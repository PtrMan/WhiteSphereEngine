module GraphicsCoreGl;

import gl;
import Sdl;
import ErrorStack : ErrorStack;
import IDisposable : IDisposable;

// graphics initialisation for sdl/opengl 

class GraphicsCoreGl : IDisposable {
	public final void initSdlForGl() {
		Sdl.SDL_GL_SetAttribute(Sdl.SDL_GL_CONTEXT_MAJOR_VERSION, 3);
		Sdl.SDL_GL_SetAttribute(Sdl.SDL_GL_CONTEXT_MINOR_VERSION, 3);
		Sdl.SDL_GL_SetAttribute(Sdl.SDL_GL_ACCELERATED_VISUAL, 1);
		Sdl.SDL_GL_SetAttribute(Sdl.SDL_GL_DOUBLEBUFFER, 1);
	}

	public final void initGl(SDL_Window *windowHandler, ErrorStack ArgumentErrorStack) {
		context = Sdl.SDL_GL_CreateContext(windowHandler);
		if (!context) {
			ArgumentErrorStack.setFatalError("Couldn't create OpenGL context", [/* + SDL_GetError()*/], __FILE__, __LINE__);
			return;
	    }

	    glEnable(GL_DEPTH_TEST);
	    glDepthFunc(GL_LEQUAL);

	    // TODO< fastest >
    	glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);

    	// TODO< enable >
    	glDisable(GL_CULL_FACE);

    	glDisable(GL_DEPTH_TEST);
	}

	public void dispose() {
		deleteGl();
	}

	protected final void deleteGl() {
		if( context != 0 ) {
			Sdl.SDL_GL_DeleteContext(context);
			context = 0;
		}
	}

	protected SDL_GLContext context;
}
