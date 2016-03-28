module physics.ChangeCallbackCalculateInverse;

import common.ChangeCallback;

class ChangeCallbackCalculateInverse(Type) : ChangeCallback!Type {
    public final this() {
    }

    /*
	public: ChangeCallbackCalculateInverse(const Type &value) : ChangeCallback<Type>(value) {
	}
    */

	public final Type getInverse() {
		return inverse;
	}

    protected final override void changed() {
		inverse = this.get().inverse();
	}

	private Type inverse;
}
