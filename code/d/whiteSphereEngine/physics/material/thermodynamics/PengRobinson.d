module whiteSphereEngine.material.thermodynamics.PengRobinson;

// equation solved with mathematica
// Solve[(r*t1)/(vm1 - b) - (a*alpha)/(vm1^2 + 2 b*vm1 - b^2) == (r*t2)/(vm2 - b) - (a*alpha)/(vm2^2 + 2 b*vm2 - b^2), t2]
// alpha is a constant == 1, because else the equation is not closed solvable
double pengRobinsonForConstantPressure(double vm1, double t1, double vm2,  double a, double b) {
	const double R = UNIVERSALGASCONSTANT;

	const double alpha = 1.0;

	const double inner1 = (R*t1)/(-b+vm1);
	const double inner2 = (a*alpha) / (-b*b+2*b*vm1+vm1*vm1);
	const double inner3 = (a*alpha) / (-b*b+2*b*vm2+vm2*vm2);
	const double firstInner = -inner1 + inner2 - inner3;
	return -((-b+vm2)*firstInner)/R;
}

// TODO< use Netwon iteration to calculate exact temperature for the constant pressure case, because alpha depends on temperature! >

// is the product of the other two constants
// see https://en.wikipedia.org/wiki/Ideal_gas_law
private const double UNIVERSALGASCONSTANT = BOLTZMANNCONSTANTINJOULESPERKELVIN * AVOGADROCONSTANTINMOL;

private const double BOLTZMANNCONSTANTINJOULESPERKELVIN = 1.3806485279e-23; // https://en.wikipedia.org/wiki/Boltzmann_constant
private const double AVOGADROCONSTANTINMOL = 6.02214085774e23 ; // https://en.wikipedia.org/wiki/Avogadro_constant
