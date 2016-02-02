// Example - String formating

// Clear the log window
print ("\\Clear") ;

// Print PI with 2 decimals
print(" The ratio of the perimeter "
    + "and the diameter of a circle is "
    + d2s(PI, 2) + ".") ;
    
// Print a sequence of number with zero−padding
for (n = 1 ; n <= 1000; n = n * 10) {
	print(IJ.pad(n, 4)) ;
}
