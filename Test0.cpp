
#include <epoxy/gl.h>
#include <epoxy/glx.h>

#include <SDL2/SDL.h>
#include <SDL2/SDL_opengl.h>







#include <iostream>
using namespace std;



#include <string>


// TODO
// * render text triangle in OpenGL, do simple identify Kernel, read OpenCL image to host and display it on the console
// * basic defered/infered shading




class GraphicsOpenGlCore {
public:
	struct InitialisationException {
		std::string text;

		InitialisationException(std::string text) {
			this->text = text;
		}
	};
public:
	GraphicsOpenGlCore() {
		context = 0;
	}

	~GraphicsOpenGlCore() {
		deleteGl();
	}

	void initSdlForGl() {
		SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 3);
		SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 3);
		SDL_GL_SetAttribute(SDL_GL_ACCELERATED_VISUAL, 1);
		SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);
		SDL_GL_SetAttribute(SDL_GL_ACCELERATED_VISUAL, 1);
	}

	void initGl(SDL_Window *windowHandler) {
		context = SDL_GL_CreateContext(windowHandler);
		if (!context) {
	        throw InitialisationException(std::string("Couldn't create OpenGL context: ") + SDL_GetError());
	    }

	    glEnable(GL_DEPTH_TEST);
	    glDepthFunc(GL_LEQUAL);

	    // TODO< fastest >
    	glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);
	}
protected:
	void deleteGl() {
		if( context != 0 ) {
			SDL_GL_DeleteContext(context);
			context = 0;
		}
	}

	SDL_GLContext context;
};



#include <functional>


// from http://the-witness.net/news/2012/11/scopeexit-in-c11/
template <typename F>
struct ScopeExit {
    ScopeExit(F f) : f(f) {}
    ~ScopeExit() { f(); }
    F f;
};

template <typename F>
ScopeExit<F> makeScopeExit(F f) {
    return ScopeExit<F>(f);
};





#include <vector>
#include "PtrEngine/hacks/EigenFixup.h"
#include <eigen/Dense>

void *createBufferCppBinding();

void BufferCppBindingCallconfigure(void*,int *typePtr, unsigned typesLength, int *returnCode);
void BufferCppBindingCallsetPolygonCount(void*, unsigned Count, bool *SuccessValue);
void BufferCppBindingCallsetVertexIndex(void*, unsigned ArrayIndex, unsigned VertexIndex);
void BufferCppBindingCallsetVerticesCount(void*, unsigned, bool *);
void BufferCppBindingCallsetPosition(void*, unsigned Index, float *Data);
void BufferCppBindingCallsetData(void*,unsigned Index, unsigned TypeIndex, float *Data);
void BufferCppBindingCallbindThis(void*);
void BufferCppBindingCalldrawThis(void*);
void BufferCppBindingCallbindNone(void*);
void BufferCppBindingCalltoModifyState(void*, bool *calleeSuccess);
void BufferCppBindingCalltoBuiltState(void*,int *ReturnCode);
void BufferCppBindingCallrelease(void*);

class Buffer {
public:
	enum class EnumConfigureResult {
      	IMPOSSIBLE = 0,
      	OUTOFMEMORY,
      	VERTEXPOSITIONWRONGINDEX, /*< Vertex position must be at index 0 */
      	TYPESLENGTHZERO, /*< Types Array has a length of 0 ! */
      	MULTIPLEPOSITIONS, /*< one vertex has multiple positions! */
      	ALLREADYCONFIGURED, /*< the buffer was allready configured! */
      	SUCCESS
   	};

   	enum class EnumDatatype {
      	VERTEXPOSITION = 0,
      	DATA2D, /*< texture coordinates, ... */
      	DATA3D
   	};

   	enum class EnumBuildBufferResult {
      	IMPOSSIBLE = 0,
      	NOMEMORY,
      	NOTCONFIGURED,
      	POSITIONORDATAWASNULL, /*< at least one reference in the position or a data buffer was null */
      	WRONGSTATE, /*< the buffer was in wrong state */
      	SUCCESS
   	};

