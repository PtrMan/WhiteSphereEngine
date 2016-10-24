module whiteSphereEngine.common.ScopedResource;

// creates and own a datastructure
// is used to release it after RAII
// owns the resource exclusivly
struct ScopedResource(ResourceType) {
	alias void delegate(ResourceType ownedResource) DestructorType;
	alias ResourceType delegate() ConstructorType;

	static struct Arguments {
		ScopedResource!ResourceType.ConstructorType constructor;
		ScopedResource!ResourceType.DestructorType destructor;
	}

	final this(Arguments arguments) {
		this.destructor = arguments.destructor;
		this.constructor = arguments.constructor;
	}

	final void construct() {
		assert(!wasConstructed);

		this.hiddenOwnedResource = constructor();
		wasConstructed = true;
	}

	final @property ResourceType ownedResource() pure {
		assert(wasConstructed);
		return hiddenOwnedResource;
	}

	final ~this() {
		assert(wasConstructed);

		destructor(hiddenOwnedResource);
		hiddenOwnedResource = ResourceType.init;
	}

	private DestructorType destructor;
	private ConstructorType constructor;
	private bool wasConstructed;

	private ResourceType hiddenOwnedResource;
}
