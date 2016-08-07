module systemEnvironment.Engine;

import systemEnvironment.EnvironmentChain;
import systemEnvironment.ChainContext;
import EngineEntry;

public void systemEnvironmentEngineEntry(ChainContext chainContext, ChainElement[] chainElements, uint chainIndex) {
	engineEntry(chainContext.vulkan);
	
	// we dont call deeper chain elements because it should be the top chain element
}