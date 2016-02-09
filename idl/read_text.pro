;-----------------------------------------------------------------------
;
; read_text()
;
; Reads a variable from a test based data file and returns the values.
; Dynamically Loads data from a text file, returns as a STRING
; array. Once the array is returned, you can convert the data
; type to whatever you wish.
;
; Usage: result = read_text('filename.txt', [/version, /versbose])
;
; Arguments
; ---------
; delim       - column separator
; header_char - file's comment character
;
; Notes
; -----
; [1] If you do not set a 'delim' or 'header_char' then the
;     default will be ',' and '#' respectively.
;
; [2] For a 'tab' separator, use delim='string(11B)'
;
; History
; -------
; Oct 26, 2015 - v1.0.0, (Early) Initial release
; Dec  2, 2015 - v1.1.0, (Stable)
;
;
; The fine print (MIT License)
; ----------------------------
; Copyright (c) 2015 Adam C. Abernathy
;
; Permission is hereby granted, free of charge, to any person obtaining
; a copy of this software and associated documentation files
; (the "Software"), to deal in the Software without restriction,
; including without limitation the rights to use, copy, modify, merge,
; publish, distribute, sublicense, and/or sell copies of the Software,
; and to permit persons to whom the Software is furnished to do so,
; subject to the following conditions:
;
; The above copyright notice and this permission notice shall be
; included in all copies or substantial portions of the Software.
;
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
; MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
; NONINFRINGEMENT.  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
; BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
; ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
; CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
; THE SOFTWARE.
;-----------------------------------------------------------------------

function read_text, f, $
                    delim       = delim, $
                    header_char = header_char, $
                    version     = show_version, $
                    verbose     = err_mode

compile_opt idl2,HIDDEN
!except = 2 ; diagnostic

code_version = '1.0.0'


; Determine option flags
if not keyword_set(err_mode) then err_mode = 0 ; NO
if keyword_set(show_version) then begin
    return, code_version
endif

if not keyword_set(run_mode) then begin
    run_mode = 1
endif else begin
    run_mode = 0
endelse

if not keyword_set(delim) then delim = ','
if not keyword_set(header_char) then header_char = '#'


; Establish error handler
catch, error_status
if error_status ne 0 then begin
    ;print, 'error index: ', error_status
    if err_mode eq 0 then return, 'ERROR' else $
        return, !error_state.msg
    catch, /cancel
endif


; Open and read in the text file
openr, lun, f, /get_lun

text_array = ''
text_line  = ''

while not eof(lun) do begin
    readf, lun, text_line
    text_array = [text_array,text_line]
endwhile

free_lun, lun

;-----------------------------------------------------------------------
; Extract and process data in the text_array string ...
;
; We are loading all the data in as a string, then exporting
; the complete data object to the user, allowing them to decide
; what the data type should be.
;-----------------------------------------------------------------------

n_lines = n_elements(text_array) ; no. of lines of data

; Find the header chars
r  = where(strmid(text_array,0,1) eq header_char)
rr = where(strmid(text_array,0,1) eq '')

start_idx = max([r, rr])

; Catch the extra return at the end of the file (if one is there)
if start_idx lt n_lines - 1 then begin
    start_idx = start_idx + 1
endif else begin
    start_idx = max(r) + 1
endelse


; Now figure out how many cols are in the text file. This is useful
; for diagnostics and later functionality to the routine.
r = text_array[start_idx+1]     ; get the first line of the text-array
q = strsplit(r, delim,/extract) ; break the line apart
n_cols = n_elements(q)          ; no. of columns

data = make_array(n_lines-start_idx, n_cols, /string)

;-----------------------------------------------------------------------
; Using a stacked loop to process cols then lines of data. First we
; will extract the strings parts as noted by the 'delim' then
; write those to the 'output_array'
;-----------------------------------------------------------------------
for i = 0, n_lines - start_idx - 1 do begin
    s = strsplit(text_array[i+start_idx], delim, /extract)

    for ii = 0, n_cols - 1 do begin
        data[i, ii] = s[ii]
    endfor ; [ii]

endfor ; [i]

return, transpose(data)


end ; All done!
