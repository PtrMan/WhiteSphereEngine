module physics.DynamicObject;

import math.NumericSpatialVectors : SpatialVector;
import physics.InvMassTemplate;
import physics.ITemporalChange;

/**
 * Object which has a (center relative) position and velocity
 *
 * is directly influenced by gravity
 *
 * is used for ships, drones, projectiles, etc.
 *
 */
class DynamicObject {
	public final struct State {
		public SpatialVector!(3, double) relativePosition, velocity;
	}
	
	// this should be used by the outside
	public State currentState;
	
	// the motion integration algorithm works on this step for step
	public State currentInternalState;
	
	public bool isControlled; // can the motion of the object by controlled by acceleration?
	public double enclosingRadiusFromRelativePosition;
	
	public double maximalForce; // only used if isControlled is true
	public ITemporalChange temporalChange; // can be null if is not controlled
	
	public final this(double mass) {
		this.protectedInvMass = 1.0/mass;
	}
	
	mixin InvMassTemplate!double;
}
