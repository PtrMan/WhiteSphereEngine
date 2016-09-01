module math.Matrix;

import math.NumericSpatialVectors;

// TODO< for more than two dimensions! >
template Matrix(DataType, uint width, uint height) if (width > 1 && height > 1) {
	class Matrix {
		public this() {
			data = new SpatialVector!(width*height, DataType, false)();
		}
		
		public this(DataType[width*height] content ...) {
			this.data = new SpatialVector!(width*height, DataType, false)(content);
		}
		
		public final DataType opIndexAssign(DataType value, size_t row, size_t column) {
			return data.data[row*width + column] = value;
		}
		
		public final DataType opIndex(size_t row, size_t column) {
			return data.data[row*width + column];
		}

		final DataType opIndexOpAssign(string op)(DataType rhs, size_t row, size_t column) {
			static if (op == "+") {
				return data.data[row*width + column] += rhs;
			}
			else static if (op == "-") {
				return data.data[row*width + column] -= rhs;
			}
			else static if (op == "*") {
				return data.data[row*width + column] *= rhs;
			}
			else static if (op == "/") {
				return data.data[row*width + column] /= rhs;
			}
			else {
				static assert(0, "Operator "~op~" not implemented");
			}
		}
		
		final public @property Type* ptr() {
			return data.ptr;
		}

		
		private SpatialVector!(width*height, DataType, false) data;
		
		public enum RAWDATALENGTH = width*height;
		public alias Type = DataType;
	}
}
