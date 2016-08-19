

// see https://en.wikipedia.org/wiki/Hohmann_transfer_orbit

// import celestialMathematics.Constants;

//#include "CelestialMathematics/HohmannTransfer.h"
//#include "CelestialMathematics/Constants.h"

import std.math : sqrt;

struct HohmannTransfer {
    static double hohmannTransferDeltaV1(const double centerMass, const double r1, const double r2) {
        const double mu = Constants.GravitationalConstant * centerMass;

        const double temp1 = sqrt(mu/r1);
        const double temp2 = sqrt((2.0*r2)/(r1+r2))-1.0;

        return temp1*temp2;
    }

    static double hohmannTransferDeltaV2(const double centerMass, const double r1, const double r2) {
        const double mu = Constants.GravitationalConstant * centerMass;

        const double temp1 = sqrt(mu/r2);
        const double temp2 = 1.0 - sqrt((2.0*r1)/(r1+r2));

        return temp1*temp2;
    }
}
