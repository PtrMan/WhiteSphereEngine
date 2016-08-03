module systemEnvironment.Logging;

import common.LoggerPipe;

public void platformLogging(ChainContext chainContext, ChainElement[] chainElements, uint chainIndex) {
	chainContext.loggerPipe = new LoggerPipe();
	scope(exit) chainContext.loggerPipe.shutdown();
	
	chainIndex++;
	chainElements[chainIndex](chainContext, chainElements, chainIndex);
}
