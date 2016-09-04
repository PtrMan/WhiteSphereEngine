module whiteSphereEngine.math.geometry.DistancePointEllipseEllipsoid;

import std.math : sqrt, abs, fmax;

// helper
private Type sqr(Type)(const Type value) {
	return value*value;
}

// computes the length of the input vector v0, v1 by avoiding floating-point overflow that could ccur normally when computing v_0^2 + v_1^2
private Type robustLength(Type)(const Type v0, const Type v1) {
	if( abs(v0) == cast(Type)fmax(abs(v0), abs(v1))) { // |v_0] = max{|v_0|,|v_1|}
		return abs(v0)*sqrt(cast(Type)1+sqr(v1/v0));
	}
	else { // |v_1] = max{|v_0|,|v_1|}
		return abs(v1)*sqrt(cast(Type)1+sqr(v0/v1));
	}
}

// http://www.geometrictools.com/Documentation/DistancePointEllipseEllipsoid.pdf
// page 12
// LICENSE< unknown! >

private Type getRoot(Type)(const Type r0, const Type z0, const Type z1, Type g) {
	enum maxIterations = Type.dig - Type.min_exp; // as described in http://www.geometrictools.com/Documentation/DistancePointEllipseEllipsoid.pdf  page 8

	const Type
		n0 = r0*z0;
	
	Type 
		s1 = (g < 0 ? 0 : robustLength(n0, z1) - 1),
		s0 = z1 - 1,
		s = 0;


	foreach( i; 0..maxIterations ) {
		s = (s0 + s1) / 2;
		if( s == s0 || s == s1 ) {
			break;
		}
		const Type
			ratio0 = n0/(s + r0),
			ratio1 = z1/(s + 1);
		g = sqr(ratio0) + sqr(ratio1) - 1;
		if( g > 0 ) {
			s0 = s;
		}
		else if( g < 0 ) {
			s1 = s;
		}
		else {
			break;
		}
	}

	return s;
}


// just for testing
/*
 double testgetRoot(const double r0, const double z0, const double z1, double g) {
 	 return getRoot(r0, z0, z1, g);
 }
*/

// http://www.geometrictools.com/Documentation/DistancePointEllipseEllipsoid.pdf
// page 12
// LICENSE< unknown! >
Type distancePointEllipse(Type)(const Type e0, const Type e1, const Type y0, const Type y1, out Type x0, out Type x1)
in {
	assert(e0 >= e1);
	assert(y0 >= 0);
	assert(y1 >= 0);
}
body {
	Type distance;
	if( y1 > 0 ) {
		if( y0 > 0 ) {
			const Type
				z0 = y0/e0,
				z1 = y1/e1,
				g = sqr(z0)+sqr(z1)-1;
			if( g != 0 ) {
				const Type
					r0 = sqr(e0/e1),
					sbar = getRoot(r0, z0, z1, g);

				x0 = r0*y0/(sbar + r0);
				x1 = y1/(sbar + 1);
				distance = sqrt(sqr(x0-y0) + sqr(x1 - y1));
			}
			else {
				x0 = y0;
				x1 = y1;
				distance = 0;
			}
		}
		else { // y0 == 0
			x0 = 0;
			x1 = e1;
			distance = abs(y1 - e1);
		}
	}
	else { // y1 == 0
		const Type
			numer0 = e0*y0,
			denom0 = sqr(e0) - sqr(e1);

		if( numer0 < denom0 ) {
			const Type xde0 = numer0/denom0;
			x0 = e0*xde0;
			x1 = e1*sqrt(1 - sqr(xde0));
			distance = sqrt(sqr(x0-y0)+sqr(x1));
		}
		else {
			x0 = e0;
			x1 = 0;
			distance = abs(y0-e0);
		}
	}

	return distance;
}

// for testing
double distancePointEllipsed(const double e0, const double e1, const double y1, const double y2, out double x0, out double x1) {
  return distancePointEllipse(e0, e1, y1, y2, x0, x1);
}

// computes the length of the input vector v0, v1, v2 by avoiding floating-point overflow that could occur normally
// described at http://www.geometrictools.com/Documentation/DistancePointEllipseEllipsoid.pdf  page 20
private Real robustLength(Real)(const Real v0, const Real v1, const Real v2) {
	const real maxValue = cast(Real)fmax(abs(v0), cast(Real)fmax(abs(v1), abs(v0)));

	if( abs(v0) == maxValue ) {
		return abs(v0)*sqrt(cast(Real)1 + sqr(v1/v0) + sqr(v2/v0));
	}
	else if( abs(v1) == maxValue ) {
		return abs(v1)*sqrt(sqr(v0/v1) + cast(Real)1 + sqr(v2/v1));
	}
	else { // |v_2] = max{...}
		return abs(v2)*sqrt(sqr(v0/v2) + sqr(v1/v2) + cast(Real)1);
	}
}

