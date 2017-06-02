#!/bin/bash

# Extract pages
for file in `ls *.pdf | grep -v extracted | grep -v combined`; 
do 
#pdftk ${file} cat 1-4 output "${file%.pdf}-extracted.pdf"
numPages=$(pdftk ${file} dump_data | grep NumberOfPages | cut -d' ' -f2)
pdftk ${file} cat 1-${numPages} output "${file%.pdf}-extracted.pdf"
done

# Combine them
pdftk *-extracted.pdf cat output combined3.pdf

# remove the extracted stuff
ls *-extracted.pdf | xargs -I{} rm {}

# Extract the text
rm Extracted_text3.txt
numPages=$(pdftk combined3.pdf dump_data | grep NumberOfPages | cut -d' ' -f2)
seq 0 "$(($numPages+1))" | parallel -k -I{} 'convert -monochrome -density 800 combined3.pdf\[{}\] /dev/fd/1 | tesseract stdin stdout' >> Extracted_text3.txt

