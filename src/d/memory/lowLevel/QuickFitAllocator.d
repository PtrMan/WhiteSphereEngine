module memory.lowLevel.QuickFitAllocator;

import std.range : SortedRange;
import std.algorithm.searching : find, until;
import std.array : array;
import std.typecons : Nullable;


import memory.FreeList;
import memory.lowLevel.MemoryHelpers;

private const bool DEBUG = true;

// tries to allocate from a set of Freelist allocators (for different sizes) for the closest fitting size
// for small allocations.
// If it failed it allocates from the ParentAllocator (and will return it back to the corresponding freelist)
// For big allocations it just allocates from the ParentAllocator directly. 
// The parent allocator is usually first fit
class QuickFitAllocator(Type, ParentAllocatorType, SizeType = size_t) {
	protected static class FreeListWithSize {
		public final this(SizeType size) {
			this.size = size;
		}
		
		public FreeList!Type freeList;
		public SizeType size;
	}
	
	// type for the allocated size with an hint
	public static struct HintAllocatedSize {
		public final this(SizeType size, bool wasParentAllocated) {
			this.protectedSize = size;
			this.protectedWasParentAllocated = wasParentAllocated;
		}
		
		public final @property bool wasParentAllocated() {
			return protectedWasParentAllocated;
		}
		
		public final @property SizeType size() {
			assert(!wasParentAllocated);
			return protectedSize;
		}
		
		protected SizeType protectedSize;
		protected bool protectedWasParentAllocated;
	}
	
	import std.range : SortedRange;
	
	protected SortedRange!(SizeType[]) freeListSizes;
	protected SortedRange!(FreeListWithSize[]) freeListsBySortedSize;
	
	protected SortedRange!(Type[]) parentAllocations; // allocations done with the parent allocator because they were too large
	protected ParentAllocatorType parentAllocator;
	
	// allocations up to maxAllocationSize are handled over the freelist mechanism
	// minAllocationSize is to avoid extremly small allocations
	public final this(SizeType minAllocationSize, SizeType maxAllocationSize) {
		fillAllocationSizes(minAllocationSize, maxAllocationSize);
	}
	
	protected final void fillAllocationSizes(SizeType minAllocationSize, SizeType maxAllocationSize) {
		static SizeType exponentialSizeStrategy(SizeType lastSize, SizeType index) {
			import std.math : pow;
			return cast(SizeType)pow(1.5, cast(double)index);
		}
		
		freeListSizes = SortedRange!(SizeType[])(generateSizeList(minAllocationSize, maxAllocationSize, &exponentialSizeStrategy));
	}
	
	public final void setParentAllocator(ParentAllocatorType parentAllocator) {
		this.parentAllocator = parentAllocator;
	}
	
	// hintAllocatedSize will hold the size of the chunk it got allocated from/to
	// is just an hint to speed up freeing
	public final Type allocate(SizeType requestedSize, SizeType alignment, out bool outOfMemory, out HintAllocatedSize hintAllocatedSize) {
		bool granularisationInRange;
		SizeType size = granularizeAndCheckIfPossible(requestedSize, granularisationInRange);
		
		static if(DEBUG) {
			import std.format;
			debugFunction(format("quickfit allocate called with size=%s, alignment=%s", requestedSize, alignment));
			debugFunction(format("\tgranluarized size=%s, granularisation in range=%s", size, granularisationInRange));
		}
		
		Type resultAdress;
		if( granularisationInRange ) {
			hintAllocatedSize = HintAllocatedSize(size, false);
			return allocateElementWithSizeInternal(size, alignment, outOfMemory);
		}
		else {
			// allocate with the parent alorithm and store the information about the allocation in the big chunk list
			
			Type parentAllocatedMemory = parentAllocator.allocate(requestedSize, alignment, outOfMemory);
			
			// insert into parentAllocations where the index fits best
			size_t insertIndex = parentAllocations.findIndexInArrayWhere(parentAllocatedMemory);
			parentAllocations.insertInPlace(insertIndex, parentAllocatedMemory);
			
			resultAdress = parentAllocatedMemory;
			
			hintAllocatedSize = HintAllocatedSize(0, true);
		}
		
		assert((resultAdress % alignment) == 0);
		return resultAdress;
	}
	
