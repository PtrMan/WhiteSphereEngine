module whiteSphereEngine.geometry.volume.Volume;

import whiteSphereEngine.geometry.area.AreaSimple;

// see http://math.stackexchange.com/questions/818608/how-to-find-the-volume-of-oblique-cone
double volumeCone(double height, double radius) {
	return areaCircle(radius)*height / 3.0;
}

import std.math : PI, sqrt;

// see http://keisan.casio.com/exec/system/1223372110
double volumeConeSection(double r1, double r2, double h) {
	return (1.0/3.0)*cast(double)PI*(r1*r1 + r1*r2 + r2*r2)*h;
}

// see http://www.vitutor.com/geometry/solid/truncated_cone.html
double surfaceAreaTruncatedCodeInner(double R, double r, double h) {
	const double s = cast(float)sqrt(h*h + (R-r)*(R-r));
	return cast(double)PI*s*(R+r);
}


// helper
private double lineZeroIntersectionX(double ax, double ay, double bx, double by) {
	const double diffX = bx - ax;
	const double diffY = by - ay;
	assert(diffX != 0.0);
	const double gradient = diffY / diffX;

	return (ay - gradient * ax) / - gradient;
}