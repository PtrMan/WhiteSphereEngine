module physics.DynamicSimulator;

import math.NumericSpatialVectors : SpatialVector, normalized, magnitude, scale;
import math.RungeKutta4;
import physics.DynamicObject;
import world.World; // just because CelestialObjectWithPosition is in there, TODO< move again to own file >
static import celestial.Orbit;
import geometry.AxisOrientedBoundingBox;

alias SpatialVector!(3, double) VectorType;

public class DynamicEngine {
	public class Settings {
		// number of timesteps for motion extrapolation for the prediction of the collision of all objects
		// per SolarSystem
		// motion can be predicted not just after this time, but as a consequence of
		// - sudden change of motion (collision)
		// - new objects
		// etc.
		uint numberOfStepsForMotionExtrapolation;
	}
	
	public final this(Settings settings) {
		this.settings = settings;
		
		motionIntegrator.initialize();
	}
	
	public final void tick(float deltaT, float extrapolationDeltaT) {
		extrapolateMotionIfRequiredForSolarSystems(extrapolationDeltaT);
		tickForSolarSystems(deltaT);
	}
	
	protected final extrapolateMotionIfRequiredForSolarSystems(float extrapolationDeltaT) {
		foreach( iterationSolarSystem; solarSystems ) {
			iterationSolarSystem.extrapolateMotionIfRequired(settings.numberOfStepsForMotionExtrapolation, extrapolationDeltaT);
		}
	}
	
	protected final tickForSolarSystems(float deltaT) {
		foreach( iterationSolarSystem; solarSystems ) {
			tickForSolarSystem(iterationSolarSystem, deltaT);
		}
	}
	
	protected final void tickForSolarSystem(SolarSystem solarsystem, float deltaT) {
		solarsystem.nextFrame(); // flush
		motionIntegrator.tick(solarsystem.allDynamicObjects, deltaT);
	}
	
	final @property public double universeTime(double universeTimeArgument) {
		motionIntegrator.universeTime = universeTimeArgument; // give it to motion integrator, that it can recalculate the celestial position after the time
		return universeTimeArgument;
	}
	
	protected SolarSystem[] solarSystems;
	protected Settings settings;
	
	private MotionIntegrator motionIntegrator = new MotionIntegrator();
}

/**
 * simulates the motion of dynamic objects and does (simple) collisionchecks
 *
 *
 */
protected class MotionIntegrator {
    /* nonstatic */ class RungeKuttaAccelerationCalculator : IAcceleration!VectorType {
    	public double currentDynamicObjectInvMass;
    	public VectorType externalAcceleration;
    	public final VectorType calculateAcceleration(ref RungeKutta4State!VectorType state, float time) { 
        	return externalAcceleration + MotionIntegrator.calculateAcceleration(state, time, currentDynamicObjectInvMass);
        }
    }
    
	final void initialize() {
		rungeKutta4.acceleration = new RungeKuttaAccelerationCalculator();
	}
    
    final void tick(DynamicObject[] dynamicObjects, float deltaTime) {
		transferCurrentStateToInternalStateForObjects(dynamicObjects);
		integrateMotionForDynamicObjects(dynamicObjects, deltaTime);
		transferInternalStateToCurrentStateForObjects(dynamicObjects);
    }
    
    // doesn't transfer state
    // protected for own use and use of PredictiveMotionIntegrator
    protected final void integrateMotionForDynamicObjects(DynamicObject[] localDynamicObjects, float deltaTime) {
    	foreach( iterationDynamicObject; localDynamicObjects ) {
			integrateMotionForDynamicObject(iterationDynamicObject, deltaTime);
		}
    }
    
    protected final void integrateMotionForDynamicObject(DynamicObject dynamicObject, float deltaTime, VectorType externalAcceleration = new VectorType(0.0, 0.0, 0.0)) {
    	RungeKutta4State!VectorType rungeKutta4State;
        rungeKutta4State.x = dynamicObject.currentInternalState.relativePosition;
        rungeKutta4State.v = dynamicObject.currentInternalState.velocity;
        
        RungeKuttaAccelerationCalculator rungeKuttaAccelerationCalculator = cast(RungeKuttaAccelerationCalculator)rungeKutta4.acceleration;
        rungeKuttaAccelerationCalculator.externalAcceleration = externalAcceleration;
        rungeKuttaAccelerationCalculator.currentDynamicObjectInvMass = dynamicObject.invMass;

        rungeKutta4.integrate(rungeKutta4State, 0.0f, deltaTime);

        dynamicObject.currentInternalState.relativePosition = rungeKutta4State.x;
        dynamicObject.currentInternalState.velocity = rungeKutta4State.v;
    }
    
