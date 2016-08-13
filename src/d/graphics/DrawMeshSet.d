module graphics.DrawMeshSet;

// used to group meshes together, used for improving the performance of the draws
// the draw order is not predertermined and can change at any time (this is why its called a set)

class DrawMeshSet {
	public final void reset() {
		// TODO< reset >

	}
	
	public final void beginRecord() {
		// TODO< begin record
	}
	
	// TODO< add mesh  with fixed (relative?) transform >
	
	public final void endRecord() {
		// TODO< end >
	}
	
	// TODO< low level access for low level renderer >
}
