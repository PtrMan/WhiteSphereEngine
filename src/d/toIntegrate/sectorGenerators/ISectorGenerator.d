#include "CelestialCluster.h"
#include "CelestialSettings.h"

interface ISectorGenerator {
	~this();
	void createCelestialClustersForSector(CelestialCluster[] destinationArray, const int64_t[3] sectorPosition, const InternalScalar sectorsize, const ref CelestialSettings celestialSettings);
  
	protected static int64_t calculateHashForUniverseSector(const int64_t[3] sectorPosition);
}
