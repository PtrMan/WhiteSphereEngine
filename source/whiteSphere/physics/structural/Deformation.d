
// described in "MECHANICAL PROPERTIES OF STRUCTURAL STAINLESS STEELS"
// https://suw.biblos.pk.edu.pl/resources/i4/i7/i8/i6/i8/r47868/TylekI_MechanicalProperties.pdf
double calcRambergOsgoodFormula(double rho, double E, double E_y, double f_y, double f_u, double e_u, unsigned n, unsigned m) {
	if( rho < f_y ) {
		return rho/E + 0.002 * expBySquaringIterative(rho, n);
	}
	else {
		double insideExponent = (rho - f_y)/(f_u - f_y);
		return 0.002 + f_y/E + (rho - f_y) / E_y + e_u * expBySquaringIterative(insideExponent, m);
	}
}
