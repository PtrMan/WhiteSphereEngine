module math.QuadraticSolver;

import std.math : sqrt;

/** \brief solves the quadratic equation
 *
 * Formula : (TOFORMAT x*x*a + x*b + c = 0)
 *
 * \param a ...
 * \param b ...
 * \param c ...
 * \param existSolutions ...
 * \param solution1 ...
 * \param solution2 ...
 */
public void quadraticSolve(Type)(Type a, Type b, Type c, out bool existSolutions, out Type solution1, out Type solution2) {
	if( a == cast(Type)0.0 ) {
 		existSolutions = false;
 		return;
	}
		
	Type toSquareRoot = b*b - cast(Type)4.0*a*c;
	existSolutions = toSquareRoot > 0;
	if( existSolutions ) {
		Type squareRooted = sqrt(toSquareRoot);

		solution1 = (-b + squareRooted) / (cast(Type)2.0*a);
		solution2 = (-b - squareRooted) / (cast(Type)2.0*a);

		existSolutions = true;
	}
}
