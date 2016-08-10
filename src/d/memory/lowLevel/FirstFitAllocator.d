module memory.lowLevel.FirstFitAllocator;

import std.array : array;
import std.range : SortedRange;
import std.algorithm.mutation : remove;

import memory.lowLevel.MemoryHelpers : findIndexInArrayWhere, insertInPlace;

private const bool DEBUG = true;

// for description of first fit see
// http://odl.sysworks.biz/disk$cddoc03jul11/decw$book/d32va122.p78.decw$book
class FirstFitAllocator(Type, SizeType = size_t) {
	protected static class ElementWithSize {
		public Type offset;
		public SizeType size;
		
		public final this(Type offset, SizeType size) {
			this.offset = offset;
			this.size = size;
		}
	}
	
	public SizeType threshold = 0; // used to combat fragmentation
	                             // see https://www.cs.rit.edu/~ark/lectures/gc/03_03_02.html
	
	protected SortedRange!(ElementWithSize[]) freeList; // sorted after offset
	protected SortedRange!(ElementWithSize[]) usedList; // sorted after offset, used to retrive size information
	
	protected SizeType overallMemorySize;
	
	public final void setInitialChunk(Type offset, SizeType size) {
		assert(freeList.length() == 0 && usedList.length() == 0);
		if( freeList.length() != 0 && usedList.length() != 0 ) {
			// inconsistent call, this should not happen, we just ignore it
			return;
		}
		
		overallMemorySize = size;
		freeList = SortedRange!(ElementWithSize[])([new ElementWithSize(offset, size)]);
	}
	
	// alloction is satisfied by first block which is large enough
	public final Type allocate(SizeType size, SizeType alignment, out bool outOfMemory) {
		outOfMemory = true;
		
		static if( DEBUG ) {
			import std.format;
			debugFunction(format("allocate called with size=%s, alignment=%s", size, alignment));
		}
		
		checkInvariants();
		
		bool hasFoundElementWithAtLeastFreeMemory;
		size_t foundIndex;
		import std.algorithm.comparison : min;
		ElementWithSize foundElementWithAtLeastFreeMemory = searchFirstFreeElementWithAtLeastFreeMemory(size + min(threshold, alignment), foundIndex, hasFoundElementWithAtLeastFreeMemory);
		
		static if( DEBUG ) {
			import std.format;
			debugFunction(format("\thasFoundElementWithAtLeastFreeMemory = %s", hasFoundElementWithAtLeastFreeMemory));
		}		
		
		if( !hasFoundElementWithAtLeastFreeMemory ) {
			outOfMemory = true;
			return Type.init;
		}
		
		// else we are here
		
		import helpers.Alignment : alignAt;
		
		// split the element
		//  we do this in place to save some cycles and GC preasure
		SizeType allocatedSizeWithAlignment = alignAt(size, alignment);
		assert(foundElementWithAtLeastFreeMemory.size >= allocatedSizeWithAlignment);
		Type nextFreeOffset = foundElementWithAtLeastFreeMemory.offset + allocatedSizeWithAlignment;
		SizeType nextFreeSize = foundElementWithAtLeastFreeMemory.size - allocatedSizeWithAlignment;
		
		Type resultOffset = foundElementWithAtLeastFreeMemory.offset;
		
		{ // insert into the right index
			size_t usedListInsertIndex = usedList.findIndexInArrayWhere!(ElementWithSize, Type, "a.offset >= b")(foundElementWithAtLeastFreeMemory.offset);
			memory.lowLevel.MemoryHelpers.insertInPlace!(ElementWithSize)(usedList, usedListInsertIndex, new ElementWithSize(foundElementWithAtLeastFreeMemory.offset, allocatedSizeWithAlignment));
		}
		
		foundElementWithAtLeastFreeMemory.offset = nextFreeOffset;		
		foundElementWithAtLeastFreeMemory.size = nextFreeSize;
		
		assert((resultOffset % alignment) == 0); // make sure the alignment isn't screwed up
		
		static if( DEBUG ) {
			import std.format;
			debugFunction(format("\tallocation success, offset=%s", resultOffset));
		}
		
		checkInvariants();
		
		outOfMemory = false;
		return resultOffset;
	}
	
