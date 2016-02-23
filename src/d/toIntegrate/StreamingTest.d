
/*
interface IStreamLevel1 {
   	public enum EnumLengthType {
      	FINITELENGTH,  // the source does have a finite length and the length is determinable
      	UNKNOWNLENGTH, // the length is unknown
      	INFINITELENGTH // the source is infinite
   	}

   	// blocks untill reaing was successful
   	public ubyte[] read(uint NumberOfBytes, out bool Success);

   	public uint getRemainingLength(out EnumLengthType Type);
}
*/

class MemoryHandle {
	void[] directData;

	protected this(void[] directData) {
		this.directData = directData;
	}
}

struct FileActionResponse {
	enum EnumResponse {
		SUCCESSFULL_BUT_REOPENEDFILE,
		ERROR_FILENOTFOUND,
		SUCCESSFULL,
		SUCCESSFULL_BUT_NOFILEOPENED,
		ERROR_NOFILEOPEN,
		ERROR_OUTOFRANGE,  // read requested outside the file
		ERROR_READERROR
	}

	public EnumResponse response;

	public final bool wasSuccessful() {
		return response == EnumResponse.SUCCESSFULL_BUT_REOPENEDFILE || response == EnumResponse.SUCCESSFULL;
	}
}


interface IFileAccess {
	void openFileBlocking(string filename, ref FileActionResponse response);
	void closeFileBlocking(ref FileActionResponse response);
	ulong getFilesizeBocking(ref FileActionResponse response);
	void[] readBlocking(ulong offset, uint length, ref FileActionResponse fileActionResponse);
}

import std.mmfile;

class MemoryMappedFileAccess : IFileAccess {
	public final void openFileBlocking(string filename, ref FileActionResponse response) {
		// TODO< close file if it was already opened
		memoryMappedFile = new MmFile(filename);

		response.response = FileActionResponse.EnumResponse.SUCCESSFULL;
	}

	public final void closeFileBlocking(ref FileActionResponse response) {
		// TODO	
	}

	public final ulong getFilesizeBocking(ref FileActionResponse response) {
		// TODO< check for opened file >

		return memoryMappedFile.length;
	}

	public final void[] readBlocking(ulong offset, uint length, ref FileActionResponse fileActionResponse) {
		// TODO< check for opened file >

		fileActionResponse.response = FileActionResponse.EnumResponse.SUCCESSFULL;

		return memoryMappedFile[offset..offset+length];
	}

	protected MmFile memoryMappedFile;
}

import std.string : toStringz;
import core.stdc.stdio : _iobuf, fopen, fclose, fseek, fseek, fread;

class DirectFileAccess : IFileAccess {
	private shared(_iobuf)* currentHandle;

	public final void openFileBlocking(string filename, ref FileActionResponse response) {
		bool fileWasOpened;
		internalCloseIfOpen(fileWasOpened);
		currentHandle = fopen(toStringz(filename), "rb");
		
		if( currentHandle is null ) {
			response.response = FileActionResponse.EnumResponse.ERROR_FILENOTFOUND;
			return;
		}

		response.response = FileActionResponse.EnumResponse.SUCCESSFULL;
	}

	public final void closeFileBlocking(ref FileActionResponse response) {
		bool fileWasOpen;
		internalCloseIfOpen(fileWasOpen);

		if( fileWasOpen ) {
			response.response = FileActionResponse.EnumResponse.SUCCESSFULL;
		}
		else {
			response.response = FileActionResponse.EnumResponse.SUCCESSFULL_BUT_NOFILEOPENED;
		}
	}

	public final ulong getFilesizeBocking(ref FileActionResponse response) {
		// TODO< check if opened >

		fseek(currentHandle, 0, SEEK_END);

		ulong apiResult = ftell(currentHandle);

		// TODO< check API result for error >

		return cast(long)apiResult;
	}

	public final void[] readBlocking(ulong offset, uint length, ref FileActionResponse fileActionResponse) {
		ubyte[] buffer;

		buffer.length = length;

		// TODO< files bigger than 2 gb >
		// TODO< check error of seek >
		fseek(currentHandle, cast(int)offset, SEEK_SET);


		uint numberOfReadBytes = fread( 
  			buffer.ptr,
  			1, 
  			cast(uint)buffer.length,
  			currentHandle
  		);

  		writeln("read ", numberOfReadBytes, " bytes");

  		buffer.length = numberOfReadBytes;

  		if( numberOfReadBytes != length ) {
  			// either a read error occured or we are at th end of the file

  			const bool atEndOfFile = feof(currentHandle) != 0;
  			if( !atEndOfFile ) {
  				fileActionResponse.response = FileActionResponse.EnumResponse.ERROR_READERROR;
  				return [];
  			}
  		}


  		fileActionResponse.response = FileActionResponse.EnumResponse.SUCCESSFULL;

  		return cast(void[])buffer;
	}

