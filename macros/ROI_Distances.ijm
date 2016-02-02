/* 
 * Measure distances between ROIs in channels 2 to ROIs in channel 1.
 * The input is an 2D hyper-stack with ROIs already defined 
 * in the ROI Manager. The ROI have the 0000-0000-0000 name pattern.
 * 
 * Jerome Boulanger 2015
 */

macro "Distance to ROI" {
	
	if (nImages == 0) {
		createTest();
	}
	
	// Get user input
	Dialog.create("Deblur");
	Dialog.addNumber("Reference channel", 1);
	Dialog.addNumber("Object channel", 2);
	Dialog.show();
	b = Dialog.getNumber();
	a = Dialog.getNumber();
	
	setBatchMode(true);	
	ra = getRoiInChannel(a);
	rb = getRoiInChannel(b);
	D = computeRoiDistances(a, ra, b, rb);
	setBatchMode(false);
	
	// save the distance in the results table	
	for (i = 0; i  < D.length; i++) {
		roiManager("select", ra[i]);		
		setResult("ROI Index", i, ra[i]);
		setResult("ROI Name", i, Roi.getName);
		setResult("Distance", i, D[i]);
	}
	updateResults();	
}

function createTest() {
	newImage("HyperStack", "8-bit color-mode", 400, 300, 2, 1, 1);
	Stack.setChannel(1);
	setTool("oval");
	makeOval(102, 84, 136, 147);		
	roiManager("Add");
	makeOval(50, 84, 136, 147);		
	roiManager("Add");
	Stack.setChannel(2);
	makeOval(256, 43, 83, 90);
	roiManager("Add");
	makeOval(81, 64, 80, 78);
	roiManager("Add");
	makeOval(233, 186, 82, 84);
	roiManager("Add");
}

// Compute the distance for ROI in Channels a to ROI channel b
function computeRoiDistances(a, ra, b, rb) {
	
	// Compute the distance map to all ROIs in b
	computeRoiDistanceMap(rb);
	map_id = getImageID();
		
	// Move the ROI in a to b to be able to perform measurements	
	moveRoiToChannel(ra, b);
	
	// Measure the distances as the min of the distance map
	D = newArray(ra.length);
	for (i = 0; i < ra.length; i++) {
  		roiManager("select", ra[i]);
      	List.setMeasurements;
      	D[i] = List.getValue("Min");      
	}
	selectImage(map_id);
	close();
	
	// Move back the ROI the original channel	
	moveRoiToChannel(ra, a);
	return D;
}

// compute distance map for all ROI in channel c
function computeRoiDistanceMap(rois) {
	getDimensions(nx, ny, nc, nz, nt);
	newImage("HyperStack", "8-bit color-mode", nx, ny, nc, nz, nt);	
	setColor(255);
	for (i = 0; i < rois.length; i++) {
		roiManager("select", rois[i]);
		fill();
	}
	run("Convert to Mask", "method=Default background=Dark calculate");
	run("Distance Map", "slice");
}

// Move the ROIs to channel by renaming the prefix 000x-
function moveRoiToChannel(rois, channel) {	
	for (i = rois.length - 1; i >= 0; i--) {
		index = rois[i];
		roiManager("select", index);
		oname = Roi.getName;
		nname = "000" + channel + substring(oname, 4, lengthOf(oname));
		roiManager("Rename", nname);
	}
}

// Counts the number of region in a Channel c
// Assumes that the name of the ROI starts with 000c
// This is the case when using an hyper stack
function getRoiInChannel(c){
	index = newArray(0);
	for (n = 0; n < roiManager("count"); n++) {
		roiManager("select", n);	
		if (matches(Roi.getName, "000" + c + "-.*")) {
			index = arrayPushBack(index, n);
		}
	}
	return index;
}

// Push back a value in the array "a"
function arrayPushBack(a, value) {
	if (a.length == 0) {
		a = newArray(1);
		a[0] = value;
	} else {
		b = newArray(1);
		b[0] = value;
		a = Array.concat(a, b);			
	}
	return a;
}

