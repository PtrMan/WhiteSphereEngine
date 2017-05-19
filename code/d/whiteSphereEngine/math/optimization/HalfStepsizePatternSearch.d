module whiteSphereEngine.math.optimization.HalfStepsizePatternSearch;

import std.math : fmin;


// helpers
private Real[Size] add(Real, uint Size)(Real[Size] a, Real[Size] b) {
    Real[Size] result;
    foreach( i; 0..Size ) {
        result[i] = a[i] + b[i];
    }
    return result;
}

private Real[Size] sub(Real, uint Size)(Real[Size] a, Real[Size] b) {
    Real[Size] result;
    foreach( i; 0..Size ) {
        result[i] = a[i] - b[i];
    }
    return result;
}

private Real[Size] scale(Real, uint Size)(Real[Size] a, Real b) {
    Real[Size] result;
    foreach( i; 0..Size ) {
        result[i] = a[i] * b;
    }
    return result;
}


// algorithm as described in the wikipedia article
// https://en.wikipedia.org/wiki/Pattern_search_(optimization)#cite_note-davidon91variable-2
Real[NumberOfDimensions] halfStepsizePatternSearch(Real, uint NumberOfDimensions)(Real delegate(Real[NumberOfDimensions] coordinate) evaluate, const Real[NumberOfDimensions] initialCenter, const Real initialStepsize, const size_t maxIterations = -1) if (NumberOfDimensions > 0) {
	alias Real[NumberOfDimensions] VectorType;

	import std.stdio; // for debugging
	writeln("ENTER halfStepsizePatternSearch()");
	scope(exit) writeln("EXIT halfStepsizePatternSearch()");


	Real stepsize = initialStepsize;
	VectorType center = initialCenter;

	Real centerSample;
	Real[2][NumberOfDimensions] neighborhoodSamples;

	static VectorType makeBaseVector(uint dimension) {
		VectorType result;
		foreach( i; 0..NumberOfDimensions ) {
			result[i] = 0;
		}
		result[dimension] = 1;
		return result;
	}

	void sampleNeighborhood() {
		foreach( dimension; 0..NumberOfDimensions ) {
			VectorType plus = add(center, scale(makeBaseVector(dimension), stepsize)), minus = sub(center, scale(makeBaseVector(dimension), stepsize));

			neighborhoodSamples[dimension][0] = evaluate(minus);
			neighborhoodSamples[dimension][1] = evaluate(plus);

			writeln("sampleNeighborhood() - = ", neighborhoodSamples[dimension][0]);
			writeln("sampleNeighborhood() + = ", neighborhoodSamples[dimension][1]);
		}
	}

	void sampleCenter() {
		centerSample = evaluate(center);
	}

	void halfStepsize() {
		stepsize *= 0.5;
	}

	void moveToMinimum() {
		uint minimumDimension = 0, minimumDirection = 0;
		Real minimumValue = neighborhoodSamples[minimumDimension][minimumDirection];

		foreach( iterationDimension; 0..NumberOfDimensions ) {
			foreach( iterationDirection; 0..2 ) {
				Real compareValue = neighborhoodSamples[iterationDimension][iterationDirection];
				if( compareValue < minimumValue ) {
					minimumValue = compareValue;
					minimumDimension = iterationDimension;
					minimumDirection = iterationDirection;
				}
			}
		}
	}

	Real calcMinimumOfNeighorSamples() {
		uint minimumDimension = 0, minimumDirection = 0;
		Real minimumValue = neighborhoodSamples[minimumDimension][minimumDirection];

		foreach( iterationDimension; 0..NumberOfDimensions ) {
			foreach( iterationDirection; 0..2 ) {
				minimumValue = fmin(minimumValue, neighborhoodSamples[iterationDimension][iterationDirection]);
			}
		}

		return minimumValue;
	}

	bool isCenterMinimum() {
		return centerSample < calcMinimumOfNeighorSamples();
	}

	bool terminate() {
		// TODO< check precision >
		return false;
	}

	foreach( iteration; 0..maxIterations ) {
		sampleCenter();
		sampleNeighborhood();
		moveToMinimum();

		if( isCenterMinimum() ) {
			halfStepsize();
		}
		if( terminate() ) {
			break;
		}
	}

	return center;
}

