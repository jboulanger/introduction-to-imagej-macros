// Example - Using the Macro recorder

run("Blobs (25K)");
run("Duplicate...", " ");
run("Median...", "radius=2");
run("Auto Threshold", "method=Default");
run("Watershed");
run("Analyze Particles...", "add");
close();
run("Set Measurements...", "area mean redirect=None decimal=9");
roiManager("Measure");