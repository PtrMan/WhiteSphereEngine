module whiteSphereEngine.material.thermodynamics.ClapeyronEquation;

import std.math : log, exp;

// can be used to calculate the melting temperature of a pressure a
// see http://www.chm.bris.ac.uk/~chdms/Teaching/Chemical_Interactions/page_11.htm
// deltaV : delta of molar volume
// p1, p2 : pressure
// t1 : temperature
// deltaH : delta of enthalpy
double solveClapeyronEquationForT2(double p1, double p2, double deltaH, double deltaV, double t1) {
  double inner = (deltaV/deltaH)*(p2-p1) + log(t1);
  return exp(inner);
}