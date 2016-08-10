module memory.lowLevel.QuickFitAllocator;

import std.range : SortedRange;
import std.algorithm.searching : find, until;
import std.array : array;


import memory.FreeList;
import memory.lowLevel.MemoryHelpers;

private const bool DEBUG = true;

// tries to allocate from a set of Freelist allocators (for different sizes) for the closest fitting size
// for small allocations.
// If it failed it allocates from the ParentAllocator (and will return it back to the corresponding freelist)
// For big allocations it just allocates from the ParentAllocator directly. 
// The parent allocator is usually first fit
class QuickFitAllocator(Type, ParentAllocatorType) {
	protected static class FreeListWithSize {
		public final this(size_t size) {
			this.size = size;
		}
		
		public FreeList!Type freeList;
		public size_t size;
	}
	
	import std.range : SortedRange;
	
	protected SortedRange!(size_t[]) freeListSizes;
	protected SortedRange!(FreeListWithSize[]) freeListsBySortedSize;
	
	protected SortedRange!(Type[]) parentAllocations; // allocations done with the parent allocator because they were too large
	protected ParentAllocatorType parentAllocator;
	
	// allocations up to maxAllocationSize are handled over the freelist mechanism
	// minAllocationSize is to avoid extremly small allocations
	public final this(size_t minAllocationSize, size_t maxAllocationSize) {
		fillAllocationSizes(minAllocationSize, maxAllocationSize);
	}
	
	public final void setParentInitialChunk(Type offset, size_t size) {
		parentAllocator.setInitialChunk(offset, size);
	}
	
	protected final void fillAllocationSizes(size_t minAllocationSize, size_t maxAllocationSize) {
		static size_t exponentialSizeStrategy(size_t lastSize, size_t index) {
			import std.math : pow;
			return cast(size_t)pow(1.5, cast(double)index);
		}
		
		freeListSizes = SortedRange!(size_t[])(generateSizeList(minAllocationSize, maxAllocationSize, &exponentialSizeStrategy));
	}
	
	public final void setParentAllocator(ParentAllocatorType parentAllocator) {
		this.parentAllocator = parentAllocator;
	}
	
	// hintAllocatedSize will hold the size of the chunk it got allocated from/to
	// is -1 if it got allocated directly by the parentAllocation
	// is just an hint to speed up freeing
	public final Type allocate(size_t requestedSize, size_t alignment, out bool outOfMemory, out ptrdiff_t hintAllocatedSize) {
		bool granularisationInRange;
		size_t size = granularizeAndCheckIfPossible(requestedSize, granularisationInRange);
		
		static if(DEBUG) {
			import std.format;
			debugFunction(format("quickfit allocate called with size=%s, alignment=%s", requestedSize, alignment));
			debugFunction(format("\tgranluarized size=%s, granularisation in range=%s", size, granularisationInRange));
		}
		
		Type resultAdress;
		if( granularisationInRange ) {
			hintAllocatedSize = size;
			return allocateElementWithSizeInternal(size, alignment, outOfMemory);
		}
		else {
			// allocate with the parent alorithm and store the information about the allocation in the big chunk list
			
			Type parentAllocatedMemory = parentAllocator.allocate(requestedSize, alignment, outOfMemory);
			
			// insert into parentAllocations where the index fits best
			size_t insertIndex = parentAllocations.findIndexInArrayWhere(parentAllocatedMemory);
			parentAllocations.insertInPlace(insertIndex, parentAllocatedMemory);
			
			resultAdress = parentAllocatedMemory;
			hintAllocatedSize = -1;
		}
		
		assert((resultAdress % alignment) == 0);
		return resultAdress;
	}
	
	public final void deallocate(Type offset, out bool cantFindAdress, ptrdiff_t hintAllocatedSize) {
		cantFindAdress = true;
		
		if( hintAllocatedSize == -1 ) { // check if it got allocated by the parent allocator directly
			parentAllocator.deallocate(offset, cantFindAdress);
		}
		else {
			assert(hintAllocatedSize >= 0);
			
			bool granularisationInRange;
			size_t granularizedSize = granularizeAndCheckIfPossible(cast(size_t)hintAllocatedSize, granularisationInRange);
			assert(granularisationInRange); // must be in range, else we have an internal error
			assert(granularizedSize == hintAllocatedSize);
			if( !granularisationInRange ) {
				cantFindAdress = true;
				return;
			}
			
			FreeListWithSize freeListBySize = getFreeListBySize(cast(size_t)hintAllocatedSize);
			freeListBySize.freeList.free(offset);
			cantFindAdress = false;
			return;
		}
	}
	
	protected final size_t granularizeAndCheckIfPossible(size_t requestedSize, out bool granularisationInRange) {
		granularisationInRange = false;
		
		size_t[] foundUntilResult = freeListSizes.until!("a >= b")(requestedSize).array;
		
		if( foundUntilResult.length == freeListSizes.length ) {
			granularisationInRange = false;
			return 0;
		}
		else {
			size_t sizeIndex = foundUntilResult.length;
			size_t foundSize = freeListSizes[sizeIndex];
			granularisationInRange = true;
			return foundSize;
		}
	}
	
	protected final Type allocateElementWithSizeInternal(size_t size, size_t alignment, out bool outOfMemory) {
		checkForAndAddAllocatorForSize(size);
		
		FreeListWithSize freeListWithSize = getFreeListBySize(size);
		assert(freeListWithSize.size == size);
		
		// try to find a element in freelist with the right alignment
		// TODO< if this is too slow we might sort the freelist after the alignments and binary search witht the standard algorithms >
		{
			static bool condition(Type element, size_t alignment) {
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
	
	protected final FreeListWithSize getFreeListBySize(size_t size) {
		auto foundElements = freeListsBySortedSize.find!"a.size == b"(size);
		assert(foundElements.length == 1);
		
		FreeListWithSize freeListWithSize = foundElements[0];
		return freeListWithSize;
	}
	
	protected final void checkForAndAddAllocatorForSize(size_t size) {
		bool sizeExists = logarithmicCanFindForFreeListsBySortedSize(size);
		if( !sizeExists ) {
			addFreeListWithSize(new FreeListWithSize(size));
		}
	}
	
	protected bool logarithmicCanFindForFreeListsBySortedSize(size_t size) {
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
