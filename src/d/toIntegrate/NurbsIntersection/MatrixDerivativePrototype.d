// computes D and Du matrices using gauss elimination
// see paper "a new approach for surface intersection" http://diyhpl.us/~bryan/papers2/cad/INTERSECT/papers/IJCGA.pdf
template GaussianEliminationDerivationStep(Type, uint width, uint height) {
	struct GaussianEliminationDerivationStep {
		public static doOperationForRowsAndColumn(Matrix!(Type, width, height) matrix, uint iRow, uint kRow, uint j) {
			matrix[kRow, j].value = matrix[kRow, j].value - (matrix[kRow, iRow].value / matrix[iRow, iRow].value)*matrix[iRow, j].value;

			double dividend = (matrix[kRow, iRow].derivativeU*matrix[iRow, j] + matrix[kRow, iRow].value*matrix[iRow, j].derivativeU)*matrix[iRow, iRow].value - (matrix[kRow, iRow].value*matrix[iRow, j].value)*matrix[iRow, iRow].derivativeU;
			matrix[kRow, j].derivativeU = matrix[kRow, j].derivativeU - dividend / matrix[iRow, iRow].value;
		}
	}
}

struct DandDu {
	public double value;
	public double derivativeU;
}

{
	// see paper "a new approach for surface intersection" http://diyhpl.us/~bryan/papers2/cad/INTERSECT/papers/IJCGA.pdf
	void gaussEliminationAndCalculateDandDDerivativeU() {
		gaussEliminationWithDerivationStep();

		// TODO< calculate D and Du
	}

	void gaussEliminationWithDerivationStep() {
		gaussElimination!(DandDu, 18, 18, GaussianEliminationDerivationStep!(DandDu, 18, 18))(matrix);
	}
}
