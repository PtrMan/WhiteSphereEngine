#define _USE_MATH_DEFINES
#include <cmath>
#include <complex>

#include "math/Math.h"


using namespace std;


// debug
//#include <iostream>
//using namespace std;




// Numerical recipes in Fortran 77 : the art of scientific computing 1992
// page 179
// helper function
template<typename NumericType>
void calcQandRfor3thOrderForReal(NumericType a, NumericType b, NumericType c, NumericType &Q, NumericType &R) {
	Q = (a*a - static_cast<NumericType>(3)*b) / static_cast<NumericType>(9),
	R = (static_cast<NumericType>(2)*a*a*a - static_cast<NumericType>(9)*a*b + static_cast<NumericType>(27)*c) / static_cast<NumericType>(54);
}

// Numerical recipes in Fortran 77 : the art of scientific computing 1992
// page 179
template<typename NumericType>
bool solve3thOrderForReal(NumericType aParameter, NumericType bParameter, NumericType cParameter, NumericType dParameter, NumericType (&solutions)[3]) {
	// translate into the form x^3 + ax^2 + bx + c = 0
	NumericType
		a = bParameter / aParameter,
		b = cParameter / aParameter,
		c = dParameter / aParameter;

	NumericType Q, R;
	calcQandRfor3thOrderForReal(a, b, c, Q, R);

	if( R*R < Q*Q*Q ) {
		// cubic equation has three roots
		NumericType phi = acos(R/sqrt(Q*Q*Q));

		solutions[0] = static_cast<NumericType>(-2)*sqrt(Q)*cos(phi/static_cast<NumericType>(3)) - a/static_cast<NumericType>(3);
		solutions[1] = static_cast<NumericType>(-2)*sqrt(Q)*cos((phi + static_cast<NumericType>(2.0*M_PI))/static_cast<NumericType>(3)) - a/static_cast<NumericType>(3);
		solutions[2] = static_cast<NumericType>(-2)*sqrt(Q)*cos((phi - static_cast<NumericType>(2.0*M_PI))/static_cast<NumericType>(3)) - a/static_cast<NumericType>(3);

		return true;
	}
	return false;
}

// Numerical recipes in Fortran 77 : the art of scientific computing 1992
// page 179
template<typename NumericType>
void solve3thOrderForRealForComplexResult(NumericType aParameter, NumericType bParameter, NumericType cParameter, NumericType dParameter, NumericType &realSolution, complex<NumericType> (&complexSolutions)[2]) {
	// translate into the form x^3 + ax^2 + bx + c = 0
	NumericType
		a = bParameter / aParameter,
		b = cParameter / aParameter,
		c = dParameter / aParameter;

	NumericType Q, R;
	calcQandRfor3thOrderForReal(a, b, c, Q, R);

	if( R*R < Q*Q*Q ) {
		// cubic equation has three roots
		NumericType phi = acos(R/sqrt(Q*Q*Q));

		realSolution = static_cast<NumericType>(-2)*sqrt(Q)*cos(phi/static_cast<NumericType>(3)) - a/static_cast<NumericType>(3);
		complexSolutions[0] = complex<NumericType>(static_cast<NumericType>(-2)*sqrt(Q)*cos((phi + static_cast<NumericType>(2.0*M_PI))/static_cast<NumericType>(3)) - a/static_cast<NumericType>(3));
		complexSolutions[1] = complex<NumericType>(static_cast<NumericType>(-2)*sqrt(Q)*cos((phi - static_cast<NumericType>(2.0*M_PI))/static_cast<NumericType>(3)) - a/static_cast<NumericType>(3));
		return;
	}

	
	NumericType A = -static_cast<NumericType>(sgn(R))*pow(abs(R) + sqrt(R*R - Q*Q*Q), static_cast<NumericType>(1.0/3.0));
	
	NumericType B;
	if( A == static_cast<NumericType>(0) ) {
		B = static_cast<NumericType>(0);
	}
	else {
		B = Q/A;
	}

	realSolution = (A + B) - a / static_cast<NumericType>(3);

	complexSolutions[0] = complex<NumericType>(static_cast<NumericType>(-1.0/2.0)*(A + B) - a / static_cast<NumericType>(3), static_cast<NumericType>(sqrt(3.0)/2.0)*(A - B));
	complexSolutions[1] = complex<NumericType>(static_cast<NumericType>(-1.0/2.0)*(A + B) - a / static_cast<NumericType>(3), static_cast<NumericType>(-sqrt(3.0)/2.0)*(A - B));
}


