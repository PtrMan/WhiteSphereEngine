#include <cstdint>

#include <cmath>






// see http://mathworld.wolfram.com/Circle-CircleIntersection.html
double circleSegmentArea(double rTick, double dTick) {
  return rTick*rTick * acos(dTick/rTick) - dTick * (rTick*rTick - dTick*dTick);
}

// calculates area of intersecting 'lense'
// see http://mathworld.wolfram.com/Circle-CircleIntersection.html
double circleIntersectionLenseAreaForX(double x, double d, double r1, double r2) {
  double d1 = x;
  double d2 = d - x;
  
  return circleSegmentArea(r1, d1) + circleSegmentArea(r2, d2);
}

// calculates area of intersecting 'lense'
// see http://mathworld.wolfram.com/Circle-CircleIntersection.html
double circleIntersectionLenseArea(double d, double r, double rBig, double &x) {
  x = (d*d - r*r + rBig*rBig) / 2*d;
  return circleIntersectionLenseAreaForX(x, d, rBig, r);
}
