import whiteSphereEngine.sound.dsp.FastOscillator;

// TODO< move into math >
float pow2(float x) {
    return x*x;
}


// calculates sinus "rotations" with my (PtrMan/Square) DSP math trick
// I couldn't find this trick in any DSP resource
// the trick is to just take a (sually normalized) vector and rotate it with its own tangent

// length is how far it gets rotated
private void calc(float *xParameter, float *yParameter, float *lengthParameter, float *xNextParameter, float *yNextParameter, float *normalizationFactorParameter, size_t length) {
	align(64) float *x = xParameter;
	align(64) float *y = yParameter;
	align(64) float *length = lengthParameter;
	align(64) float *xNext = xNextParameter;
	align(64) float *yNext = yNextParameter;
	align(64) float *normalizationFactor = normalizationFactorParameter;
	
	foreach( i; 0..length ) {
		float
			tangentX = x[i] * length[i],
			tangentY = y[i] * -length[i];

		xNext[i] = (x[i]) + tangentX) * normalizationFactor[i];
		yNext[i] = (y[i]) + tangentY) * normalizationFactor[i];
	}
}


import std.math;
import std.stdio;



// TODO< move into AlignedMemory.d or something
import whiteSphereEngine.memory.AlignedMemory;



void main(string[] args) {
	AlignedMemory* xAligned, yAligned, lengthAligned, xNextAligned, yNextAligned, normalizationFactorAligned;

	xAligned = new AlignedMemory;
	xAligned.malloc(1, float.sizeof);
	scope(exit) xAligned.free();

	yAligned = new AlignedMemory;
	yAligned.malloc(1, float.sizeof);
	scope(exit) yAligned.free();

	lengthAligned = new AlignedMemory;
	lengthAligned.malloc(1, float.sizeof);
	scope(exit) lengthAligned.free();

	xNextAligned = new AlignedMemory;
	xNextAligned.malloc(1, float.sizeof);
	scope(exit) xNextAligned.free();

	yNextAligned = new AlignedMemory;
	yNextAligned.malloc(1, float.sizeof);
	scope(exit) yNextAligned.free();

	normalizationFactorAligned = new AlignedMemory;
	normalizationFactorAligned.malloc(1, float.sizeof);
	scope(exit) normalizationFactorAligned.free();

	xAligned.ptr!float[0] = 1.0f;
	yAligned.ptr!float[0] = 0.0f;
	lengthAligned.ptr!float[0] = 0.8f; // length of rotation
    normalizationFactorAligned.ptr!float[0] = 1.0f/sqrt(pow2(xAligned.ptr!float[0]+yAligned.ptr!float[0]*length) + pow2(yAligned.ptr!float[0]-xAligned.ptr!float[0]*length));
    





	for( uint i = 0; i < 100000; i++ ) {
		/*
		old "slow" working code

		float
			tangentX = y * length,
			tangentY = x * -length;
        
		x = (x + tangentX) * normalsationFactor;
		y = (y + tangentY) * normalsationFactor;
		
		if( i % (1 << 12) == 0 ) { // must be power of two because the test is supercheap
			double length2 = sqrt(x*x + y*y);
			x /= length2;
			y /= length2;
		}
		*/

		// TODO< pointer ping pong >
		calc(xAligned.ptr!float, yAligned.ptr!float, lengthAligned.ptr!float, xNextAligned.ptr!float, yNextAligned.ptr!float, normalizationFactorAligned.ptr!float, 1);

        
		//writeln(x, "  ", y, " ", sqrt(pow2(x) + pow2(y)));
	}


	//writeln(sqrt(pow2(x)+pow2(y)));
}
