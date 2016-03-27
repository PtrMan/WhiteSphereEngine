module physics.DynamicSimulator;

import math.NumericSpatialVectors : SpatialVector, normalized, magnitude;
import math.RungeKutta4;
import physics.DynamicObject;
import celestial.CelestialObjectWithPosition;
static import celestial.Orbit;

/**
 * simulates the motion of dynamic objects and does (simple) collisionchecks
 *
 *
 */
class DynamicSimulator {
	alias SpatialVector!(3, double) VectorType;
	
    /* nonstatic */ class RungeKuttaAccelerationCalculator : IAcceleration!VectorType {
    	public double currentDynamicObjectInvMass;
    	public final VectorType calculateAcceleration(ref RungeKutta4State!VectorType state, float time) { 
        	return DynamicSimulator.calculateAcceleration(state, time, currentDynamicObjectInvMass);
        }
    }
    
    public final this() {
    	rungeKutta4.acceleration = new RungeKuttaAccelerationCalculator();
    }
    
    public final void tick(float deltaTime) {
    	RungeKuttaAccelerationCalculator rungeKuttaAccelerationCalculator = cast(RungeKuttaAccelerationCalculator)rungeKutta4.acceleration;
		
		foreach( iterationDynamicObject; dynamicObjects ) {
			RungeKutta4State!VectorType rungeKutta4State;
	        rungeKutta4State.x = iterationDynamicObject.relativePosition;
	        rungeKutta4State.v = iterationDynamicObject.velocity;
	        
	        rungeKuttaAccelerationCalculator.currentDynamicObjectInvMass = iterationDynamicObject.invMass;
	
	        rungeKutta4.integrate(rungeKutta4State, 0.0f, deltaTime);
	
	        iterationDynamicObject.relativePosition = rungeKutta4State.x;
	        iterationDynamicObject.velocity = rungeKutta4State.v;

		}
    }
    
    // called from RungeKuttaAccelerationCalculator::calculateAcceleration();
    protected final VectorType calculateAcceleration(ref RungeKutta4State!VectorType state, float time, double invMass) {
    	VectorType extrapolatedPosition = state.x + state.v * time;
    	return calculateAccelerationAtPosition(extrapolatedPosition, invMass);
    }

    private final VectorType calculateAccelerationAtPosition(VectorType position, double invMass) {
    	VectorType forceSum = new VectorType(0.0, 0.0, 0.0);

    	foreach( iterationCelestialObjectWithPosition; celestialObjectsWithPosition ) {
        	VectorType difference = iterationCelestialObjectWithPosition.position - position;
        	VectorType direction = difference.normalized();
       		double distance = difference.magnitude();

        	double forceScalar = celestial.Orbit.calculateForceBetweenObjectsByDistance(iterationCelestialObjectWithPosition.celestialObject.mass, 1.0/invMass, distance);
        	forceSum += (direction * forceScalar);
    	}

    	VectorType acceleration = forceSum * invMass;
    	
    	return acceleration;
    }

    public DynamicObject[] dynamicObjects;
    public CelestialObjectWithPosition[] celestialObjectsWithPosition;
	private RungeKutta4!VectorType rungeKutta4 = new RungeKutta4!VectorType();
}