// http://math.stackexchange.com/a/57688
// https://problemasteoremas.wordpress.com/2010/05/20/resolucao-da-equacao-do-4-%C2%BA-grau-ou-quartica/
// the formula from math.stackexchange for B is completly wrong, took it from the original post the author linked
template<typename NumericType>
bool solve4thOrderForReal(NumericType a, NumericType b, NumericType c, NumericType d, NumericType e, NumericType (&solutions)[4]) {
	// variable renaming
	NumericType
		alpha = a,
		beta = b,
		gamma = c,
		delta = d,
		epsilon = e;

	//DEBUG cout << "alpha " << alpha << endl;
	//DEBUG cout << "beta " << beta  << endl;
	//DEBUG cout << "gamma " << gamma  << endl;
	//DEBUG cout << "delta " << delta  << endl;
	//DEBUG cout << "epsilon " << epsilon  << endl;

	NumericType
		A = gamma/alpha - (static_cast<NumericType>(3)*beta*beta) / (static_cast<NumericType>(8)*alpha*alpha),
		B = delta/alpha - (beta*gamma)/(static_cast<NumericType>(2)*alpha*alpha) + (beta*beta*beta)/(static_cast<NumericType>(8)*alpha*alpha*alpha),
		C = epsilon/alpha - (beta*delta)/(static_cast<NumericType>(4)*alpha*alpha) + (beta*beta*gamma)/(static_cast<NumericType>(16)*alpha*alpha*alpha) - (static_cast<NumericType>(3)*beta*beta*beta*beta)/(static_cast<NumericType>(256)*alpha*alpha*alpha*alpha);

	// lets solve the s cubic equation
	NumericType
		cubicA = static_cast<NumericType>(8),
		cubicB = static_cast<NumericType>(-4)*A,
		cubicC = static_cast<NumericType>(-8)*C,
		cubicD = static_cast<NumericType>(4)*A*C - B*B;

	NumericType cubicRealSolution;
	complex<NumericType> cubicComplexSolutions[2];
	solve3thOrderForRealForComplexResult(
		cubicA, // a
		cubicB, // b
		cubicC, // c
		cubicD, // d
		cubicRealSolution,
		cubicComplexSolutions
	);

	//DEBUG cout << "A "<< A << endl;
	//DEBUG cout << "B "<< B << endl;
	//DEBUG cout << "C "<< C << endl;

	//DEBUG cout << "a " << cubicA << endl;
	//DEBUG cout << "b " << cubicB << endl;
	//DEBUG cout << "c " << cubicC << endl;
	//DEBUG cout << "d " << cubicD << endl;


	NumericType s = cubicRealSolution; // we just take the real solution

	//DEBUG cout << s << endl;

	NumericType sqrt2sMinusAInSqrt = static_cast<NumericType>(2)*s - A;
	// if this is not real then the solutions aren't propably too
	if( sqrt2sMinusAInSqrt < static_cast<NumericType>(0) ) {
		return false;
	}

	NumericType sqrt2sMinusA = sqrt(sqrt2sMinusAInSqrt);


	NumericType precalculatedBigPlusSquared = -static_cast<NumericType>(2)*s - A + ((static_cast<NumericType>(2)*B)/sqrt2sMinusA);
	// if this is not real then the solutions aren't propably too
	if( precalculatedBigPlusSquared < static_cast<NumericType>(0) ) {
		return false;
	}

	NumericType precalculatedBigPlus = sqrt(precalculatedBigPlusSquared);


	NumericType precalculatedBigMinusSquared = -static_cast<NumericType>(2)*s - A - ((static_cast<NumericType>(2)*B)/sqrt2sMinusA);
	// if this is not real then the solutions aren't propably too
	if( precalculatedBigMinusSquared < static_cast<NumericType>(0) ) {
		return false;
	}

	NumericType precalculatedBigMinus = sqrt(precalculatedBigMinusSquared);



	NumericType
		y1 = static_cast<NumericType>(-1.0/2.0)*sqrt2sMinusA + static_cast<NumericType>(1.0/2.0)*precalculatedBigPlus,
		y2 = static_cast<NumericType>(-1.0/2.0)*sqrt2sMinusA - static_cast<NumericType>(1.0/2.0)*precalculatedBigPlus,
		y3 = static_cast<NumericType>( 1.0/2.0)*sqrt2sMinusA + static_cast<NumericType>(1.0/2.0)*precalculatedBigMinus,
		y4 = static_cast<NumericType>( 1.0/2.0)*sqrt2sMinusA - static_cast<NumericType>(1.0/2.0)*precalculatedBigMinus;
	
	solutions[0] = y1 - beta/(static_cast<NumericType>(4.0)*alpha);
	solutions[1] = y2 - beta/(static_cast<NumericType>(4.0)*alpha);
	solutions[2] = y3 - beta/(static_cast<NumericType>(4.0)*alpha);
	solutions[3] = y4 - beta/(static_cast<NumericType>(4.0)*alpha);

	return true;
}
