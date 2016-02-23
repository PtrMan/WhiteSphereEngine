module Sdl;

alias uint Uint32;

alias void SDL_Window;
alias uint SDL_GLattr;

alias uint SDL_GLContext;

;static const uint  SDL_INIT_TIMER          =0x00000001
;static const uint  SDL_INIT_AUDIO          =0x00000010
;static const uint  SDL_INIT_VIDEO          =0x00000020  /**< SDL_INIT_VIDEO implies SDL_INIT_EVENTS */
;static const uint  SDL_INIT_JOYSTICK       =0x00000200  /**< SDL_INIT_JOYSTICK implies SDL_INIT_EVENTS */
;static const uint  SDL_INIT_HAPTIC         =0x00001000
;static const uint  SDL_INIT_GAMECONTROLLER =0x00002000  /**< SDL_INIT_GAMECONTROLLER implies SDL_INIT_JOYSTICK */
;static const uint  SDL_INIT_EVENTS         =0x00004000
;static const uint  SDL_INIT_NOPARACHUTE    =0x00100000  /**< Don't catch fatal signals */
//;static const uint  SDL_INIT_EVERYTHING ( \
//                SDL_INIT_TIMER | SDL_INIT_AUDIO | SDL_INIT_VIDEO | SDL_INIT_EVENTS | \
//                SDL_INIT_JOYSTICK | SDL_INIT_HAPTIC | SDL_INIT_GAMECONTROLLER \
//            )
;;

extern(System)
{
	int SDL_Init(Uint32 flags);
	void SDL_Quit();
}

//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
// from SDL video

;static const uint      SDL_WINDOW_FULLSCREEN = 0x00000001         /**< fullscreen window */
 ;static const uint     SDL_WINDOW_OPENGL = 0x00000002             /**< window usable with OpenGL context */
;static const uint      SDL_WINDOW_SHOWN = 0x00000004              /**< window is visible */
;static const uint      SDL_WINDOW_HIDDEN = 0x00000008             /**< window is not visible */
;static const uint      SDL_WINDOW_BORDERLESS = 0x00000010         /**< no window decoration */
;static const uint      SDL_WINDOW_RESIZABLE = 0x00000020          /**< window can be resized */
;static const uint      SDL_WINDOW_MINIMIZED = 0x00000040          /**< window is minimized */
;static const uint      SDL_WINDOW_MAXIMIZED = 0x00000080          /**< window is maximized */
;static const uint      SDL_WINDOW_INPUT_GRABBED = 0x00000100      /**< window has grabbed input focus */
;static const uint      SDL_WINDOW_INPUT_FOCUS = 0x00000200        /**< window has input focus */
;static const uint      SDL_WINDOW_MOUSE_FOCUS = 0x00000400        /**< window has mouse focus */
;static const uint      SDL_WINDOW_FULLSCREEN_DESKTOP = ( SDL_WINDOW_FULLSCREEN | 0x00001000 )
;static const uint      SDL_WINDOW_FOREIGN = 0x00000800            /**< window not created by SDL */
 ;static const uint     SDL_WINDOW_ALLOW_HIGHDPI = 0x00002000       /**< window should be created in high-DPI mode if supported */




//typedef enum
//{
;static const uint  SDL_GL_RED_SIZE = 0; // propably right
;static const uint      SDL_GL_GREEN_SIZE = 1;
;static const uint      SDL_GL_BLUE_SIZE = 2;
;static const uint      SDL_GL_ALPHA_SIZE = 3;
;static const uint      SDL_GL_BUFFER_SIZE = 4;
;static const uint      SDL_GL_DOUBLEBUFFER = 5;
;static const uint      SDL_GL_DEPTH_SIZE = 6;
;static const uint      SDL_GL_STENCIL_SIZE = 7;
;static const uint      SDL_GL_ACCUM_RED_SIZE = 8;
;static const uint      SDL_GL_ACCUM_GREEN_SIZE = 9;
;static const uint      SDL_GL_ACCUM_BLUE_SIZE = 10;
 ;static const uint     SDL_GL_ACCUM_ALPHA_SIZE = 11;
;static const uint      SDL_GL_STEREO = 12;
;static const uint      SDL_GL_MULTISAMPLEBUFFERS = 13;
;static const uint      SDL_GL_MULTISAMPLESAMPLES = 14;
;static const uint      SDL_GL_ACCELERATED_VISUAL = 15;
;static const uint      SDL_GL_RETAINED_BACKING =16 ;
;static const uint      SDL_GL_CONTEXT_MAJOR_VERSION = 17;
;static const uint  SDL_GL_CONTEXT_MINOR_VERSION = 18;
;static const uint      SDL_GL_CONTEXT_EGL = 19;
;static const uint      SDL_GL_CONTEXT_FLAGS = 20;
 ;static const uint     SDL_GL_CONTEXT_PROFILE_MASK = 21;
;static const uint      SDL_GL_SHARE_WITH_CURRENT_CONTEXT = 22;
;static const uint      SDL_GL_FRAMEBUFFER_SRGB_CAPABLE = 23;
//} SDL_GLattr;

;;

extern(System)
{
void SDL_GL_SetAttribute(SDL_GLattr attr, int value);
SDL_GLContext SDL_GL_CreateContext(SDL_Window *window);
void SDL_GL_SwapWindow(SDL_Window * window);
void SDL_GL_DeleteContext(SDL_GLContext context);

void SDL_DestroyWindow(SDL_Window * window);
SDL_Window * SDL_CreateWindow(immutable char *title,
                                                      int x, int y, int w,
                                                      int h, uint flags);
}