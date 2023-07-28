// Example - String filtering

// filter an array of string with a pattern
function filterArrayOfString(input, pattern) {
	output = Array.copy(input);	
	for (i = 0, k = 0; i < input.length; i++) {
		if (matches(input[i], pattern)) {
			output[k++] = input[i];			
		}
	}
	return Array.trim(output, k);
}

// Define an array of string
T = 10;
C = 2;
names = newArray(T*C);
for (t = 1; t <= T; t++) {
	for (c = 1; c <= C; c++) {
		names[(c-1) + C * (t-1)] = "image_c"+IJ.pad(c,2)+"_t"+IJ.pad(t,3)+".tif";
	}
}
Array.show(names);

// keep filenames corresponding to the first channel
filtered_names = filterArrayOfString(names, ".*c01.*");
Array.show(filtered_names);