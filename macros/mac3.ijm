// Example - Using the Macro recorder

run("Blobs (25K)");
run("Duplicate...", " ");
run("Median...", "radius=2");
run("Auto Threshold", "method=MaxEntropy white");
run("Watershed");
run("Analyze Particles...", "size=5-Infinity add");
close();
selectWindow("blobs.gif");
roiManager("Show None");
roiManager("Show All");
roiManager("Measure");
