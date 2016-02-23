module DMain;

import std.stdio : writeln, write;
import std.string; // for toStringz

import std.stdio;
import std.file;

import std.datetime;

import Sdl;

import gl;
import glExtQueryAdresses;

import GraphicsCoreGl : GraphicsCoreGl;
import OpenClWrapper : OpenClWrapper;
static import Fbo;
import Buffer : Buffer;

import Vector;

import ShaderUtilities : ShaderUtilities;
import ShaderProgram : ShaderProgram;
import ErrorStack : ErrorStack;
import ResourceDag : ResourceDag;

void reportError(string Message, ErrorStack LocalErrorstack) {
	writeln(Message);
	
	writeln(LocalErrorstack.Message);
	writeln(LocalErrorstack.Submessages);
}

void main() {
	bool CalleeSuccess;

	ResourceDag LocalResourceDag = new ResourceDag();
	scope(exit) LocalResourceDag.disposeFromExternalAll();

	ErrorStack LocalErrorstack = new ErrorStack();


	if( Sdl.SDL_Init(Sdl.SDL_INIT_VIDEO) < 0 ) {
		writeln("Can't initialize sdl!");
		return;
	}

	glExtQueryAdresses.initalizeGlExtFunctions();

	GraphicsCoreGl GraphicsOpenGlCore = new GraphicsCoreGl();
	GraphicsOpenGlCore.initSdlForGl();


	string windowTitle = "GAME";

	// TODO< undefined position >
	SDL_Window *windowHandler = SDL_CreateWindow(
        toStringz(windowTitle),
        0,
        0,           // initial y position
        512,
        512,
        SDL_WINDOW_OPENGL | SDL_WINDOW_SHOWN
    );

    if (windowHandler is null) {
        // In the case that the window could not be made...
        writeln("Could not create window: " /*, SDL_GetError()*/);
        // TODO< SDL_GetError to string >
        return;
    }

    scope(exit) {
    	SDL_DestroyWindow(windowHandler);
    	SDL_Quit();
    }


    GraphicsOpenGlCore.initGl(windowHandler, LocalErrorstack);
    if( !LocalErrorstack.inNormalState ) {
		reportError("Error while initialisizing OpenGL", LocalErrorstack);
		return;
	}

    scope(exit) GraphicsOpenGlCore.dispose();

    // need to initialize this
    Fbo.queryMaxRenderbufferColorAtachments();
	


    OpenClWrapper openClWrapper = new OpenClWrapper();
    openClWrapper.aquire(LocalErrorstack);
    if( !LocalErrorstack.inNormalState ) {
    	reportError("Error while initialisizing OpenCL", LocalErrorstack);
		return;
	}

	scope(exit) openClWrapper.dispose();




	OpenClWrapper.Program openclProgramTestA = openClWrapper.openAndCompile("./opencl/KernelTransfer.cl", LocalErrorstack);
	if( !LocalErrorstack.inNormalState ) {
		reportError("Error while compiling OpenCL program!", LocalErrorstack);
		return;
	}

	OpenClWrapper.Kernel openclKernelCopyImage = openclProgramTestA.createKernel("kernelCopyImage");



	Fbo.FboHandle FboHandleForMainFbo = Fbo.create(512, 512, [new Fbo.FormatDescriptor(GL_RGBA, GL_RGBA, GL_UNSIGNED_BYTE)], LocalResourceDag, LocalErrorstack);
	if( !LocalErrorstack.inNormalState ) {
		reportError("Error while creating FBO!", LocalErrorstack);
		return;
	}

	scope(exit) FboHandleForMainFbo.disposeImmediatly();


	string VertexShaderPath = "./shader/glsl/SimpleVertex.glsl";
	string FragmentShaderPath = "./shader/glsl/SimpleFragment.glsl";
	ShaderProgram GlslTestProgram = ShaderUtilities.createProgramLinkedCompileFromFiles(VertexShaderPath, FragmentShaderPath, [new ShaderUtilities.BindingLocation(0, "in_Position")], LocalErrorstack);
	if( !LocalErrorstack.inNormalState ) {
		reportError("Error while building Shader!", LocalErrorstack);
		return;
	}

	VertexShaderPath = "./shader/glsl/Coordinate3dVertex.glsl";
	FragmentShaderPath = "./shader/glsl/StampFragment.glsl";
	ShaderProgram GlslStampProgram = ShaderUtilities.createProgramLinkedCompileFromFiles(VertexShaderPath, FragmentShaderPath, [new ShaderUtilities.BindingLocation(0, "in_Position"), new ShaderUtilities.BindingLocation(1, "in_coordinate")], LocalErrorstack);
	if( !LocalErrorstack.inNormalState ) {
		reportError("Error while building Shader!", LocalErrorstack);
		return;
	}










	Buffer VertexBuffer = new Buffer();

	// *** configure and fill buffer
	Buffer.EnumConfigureResult ConfigureReturnCode;
	VertexBuffer.configure([Buffer.EnumDatatype.VERTEXPOSITION], ConfigureReturnCode);
	if( ConfigureReturnCode != Buffer.EnumConfigureResult.SUCCESS ) {
		reportError("Can't configure vertex buffer!", LocalErrorstack);
		return;
	}
	
	VertexBuffer.setPolygonCount(1, CalleeSuccess);
	if( !CalleeSuccess ) {
		reportError("setPolygonCount() failed!", LocalErrorstack);
		return;
	}

	VertexBuffer.setVerticesCount(3, CalleeSuccess);
	if( !CalleeSuccess ) {
		reportError("setVerticesCount() failed!", LocalErrorstack);
		return;
	}

	VertexBuffer.setVertexIndex(0, 0);
	VertexBuffer.setVertexIndex(1, 1);
	VertexBuffer.setVertexIndex(2, 2);

/*
	VertexBuffer.setVertexIndex(3, 3);
	VertexBuffer.setVertexIndex(4, 4);
	VertexBuffer.setVertexIndex(5, 5);
*/

/*
	VertexBuffer.setPosition(0, new Vector3f(-0.5f, -0.5f, 0.5f));
	VertexBuffer.setPosition(1, new Vector3f(5f, 0.0f, -0.1f));
	VertexBuffer.setPosition(2, new Vector3f(0.0f, 5f, 0.5f));
	
	VertexBuffer.setPosition(3, new Vector3f(-0.5f, -0.5f, -0.5f));
	VertexBuffer.setPosition(4, new Vector3f(1f, 0.0f, -0.1f));
	VertexBuffer.setPosition(5, new Vector3f(0.0f, 5f, -0.5f));
*/	

	VertexBuffer.setPosition(0, new Vector3f(0.0f,  0.0f,  0.0f));
	VertexBuffer.setPosition(1, new Vector3f(1f, 0,  0.0f));
	VertexBuffer.setPosition(2, new Vector3f(0, 1,  0.0f));

/*	
	VertexBuffer.setPosition(3, new Vector3f(-0.5f, -0.5f, -0.5f));
	VertexBuffer.setPosition(4, new Vector3f(1f, 0.0f, -0.1f));
	VertexBuffer.setPosition(5, new Vector3f(0.0f, 5f, -0.5f));
*/

	Buffer.EnumBuildBufferResult BuildBufferResult;
	VertexBuffer.toBuiltState(BuildBufferResult);
	if( BuildBufferResult != Buffer.EnumBuildBufferResult.SUCCESS ) {
		reportError("toBuiltState() failed!", LocalErrorstack);
		return;
	}












	FboHandleForMainFbo.bind(CalleeSuccess);
	if( !CalleeSuccess ) {
		reportError("binding of FBO failed!", LocalErrorstack);
		return;
	}

	Fbo.bindNone();




	// render
	StopWatch sw;
	sw.start();


	glClearColor(1.0, 0.0, 0.0, 0.0);
   glClearDepthf(1.0f);
   glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	glViewport(0, 0, 512, 512);


	GlslTestProgram.useThis();

	VertexBuffer.bindThis();


	VertexBuffer.drawThis();


	

	
	sw.stop();

	writeln("Microseconds: ",sw.peek().usecs);

	ubyte pixels[512*512*4];
   	glReadPixels(0, 0, 512, 512, GL_RGBA, GL_UNSIGNED_BYTE, pixels.ptr);


   	File file = File("test.ppm", "w");

   	file.writeln("P3");
	file.writeln("512 512");
	file.writeln("255");

   	for( uint y = 0; y < 512; y++ ) {
   		for( uint x = 0; x < 512; x++ ) {
   			file.write(pixels[((y * 512 + x) * 4) + 0], " ");
   			file.write(pixels[((y * 512 + x) * 4) + 1], " ");
   			file.write(pixels[((y * 512 + x) * 4) + 2], "  ");
   		}

   		file.writeln("");
   	}

   	file.close();

	writeln("HERE");

	// TODO< render ! >

}