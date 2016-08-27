module whiteSphereEngine.misc.LookupInterpolator;

import whiteSphereEngine.serialization.csv.CsvHelper;

class LookupInterpolator {
	private static struct LookupEntry {
		float[] values; 
	}

	final public float lookupAndInterpolate(float value, size_t indexOfValue, size_t queryIndex)
	in {
		assert(value >= 0.0f);
	}
	body {
		size_t indexOfEntryWhereValueEqualOrLarger = getIndexOfEntryWhereValueIsEqualOrLarger(value, indexOfValue);

		bool isFirst = indexOfEntryWhereValueEqualOrLarger == 0;
		bool isLast = indexOfEntryWhereValueEqualOrLarger == lookupEntries.length-1;

		float queriedValueWhereValueEqualOrLarger = lookupEntries[indexOfEntryWhereValueEqualOrLarger].values[queryIndex];
		float valueWhereValueEqualOrLarger = lookupEntries[indexOfEntryWhereValueEqualOrLarger].values[indexOfValue];

		// for the case if its the first entry and the pressure is below the pressure of the first entry
		if( isFirst && value < valueWhereValueEqualOrLarger ) {
			return queriedValueWhereValueEqualOrLarger;
		}

		// if its the last entry we can't interpolate with anything
		if( isLast ) {
			return queriedValueWhereValueEqualOrLarger;
		}
		// else we are here

		float queriedValueNext = lookupEntries[indexOfEntryWhereValueEqualOrLarger+1].values[queryIndex];
		float valueNext = lookupEntries[indexOfEntryWhereValueEqualOrLarger+1].values[indexOfValue];

		return interpolate(valueWhereValueEqualOrLarger, valueNext, value, queriedValueWhereValueEqualOrLarger, queriedValueNext);
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

	private final size_t getIndexOfEntryWhereValueIsEqualOrLarger(float value, size_t indexOfValue) 
	in {
		assert(value >= 0.0f);
	}
	body {
		// TODO< use binary search from d standard library >
		foreach( i; 0..lookupEntries.length ) {
			if( lookupEntries[i].values[indexOfValue] >= value ) {
				return i;
			}
		}

		// if it wasn't found we return the last entry
		return lookupEntries.length-1;
	}

	private final void parseTsvAndReadIntoLookupTable(string tsvTable) {
		import std.typecons : Tuple;
		alias Tuple!(float, float, float, float, float, float, float, float) RowType;

		RowType[] rows = jumpOverHeaderLinesAndReadCsv!RowType(tsvTable, 1, "\t");

		foreach( iterationRow; rows ) {
			LookupEntry createdLookupEntry;
			createdLookupEntry.values.length = 8;
			createdLookupEntry.values[0] = iterationRow[0];
			createdLookupEntry.values[1] = iterationRow[1];
			createdLookupEntry.values[2] = iterationRow[2];
			createdLookupEntry.values[3] = iterationRow[3];
			createdLookupEntry.values[4] = iterationRow[4];
			createdLookupEntry.values[5] = iterationRow[5];
			createdLookupEntry.values[6] = iterationRow[6];
			createdLookupEntry.values[7] = iterationRow[7];
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
