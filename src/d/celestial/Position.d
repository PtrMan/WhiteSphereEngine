module celestial.Position;

import std.math : sin, cos;

import math.NumericSpatialVectors;
import math.VectorAlias;

// calculate the vectors based on the angle of the circle, its_not_ the angle we get from the positionAfterT*() family, we need to add 90 degrees from it to put it into this formula
Vector3p calcRelativePositionAfterAngleAndMajorSemimajorAxis(const double angle, const double heliocentricDistance, const Vector3p majorAxisDirection, const Vector3p semimajorAxisDirection) {
	double cosPart = cos(angle) * heliocentricDistance;
	double sinPart = sin(angle) * heliocentricDistance;
	
	return majorAxisDirection * cosPart + semimajorAxisDirection * sinPart;
}

Vector3p calcRelativePositionAfterAngleAndMajorSemimajorAxisFromTrueAnomaly(const double trueAnomaly, const double heliocentricDistance, const Vector3p majorAxisDirection, const Vector3p semimajorAxisDirection) {
	const double angle = trueAnomaly + PI/2.0; // add 90 degrees to correct it
	return calcRelativePositionAfterAngleAndMajorSemimajorAxis(angle, heliocentricDistance, majorAxisDirection, semimajorAxisDirection);
}
