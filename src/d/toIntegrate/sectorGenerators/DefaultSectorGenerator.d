import sectorGenerators.ISectorGenerator;
#include "CelestialObject.h"
#include "Math/EnumeratedDistribution.h"

class DefaultSectorGenerator : ISectorGenerator {
	private static struct CelestialOrbitInfo {
		FCelestialObject celestialObject;

		double orbitRadius;
	}

	private static struct CelestialNoncenterBlueprint {
		EEnumCelestialObjectType celestialObjectType;

		double massMin;
		double massMax;
    	
		bool canHaveAtmosphere;
	}

	public final this() {
		initializeCelestialNoncenterBlueprints();
	}

	public /*virtual*/ ~this() {

	}

	public /*virtual*/ void createCelestialClustersForSector(ref FCelestialCluster[] destinationArray, const int64_t[3] sectorPosition, const InternalScalar sectorsize, const ref FCelestialSettings celestialSettings) {
		const InternalPreciseVector sectorOffset = InternalPreciseVector(cast(InternalScalar)sectorPosition[0] * sectorsize, cast(InternalScalar)sectorPosition[1] * sectorsize, cast(InternalScalar)sectorPosition[2] * sectorsize);

		const int64_t spatialHashForPosition = calculateHashForUniverseSector(sectorPosition);

		uint32_t countOfCelestialClusters = 1;

		int64_t runningRng = spatialHashForPosition;
  
		int64_t celestialPseudorandomPositionCounter = 0 + spatialHashForPosition % 10;

		foreach( celestialClusterCounter; 0..countOfCelestialClusters ) {
			InternalScalar currentX = RandomUtility.radicalInverse(celestialPseudorandomPositionCounter, 2);
			InternalScalar currentY = RandomUtility.radicalInverse(celestialPseudorandomPositionCounter, 3);
			InternalScalar currentZ = RandomUtility.radicalInverse(celestialPseudorandomPositionCounter, 5);
			
			
			InternalPreciseVector rootClusterCenterPosition = sectorOffset + (InternalPreciseVector(currentX, currentY, currentZ) * sectorsize);
			
			
			// TODO< call logic to generate a random cluster (system) based on the rng and the position >
			
			FCelestialCluster rootCelestialCluster(rootClusterCenterPosition);
			
			FRandomStream randomStream(runningRng);
			
			// build address of center
			int32_t[2] randomNumberGeneratorCoordinatesForCenter;
			randomNumberGeneratorCoordinatesForCenter ~= cast(int32_t)runningRng;
			randomNumberGeneratorCoordinatesForCenter ~= 0; // add coordinate for indicating that its a center celestial
			
			const FCelestialCluster[] centerClusters = calculateCelestialClustersForCenter(randomStream, randomNumberGeneratorCoordinatesForCenter);
			const double centerSumMass = calculateMassForCelestialClusters(centerClusters);

			rootCelestialCluster.subclusters.Append(centerClusters);
			
			// build address of noncenter
			int32_t[2]  randomNumberGeneratorCoordinatesForNonCenter;
			randomNumberGeneratorCoordinatesForNonCenter ~= cast(int32_t)runningRng;
			randomNumberGeneratorCoordinatesForNonCenter ~= 1; // add coordinate for indicating that its a noncenter celestial
			
			rootCelestialCluster.subclusters ~= calculateCelestialClustersForNoncenterObjects(randomStream, centerSumMass, randomNumberGeneratorCoordinatesForNonCenter, celestialSettings);
			
			destinationArray ~= rootCelestialCluster;
			
			celestialPseudorandomPositionCounter++;
			runningRng++;
		}
	}

	protected static FCelestialCluster[] calculateCelestialClustersForCenter(FRandomStream &random, const int32_t[] randomNumberGeneratorCoordinatesForCenter) {
		FCelestialCluster[] resultClusters;

		// TODO< weighted random number generator >
		const uint32_t numberOfCelestials = 1;

		// TODO<take set and calculate the ideal orbits of 2 or 3 body systems>

		if( numberOfCelestials == 1 ) {
			TArray<int32> randomNumberGeneratorCoordinatesForCurrentCelestial = randomNumberGeneratorCoordinatesForCenter;
			randomNumberGeneratorCoordinatesForCurrentCelestial.Add(0); // first object in the center
			
			FCelestialCluster resultCluster;
			resultCluster.leafCelestialObject = generateCelestialCenterObjectWithoutConstraints(random, randomNumberGeneratorCoordinatesForCurrentCelestial);
			
			UE_LOG(YourLog,Log,TEXT("DefaultSectorGenerator::calculateCelestialClustersForCenterObjects() called for 1 celestial"));
			
			resultClusters.Add(resultCluster);
		}
  
		
		// TODO< two body system >


		// TODO< three body system >
		else {
			// shouldn't happen
			UE_LOG(YourLog,Fatal,TEXT("DefaultSectorGenerator::calculateCelestialClustersForCenterObjects() called for unhandled number of Celestial bodies!"));
		}

		return resultClusters;
	}


