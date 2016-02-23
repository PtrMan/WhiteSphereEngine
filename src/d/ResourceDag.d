module ResourceDag;

import IDisposable : IDisposable;

// TODO< on dispose check if the counter reaches zero first decrement all internal reference counters, if they reach zero first delete the child then the parent

// is a unified GC for resources
// does not depend on GC functionality
class ResourceDag {
	public interface IResource : IDisposable {

	}

	public class ResourceNode : IDisposable {
		protected final this(IResource Resource) {
			this.Resource = Resource;
		}

		public void dispose() {
			disposeFromExternal();
		}

		// dispose without time delay
		public final void disposeImmediatly() {

		}

		private final void disposeFromExternal() {
			WasDisposedFromExternal = true;
		}

		public final void addChild(ResourceNode Child) {
			// TODO< plausibility checks >

			ChildResourceIndices ~= Child.ResourceDagIndex;
		}

		public final IResource getResource() {
			return Resource;
		}

		protected bool WasDisposedFromExternal = false;

		protected IResource Resource;

		protected uint ResourceDagIndex;
		protected uint[] ChildResourceIndices;

		protected int DagReferenceCounter;
	}

	// doesn't do anything, just holds references to childs
	public class EntryResourceNode : ResourceNode {
		protected final this() {
			super(null);
		}
	}

	public final void disposeFromExternalAll() {
		// disposes all resources

		// TODO
	}

	public final ResourceNode createNode(IResource Resource) {
		ResourceNode CreatedResourceNode = new ResourceNode(Resource);
		ResourceNodes ~= CreatedResourceNode;
		CreatedResourceNode.ResourceDagIndex = cast(uint)ResourceNodes.length-1;
		return CreatedResourceNode;
	}

	public final EntryResourceNode createEntryNode() {
		EntryResourceNode CreatedEntryResourceNode = new EntryResourceNode();
		ResourceNodes ~= CreatedEntryResourceNode;
		CreatedEntryResourceNode.ResourceDagIndex = cast(uint)ResourceNodes.length-1;
		return CreatedEntryResourceNode;
	}

	private ResourceNode[] ResourceNodes;
}