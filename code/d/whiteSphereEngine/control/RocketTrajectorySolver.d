module whiteSphereEngine.control.RocketTrajectorySolver;

import math.NumericSpatialVectors;

import std.math : sqrt;

/** \brief Solver for controlling the rocket to hit a moving target
 *
 * This solver implements the algorithm described on stackexchange gamedev with the title "Implementing a homing missile" http://gamedev.stackexchange.com/questions/52988/implementing-a-homing-missile
 * (see there for a better description)
 */
void solve(VectorType)(VectorType rocketPosition, VectorType rocketVelocity, VectorType targetPosition, VectorType targetVelocity, double acceleration, ref VectorType accelerationDirection) {
	alias typeof(rocketPosition.x) ComponentType;

	VectorType vs = targetVelocity - rocketVelocity;
	VectorType normalizedTarget = (targetPosition - rocketPosition).normalized;

	ComponentType vc = vs.scale(cast(ComponentType)-1.0).dot(normalizedTarget);

	ComponentType distance = (rocketPosition - targetPosition).magnitude;

	// estimate time to arival
	ComponentType eta = -vc / cast(ComponentType)acceleration + cast(ComponentType)sqrt((vc*vc) / (cast(ComponentType)acceleration*cast(ComponentType)acceleration) + (cast(ComponentType)2.0*distance)/cast(ComponentType)acceleration);

	VectorType laterTargetPosition = targetPosition + targetVelocity.scale(eta);

	accelerationDirection = (laterTargetPosition - rocketPosition).normalized;
}
