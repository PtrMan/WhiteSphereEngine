#include "Solver4thOrder.h"

/*
Quaternion<float> mul(Quaternion<float> a, Quaternion<float> &b) {
	return a.mul(b);
}

Quaternion<float> conjugate(Quaternion<float> a) {
	return a.conjugate();
}

Quaternion<float> inverse(Quaternion<float> a) {
	return a.inverse();
}
*/

#include <iostream>

using namespace std;

void main() {
	// works
	if(false)
	{
		float a, b, c, d, solutions[3];

		a = 4.0f;
		b = 1.0f;
		c = 0.0f;
		d = -0.001f;

		bool wasSolved = solve3thOrderForReal(a, b, c, d, solutions);

		if( !wasSolved ) {
			cout << "no real solution" << endl;
		}
		else {
			cout << "real solution" << endl;

			cout << solutions[0] << endl;
			cout << solutions[1] << endl;
			cout << solutions[2] << endl;
		}

	}

	// test 4th order solver for the example from the post in the description of the algorithm
	if(false)
	{
		float a, b, c, d, e, solutions[4];

		a = 1.0f;
		b = 2.0f;
		c = 3.0f;
		d = -2.0f;
		e = -1.0f;

		bool wasSolved = solve4thOrderForReal(a, b, c, d, e, solutions);

		if( !wasSolved ) {
			cout << "no real solution" << endl;
		}
		else {
			cout << "real solution" << endl;

			cout << solutions[0] << endl;
			cout << solutions[1] << endl;
			cout << solutions[2] << endl;
			cout << solutions[3] << endl;
		}

	}

	// test for own case with real solutions
	if(true) {
		float a, b, c, d, e, solutions[4];

		a = 4.0f;
		b = 1.0f;
		c = -1.0f;
		d = 0.0f;
		e = 0.001f;

		bool wasSolved = solve4thOrderForReal(a, b, c, d, e, solutions);

		if( !wasSolved ) {
			cout << "no real solution" << endl;
		}
		else {
			cout << "real solution" << endl;

			cout << solutions[0] << endl;
			cout << solutions[1] << endl;
			cout << solutions[2] << endl;
			cout << solutions[3] << endl;
		}

	}



	/*
	float a, b, c, d, e, solution1, solution2, solution3, solution4;

	// has 4 real solutions
	a = 2.0f;
	b = 4.0f;
	c = 1.0f;
	d = 0.0f;
	e = -0.001f;

	bool wasSolved = solve4thOrder(a, b, c, d, e, solution1, solution2, solution3, solution4);

	if( !wasSolved ) {
		cout << "no real solution" << endl;
	}
	else {
		cout << "real solution" << endl;

		cout << solution1 << endl;
		cout << solution2 << endl;
		cout << solution3 << endl;
		cout << solution4 << endl;
	}
	*/
}
