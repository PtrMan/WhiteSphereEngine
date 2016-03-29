module physics.collisionCode.RayRay;

import math.NumericSpatialVectors : SpatialVector, dot;

// finds t of closests points between two rays
// http://morroworks.com/Content/Docs/Rays%20closest%20point.pdf
public void closestTOfTwoRays(NumericType, bool checkDirectionsZero = true)(SpatialVector!(3, NumericType) aPosition, SpatialVector!(3, NumericType) aDirection, SpatialVector!(3, NumericType) bPosition, SpatialVector!(3, NumericType) bDirection, out NumericType at, out NumericType bt, out bool valid) {
	valid = false;
	
	NumericType dotAB = dot(aDirection, bDirection);
	NumericType dotAA = dot(aDirection, aDirection);
	NumericType dotBB = dot(bDirection, bDirection);
	
	NumericType divisor = dotAA*dotBB - dotAB*dotAB;
	if( divisor == cast(NumericType)0.0 ) {
		return;
	}
	if( checkDirectionsZero && dotAA != cast(NumericType)0.0 && dotBB != cast(NumericType)0.0 ) {
		return;
	}
	
	valid = true;
	
	SpatialVector!(3, NumericType) c = bPosition - aPosition;
	NumericType dotAC = dot(aDirection, c);
	NumericType dotBC = dot(bDirection, c);
	
	at = (-dotAB*dotBC + dotAC*dotBB) / divisor;
	bt = (dotAB*dotAC - dotBC*dotAA) / divisor;
}
