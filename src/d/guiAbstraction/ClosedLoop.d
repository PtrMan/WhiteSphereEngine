module guiAbstraction.ClosedLoop;

import math.NumericSpatialVectors;


/** \brief A closed loop of points
 *
 * All points are connected with lines in between and there is a line from the last point to the first
 *
 * This class doesn't define how it is drawn, the width, if it can be convex and so on
 *
 */
class ClosedLoop {
	Vector2f[] points;
}
