//@File(label = "file") my_filename
//@Double(label = "radius", value = 2) my_radius
//@Integer(label = "iterations", value = 3) my_iterations
//@OUTPUT String my_filename
macro "Test parameter annotations" {
	print("the file is '" + my_filename + "'\nradius is " + my_radius);
}