	public final void deallocate(Type offset, out bool cantFindAdress, HintAllocatedSize hintAllocatedSize) {
		cantFindAdress = true;
		
		if( hintAllocatedSize.wasParentAllocated ) { // check if it got allocated by the parent allocator directly
			parentAllocator.deallocate(offset, cantFindAdress);
		}
		else {
			assert(hintAllocatedSize.size >= 0);
			
			bool granularisationInRange;
			SizeType granularizedSize = granularizeAndCheckIfPossible(hintAllocatedSize.size, granularisationInRange);
			assert(granularisationInRange); // must be in range, else we have an internal error
			assert(granularizedSize == hintAllocatedSize.size);
			if( !granularisationInRange ) {
				cantFindAdress = true;
				return;
			}
			
			FreeListWithSize freeListBySize = getFreeListBySize(hintAllocatedSize.size);
			freeListBySize.freeList.free(offset);
			cantFindAdress = false;
			return;
		}
	}
	
	protected final SizeType granularizeAndCheckIfPossible(SizeType requestedSize, out bool granularisationInRange) {
		granularisationInRange = false;
		
		SizeType[] foundUntilResult = freeListSizes.until!("a >= b")(requestedSize).array;
		
		if( foundUntilResult.length == freeListSizes.length ) {
			granularisationInRange = false;
			return 0;
		}
		else {
			size_t sizeIndex = foundUntilResult.length;
			SizeType foundSize = freeListSizes[sizeIndex];
			granularisationInRange = true;
			return foundSize;
		}
	}
	
	protected final Type allocateElementWithSizeInternal(SizeType size, SizeType alignment, out bool outOfMemory) {
		checkForAndAddAllocatorForSize(size);
		
		FreeListWithSize freeListWithSize = getFreeListBySize(size);
		assert(freeListWithSize.size == size);
		
		// try to find a element in freelist with the right alignment
		// TODO< if this is too slow we might sort the freelist after the alignments and binary search witht the standard algorithms >
		{
			static bool condition(Type element, SizeType alignment) {
				return (cast(size_t)element % alignment) == 0;
			}
			
			alias FreeList!Type.EnumAllocateWhereResult AllocResultEnumType;
			AllocResultEnumType freeListAllocateWhereResult;
			Type allocatedElement = freeListWithSize.freeList.allocateWhere(&condition, alignment, freeListAllocateWhereResult);
			final switch(freeListAllocateWhereResult) with (AllocResultEnumType) {
				case ISEMPTY: case COULDNTFIND:
				return parentAllocator.allocate(size, alignment, outOfMemory);
				
				case FOUND:
				outOfMemory = false;
				return allocatedElement;
			}
		}
	}
	
	protected final FreeListWithSize getFreeListBySize(SizeType size) {
		auto foundElements = freeListsBySortedSize.find!"a.size == b"(size);
		assert(foundElements.length == 1);
		
		FreeListWithSize freeListWithSize = foundElements[0];
		return freeListWithSize;
	}
	
	protected final void checkForAndAddAllocatorForSize(SizeType size) {
		bool sizeExists = logarithmicCanFindForFreeListsBySortedSize(size);
		if( !sizeExists ) {
			addFreeListWithSize(new FreeListWithSize(size));
		}
	}
	
	protected bool logarithmicCanFindForFreeListsBySortedSize(SizeType size) {
		import std.algorithm.searching : find;
		
		auto foundElements = freeListsBySortedSize.find!("a.size == b")(size);
		assert(foundElements.length <= 1);
		return foundElements.length == 1;
	}
	
	protected final void addFreeListWithSize(FreeListWithSize toAdd) {
		assert(!logarithmicCanFindForFreeListsBySortedSize(toAdd.size));
				
		size_t foundIndex = freeListsBySortedSize.findIndexInArrayWhere!(FreeListWithSize, Type, "a.size >= b")(toAdd.size);
		
		freeListsBySortedSize.insertInPlace(foundIndex, toAdd);
	}
	
	unittest {
		// TODO< unittest addFreeListWithSize >
	}
	
	protected final void debugFunction(string text) {
		import std.stdio;
		writeln(text);
	}

}
