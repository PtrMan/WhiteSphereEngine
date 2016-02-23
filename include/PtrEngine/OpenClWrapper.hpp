#pragma once

#include <CL/cl.h>
#include <CL/cl_gl.h>
#include <CL/cl_ext.h>
#include <string>
#include <list>
#include <vector>
#include <memory>

#include <epoxy/gl.h>

using namespace std;

// this is a "simple" OpenCL warper
// is used to improve readability of the openCL things
class OpenClWrapper {
   public:
	// this class is throw if it don't have memory
	class NoMemory {
	};
	
	// this is a class for custom Error Messages
	class ErrorMessage {
	   public:
		string message;
		
		ErrorMessage(string Message) : message(Message) {}
	};

	class CantOpenFile {
	   public:
		string file;
		
		CantOpenFile(string File) : file(File) {}
	};

	//---


	class Kernel {
	public:
		Kernel(cl_kernel handle);
		~Kernel();

		cl_kernel getHandle() const;
	protected:
		cl_kernel handle;
	};
	
	// this is a Capsulation for the OpenCL program and the possible actions of it
	class Program {
		friend class OpenClWrapper;
	   public:
		~Program();

		// creates a Kernel from the openCL Program Object
		std::shared_ptr<OpenClWrapper::Kernel> createKernel(string name);

	   protected:
		cl_program program;
	};

	
	// this is visible from outside
	// this is a list with events for that a comand can wait before it is run in the queue
	// the user have to make shure that he deletes it later
	// TODO< do bind the Objekct to the OpenClWrapper object
	class EventList {
		friend class OpenClWrapper;
	   public:
	   protected:
		vector<cl_event> events;
	};

	// this is a Capsulation for a Buffer and the possible actions for it
	class Buffer {
		friend class OpenClWrapper;
	   public:
		// is a clas for error-throwing
		class ExceptionMappingFailed {};
		Buffer(OpenClWrapper* OpenClWrapperPtr);
		~Buffer();
		
		// this write to the buffer
		// if Waitlist is not nullptr, it allocates a new event in the Eventlist and pass the pointer to it to the API
		// throws a error if something goes wrong
		void write(cl_bool Blocking, const void *Ptr, size_t Size, size_t Offset, cl_event* Event = nullptr, EventList* Waitlist = nullptr);
		
		// this writes to the buffer and passes the "native" waitlist as a pointer with the count to the OpenCL-API
		void write(cl_bool Blocking, const void *Ptr, size_t Size, size_t Offset, cl_event* Event, cl_uint WaitlistCount, cl_event* Waitlist);

		// this reads from a buffer
		// if Eventlist is not nullptr, it allocates a new event in the Eventlist and pass the pointer to it to the API
		// throws a error if something goes wrong
		void read(cl_bool Blocking, void* Ptr, size_t Size, size_t Offset, cl_event* Event = nullptr, EventList* Eventlist = nullptr);
		
		// this reads from a buffer
		// this reads from the buffer and passes the "native" waitlist as a pointer with the count to the OpenCL-API
		// throws a error if something goes wrong
		void read(cl_bool Blocking, void *Ptr, size_t Size, size_t Offset, cl_event* Event, cl_uint WaitlistCount, cl_event* Waitlist);
		

		// map a buffer and return the memory to it 
		// TODO< event things and so on >
		void* map(cl_bool Blocking, cl_map_flags Flags, size_t Size, size_t Offset);
		

		// this returns the pointer to the buffer openCL object
		// TODO< maybe we don't need this kind of function cos it should not be public accessable >
		cl_mem* getPtr();
	   protected:
		cl_mem buffer;
		OpenClWrapper* openclw; // is a pointer to the opencl object
	};

	class Image {
		friend class OpenClWrapper;
	   public:
		Image();
		~Image();

		// TODO< maybe we don't need this kind of function cos it should not be public accessable >
		cl_mem getHandle() const;
	   protected:
		cl_mem image;
	};

	OpenClWrapper();
	~OpenClWrapper();
	
	// this try to compile the Programm Filename and return on success a program Object (a pointer)
	// the program object is managed by this Class
	std::shared_ptr<Program> openAndCompile(string Filename);

	// this creates a buffer object and return a buffer object
	// throw a error if something goes wrong
	Buffer* createBuffer(cl_mem_flags Flags, size_t Size, void* Ptr);

	// this creates a "OpenCL image object" from a openGL Texture
	// Flags: see OpenCL clCreateFromGLTexture2D function documentation
	// Texture: is the existing openGL texture ID
	
	// Throws an Error if something goes wrong

	// openCL/openGL note:
	//  texture_target is everytime GL_TEXTURE_2D
	//  miplevel is everytime 0
	std::shared_ptr<Image> createImageFromOpenGLTexture(cl_mem_flags Flags, GLuint Texture);

	std::shared_ptr<Image> createImage2dOnDevice(cl_mem_flags flags, unsigned sizeX, unsigned sizeY, cl_channel_order channelOrder, cl_channel_type channelType);

	// TODO< deleteBuffer >

	// this is for testcode
	// TODO< remove it >
	// TESTCODE
	// returns the command queue
	cl_command_queue testcode_getCQ() {
		return GPUCommandQueue;
	}

	// this is a little helper function that converts the errorcode into its text
	static string getErrorText(cl_int Errorcode);

   protected:
	cl_context GPUContext;
	cl_command_queue GPUCommandQueue;
	cl_device_id* GPUDevices;
};
