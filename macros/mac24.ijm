// Example - Closing the ROI manager

// Close the ROI manager and start batch mode
closeRoiManager();
setBatchMode(true);

// Close the ROI manager if it is open
function closeRoiManager() {
	if (isOpen("ROI Manager")) {
		selectWindow("ROI Manager");
		run("Close");
	}
}