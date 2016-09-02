module whiteSphereEngine.control.RocketTrajectorySolver;

import std.math : sqrt;

import math.NumericSpatialVectors;

/** \brief Solver for controlling the rocket to hit a moving target
 *
 * This solver is inspired by the algorithm described on stackexchange gamedev with the title 
 * "Implementing a homing missile" http://gamedev.stackexchange.com/questions/52988/implementing-a-homing-missile
 */
void solve(VectorType)(VectorType rocketPosition, VectorType rocketVelocity, VectorType targetPosition, VectorType targetVelocity, double acceleration, ref VectorType accelerationDirection) {
	alias typeof(rocketPosition.x) ComponentType;

	VectorType localPosition = targetPosition - rocketPosition;
	VectorType localVelocity = targetVelocity - rocketVelocity;

	ComponentType distance = localPosition.magnitude;

	// normalize the difference to the target to get the direction where we have to go
	VectorType directionToTarget = localPosition.normalized;

	// calculate how fast we are moving to the target with the component of the velocity to the target
	ComponentType directionToTargetDotVelocity;
	ComponentType scalarClosingSpeed = directionToTargetDotVelocity = directionToTarget.scale(-1.0f).dot(localVelocity);

	// estimate time to arival if we accelerate just in the direction of the component
	ComponentType eta = -scalarClosingSpeed / cast(ComponentType)acceleration + cast(ComponentType)sqrt((scalarClosingSpeed*scalarClosingSpeed) / (cast(ComponentType)acceleration*cast(ComponentType)acceleration) + (cast(ComponentType)2.0*distance)/cast(ComponentType)acceleration);

	// calculate the extrapolated target 
	VectorType extrapolatedLocalTargetPosition = localPosition + localVelocity.scale(eta);

	VectorType extrapolatedLocalPositionWithoutAcceleration = localVelocity.scale(eta);

	// the direction of thrust is to the extrapolated position to close the gap
	accelerationDirection = extrapolatedLocalTargetPosition.normalized;
}