    // protected for own use and use of PredictiveMotionIntegrator
    protected static void transferCurrentStateToInternalStateForObjects(DynamicObject[] localDynamicObjects) {
    	foreach( iterationDynamicObject; localDynamicObjects ) {
    		transferCurrentStateToInternalStateForObject(iterationDynamicObject);
    	}
    }
    
    protected static void transferCurrentStateToInternalStateForObject(DynamicObject localDynamicObjects) {
    	localDynamicObjects.currentInternalState = localDynamicObjects.currentState;
    }
    
    protected static void transferInternalStateToCurrentStateForObjects(DynamicObject[] localDynamicObjects) {
    	foreach( iterationDynamicObject; localDynamicObjects ) {
    		iterationDynamicObject.currentState = iterationDynamicObject.currentInternalState;
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
        	VectorType difference = iterationCelestialObjectWithPosition.position(universeTime) - position;
        	VectorType direction = difference.normalized();
       		double distance = difference.magnitude();

        	double forceScalar = celestial.Orbit.calculateForceBetweenObjectsByDistance(iterationCelestialObjectWithPosition.celestialObject.mass, 1.0/invMass, distance);
        	forceSum += (direction * forceScalar);
    	}

    	VectorType acceleration = forceSum * invMass;
    	
    	return acceleration;
    }
	
	// TODO< replace with something which is stored in DynamicObject? >
	public CelestialObjectWithPosition[] celestialObjectsWithPosition;
	private RungeKutta4!VectorType rungeKutta4 = new RungeKutta4!VectorType;
	public double universeTime; // in seconds
}

import physics.spatial.HashSpatialNestedGrid;
import math.Range;
import helpers.Unique : calcUnique;

alias HashSpatialNestedGrid!(DynamicObject, VectorType) SpatialGridType;

/**
 * Integrates the motion over a longer timeframe (seconds, minutes, hours?)
 * if the DynamicObject is controlled the range spanned by the maximal acceleration is calculated after the maximal acceleration in all directions
 *
 */
protected class PredictiveMotionIntegrator {
	public static void extrapolateMotionAndUpdateForSolarsystem(SolarSystem solarSystem, uint numberOfSteps, float deltaT) {
		void resetCollisionMotionObjectsOfSolarsystem(SolarSystem solarSystem) {
			solarSystem.collisionMotionObjects.length = 0;
		}
		
		calcPredictiveMotionAabbAndAddToAccelerationsDatastructuresForObjectsInSolarsystem(solarSystem, numberOfSteps, deltaT);
		resetCollisionMotionObjectsOfSolarsystem(solarSystem);
		checkPredictiveMotionGridElementsForOverlapAndAddPotentialCollisionCandidatesToListForSolarsystem(solarSystem);
		putCollisionMotionObjectsIntoGridForSolarsystem(solarSystem);
	}
	
