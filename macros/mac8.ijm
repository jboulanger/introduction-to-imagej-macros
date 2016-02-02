// Example - Functions

// Hi Guys! – great the team
macro "Hi guys!" {
	team = newArray("Mathias", "Jon", "Nick");
	for (i = 0; i < team.length; i++) {
		print(greet(team[i]));
	}
}

// Return a greeting string
function greet(name) {
	 return "Hi " + name + "!";
}