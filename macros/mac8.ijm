// Example - Functions

function addOneToNumber(number) {
	// Add one to the number
	return number + 1;
}

n = 1;
m = addOneToNumber(n);
print("n = "+ n + ", m =" + m);

function addOneToArray(array) {
	// Add one the first element of the array
	for (i = 0; i < array.length; i++) {
		array[i] = array[i] + 1;
	}
}

a = newArray(1,2,3,4,5,6);
addOneToArray(a);
Array.print(a);