	void configure(std::vector<Buffer::EnumDatatype> &bufferDatatypes, EnumConfigureResult &returnCode) {
		int configureReturnCodeInt;
		int *bufferDatatypesForD = reinterpret_cast<int*>(&(bufferDatatypes[0]));
		BufferCppBindingCallconfigure(reinterpret_cast<void*>(this), bufferDatatypesForD, bufferDatatypes.size(), &configureReturnCodeInt);
		EnumConfigureResult returnCodeTemp = static_cast<Buffer::EnumConfigureResult>(configureReturnCodeInt);
		returnCode = returnCodeTemp;
	}

    void setPolygonCount(unsigned Count, bool &SuccessValue) {
    	bool calleeSuccess;
    	BufferCppBindingCallsetPolygonCount(reinterpret_cast<void*>(this), Count, &calleeSuccess);
    	SuccessValue = calleeSuccess;
    }

    void setVertexIndex(unsigned ArrayIndex, unsigned VertexIndex) {
    	BufferCppBindingCallsetVertexIndex(reinterpret_cast<void*>(this), ArrayIndex, VertexIndex);
    }

    void setVerticesCount(unsigned Count, bool &SuccessValue) {
    	bool calleeSuccess;
    	BufferCppBindingCallsetVerticesCount(reinterpret_cast<void*>(this), Count, &calleeSuccess);
    	SuccessValue = calleeSuccess;
    }
    
    
    void setPosition(unsigned Index, Eigen::Matrix<float, 3, 1> Position) {
    	float positionArray[3] = {Position(0), Position(1), Position(2)};
    	BufferCppBindingCallsetPosition(reinterpret_cast<void*>(this), Index, reinterpret_cast<float*>(&positionArray));
	}
	

    void setData(unsigned Index, unsigned TypeIndex, float *Data) {
    	BufferCppBindingCallsetData(reinterpret_cast<void*>(this), Index,TypeIndex, Data);
    }

    void bindThis() {
    	BufferCppBindingCallbindThis(reinterpret_cast<void*>(this));
    }
    void drawThis() {
    	BufferCppBindingCalldrawThis(reinterpret_cast<void*>(this));
    }
    void bindNone() {
    	BufferCppBindingCallbindNone(reinterpret_cast<void*>(this));
    }
   	void toModifyState(bool &SuccessValue) {
   		bool calleeSuccess;
   		BufferCppBindingCalltoModifyState( reinterpret_cast<void*>(this), &calleeSuccess);
		SuccessValue = calleeSuccess;
   	}
   	void toBuiltState(Buffer::EnumBuildBufferResult &ReturnCode) {
   		int returnCodeInt;
   		BufferCppBindingCalltoBuiltState(reinterpret_cast<void*>(this), &returnCodeInt);
		Buffer::EnumBuildBufferResult ReturnCodeCopy = static_cast<Buffer::EnumBuildBufferResult>(returnCodeInt);
		ReturnCode = ReturnCodeCopy;
   	}
   	void release() {
   		BufferCppBindingCallrelease(reinterpret_cast<void*>(this));
   	}
};

void *ShaderCppBindingCTOR();
void ShaderCppBindingcompile(void *ptr, char *source, int type, int *returnCode, char **compileErrorMessage);
int ShaderCppBindinggetHandle(void *ptr);


class Shader
{
public:
	enum class EnumShaderType
	{
	  	VERTEXSHADER = 0,
	  	FRAGMENTSHADER
	};

	enum class EnumReturnCodes
	{
	  	FAILED = 0, // Failed without ErrorMessage
	  	COMPILATIONERROR = 2, // a error message
	  	OK = 3,
	  	OK_SOFTWARE = 4 // compiled ok but its running on software, no error message
	};

	void compile(std::string Source, EnumShaderType Type, EnumReturnCodes &ReturnCode, std::string &CompileErrorMessage) {
		Shader::EnumReturnCodes returncode2;
		int returncodeFromD;
		char* errorMessagefromD;
	  	ShaderCppBindingcompile(reinterpret_cast<void*>(this), const_cast<char*>(Source.c_str()), static_cast<int>(Type), &returncodeFromD, &errorMessagefromD);
	  	returncode2 = static_cast<Shader::EnumReturnCodes>(returncodeFromD);
	  	ReturnCode = returncode2;

	  	CompileErrorMessage = std::string(errorMessagefromD);
	  	free(errorMessagefromD);
	}

	GLuint getHandle()
	{
		static_cast<GLuint>(ShaderCppBindinggetHandle(reinterpret_cast<void*>(this)));
	}
};











