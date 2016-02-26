module systemEnvironment.EnvironmentChain;

import systemEnvironment.ChainContext;

class ChainElement {
	public alias void function(ChainContext chainContext, ChainElement[] elements, uint index) FunctionType;
	
	protected FunctionType fn;
	
	public final this(FunctionType fn) {
		this.fn = fn;
	}

	public final void opCall(ChainContext chainContext, ChainElement[] elements, uint index) {
		fn(chainContext, elements, index);
	}
}

/**
 * invokes the chain by calling th first (outermost) function
 */
public void processChain(ChainElement[] chainElements, ChainContext chainContext) {
	chainElements[0](chainContext, chainElements, 0);
}
