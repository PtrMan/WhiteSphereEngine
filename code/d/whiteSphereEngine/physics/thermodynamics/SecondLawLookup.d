module whiteSphereEngine.physics.thermodynamics.SecondLawLookup;


import whiteSphereEngine.serialization.csv.CsvHelper;

class SecondLawLookupForWater {
	private static struct LookupEntry {
		float[3] specificEnthalpy;
		float pressureInKpa; 
	}

	final float lookupAndInterpolateSpecificEnthalpyOfLiquidWater(float pressureInKpa) 
	in {
		assert(pressureInKpa >= 0.0f);
	}
	body {
		return lookupAndInterpolateSpecificEnthalpy(pressureInKpa, 0);
	}

	final float lookupAndInterpolateSpecificEnthalpyOfSteam(float pressureInKpa) 
	in {
		assert(pressureInKpa >= 0.0f);
	}
	body {
		return lookupAndInterpolateSpecificEnthalpy(pressureInKpa, 2);
	}


	final private float lookupAndInterpolateSpecificEnthalpy(float pressureInKpa, size_t specificEnthalpyIndex)
	in {
		assert(pressureInKpa >= 0.0f);
	}
	body {
		size_t indexOfEntryWherePressureEqualOrLarger = getIndexOfEntryWherePressureIsEqualOrLarger(pressureInKpa);
		bool isFirst = indexOfEntryWherePressureEqualOrLarger == 0;
		bool isLast = indexOfEntryWherePressureEqualOrLarger == lookupEntries.length-1;

		float specificEnthalpyWherePressureEqualOrLarger = lookupEntries[indexOfEntryWherePressureEqualOrLarger].specificEnthalpy[specificEnthalpyIndex];
		float pressureInKpaWherePressureEqualOrLarger = lookupEntries[indexOfEntryWherePressureEqualOrLarger].pressureInKpa;

		// for the case if its the first entry and the pressure is below the pressure of the first entry
		if( isFirst && pressureInKpa < pressureInKpaWherePressureEqualOrLarger ) {
			return specificEnthalpyWherePressureEqualOrLarger;
		}

		// if its the last entry we can't interpolate with anything
		if( isLast ) {
			return specificEnthalpyWherePressureEqualOrLarger;
		}
		// else we are here

		float specificEnthalpyNext = lookupEntries[indexOfEntryWherePressureEqualOrLarger+1].specificEnthalpy[specificEnthalpyIndex];
		float pressureInKpaNext = lookupEntries[indexOfEntryWherePressureEqualOrLarger+1].pressureInKpa;

		return interpolate(pressureInKpaWherePressureEqualOrLarger, pressureInKpaNext, pressureInKpa, specificEnthalpyWherePressureEqualOrLarger, specificEnthalpyNext);
	}

	// interpolate for c between a and b
	private static float interpolate(float a, float b, float c, float aValue, float bValue) 
	in {
		assert(a < b && c >= a && c <= b);
	}
	body {
		float relative = (c - a) / (b - a);
		return interpolate(aValue, bValue, relative); 
	}

	private static float interpolate(float a, float b, float relative) {
		return a + (b - a) * relative;
	}

	private final size_t getIndexOfEntryWherePressureIsEqualOrLarger(float pressureInKpa) 
	in {
		assert(pressureInKpa >= 0.0f);
	}
	body {
		// TODO< use binary search from d standard library >
		foreach( i; 0..lookupEntries.length ) {
			if( lookupEntries[i].pressureInKpa >= pressureInKpa ) {
				return i;
			}
		}

		// if it wasn't found we return the last entry
		return lookupEntries.length-1;
	}

	private final void parseTsvAndReadIntoLookupTable(string tsvTable) {
		const size_t indexPressureInKpa = 0;
		const size_t indexSpecificEnthalpyLiquidWater = 4;
		const size_t indexSpecificEnthalpyEvaporationWater = 5;
		const size_t indexSpecificEnthalpySteamWater = 6;

		import std.typecons : Tuple;
		alias Tuple!(float, float, float, float, float, float, float, float, float, float, float) RowType;

		RowType[] rows = jumpOverHeaderLinesAndReadCsv!RowType(tsvTable, 1, "\t");

		foreach( iterationRow; rows ) {
			LookupEntry createdLookupEntry;
			createdLookupEntry.pressureInKpa = iterationRow[indexPressureInKpa];
			createdLookupEntry.specificEnthalpy[0] = iterationRow[indexSpecificEnthalpyLiquidWater];
			createdLookupEntry.specificEnthalpy[1] = iterationRow[indexSpecificEnthalpyEvaporationWater];
			createdLookupEntry.specificEnthalpy[2] = iterationRow[indexSpecificEnthalpySteamWater];
			lookupEntries ~= createdLookupEntry;
		}
	}

	final void parseTsvAndReadIntoLookupTableFromFile(string path) {
		import std.file : read;
		string str = cast(string)read(path);
		parseTsvAndReadIntoLookupTable(str);
	}

	private LookupEntry[] lookupEntries;
}
