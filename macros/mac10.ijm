// Example - Pixel values

// Convert a 2D image to a 1D array
function image2Array() {
	A = newArray(getWidth * getHeight);
	for (y = 0; y < getHeight; y++) {
		for (x = 0; x < getWidth; x++) {
			A[x + getWidth * y] = getPixel(x, y);
		}
	}
	return A;
}

print("\\Clear");
run("Blobs (25K)");
a = image2Array();
Array.print(a);