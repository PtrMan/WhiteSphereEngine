module memory.lowLevel.QuickFitAllocator;

import std.range : SortedRange;
import std.algorithm.searching : find, until;
import std.array : array;


import memory.FreeList;
import memory.lowLevel.MemoryHelpers;

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
	
	public final Type allocate(size_t requestedSize, size_t alignment, out bool outOfMemory) {
		bool granularisationInRange;
		size_t size = granularizeAndCheckIfPossible(requestedSize, granularisationInRange);
		
		Type resultAdress;
		if( granularisationInRange ) {
			return allocateElementWithSizeInternal(size, alignment, outOfMemory);
		}
		else {
			// allocate with the parent alorithm and store the information about the allocation in the big chunk list
			
			Type parentAllocatedMemory = parentAllocator.allocate(requestedSize, alignment, outOfMemory);
			
			// insert into parentAllocations where the index fits best
			size_t insertIndex = parentAllocations.findIndexInArrayWhere(parentAllocatedMemory);
			parentAllocations.insertInPlace(insertIndex, parentAllocatedMemory);
			
			resultAdress = parentAllocatedMemory;
		}
		
		assert((resultAdress % alignment) == 0);
		return resultAdress;
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
		
		auto foundElements = freeListsBySortedSize.find!("a.size == b")(size);
		assert(foundElements.length == 1);
		
		FreeListWithSize freeListWithSize = foundElements[0];
		assert(freeListWithSize.size == size);
		
		bool isEmpty;
		// TODO< iterate over freelist until an element with the right alignment was hit, if we didn't hit one then we have to call the parentAllocator >
		Type allocatedElement = freeListWithSize.freeList.allocate(isEmpty);
		if( isEmpty ) {
			allocatedElement = parentAllocator.allocate(size, alignment, outOfMemory);
		}
		
		return allocatedElement;
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
}
