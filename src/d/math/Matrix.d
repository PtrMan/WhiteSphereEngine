module math.Matrix;

import math.NumericSpatialVectors;

// TODO< for more than two dimensions! >
template Matrix(Type, uint width, uint height) {
	class Matrix {
		public this() {
			data = new SpatialVector!(width*height, Type, false)();
		}

		public final Type opIndexAssign(Type value, size_t row, size_t column) {
			return data.data[row*width + column] = value;
		}

		public final Type opIndex(size_t row, size_t column) {
			return data.data[row*width + column];
		}

		private SpatialVector!(width*height, Type, false) data;
	}
}
