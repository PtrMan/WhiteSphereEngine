module common.ChangeCallback;

// templated abstraction for a coupled action to a changed value
// can be used for
// * recalculating a hash
// * invalidating cache
// * recalculating normals, inverse of matrix, etc
abstract class ChangeCallback(Type) {
    final public this(){}
    /*
    protected: ChangeCallback(const Type &value) {
        this->set(value);
	}
    */

	public final void set(Type value) {
		currentValue = value;
        this.changed();
	}

	public final @porperty Type get() {
		return currentValue;
	}
	
	protected abstract void changed();

	private Type currentValue;
}
