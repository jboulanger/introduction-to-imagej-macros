#@File(label = "file") name
#@File(label = "folder",style="directory") folder
#@Double(label = "radius",value=2,min=0,max=10,style="slider") R
#@Integer(label = "iterations", value = 3) N
#@OUTPUT String output
macro "Test parameter annotations" {
	print("file:'" + name + "'\nradius: " + R);
	output = "filter img:"+name+"w radius:"+R;
}
