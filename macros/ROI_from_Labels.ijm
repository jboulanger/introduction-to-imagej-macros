/*
 * ROI from Labels
 * 
 * Convert a image with labels to ROIs 
 * 
 * Jerome Boulanger 2019
 */
 
macro "ROI from Labels" {
	
	if (nImages==0) {
		run("Blobs (25K)");
		run("Median...", "radius=5");
		run("Multiply...", "value="+(4/255));
		run("Enhance Contrast", "saturated=0.0");
	}
	
	labelImageToRoi();
}

// Convert the levels of an image into ROIs
function labelImageToRoi() {	
	run("16-bit");
	getStatistics(area, mean, min, max, std, histogram);
	print(max);
	getHistogram(values, counts, max-min+1, min, max);
	for (i = 1; i < counts.length; i++) {
		if ( counts[i] != 0 ) {
			run("Select None");
			run("Duplicate...", " ");
			id = getImageID();
			setThreshold(values[i], values[i]);
			run("Convert to Mask");
			run("Create Selection");
			roiManager("add");
			selectImage(id); close();
		}
	}
	roiManager("show all");
}

