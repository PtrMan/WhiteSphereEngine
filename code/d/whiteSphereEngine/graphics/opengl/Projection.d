module whiteSphereEngine.graphics.opengl.Projection;
// is not really opengl specific because we can modify the matrix to get a vulkan matrix

import linopterixed.linear.Matrix;

// see http://www.songho.ca/opengl/gl_projectionmatrix.html
Matrix!(ScalarType, 4, 4) projectionMatrix(ScalarType)(ScalarType near, ScalarType far, ScalarType r, ScalarType t) {
	static const ScalarType NULL = cast(ScalarType)0;

	return new Matrix!(ScalarType, 4, 4)([
		near/r, NULL  , NULL                      , NULL,
		NULL  , near/t, NULL                      , NULL,
		NULL  , NULL  , -(far + near)/(far - near), (cast(ScalarType)-2 * far * near) / (far - near),
		NULL  , NULL  , cast(ScalarType)-1        , NULL,
	]);
}
