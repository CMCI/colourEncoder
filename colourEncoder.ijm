/* The purpose of this scrpt is to colour objects based on their rank position in a list
 *  e.g. 1st object in a list is coloured 1, second is coloured 2, but the order of the list is determined by
 *  a parameter such as size, circularity, or some other factor
 */

open(); //open a Binary image

run("Set Measurements...", "area mean centroid fit shape skewness kurtosis area_fraction redirect=None decimal=3");
setThreshold(1, 65335);
run("Convert to Mask");
run("Analyze Particles...", "size=0.0-Infinity display clear add");
inLUT = is("Inverting LUT");
if (inLUT == true){
	run("Invert LUT");
}
iCount = roiManager("Count");
measurementType=newArray("Area","Mean","X","Y","Major","Minor","Angle","Circ.","Skew","Kurt","%Area","AR","Round","Solidity");
sortType = newArray("Rank", "Value");
scaleType = newArray("Yes", "No");
Dialog.create("Options");
Dialog.addChoice("Choose the measurement to encode: ",measurementType,"Area");
Dialog.addChoice("Colour by Rank or by Value: ",sortType,"Rank");
Dialog.addChoice("Scale data to fill LUT?: ",scaleType,"Yes");
//Dialog.addCheckboxGroup(1, 2, newArray("Ranked","Absolute"), ranked);
//Dialog.addCheckbox(1, 2, newArray("Scaled","Raw"), scaled);
Dialog.show();
resultColumn = Dialog.getChoice();
ranked = Dialog.getChoice();
//absolute = Dialog.getChoice();
scaled = Dialog.getChoice();
//raw = Dialog.getChoice();
scale = 1;

resultList = newArray();

for (item = 0; item<iCount; item++){
	resultList = Array.concat(resultList,getResult(resultColumn, item));
}

if (scaled == "Yes" && ranked == "Rank"){
	scale = 255/iCount;
}
if (scaled == "Yes" && ranked == "Value"){
	Array.getStatistics(resultList, min, max, mean, stdDev);
	scale = 255/max;
	
}



if (ranked == "Rank"){
	rankList = Array.rankPositions(resultList);
	for (item = 0; item<iCount; item++){
		roiManager("select",rankList[item]);
		setForegroundColor((item+1)*scale,(item+1)*scale,(item+1)*scale);
		roiManager("fill");
	}
} else{
	for (item = 0; item<iCount; item++){
		roiManager("select",item);
		setForegroundColor((resultList[item])*scale,(resultList[item])*scale,(resultList[item])*scale);
		roiManager("fill");
	}
}
