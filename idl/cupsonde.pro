
;------------------------------------------------------------------------------;
; Environmental Instrumentation - ATMOS 6050                                   ;
; Cupsonde Data Retrieval                                                      ;
;                                                                              ;
; (C) 2016 Adam C. Abernathy, adamabernathy@gmail.com                          ;
; All rights reserved.                                                         ;
;                                                                              ;
; Dependencies                                                                 ;
; ------------                                                                 ;
; Islay IDL Library : https://github.com/adamabernathy/islay                   ;
;                                                                              ;
; History                                                                      ;
; -------                                                                      ;
; v0.0.1 - Initial Release, February 10, 2016                                  ;
;                                                                              ;
;------------------------------------------------------------------------------;

pro cupsonde
    compile_opt idl2

    ; Set user options
    run_retrievals = 'yes'
    do_temp_height = 'yes'


    ; Read in parsed data file.
    F         = '../1430258910-example.csv'
    granule   = read_text(F)
    nprofiles = n_elements(granule[1,*])
    print, string(nprofiles, format='(I4)') + ' profiles loaded'

    ;
    ; Granule Summary
    ;
    ; Loc   Description     Type        Units
    ; ------------------------------------------------------------------
    ;  0    IDX             INT         none
    ;  1    UNIX-TIME       LONG INT    UNIX UTC timestamp
    ;  2    SYS-NSAT        INT         none
    ;  3    SYS-VOLT        FLOAT       Volts
    ;  4    GEO-LAT         DOUBLE      Degrees North
    ;  5    GEO-LON         DOUBLE      Degrees East
    ;  6    GEO-ELEV        DOUBLE      Meters
    ;  7    GEO-ANG         DOUBLE      Degrees North
    ;  8    DAT-SPD         FLOAT       meters / sec
    ;  9    DAT-TMPC        FLOAT       Celcius
    ; 10    DAT-RH          FLOAT       ratio of e/es
    ; 11    DAT-PRES        FLOAT       Pacals
    ; ------------------------------------------------------------------
    ;

    ; Data is loaded in, now break the granule array apart
    unix_time =   long( granule[1, *] )
    sys_sats  =    fix( granule[2, *] )
    sys_volt  =  float( granule[3, *] )
    geo_lat   = double( granule[4, *] ) * 1e-6
    geo_lon   = double( granule[5, *] ) * 1e-6
    geo_alt   = double( granule[6, *] )
    geo_ang   = double( granule[7, *] )
    dat_spd   =  float( granule[8, *] )
    dat_temp  =  float( granule[9, *] )
    dat_rh    =  float( granule[10, *] )
    dat_press =  float( granule[11, *] )

    ; Free up memory
    granule = ''

    ;
    ; Signifcant indicies
    ;

    ; Locate the 'base' alt by searching for the first positive alt in the data
    for i = 0, nprofiles - 1 do begin
        if geo_alt[i] gt 0 then begin
            base_alt     = geo_alt[i]
            base_alt_idx = i
            i = nprofiles ; escape
        endif
    endfor

    ; Peak alt
    peak_alt = max(geo_alt)
    for i = 0, nprofiles - 1 do begin
        if geo_alt[i] eq peak_alt then begin
            peak_alt_idx = i
            i = nprofiles ; escape
        endif
    endfor


    ;
    ; Data retrievals
    ;
    if run_retrievals eq 'yes' then begin
        ret_dewpoint = fltarr(nprofiles)
        for i = 0, nprofiles - 1 do begin
            if dat_rh[i] ne 0 then begin
                ret_dewpoint[i] = retDewPoint(dat_temp[i], dat_rh[i])
            endif
        endfor
    endif


    ;---------------------------------------------------------------------------
    ; Plot Height as a function of time
    ;---------------------------------------------------------------------------
    if do_temp_height eq 'yes' then begin

        time_offset = indgen(n_elements(unix_time))
        p1  = plot(time_offset, geo_alt, /nodata, $
            yrange=[base_alt, max(geo_alt)], /ystyle, $
            title='Time vs. Height', $
            xtitle='Time',       $
            ytitle='Height [m]')
        p1a = plot(time_offset[base_alt_idx:peak_alt_idx], $
            geo_alt[base_alt_idx:peak_alt_idx],  /overplot, $
            color='red', thick=2)
        p1a = plot(time_offset[peak_alt_idx:-1], $
            geo_alt[peak_alt_idx:-1],  /overplot, $
            color='blue', thick=2)
    endif

end


;
; Dewpoint Retrieval
;
function retDewPoint, temperature, rh
    compile_opt idl2

    ; http://www.srh.noaa.gov/images/epz/wxcalc/vaporPressure.pdf
    ; http://www.srh.noaa.gov/images/epz/wxcalc/wetBulbTdFromRh.pdf
    ; http://andrew.rsmas.miami.edu/bmcnoldy/humidity_conversions.pdf
    ;
    ; Alduchov, O. A., and R. E. Eskridge, 1996: Improved Magnus' form
    ;   approximation of saturation vapor pressure. J. Appl. Meteor.,
    ;   35, 601–609.
    ; August, E. F., 1828: Ueber die Berechnung der Expansivkraft des
    ;   Wasserdunstes. Ann. Phys. Chem., 13, 122–137.

    a  = 17.625
    b  = 243.04
    rh = rh / 100.0

    Td = b * ( alog(rh)+((a * temperature) / (b + temperature)) ) / $
             ( a - alog(rh) - ( (a * temperature) / (b + temperature) ) )

    return, Td
end
