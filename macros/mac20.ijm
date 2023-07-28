//@Integer(label="radius") radius
//@String(label="Threshold", choices={"Default","Otsu"}) threshold

// Example - Using image identifier

// Segment the cell and add regions to ROI manager
function segmentBlobs(radius, threshold) {
	run("Duplicate...", " ");
	run("Median...", "radius=" + radius);
	run("Auto Threshold", "method=" + threshold);
	run("Watershed");
	run("Analyze Particles...", "add");
	close();
}

segmentBlobs(radius, threshold);
