// Example - Append a string to a filename

// append str before the extension of filename
function appendToFilename(filename, str) {
	i = lastIndexOf(filename, '.');
	if (i > 0) {
		name = substring(filename, 0, i);
		ext = substring(filename, i, lengthOf(filename));
		return name + str + ext;
	} else {
		return filename + str
	}
}

input = "3D_Stack.TIF";
output = appendToFilename(input, "_deconv");
print("Input: " + input + "\nOutput: " + output);