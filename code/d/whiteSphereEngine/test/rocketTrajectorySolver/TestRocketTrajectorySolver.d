import std.stdio;
import std.file;

import math.NumericSpatialVectors;
import math.VectorAlias;

import whiteSphereEngine.test.rocketTrajectorySolver.MathematicaDebug;
import whiteSphereEngine.control.RocketTrajectorySolver : rocketTrajectorySolve = solve;

void main() {
	double deltaTime = 1.0/30.0;

	Vector3f rocketPosition = new Vector3f(0.0f, 0.0f, 0.0f);
	Vector3f rocketVelocity = new Vector3f(0.0f, 3.0f, 1.0f);

	Vector3f targetPosition = new Vector3f(10.0f, 5.0f, 0.0f);
	Vector3f targetVelocity = new Vector3f(1.0f, 0.0f, 0.0f);
	

	double rocketAcceleration = 4.0;

	File file = File("logMathematica.txt", "w");

	Vector3f accelerationDirection = new Vector3f(0.0f, 0.0f, 0.0f);

	file.writeln("ListAnimate[{");

	foreach( timeI; 0..3000 ) {
		DebugVector[] debugVectors;
		debugVectors ~= new DebugVector(rocketPosition, rocketPosition+rocketVelocity);
		debugVectors ~= new DebugVector(targetPosition, targetPosition+targetVelocity);
		debugVectors ~= new DebugVector(rocketPosition, rocketPosition+accelerationDirection, DebugVector.EnumColor.BLUE);


		rocketTrajectorySolve(rocketPosition, rocketVelocity, targetPosition, targetVelocity, rocketAcceleration, /*out*/accelerationDirection);

		file.write(calcMathematicaFormOfVectors(debugVectors));

		if( timeI != 3000-1 ) {
			file.writeln(",");
		}

		targetPosition += targetVelocity.scale(cast(float)deltaTime);
		rocketPosition += rocketVelocity.scale(cast(float)deltaTime);
		rocketVelocity += accelerationDirection.scale(cast(float)deltaTime*cast(float)rocketAcceleration);
	}

	file.writeln("}]");

	file.close();
}
