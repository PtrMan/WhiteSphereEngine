module guiAbstraction.IClickable;

import math.NumericSpatialVectors;
import math.VectorAlias;

interface IClickable {
	void mouseDown(Vector2f Position);
	void mouseUp(Vector2f Position);
}
