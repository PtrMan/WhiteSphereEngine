module memory.lowLevel.MemoryHelpers;

/+
// TODO< unittest >
size_t findIndexInArrayWhere(Type)(Type[] array, bool delegate(Type element) comparisionGreater) {
	size_t findRecursive(size_t minIndex, size_t maxIndex) {
		assert(minIndex <= maxIndex);
		
		bool found = minIndex == maxIndex;
		if( found ) {
			size_t foundIndex = minIndex;
			return foundIndex;
		}
		
		size_t midIndex = minIndex + (maxIndex - minIndex) / 2;
		if( comparisionGreater(array[midIndex]) ) {
			return findRecursive(minIndex, midIndex);
		}
		else {
			return findRecursive(midIndex + 1, maxIndex);
		}
	}

	
	size_t minIndex = 0;
	size_t maxIndex = array.length;
	return findRecursive(minIndex, maxIndex);
}
+/

static import std.array;
import std.range : SortedRange;
import std.algorithm.searching : until;

// TODO< unittest >
size_t findIndexInArrayWhere(Type, ValueType, string comparision = "a >= b")(SortedRange!(Type[]) arr, ValueType value) {
	Type[] foundUntilResult = std.array.array(until!(comparision)(std.array.array(arr), value));
	size_t index = foundUntilResult.length;
	return index;
}

// small helper
void insertInPlace(Type)(ref SortedRange!(Type[]) arr, size_t index, Type element) {
	Type[] replaceResult = std.array.array(arr);
	std.array.insertInPlace(replaceResult, index, element);
	arr = SortedRange!(Type[])(replaceResult);
}

// lower and upper bound are inclusive
size_t[] generateSizeList(size_t lowerBound, size_t upperBound, size_t function(size_t lastValue, size_t counter) generator) {
	assert(lowerBound <= upperBound);
	
	size_t[] resultList;
	size_t lastValue = 0;
	size_t counter = 0;
	for(;;) {
		size_t currentValue = generator(lastValue, counter);
		
		if( currentValue > upperBound ) {
			break;
		}
		
		if( currentValue >= lowerBound ) {
			resultList ~= currentValue;
		}
		
		counter++;
		lastValue = currentValue;
	}
	
	return resultList;
}