private Real getRoot(Real)(const Real r0, const Real r1, const Real z0, const Real z1, const Real z2, Real g) {
	enum maxIterations = Real.dig - Real.min_exp; // as described in http://www.geometrictools.com/Documentation/DistancePointEllipseEllipsoid.pdf  page 8

	const Real
		n0 = r0*z0,
		n1 = r1*z1;

	Real
		s0 = z1 - 1,
		s1 = (g < 0 ? 0 : robustLength(n0, n1, z2)-1),
		s = 0;

	foreach( i; 0..maxIterations ) {
		s = (s0+s1)/2;
		if( s == s0 || s == s1 ) {
			break;
		}
		const Real
			ratio0 = n0/(s+r0),
			ratio1 = n1/(s+r1),
			ratio2 = z2/(s+1);
		g = sqr(ratio0)+sqr(ratio1)+sqr(ratio2)-1;
		if( g > 0 ) {
			s0 = s;
		}
		else if( g < 0 ) {
			s1 = s;
		}
		else {
			break;
		}
	}

	return s;
}

// http://www.geometrictools.com/Documentation/DistancePointEllipseEllipsoid.pdf
// page 19
// LICENSE< unknown! >
Real distancePointEllipsoid(Real)(const Real e0, const Real e1, const Real e2, const Real y0, const Real y1, const Real y2, out Real x0, out Real x1, out Real x2) 
in {
	assert(e0 >= e1 && e1 >= e2 && e2 > 0);
	assert(y0 >= 0);
	assert(y1 >= 0);
	assert(y2 >= 0);
}
body {
	Real distance;
	if( y2 > 0 ) {
		if( y1 > 0 ) {
			if( y0 > 0 ) {
				const Real
					z0 = y0/e0,
					z1 = y1/e1,
					z2 = y2/e2,
					g = sqr(z0)+sqr(z1)+sqr(z2)-1;

				if( g != 0 ) {
					const Real
						r0 = sqr(e0/e2),
						r1 = sqr(e1/e2),
						sbar = getRoot(r0, r1, z0, z1, z2, g);

					x0 = r0*y0/(sbar+r0);
					x1 = r1*y1/(sbar+r1);
					x2 = y2/(sbar + 1);
					distance = sqrt(sqr(x0-y0) + sqr(x1 - y1));
				}
				else {
					x0 = y0;
					x1 = y1;
					x2 = y2;
					distance = 0;
				}
			}
			else {  // y0 == 0
				x0 = 0;
				distance = distancePointEllipse(e1, e2, y1, y2, x1, x2);
			}
		}
		else { // y1 == 0
			if( y0 > 0 ) {
				x1 = 0;
				distance = distancePointEllipse(e0, e2, y0, y2, x0, x2);
			}
			else { // y0 == 0
				x0 = 0;
				x1 = 0;
				x2 = e2;
				distance = abs(y2-e2);
			}
		}
	}
	else { // y2 == 0
		const Real
			denom0 = e0*e0 - e2*e2,
			denom1 = e1*e1 - e2*e2,
			numer0 = e0*y0,
			numer1 = e1*y1;

		bool computed = false;
		if( numer0 < denom0 && numer1 < denom1 ) {
			// GUESS< PtrMan thinks that ey0 and ey1 are the products, not sure, could be a typo in the pdf >
			const Real
				ey0 = e0*y0,
				ey1 = e1*y1;

			const Real
				xde0 = ey0/denom0,
				xde1 = ey1/denom1,
				xde0sqr = sqr(xde0),
				xde1sqr = sqr(xde1),
				discr = 1 - xde0sqr - xde1sqr;

			if( discr > 0 ) {
				x0 = e0*xde0;
				x1 = e1*xde1;
				x2 = e2*sqrt(discr);
				distance = sqrt(sqr(x0-y0)+sqr(x1-y1)+sqr(x2));
				computed = true;
			}
		}

		if( !computed ) {
			x2 = 0;
			// NOTE< other variables are missing for this case, fix this! >
			distance = distancePointEllipse(e0, e1, y0, y1, x0, x1);
		}
	}
	return distance;
}

double distancePointEllipsoidTest(const double e0, const double e1, const double e2, const double y0, const double y1, const double y2, out double x0, out double x1, out double x2)  {
	return distancePointEllipsoid(e0, e1, e2, y0, y1, y2, x0, x1, x2);
}
