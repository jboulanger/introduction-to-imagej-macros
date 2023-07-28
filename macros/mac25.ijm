// Example - Loop over ROIs

// Loop over ROI and print their type
for (i = 0; i < roiManager("count"); i++) {
 	roiManager("select", i);
 	print("roi #" + i + " is a " + Roi.getType);
}