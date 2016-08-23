import std.math : sin, cos, tan, atan, PI, abs;

import math.NewtonsMethod;

private double calcTrueAnomaly(double eccentricity, double eccentricAnomaly) {
	// see 3rd equation of https://en.wikipedia.org/wiki/Kepler%27s_laws_of_planetary_motion#Position_as_a_function_of_time
	double rightSide = (1.0 + eccentricity)*tan(tan(eccentricAnomaly / 2.0));
	double result = atan(atan(rightSide/(1.0 - eccentricity))) * 2.0;

	assert(abs((1.0 - eccentricity)*tan(tan(result / 2.0)) - (1.0 + eccentricity)*tan(tan(eccentricAnomaly / 2.0))) < 0.000001);
	return result;
}

private double calcHelicentricDistance(double semiMajorAxis, double eccentricity, double trueAnomaly) {
	// see 4th equation of https://en.wikipedia.org/wiki/Kepler%27s_laws_of_planetary_motion#Position_as_a_function_of_time
	return semiMajorAxis*(1.0 - eccentricity*cos(trueAnomaly));
}

private double calcEccentricAnomaly(double eccentricity, double meanAnomaly,  double accuracy) {
	// see 2nd equation of https://en.wikipedia.org/wiki/Kepler%27s_laws_of_planetary_motion#Position_as_a_function_of_time
	// we solve it with the netwon method

	double f(double x) {
		return (x - eccentricity * sin(x)) - meanAnomaly;
	}

	double fDerivative(double x) {
		// https://www.wolframalpha.com/input/?i=derive+(x+-+a+*+sin(x))+-+b+by+x
		return 1.0 - eccentricity * cos(x);
	}

	const double eccentricAnomaly = newtonsMethod(&f, &fDerivative, accuracy, 300, PI);
	return eccentricAnomaly;
}

// calculates the position (as radius and angle) of a celestial body
void positionAfterT(double period, double t, double eccentricity, double semiMajorAxis, out double trueAnomaly, out double heliocentricDistance, const double accuracy = 1.0e-5)
in {
	assert(0.0 <= t && t <= period, "t must be between 0.0 and period");
}
body {
	//  see 1th equation of https://en.wikipedia.org/wiki/Kepler%27s_laws_of_planetary_motion#Position_as_a_function_of_time
	double meanMotion = (2.0*PI) / period;
	double meanAnomaly = meanMotion * t;

	//writeln("mean anomaly ", meanAnomaly);

	const double eccentricAnomaly = calcEccentricAnomaly(eccentricity, meanAnomaly,  accuracy);

	//writeln("eccentric anomaly ", eccentricAnomaly);
	//writeln("(error) ", (eccentricAnomaly - eccentricity * sin(eccentricAnomaly)) - meanAnomaly);

	trueAnomaly = calcTrueAnomaly(eccentricity, eccentricAnomaly);
	//writeln("true anomaly ", trueAnomaly);
	
	heliocentricDistance = calcHelicentricDistance(semiMajorAxis, eccentricity, trueAnomaly);
}

void positionAfterTWithPrecisionByAphelion(double period, double t, double eccentricity, double semiMajorAxis, out double trueAnomaly, out double heliocentricDistance, double aphelionInMeter) 
in {
  assert(aphelionInMeter > 0.0);
}
body {
  double accuracy = 1.0 / aphelionInMeter; // actually (1.0 / aphelionInMeter*2*PI) * 2*PI
  positionAfterT(period, t, eccentricity, semiMajorAxis, trueAnomaly, heliocentricDistance, accuracy);
}


/+
void main() {
	import std.stdio;

	double period = 10.0;

	double t = 1.0; // [0; period]

	double eccentricity = 0.5; // (0.0; 1.0]

	double trueAnomaly, heliocentricDistance;
	positionAfterT(period, t, eccentricity, semiMajorAxis, /*out*/trueAnomaly, /*out*/heliocentricDistance)
}
+/