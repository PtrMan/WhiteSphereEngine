module physics.InvMassTemplate;

mixin template InvMassTemplate(NumericType) {
	public final @property NumericType mass() {
		return cast(NumericType)1.0/protectedInvMass;
	}
	
	public final @property NumericType mass(NumericType massValue) {
		protectedInvMass = cast(NumericType)1.0/massValue;
		return mass;
	}
	
	public final @property NumericType invMass() {
		return protectedInvMass;
	}
	
	public final @property NumericType invMass(NumericType invMassValue) {
		protectedInvMass = invMassValue;
		return invMassValue;
	} 

	protected NumericType protectedInvMass;
}
