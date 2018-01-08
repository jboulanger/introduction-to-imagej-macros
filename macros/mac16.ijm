// Example - User interface using Dialog

 Dialog.create("New Image");
 Dialog.addString("Title:", "Untitled");
 Dialog.addChoice("Type:", newArray("8-bit", "16-bit", "32-bit", "RGB"));
 Dialog.addNumber("Width:", 512);
 Dialog.addNumber("Height:", 512);
 Dialog.addCheckbox("Ramp", true);
 Dialog.show();
 title = Dialog.getString();
 type = Dialog.getChoice();
 width = Dialog.getNumber();
 height = Dialog.getNumber();
 ramp = Dialog.getCheckbox();
 if (ramp==true) type = type + " ramp";
 newImage(title, type, width, height, 1);