module geometry.AxisOrientedBoundingBox;

class AxisOrientedBoundingBox(VectorType) {
	VectorType min, max;
	
	final public this(VectorType min, VectorType max) {
		this.min = min;
		this.max = max;
	}
}

// bounding box helpers
// TODO< put into own sourcefile >

import std.algorithm : min, max;

import math.Range;

bool boundingBoxIsInsidePositionInclusive(VectorType)(AxisOrientedBoundingBox!VectorType boundingBox, VectorType toCheckPosition) {
	return
		isInRangeEnum!(EnumRangeType.INCLUSIVE)(boundingBox.min.x, boundingBox.max.x, toCheckPosition.x) &&
		isInRangeEnum!(EnumRangeType.INCLUSIVE)(boundingBox.min.y, boundingBox.max.y, toCheckPosition.y) &&
		isInRangeEnum!(EnumRangeType.INCLUSIVE)(boundingBox.min.z, boundingBox.max.z, toCheckPosition.z);
}

bool boundingBoxIsInsideInclusive(VectorType)(AxisOrientedBoundingBox!VectorType boundingBox, AxisOrientedBoundingBox!VectorType toCheckBoundingBox) {
	return
		boundingBoxIsInsidePositionInclusive(boundingBox.min, boundingBox.max, toCheckBoundingBox.min) &&
		boundingBoxIsInsidePositionInclusive(boundingBox.min, boundingBox.max, toCheckBoundingBox.max);
}

// implies the boundingBoxIsInside test
bool boundingBoxDoesOverlap(EnumRangeType rangeType, VectorType)(AxisOrientedBoundingBox!VectorType boundingBox, AxisOrientedBoundingBox!VectorType toCheckBoundingBox) {
	alias typeof(boundingBox.min.x) NumericType;
	
	bool overlapsOrInsideForOneDimension(NumericType aBegin, NumericType aEnd, NumericType bBegin, NumericType bEnd) {
		return
			isInRangeEnum!rangeType(aBegin, aEnd, bBegin) ||
			isInRangeEnum!rangeType(aBegin, aEnd, bEnd) ||
			isInRangeEnum!rangeType(bBegin, bEnd, aBegin) ||
			isInRangeEnum!rangeType(bBegin, bEnd, aEnd);
	}
	
	return
		overlapsOrInsideForOneDimension(boundingBox.min.x, boundingBox.max.x, toCheckBoundingBox.min.x, toCheckBoundingBox.max.x) &&
		overlapsOrInsideForOneDimension(boundingBox.min.y, boundingBox.max.y, toCheckBoundingBox.min.y, toCheckBoundingBox.max.y) &&
		overlapsOrInsideForOneDimension(boundingBox.min.z, boundingBox.max.z, toCheckBoundingBox.min.z, toCheckBoundingBox.max.z);
}

// creates a bounding box which includes both bounding boxes
AxisOrientedBoundingBox!VectorType merge(VectorType)(AxisOrientedBoundingBox!VectorType a, AxisOrientedBoundingBox!VectorType b) {
	alias typeof(a.min.x) NumericType;
	
	NumericType minX = min(a.min.x, b.min.x);
	NumericType minY = min(a.min.y, b.min.y);
	NumericType minZ = min(a.min.z, b.min.z);
	NumericType maxX = max(a.max.x, b.max.x);
	NumericType maxY = max(a.max.y, b.max.y);
	NumericType maxZ = max(a.max.z, b.max.z);
	return new AxisOrientedBoundingBox!VectorType(new VectorType(minX, minY, minZ), new VectorType(maxX, maxY, maxZ));
}

AxisOrientedBoundingBox!VectorType merge(VectorType)(AxisOrientedBoundingBox!VectorType[] args) {
	AxisOrientedBoundingBox!VectorType result = args[0];
	
	foreach( iterationBoundingBox; args[1..$-1] ) {
		result = merge(result, iterationBoundingBox);
	}
	
	return result;
}
