// Example - Overlays / time stamp and scale bar

time_interval_s = 2.5;
pixel_size_um = 0.16;
scale_bar_size_um = 10;

Overlay.remove;
for (frame = 1; frame <= nSlices(); frame++) {
	addTimer(frame, time_interval_s);
	addScaleBar(pixel_size_um, scale_bar_size_um);
}

function addTimer(frame, time_interval_s) {
	time = frame * time_interval_s;
	setColor("white");
	Overlay.drawString("[" + time + "s]",
		5, getHeight() - 5);
	Overlay.setPosition(frame);
	Overlay.show();
}

function addScaleBar(pixel_size_um, scale_bar_size_um) {
	setColor("white");
	size_in_pixel = scale_bar_size_um / pixel_size_um;
	d = 10; // Distance from the edge
	Overlay.drawRect(getWidth() - size_in_pixel - d,
		getHeight() - d,  size_in_pixel, 1);
	text = "" + scale_bar_size_um + getInfo("micrometer.abbreviation");
	Overlay.drawString(text, getWidth() - size_in_pixel*0.9, getHeight() - d - 2);
	Overlay.setPosition(frame);
	Overlay.show();
}
