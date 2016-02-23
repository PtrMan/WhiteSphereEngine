#include "PtrEngine/OpenClWrapper.hpp"

// for linux
#include <epoxy/glx.h>

#include <fstream>

cl_mem OpenClWrapper::Image::getHandle() const {
	return image;
}

OpenClWrapper::OpenClWrapper() {
	cl_int ret;
	cl_uint numberOfPlatforms;
	cl_platform_id* platformIds; // this is a pointer to an array with (numberOfPlatforms) platforms that are available
	
	// query the count of the available platforms
	ret = clGetPlatformIDs(0, NULL, &numberOfPlatforms);
	if( ret != CL_SUCCESS ) {
		throw ErrorMessage("Couldn't query the number of available Platforms!");
	}

	if( numberOfPlatforms == 0 ) {
		throw ErrorMessage("There are no Platforms!");
	}

	// allocate an memory region where the Platform id's can be saved
	platformIds = new cl_platform_id[numberOfPlatforms];
	
	if( !platformIds ) {
		// the array couln't be allocated
		throw ErrorMessage("Couldn't allocate array!");
	}

	
	// get all available platform ids
	ret = clGetPlatformIDs(numberOfPlatforms, platformIds, NULL);
	if( ret != CL_SUCCESS ) {
		throw ErrorMessage("Couldn't query the available Platforms!");
	}

	/*
		this can be anytime helpful
	size_t size;
	char* stringInfo;
	// enumerate the informations about the device
	// TODO< enumerate the informations of multiple platforms if we have many and choose the right one >
	cl_platform_id id = platformIds[0];
	ret = clGetPlatformInfo(platformIds[0], CL_PLATFORM_EXTENSIONS , 0, NULL, &size); 
	if( ret != CL_SUCCESS ) {
		throw ErrorMessage("Couldn't get informations about the Platform!"); 
	}
	
	stringInfo = new char[size];
	if( !stringInfo ) {
		throw ErrorMessage("Couldn't allocate array!");
	}
	ret = clGetPlatformInfo(platformIds[0], CL_PLATFORM_EXTENSIONS , size, stringInfo, NULL);
	if( ret != CL_SUCCESS ) {
		throw ErrorMessage("Couldn't get informations about the Platform!"); 
	}
	
	delete stringInfo;
	*/

	// fill the properties structure
	cl_context_properties akProperties[] = {
		CL_CONTEXT_PLATFORM, (cl_context_properties)platformIds[0],

		// windows : CL_GL_CONTEXT_KHR, (cl_context_properties)wglGetCurrentContext()
		//CL_WGL_HDC_KHR, (cl_context_properties)wglGetCurrentDC(), required for windows?

		CL_GL_CONTEXT_KHR, (cl_context_properties)glXGetCurrentContext(),
		CL_GLX_DISPLAY_KHR, (cl_context_properties)glXGetCurrentDisplay(),
		
		0 // don't forget the terminating null!
	};


	// Create a context to run OpenCL
	GPUContext = clCreateContextFromType(akProperties, CL_DEVICE_TYPE_GPU, nullptr, nullptr, &ret); 
	if( !GPUContext ) {
		// figure out the error-code
		string errorText = getErrorText(ret);

		throw ErrorMessage("Could not create the GPU-Context(" + errorText + ")!");
	}

	// Get the list of GPU devices associated with this context 
	size_t ParmDataBytes; 

	ret = clGetContextInfo(GPUContext, CL_CONTEXT_DEVICES, 0, nullptr, &ParmDataBytes); 
	if( ret != CL_SUCCESS ) {
		throw ErrorMessage("Can't get the context informations!");
	}
	
	GPUDevices = reinterpret_cast<cl_device_id*>(malloc(ParmDataBytes)); 
	if( !GPUDevices ) {
		throw NoMemory();
	}
	
	ret = clGetContextInfo(GPUContext, CL_CONTEXT_DEVICES, ParmDataBytes, GPUDevices, nullptr); 
	if( ret != CL_SUCCESS ) {
		throw ErrorMessage("Can't get the context informations!");
	}
	
	// Create a command-queue on the first GPU device 
	GPUCommandQueue = clCreateCommandQueue(GPUContext,
	                                       GPUDevices[0],
	                                       //CL_QUEUE_OUT_OF_ORDER_EXEC_MODE_ENABLE |/* we want it for more speed */     no we don't until we wait for the kernel execution
	                                       CL_QUEUE_PROFILING_ENABLE ,              /* we want to profile the timings */
	                                       nullptr);

	if( !GPUCommandQueue ) {
		throw ErrorMessage("Couldn't create the Command Queue!");
	}

	
	// free the array with the available platform ids
	delete platformIds;
}