	protected final void internalCloseIfOpen(out bool fileWasOpen) {
		fileWasOpen = currentHandle !is null;
		if( !fileWasOpen ) {
			return;
		}

		fclose(currentHandle);
		currentHandle = null;
	}
}


import std.stdio;

class StreamLevel1 {
	public this(IFileAccess fileAccess) {
		this.fileAccess = fileAccess;
	}

	public final void openFileBlocking(string filename, ref FileActionResponse response) {
		fileAccess.openFileBlocking(filename, response);
	}

	public final void closeFileBlocking(ref FileActionResponse response) {
		fileAccess.closeFileBlocking(response);
	}
	
	public final ulong getFilesizeBocking(ref FileActionResponse response) {
		return fileAccess.getFilesizeBocking(response);
	}
	
	public final void queueReadAsync(ulong offset, uint length, void delegate(ulong offset, uint length, FileActionResponse fileActionResponse, MemoryHandle readChunkHandle) completitionDelegate) {
		// TODO< async reading >
		FileActionResponse fileActionResponse;
		void[] buffer = fileAccess.readBlocking(offset, length, fileActionResponse);

		MemoryHandle resultMemoryHandle = new MemoryHandle(buffer);
  		completitionDelegate(offset, buffer.length, fileActionResponse, resultMemoryHandle);
	}

	protected IFileAccess fileAccess;
}

// TODO< level 2 >

import Queue;

class StreamOperationRequest {
	ulong offset;
	uint length;
	void delegate(ulong offset, uint length, FileActionResponse fileActionResponse, MemoryHandle readChunkHandle) completitionDelegate;
}

import core.thread : Thread;

// thread which takes Stream requests and executes them
// file system operations block, this is the reason that we need a "worker" thread
class BlockingStreamWorkerThread : Thread {
    this(StreamLevel1 streamLevel1, QueueConcurrentBlockingGcArray!StreamOperationRequest streamOperationRequestQueue) {
    	this.streamLevel1 = streamLevel1;
        this.streamOperationRequestQueue = streamOperationRequestQueue;
        super(&run);
    }

	private void run() {
        for(;;) {
        	// block on queue reading
        	bool peekSuccess;
        	StreamOperationRequest currentRequest;
        	streamOperationRequestQueue.peek(peekSuccess, currentRequest);

        	writeln("BlockingStreamWorkerThread : executes request");

        	streamLevel1.queueReadAsync(currentRequest.offset, currentRequest.length, currentRequest.completitionDelegate);
        }
    }

    private StreamLevel1 streamLevel1;
    private QueueConcurrentBlockingGcArray!StreamOperationRequest streamOperationRequestQueue;
}



/*
requirements overall:
* reading blockades on lower levels

* seekable
* bulk reading
* caching
* multifile reading
* async



level 1:
* read chunk async with completion callback
* seeking
* overreading
* asny reading (still singlethreaded)

level 2:
* bulk reading (agregate multiple reads)
* cache (?)
* multifile support
*/

void main(string[] args) {
	IFileAccess fileAccess = new MemoryMappedFileAccess();
	StreamLevel1 streamLevel1 = new StreamLevel1(fileAccess);

	FileActionResponse fileActionResponse;

	streamLevel1.openFileBlocking("testfile.txt", fileActionResponse);

	QueueConcurrentBlockingGcArray!StreamOperationRequest streamOperationRequestQueue = new QueueConcurrentBlockingGcArray!StreamOperationRequest();

	Thread blockingStreamWorkerThread = new BlockingStreamWorkerThread(streamLevel1, streamOperationRequestQueue).start();


	void queriedReadRequestCompleted(ulong offset, uint length, FileActionResponse fileActionResponse, MemoryHandle readChunkHandle) {
		writeln("read request completed");
	}


	// TODO< add a read request into the queue >

	{
		StreamOperationRequest streamOperationRequest = new StreamOperationRequest();
		streamOperationRequest.offset = 0;
		streamOperationRequest.length = 5;
		streamOperationRequest.completitionDelegate = &queriedReadRequestCompleted;

		streamOperationRequestQueue.insert(streamOperationRequest);
	}



	/*
	void queriedReadRequestFinished(ulong offset, uint length, FileActionResponse fileActionResponse, MemoryHandle readChunkHandle) {

	}

	streamLevel1.queueReadAsync(0, 5, &queriedReadRequestFinished);

	
	streamLevel1.closeFileBlocking(fileActionResponse);
	*/
}
