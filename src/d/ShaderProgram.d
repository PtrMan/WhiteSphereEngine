module ShaderProgram;

import IDisposable : IDisposable;
import MemoryAccessor;
import std.string; // for tostringz
import core.stdc.string : strlen;

import gl;
static import glExt;

import Shader : Shader;

class ShaderProgram : IDisposable
{
   // enable deprecated Pre 3.0 4.0 functionality?
   static const bool ENABLEFIXEDPIPELINE = false;

   public enum EnumReturnCode
   {
      FAILED = 0,
      OK,
      OUTOFMEMORY
   }

   final bool create()
   {
      this.Program = glExt.glCreateProgram();
      
      return this.Program != 0;
   }

   final public void attach(Shader OfShader)
   in
   {
      assert(OfShader !is null);
   }
   body
   {
      glExt.glAttachShader(this.Program, OfShader.getHandle());
   }

   // must be called before link!
   final public void bindAttribLocation(uint Index, string Attribute)
   {
      glExt.glBindAttribLocation(this.Program, Index, Attribute.toStringz);
   }

   // must be called before link!
   final public void bindFragmentOutput(uint ColorNumber, string Name)
   {
      glExt.glBindFragDataLocation(this.Program, ColorNumber, Name.toStringz);
   }

   //uint GetAttributeLocation(string Name);

   final public uint getUniformLocation(string Name)
   {
      return glExt.glGetUniformLocation(this.Program, Name.toStringz);
   }

   /** \brief wrapper around glUniformMatrix4fv to set the matrix
    *
    * \param Location ...
    * \param Ptr pointer to raw 4x4 matrix data
    */
   static public void uniformMatrix(uint Location, float* Ptr)
   {
      glExt.glUniformMatrix4fv(Location, 1, GL_FALSE, Ptr); 
   }

   final public void link(out EnumReturnCode ReturnCode, out string ErrorMessage, out string linkerLog)
   {
      int MessageLength;
      int LinkStatus;

      ReturnCode = EnumReturnCode.FAILED;

      glExt.glLinkProgram(this.Program);

      glExt.glGetProgramiv(this.Program, glExt.GL_LINK_STATUS, &LinkStatus);

      if( LinkStatus == GL_FALSE )
      {
         // linking error

         glExt.glGetProgramiv(this.Program, glExt.GL_INFO_LOG_LENGTH, &MessageLength);
         
         char *linkerLogCString = cast(char*)MemoryAccessor.allocateMemoryNoScanNoMove(MessageLength);
         if( linkerLogCString is null ) {
            ReturnCode = EnumReturnCode.OUTOFMEMORY;
            return;
         }
         scope(exit) MemoryAccessor.freeMemory(cast(void*)linkerLogCString);

         glExt.glGetProgramInfoLog(this.Program, MessageLength, &MessageLength, linkerLogCString);
         
         // TODO< transfer linker log >
         linkerLog = cast(string)linkerLogCString[0 .. strlen(linkerLogCString)];

         return;
      }

      ReturnCode = EnumReturnCode.OK;
   }

   final public void useThis()
   {
      glExt.glUseProgram(this.Program);
   }

   /** \brief binds against fixed functionality hardware
    *
    * \note this is deprecated with OpenGL 3.X or 4.X functionality
    */
   static if(ShaderProgram.ENABLEFIXEDPIPELINE) {
      final public static void useNone()
      {
         glExt.glUseProgram(0);
      }
   }

   final public uint getHandle()
   {
      return this.Program;
   }

   public void dispose() {
      if( Program != 0 ) {
         glExt.glDeleteProgram(Program);
         Program = 0;
      }
   }
   
   private uint Program;
}