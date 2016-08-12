module graphics.apiIndependent.IResourceUploader;

import common.IShutdown;

// interface for async resource uploader whic runs in its own thread
// TODO< flesh out and implement PI dependent realisation >
interface IResourceUploader : IShutdown {
	// TODO< complete function prototype and make it maybe to an template method which takes a different type for the resource? >
	void enqueueUploadOfResource(TODO resource);
		
	// entry for loop
	void loop();
}