	protected static FCelestialObject generateCelestialCenterObjectWithoutConstraints(FRandomStream &random, const TArray<int32> &randomNumberGeneratorCoordinates) {
		// TODO< use a random process for the random sampling of the temperature of the star >
		float surfaceTemperatureInKelvin = linearInterpolate(random.GetFraction(), 3000.0f, 40000.0f);
		
		FCelestialObject resultCelestial = new FCelestialObject(EnumCelestialObjectType.Star);
		resultCelestial.luminosityLogarithmic = StarGeneration.calculateLuminosityByTemperature(surfaceTemperatureInKelvin);
		resultCelestial.surfaceTemperatureInKelvin = surfaceTemperatureInKelvin;
		resultCelestial.randomNumberGeneratorCoordinates = randomNumberGeneratorCoordinates;
		
		return resultCelestial;
	}



	protected static double calculateMassForCelestialClusters(const FCelestialCluster[] celestialObjects) {
		double massSum = 0.0;

		foreach ( iterationCelestialCluster; celestialObjects ) {
			massSum += iterationCelestialCluster.getMassSumRecursive();
		}

		return massSum;
	}


	protected FCelestialCluster[] calculateCelestialClustersForNoncenterObjects(ref FRandomStream random, const double centerSumMass, const ref int32_t[] randomNumberGeneratorCoordinates, const ref FCelestialSettings celestialSettings) const {
		FCelestialCluster[] resultClusters;

		bool youngSystem = false; // TODO< use randomnumber generator >
		const DefaultSectorGenerator::CelestialOrbitInfo[] noncenterCelestialOrbitInfos = calculateOrbitRadiusesAndCelestialInfo(random, centerSumMass, youngSystem, randomNumberGeneratorCoordinates, celestialSettings);

		// create celestialClusters for the celestial objects
		foreach( iterationCelestialOrbitInfo ; noncenterCelestialOrbitInfos ) {
			FCelestialCluster createdClusterForCelestial;
			
			createdClusterForCelestial.leafCelestialObject = new FCelestialObject(iterationCelestialOrbitInfo.celestialObject);
			// set orbit informations
			createdClusterForCelestial.leafHasNoOrbit = false;
			createdClusterForCelestial.leafPlaneNormal = createdClusterForCelestial.leafPlaneUpVector;
			
			createdClusterForCelestial.leafOneOrbitTimeInSeconds = Orbit.calculateOrbitalPeriod(centerSumMass, iterationCelestialOrbitInfo.orbitRadius*2.0);
			createdClusterForCelestial.leafOrbitTimeOffsetInSeconds = 0.0; // TODO< use random number generator to generate this one >
			
			//  set orbit information to circular orbit
			createdClusterForCelestial.leafOrbitA = iterationCelestialOrbitInfo.orbitRadius;
			createdClusterForCelestial.leafOrbitB = iterationCelestialOrbitInfo.orbitRadius;
			
			resultClusters.Add(createdClusterForCelestial);
		}

		return resultClusters;
	}

