module whiteSphereEngine.physics.material.SpecificHeatLookup;

import whiteSphereEngine.misc.LookupInterpolator;

// looks up the specific heat in a table which is ordered by absolute temperatue in kelvin and calculates the heatchange
class SpecificHeatLookup {
	final this(size_t numberOfColumns, uint numberOfSkipedRows, size_t indexOfValue, size_t queryIndex) {
		this.numberOfColumns = numberOfColumns;
		this.numberOfSkipedRows = numberOfSkipedRows;
		this.indexOfValue = indexOfValue;
		this.queryIndex = queryIndex;
	}

	final void load(string path) {
		lookupInterpolator = new LookupInterpolator;
		lookupInterpolator.parseTsvAndReadIntoLookupTableFromFile(path, numberOfColumns, numberOfSkipedRows);
	}

	final float lookupSpecificHeatInJoules(float temperatureInKelvin) {
		const float specificHeatInKiloJoulesPerKilogramPerKelvin = lookupInterpolator.lookupAndInterpolate(steamTemperatureInKelvin, indexOfValue, queryIndex);
		const float specificHeatInJoulesPerKilogramPerKelvin = specificHeatInKiloJoulesPerKilogramPerKelvin * 1000.0f;
		return specificHeatInJoulesPerKilogramPerKelvin;
	}

	final float calcDeltaTemperature(float steamTemperatureInKelvin, float massInKg, float deltaEnergyInJoules) {
		const float specificHeatInJoulesPerKilogramPerKelvin = lookupSpecificHeatInJoules(steamTemperatureInKelvin);
		return deltaEnergyInJoules / (specificHeatInJoulesPerKilogramPerKelvin*massInKg); // see http://hyperphysics.phy-astr.gsu.edu/hbase/thermo/spht.html
	}

	private LookupInterpolator lookupInterpolator;

	private size_t numberOfColumns;
	private uint numberOfSkipedRows;
	private size_t indexOfValue, queryIndex;
}
