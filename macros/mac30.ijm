//@File (label="Input file") filename

// Example -Tables

function processFile(){
	/*Open file, threshold and add ROI to manager*/
	open(filename);
	run("Auto Threshold", "method=Otsu white");	
	run("Analyze Particles...", "clear add");
	roiManager("Show All without labels");
}

function createTable(name) {
	/*Create a table is not opened and return the number of rows*/
	if (!isOpen(name)) { Table.create(name); }
	selectWindow(name);
	return Table.size;
}

processFile();

row = createTable("Measurements by object");

for ( i = 0; i < roiManager("count"); i++) {
	roiManager("select", i);
	Table.set("ID", row + i, i + 1);
	Table.set("Mean Intensity", row + i, getValue("Mean"));
}
Table.update;

// Compute summary statistics for the mean intensity column
values = Table.getColumn("Mean Intensity");
Array.getStatistics(values, values_min, values_max, values_mean, values_std);

row = createTable("Measurements by image");
Table.set("Image Name", row, getTitle());
Table.set("Object count", row, roiManager("count"));
Table.set("Mean Intensity", row, values_mean);
Table.set("Min Intensity", row, values_min);
Table.set("Max Intensity", row, values_max);
Table.set("Std Intensity", row, values_std);
Table.update;

close();