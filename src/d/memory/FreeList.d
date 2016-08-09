module memory.FreeList;

// simple implementation of freelist with a array
// a freelist is described here https://en.wikipedia.org/wiki/Free_list
struct FreeList(Type) {
	protected Type[] list;
	
	public final Type allocate(out bool isEmpty) {
		isEmpty = list.length == 0;
		if( isEmpty ) {
			return Type.init;
		}
		
		Type topElement = list[$];
		list.length--;
		
		return topElement;
	}
	
	public final void free(Type value) {
		addToList(value);
	}
	
	// used to fill the Freelist
	public final void initAddAsFree(Type[] values) {
		foreach( iterationValue; values ) {
			addToList(iterationValue);
		}
	}
	
	protected final void addToList(Type value) {
		list ~= value;
	}
}

