import whiteSphereEngine.ai.weak.hmm.Forward;

// test
void main() {
	uint numberOfStatesInQ = 3;

	ValueMatrix!float e = new ValueMatrix!float(2, numberOfStatesInQ);
	foreach( i; 0..2 ) foreach( j; 0..numberOfStatesInQ ) {
		e[i, j] = 0.0f;
	}

	e[0, 0] = 0.5f;
	e[1, 0] = 0.5f;

	e[0, 1] = 0.7f;
	e[1, 1] = 0.3f;



	ValueMatrix!float t = new ValueMatrix!float(numberOfStatesInQ, numberOfStatesInQ);
	foreach( i; 0..numberOfStatesInQ ) foreach( j; 0..numberOfStatesInQ ) {
		t[i, j] = 0.0f;
	}

	t[0, 0] = 0.0f;
	t[1, 0] = 1.0f;
	t[1, 1] = 1.0f;
	
	//t[0, 1] = 0.5f;
	//t[0, 2] = 0.5f;


	uint[] v = [0, 1, 1];

	float[] entryPropability = [1.0f, 0.0f, 0.0f];
	float[] exitPropability = [0.5f, 0.1f, 1.0f];

	float propability = forward!float(v, e, t, entryPropability, exitPropability);

	import std.stdio;
	writeln("p=", propability);
}
