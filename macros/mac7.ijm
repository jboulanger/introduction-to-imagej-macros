// Example - Loops & array

// Hi Guys - great the team
macro "Hi guys!" {
	team = newArray("Mathias", "Jon", "Nick");
	for (i = 0; i < team.length; i++) {
		print("Hi " + team[i] + "!");
	}
}