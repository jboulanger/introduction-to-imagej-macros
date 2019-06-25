// Example - Adding parameters

path = File.openDialog("file");
Dialog.create("parameters");
Dialog.addSlider("radius", 1, 5, 2);
Dialog.addSlider("area", 1, 10, 5);
Dialog.show();
radius = Dialog.getNumber();
area = Dialog.getNumber();
open(path); // Open the image

run("Duplicate...", " ");
run("Median...", "radius=" + radius);
setAutoThreshold("Otsu dark");
run("Convert to Mask"); // add this line
run("Watershed");
run("Analyze Particles...", "size=" + area + "-Infinity add");
close();
// we need to guess the window name (cf mac13.ijm)
name = baseName(path);
selectWindow(name);
roiManager("Show None");
roiManager("Show All");
roiManager("Measure");


// return the base name of a path (remove folder)
function baseName(path) {
	N =  lastIndexOf(path, File.separator);
	return substring(path, N + 1, lengthOf(path)) ;
}