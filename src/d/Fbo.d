module Fbo;

import std.conv : to;

import gl;
import glExt;
import IDisposable : IDisposable;
import ErrorStack : ErrorStack;
import ResourceDag : ResourceDag;

// TODO< doku >

private class FramebufferResource : ResourceDag.IResource {
   public this(GLuint Handle) {
      this.Handle = Handle;
   }

   public final GLuint getOpenGlHandle() {
      return Handle;
   }

   public void dispose() {
      if( Valid ) {
         glDeleteFramebuffers(1, &Handle);
         Handle = 0;
         Valid = false;
      }
   }

   private bool Valid = true;
   private GLuint Handle;  
}

public class TextureResource : ResourceDag.IResource {
   public this(GLuint Handle) {
      this.Handle = Handle;
   }

   public final GLuint getOpenGlHandle() {
      return Handle;
   }

   public void dispose() {
      if( Valid ) {
         // TODO< delet texture >
         Handle = 0;
         Valid = false;
      }
   }

   private bool Valid = true;
   private GLuint Handle;  
}

private static uint MaxRenderbufferColorAtachments = 0;

public static void queryMaxRenderbufferColorAtachments() {
   GLint maxAttach = 0;
   glGetIntegerv(GL_MAX_COLOR_ATTACHMENTS, &maxAttach);
   MaxRenderbufferColorAtachments = maxAttach;
}

public class FormatDescriptor {
   public this(GLint InternalType, GLenum Format, GLenum Type) {
      this.InternalType = InternalType;
      this.Format = Format;
      this.Type = Type;
   }

   GLint InternalType;
   GLenum Format;
   GLenum Type;
}

public class FboHandle {
   private ResourceDag.EntryResourceNode ThisEntryResourceNode;

   private ResourceDag.ResourceNode FramebufferResourceNode;

   private ResourceDag.ResourceNode FramebufferRenderBufferForDepth; // "Render Buffer" for the depth

   private TextureResource[] Textures;


   final public void bind(out bool Success) {
      Success = false;

      glBindFramebuffer(GL_FRAMEBUFFER, (cast(FramebufferResource)FramebufferResourceNode.getResource()).getOpenGlHandle());

      GLenum Status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
      
      if(Status == GL_FRAMEBUFFER_COMPLETE) {
         //printf("FBO complete!!");
         Success = true;
      }
   }

   final public GLuint getTextureOfDescriptor(uint Index) {
      return this.Textures[Index].getOpenGlHandle();
   }

   final public void disposeImmediatly() {
      ThisEntryResourceNode.disposeImmediatly();
   }
}

// NOTE< opengl context must allready be initialisized >
public static FboHandle create(uint SizeX, uint SizeY, FormatDescriptor[] FormatDescriptors, ResourceDag LocalResourceDag, ErrorStack LocalErrorstack) {
   if( FormatDescriptors.length >= MaxRenderbufferColorAtachments ) {
      LocalErrorstack.setRecoverableError("Call requires more Renderbuffer Color Attachments than available!", [to!string(MaxRenderbufferColorAtachments)], __FILE__, __LINE__);
      return null;
   }

   FboHandle ResultFboHandle = new FboHandle();
   ResultFboHandle.ThisEntryResourceNode = LocalResourceDag.createEntryNode();


   GLuint FramebufferGlHandle;
   GLuint DepthbufferGlHandle;

   glGenFramebuffers(1, &FramebufferGlHandle); // frame buffer
   ResultFboHandle.FramebufferResourceNode = LocalResourceDag.createNode(new FramebufferResource(FramebufferGlHandle));
   ResultFboHandle.ThisEntryResourceNode.addChild(ResultFboHandle.FramebufferResourceNode);

   glGenRenderbuffers(1, &DepthbufferGlHandle); // render buffer
   ResultFboHandle.FramebufferRenderBufferForDepth = LocalResourceDag.createNode(new FramebufferResource(DepthbufferGlHandle));
   ResultFboHandle.ThisEntryResourceNode.addChild(ResultFboHandle.FramebufferRenderBufferForDepth);      

   glBindFramebuffer(GL_FRAMEBUFFER, FramebufferGlHandle);

   for( int DescriptorI = 0; DescriptorI < FormatDescriptors.length; DescriptorI++ ) {
      FormatDescriptor CurrentFormatDescriptor = FormatDescriptors[DescriptorI];

      GLuint TextureGlHandle;
      glGenTextures(1, &TextureGlHandle);
      if( TextureGlHandle == 0 ) {
         // rollback
         ResultFboHandle.ThisEntryResourceNode.disposeImmediatly();

         LocalErrorstack.setRecoverableError("Could not generate OpenGL Texture!", [], __FILE__, __LINE__);
         return null;
      }
      TextureResource CreatedTextureResource = new TextureResource(TextureGlHandle);
      ResultFboHandle.Textures ~= CreatedTextureResource;
      ResultFboHandle.ThisEntryResourceNode.addChild(LocalResourceDag.createNode(CreatedTextureResource));

      //  initialize texture
      glBindTexture(GL_TEXTURE_2D, TextureGlHandle);

      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR); // important, else its incomplete and we can't render it

      glTexImage2D(GL_TEXTURE_2D, 0, CurrentFormatDescriptor.InternalType, SizeX, SizeY, 0, CurrentFormatDescriptor.Format, CurrentFormatDescriptor.Type, null);
   
      // attach texture to framebuffer color buffer
      glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0+DescriptorI, GL_TEXTURE_2D, TextureGlHandle, 0);
   }

   //  initialize depth renderbuffer
   glBindRenderbuffer(GL_RENDERBUFFER, DepthbufferGlHandle);
   glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT24, SizeX, SizeY);

   //  attach renderbuffer to framebuffer depth buffer
   glFramebufferRenderbuffer(
      GL_FRAMEBUFFER, 
      GL_DEPTH_ATTACHMENT,
      GL_RENDERBUFFER, 
      DepthbufferGlHandle
   );

   GLenum Status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
   
   if(Status != GL_FRAMEBUFFER_COMPLETE) {
      // rollback
      ResultFboHandle.ThisEntryResourceNode.disposeImmediatly();
      
      LocalErrorstack.setRecoverableError("Renderbuffer status is incomplete after creation!", [], __FILE__, __LINE__);
      return null;
   }

   Fbo.bindNone();

   return ResultFboHandle;
}

static public void bindNone() {
   glBindFramebuffer(GL_FRAMEBUFFER, 0);
}