OpenClWrapper::~OpenClWrapper() {

	// TODO< the same for images and buffers >

	free(GPUDevices);

	clReleaseContext(GPUContext);
	clReleaseCommandQueue(GPUCommandQueue);
}

std::shared_ptr<OpenClWrapper::Program> OpenClWrapper::openAndCompile(string Filename) {
	char* buffer;
	cl_int ret;


	std::shared_ptr<OpenClWrapper::Program> program = std::shared_ptr<OpenClWrapper::Program>(new Program());
	if( !program ) {
		throw NoMemory();
	}

	ifstream f(Filename.c_str());
	
	if ( !f ) {
		throw CantOpenFile(Filename);
	}
	
	buffer = reinterpret_cast<char*>(malloc(1000000));
	if( !buffer ) {
		throw NoMemory();
	}

	f.get(buffer, 1000000-1, 0);
	buffer[f.gcount()] = 0; // delimit last byte

	f.close();

	program->program = clCreateProgramWithSource(GPUContext, 1, const_cast<const char**>(&buffer), nullptr, nullptr); 
	
	
	if( !program->program ) {
		throw ErrorMessage("Can't compile the Source!");
	}

	free(buffer);

	// Build the program (OpenCL JIT compilation) 
	ret = clBuildProgram(program->program, 0, nullptr, nullptr, nullptr, nullptr); 
	if( ret != CL_SUCCESS ) {
		char errBuff[4096]; // is a buffer for the error message

		// we get the compilation error
		clGetProgramBuildInfo(program->program, GPUDevices[0], CL_PROGRAM_BUILD_LOG, 4096, &errBuff, nullptr);
		

		throw ErrorMessage("Can't build the program!");
	}

	return program;
}

OpenClWrapper::Program::~Program() {
	clReleaseProgram(program);
}

std::shared_ptr<OpenClWrapper::Kernel> OpenClWrapper::Program::createKernel(string name) {
	cl_kernel handle;
	
	handle = clCreateKernel(program, name.c_str(), nullptr); 
	if( !handle ) {
		throw ErrorMessage("Can't create the Kernel!");
	}

	return std::shared_ptr<OpenClWrapper::Kernel>(new OpenClWrapper::Kernel(handle));
}

OpenClWrapper::Kernel::Kernel(cl_kernel handle) {
	this->handle = handle;
}

OpenClWrapper::Kernel::~Kernel() {
	clReleaseKernel(handle);
}

cl_kernel OpenClWrapper::Kernel::getHandle() const {
	return handle;
}


OpenClWrapper::Buffer* OpenClWrapper::createBuffer(cl_mem_flags Flags, size_t Size, void *Ptr) {
	Buffer* buffer;
	
	buffer = new Buffer(this);
	if( !buffer ) {
		throw NoMemory();
	}

	buffer->buffer = clCreateBuffer(GPUContext, Flags, Size, Ptr, nullptr);
	if( !buffer->buffer ) {
		throw ErrorMessage("Can't create the Buffer!");
	}
	
	return buffer;
}

OpenClWrapper::Buffer::Buffer(OpenClWrapper* OpenClWrapperPtr) {
	openclw = OpenClWrapperPtr;
}

OpenClWrapper::Buffer::~Buffer() {
	clReleaseMemObject(buffer);
}

cl_mem* OpenClWrapper::Buffer::getPtr() {
	return &buffer;
}

void OpenClWrapper::Buffer::write(cl_bool Blocking, const void *Ptr, size_t Size, size_t Offset, cl_event* Event, OpenClWrapper::EventList* Waitlist) {
	cl_int ret;

	if( Waitlist == nullptr ) {
		ret = clEnqueueWriteBuffer(openclw->GPUCommandQueue, buffer, Blocking, Offset, Size, Ptr, 0, 0, Event);
	}
	else {
		ret = clEnqueueWriteBuffer(openclw->GPUCommandQueue, buffer, Blocking, Offset, Size, Ptr, Waitlist->events.size(), &(Waitlist->events[0]), Event);
	}

	if( ret != CL_SUCCESS ) {
		throw ErrorMessage("Can't write to OpenCL Buffer");
	}
}

void OpenClWrapper::Buffer::write(cl_bool Blocking, const void *Ptr, size_t Size, size_t Offset, cl_event* Event, cl_uint WaitlistCount, cl_event* Waitlist) {
	cl_int ret;

	ret = clEnqueueWriteBuffer(openclw->GPUCommandQueue, buffer, Blocking, Offset, Size, Ptr, WaitlistCount, Waitlist, Event);
	
	if( ret != CL_SUCCESS ) {
		throw ErrorMessage("Can't write to OpenCL Buffer");
	}
}

