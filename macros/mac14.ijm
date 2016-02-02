// Example - String filtering

// Define an array of string
names = newArray("mCherry_c1_t1.tif","GFP_c2_t1.tif",
				 "mCherry_c1_t2.tif","GFP_c2_t2.tif");
Array.print(names);
// keep string having mCherry in the middle
names = filterArrayOfString(names, ".*mCherry.*");
Array.print(names);

// filter an array of string with a pattern
function filterArrayOfString(input, pattern) {
	output = newArray(0);
	for (i = 0; i < input.length; i++) {
		if (matches(input[i], pattern)) {
			output = Array.concat(output, input[i]);
		}
	}
	return output;
}