function [B, C] = get_csvcol(f, header,col)
%get_csvcol returns a column of data from a csv file.
%
% f      :: Path of source file
% header :: No. of header lines in the input file
% col    :: Column you want to extract
%
% get_csv & get_csvcol are n = 0 based routines.
% 
% v1.0.0, Tested in Matlab 2012b.
%
% (C) 2014 Adam Abernathy, adamabernathy@gmail.com
%
% Permission is hereby granted, free of charge, to any person obtaining 
% a copy of this software and associated documentation files 
% (the "Software"), to deal in the Software without restriction, 
% including without limitation the rights to use, copy, modify, merge, 
% publish, distribute, sublicense, and/or sell copies of the Software, 
% and to permit persons to whom the Software is furnished to do so, 
% subject to the following conditions:
%
% The above copyright notice and this permission notice shall be 
% included in all copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
% EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
% MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
% IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
% CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
% TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
% SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%

% Find number of lines in the file.
fid = fopen(f, 'rb');
n = 0;

while ischar(fgets(fid))
    n = n + 1;
end

fclose(fid);

%  Load data from file.
R = [header, col, n - 1, col];
B = csvread(f, header, col, R);
C = length(B);

end % All done!