void initDRuntime();

void dmain();


#include <stdexcept>

#include "PtrEngine/OpenClWrapper.hpp"
#include "PtrEngine/Fbo.hpp"
	

int main() {
	bool calleeSuccess;


	std::cout << "init D runtime" << std::endl;
	initDRuntime();
	std::cout << "done" << std::endl;

	if( SDL_Init(SDL_INIT_VIDEO) < 0 ) {
		throw std::runtime_error(std::string("Can't initialize sdl!"));
	}

	GraphicsOpenGlCore graphicsOpenGlCore;

	graphicsOpenGlCore.initSdlForGl();







	std::string windowTitle = "GAME";

	// TODO< undefined position >
	SDL_Window *windowHandler = SDL_CreateWindow(
        windowTitle.c_str(),
        0,
        0,           // initial y position
        640,
        480,
        SDL_WINDOW_OPENGL | SDL_WINDOW_SHOWN
    );

    if (windowHandler == nullptr) {
        // In the case that the window could not be made...
        throw std::runtime_error(std::string("Could not create window: ") + SDL_GetError());
        return 1;
    }

    auto scope0 = makeScopeExit([&](){
    	SDL_DestroyWindow(windowHandler);
    	SDL_Quit();
    });


    graphicsOpenGlCore.initGl(windowHandler);









	Buffer *vertexBuffer = reinterpret_cast<Buffer*>(createBufferCppBinding());

	// *** configure and fill buffer

	

	std::vector<Buffer::EnumDatatype> bufferDatatypes;
	Buffer::EnumConfigureResult configureReturnCode;

	bufferDatatypes.push_back(Buffer::EnumDatatype::VERTEXPOSITION);

	vertexBuffer->configure(bufferDatatypes, configureReturnCode);
	if( configureReturnCode != Buffer::EnumConfigureResult::SUCCESS ) {
		//std::cout << configureReturnCode << std::endl;
		throw std::runtime_error(std::string("Can't configure vertex buffer!"));
	}
	
	vertexBuffer->setPolygonCount(1, calleeSuccess);
	if( !calleeSuccess ) {
		throw std::runtime_error(std::string("setPolygonCount() failed!"));
	}

	vertexBuffer->setVerticesCount(3, calleeSuccess);
	if( !calleeSuccess ) {
		throw std::runtime_error(std::string("setVerticesCount() failed!"));
	}

	vertexBuffer->setVertexIndex(0, 0);
	vertexBuffer->setVertexIndex(1, 1);
	vertexBuffer->setVertexIndex(2, 2);

	vertexBuffer->setPosition(0, Eigen::Matrix<float, 3, 1>(0.0f, 0.0f, 0.5f));
	vertexBuffer->setPosition(1, Eigen::Matrix<float, 3, 1>(1.0f, 0.0f, 0.5f));
	vertexBuffer->setPosition(2, Eigen::Matrix<float, 3, 1>(0.0f, 1.0f, 0.5f));

	Buffer::EnumBuildBufferResult buildBufferResult;
	vertexBuffer->toBuiltState(buildBufferResult);
	if( buildBufferResult != Buffer::EnumBuildBufferResult::SUCCESS ) {
		throw std::runtime_error(std::string("toBuiltState() failed!"));
	}

	dmain();








	OpenClWrapper openClWrapper;

	Fbo fboTest;


	fboTest.init(512, 512, calleeSuccess);
	if( !calleeSuccess ) {
		throw std::runtime_error(std::string("Could not create Framebufferobject!"));
        return 1;
	}

	std::shared_ptr<OpenClWrapper::Program> openclProgramTestA = openClWrapper.openAndCompile("../opencl/KernelTransfer.cl");

	std::shared_ptr<OpenClWrapper::Kernel> openclKernelCopyImage = openclProgramTestA->createKernel("kernelCopyImage");


	// OpenCL OpenGL interop test

	// TODO< clean up later >
	std::shared_ptr<OpenClWrapper::Image> openclImageForFbo = openClWrapper.createImageFromOpenGLTexture(CL_MEM_READ_ONLY, fboTest.getTexture());


	// TODO< render correctly (for now just with a clear command that we can see something) >
	




	// *** create destination image
	std::shared_ptr<OpenClWrapper::Image> openclImageForColorResult = openClWrapper.createImage2dOnDevice(CL_MEM_READ_WRITE, 512, 512, CL_RGBA, CL_FLOAT);


	// important before we do the aquire
	glFinish();

	// *** aquire openCL previlege of OpenGL buffer
	//     if we forget this our kernel fails!

	// TODO< move into wrapper ! >
	{
		cl_mem openclHandleImageSource = openclImageForFbo->getHandle();
		cl_int openclResult = clEnqueueAcquireGLObjects(openClWrapper.testcode_getCQ(), 1, &openclHandleImageSource, 0, 0, nullptr);
		if( openclResult != CL_SUCCESS ) {
			throw std::runtime_error(std::string("clEnqueueAcquireGLObjects() error: ") + OpenClWrapper::getErrorText(openclResult));
		}
		// TODO< wait list and event for waiting >
	}
	

	// *** setup kernel
	cl_kernel openclHandleKernelCopyImage = openclKernelCopyImage->getHandle();

	cl_mem openclHandleImageSource = openclImageForFbo->getHandle();
	clSetKernelArg(openclHandleKernelCopyImage, 0, sizeof(cl_mem), &openclHandleImageSource);

	cl_mem openclHandleImageDestination = openclImageForColorResult->getHandle();
	clSetKernelArg(openclHandleKernelCopyImage, 1, sizeof(cl_mem), &openclHandleImageDestination);

	size_t global_item_size[] = {512, 512};
	size_t local_item_size[] = {1, 1};
			
	/* Execute OpenCL kernel as data parallel */
	cl_int openclResult = clEnqueueNDRangeKernel(
		openClWrapper.testcode_getCQ(),
		openclHandleKernelCopyImage,
		2,
		nullptr,
		reinterpret_cast<const size_t*>(&global_item_size),
		reinterpret_cast<const size_t*>(&local_item_size),
		0,
		nullptr,
		nullptr
	);
	if( openclResult != CL_SUCCESS ) {
		throw std::runtime_error(std::string("clEnqueueNDRangeKernel() error: ") + OpenClWrapper::getErrorText(openclResult));
	}

	// TODO< wait for kernel >


	// important before we do the release
	clFinish(openClWrapper.testcode_getCQ());

	// release aqured OpenCL previleges of OpenGL buffer

	// TODO< move into wrapper ! >
	{
		

		cl_mem openclHandleImageSource = openclImageForFbo->getHandle();
		clEnqueueReleaseGLObjects(openClWrapper.testcode_getCQ(), 1,  &openclHandleImageSource, 0, 0, nullptr);
	}


	// *** read back image
	// 3 dimensional array size is important, else we get not defined behaviour
	size_t readOrigin[3] = {0, 0, 0};
	size_t readRegion[3] = {512, 512, 1};

	// for testing just with malloc, TODO< encapsulate this into a RAII container >
	float *buffer = static_cast<float*>(malloc(512*512  * 4 /* size of RGBA */  * sizeof(float) /* size of float */));

	openclResult = clEnqueueReadImage(
		openClWrapper.testcode_getCQ(),
	  	openclImageForColorResult->getHandle(),
	  	CL_TRUE,
	  	reinterpret_cast<const size_t*>(&readOrigin),
	  	reinterpret_cast<const size_t*>(&readRegion),
	  	0,
	  	0,
	  	buffer,
	  	0,
	  	nullptr,
	  	nullptr
  	);
  	if( openclResult != CL_SUCCESS ) {
		throw std::runtime_error(std::string("clEnqueueReadImage() error: ") + OpenClWrapper::getErrorText(openclResult));
	}




	// debug image on the console (the dumb way)
	for( int y = 0; y < 512; y++ ) {
		for( int x = 0; x < 512; x++ ) {
			bool threshold = buffer[(x + y*512)*4] > 0.5f;

			if( threshold ) {
				std::cout << "x";
			}
			else {
				std::cout << ".";
			}
		}

		std::cout << std::endl;
	}







  	free(buffer);
  	buffer = nullptr;




    SDL_GL_SwapWindow(windowHandler);

    // The window is open: could enter program loop here (see SDL_PollEvent())

    SDL_Delay(3000);  // Pause execution for 3000 milliseconds, for example




    return 0;
}
