// Example - Adding parameters

filename = File.openDialog("file");
Dialog.create("parameters");
Dialog.addSlider("radius", 1, 5, 2);
Dialog.addSlider("area", 1, 10, 5);
Dialog.show();
radius = Dialog.getNumber();
area = Dialog.getNumber();
open(filename); // Open the image

run("Duplicate...", " ");
run("Median...", "radius=" + radius);
run("Auto Threshold", "method=MaxEntropy white");
run("Convert to Mask"); // add this line
run("Watershed");
run("Analyze Particles...", "size=" + area + "-Infinity add");
close();
// we need to guess the window name
name = substring(filename, lastIndexOf(filename, "/") + 1, lengthOf(filename));
selectWindow(name);
roiManager("Show None");
roiManager("Show All");
roiManager("Measure");
