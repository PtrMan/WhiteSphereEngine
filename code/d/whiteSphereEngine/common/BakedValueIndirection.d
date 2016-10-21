module whiteSphereEngine.common.BakedValueIndirection;

import whiteSphereEngine.common.IValueIndirection;

// is an indirection which accesses an value directly over an pointer
class BakedValueIndirection(Type) : IValueIndirection!Type {
	final this(Type *ptr) {
		this.ptr = ptr;
	}

	final override @property Type value() const {
		return *ptr;
	}

	protected Type *ptr;
}
