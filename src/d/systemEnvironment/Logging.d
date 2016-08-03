module systemEnvironment.Logging;

import common.LoggerPipe;
import systemEnvironment.EnvironmentChain;
import systemEnvironment.ChainContext;

public void platformLogging(ChainContext chainContext, ChainElement[] chainElements, uint chainIndex) {
	chainContext.loggerPipe = new LoggerPipe();
	chainContext.loggerPipe.init();
	scope(exit) chainContext.loggerPipe.shutdown();
	
	chainIndex++;
	chainElements[chainIndex](chainContext, chainElements, chainIndex);
}
