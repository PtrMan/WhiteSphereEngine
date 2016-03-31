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

import math.Range;

bool boundingBoxIsInsidePositionInclusive(VectorType)(AxisOrientedBoundingBox!VectorType boundingBox, VectorType toCheckPosition) {
	return
		isInRangeInclusive(boundingBox.min.x, boundingBox.max.x, toCheckPosition.x) &&
		isInRangeInclusive(boundingBox.min.y, boundingBox.max.y, toCheckPosition.y) &&
		isInRangeInclusive(boundingBox.min.z, boundingBox.max.z, toCheckPosition.z);
}

bool boundingBoxIsInsideInclusive(VectorType)(AxisOrientedBoundingBox!VectorType boundingBox, AxisOrientedBoundingBox!VectorType toCheckBoundingBox) {
	return
		boundingBoxIsInsidePositionInclusive(boundingBox.min, boundingBox.max, toCheckBoundingBox.min) &&
		boundingBoxIsInsidePositionInclusive(boundingBox.min, boundingBox.max, toCheckBoundingBox.max);
}

// implies the boundingBoxIsInside test
bool boundingBoxDoesOverlapInclusive(VectorType)(AxisOrientedBoundingBox!VectorType boundingBox, AxisOrientedBoundingBox!VectorType toCheckBoundingBox) {
	alias typeof(boundingBox.min.x) NumericType;
	
	bool overlapsOrInsideForOneDimension(NumericType aBegin, NumericType aEnd, NumericType bBegin, NumericType bEnd) {
		return
			isInRangeInclusive(aBegin, aEnd, bBegin) ||
			isInRangeInclusive(aBegin, aEnd, bEnd) ||
			isInRangeInclusive(bBegin, bEnd, aBegin) ||
			isInRangeInclusive(bBegin, bEnd, aEnd);
	}
	
	return
		overlapsOrInsideForOneDimension(boundingBox.min.x, boundingBox.max.x, toCheckBoundingBox.min.x, toCheckBoundingBox.max.x) &&
		overlapsOrInsideForOneDimension(boundingBox.min.y, boundingBox.max.y, toCheckBoundingBox.min.y, toCheckBoundingBox.max.y) &&
		overlapsOrInsideForOneDimension(boundingBox.min.z, boundingBox.max.z, toCheckBoundingBox.min.z, toCheckBoundingBox.max.z);
}
