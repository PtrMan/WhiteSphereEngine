#include "PtrEngine/Fbo.hpp"

// NOTE< opengl context must allready be initialisized >
void Fbo::init(unsigned sizeX, unsigned sizeY, bool &success) {
   success = false;

   glGenFramebuffers(1, &fboHandle); // frame buffer

   glGenRenderbuffers(1, &(RenderBufferDepth)); // render buffer
   glGenTextures(1, &(fboTexture)); // texture
   glBindFramebuffer(GL_FRAMEBUFFER, fboHandle);

   //  initialize texture
   glBindTexture(GL_TEXTURE_2D, fboTexture);

   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
   glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR); // important, else its incomplete and we can't render it

   glTexImage2D(GL_TEXTURE_2D, 0, /*GL_RGBA8*/GL_RGBA/*GL_RGBA8_EXT*/, sizeX, sizeY, 0, GL_RGBA, GL_UNSIGNED_BYTE, nullptr);

   //  attach texture to framebuffer color buffer
   glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, fboTexture, 0);

   //  initialize depth renderbuffer
   glBindRenderbuffer(GL_RENDERBUFFER, RenderBufferDepth);
   glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT24, sizeX, sizeY);

   //  attach renderbuffer to framebuffer depth buffer
   glFramebufferRenderbuffer(
      GL_FRAMEBUFFER, 
      GL_DEPTH_ATTACHMENT,
      GL_RENDERBUFFER, 
      RenderBufferDepth
   );

   GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
   
   if( status == GL_FRAMEBUFFER_COMPLETE ) {
      success = true;
   }

   Fbo::bindNone();

   //success = true;
}

void Fbo::bind(bool &success) {
   success = false;

   glBindFramebuffer(GL_FRAMEBUFFER, fboHandle);

   GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
   
   if(status == GL_FRAMEBUFFER_COMPLETE)
   {
      //printf("FBO complete!!");
      success = true;
   }
}

unsigned Fbo::getTexture() {
   return fboTexture;
}

void Fbo::bindNone() {
   glBindFramebuffer(GL_FRAMEBUFFER, 0);
}
