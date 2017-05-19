module procedural.sosmc.TestShip;





// connects the code of the SOSMC to the Scripting functions and so the script execution
class ProceduralGenerationContext {

}

// provides functions for scripting for the procedural generation of the ship
class ScriptingFunctions {
	// is a procedural future for the creation of a mainbody segment
	protected final Variant proceduralFutureMainbody(InterpreterState state, Variant[] arguments) {
		proceduralGenerationContext.activeFutures[proceduralGenerationContext.EnumProceduralFuture.MAINBODY] = true;

		return Variant();
	}

	// is a procedural future for the creation of a wing segment
	protected final Variant proceduralFutureWingsegment(InterpreterState state, Variant[] arguments) {
		proceduralGenerationContext.activeFutures[proceduralGenerationContext.EnumProceduralFuture.WINGSEGMENT] = true;

		return Variant();
	}

	// is used to indicate a barrier, here the SOSMC algorithm stops the interpretation of the script and returns back
	protected final Variant barrier(InterpreterState state, Variant[] arguments) {
		// TODO

		return Variant();
	}

	// flips a coin and looks for the propability, returns a boolean
	protected final Voriant flipCoin(InterpreterState state, Variant[] arguments) {
		// TODO

		bool booleanResult = TODO;

		return Variant(booleanResult);
	}

	// finishes the creating of the model
	protected final Variant finish(InterpreterState state, Variant[] arguments) {
		// TODO

		return Variant();
	}

	public ProceduralGenerationContext proceduralGenerationContext;
}
