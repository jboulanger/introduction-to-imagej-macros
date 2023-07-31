// Print "Hello World!" in the log window

macro "Hello World [g]" {
	message = "Hello World! ";	
	if (nImages > 0) {
		message += "There are " + nImages + " images opened.";
	} else {
		message += "There are no opened image.";
	}
    print(message);
}
