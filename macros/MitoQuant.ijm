/*
 * Process all the TIFF file in a folder
 * Count the number of cell in each file
 
*/

// test classify the cell in division
macro "Classify Cells" {	
	segmentBlobs(5, 50, 1);		
	measures = newArray("StdDev+", "Round-", "Max+");
	D = classifyRoi(measures, 0.1);	
	// color the ROI with classification
	lut = newArray("green", "red");
	for (i = 0; i < D.length; i++) {
		roiManager("select", i);
		index = floor(D[i]);
		Roi.setStrokeColor(lut[index]);		
	}
}

macro "Count" {
	folder = getDirectory("Choose a folder");
	print("Analysis of [" + folder + "].");
	list = getFileList(folder);
	t0 = getTime();
	processTiffsInFolder(folder, list);
	t1 = getTime();
	print("Elapsed Time: " + (t1 - t0)/1000 + "s.");
}


// Open each TIF files in a folder 
// Segments the cells and store the number of cells
// 
function processTiffsInFolder(folder, list) {
	num_cell = newArray(0);
	time = newArray(0);
	names = newArray(0);
	if (isOpen("ROI Manager")) {
		selectWindow("ROI Manager");
		run("Close");
	}
	setBatchMode(true);
	for (i = 0; i < list.length; i++) {		
		if (endsWith(list[i], ".TIF")) {
			names = arrayPushBack(names, list[i]);
			time = arrayPushBack(time, i);
			open(folder + File.separator + list[i]);
			segmentBlobs(5, 50, 2);
			num_cell = arrayPushBack(num_cell, roiManager("count"));
			//e = quantifyBlobsEccentricity();
			// Clear the ROIs
			run("Select All");
			roiManager("Delete");	
			// Close the image
			close();
		}
	}
	setBatchMode(false);
	Array.show("Cell count", names, time, num_cell);
	// Compute the doubling time of the population growth
	Fit.doFit("Exponential", time, num_cell);
	Fit.plot();
	T =  log(2) / Fit.p(1);
	print("Doubling time: " + T + " frame." );
}

// Segment bright blobs using a DoG filter
function segmentBlobs(smoothing, background, quantile) {	
	id = getImageID();	
	run("Duplicate...", "title=mask");
	DoG(5, 10);	
	threshold = computeThreshold(quantile);
	getStatistics(area, mean, min, max);
	setThreshold(threshold, max);
	run("Convert to Mask");
	run("Watershed");
	run("Analyze Particles...", "add");
	selectWindow("mask");
	close();
	selectImage(id);
}

// Classifiy ROI according to the list of measurments given as an array of string
// exemple newArray("StdDev+", "Round-", "Max+");
function classifyRoi(M, quantile) {
	D = newArray(roiManager("count"));
	for (i = 0; i < D.length; i++) {
		D[i] = 1;
	}
	for (j = 0; j < M.length; j++) {
		str = substring(M[j], 0, lengthOf(M[j]) - 1);
		sig = substring(M[j], lengthOf(M[j]) - 1, lengthOf(M[j]));
		print("Using " + str + " with " + sig);
		s = getROIMeasure(str);
		c = med(s);
		d = quantile * mad(s);
		for (i = 0; i < s.length; i++) {
			if ((s[i] < (c-d) && sig=="+") || (s[i] > (c+d) && sig=="-")) {
				D[i] = 0;
			}
		}
	}
	return D;	
}

// Measure for all ROI a characteristic and return an array
function getROIMeasure(str) {
	N = roiManager("count");
	e = newArray(N);
	for (i = 0; i < N; i++) {
		roiManager("select", i);
		List.setMeasurements;
		e[i] = List.getValue(str);
	}
	return e;
}

// Difference of Gaussian filter
function DoG(sigma1, sigma2) {
	run("32-bit");
	N = 2 * round(3 * sigma2) + 1;		
	c1 = 2 * PI * sigma1 * sigma1;
	c2 = 2 * PI * sigma2 * sigma2;	
	txt = "[";		
	for (j = 0; j < N; j++) {
		for (i = 0; i < N; i++) {			
			x = i - (N - 1)/2;
			y = j - (N - 1)/2;
			z1 = - (x * x + y * y) / (2 * sigma1 * sigma1);
			z2 = - (x * x + y * y) / (2 * sigma2 * sigma2);
			val1 = exp(z1) / c1;
			val2 = exp(z2) / c2;
			s = s + val2;
			txt = txt + d2s(val1-val2, 6);
			if (i != N-1) {
				txt = txt + " ";
			}
		}		
		if (j != N-1) {
			txt = txt + "\n";
		}
	}
	txt = txt + "]";	
	run("Convolve...", "text1=" + txt);
}

// Compute a threshold from a quantile on robust statistics
function computeThreshold(quantile) {	
	A = image2Array();
	return med(A) + quantile * mad(A);
}

// Convert a 2D image to a 1D array
function image2Array() {
	A = newArray(getWidth * getHeight);
	for (y = 0; y < getHeight; y++) {
		for (x = 0; x < getWidth; x++) {
			i = x + getWidth * y;
			A[i] = getPixel(x, y);
		}
	}
	return A;
}

// Median of the array A
function med(array) {
	A = Array.copy(array);
	Array.sort(A);
	i = round((A.length - 1)/2);
	return A[i];
}

// Median of Absolute Deviation (estimate of the standard deviation)
function mad(array) {
	m = med(array);
	A = Array.copy(array);
	for (i = 0; i < A.length; i++) {
		A[i] = abs(A[i] - m);
	}	
	return med(A);
}

// Push back  a value in the array "a"
function arrayPushBack(a, value) {
	if (a.length == 0) {
		a = newArray(1);
		a[0] = value;
	} else {
		b = newArray(1);
		b[0] = value;
		a = Array.concat(a, b);			
	}
	return a;
}