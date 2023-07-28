/*
 * ROI Distances
 *
 * Compute the distance between two set of ROIs
 *
 * Jerome Boulanger 2015-2023
 */

run("Close All");

if (nImages == 0) {
	test();
}

function test() {
	/* Generate a test example */
	newImage("test", "8-bit", 500, 500, 1);
	if (isOpen("ROI Manager")) {selectWindow("ROI Manager"); run("Close");}
	big_id = generateRandomCircles(2,200,300,"blue");
	small_id = generateRandomCircles(10,30,60,"red");
	distances = computeDistances(small_id, big_id);
	Array.show(small_id, distances);
	roiManager("Show All");
	run("Select None");
}

function computeDistances(rois1, rois2) {
	/* Compute the distances from rois1 to rois2 */
	edm = computeEDM(rois2);
	distances = measureROIsStatistics(rois1, "Min");
	return distances;
}

function computeEDM(rois) {
	/* Return a distance map to the list of ROIs */
	getDimensions(width, height, channels, slices, frames);
	newImage("mask", "8-bit white", width, height, 1);
	roiManager("select", rois);
	roiManager("combine");
	setColor(0);
	fill();
	mask = getImageID();
	run("Options...", "iterations=1 count=1 black edm=32-bit");
	run("Distance Map");
	edm = getImageID();
	selectImage(mask);
	close();
	return edm;
}

function measureROIsStatistics(rois, statistic) {
	/* Return the `getValue(statistics)` for each ROIs */
	values = newArray(rois.length);
	for (i = 0; i < values.length; i++) {
		roiManager("select", rois[i]);
		values[i] = getValue(statistic);
	}
	return values;
}

function generateRandomCircles(number, min_size, max_size, color) {
	/* Generate random circles in the image  */
	getDimensions(width, height, channels, slices, frames);
	ids = newArray(number);
	for (i = 0; i < number; i++) {
		d = min_size + random * (max_size - min_size);
		x = random * (width - d);
		y = random * (height - d);
		makeOval(x,y,d,d);
		Roi.setStrokeColor(color);
		roiManager("add");
		ids[i] = roiManager("count") - 1;
	}
	return ids;
}