	public final void deallocate(Type offset, out bool cantFindAdress) {
		import std.array : insertInPlace;
		
		static if( DEBUG ) {
			import std.format;
			debugFunction(format("deallocate called, offset=%s", offset));
		}
		
		checkInvariants();
		
		cantFindAdress = true;
		
		// find in used, remeber the size, remove from used
		
		size_t foundIndexInUsed = usedList.findIndexInArrayWhere!(ElementWithSize, Type, "a.offset >= b")(offset);
		if( usedList[foundIndexInUsed].offset != offset ) {
			cantFindAdress = true;
			return;
		}
		
		SizeType associatedSize = usedList[foundIndexInUsed].size;
		
		
		static if( DEBUG ) {
			import std.format;
			debugFunction(format("\t removal, foundIndexInUsed=%s", foundIndexInUsed));
		}
		usedList = SortedRange!(ElementWithSize[])(usedList.array.remove(foundIndexInUsed));
		checkInvariantsOffsets(); // removal could happen at wrong index

		
		// insert into free, remember index
		size_t insertIndex = 0;
		if( freeList.length > 0 ) {
			insertIndex = freeList.findIndexInArrayWhere!(ElementWithSize, Type, "a.offset >= b")(offset);
		}
		
		memory.lowLevel.MemoryHelpers.insertInPlace!(ElementWithSize)(freeList, insertIndex, new ElementWithSize(offset, associatedSize));
		
		checkInvariants();
		
		// try to merge
		tryMergeAtFreeIndex(insertIndex);
		checkInvariants();// merging could be errorous
		
		cantFindAdress = false; // everything is fine
	}
	
	protected final void tryMergeAtFreeIndex(size_t candidateIndex) {
		assert(freeList.length >= 1);
		
		static if( DEBUG ) {
			import std.format;
			debugFunction(format("\ttryMergeAtFreeIndex, index=%s", candidateIndex));
		}
		
		if( freeList.length <= 1 ) {
			// no work to do
			return;
		}
		
		assert(candidateIndex < freeList.length);
		
		bool tryToMergeWithNextAtIndex(size_t index) {
			bool mergeNeeded = cast(SizeType)freeList[index].offset + freeList[index].size == cast(SizeType)freeList[index+1].offset;
			if( mergeNeeded ) {
				freeList[index].size += freeList[index+1].size;
				freeList = SortedRange!(ElementWithSize[])(freeList.array.remove(index+1));
			}
			bool wasMerged = mergeNeeded;
			return wasMerged;
		}
		
		if( candidateIndex == 0 ) { // just merge first with second
			tryToMergeWithNextAtIndex(candidateIndex);
		}
		else if( candidateIndex == freeList.length - 1 ) { // just merge last with previous
			tryToMergeWithNextAtIndex(candidateIndex-1);
		}
		else { // try to merge middle
			tryToMergeWithNextAtIndex(candidateIndex);
			tryToMergeWithNextAtIndex(candidateIndex-1);
		}
	}
	
	protected final ElementWithSize searchFirstFreeElementWithAtLeastFreeMemory(SizeType atLeastSize, out size_t foundIndex, out bool found) {
		found = false;
		
		foundIndex = 0;
		
		foreach( iterationFreelistElement; freeList ) {
			if( iterationFreelistElement.size >= atLeastSize ) {
				found = true;
				return iterationFreelistElement;
			}
			
			foundIndex++;
		}
		
		return null;
	}
	
	protected final void checkInvariantsOffsets() {
		void checkOffsetsIncreasing(ElementWithSize[] list) {
			/*import std.stdio;
			import std.format;
			foreach( i; 0..list.length ) {
				write(format("offset=%s,size=%s     ", list[i].offset, list[i].size));
			}
			writeln("");
			*/
			
			foreach( i; 0..cast(ptrdiff_t)list.length-1 ) {
				assert(cast(SizeType)list[i].offset < cast(SizeType)list[i+1].offset);
			}
		}
		
		// check if the offsets are increasing
		checkOffsetsIncreasing(freeList.array);
		checkOffsetsIncreasing(usedList.array);
		
	}
	
