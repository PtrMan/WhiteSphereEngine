module world.World;

import math.NumericSpatialVectors;
import math.VectorAlias;

import celestial.CelestialObject;

import celestial.Motion;
import celestial.Position;

import math.Math;

class CelestialObjectWithPosition {
	
	
	CelestialObject celestialObject;
	
	/*
	final this(CelestialObject parameterCelestialObject, SpatialVector!(3, double) parameterPosition) {
	 	position = parameterPosition;
		celestialObject = parameterCelestialObject;
	}*/
	
	// t can be negative for a higher precision
	final Vector3p position(double t) {
		if( !isPositionCached ) {
			recalcPosition(t);
		}
		
		return cachedPosition;
	}
	
	final private void recalcPosition(double t) {
		double modT = modNegative(t, celestialObject.orbitProperties.period);
		double trueAnomaly, heliocentricDistance;
		positionAfterTWithPrecisionByAphelion(celestialObject.orbitProperties.period, modT, celestialObject.orbitProperties.eccentricity, celestialObject.orbitProperties.semiMajorAxis, /*out*/ trueAnomaly, /*out*/ heliocentricDistance); 
		
		// calculate position after trueAnomaly and distance
		cachedPosition = calcRelativePositionAfterAngleAndMajorSemimajorAxisFromTrueAnomaly(trueAnomaly, heliocentricDistance, celestialObject.orbitProperties.majorAxisDirection, celestialObject.orbitProperties.semimajorAxisDirection);
		
		isPositionCached = true;
	}
	
	protected Vector3p cachedPosition;
	protected bool isPositionCached = false;
}


import physics.DynamicObject;

class SystemObject {
	enum EnumDriven {
		PHYSICS,
		CELESTIALONRAILS, // position(and velocity) is driven by the celestial system, for example for an asteroid or planet or moon
	}
	
	public static SystemObject makePhysicsDriven(DynamicObject dynamicObject, ulong id) {
		SystemObject result = new SystemObject(EnumDriven.PHYSICS, id);
		result.protectedDynamicObject = dynamicObject;
		return result;
	}
	
	public static SystemObject makeCelestialOnrails(CelestialObjectWithPosition celestialOnRails, ulong id) {
		SystemObject result = new SystemObject(EnumDriven.CELESTIALONRAILS, id);
		result.protectedCelestialOnRails = celestialOnRails;
		return result;
	}
	
	protected final this(EnumDriven drivenBy, ulong id){
		this.drivenBy = drivenBy;
		this.id = id;
	}
	
	immutable EnumDriven drivenBy;
	immutable ulong id;
	
	final @property DynamicObject dynamicObject() {
		assert(drivenBy == EnumDriven.PHYSICS );
		return protectedDynamicObject;
	}
	
	final @property CelestialObjectWithPosition celestialOnRails() {
		assert(drivenBy == EnumDriven.CELESTIALONRAILS );
		return protectedCelestialOnRails;
	}
	
	// just based on id
	final bool isEqual(SystemObject other) {
		return id == other.id;
	}
	
	
	// t can be negative
	final Vector3p position(double t) {
		final switch(drivenBy) with (EnumDriven) {
			case PHYSICS:
			return dynamicObject.currentState.relativePosition;
			
			case CELESTIALONRAILS:
			return protectedCelestialOnRails.position(t);
		}
	}
	
	protected CelestialObjectWithPosition protectedCelestialOnRails; // TODO< create class CelestialCached > 
	protected DynamicObject protectedDynamicObject;
}


