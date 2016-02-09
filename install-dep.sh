#!/bin/sh
ryeURL="https://raw.githubusercontent.com/adamabernathy/rye/master/get_csvcol.m"
islayURL1="https://raw.githubusercontent.com/adamabernathy/islay/master/read_text.pro"
islayURL2="https://raw.githubusercontent.com/adamabernathy/islay/master/panplot.pro"
echo "Installing Dependencies..."
cd matlab/ && { curl -O $ryeURL ; cd -; }
cd idl/ && { curl -O $islayURL1 ; cd -; }
cd idl/ && { curl -O $islayURL2 ; cd -; }
echo "Done."
