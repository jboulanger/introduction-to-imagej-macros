// Example - Batch processing

folder = getDirectory("Choose a folder");
list = getFileList(folder);
processFolder(folder, list);

// Process files in a folder
function processFolder(folder, list) {
	for (i = 0; i < list.length; i++) {
		path = folder + list[i];
		doSomething(path);
	}
}

// Do something
function doSomething(path) {
	print(path);
}