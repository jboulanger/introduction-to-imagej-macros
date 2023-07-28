// Example - Median value

// Return the median of the array A
function med(array) {
	sorted = Array.copy(array);	
	Array.sort(sorted);
	if (array.length % 2 == 0) {
		return 0.5 * (sorted[array.length / 2 - 1] + sorted[array.length / 2]);
	} else {
		return sorted[(array.length - 1) / 2];
	}	
}

n = 100;
a = newArray(n);
for (i = 0; i < n; i++) {
	a[i] = round(1000 * random);
}
Array.print(a);
print("The median is: " + med(a));

