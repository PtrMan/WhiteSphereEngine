module whiteSphereEngine.physics.material.SpecificHeatLookup;

import whiteSphereEngine.misc.LookupInterpolator;

// looks up the specific heat in a table which is ordered by absolute temperatue in kelvin and calculates the heatchange
class SpecificHeatLookup {
	final void load(string path) {
		lookupInterpolator = new LookupInterpolator;
		lookupInterpolator.parseTsvAndReadIntoLookupTableFromFile(path/*"resources/engine/physics/material/Specific heat water vapor.tsv"*/, 2, 2);
	}

	final float calcDeltaTemperature(float steamTemperatureInKelvin, float massInKg, float deltaEnergyInJoules) {
		const float specificHeatInKiloJoulesPerKilogramPerKelvin = lookupInterpolator.lookupAndInterpolate(steamTemperatureInKelvin, 0, 1);
		const float specificHeatInJoulesPerKilogramPerKelvin = specificHeatInKiloJoulesPerKilogramPerKelvin * 1000.0f;
		return deltaEnergyInJoules / (specificHeatInJoulesPerKilogramPerKelvin*massInKg); // see http://hyperphysics.phy-astr.gsu.edu/hbase/thermo/spht.html
	}

	private LookupInterpolator lookupInterpolator;
}