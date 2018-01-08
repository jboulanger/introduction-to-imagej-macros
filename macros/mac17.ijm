//@File(label = "file") name
//@Double(label = "radius", value = 2) R
//@Integer(label = "iterations", value = 3) N
//@OUTPUT String output
macro "Test parameter annotations" {
	print("file:'" + name + "'\nradius: " + R);
	output = "filter img:"+name+"w radius:"+R;
}