	// add object with aabb to the predictiveMotion HashSpatialNestedGrid
	// (after iterating over all objects)
	protected static void calcPredictiveMotionAabbAndAddToAccelerationsDatastructuresForObjectsInSolarsystem(SolarSystem solarSystem, uint numberOfSteps, float deltaT) {
		SpatialGridType.ContentWithBoundingBoxType[] contentsWithAabb;
		
		foreach( iterationDynamicObject; solarSystem.allDynamicObjects ) {
			auto aabb = simulateGravityAndDirectAccelerateOfForStepsAnReturnAAbb(iterationDynamicObject, numberOfSteps, deltaT);
			
			contentsWithAabb ~= new SpatialGridType.ContentWithBoundingBoxType(iterationDynamicObject, aabb);
		}
		
		solarSystem.predictiveMotionGrid.resetContentAndAddAll(contentsWithAabb);
	}
	
	
	// check for all used grid cells which elements overlap
	// if some overlap, add them to the more detailed per physics frame simulation,
	// else leave them out for collision tests
	protected static void checkPredictiveMotionGridElementsForOverlapAndAddPotentialCollisionCandidatesToListForSolarsystem(SolarSystem solarSystem) {
		SpatialGridType.GridElementType.ContentWithBoundingBox[] temporaryArray;
		
		// delegate which gets the GridElement of the HashSpatialNestedGrid
		// which checks for the overlap of the AABB's of the content
		void checkForElementOverlapAndAddThemToTemporalArray(SpatialGridType.GridElementType gridElement) {
			foreach( iOuter; 0..gridElement.decoratedContent.length ) {
				auto outerContentWithBoundingBox = gridElement.decoratedContent[iOuter];
				
				bool outerElementAlreadyInTemporalArray = false;
				
				foreach( iInner; iOuter+1..gridElement.decoratedContent.length ) {
					auto innerContentWithBoundingBox = gridElement.decoratedContent[iInner];
					
					bool overlap = outerContentWithBoundingBox.boundingBox.boundingBoxDoesOverlap!(EnumRangeType.EXCLUSIVE)(innerContentWithBoundingBox.boundingBox);
					if( overlap ) {
						if( !outerElementAlreadyInTemporalArray ) {
							outerElementAlreadyInTemporalArray = true;
							temporaryArray ~= outerContentWithBoundingBox;
						}
						
						temporaryArray ~= innerContentWithBoundingBox;
					}
				}
			}
		}
		
		solarSystem.predictiveMotionGrid.invokeDelegateForAllGridElementsRecursive(&checkForElementOverlapAndAddThemToTemporalArray);
		
		// get only unique objects of temporalArray
		SpatialGridType.GridElementType.ContentWithBoundingBox[] uniqueTemporaryArray = calcUnique(temporaryArray);
		
		// add the DynamicObjects to the more detailed physics frame simulation
		solarSystem.collisionMotionObjects = array(map!(iterationContentWithAabb => iterationContentWithAabb.content)(uniqueTemporaryArray));
	}
	
	protected static void putCollisionMotionObjectsIntoGridForSolarsystem(SolarSystem solarSystem) {
		auto motionObjectsWithAabb = decorateDynamicObjectsWithAabb(solarSystem.collisionMotionObjects);
		solarSystem.collisionMotionGrid.resetContentAndAddAll(motionObjectsWithAabb);
	}
	
	
	protected static AxisOrientedBoundingBox!VectorType simulateGravityAndDirectAccelerateOfForStepsAnReturnAAbb(DynamicObject dynamicObject, uint numberOfSteps, float deltaT) {
		DynamicEngine dynamicEngine;
		
		// copy state
		dynamicEngine.motionIntegrator.transferCurrentStateToInternalStateForObject(dynamicObject);
		
		AxisOrientedBoundingBox!VectorType agregateAabb = createAabb(dynamicObject.currentInternalState.relativePosition, dynamicObject.enclosingRadiusFromRelativePosition);
		
		void integrateMotionForDynamicObjectWithAccelerationAndAddToAabb(VectorType externalAcceleration) {
			dynamicEngine.motionIntegrator.integrateMotionForDynamicObject(dynamicObject, deltaT, externalAcceleration);
			agregateAabb = merge(agregateAabb, agregateAabb = createAabb(dynamicObject.currentInternalState.relativePosition, dynamicObject.enclosingRadiusFromRelativePosition));
		}
		
		void copyStateAndIntegrateMotionOverWholeTimeWithForceAndAntiforce(VectorType force) {
			// copy state
			dynamicEngine.motionIntegrator.transferCurrentStateToInternalStateForObject(dynamicObject);
			
			foreach( i; 0..numberOfSteps ) {
				integrateMotionForDynamicObjectWithAccelerationAndAddToAabb(force);
			}
			
			
			
			// copy state
			dynamicEngine.motionIntegrator.transferCurrentStateToInternalStateForObject(dynamicObject);
			
			foreach( i; 0..numberOfSteps ) {
				integrateMotionForDynamicObjectWithAccelerationAndAddToAabb(force.scale(-1.0));
			}
		}
		
		foreach( i; 0..numberOfSteps ) {
			integrateMotionForDynamicObjectWithAccelerationAndAddToAabb(new VectorType(0.0, 0.0, 0.0));
		}

		// if it is controlled we have to merge all possible acceleration directions
		if( dynamicObject.isControlled ) {
			float sumOfTime = cast(float)numberOfSteps * deltaT;
			double minimalInvMassInTimeOfObject = dynamicObject.temporalChange.calcuateMinimalInvMassAfterTime(sumOfTime);
			
			// swap mass and swap it back aftr the simulation
			double oldMassInverted = dynamicObject.invMass;
			dynamicObject.invMass = minimalInvMassInTimeOfObject;
			
			copyStateAndIntegrateMotionOverWholeTimeWithForceAndAntiforce(new VectorType(dynamicObject.maximalForce, 0.0, 0.0));
			copyStateAndIntegrateMotionOverWholeTimeWithForceAndAntiforce(new VectorType(0.0, dynamicObject.maximalForce, 0.0));
			copyStateAndIntegrateMotionOverWholeTimeWithForceAndAntiforce(new VectorType(0.0, 0.0, dynamicObject.maximalForce));
			
			dynamicObject.invMass = oldMassInverted;
		}
		
		// reset state by copying state
		dynamicEngine.motionIntegrator.transferCurrentStateToInternalStateForObject(dynamicObject);
		
		return agregateAabb;
	}
}

