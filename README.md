# colourEncoder
A macro for encoding object information in Intensity Values

Several ImageJ tools encode identity information in an 8-bit image. I wanted to be able to encode other information about an object into images so we can quickly and intuitively tell which are the larger objects, o the more circular, for example.

The user should open the macro, and hit the "Run" button, then point the dialog at a file containing a 0-value background and solidly-coloured objects. From a long list of options, the user can choose:
- Which measurement to encode in the intensity of the image (e.g. Area, Circularity, Solidity)
- Whether this information is to be rank-coded or reflect the absolute values
- Whether the colour-coding should be scaled to fill the 255 values of the 8-bit image, or not

The macro measures all of the objects using the selected parameter, then uses the "Fill" command to replace their colour value with one determined by either their rank position for that parameter, or the absolute value of that parameter.

Caveats - I wrote this in about 30 mins. It doesn't yet have a way to do the following:
 - Deal with holes in objects (the ROI Manager basically ignores holes)
 - Deal with multiple objects with the same rank
 - Correctly/attractively/intuitively encode variance; if most of your objects are near the same value, and there are a few outliers, it would be neat to have a way to make it such that the colour assignment ignores the outliers, and returns lots of 
