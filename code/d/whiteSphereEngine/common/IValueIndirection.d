module whiteSphereEngine.common.IValueIndirection;

// indirection for an value, useful if we want to avoid duplicated states and manual value updates etc
interface IValueIndirection(Type) {
	@property Type value() const;
}