protected SpatialGridType.ContentWithBoundingBoxType[] decorateDynamicObjectsWithAabb(DynamicObject[] dynamicObjects) {
	return array(
		map!(
			iterationMotionObject => new SpatialGridType.ContentWithBoundingBoxType(
				iterationMotionObject,
				createAabb(iterationMotionObject.currentState.relativePosition, iterationMotionObject.enclosingRadiusFromRelativePosition)
			)
		)(dynamicObjects)
	);
}

// helper
protected AxisOrientedBoundingBox!VectorType createAabb(VectorType centerPosition, double radius) {
	VectorType radiusVector = new VectorType(radius, radius, radius);
	return new AxisOrientedBoundingBox!VectorType(centerPosition - radiusVector, centerPosition + radiusVector);
}

// Should map to all objects inside a single solar system (with possibly multiple stars or none at all)
// Represents one spatial relationship where potentially anything can collide with anything else (there are exceptions)
public class SolarSystem {
	public final DynamicObject[] queryObjectsForThisFrame(VectorType min, VectorType max) {
		recalcCachedSpatialQueryGrid();
		return cachedSpatialQueryGrid.getContentByRange(min, max);
	}
	
	protected final void recalcCachedSpatialQueryGrid() {
		if( !cachedSpatialQueryGridAlreadyUpdatedForThisFrame ) {
			// recalculate spatial grid
			auto decoratedDynamicObjectsWithAabb = decorateDynamicObjectsWithAabb(allDynamicObjects);
			cachedSpatialQueryGrid.resetContentAndAddAll(decoratedDynamicObjectsWithAabb);
			
			cachedSpatialQueryGridAlreadyUpdatedForThisFrame = true;
		}
	}
	
	public final void nextFrame() {
		resetCacheedSpatialQueryGrid();
	}
	
	protected final void resetCacheedSpatialQueryGrid() {
		cachedSpatialQueryGridAlreadyUpdatedForThisFrame = false;
	}
	
	// recalculates the motion extrapolation if required
	public final void extrapolateMotionIfRequired(int numberOfStepsForMotionExtrapolation, float extrapolationDeltaT) {
		remainingStepsTillMotionIntegration--;
		
		if( remainingStepsTillMotionIntegration <= 0 ) {
			PredictiveMotionIntegrator.extrapolateMotionAndUpdateForSolarsystem(this, numberOfStepsForMotionExtrapolation, extrapolationDeltaT);
			
			remainingStepsTillMotionIntegration = numberOfStepsForMotionExtrapolation;
		}
	}
	
	// grid used to find if objects can possible collide in a big timeframe
	protected SpatialGridType predictiveMotionGrid;
	
	// grid for the possible collision pairs, per timestep exact
	// contains only objects which can collide with any
	protected SpatialGridType collisionMotionGrid;
	protected DynamicObject[] collisionMotionObjects;
	
	
	// array with all dynamic objects in the solar system
	protected DynamicObject[] allDynamicObjects;
	
	// updated only if a spatial query is done on the system
	// contains all dynamic objects
	protected SpatialGridType cachedSpatialQueryGrid;
	protected bool cachedSpatialQueryGridAlreadyUpdatedForThisFrame;
	
	protected int remainingStepsTillMotionIntegration = 0;
}
