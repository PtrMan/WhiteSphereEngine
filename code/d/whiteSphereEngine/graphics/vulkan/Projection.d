module whiteSphereEngine.graphics.vulkan.Projection;

import whiteSphereEngine.graphics.opengl.Projection : openglProjectionMatrix = projectionMatrix;
import linopterixed.linear.Matrix;
import linopterixed.linear.MatrixCommonOperations;

// see https://matthewwellings.com/blog/the-new-vulkan-coordinate-system/
private Matrix!(ScalarType, 4, 4) correctionMatrix(ScalarType)() {
	return new Matrix!(ScalarType, 4, 4)([
		cast(ScalarType)1, cast(ScalarType)0 , cast(ScalarType)0  , cast(ScalarType)0,
		cast(ScalarType)0, cast(ScalarType)-1, cast(ScalarType)0  , cast(ScalarType)0,
		cast(ScalarType)0, cast(ScalarType)0 , cast(ScalarType)0.5, cast(ScalarType)0.5,
		cast(ScalarType)0, cast(ScalarType)0 , cast(ScalarType)0  , cast(ScalarType)1,
	]);
}

Matrix!(ScalarType, 4, 4) projectionMatrix(ScalarType)(ScalarType near, ScalarType far, ScalarType r, ScalarType t) {
	Matrix!(ScalarType, 4, 4) result = new Matrix!(ScalarType, 4, 4);
	mul(correctionMatrix!ScalarType(), openglProjectionMatrix!ScalarType(near, far, r, t), result);
	return result;
}
