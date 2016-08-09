import memory.lowLevel.QuickFitAllocator;
import memory.lowLevel.FirstFitAllocator : FirstFitAllocator;

void testQuickFitAllocator() {
	alias FirstFitAllocator!size_t FirstFitAllocatorType;
	
	FirstFitAllocatorType firstFit = new FirstFitAllocatorType();
	
	size_t minSize = 100;
	size_t maxSize = 1 << 17;
	QuickFitAllocator!(size_t, FirstFitAllocatorType) quickFit = new QuickFitAllocator!(size_t, FirstFitAllocatorType)(minSize, maxSize);
	quickFit.setParentAllocator(firstFit);
	
	// TODO< allocate and free and debug internal processes >
}



void main() {
	testQuickFitAllocator();
	
	import std.stdio;
	writeln("successful");
}