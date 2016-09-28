module math.ConvertMatrix;

import linopterixed.linear.Matrix;

void translateToArray(ScalarType, uint width, uint height)(Matrix!(ScalarType, width, height) matrix, ref ScalarType[16] arr) {
	foreach( i; 0..width ) {
		foreach( j; 0..height ) {
			arr[width*i + j] = matrix[i, j];
		}
	}
}
