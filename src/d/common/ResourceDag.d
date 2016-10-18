module common.ResourceDag;

import std.algorithm.mutation : remove;

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
		protected final this(IResource resource, string humanReadableDescription) {
			this.protectedResource = resource;
			this.humanReadableDescription = humanReadableDescription;
		}

		public void dispose() {
			disposeFromExternal();
		}
		
		public final void incrementExternalReferenceCounter() {
			assert(dagReferenceCounterExternal >= 0);
			dagReferenceCounterExternal++;
		}
		
		public final void decrementExternalReferenceCounter() {
			import std.stdio;
			writeln("decrementExternalReferenceCounter() before assert");
			stdout.flush;

			writeln("human ", humanReadableDescription, " ref ", dagReferenceCounterExternal);
			stdout.flush;


			assert(dagReferenceCounterExternal >= 1);

			writeln("decrementExternalReferenceCounter() after assert");
			stdout.flush;
			dagReferenceCounterExternal--;

			writeln("decrementExternalReferenceCounter() after decrement");
			stdout.flush;

			import std.stdio;
			writeln("decrementExternalReferenceCounter()");
			stdout.flush;
		}

		protected final void decrementInternalReferenceCounter() {
			assert(dagReferenceCounterInternal >= 1);
			dagReferenceCounterInternal--;
		}

		// dispose without time delay
		public final void disposeFromExternalImmediatly() {
			if( dagReferenceCounterCombined == 0 ) {

				import std.stdio;
				writeln("wasDisposed ... ", wasDisposed);


				assert(!wasDisposed);

				writeln(protectedResource);
				stdout.flush;
				
				protectedResource.dispose();

				writeln("after dispose()");
				stdout.flush;

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

		// rewires/adapts the child indices which point to the element(s) behind the removed elment at index
		final void elementWasRemovedAt(size_t removedIndex) {
			foreach( childResourceIndexIndex; 0..childResourceIndices.length ) {
				size_t childResourceIndex = childResourceIndices[childResourceIndexIndex];
				assert(childResourceIndex != removedIndex, "elementWasRemovedAt() was called for an element which is still referenced!");
				if( childResourceIndex > removedIndex ) {
					childResourceIndices[childResourceIndexIndex]--; // decrement index by one because an element before it was removed
				}
			}
		}

		final void dumpDebug(void delegate(string message) log) {
			import std.format : format;

			log("humanReadableDescription=%s".format(humanReadableDescription));
			log("resourceDagIndex=%s".format(resourceDagIndex));
			log("childResourceIndices=%s".format(childResourceIndices));
			log("dagReferenceCounterInternal) + dagReferenceCounterExternal=(%s)+%s".format(dagReferenceCounterInternal, dagReferenceCounterExternal));
		}

		public final @property IResource resource() {
			return protectedResource;
		}
		
		public final @property bool isNotReferenced() {
			return dagReferenceCounterCombined == 0;
		}

		immutable string humanReadableDescription; // for debugging/profiling

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
			super(null, "");
		}
	}
	
	
	// method to free the elements in the resource-dag (and rewire the eventually changed child indices)
	final void disposeIfPossible() {
		// this rewires the indices to the elements behind the removed element
		void innerFnElementAtIndexWasRemoved(size_t indexOfToRemoveElement) {
			foreach( iterationResourceNode; resourceNodes ) {
				iterationResourceNode.elementWasRemovedAt(indexOfToRemoveElement);
			}
		}

		// this makes sure that after removal all indices of the elements are correct
		void innerFnFixUpElementIndices() {
			foreach( iterationResourceNodeIndex, iterationResourceNode; resourceNodes ) {
				iterationResourceNode.resourceDagIndex = iterationResourceNodeIndex;
			}
		}

		// decrements all internal counters of all childs of this node
		void innerFnDecrementInternalReferenceCountersOfChildrenOfNode(ResourceNode resourceNode) {
			foreach( childIndex; resourceNode.childResourceIndices ) {
				assert(resourceNodes[childIndex].resourceDagIndex == childIndex); // check for corruption
				resourceNodes[childIndex].decrementInternalReferenceCounter();
			}
		}

		if( true ) {
			import std.stdio;
			writeln("disposeIfPossible() enter");
		}

		for(;;) {
			bool elementWasDisposedAndRemoved = false;
			
			foreach( resourceNodeIndex, iterationResourceNode; resourceNodes ) {
				if( iterationResourceNode.dagReferenceCounterCombined == 0 ) {

					if( true ) {
						import std.stdio;
						writeln("ResourceDag:  begin dispose=", iterationResourceNode.humanReadableDescription);
					}

					iterationResourceNode.disposeFromExternalImmediatly();

					if( true ) {
						import std.stdio;
						writeln("ResourceDag:  end dispose=", iterationResourceNode.humanReadableDescription);
					}

					innerFnDecrementInternalReferenceCountersOfChildrenOfNode(iterationResourceNode);
					innerFnElementAtIndexWasRemoved(resourceNodeIndex);
					resourceNodes = resourceNodes.remove(resourceNodeIndex);
					innerFnFixUpElementIndices();
					
					elementWasDisposedAndRemoved = true;
					break;
				}
			}

			if( !elementWasDisposedAndRemoved ) {
				break;
			}
		}

		if( true ) {
			import std.stdio;
			writeln("disposeIfPossible() exit");
		}

	}
	
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

	public final ResourceNode createNode(IResource resource, string humanReadableDescription = "") {
		ResourceNode createdResourceNode = new ResourceNode(resource, humanReadableDescription);
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

	final void dumpDebug(void delegate(string message) log) {
		foreach( iterationResourceNode; resourceNodes ) {
			iterationResourceNode.dumpDebug(log);
			log("---");
		}
	}

	private ResourceNode[] resourceNodes;
}
