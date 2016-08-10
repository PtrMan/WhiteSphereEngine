module memory.lowLevel.MemoryHelpers;

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
SizeType[] generateSizeList(SizeType)(SizeType lowerBound, SizeType upperBound, SizeType function(SizeType lastValue, SizeType counter) generator) {
	assert(lowerBound <= upperBound);
	
	SizeType[] resultList;
	SizeType lastValue = 0;
	SizeType counter = 0;
	for(;;) {
		SizeType currentValue = generator(lastValue, counter);
		
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
