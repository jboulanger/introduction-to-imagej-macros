//@Integer(label="x") x
//@Integer(label="y") y
//@Integer(label="r") r

// Example - Calling another macro

function parseArgument(str, keys, default_values) {
	/* Parse arguments in string str */
	args = split(str);
	for (i = 0; i < args.length; i++) {
		kv = split(args[i], ",");
		for (j = 0; j < keys.length; j++) 
			if (kv[0] == keys[j]) 
				default_values[j] = kv[1];		
	} 	
}
args = getArgument();
if (args != "") {
	keys = newArray("x","y","r");
	values = newArray(1,1,5);
	parseArgument(args, keys, values);
	x = values[0];
	y = values[1];
	r = values[2];
}
print(x,y,r);
