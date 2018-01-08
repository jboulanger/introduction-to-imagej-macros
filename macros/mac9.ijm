print("\\Clear");

// Example - Median value
a = newArray(1,5,10,7,9);
print("The array is:")
Array.print(a);
print("The median is: " + med(a));
print("The array now is:")
Array.print(a);
print("The median (no copy) is: " + medNoCopy(a));
print("The array now is:")
Array.print(a);

// Return the median of the array A
function med(A) {
	B = Array.copy(A);
	Array.sort(B);
	i = round((B.length - 1) / 2);
	return B[i];
}

// Return the median of the array A (no copy)
function medNoCopy(A) {
	Array.sort(A);
	i = round((A.length - 1) / 2);
	return A[i];
}