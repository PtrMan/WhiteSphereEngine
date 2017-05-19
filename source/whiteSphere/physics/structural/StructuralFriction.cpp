#include <cmath>

using namespace std;


const unsigned SIZE = 4;


struct Vector {

	double data[SIZE];

	Vector operator* (double scalar) const {
		Vector result;

		for( unsigned i = 0; i < SIZE; i++ ) {
			result.data[i] = data[i] * scalar;
		}

		return result;
	}


	Vector operator* (double scalar) {
		Vector result;

		for( unsigned i = 0; i < SIZE; i++ ) {
			result.data[i] = data[i] * scalar;
		}

		return result;
	}

	Vector operator+ (Vector &other) const {
		Vector result;

		for( unsigned i = 0; i < SIZE; i++ ) {
			result.data[i] = data[i] + other.data[i];
		}

		return result;
	}
  
  	Vector operator+ (const Vector &other) const {
		Vector result;

		for( unsigned i = 0; i < SIZE; i++ ) {
			result.data[i] = data[i] + other.data[i];
		}

		return result;
	}

	Vector operator- (const Vector &other) const {
		Vector result;

		for( unsigned i = 0; i < SIZE; i++ ) {
			result.data[i] = data[i] - other.data[i];
		}

		return result;
	}


	double getLength() const {
		return sqrt(data[0]*data[0] + data[1]*data[1] + data[2]*data[2]);
	}

	Vector getNormalized() const {
		Vector result;
		double length = getLength();
		double rlength = 1.0/length;

		return *this * rlength;
	}

	
};

struct State {
	Vector *positions;
	Vector *velocities;
	unsigned numberOfPoints;

	State operator* (double x) {
		State result;

		for( unsigned i = 0; i < numberOfPoints; i++ ) {
			result.positions[i] = positions[i] * x;
			result.velocities[i] = velocities[i] * x;
		}

		return result;
	}

	State operator+ (const State &other) {
		State result;

		for( unsigned i = 0; i < numberOfPoints; i++ ) {
			result.positions[i] = other.positions[i] + positions[i];
			result.velocities[i] = other.velocities[i] + velocities[i];
		}

		return result;
	}

};






struct Connection {
	unsigned target;
	double strength;
	double defaultDistance;
};

struct Neighbors {
	Connection *neighborConnections;
	unsigned neighborConnectionsLength;
};

void calcResponseForMassPoint(unsigned centerIndex, State state, State &result, Neighbors *neighbors) {
	Vector centerVelocity = state.velocities[centerIndex];
	Vector centerPosition = state.positions[centerIndex];

	for( unsigned neighborI = 0; neighborI < neighbors->neighborConnectionsLength; neighborI++ ) {
		unsigned target = neighbors->neighborConnections[neighborI].target;
		double strength = neighbors->neighborConnections[neighborI].strength;
		double defaultDistance = neighbors->neighborConnections[neighborI].defaultDistance;

		Vector neighborPosition = state.positions[target];

		// TODO< put into function and call the mechanic function >
		double force = ((centerPosition - neighborPosition).getLength() - defaultDistance) * strength;

		Vector normalizedDirection = (centerPosition - neighborPosition).getNormalized();

		result.velocities[centerIndex] = state.velocities[centerIndex] + normalizedDirection * force;
		result.velocities[target] = state.velocities[target] - normalizedDirection * force;
	}
}

// specific context for this solver
struct Context {
	Neighbors **neighborsOfPoints;
	unsigned numberOfPoints;
};



// t_i is delta time
// u_i is previous state
State fn(Context context,   double t_i, State u_i) {
	State result;

	/*
	double forceConstant = 1.0;

	double shouldBeDistance = 5.0;

	double force = ((u_i.positionA - u_i.positionB).getLength() - shouldBeDistance) * forceConstant;

	Vector normalizedDirection = (u_i.positionA - u_i.positionB).getNormalized();

	result.speedA = u_i.speedA + normalizedDirection * force;
	result.speedB = u_i.speedB - normalizedDirection * force;	
	*/

	for( unsigned pointI = 0; pointI < context.numberOfPoints; pointI++ ) {
		calcResponseForMassPoint(pointI, u_i, result, context.neighborsOfPoints[pointI]); 
	}


	/*
	result.positionA = u_i.positionA + u_i.speedA * t_i;
	result.positionB = u_i.positionB + u_i.speedB * t_i;
	
	TODO< iterate over all positions and add the speed up >
	*/
  
  	return result;
}



