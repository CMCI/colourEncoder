/* The purpose of this scrpt is to colour objects based on their rank position in a list
 *  e.g. 1st object in a list is coloured 1, second is coloured 2, but the order of the list is determined by
 *  a parameter such as size, circularity, or some other factor
 */

open(); //open a Binary image

run("Set Measurements...", "area mean centroid fit shape integrated skewness kurtosis area_fraction redirect=None decimal=3");
getPixelSize(unit, pixelWidth, pixelHeight);
run("Set Scale...", "distance=0"); //this is so that the AREA matches the rawIntDen for lines 59 and 77
//If you remove this line, the macro assumes everything has holes in it. It might slow down?
setThreshold(1, 65335); //in case you have 16-bit images
run("Convert to Mask"); //make everything >0 into a white pixel
run("Analyze Particles...", "size=0.0-Infinity display clear add"); //analyse all particles and add them to ROIManager

//LUT inversion drives me to distraction with how it interacts with setPixel or Fill
inLUT = is("Inverting LUT"); //if the LUT is inverted, revert it back to its proper values
if (inLUT == true){
	run("Invert LUT");
}

iCount = roiManager("Count"); //how many objects are there?

//The following lines set up the dialogue box for establishing parameters of mapping
//here's an array that lists all the measurements as strings, verbatim
measurementType=newArray("Area","Mean","X","Y","Major","Minor","Angle","Circ.","IntDen","Skew","Kurt","%Area","RawIntDen","AR","Round","Solidity");
sortType = newArray("Rank", "Value");
scaleType = newArray("Yes", "No");
Dialog.create("Options");
Dialog.addChoice("Choose the measurement to encode: ",measurementType,"Area");
Dialog.addChoice("Colour by Rank or by Value: ",sortType,"Rank");
Dialog.addChoice("Scale data to fill LUT?: ",scaleType,"Yes");
Dialog.show();
resultColumn = Dialog.getChoice();
ranked = Dialog.getChoice();
scaled = Dialog.getChoice();
scale = 1;


resultList = newArray(); //make an array containing all the statistics derived from the roi
for (item = 0; item<iCount; item++){
	resultList = Array.concat(resultList,getResult(resultColumn, item));
}

// Derive a multiplier to determine the brightness of the Max mapped intensity
if (scaled == "Yes" && ranked == "Rank"){
	scale = 255/iCount;
}
if (scaled == "Yes" && ranked == "Value"){
	Array.getStatistics(resultList, min, max, mean, stdDev);
	scale = 255/max;	
}



if (ranked == "Rank"){ //if the data is being mapped by rank
	rankList = Array.rankPositions(resultList); //rank the data
	for (item = 0; item<iCount; item++){ //for every item
		//does it have holes in it?
		holecheck = 0; //No
		roiManager("select",rankList[item]);
		if (getResult("RawIntDen",rankList[item])!=getResult("Area",rankList[item])){
			holecheck = 1; //Yes
		}
		
		pxColour = (item+1)*scale; //define the pixel intensity to draw
		setForegroundColor(pxColour,pxColour,pxColour);
		if (holecheck == 0){ //if there's no holes
			roiManager("fill"); //fill the item
		} else { //otherwise
			avoidHoles(pxColour); // fill the non-black pixels in the ROI
		}
	}
}else{ //if the data  is NOT being mapped by rank
	for (item = 0; item<iCount; item++){ //for each ROI

		//does it have holes?
		holecheck = 0; 
		roiManager("select",item);
		if (getResult("RawIntDen",item)!=getResult("Area",item)){
			holecheck = 1;
		}
		
		pxColour = (resultList[item])*scale; //define the pixel intensity to be drawn
		setForegroundColor(pxColour,pxColour,pxColour);
		if (holecheck == 0){ //if there's no holes
			roiManager("fill"); //fill it
		} else { //otherwise
			avoidHoles(pxColour); //fill non-black pixels in the ROI
		}
	}
}

run("Set Scale...", "distance=1 known="+pixelWidth+" unit=µm"); //this just resets pixel size

function avoidHoles(pxColour){ // this checks if a pixel is within a selection, and if it's not black, fills it in
//needs an image with an area selection
	getSelectionBounds(x0, y0, width, height);
	for (y=y0; y<y0+height; y++)
  		for (x=x0; x<x0+width; x++) {
   	 		if (selectionContains(x, y)){
   		 		if (getPixel(x,y)!=0){
    				setPixel(x,y,pxColour);
    			}
  			}
		}
}