module Glx;

// GL/glx.h

alias void* GLXContext;

extern(System) {
GLXContext glXGetCurrentContext();
/*Display*/void *glXGetCurrentDisplay();
}