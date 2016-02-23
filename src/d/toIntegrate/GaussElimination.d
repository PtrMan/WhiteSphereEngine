module GaussElimination;

import Matrix : Matrix;

// modifies the table
void gaussElimination(Type, uint width, uint height, StepType)(Matrix!(Type, width, height) matrix) {
	void rowOperation(uint iRow, uint kRow) {
		// split into two loops because we can't touch the value at [iRow, iRow], because we divide by it

		for( uint j = 0; j < iRow; j++ ) {
			StepType.doOperationForRowsAndColumn(matrix, iRow, kRow, j);
		}

		for( uint j = iRow+1; j < width; j++ ) {
			StepType.doOperationForRowsAndColumn(matrix, iRow, kRow, j);
		}

		StepType.doOperationForRowsAndColumn(matrix, iRow, kRow, iRow);
	}

	// bring into echelon form

	foreach( uint iterationRow; 0..height ) {
		foreach( uint kRow; iterationRow+1..height ) {
			{
				import std.stdio;
				writeln("row operation for iterationRow = ", iterationRow, " kRow = ", kRow);
			}

			rowOperation(iterationRow, kRow);
		}


		{
			import std.stdio;
			writeln("MATRIX");

			for( int row = 0; row < 3; row++ ) {
				for( int column = 0; column < 4; column++ ) {
					write(matrix[row, column], " ");
				}

				writeln("");
			}

			writeln("");
		}
	}

	// calculate result matrix

	{
		import std.stdio;
		writeln("calculate result matrix");
	}
	
	// TODO

}

template DefaultStep(Type, uint width, uint height) {
	struct DefaultStep {
		public static doOperationForRowsAndColumn(Matrix!(Type, width, height) matrix, uint iRow, uint kRow, uint j) {
			Type divFactor = matrix[kRow, iRow] / matrix[iRow, iRow];

			{
				import std.stdio;

				writeln( matrix[kRow, iRow] ," / ",matrix[iRow, iRow], " = ", divFactor);
			}

			matrix[kRow, j] = matrix[kRow, j] - divFactor*matrix[iRow, j];			
		}
	}
}

void standardGaussElimination(Type, uint width, uint height)(Matrix!(Type, width, height) matrix) {
	gaussElimination!(Type, width, height, DefaultStep!(Type, width, height))(matrix);
}
