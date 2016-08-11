module helpers.VariableValidator;

/**
 * small class which asserts on not initalized values
 *
 */
struct VariableValidator(Type) {
	public final void opAssign(Type inputvalue) {
		valid = true;
		this.protectedValue = inputvalue;
	}
	
	public final void invalidate() {
		valid = false;
	}
	
	
	public final @property bool isValid() {
		// TODO< return true in release build to be a nop >
		
		return valid;
	}
	
	// TODO< do only ref if Type is struct >
	public final @property ref Type value() {
		assert(isValid);
		
		return protectedValue;
	}
	
	
	protected bool valid = false;
	protected Type protectedValue;
}