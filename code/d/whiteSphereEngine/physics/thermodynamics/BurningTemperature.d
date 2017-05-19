module whiteSphereEngine.physics.thermodynamics.BurningTemperature;

import std.range.primitives : isInputRange;

// TODO< move to math >
private ScalarType dot(ScalarType, RangeA, RangeB)(RangeA a, RangeB b) if (isInputRange!RangeA && isInputRange!RangeB) {
	ScalarType sum = cast(ScalarType)0;

	for(;;) {
		if( a.empty ) {
			assert(b.empty);
			return sum;
		}

		sum += (a.front * b.front);
		a.popFront;
		b.popFront;
	}
}

import std.algorithm.iteration : map;
import std.array : empty, front, popFront;

float calcEnergy(uint[] mole, float[] enthalpyOfFormation) {
	return dot!float(mole.map!(s => cast(float)s), enthalpyOfFormation);
}

// http://web.mit.edu/16.unified/www/FALL/thermodynamics/notes/node111.html

float buringDeltaTemperature(uint[] burningProductsMole, float[] buringProductsEnthalpyOfFormation,  uint reactantsMole, float reactantEnthalpyOfFormation,  uint[] combustionProductsMole, float[] combustionProductsSpecificHeat) {
	uint[1] reactantsMoleArr = [reactantsMole];
	float[1] reactantEnthalpyOfFormationArr = [reactantEnthalpyOfFormation];

	// we calculate the delta energy of the buring reaction
	float deltaEnergy = -( calcEnergy(burningProductsMole, buringProductsEnthalpyOfFormation) - calcEnergy(reactantsMoleArr, reactantEnthalpyOfFormationArr));
	assert(deltaEnergy > 0.0f);

	// now we calculate delta-tmperature, based on the first method called
	// "Approximate solution using ``average'' values of specific heat"

	float averageSpecificHeat = dot!float(combustionProductsMole.map!(s => cast(float)s), combustionProductsSpecificHeat);

	return deltaEnergy / averageSpecificHeat;
}
