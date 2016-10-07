module whiteSphereEngine.celestial.GalaxyDensity;

// untested
// TODO< test and integrate >

import linoperixed.linear.Vector;
import math.VectorAlias;

Vector3p pickNearestPoint(const Vector3p[] points, const Vector3p point) {
	double nearestDistance = (points[0]-point).magnitudeSquared;
	Vector3p nearestPoint = points[0];

	foreach( iterationPoint; points[1..$] ) {
		const double currentDistance = (iterationPoint-point).magnitudeSquared;
		if( currentDistance < nearestDistance ) {
			nearestDistance = currentDistance;
			nearestPoint = iterationPoint;
		}
	}

	return nearestPoint;
}


struct Arguments {
	Vector3p[] armPoints;
	double delegate(double angle, double radius) calcDensityByRadiusAndAngle;
	double maxRadius;

	double delegate(double distance) calcDensityToNextSpiral;
}

// calculates the density of a givn point in a (spiral) galaxy
// can be used to calculate the propability of an [star(system)/stellar object] in a galaxy
double spiralGalaxyCalcDensity(double angle, double radius, Vector3p position, const ref Arguments arguments) {
	if( radius > arguments.maxRadius ) {
		return 0.0;
	}

	const double baseDensity = arguments.calcDensityByRadiusAndAngle(angle, radius);

	const Vector3p closestArmPoint = pickNearestPoint(arguments.armPoints, position);
	const double distanceToClosestArmPoint = (position-closestArmPoint).magnitude;

	return arguments.calcDensityToNextSpiral(distanceToClosestArmPoint)*baseDensity;
}
