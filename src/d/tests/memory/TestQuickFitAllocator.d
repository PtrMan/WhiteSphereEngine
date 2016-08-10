import memory.lowLevel.QuickFitAllocator;
import memory.lowLevel.FirstFitAllocator : FirstFitAllocator;

void testQuickFitAllocator() {
	alias FirstFitAllocator!size_t FirstFitAllocatorType;
	
	FirstFitAllocatorType firstFit = new FirstFitAllocatorType();
	
	size_t minSize = 100;
	size_t maxSize = 1 << 17;
	QuickFitAllocator!(size_t, FirstFitAllocatorType) quickFit = new QuickFitAllocator!(size_t, FirstFitAllocatorType)(minSize, maxSize);
	quickFit.setParentAllocator(firstFit);
	
	quickFit.setParentInitialChunk(0, 1 << 18);
	
	{
		bool outOfMemory, cantFindAdress;
		ptrdiff_t hintAllocatedSize0;
		size_t allocation0 = quickFit.allocate(4, 4, outOfMemory, hintAllocatedSize0);
		assert(!outOfMemory);
		assert(allocation0 == 0); // guranteed to be 0!
		assert(hintAllocatedSize0 > 0);
		
		quickFit.deallocate(allocation0, cantFindAdress, hintAllocatedSize0);
		assert(!cantFindAdress);
	}
}

void tooBigAllocation() {
	alias FirstFitAllocator!size_t FirstFitAllocatorType;
	
	FirstFitAllocatorType firstFit = new FirstFitAllocatorType();
	
	size_t minSize = 100;
	size_t maxSize = 1 << 17;
	QuickFitAllocator!(size_t, FirstFitAllocatorType) quickFit = new QuickFitAllocator!(size_t, FirstFitAllocatorType)(minSize, maxSize);
	quickFit.setParentAllocator(firstFit);
	
	quickFit.setParentInitialChunk(0, 1 << 18);
	
	{
		bool outOfMemory, cantFindAdress;
		ptrdiff_t hintAllocatedSize0;
		size_t allocation0 = quickFit.allocate((1 << 17) + 1, 4, outOfMemory, hintAllocatedSize0);
		assert(!outOfMemory);
		assert(allocation0 == 0); // guranteed to be 0!
		assert(hintAllocatedSize0.isNull);
		
		quickFit.deallocate(allocation0, cantFindAdress, hintAllocatedSize0);
		assert(!cantFindAdress);
	}
	
	

}



void main() {
	testQuickFitAllocator();
	tooBigAllocation();
	
	import std.stdio;
	writeln("successful");
}