module RefCountingMixin;

mixin template Refcount() {
	public uint referenceCounter;

	public final void resetReferenceCounter() {
		referenceCounter = 0;
	}

	public final void incrementReferenceCounter() {
		referenceCounter++;
	}
	
	public final void decrementReferenceCounter() {
		assert(referenceCounter > 0);
		referenceCounter--;
	}
	
	public final @property bool isReferenced() {
		return referenceCounter > 0;
	}
	
}
