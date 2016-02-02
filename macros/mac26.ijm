// Examples - Measurements

for (i = 0; i < roiManager("count"); i++) {
	roiManager("select", i);
	List.setMeasurements;
	contrast = List.getValue("Max") - List.getValue("Min");
	setResult("Type", i, Roi.getType);
	setResult("Contrast", i, contrast);
	setResult("Centroid-X", i, List.getValue("X"));
	setResult("Centroid-Y", i, List.getValue("Y"));
}
updateResults();