import whiteSphereEngine.physics.thermodynamics.SecondLawLookup;
import whiteSphereEngine.physics.thermodynamics.SecondLaw;

import std.stdio;

void main() {
	SecondLawLookupForWater secondLawLookup = new SecondLawLookupForWater();
	secondLawLookup.parseTsvAndReadIntoLookupTableFromFile("resources/engine/physics/material/Saturated steam.tsv");

	float pressureInKpa = 101.33f; // atmospheric conditions 

	float specificEnthalpyOfLiquidWaterBefore = 0.0f; // TODO< lookup by temperature and interpolated with 0 for the first entry
	float specificEnthalpyOfLiquidWaterAfter = secondLawLookup.lookupAndInterpolateSpecificEnthalpyOfLiquidWater(pressureInKpa);

	double temperatureBeforeInKelvin = 273.0;
	double temperatureAfterInKelvin = 373.0;

	writeln(specificEnthalpyOfLiquidWaterAfter);
	

	double changeInSpecificEntropy = calcSpecificEntropy(specificEnthalpyOfLiquidWaterBefore, temperatureBeforeInKelvin, specificEnthalpyOfLiquidWaterAfter, temperatureAfterInKelvin);
	writeln(changeInSpecificEntropy);
}
