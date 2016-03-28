module GaussElimination;

import math.Matrix : Matrix;

// modifies the table
void gaussElimination(Type, uint width, uint height, StepType, bool withGaussJordan = true)(Matrix!(Type, width, height) matrix) {
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
			rowOperation(iterationRow, kRow);
		}
	}

	// calculate result matrix
	// this is the extension called gauss-jordan elimination
	if( withGaussJordan ) {
		void multipleRowBy(uint row, Type value) {
			foreach( i; 0..width ) {
				matrix[row, i] = matrix[row, i] * value;
			}
		}
		
		foreach_reverse( bottomRow; 0..height ) {
			multipleRowBy(bottomRow, cast(Type)1.0 / matrix[bottomRow, bottomRow]);
			
			foreach( iterationRow; 0..bottomRow ) {
				rowOperation(bottomRow, iterationRow);
			}
		}
	}
}

template DefaultStep(Type, uint width, uint height) {
	struct DefaultStep {
		public static doOperationForRowsAndColumn(Matrix!(Type, width, height) matrix, uint iRow, uint kRow, uint j) {
			Type divFactor = matrix[kRow, iRow] / matrix[iRow, iRow];
			matrix[kRow, j] = matrix[kRow, j] - divFactor*matrix[iRow, j];			
		}
	}
}

void standardGaussElimination(Type, uint width, uint height)(Matrix!(Type, width, height) matrix) {
	gaussElimination!(Type, width, height, DefaultStep!(Type, width, height))(matrix);
}
