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
	title = getTitle();
	run("Duplicate...", "duplicate");
	run("32-bit");		
	data = getImageID();	
	
	getStatistics(n,avg,min);
	run("Subtract...", "value=" + (min-1));	
	
	run("Duplicate...", "duplicate");		
	img1 = getImageID();
	run("Gaussian Blur 3D...", "x=" + sx + " y=" + sy + " z=" + sz);
	for (i = 0; i < iter; i++) {
		run("Duplicate...", "title=Blurred duplicate");
		img2 = getImageID();
		run("Gaussian Blur 3D...", "x=" + sx + " y=" + sy + " z=" + sz);		
		imageCalculator("Divide create 32-bit stack", data, img2);		
		ratio = getImageID();
		selectImage(img2); close();	
		imageCalculator("Multiply 32-bit stack", img1, ratio);
		selectImage(ratio); close();
	}
	selectImage(img1);
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