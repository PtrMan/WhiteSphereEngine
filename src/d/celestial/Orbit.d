module celestial.Orbit;

import std.math : PI, sqrt;

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
