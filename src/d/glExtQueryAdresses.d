module glExtQueryAdresses;

import std.string;

static import glExt;

// if on linux
static if(true) {

	extern(System)
	{
		void *glXGetProcAddress(immutable char*);
	}

	// under linux this works without initialisation
	void initalizeGlExtFunctions() {
		// TODO< automatically generate code for this when compiling >

		glExt.glCreateProgram = cast(glExt.TYPEGLCREATEPROGRAM)glXGetProcAddress("glCreateProgram");
	     glExt.glUseProgram = cast(glExt.TYPEGLUSEPROGRAM)glXGetProcAddress("glUseProgram");
	     glExt.glAttachShader = cast(glExt.TYPEGLATTACHSHADER)glXGetProcAddress("glAttachShader");
	     glExt.glLinkProgram = cast(glExt.TYPEGLLINKPROGRAM)glXGetProcAddress("glLinkProgram");
	     glExt.glBindAttribLocation = cast(glExt.TYPEGLBINDATTRIBLOCATION)glXGetProcAddress("glBindAttribLocation");
	     glExt.glBindFragDataLocation = cast(glExt.TYPEGLBINDFRAGDATALOCATION)glXGetProcAddress("glBindFragDataLocation");
	     glExt.glGetUniformLocation = cast(glExt.TYPEGLGETUNIFORMLOCATION)glXGetProcAddress("glGetUniformLocation");
	     glExt.glGetProgramiv = cast(glExt.TYPEGLUEIP)glXGetProcAddress("glGetProgramiv");
	     glExt.glGetShaderiv = cast(glExt.TYPEGLUEIP)glXGetProcAddress("glGetShaderiv");
	     glExt.glGetProgramInfoLog = cast(glExt.TYPEGLUSISIPCP)glXGetProcAddress("glGetProgramInfoLog");
	     glExt.glGetShaderInfoLog = cast(glExt.TYPEGLUSISIPCP)glXGetProcAddress("glGetShaderInfoLog");
	     glExt.glCreateShader = cast(glExt.TYPEGLCREATESHADER)glXGetProcAddress("glCreateShader");
	     glExt.glShaderSource = cast(glExt.TYPEGLSHADERSOURCE)glXGetProcAddress("glShaderSource");
	     glExt.glCompileShader = cast(glExt.TYPEGLU)glXGetProcAddress("glCompileShader");
	     glExt.glDeleteProgram = cast(glExt.PFNGLDELETEPROGRAMPROC)glXGetProcAddress("glDeleteProgram");

	     glExt.glUniformMatrix4fv = cast(glExt.TYPEGLUNIFORMMATRIX4FV)glXGetProcAddress("glUniformMatrix4fv");

	     // Buffer
	     glExt.glGenVertexArrays = cast(glExt.TYPEGLGENVERTEXARRAYS)glXGetProcAddress("glGenVertexArrays");
	     glExt.glBindVertexArray = cast(glExt.TYPEGLU)glXGetProcAddress("glBindVertexArray");
	     glExt.glVertexAttribPointer = cast(glExt.TYPEGLVERTEXATTRIBPOINTER)glXGetProcAddress("glVertexAttribPointer");
	     glExt.glEnableVertexAttribArray = cast(glExt.TYPEGLU)glXGetProcAddress("glEnableVertexAttribArray");
	     glExt.glDeleteVertexArrays = cast(glExt.TYPEGLDELETEVERTEXARRAYS)glXGetProcAddress("glDeleteVertexArrays");
	     glExt.glBindBuffer = cast(glExt.TYPEGLBINDBUFFER)glXGetProcAddress("glBindBuffer");
	     glExt.glBufferData = cast(glExt.TYPEGLBUFFERDATA)glXGetProcAddress("glBufferData");
	     glExt.glGenBuffers = cast(glExt.TYPEGLGENBUFFERS)glXGetProcAddress("glGenBuffers");
	     glExt.glDeleteBuffers = cast(glExt.TYPEGLDELETEBUFFERS)glXGetProcAddress("glDeleteBuffers");

	    // VBO
	    glExt.glBindFramebuffer = cast(glExt.TYPEGLBINDFRAMEBUFFER)glXGetProcAddress("glBindFramebuffer");
	    glExt.glDeleteFramebuffers = cast(glExt.TYPEGLDELETEFRAMEBUFFER)glXGetProcAddress("glDeleteFramebuffers");
	    glExt.glGenFramebuffers = cast(glExt.TYPEGLGENFRAMEBUFFERS)glXGetProcAddress("glGenFramebuffers");
	    glExt.glCheckFramebufferStatus = cast(glExt.TYPEGLCHECKFRAMEBUFFERSTATUS)glXGetProcAddress("glCheckFramebufferStatus");
	    glExt.glFramebufferTexture2D = cast(glExt.TYPEGLFRAMEBUFFERTEXTURE2D)glXGetProcAddress("glFramebufferTexture2D");
	    glExt.glBindRenderbuffer = cast(glExt.TYPEGLBINDRENDERBUFFER)glXGetProcAddress("glBindRenderbuffer");
	    glExt.glRenderbufferStorage = cast(glExt.TYPEGLRENDERBUFFERSTORAGE)glXGetProcAddress("glRenderbufferStorage");
	    glExt.glFramebufferRenderbuffer = cast(glExt.TYPEGLFRAMEBUFFERRENDERBUFFER)glXGetProcAddress("glFramebufferRenderbuffer");
	    glExt.glGenRenderbuffers = cast(glExt.TYPEGLGENRENDERBUFFERS)glXGetProcAddress("glGenRenderbuffers");
	}
}