	protected final void checkInvariants() {
		checkInvariantsOffsets();
		
		// check if the freeblocks dont overlap
		foreach( i; 0..cast(ptrdiff_t)freeList.length-1 ) {
			assert(cast(SizeType)freeList[i].offset + freeList[i].size <= cast(SizeType)freeList[i+1].offset);
		}
		
		// check that the sum of all used and unused entries is overallMemorySize
		SizeType sumOfSizes = 0;
		
		foreach( iterationFreeElement; freeList ) {
			sumOfSizes += iterationFreeElement.size;
		}
		foreach( iterationUsedElement; usedList ) {
			sumOfSizes += iterationUsedElement.size;
		}
		
		assert(sumOfSizes == overallMemorySize);
		
	}
	
	protected final void debugFunction(string text) {
		import std.stdio;
		writeln(text);
	}
}


unittest { // allocation requsts without an initial chunk should fail
	alias FirstFitAllocator!size_t FirstFitAllocatorType;
	bool outOfMemory, cantFindAdress;
	
	FirstFitAllocatorType firstFit = new FirstFitAllocatorType();
	
	// allocation requests without an initial chunk should fail
	firstFit.allocate(64, 4, outOfMemory);
	assert(outOfMemory);
}

unittest { // reuses memory
	alias FirstFitAllocator!size_t FirstFitAllocatorType;
	bool outOfMemory, cantFindAdress;
	
	FirstFitAllocatorType firstFit = new FirstFitAllocatorType();
	
	firstFit.setInitialChunk(0, 65536); 
	
	size_t allocation0 = firstFit.allocate(64, 4, outOfMemory);
	assert(!outOfMemory);
	assert(allocation0 == 0);
	
	size_t allocation1 = firstFit.allocate(64, 4, outOfMemory);
	assert(!outOfMemory);
	assert(allocation1 == 64);
	
	firstFit.deallocate(allocation0, cantFindAdress);
	assert(!cantFindAdress);

	size_t allocation2 = firstFit.allocate(64, 4, outOfMemory);
	assert(!outOfMemory);
	assert(allocation2 == 0);
}


unittest {
	alias FirstFitAllocator!size_t FirstFitAllocatorType;
	bool outOfMemory, cantFindAdress;
	
	FirstFitAllocatorType firstFit = new FirstFitAllocatorType();
	
	firstFit.setInitialChunk(0, 65536); 
	
	size_t allocation0 = firstFit.allocate(64, 4, outOfMemory);
	assert(!outOfMemory);
	assert(allocation0 == 0);
	
	size_t allocation1 = firstFit.allocate(64, 4, outOfMemory);
	assert(!outOfMemory);
	assert(allocation1 == 64);
	
	firstFit.deallocate(allocation0, cantFindAdress);
	assert(!cantFindAdress);
	
	firstFit.deallocate(allocation1, cantFindAdress);
	assert(!cantFindAdress);

	size_t allocation3 = firstFit.allocate(128, 4, outOfMemory);
	assert(!outOfMemory);
	assert(allocation3 == 0); // must be zero because it should have merged the chunks
}

// we allocate 3 chunks, remove the first and last, and then the one in the middle
// then we allocate a big memory and it should have the adress zero
unittest {
	alias FirstFitAllocator!size_t FirstFitAllocatorType;
	bool outOfMemory, cantFindAdress;
	
	FirstFitAllocatorType firstFit = new FirstFitAllocatorType();
	
	firstFit.setInitialChunk(0, 65536); 
	
	size_t allocation0 = firstFit.allocate(64, 4, outOfMemory);
	assert(!outOfMemory);
	assert(allocation0 == 0);
	
	size_t allocation1 = firstFit.allocate(64, 4, outOfMemory);
	assert(!outOfMemory);
	assert(allocation1 == 64);
	
	size_t allocation2 = firstFit.allocate(64, 4, outOfMemory);
	assert(!outOfMemory);
	assert(allocation2 == 128);

	firstFit.deallocate(allocation0, cantFindAdress);
	assert(!cantFindAdress);
	
	firstFit.deallocate(allocation2, cantFindAdress);
	assert(!cantFindAdress);
	
	firstFit.deallocate(allocation1, cantFindAdress);
	assert(!cantFindAdress);


	size_t allocation3 = firstFit.allocate(200, 4, outOfMemory);
	assert(!outOfMemory);
	assert(allocation3 == 0); // must be zero because it should have merged the chunks
}
