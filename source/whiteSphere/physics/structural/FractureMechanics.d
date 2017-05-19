#include <cmath>

// http://www.mathopenref.com/trigsecant.html
double sec(double x) {
	return 1.0 / cos(x);
}

// book "J. Schijve Fatigue of Structures and Material 2009" page 112
double calcGeometryCorrectionFactorForCentralCrack(double a, double W) {
	double beta = sec((M_PI*a)/W);
	return beta;
}

// book "J. Schijve Fatigue of Structures and Material 2009" page 111
// beta is the geometry correction factor
// a is the width of the crack
double calcKSolution(double beta, double S, double a) {
	return beta*S*sqrt(M_PI*a);
}


double calcKSolutionForCentralCrack(double S, double a, double W) {
	return calcKSolution(calcGeometryCorrectionFactorForCentralCrack(a, W), S, a);
}

// book "J. Schijve Fatigue of Structures and Material 2009" page 115
double calcKSolutionForEdgeCrack(double S, double a) {
	return calcKSolution(1.1215, S, a);
}

// book "J. Schijve Fatigue of Structures and Material 2009" page 115
double calcKSolutionForTwoEdgeCrack(double S, double a, double W) {
	double aDivW = a/W;
	double beta = (1.122 - 1.122*aDivW - 0.06*aDivW*aDivW + 0.728*aDivW*aDivW*aDivW) / (sqrt(1.0 - 2.0*aDivW));
	return calcKSolution(beta, S, a);
}






// helper
// https://en.wikipedia.org/wiki/Radius_of_curvature#Ellipses
float calcRadiusOfCurvatureForEllpse(float a, float b) {
	return (a*a) / b;
}
