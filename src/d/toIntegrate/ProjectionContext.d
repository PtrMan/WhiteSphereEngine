/**
 * Abstraction for the position and Frustum of a camera or lightsource or AI view or something entirely else
 *
 *
 */

module ProjectionContext;

import NumericSpatialVectors;
import Frustum;

class ProjectionContext(NumericType) {
	public SpatialVector!(3, NumericType) globalPosition;
	public Frustum!NumericType frustum;
}