	protected CelestialOrbitInfo[] calculateOrbitRadiusesAndCelestialInfo(ref RandomStream random, const double centerSumMass, const bool youngSystem, const int32_t[] randomNumberGeneratorCoordinates, const ref FCelestialSettings celestialSettings) const {
		DefaultSectorGenerator.CelestialOrbitInfo[] resultCelestialOrbits;

		// factor for the range of gravity from a celestial body, gets multiplied with a constant to get real gravity value for the influence
		/**
		* if it is a young system tbe planets are much much closer together, and the numeriousity is much higher, because the planets didn't got kicked out
		* 
		* 
		*/
		double gravityInfluenceDampingFactor = youngSystem ? 0.1f : 1.0f;

		uint32 hitCounter = 0;

		uint32_t maxTries = youngSystem ? 100 : 20;

		// for testing for now we nail
		maxTries = 1;
		
		// TODO< build in asteroid belts somehow >
		// TODO< a young system has by far more asteroid belts than a old system, build this in somehow >
		
		for( uint32 tryI = 0; tryI < maxTries; tryI++ ) {
			// choose orbitRadius at random
    
			// TODO< take the maximal radius of the ecenter objects into account and the radius of the bigest center object >
			const double chosenNewCelestialOrbitRadius = random.GetFraction() * Constants.AstronomicalUnit * 500.0;
			
			// NOTE< does NOT work this way for belts >
			FCelestialObject generatedCelestialObject = generateCandidateForNoncenterCelestialObject(random);
			
			const bool orbitIsNotInInfluence = isOrbitNotInInfluenceOfBodies(resultCelestialOrbits, chosenNewCelestialOrbitRadius, generatedCelestialObject.mass, gravityInfluenceDampingFactor, celestialSettings.dampingFactorToAttractiveForceFactor);
			if( orbitIsNotInInfluence ) {
				// TODO< calculate surface temperature >
				
				// add to list
				CelestialOrbitInfo createdCelestialOrbitInfo;
				createdCelestialOrbitInfo.orbitRadius = chosenNewCelestialOrbitRadius;
				createdCelestialOrbitInfo.celestialObject = generatedCelestialObject;
				createdCelestialOrbitInfo.celestialObject.randomNumberGeneratorCoordinates = randomNumberGeneratorCoordinates;
				createdCelestialOrbitInfo.celestialObject.randomNumberGeneratorCoordinates.Add((int32)hitCounter);
				
				resultCelestialOrbits ~= createdCelestialOrbitInfo;
				
				hitCounter++;
			}
		}

		return resultCelestialOrbits;
	}

	protected static bool isOrbitNotInInfluenceOfBodies(const CelestialOrbitInfo[] celestialInfos, const double orbitRadius, const double celestialMass, const double gravityInfluenceDampingFactor, const double dampingFactorToAttractiveForceFactor) {
		const double maximalAttractiveForce = gravityInfluenceDampingFactor * dampingFactorToAttractiveForceFactor; 

		foreach( iterationCelestialInfo; celestialInfos ) {
			const double gravityForce = Orbit.calculateForceBetweenObjectsByRadius(iterationCelestialInfo.celestialObject.mass, iterationCelestialInfo.orbitRadius, celestialMass, orbitRadius);
			
			if( gravityForce > maximalAttractiveForce ) {
				return false;
			}
		}

		return true;
	}
   
	protected FCelestialObject generateCandidateForNoncenterCelestialObject(ref RandomStream random) const {
		const CelestialNoncenterBlueprint blueprint = celestialNoncenterBlueprints.sample(random.getFraction());

		FCelestialObject resultCelestialObject;
		resultCelestialObject.type = blueprint.celestialObjectType;
		resultCelestialObject.mass = linearInterpolate((double)random.getFraction(), blueprint.massMin, blueprint.massMax);
		
		if( blueprint.canHaveAtmosphere ) {
			resultCelestialObject.hasAtmosphere = ((random.GetUnsignedInt() % 2) == 1);
		}
		else {
			resultCelestialObject.hasAtmosphere = false;
		}

		return resultCelestialObject;
	}

	protected EnumeratedDistribution!CelestialNoncenterBlueprint celestialNoncenterBlueprints;
  
	protected /*virtual*/ void initializeCelestialNoncenterBlueprints() {
		// PLANET
		{
			EnumeratedDistribution!CelestialNoncenterBlueprint.Entry newEntry;
			newEntry.data.celestialObjectType = EnumCelestialObjectType.GenericCelestialBody;
			newEntry.data.massMin = 3.3 * Math.exponentInteger!double(10.0, 23); // min mass for a planet, i've just taken the mass of mercury
			newEntry.data.massMax = 13.0 * MassTable.Jupiter; // see https://en.wikipedia.org/wiki/Planet#Extrasolar_planet_definition
			newEntry.data.canHaveAtmosphere = true;
			newEntry.normalizedPropability = 1.0;
			    
			celestialNoncenterBlueprints.addEntry(newEntry);
		}
			  
		// TODO< others >
	}
}
