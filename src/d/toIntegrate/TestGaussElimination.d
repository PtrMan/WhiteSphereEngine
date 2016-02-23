import GaussElimination;

import std.stdio;

void main(string[] args) {
	Matrix!(float, 4, 3) matrix = new Matrix!(float, 4, 3)();

	// example from wikipedia
	matrix[0, 0] = 2.0f;
	matrix[0, 1] = 1.0f;
	matrix[0, 2] = -1.0f;
	matrix[0, 3] = 8.0f;

	matrix[1, 0] = -3.0f;
	matrix[1, 1] = -1.0f;
	matrix[1, 2] = 2.0f;
	matrix[1, 3] = -11.0f;

	matrix[2, 0] = -2.0f;
	matrix[2, 1] = 1.0f;
	matrix[2, 2] = 2.0f;
	matrix[2, 3] = -3.0f;


	standardGaussElimination!(float, 4, 3)(matrix);

	for( int row = 0; row < 3; row++ ) {
		for( int column = 0; column < 4; column++ ) {
			write(matrix[row, column], " ");
		}

		writeln("");
	}
}
