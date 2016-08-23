module celestial.Orbit;

import std.math : PI, sqrt, pow;

static import celestial.Constants;
import math.Math : exponentInteger;


double calcVelocityOfCircularOrbit(double centerMass, double radius) {
  return calcVelocityOfCenteredEllipticalOrbit(centerMass, radius, radius);
}

double calcVelocityOfCenteredEllipticalOrbit(double centerMass, double lengthOfSemimajorAxis, double radius) {
  // https://en.wikipedia.org/wiki/Orbital_speed
  // -> Precise orbital speed
  
  double standardGravitationalParameter = centerMass * celestial.Constants.GravitationalConstant;
  return sqrt(standardGravitationalParameter*((2.0/radius) - (1.0/lengthOfSemimajorAxis)));
}

double calculateOrbitalPeriod(double centerMass, double lengthOfSemimajorAxis) {
  // https://en.wikipedia.org/wiki/Orbital_period
  return 2.0*PI*sqrt(exponentInteger(lengthOfSemimajorAxis, 3)/(centerMass*celestial.Constants.GravitationalConstant));
}

double calculateForceBetweenObjectsByRadius(double massA, double radiusA, double massB, double radiusB) {
  double difference = radiusA - radiusB;
  return calculateForceBetweenObjectsByDistance(massA, massB, difference);
}

double calculateForceBetweenObjectsByDistance(double massA, double massB, double distance) {
    return (celestial.Constants.GravitationalConstant * massA * massB) / (distance*distance);
}


// w : initial spin rate in radiants per second
// a : semimajor axis of motion of satellite around planet/bigger body
  // Q : dissipation function of the satellite
  // G : gravitational costant
  // ms: mass of satellite
  // mc: mass of center
  // R : mean radius of satellite

  // p : density of satellite
  // mu: riggidity of satellite
double calcTidalLockingTimeForSphericalSatellite(const double w, const double a, const double Q, const double ms, const double mc, const double R, const double p, const double mu) {
	const double I = 0.4*ms*R*R;
	return calcTidalLockingTime(w, a, I, Q, ms, mc, R, p, mu);
}

// https://en.wikipedia.org/wiki/Tidal_locking#Timescale
// w : initial spin rate in radiants per second
// a : semimajor axis of motion of satellite around planet/bigger body
// I : moment of inertia of the satellite (typical for sphere, 0.4ms*R^2)
// Q : dissipation function of the satellite
// G : gravitational costant
// ms: mass of satellite
// mc: mass of center
// R : mean radius of satellite

// p : density of satellite
// mu: riggidity of satellite
double calcTidalLockingTime(const double w, const double a, const double I, const double Q, const double ms, const double mc, const double R, const double p, const double mu) {
	const double surfaceGravity = calcSurfaceGravity(ms, R); // assumes sphere
	const double k2 = calcK2(p, surfaceGravity, mu, R); // tidal love number of the satellite
	
	return (w*pow(a, 6.0)*I*Q) / (3.0*celestial.Constants.GravitationalConstant*pow(mc, 2.0)*k2*pow(R, 5.0));
}

double calcK2(const double p, const double g, const double mu, const double R) {
	return 1.5 / (1.0 + ((19.0*mu) / (2.0*p*g*R)));
}

double calcSurfaceGravity(const double mass, const double r) {
    return (celestial.Constants.GravitationalConstant * mass) / (r*r);
}