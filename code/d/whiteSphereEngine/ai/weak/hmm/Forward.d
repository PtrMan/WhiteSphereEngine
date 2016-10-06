module whiteSphereEngine.ai.weak.hmm.Forward;

import common.ValueMatrix;

// HMM forward algorithm
// see https://web.stanford.edu/~jurafsky/slp3/8.pdf
// SQUARE< or my notes and stuff from the TU dresden >

// calculates likelihood of a given (observation) sequence

// v is the vector of the observation sequence
// e is the observation/emission propability
// t is the transition propability matrix

// entry and exit propabilities are the propabilities for entering and exiting into/from the start and endstates

PropabilityType forward(PropabilityType)(uint[] v, ValueMatrix!PropabilityType e, ValueMatrix!PropabilityType t, PropabilityType[] entryPropability, PropabilityType[] exitPropability) {
	assert(t.width == t.height); // has to be the way because each state can potentially transistion to any other one

	const uint n = v.length; // n is the length of the sequence
	const uint numberOfStatesInQ = t.width;

	ValueMatrix!PropabilityType T = new ValueMatrix!PropabilityType(n, numberOfStatesInQ);

	foreach( q; 0..numberOfStatesInQ ) {
		T[0, q] = e[v[0], q]*entryPropability[q];
	}

	foreach( t2; 1..n ) {
		foreach( q; 0..numberOfStatesInQ ) {
			PropabilityType propabilitySum = 0;
			foreach( qTick; 0..numberOfStatesInQ ) {
				propabilitySum += (t[q, qTick]*T[t2-1, qTick]);
			}

			T[t2, q] = e[v[t2], q] * propabilitySum;
		}
	}

	// calculate the propability of the sequence
	{
		PropabilityType result = 0;
		foreach( q; 0..numberOfStatesInQ ) {
			result += (exitPropability[q]*T[n-1, q]);
		}
		return result;
	}
}
