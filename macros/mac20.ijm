// Example - Using image identifier

segmentCell(3, 5);

// Segement the cell and add regions to ROI manager
function segmentCell(radius, area) {
	id = getImageID();
	run("Duplicate...", " ");
	run("Median...", "radius=" + radius);
	run("Auto Threshold", "method=MaxEntropy white");
	run("Convert to Mask"); // add this line
	run("Watershed");
	run("Analyze Particles...",
	  	"size=" + area + "-Infinity add");
	close();
	selectImage(id); // use image ID to set the focus back
}
