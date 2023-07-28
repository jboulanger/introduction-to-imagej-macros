/*
 * ROI Overlaps
 *
 * Compute the overlap between two set of ROIs
 *
 * Jerome Boulanger 2015-2023
 */

run("Close All");

if (nImages == 0) {
	test();
}

function test() {

	newImage("test", "8-bit", 500, 500, 1);

	if (isOpen("ROI Manager")) {selectWindow("ROI Manager"); run("Close");}

	big_id = generateRandomCircles(2,200,300,"blue");
	big_areas = measureROIsStatistics(big_id, "Area");

	small_id = generateRandomCircles(10,30,60,"red");
	small_areas = measureROIsStatistics(small_id, "Area");

	groups = getParentID(small_id, big_id, 0.01);

	sum_area_small = aggregate(groups, small_areas, "sum");
	num_small = aggregate(groups, small_areas, "count");

	Array.show(big_id, big_areas, sum_area_small, num_small);

	roiManager("Show All");
	run("Select None");
}

function generateRandomCircles(number, min_size, max_size, color) {
	/*  Generate random circles in the image */
	getDimensions(width, height, channels, slices, frames);
	ids = newArray(number);
	for (i = 0; i < number; i++) {
		d = min_size + random * (max_size - min_size);
		x = random * (width - d);
		y = random * (height - d);
		makeOval(x,y,d,d);
		Roi.setStrokeColor(color);
		roiManager("add");
		ids[i] = roiManager("count") - 1;
	}
	return ids;
}

function measureROIsStatistics(rois, statistic) {
	/* Return the getValue(statistics) for each ROIs */
	values = newArray(rois.length);
	for (i = 0; i < values.length; i++) {
		roiManager("select", rois[i]);
		values[i] = getValue(statistic);
	}
	return values;
}

function getParentID(childs, parents, iou_threshold) {
	/* List all parent IDs as a child, parent index pair in the original arrays */
	 parent_id = newArray(2 * childs.length * parents.length);
	 k = 0;
	 for (i = 0; i < childs.length; i++) {
	 	for (j = 0; j < parents.length; j++) {
	 		iou = getIntersectionOverUnion(parents[j], childs[i]);
	 		if (iou > iou_threshold) {
	 			parent_id[2*k] = i;
	 			parent_id[2*k+1] = j;
	 			k++;
	 		}
	 	}
	 }
	 return Array.trim(parent_id, 2 * k);
}

function getIntersectionOverUnion(id1, id2) {
	/* Compute the intersection over union of ROIs id1 and id2 */
	roiManager("select", newArray(id1,id2));
	roiManager("combine");
	union = getValue("Area");
	roiManager("select", newArray(id1,id2));
	// intersection
	roiManager("and");
	// if no overlap, returns 0
	if (Roi.size==0) return 0;
	// mesure area of resulting selection
	return getValue("Area") / union;
}

function aggregate(groups, values, func) {
	/* Aggregate values by group using aggregation function func
	 *
	 * groups: array with index (2k) / group (2k+1) pairs
	 * values: array with value to aggregate
	 * func : aggregation function "sum", "count", "min", "max", "mean", "std"
	 *
	 * Returns an array of size the number of groups
	 */

	if (matches(func,"mean")) {
		S = aggregateStatistics(groups, values, "sum");
		N = aggregateStatistics(groups, values, "count");
		for (i = 0; i < S.length; i++) {
			S[i] = S[i] / N[i];
		}
		return S;
	}

	if (matches(func,"std")) {
		M = aggregateStatistics(groups, values, "mean");
		centered_values = newArray(values.length);
		for (i = 0; i < centered_values .length; i++) {
			centered_values[i] = (S[i] - M[groups[i]]) * (S[i] - M[groups[i]]);
		}
		S = aggregateStatistics(groups, centered_values, "mean");
		for (i = 0; i < S.length; i++) {
			S[i] = sqrt(S[i]);
		}
		return S;
	}

	aggvalues = newArray(groups.length);
	gidmax = 0;
	for (i = 0; i < groups.length / 2; i++) {
		eid = groups[2*i];
		gid = groups[2*i+1];
		gidmax = maxOf(gid, gidmax);
		if (gid >= 0) {
			if (matches(func,"sum")) {
				aggvalues[gid] += values[eid];
			} else if (matches(func,"min")) {
				aggvalues[gid] = minOf(aggvalues[gid], values[eid]);
			} else if (matches(func,"max")) {
				aggvalues[gid] = maxOf(aggvalues[gid], values[eid]);
			} else if (matches(func,"count")) {
				aggvalues[gid] = aggvalues[gid] + 1;
			}
		}
	}
	aggvalues = Array.trim(aggvalues, gidmax+1);
	return aggvalues;
}


