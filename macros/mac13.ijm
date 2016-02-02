// Example - Path name manipulation

print("\\Clear");
path = "C:/My Favourite Folder/image.tif";
print("Path name\t: " + path);
print("Basename\t: " + baseName(path));
print("Dirname\t: " + dirName(path));

// return the base name of a path (remove folder)
function baseName(path) {
	N =  lastIndexOf(path, File.separator);
	return substring(path, N + 1, lengthOf(path)) ;
}

// return the directoy/folder name
function dirName(path) {
	N =  lastIndexOf(path, File.separator);
	return substring(path, 0, N) ;
}