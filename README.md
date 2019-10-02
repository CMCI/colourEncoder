# colourEncoder
A macro for encoding object information in Intensity Values

Several ImageJ tools encode identity information in an 8-bit image. I wanted to be able to encode other information about an object into images so we can quickly and intuitively tell which are the larger objects, or the more circular, for example.

Before running the macro, users should drag the .lut files in this git into the LUT folder in their FIJI installation - these are the cividis LUT, and 4 modified versions of it. The cividis LUT is nearly identical whether an individual suffers from the most common forms of impaired colour perception or not, which is why it has been chosen for this application. Other LUTs can also be assigned using the regular methods in FIJI. 

The user should open the macro (colourEncoder_ties.ijm), and hit the "Run" button, then point the dialog at a file containing a 0-value background and solidly-coloured objects. From a long list of options, the user can choose:
- Which measurement to encode in the intensity of the image (e.g. Area, Circularity, Solidity)
- Whether this information is to be rank-coded or reflect the absolute values
- Whether the colour-coding should be scaled to fill the 255 values of the 8-bit image, or not

The macro measures all of the objects using the selected parameter, then uses the "Fill" command to replace their colour value with one determined by either their rank position for that parameter, or the absolute value of that parameter. If multiple items share the same rank for the selected stat, they are marked in the same colour. 

Caveats - The macro doesn't yet have a way to do the following:
 - Correctly/attractively/intuitively encode variance; if most of your objects are near the same value, and there are a few outliers, it would be neat to have a way to make it such that the colour assignment ignores the outliers, and returns lots of different colours.
