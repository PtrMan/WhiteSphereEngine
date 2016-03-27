module physics.DynamicObject;

import math.NumericSpatialVectors : SpatialVector;
import physics.InvMassTemplate;

/**
 * Object which has a (center relative) position and velocity
 *
 * is directly influenced by gravity
 *
 * is used for ships, drones, projectiles, etc.
 *
 */
class DynamicObject {
	public SpatialVector!(3, double) relativePosition, velocity;
	
	public final this(double mass) {
		this.protectedInvMass = 1.0/mass;
	}
	
	mixin InvMassTemplate!double;
}
