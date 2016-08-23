module celestial.CelestialObject;

import math.NumericSpatialVectors;
import math.VectorAlias;
import physics.InvMassTemplate;

/**
 * 
 */
class CelestialObject {
	public enum EnumCelestialObjectType {
  		NOTSET,
  		STAR,
  		
  		GENETICCELESTIALBODY
  		// Planet
  		// Asteroid
  		// RoundMoon
  		// Planetoid
  
  		// TODO< system for procedurally beldning betwen moon, asteroid and planet?, because they are all the same >
  
  		//Blackhole UMETA(DisplayName="Blackhole"),
  		//NeutronStar UMETA(DisplayName="NeutronStar"),
	}
	
	
	
	EnumCelestialObjectType type = EnumCelestialObjectType.NOTSET;
  	
  	// TODO< age >
  	// TODO< maxRadius (radius but same for irregular shapes >
  
  	// is ignored/not valid if it is a GenericCelestialBody
  	float luminosityLogarithmic; // base 10, relative to sun
  
  	float surfaceTemperatureInKelvin = 0;
  
  	// is ignored/not valid if it is a Star/Blackhole
  	// TODO< add more properties about the atmosphere >
  	bool hasAtmosphere = false;
  
  	mixin InvMassTemplate!double;
  	
  	// used for lookup of name/generation of procedural name
  	int[] randomNumberGeneratorCoordinates;
    
  	public final this(EnumCelestialObjectType parameterType) {
    	type = parameterType;
    	
  		mass = 1.0; // set to one kilo to avoid numeric problems
  	}

	// orbit properties
	static struct OrbitProperties {
	  	// orbit properties
		double period; // in seconds
		double eccentricity;
		
		double semiMajorAxis;
		
		Vector3p majorAxisDirection, semimajorAxisDirection; // normalized
	}
	
	OrbitProperties orbitProperties;
}
