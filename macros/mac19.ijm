//@File(label="input") path
//@Integer(label="radius") radius
//@String(label="Threshold", choices={"Default","Otsu"}) threshold

open(path);
run("Duplicate...", " ");
run("Median...", "radius=" + radius);
run("Auto Threshold", "method=" + threshold);
run("Watershed");
run("Analyze Particles...", "add");
close();
run("Set Measurements...", "area mean redirect=None decimal=9");
roiManager("Measure");