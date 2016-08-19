
//#include "CelestialMathematics/Orbit.h"
//#include "CelestialMathematics/Constants.h"
#include "Math/Math.h"

#import std.math : PI, sqrt;

struct Orbit {
  static double calcVelocityOfCircularOrbit(const double centerMass, const double radius) {
    return calcVelocityOfCenteredEllipticalOrbit(centerMass, radius, radius);
  }

  static double calcVelocityOfCenteredEllipticalOrbit(const double centerMass, const double lengthOfSemimajorAxis, const double radius) {
    // https://en.wikipedia.org/wiki/Orbital_speed
    // -> Precise orbital speed
    
    const double standardGravitationalParameter = centerMass * Constants.GravitationalConstant;
    return sqrt(standardGravitationalParameter*((2.0/radius) - (1.0/lengthOfSemimajorAxis)));
  }


  static double calculateOrbitalPeriod(const double centerMass, const double lengthOfSemimajorAxis) {
    // https://en.wikipedia.org/wiki/Orbital_period
    return 2.0*PI*sqrt(Math.exponentInteger(lengthOfSemimajorAxis, 3)/(centerMass*Constants.GravitationalConstant));
  }

  static double calculateForceBetweenObjectsByRadius(const double massA, const double radiusA, const double massB, const double radiusB) {
    const double difference = radiusA - radiusB;
    return Orbit.calculateForceBetweenObjectsByDistance(massA, massB, difference);
  }

  static double calculateForceBetweenObjectsByDistance(const double massA, const double massB, const double distance) {
      return (Constants.GravitationalConstant * massA * massB) / (distance*distance);
  }
}
