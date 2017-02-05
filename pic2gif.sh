#!/bin/bash
#-----------------------------------------------------------
#         pic2gif <https://svmgrg.github.io/>
#-----------------------------------------------------------
# pic2gif is a toy program that creates a GIF of an input
# image with increasing and descreasing threshold values
# (requires 'convert' function of ImageMagick).
#-----------------------------------------------------------
# Running the program:
# For black and white gif:
# $ bash pic2gif.sh <input_image>
# For colored gif:
# $ bash pic2gif.sh <input_image> -c
#-----------------------------------------------------------
# Output is an image of the same name with extension as .gif
#-----------------------------------------------------------

# reduce the dimensions of the image to less than 400x400
WIDTH=$(identify -format '%w' $1)
HEIGHT=$(identify -format '%h' $1)
if [ $WIDTH -gt 400 ] || [ $HEIGHT -gt 400 ]; then
    convert -resize 400x400 $1 .tmp.png
else
    convert $1 .tmp.png
fi

# forward loop thresholding
for COUNTER in {000..099}
do
    if [ $# -eq 2 ] && [ $2 == '-c' ]; then
	convert .tmp.png -separate -threshold $COUNTER% -combine .temp_$COUNTER.png
    else 
	convert .tmp.png -threshold $COUNTER% .temp_$COUNTER.png
    fi
done

# backward loop thresholding
COUNTER=100
for PREV in {099..000}
do
    cp .temp_$PREV.png .temp_$COUNTER.png
    let COUNTER+=1
done

# create the gif
OUTPUT=${1%.*}
convert -delay 5 .temp_*.png $OUTPUT.gif

# remove temporary images
rm .temp_*.png
rm .tmp.png
