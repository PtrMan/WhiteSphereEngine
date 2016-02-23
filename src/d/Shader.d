module Shader;

import MemoryAccessor;
import std.string; // for tostringz

import gl;
import glExt;

class Shader {
   public enum EnumShaderType {
      VERTEXSHADER = 0,
      FRAGMENTSHADER
   }

   public enum EnumReturnCodes {
      FAILED = 0, // Failed without ErrorMessage
      COMPILATIONERROR = 2, // a error message
      OK = 3,
      OK_SOFTWARE = 4, // compiled ok but its running on software, no error message
      OUTOFMEMORY
   }
   
   final public void compile(string Source, EnumShaderType Type, out EnumReturnCodes ReturnCode, out string CompileErrorMessage) {
      uint OpenglType;
      bool SoftwareExecution = false;

      ReturnCode = EnumReturnCodes.FAILED;

      CompileErrorMessage = "";

      final switch(Type) {
         case EnumShaderType.FRAGMENTSHADER:
         OpenglType = GL_FRAGMENT_SHADER;
         break;

         case EnumShaderType.VERTEXSHADER:
         OpenglType = GL_VERTEX_SHADER;
         break;
      }

      this.ShaderHandler = glCreateShader(OpenglType);
      if( this.ShaderHandler == 0 ) {
         return;
      }

      //char **Array;
      char *Array[1];
      Array[0] = cast(char*)Source.toStringz;

      glShaderSource(this.ShaderHandler, 1, cast(char**)Array, null);
      glCompileShader(this.ShaderHandler);

      GLint ReturnGLInt;
      GLint LogLength;

      glGetShaderiv(this.ShaderHandler, GL_INFO_LOG_LENGTH, &LogLength);
      
      string LogText = "";

      if( LogLength > 0 ) {
         char *LogMemory = cast(char*)MemoryAccessor.allocateMemoryNoScanNoMove(LogLength);
         if( LogMemory is null ) {
            ReturnCode = EnumReturnCodes.OUTOFMEMORY;
            return;
         }

         scope(exit) MemoryAccessor.freeMemory(LogMemory);
         
         glGetShaderInfoLog(this.ShaderHandler, LogLength, &LogLength, LogMemory);

         
         for( uint i = 0;; i++ ) {
            if( LogMemory[i] == 0 )
            {
               break;
            }

            LogText ~= LogMemory[i];
         }

         if( LogText.length == 0 ) {
         }
         else if( std.string.indexOf(LogText, "Hardware", std.string.CaseSensitive.no) == -1 ) {
            SoftwareExecution = true;
         }
      }
      else {
         // Log is ok
      }
      

      glGetShaderiv(this.ShaderHandler, GL_COMPILE_STATUS, &ReturnGLInt);
      if( ReturnGLInt == GL_FALSE ) {
         // compiling error
      
         // return error message
         CompileErrorMessage = LogText;

         ReturnCode = EnumReturnCodes.COMPILATIONERROR;

         return;
      }

      if( !SoftwareExecution ) {
         ReturnCode = EnumReturnCodes.OK;
      }
      else {
         ReturnCode = EnumReturnCodes.OK_SOFTWARE;
      }
   }
   
   // doesn't check for errors
   final public GLuint getHandle() {
      return this.ShaderHandler;
   }

   GLuint ShaderHandler;
}
