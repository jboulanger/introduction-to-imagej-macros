// Example - Using the Macro recorder

run("Blobs (25K)");
run("Duplicate...", " ");
run("Median...", "radius=2");
setAutoThreshold("Otsu");
run("Convert to Mask"); 
run("Watershed");
run("Analyze Particles...", "size=5-Infinity add");
close();
selectWindow("blobs.gif");
roiManager("Show None");
roiManager("Show All");
roiManager("Measure");
