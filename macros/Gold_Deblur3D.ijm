/*
 * 3D Debluring with Gold-Meinel algorithm
 * 
 * Jerome Boulanger 2015
 */

macro "Gold_Deblur3D" {	
	Dialog.create("Deblur");
	Dialog.addNumber("Lateral blur (px):", 2);
	Dialog.addNumber("Axial blur (px):", 2);
	Dialog.addNumber("Number of iterations:", 3);
	Dialog.show();
	bl = Dialog.getNumber();
	ba = Dialog.getNumber();
	N = Dialog.getNumber();
	gold_deblur(bl, bl, ba, N);
}

// 3D debluring using a Gold Meinel algorithm.
function gold_deblur(sx, sy, sz, iter) {		
	setBatchMode(true);
	title = getTitle(); // Get windows title
	// Duplicate the image to create a 32bit version of it	
	run("Duplicate...", "duplicate");
	run("32-bit");	
	// and substract its minimum - offset to avoid dividing by 0
	getRawStatistics(nPixels, mean, min);
	run("Subtract...", "value=" + (min - 0.01));	
	data = getImageID();	
	// Duplicate the data image to create the initialization
	run("Duplicate...", "duplicate");
	run("Gaussian Blur 3D...", "x=" + sx + " y=" + sy + " z=" + sz);
	img1 = getImageID(); // ID of the initial estimate
	for (i = 0; i < iter; i++) {		
		// Compute the blurred version of the estimate
		run("Duplicate...", "title=Blurred duplicate");
		img2 = getImageID();	
		run("Gaussian Blur 3D...", "x=" + sx + " y=" + sy + " z=" + sz);		
		// Divide the input data (id:data) by the blurred estimate (id:img2)
		imageCalculator("Divide create 32-bit stack", data, img2);		
		ratio = getImageID();
		// Close the blurred estimate (id:img2)
		selectImage(img2); close();	
		// Multiply the previous estimate (id:img1) by the ration
		imageCalculator("Multiply 32-bit stack", img1, ratio);
		// Close the ratio (id:ratio)
		selectImage(ratio); close();
		// Select the estimate (id:img1)
		selectImage(img1);
	}	
	rename(appendToFilename(title, "_deblurred"));
	setBatchMode(false);
}

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