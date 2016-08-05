module common.ResourceDag;

import common.IDisposable;

// is a unified GC for resources
// does not depend on GC functionality


// for the examples ref stands for references,
// the first number in the brace is the number of dag internal references
// the second number is the number of external references

// Example 1:

// ref (0) + 1
// resource a
//            \
//             V
//             ref (2) + 0
//             resource c
//             ^
//            /
// ref (0) + 2
// resource b
//             \
//              V
//              ref (1) + 0
//              resource d

// if resource b gets externally disposed two times we end up with

// ref (0) + 1
// resource a
//            \
//             V
//             ref (2) + 0
//             resource c
//             ^
//            /
// ref (0) + 0
// resource b
//             \
//              V
//              ref (1) + 0
//              resource d

// so its after to dispose it, after this happened the graph looks like this

// ref (0) + 1
// resource a
//            \
//             V
//             ref (1) + 0
//             resource c

//             ref (0) + 0
//             resource d

// which means resource d can get safly disposed


class ResourceDag {
	public interface IResource : IDisposable {
	}

	public /*not static*/ class ResourceNode : IDisposable {
		protected final this(IResource resource) {
			this.protectedResource = resource;
		}

		public void dispose() {
			disposeFromExternal();
		}
		
		public final void incrementExternalReferenceCounter() {
			assert(dagReferenceCounterExternal >= 0);
			dagReferenceCounterExternal++;
		}
		
		public final void decrementExternalReferenceCounter() {
			assert(dagReferenceCounterExternal >= 1);
			dagReferenceCounterExternal--;
		}

		// dispose without time delay
		public final void disposeFromExternalImmediatly() {
			if( dagReferenceCounterCombined == 0 ) {
				assert(!wasDisposed);
				
				protectedResource.dispose();
				wasDisposed = true;
			}
		}

		private final void disposeFromExternal() {
			wasDisposedFromExternal = true;
		}

		public final void addChild(ResourceNode child) {
			// TODO< plausibility checks >

			childResourceIndices ~= child.resourceDagIndex;
			resourceNodes[child.resourceDagIndex].dagReferenceCounterInternal++;
		}

		public final @property IResource resource() {
			return protectedResource;
		}
		
		public final @property bool isNotReferenced() {
			return dagReferenceCounterCombined == 0;
		}

		protected bool wasDisposedFromExternal = false;
		protected bool wasDisposed = false;

		protected IResource protectedResource;

		protected size_t resourceDagIndex;
		protected size_t[] childResourceIndices;

		protected int dagReferenceCounterInternal, dagReferenceCounterExternal;
		
		protected final @property int dagReferenceCounterCombined() {
			assert(dagReferenceCounterInternal >= 0);
			assert(dagReferenceCounterExternal >= 0);
			return dagReferenceCounterInternal + dagReferenceCounterExternal;
		}
	}

	// doesn't do anything, just holds references to childs
	public /*not static*/ class EntryResourceNode : ResourceNode {
		protected final this() {
			super(null);
		}
	}
	
	
	// TODO< method to free the elements in the resource-dag (and rewire the eventually changed child indices) >
	
	// TODO< maybe its better to first dispose the parent and then the childs and so on >
	// disposes all resources
	// disposedAny : indicates if any resources got disposed
	public final void disposeFromExternalAll(out bool disposedAny) {
		disposedAny = false;
		
		for( size_t resourceNodeI = 0; resourceNodeI < resourceNodes.length; resourceNodeI++ ) {
			ResourceNode currentResourceNode = resourceNodes[resourceNodeI];
			
			if( currentResourceNode is null ) {
				continue;
			}
			
			if( currentResourceNode.isNotReferenced ) {
				currentResourceNode.disposeFromExternalImmediatly();
				disposedAny = true;
			}
			
			if( currentResourceNode.wasDisposed ) {
				// can only got disposed if both references were zero
				assert(currentResourceNode.dagReferenceCounterExternal == 0 && currentResourceNode.dagReferenceCounterInternal == 0);
				
				decrementInternalReferenceCountersOfChildrenAndSetToNull(resourceNodeI);
			}
		}
	}
	
	protected final void decrementInternalReferenceCountersOfChildrenAndSetToNull(size_t resourceNodeIndex) {
		ResourceNode currentResourceNode = resourceNodes[resourceNodeIndex];
		
		// could only be called if both reference counters are zero
		assert(currentResourceNode.dagReferenceCounterExternal == 0 && currentResourceNode.dagReferenceCounterInternal == 0);
		
		// decrement all internal references of the childs
		foreach( iterationChildIndex; currentResourceNode.childResourceIndices ) {
			ResourceNode childResourceNode = resourceNodes[iterationChildIndex];
			
			if( childResourceNode is null ) {
				continue;
			}
			
			childResourceNode.dagReferenceCounterInternal--;
			assert(childResourceNode.dagReferenceCounterInternal >= 0);
		}
		
		// set to null
		resourceNodes[resourceNodeIndex] = null;
	}

	public final ResourceNode createNode(IResource resource) {
		ResourceNode createdResourceNode = new ResourceNode(resource);
		resourceNodes ~= createdResourceNode;
		createdResourceNode.resourceDagIndex = cast(size_t)resourceNodes.length-1;
		return createdResourceNode;
	}

	public final EntryResourceNode createEntryNode() {
		EntryResourceNode createdEntryResourceNode = new EntryResourceNode();
		resourceNodes ~= createdEntryResourceNode;
		createdEntryResourceNode.resourceDagIndex = cast(size_t)resourceNodes.length-1;
		return createdEntryResourceNode;
	}

	private ResourceNode[] resourceNodes;
}