void OpenClWrapper::Buffer::read(cl_bool Blocking, void *Ptr, size_t Size, size_t Offset, cl_event* Event, OpenClWrapper::EventList* Eventlist) {
	cl_int ret;

	if( Eventlist == nullptr ) {
		ret = clEnqueueReadBuffer(openclw->GPUCommandQueue, buffer, Blocking, Offset, Size, Ptr, 0, 0, Event);
	}
	else {
		ret = clEnqueueReadBuffer(openclw->GPUCommandQueue, buffer, Blocking, Offset, Size, Ptr, Eventlist->events.size(), &(Eventlist->events[0]), Event);
	}

	if( ret != CL_SUCCESS ) {
		throw ErrorMessage("Can't read from OpenCL Buffer");
	}
}

void OpenClWrapper::Buffer::read(cl_bool Blocking, void *Ptr, size_t Size, size_t Offset, cl_event* Event, cl_uint WaitlistCount, cl_event* Waitlist) {
	cl_int ret;

	ret = clEnqueueReadBuffer(openclw->GPUCommandQueue, buffer, Blocking, Offset, Size, Ptr, WaitlistCount, Waitlist, Event);
	
	if( ret != CL_SUCCESS ) {
		throw ErrorMessage("Can't read from OpenCL Buffer");
	}
}

void* OpenClWrapper::Buffer::map(cl_bool Blocking, cl_map_flags Flags, size_t Size, size_t Offset) {
	void* ret = clEnqueueMapBuffer(openclw->GPUCommandQueue, buffer, Blocking, Flags, Offset, Size, 0, 0, 0, 0);
	if( !ret ) {
		throw ExceptionMappingFailed();
	}

	return ret;
}

std::shared_ptr<OpenClWrapper::Image> OpenClWrapper::createImageFromOpenGLTexture(cl_mem_flags Flags, GLuint Texture) {
	cl_mem ret;
	cl_int errorcode;
	
	ret = clCreateFromGLTexture2D(GPUContext, Flags, GL_TEXTURE_2D, 0, Texture, &errorcode);

	if( errorcode != CL_SUCCESS ) {
		string code = getErrorText(errorcode);
		throw ErrorMessage("Can't create the OpenCL Texture from the OpenGL Texture!");
	}

	// create a new Image Object
	std::shared_ptr<OpenClWrapper::Image> newImage = std::shared_ptr<OpenClWrapper::Image>(new OpenClWrapper::Image());
	
	if( !newImage ) {
		throw NoMemory();
	}

	newImage->image = ret;

	return newImage;
}

std::shared_ptr<OpenClWrapper::Image> OpenClWrapper::createImage2dOnDevice(cl_mem_flags flags, unsigned sizeX, unsigned sizeY, cl_channel_order channelOrder, cl_channel_type channelType) {
	cl_mem ret;
	cl_int errorcode;

	cl_image_format openclImageFormat;
	openclImageFormat.image_channel_order = channelOrder;
	openclImageFormat.image_channel_data_type = channelType;

	ret = clCreateImage2D(
		GPUContext,
  		flags,
  		&openclImageFormat,
  		sizeX,
  		sizeY,
  		0,
  		nullptr,
  		&errorcode
  	);

	if( errorcode != CL_SUCCESS ) {
		string code = getErrorText(errorcode);
		throw ErrorMessage("Can't create a 2d Image! " + code);
	}

	// create a new Image Object
	std::shared_ptr<OpenClWrapper::Image> newImage = std::shared_ptr<OpenClWrapper::Image>(new OpenClWrapper::Image());
	
	if( !newImage ) {
		throw NoMemory();
	}

	newImage->image = ret;

	return newImage;
}

OpenClWrapper::Image::Image() {

}

OpenClWrapper::Image::~Image() {

}