State step(double t_i, double h, State u_i, Context context) {
	State k_1 = fn(context,  t_i, u_i);
	State k_2 = fn(context,  t_i + h*0.5, u_i + k_1*h*0.5);
	State k_3 = fn(context,  t_i + h*0.5, u_i + k_2*h*0.5);
	State k_4 = fn(context,  t_i + h, u_i + k_3*h);


	State u_inext = k_1 * (1.0/6.0) + k_2 * (1.0/3.0) + k_3 * (1.0/3.0) + k_4 * (1.0/6.0);

	return u_inext;
}






#include <cmath>
using namespace std;

// see google "boltzmann constant"
const double BOLTZMANN_CONSTANT = 1.38064852e-23;

// paper "Characterization of the Internal Friction Properties of 2.25Cr-1Mo Steel"
// url https://www.jim.or.jp/journal/e/pdf3/50/09/2143.pdf
// page 3
double calcHighTemperatureInternalFriction(double T, double w, double A, double H, double n) {
	double tanHT = A * pow(w * exp(H/(BOLTZMANN_CONSTANT*T)), -n); 
	return tanHT;
}

// paper "Characterization of the Internal Friction Properties of 2.25Cr-1Mo Steel"
// url https://www.jim.or.jp/journal/e/pdf3/50/09/2143.pdf
// page 3
double calcThermoelasticInternalFriction(double T, double w, double E, double beta1, double beta2, double h) {
	double temp = beta1*w*h*h;
	double divisionPart = (w*h*h) / (1.0 + temp*temp);
	
	double tanTE = E*beta2*T*divisionPart;
	return tanTE;
}

// paper "Characterization of the Internal Friction Properties of 2.25Cr-1Mo Steel"
// url https://www.jim.or.jp/journal/e/pdf3/50/09/2143.pdf
// page 3
// calculates the internal friction (its just like a constant) of a metal sample

// T : temperature in kelvin
// w : angular frequency
// h : thickness

// E : young's modulus of sample

// H : activation energy, is a material constant
// A : material constant
// n : material constant
// beta1, beta2 : material constant

double calcInternalFriction(double T, double w, double h,  double E,  double H, double A, double n, double beta1, double beta2) {
  double tanHT = calcHighTemperatureInternalFriction(T, w, A, H, n);
  double tanTE = calcThermoelasticInternalFriction(T, w, E, beta1, beta2, h);
  return tanHT + tanTE;
}


// paper "Characterization of the Internal Friction Properties of 2.25Cr-1Mo Steel"
// url https://www.jim.or.jp/journal/e/pdf3/50/09/2143.pdf
// page 3
// hardcoded values from the paper for te steel 
// E depends nonlinearly on temperatur
// TODO< find formula for E >
double calcInternalFrictionFor_a542m_steel(double T, double w, double h,  double E) {
	return calcInternalFriction(T, w, h, E,  286.7, 7.44e3, 0.31, 1.33e4, 1.92e-13);
}


// book Springer "Internal Friction in Metallic Materials"
// page 1 formula (1.1) reodered
// W : elastic stored energy
// Qm1 : Q^1 : internal friction
double calcInternalFrictionInJoules(double W, double Qm1) {
	return Qm1 * (2.0*M_PI*W);
}


double calcInternalFrictionFor_a542m_steel_InJoules(double T, double w, double h,  double E,  double W) {
	double internalFriction = calcInternalFrictionFor_a542m_steel(T, w, h, E);
	double internalFrictionInJoules = calcInternalFrictionInJoules(W, internalFriction);
	return internalFrictionInJoules;
}



// TODO<?>
// page (pdf) 6
// stainless steal - nonlinear stress-strain curve with strain 
// https://suw.biblos.pk.edu.pl/resources/i4/i7/i8/i6/i8/r47868/TylekI_MechanicalProperties.pdf
