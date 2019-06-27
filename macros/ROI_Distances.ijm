/* 
 *  ROI Distances
 *  
 * Measure distances between ROIs in channels 2 to ROIs in channel 1.
 * The input is an 2D hyper-stack with ROIs already defined 
 * in the ROI Manager. The ROI have the 0000-0000-0000 name pattern.
 * 
 * Jerome Boulanger 2015 - 2019
 */

macro "ROI Distances" {		
	if (nImages == 0) {
		test();		
	} else {	
		// Get user input
		Dialog.create("ROI Distance");
		Dialog.addNumber("Reference channel", 1);
		Dialog.addNumber("Object channel", 2);
		Dialog.show();
		a = Dialog.getNumber();
		b = Dialog.getNumber();
		
		setBatchMode(true);	
		ra = getRoiInChannel(a);
		rb = getRoiInChannel(b);
		D = computeRoiDistances(ra, rb);
		setBatchMode(false);		
		// save the distance in the results table	
		for (i = 0; i  < D.length; i++) {
			roiManager("select", rb[i]);		
			setResult("ROI Index", i, rb[i]);
			setResult("ROI Name", i, Roi.getName);
			setResult("Distance", i, D[i]);
		}
		updateResults();
	}
}

function test() {
	print("Testing mode");
	//close windows
	wins = newArray("ROI Manager","Results");
	for (i = 0; i<wins.length;i++) {
		if (isOpen(wins[i])) {
			selectWindow(wins[i]);
			run("Close");
		}
	}
	// create the test example rois
	newImage("Test Image", "8-bit color-mode", 400, 300, 2, 1, 1);
	Stack.setChannel(1);	
	setTool("oval");
	makeOval(102, 84, 136, 147);
	Roi.setStrokeColor("red");
	roiManager("Add");
	makeOval(50, 84, 136, 147);
	Roi.setStrokeColor("red");
	roiManager("Add");
	Stack.setChannel(2);	
	makeOval(256, 43, 83, 90);
	Roi.setStrokeColor("green");
	roiManager("Add");
	makeOval(81, 64, 80, 78);
	Roi.setStrokeColor("green");
	roiManager("Add");
	makeOval(233, 186, 82, 84);
	Roi.setStrokeColor("green");	
	roiManager("Add");
	roiManager("Show all");	
	// compute distances 
	setBatchMode(true);	
	ra = getRoiInChannel(1);
	rb = getRoiInChannel(2);
	D = computeRoiDistances(ra, rb);
	setBatchMode(false);
	// save the distance in the results table	
	for (i = 0; i  < D.length; i++) {
		roiManager("select", rb[i]);		
		setResult("ROI Index", i, rb[i]);
		setResult("ROI Name", i, Roi.getName);
		setResult("Distance", i, D[i]);
	}
	updateResults();
	if (D[0]==34 && D[1] == 0 && D[2]==15) {
		print("Test ok");
	} else {
		print("Test failed (incorrect distances)");
	}
}

// Compute the distance for ROI in Channels a to ROI channel b
function computeRoiDistances(ra, rb) {
	
	// Compute the distance map to all ROIs in b
	map_id = computeRoiDistanceMap(ra);	
	
	// Measure the distances as the min of the distance map
	D = newArray(rb.length);
	for (i = 0; i < rb.length; i++) {		
  		roiManager("select", rb[i]);  		
      	List.setMeasurements;
      	D[i] = List.getValue("Min");      
	}
	selectImage(map_id);
	close();
	
	return D;
}

// compute distance map for all ROI in channel c
function computeRoiDistanceMap(rois) {
	getDimensions(nx, ny, nc, nz, nt);
	newImage("Distance map", "32-bit color-mode", nx, ny, 1, nz, nt);	
	setColor(128);
	for (i = 0; i < rois.length; i++) {
		roiManager("select", rois[i]);
		fill();
	}
	setThreshold(0, 10);
	run("Convert to Mask", "method=Default background=Dark black");
	run("Distance Map", "slice");
	return getImageID();
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

