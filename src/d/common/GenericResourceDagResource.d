module common.GenericResourceDagResource;

import common.ResourceDag;

class GenericResourceDagResource(ResourceType) : ResourceDag.IResource {
	public alias void function(ResourceType resource) DisposalDelegateType;
	
	public final this(ResourceType resource, DisposalDelegateType disposaleDelegate) {
		this.protectedResource = resource;
		this.disposalDelegate = disposalDelegate;
	}
	
	public void dispose() {
		assert(!wasDisposed);
		wasDisposed = true;
		
		disposalDelegate(protectedResource);
	}
	
	public final @property ResourceType resource() {
		assert(!wasDisposed);
		return protectedResource;
	}
	
	protected bool wasDisposed = false;
	protected ResourceType protectedResource;
	protected DisposalDelegateType disposalDelegate;
}