// from http://stackoverflow.com/questions/24326432/convenient-way-to-show-opencl-error-codes
string OpenClWrapper::getErrorText(cl_int Errorcode) {
	switch(Errorcode){
	    // run-time and JIT compiler errors
	    case 0: return "CL_SUCCESS";
	    case -1: return "CL_DEVICE_NOT_FOUND";
	    case -2: return "CL_DEVICE_NOT_AVAILABLE";
	    case -3: return "CL_COMPILER_NOT_AVAILABLE";
	    case -4: return "CL_MEM_OBJECT_ALLOCATION_FAILURE";
	    case -5: return "CL_OUT_OF_RESOURCES";
	    case -6: return "CL_OUT_OF_HOST_MEMORY";
	    case -7: return "CL_PROFILING_INFO_NOT_AVAILABLE";
	    case -8: return "CL_MEM_COPY_OVERLAP";
	    case -9: return "CL_IMAGE_FORMAT_MISMATCH";
	    case -10: return "CL_IMAGE_FORMAT_NOT_SUPPORTED";
	    case -11: return "CL_BUILD_PROGRAM_FAILURE";
	    case -12: return "CL_MAP_FAILURE";
	    case -13: return "CL_MISALIGNED_SUB_BUFFER_OFFSET";
	    case -14: return "CL_EXEC_STATUS_ERROR_FOR_EVENTS_IN_WAIT_LIST";
	    case -15: return "CL_COMPILE_PROGRAM_FAILURE";
	    case -16: return "CL_LINKER_NOT_AVAILABLE";
	    case -17: return "CL_LINK_PROGRAM_FAILURE";
	    case -18: return "CL_DEVICE_PARTITION_FAILED";
	    case -19: return "CL_KERNEL_ARG_INFO_NOT_AVAILABLE";

	    // compile-time errors
	    case -30: return "CL_INVALID_VALUE";
	    case -31: return "CL_INVALID_DEVICE_TYPE";
	    case -32: return "CL_INVALID_PLATFORM";
	    case -33: return "CL_INVALID_DEVICE";
	    case -34: return "CL_INVALID_CONTEXT";
	    case -35: return "CL_INVALID_QUEUE_PROPERTIES";
	    case -36: return "CL_INVALID_COMMAND_QUEUE";
	    case -37: return "CL_INVALID_HOST_PTR";
	    case -38: return "CL_INVALID_MEM_OBJECT";
	    case -39: return "CL_INVALID_IMAGE_FORMAT_DESCRIPTOR";
	    case -40: return "CL_INVALID_IMAGE_SIZE";
	    case -41: return "CL_INVALID_SAMPLER";
	    case -42: return "CL_INVALID_BINARY";
	    case -43: return "CL_INVALID_BUILD_OPTIONS";
	    case -44: return "CL_INVALID_PROGRAM";
	    case -45: return "CL_INVALID_PROGRAM_EXECUTABLE";
	    case -46: return "CL_INVALID_KERNEL_NAME";
	    case -47: return "CL_INVALID_KERNEL_DEFINITION";
	    case -48: return "CL_INVALID_KERNEL";
	    case -49: return "CL_INVALID_ARG_INDEX";
	    case -50: return "CL_INVALID_ARG_VALUE";
	    case -51: return "CL_INVALID_ARG_SIZE";
	    case -52: return "CL_INVALID_KERNEL_ARGS";
	    case -53: return "CL_INVALID_WORK_DIMENSION";
	    case -54: return "CL_INVALID_WORK_GROUP_SIZE";
	    case -55: return "CL_INVALID_WORK_ITEM_SIZE";
	    case -56: return "CL_INVALID_GLOBAL_OFFSET";
	    case -57: return "CL_INVALID_EVENT_WAIT_LIST";
	    case -58: return "CL_INVALID_EVENT";
	    case -59: return "CL_INVALID_OPERATION";
	    case -60: return "CL_INVALID_GL_OBJECT";
	    case -61: return "CL_INVALID_BUFFER_SIZE";
	    case -62: return "CL_INVALID_MIP_LEVEL";
	    case -63: return "CL_INVALID_GLOBAL_WORK_SIZE";
	    case -64: return "CL_INVALID_PROPERTY";
	    case -65: return "CL_INVALID_IMAGE_DESCRIPTOR";
	    case -66: return "CL_INVALID_COMPILER_OPTIONS";
	    case -67: return "CL_INVALID_LINKER_OPTIONS";
	    case -68: return "CL_INVALID_DEVICE_PARTITION_COUNT";

	    // extension errors
	    case -1000: return "CL_INVALID_GL_SHAREGROUP_REFERENCE_KHR";
	    case -1001: return "CL_PLATFORM_NOT_FOUND_KHR";
	    case -1002: return "CL_INVALID_D3D10_DEVICE_KHR";
	    case -1003: return "CL_INVALID_D3D10_RESOURCE_KHR";
	    case -1004: return "CL_D3D10_RESOURCE_ALREADY_ACQUIRED_KHR";
	    case -1005: return "CL_D3D10_RESOURCE_NOT_ACQUIRED_KHR";
	    default: return "Unknown OpenCL error";
    }
}

