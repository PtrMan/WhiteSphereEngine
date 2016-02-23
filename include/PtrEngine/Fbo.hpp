#pragma once

#include <epoxy/gl.h>
#include <epoxy/glx.h>

class Fbo {
public:

   // NOTE< opengl context must allready be initialisized >
   void init(unsigned sizeX, unsigned sizeY, bool &success);
   
   void bind(bool &success);

   unsigned getTexture();

   static void bindNone();
private:
   unsigned fboTexture;        // Texture for the "render to texture"

   GLuint fboHandle;         // FBO for "render to texture"
   unsigned RenderBufferDepth; // "Render Buffer" for the depth
};
