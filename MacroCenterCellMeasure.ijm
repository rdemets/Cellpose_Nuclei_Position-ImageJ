roiManager("reset");
run("Clear Results");

dirS = getDirectory("Where to save");

//run("Set Measurements...", "area mean min centroid display redirect=None decimal=0");
run("Set Measurements...", "min redirect=None decimal=0");
run("Duplicate...", "duplicate");
rename("raw");

run("RGB Color");
//run("Colour Deconvolution", "vectors=[Masson Trichrome] hide");
run("Colour Deconvolution", "vectors=[H&E DAB] hide");
selectImage("raw (RGB)-(Colour_1)");

run("Median...", "radius=5");
setAutoThreshold("MaxEntropy");
//setAutoThreshold("Otsu");

run("Create Selection");
//roiManager("Add");
run("Create Mask");
rename("Nuclei");
close("raw (RGB)-(Colour_1)");
close("raw (RGB)-(Colour_2)");
close("raw (RGB)-(Colour_3)");
close("raw (RGB)");


selectImage("raw");
run("Cellpose ...", "env_path=E:\\Anaconda3\\envs\\env-cellpose env_type=conda model=cyto3 model_path=path\\to\\own_cellpose_model diameter=150 ch1=0 ch2=-1 additional_flags=[--use_gpu, --flow_threshold, 0]");
//run("Cellpose ...", "env_path=E:\\Anaconda3\\envs\\env-cellpose env_type=conda model=cyto3 model_path=path\\to\\own_cellpose_model diameter=0 ch1=0 ch2=-1 additional_flags=[--use_gpu, --flow_threshold, 0]");
selectImage("raw-cellpose");
run("Remove Border Labels", "left right top bottom");
run("Label Size Filtering", "operation=Greater_Than size=10000");
rename("FinalLabel");
close("raw-cellpose-killBorders");
close("raw-cellpose");
run("Label image to ROIs", "rm=[RoiManager[size=5000, visible=true]]");


RoiNumber = newArray(roiManager("count"));
ResultPercentage = newArray(roiManager("count"));
CellRadius = newArray(roiManager("count"));
NucleiPos = newArray(roiManager("count"));

for (roi=0; roi<roiManager("count"); roi++) {
	showProgress(roi, roiManager("count"));
	setBatchMode(true);
	RoiNumber[roi] = roi+1;
	selectImage("Nuclei");
    roiManager("Select", roi);
    run("Duplicate...", " ");
    run("Clear Outside");
	run("Create Mask");
	run("Distance Map");
	rename("DistanceMap");
	run("Select All");
	run("Measure");
	maxCell = getResult("Max", 0);
	if (maxCell>40) {

		CellRadius[roi] = maxCell;
		imageCalculator("AND create", "DistanceMap","Nuclei-1");
		run("Select All");
		//setThreshold(1, 255);
		//run("Create Selection");
		run("Measure");
		DistNuclei = getResult("Max", 1);
		//DistNuclei = getResult("Mean", 1);
		NucleiPos[roi] = DistNuclei;
		ResultPercentage[roi] = DistNuclei/maxCell*100;
		roiManager("Select", roi);
		if (DistNuclei/maxCell*100>75) {
			roiManager("Rename", roi+1);
			roiManager("Set Color", "red");
			roiManager("Set Line Width", 10);
		}
		else if (DistNuclei/maxCell*100>50) {
			roiManager("Rename", roi+1);
			roiManager("Set Color", "orange");
			roiManager("Set Line Width", 10);
		}
		else{
			roiManager("Rename", roi+1);
		}
	close("DistanceMap");
	close("Result of DistanceMap");
	close("Nuclei-1");
	}

	run("Clear Results");

}

Array.show(RoiNumber, NucleiPos,CellRadius, ResultPercentage);	


roiManager("Save", dirS+"RoiSet.zip");
saveAs("Results", dirS+"Stats.csv");

selectImage("raw");
saveAs("Tiff", dirS+"raw.tif");

selectImage("Nuclei");
saveAs("Tiff", dirS+"Nuclei.tif");

Dialog.create("Done");
Dialog.show();
