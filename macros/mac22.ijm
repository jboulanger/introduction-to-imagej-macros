// Example - Using bioformat extension

run("Bio-Formats Macro Extensions");
id = File.openDialog("Choose a file");
Ext.setId(id);
Ext.getSeriesCount(seriesCount);
for (s=0; s<seriesCount; s++) {
  Ext.setSeries(s);
  Ext.getSizeX(sizeX);
  Ext.getSizeY(sizeY);
  Ext.getSizeZ(sizeZ);
  Ext.getSizeC(sizeC);
  Ext.getSizeT(sizeT);
  print("Series #" + s + ": image size is " + sizeX + " x " + sizeY);
  print("Focal plane count = " + sizeZ);
  print("Channel count = " + sizeC);
  print("Time point count = " + sizeT);
}
Ext.close();