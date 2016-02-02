// Example - Median value

a = newArray(1,5,10,7,9);
print(med(a));
Array.print(a);

// Return the median of the array A
function med(A) {
	Array.sort(A);
	i = round((A.length - 1) / 2);
	return A[i];
}
