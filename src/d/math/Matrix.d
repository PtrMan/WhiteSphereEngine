module math.Matrix;

import math.NumericSpatialVectors;

// TODO< for more than two dimensions! >
template Matrix(DataType, uint width, uint height) if (width >= 1 && height >= 1) {
	class Matrix {
		final this() {
		}

		final this(DataType[width*height] content ...) {
			this.data = SpatialVectorStruct!(width*height, DataType, false).make(content);
		}
		
		final DataType opIndexAssign(DataType value, size_t row, size_t column) {
			return data[row*width + column] = value;
		}
		
		final DataType opIndex(size_t row, size_t column) const {
			return data[row*width + column];
		}

		final DataType opIndexOpAssign(string op)(DataType rhs, size_t row, size_t column) {
			static if (op == "+") {
				return data[row*width + column] += rhs;
			}
			else static if (op == "-") {
				return data[row*width + column] -= rhs;
			}
			else static if (op == "*") {
				return data[row*width + column] *= rhs;
			}
			else static if (op == "/") {
				return data[row*width + column] /= rhs;
			}
			else {
				static assert(0, "Operator "~op~" not implemented");
			}
		}
		
		/* uncommented because ptr is not anymore supported by the SpatialVector, because it can be stored as simd or nonsimd array
		final public @property Type* ptr() {
			return data.ptr;
		}
		*/

		
		private SpatialVectorStruct!(width*height, DataType, false) data;
		
		enum RAWDATALENGTH = width*height;
		alias Type = DataType;
	}
}

Matrix!(Datatype, size, size) diagonal(Datatype, uint size)(Datatype[size] parameters ...) {
	alias Matrix!(Datatype, size, size) MatrixType;

	MatrixType result = makeNull!(Datatype, size, size);
	foreach( i, iterationParameter; parameters ) {
		result[i, i] = iterationParameter;
	}

	return result;
}

Matrix!(Datatype, width, height) makeNull(Datatype, uint width, uint height)() {
	Matrix!(Datatype, width, width) result = new Matrix!(Datatype, width, width)();

	foreach( row; 0..height ) {
		foreach( column; 0..width ) {
			result[row, column] = 0;
		}
	}

	return result;
}
