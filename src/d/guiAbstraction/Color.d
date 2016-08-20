module guiAbstraction.Color;

import math.NumericSpatialVectors;

/** \brief Color
 *
 */
struct Color {
	private SpatialVectorStruct!(3, float) vector;

	/** \brief set color as RGB
	 *
	 * \param R ...
	 * \param G ...
	 * \param B ...
	 */
	final public void setRgb(float r, float g, float b) {
		vector.data[0] = r;
		vector.data[1] = g;
		vector.data[2] = b;
	}

	/** \brief return color as RGB
	 *
	 * \param R ...
	 * \param G ...
	 * \param B ...
	 */
	final public void getRgb(out float r, out float g, out float b) {
		r = vector.data[0];
		g = vector.data[1];
		b = vector.data[2];
	}
}
