module systemEnvironment.Logging;

import common.LoggerPipe;

public void platformLogging(ChainContext chainContext, ChainElement[] chainElements, uint chainIndex) {
	chainContext.loggerPipe = new LoggerPipe();
	// TODO< tear down with scope(exit)
	
	chainIndex++;
	chainElements[chainIndex](chainContext, chainElements, chainIndex);
}
