/*
 * Segment a single cell in the field of view 
 * and measure the speed and total distance across frames
 * of the center of masse.
 * 
 * It assumes there is only one cell to track.
 * 
 * Jerome Boulanger - 2016
 */
macro "Track Cell" {
	// Get the main parameters from the user
	Dialog.create("centroid displacement");
	Dialog.addNumber("Smoothing (1-10):", 2);
	Dialog.addNumber("Threshold (3-10):", 6);
	Dialog.addNumber("Min area  ( > 0):", 50);
	Dialog.show();
	smoothing = Dialog.getNumber();
	quantile = Dialog.getNumber();
	min_area = Dialog.getNumber();
	// Close the ROI manager if opened
	closeRoiManager();
	setBatchMode(true);	
	// convert the stack to an hyperstack
	run("Stack to Hyperstack...", "order=xyczt(default) channels=1 slices=1 frames="+nSlices+" display=Color");
	run("Set Measurements...", "  redirect=None decimal=3");
	run("Select None");
	// segment the cell all the frames	
	segmentCellEveryFrame(smoothing, quantile, min_area);
	// Measure speed of the center of masse as an array
	a = getCenterOfMass(0);
	// Save a first line with speed and distance 0	
	saveResults(0, a, 0, 0);
	// Clean all previous overlays
	Overlay.remove;	
	// Add the first segmentation
	addOverlay(0, a, a, 0, 0);
	// initalize the distance to 0
	d = 0;
	for (i = 1; i < roiManager("count"); i++) {		
		// Compute the new center of masse for ROI i
		b = getCenterOfMass(i);
		// Compute the speed
		v = computeSpeed(a, b);
		// Update the total distance
		d = d + v;
		// Add the segmentation as overlay + center of masse
		addOverlay(i, a, b, v, d);
		// Save the new results
		saveResults(i, b, v, d);
		// Leap frog a and b
		a[0] = b[0];
		a[1] = b[1];
	}
	// Update the table
	updateResults();
	// Make sure the created overlays are visible
	Overlay.show();
	// unselect the last ROI
	run("Select None");
	setBatchMode(false);
}

// Add overlays to the frame i+1 using center masse a and b of ROI i
function addOverlay(i,a,b,v,d) {
	setLineWidth(1);
	// Set the color to a kind of butterish yellow
	setColor("#fce94f");
	// draw the line between two points
	Overlay.drawLine(a[0], a[1], b[0], b[1]);
	// update the display to take into accunt color changes
	Overlay.show();
	// add the outline of the segmented region
    run("Add Selection...", "stroke=#ef2929 width=2");
	// set its position to frame i+1    
    Overlay.setPosition(i+1);
    // set a line with of 5 pixel
    setLineWidth(5);
    // change the color to a bright green
	setColor("#8ae234");
	// draw ab ellipse at the second center of masse (b)
	Overlay.drawEllipse(b[0]-2, b[1]-2, 4, 4);
	// set its position to frame i+1
	Overlay.setPosition(i+1);	
	// update the display
	Overlay.show();
	// add text annotation
	font_size = 9;
	m = 5;
	setFont("Monospaced", font_size);
	setColor("#ecf0eb");
	Overlay.drawString("Frame    [" + i + "]", m, m+font_size + 1);
	Overlay.setPosition(i+1);
	Overlay.drawString("Position [" + d2s(b[0], 1) + ", " + d2s(b[1],1) + "]", m, m+2*(font_size+1));
	Overlay.setPosition(i+1);
	Overlay.drawString("Speed    [" + d2s(v,1) + "]", m, m+3*(font_size+1));
	Overlay.setPosition(i+1);
	Overlay.drawString("Distance [" + d2s(d,1) + "]", m, m+4*(font_size+1));
	Overlay.setPosition(i+1);
}

// Compute the center of masse at frame i+1 of ROI i (return an array [x,y])
function getCenterOfMass(i) {
	Stack.setFrame(i+1);
	roiManager("select", i);
	List.setMeasurements;
	c = newArray(2);
	c[0] = List.getValue("XM");
	c[1] = List.getValue("YM");		
	return c;
}

// Save the results for ROI i, center of masse c, speed v and distance d
function saveResults(i, c, v, d) {
	setResult("x", i, c[0]);
	setResult("y", i, c[1]);
	setResult("Speed", i, v);
	setResult("Distance", i, d);
}

// Compute the speed between two centers of masse (arrays a and b)
function computeSpeed(a, b) {
	dx = b[0] - a[0];
	dy = b[1] - a[1];
	return sqrt(dx*dx+dy*dy);
}

// Segment the Cell on every Frame
function segmentCellEveryFrame(smoothing, quantile, min_area) {
	Stack.getDimensions(width, height, channels, slices, frames);	
	for (t = 1; t <= frames; t++) {
		Stack.setFrame(t);
		segmentCell(2, 6, 50);				
	}
	// set the Roi at the right frame by changing their name
	//for (i = 0; i < roiManager("count"); i++) {
	//	roiManager("select", i);	
	//	roiManager("Rename", IJ.pad(i+1,4)+"-"+Roi.getName);
	//}		
}

// Segment the cell using a median filter + a threshold and a minimal area
function segmentCell(smoothing, quantile, min_area) {	
	id = getImageID();
	run("Duplicate...", "title=mask");	
	run("Median...", "radius=" + smoothing);
	threshold = computeThreshold(quantile);
	getStatistics(area, mean, min, max);
	setThreshold(threshold, max);	
	run("Convert to Mask");
	run("Analyze Particles...", "size=" + min_area + "-Infinity add");
	selectWindow("mask");
	close();
	selectImage(id);
}

// Close the ROI manager if it is open
function closeRoiManager() {
	if (isOpen("ROI Manager")) {
		selectWindow("ROI Manager");
		run("Close");
	}	
}

// Compute a threshold from a quantile on robust statistics
function computeThreshold(quantile) {	
	A = image2Array();
	return med(A) + quantile * mad(A);
}

// Convert a 2D image to a 1D array
function image2Array() {
	A = newArray(getWidth * getHeight);
	for (y = 0; y < getHeight; y++) {
		for (x = 0; x < getWidth; x++) {
			i = x + getWidth * y;
			A[i] = getPixel(x, y);
		}
	}
	return A;
}

// Median of the array A
function med(array) {
	A = Array.copy(array);
	Array.sort(A);
	i = round((A.length - 1)/2);
	return A[i];
}

// Median of Absolute Deviation (estimate of the standard deviation)
function mad(array) {
	m = med(array);
	A = Array.copy(array);
	for (i = 0; i < A.length; i++) {
		A[i] = abs(A[i] - m);
	}	
	return med(A);
}
