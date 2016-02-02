// Example - Loop over ROIs

// Loop over ROI and print their type
for (n = 0; n < roiManager("count"); n++) {
 	roiManager("select", n);
 	print("roi #" + n + " is a " + Roi.getType);
}