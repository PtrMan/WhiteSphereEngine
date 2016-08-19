module graphics.vulkan.resourceManagement.StackResourceAllocator;

import common.IDisposable;

/**
 * Allocates a resource in a stack fashion.
 * After each cycle the top pointer can be reseted
 * 
 * allocation and freeing are one over delegates (which have to point to valid methods/functions)
 */
class StackResourceAllocator(ResourceType) : IDisposable {
	public alias ResourceType[] delegate(size_t number) AllocateDelegate;
	public alias void delegate(ResourceType[] toFree) FreeDelegate;
	
	
	public final this(AllocateDelegate allocate, FreeDelegate free, size_t initialAllocation = 32, size_t incrementAllocation = 64) {
		this.allocate = allocate;
		this.free = free;
		
		stackPool = allocate(initialAllocation);
		this.incrementAllocation = incrementAllocation;
	}
	
	public final void reset() {
		top = 0;
	}
	
	public final ResourceType allocateOne() {
		assert( top <= stackPool.length );
		if( top == stackPool.length ) { // if this is the case then we have to allocate more
			stackPool ~= allocate(incrementAllocation);
		}
		
		assert( top <= stackPool.length );
		return stackPool[top++];
	}
	
	public final void dispose() {
		free(stackPool);
	}
	
	private AllocateDelegate allocate;
	private FreeDelegate free;
	
	private ResourceType[] stackPool;
	private size_t top = 0;
	
	private size_t incrementAllocation;
}
