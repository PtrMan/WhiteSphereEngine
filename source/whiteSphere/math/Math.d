
// first simple algorithm  https://en.wikipedia.org/wiki/Exponentiation_by_squaring
template<typename T>
T expBySquaringIterative(T x, int n) {
    if (n < 0) {
      x = 1 / x;
      n = -n;
    }
    if (n == 0) {
      return 1;
    }
    int y = 1;
  
    while (n > 1) {
      if ((n % 2) == 0) { 
        x = x * x;
        n = n / 2;
      }
      else {
        y = x * y;
        x = x * x;
        n = (n - 1) / 2;
      }
    }
    return x * y;
}



#include <cmath>
#include <algorithm>


// from http://stackoverflow.com/questions/18662261/fastest-implementation-of-sine-cosine-and-square-root-in-c-doesnt-need-to-b/28050328#28050328
// valid for (-pi, pi)

template<typename T>
T fastCos(T x) {
    /*constexpr*/ T tp = 1./(2.*M_PI);
    x *= tp;
    x -= T(.25) + std::floor(x + T(.25));
    x *= T(16.) * (std::abs(x) - T(.5));
    #if EXTRA_PRECISION
    x += T(.225) * x * (std::abs(x) - T(1.));
    #endif
    return x;
}

// TODO< check if it calculates it correctly >
template<typename T>
T fastSin(T x) {
	return fastCos(x + (T)(M_PI*0.5));
}

// function which calculates the sinus and the cosinus with the trigonometric identity and some if's

// valid for (-pi, pi)
// https://en.wikipedia.org/wiki/List_of_trigonometric_identities#Pythagorean_identity
template<typename T>
void fastSinCos(T angle, T &sinResult, T &cosResult) {
	sinResult = fastSin(angle);
	T cosResultTemp = sqrt(-(sinResult*sinResult - 1.0));

	if( abs(angle) <= M_PI/2.0 ) {
		cosResult = cosResultTemp;
	}
	else {
		cosResult = -cosResultTemp;
	}
}

/*
void testFastSinCos(double angle, double &sinResult, double &cosResult) {
	fastSinCos(angle, sinResult, cosResult);
}
*/