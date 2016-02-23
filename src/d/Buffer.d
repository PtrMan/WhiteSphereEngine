module Buffer;

// for debugging
//import std.stdio : writeln;

import gl;
static import glExt;

import Vector : Vector;
import MemoryBlock;
import Array : Array;

import MemoryAccessor;

/** \brief Abstraction for a buffer which holds and renders polygons
 *
 * Steps needed in the lifetime of an Buffer
 *
 * * Creation
 * * Configuration
 * * loop
 *   * filling/refilling
 *   * build
 *   * render
 */
class Buffer
{
   /** \brief Enumeration for the state of the Buffer
    *
    */
   public enum EnumBufferState
   {
      NOTCONFIGURED = 0,
      MODIFY, /*< buffer is free for modifications */
      BUILT
   }

   public enum EnumBuildBufferResult
   {
      IMPOSSIBLE = 0,
      NOMEMORY,
      NOTCONFIGURED,
      POSITIONORDATAWASNULL, /*< at least one reference in the position or a data buffer was null */
      WRONGSTATE, /*< the buffer was in wrong state */
      SUCCESS
   }

   public enum EnumDatatype
   {
      VERTEXPOSITION = 0,
      DATA2D, /*< texture coordinates, ... */
      DATA3D
   }

   public enum EnumConfigureResult
   {
      IMPOSSIBLE = 0,
      OUTOFMEMORY,
      VERTEXPOSITIONWRONGINDEX, /*< Vertex position must be at index 0 */
      TYPESLENGTHZERO, /*< Types Array has a length of 0 ! */
      MULTIPLEPOSITIONS, /*< one vertex has multiple positions! */
      ALLREADYCONFIGURED, /*< the buffer was allready configured! */
      SUCCESS
   }

   this() {
      this.RawVertices.configure(float.sizeof);
      this.RawVertexIndices.configure(ushort.sizeof);
   }

   final public void configure(EnumDatatype[] Types, out EnumConfigureResult ReturnCode)
   {
      ReturnCode = EnumConfigureResult.IMPOSSIBLE;

      if( this.BufferState != EnumBufferState.NOTCONFIGURED )
      {
         ReturnCode = EnumConfigureResult.ALLREADYCONFIGURED;
         return;
      }

      if( Types.length == 0 )
      {
         ReturnCode = EnumConfigureResult.TYPESLENGTHZERO;
         return;
      }

      if( Types[0] != EnumDatatype.VERTEXPOSITION )
      {
         ReturnCode = EnumConfigureResult.VERTEXPOSITIONWRONGINDEX;
         return;
      }

      foreach( TypeI; 1..Types.length )
      {
         EnumDatatype Type = Types[TypeI];

         if( Type == EnumDatatype.VERTEXPOSITION )
         {
            ReturnCode = EnumConfigureResult.MULTIPLEPOSITIONS;
            return;
         }
      }

      this.Types = Types;

      bool CalleeSuccess;
      this.Data.resize(cast(uint)this.Types.length-1, CalleeSuccess);
      if( !CalleeSuccess ) {
         ReturnCode = EnumConfigureResult.OUTOFMEMORY;
         return;
      }

      ReturnCode = EnumConfigureResult.SUCCESS;

      this.BufferState = EnumBufferState.MODIFY;
   }

   final public void setPolygonCount(uint Count, out bool Success)
   {
      this.PolygonCount = Count;

      this.RawVertexIndices.expandNeeded(this.PolygonCount*3, Success);
   }
   
   final public void setVertexIndex(uint ArrayIndex, uint VertexIndex)
   {
      if( VertexIndex >= this.Positions.length )
      {
         return;
      }

      if( ArrayIndex >= this.PolygonCount*3 )
      {
         return;
      }

      *(cast(ushort*)this.RawVertexIndices[ArrayIndex]) = cast(ushort)VertexIndex;
   }

   final public void setVerticesCount(uint Count, out bool success)
   {
      success = false;

      if( this.BufferState == EnumBufferState.NOTCONFIGURED )
      {
         return;
      }

      bool calleeSuccess;
      this.Positions.resize(Count, calleeSuccess);
      if( !calleeSuccess ) {
         return;
      } 

      foreach( DataI; 0..this.Types.length-1 ) // -1 is correct
      {
         this.Data[DataI].resize(Count, calleeSuccess);
         if( !calleeSuccess ) {
            return;
         } 
      }

      success = true;
   }
   
   /** \brief sets the Position of an index
    *
    * returns quitly if the Index is too large
    *
    * \param Index ...
    * \param Position ...
    */
   final public void setPosition(uint Index, Vector!(3, float, true) Position)
   in
   {
      assert(Position !is null);
   }
   body
   {
      if( Index >= this.Positions.length )
      {
         return;
      }

      this.Positions[Index] = Position.clone();
   }

   /** \brief sets the data of an vertex
    *
    * returns quitly on error
    * asserts for null data
    *
    * \param Index index of the vertex
    * \param TypeIndex index of the type
    * \param Data the actual data
    */
   final public void setData(uint Index, uint TypeIndex, Vector!(3, float, true) Data)
   in
   {
      assert(Data !is null);
   }
   body
   {
      if( Index >= this.Positions.length )
      {
         return;
      }

      if( TypeIndex >= this.Types.length - 1 )
      {
         return;
      }

      this.Data[TypeIndex][Index] = Data.clone();
   }

   // if bound is true a buffer must be bound
   static private void checkBoundBuffer(bool Bound)
   {
      int BoundBuffer;

      glGetIntegerv(glExt.GL_VERTEX_ARRAY_BINDING, &BoundBuffer);

      if( Bound && BoundBuffer == 0 )
      {
         assert(false, "A VAO is bound!");
      }
      else if(  !Bound && BoundBuffer != 0 )
      {
         assert(false, "A VAO is bound!");
      }
   }

   final public void bindThis()
   {
      Buffer.checkBoundBuffer(false);

      glExt.glBindVertexArray(this.Vaos[0]);
   }

   final public void drawThis()
   {
      Buffer.checkBoundBuffer(true);

      // glDrawArrays(GL_TRIANGLES, 0, 3); old code for non indiced drawing
      glDrawElements(GL_TRIANGLES, this.PolygonCount*3, GL_UNSIGNED_SHORT, null); 
   }

   public static void bindNone()
   {
      Buffer.checkBoundBuffer(true);
      glExt.glBindVertexArray(0);
      Buffer.checkBoundBuffer(false);
   }

   /** \brief tries to go into the modify state
    *
    * \param Success true on success
    */
   final public void toModifyState(out bool Success)
   {
      Success = false;

      if( this.BufferState == EnumBufferState.BUILT )
      {
         this.BufferState = EnumBufferState.MODIFY;
         Success = true;
         return;
      }
   }

   /** \brief tries to go from modify state to built state
    *
    * it also automatically rebuilts the Buffer
    *
    * \param Success true on success
    */
   final public void toBuiltState(out EnumBuildBufferResult ReturnCode)
   {
      bool CalleeSuccess;
      EnumBuildBufferResult CalleeReturnCode;

      ReturnCode = EnumBuildBufferResult.WRONGSTATE;

      if( this.BufferState == EnumBufferState.MODIFY )
      {
         this.rebuild(CalleeReturnCode);

         if( CalleeReturnCode != EnumBuildBufferResult.SUCCESS )
         {
            ReturnCode = CalleeReturnCode;
            return;
         }

         this.BufferState = EnumBufferState.BUILT;
         
         ReturnCode = EnumBuildBufferResult.SUCCESS;
      }
   }


   final private void preFirstBuild(out EnumBuildBufferResult ReturnCode)
   {
      ReturnCode = EnumBuildBufferResult.IMPOSSIBLE;

      assert(this.Types.length-1 == this.Data.length, "Must be equal");

      assert(this.Types.length >= 1, "If the buffer was configured the length of the Types array must be 1 or more!");

      foreach( DataArray ; this.Data )
      {
         assert(this.Positions.length == DataArray.length, "Positions length must match Data length!");
      }


      this.Vaos = cast(uint*)allocateMemoryNoScanNoMove(1*uint.sizeof);
      
      if( this.Vaos is null )
      {
         ReturnCode = EnumBuildBufferResult.NOMEMORY;
         return;
      }

      scope(exit)
      {
         if( ReturnCode != EnumBuildBufferResult.SUCCESS )
         {
            freeMemory(this.Vaos);
            this.Vaos = null;
         }
      }

      this.Vbos = cast(uint*)allocateMemoryNoScanNoMove(this.Types.length*uint.sizeof);

      if( this.Vbos is null )
      {
         ReturnCode = EnumBuildBufferResult.NOMEMORY;
         return;
      }

      scope(exit)
      {
         if( ReturnCode != EnumBuildBufferResult.SUCCESS )
         {
            freeMemory(this.Vbos);
            this.Vbos = null;
         }
      }

      glExt.glGenVertexArrays(1, this.Vaos);

      // TODO< error check >

      scope(exit)
      {
         if( ReturnCode != EnumBuildBufferResult.SUCCESS )
         {
            glExt.glDeleteVertexArrays(1, this.Vaos);
         }
      }

      Buffer.checkBoundBuffer(false);

      glExt.glBindVertexArray(this.Vaos[0]);

      glExt.glGenBuffers(cast(uint)this.Types.length, this.Vbos);

      // TODO< error checks >

      scope(exit)
      {
         if( ReturnCode != EnumBuildBufferResult.SUCCESS )
         {
            glExt.glDeleteBuffers(cast(uint)this.Types.length, this.Vbos);
         }
      }

      glExt.glGenBuffers(1, &this.VboIndices);

      // TODO< check errors >

      scope(exit)
      {
         if( ReturnCode != EnumBuildBufferResult.SUCCESS )
         {
            glExt.glDeleteBuffers(1, &this.VboIndices);
         }
      }

      Buffer.bindNone();

      Buffer.checkBoundBuffer(false);

      ReturnCode = EnumBuildBufferResult.SUCCESS;
   }

   final private void rebuild(out EnumBuildBufferResult ReturnCode)
   {
      bool CalleeSuccess;
      EnumBuildBufferResult CalleeReturnCode;
      ulong OldAllocatedVertices;
      bool PositionDataWasNull;

      ReturnCode = EnumBuildBufferResult.IMPOSSIBLE;

      if( this.BufferState != EnumBufferState.MODIFY )
      {
         ReturnCode = EnumBuildBufferResult.WRONGSTATE;
         return;
      }

      if( this.FirstBuild )
      {
         this.preFirstBuild(CalleeReturnCode);
         if( CalleeReturnCode != EnumBuildBufferResult.SUCCESS )
         {
            ReturnCode = CalleeReturnCode;
            return;
         }

         this.FirstBuild = false;
      }



      assert(this.Types.length-1 == this.Data.length, "Must be equal");

      assert(this.Types.length >= 1, "If the buffer was configured the length of the Types array must be 1 or more!");

      foreach( DataArray ; this.Data )
      {
         assert(this.Positions.length == DataArray.length, "Positions length must match Data length!");
      }
      

      OldAllocatedVertices = this.AllocatedVertices;

      if( this.AllocatedVertices != this.Positions.length )
      {
         // reallocate buffers

         assert(this.Types.length >= 1);

         CalleeSuccess = this.reallocateDataArrays(this.Types.length-1);
         if( !CalleeSuccess )
         {
            // reallocation failed

            ReturnCode = EnumBuildBufferResult.NOMEMORY;
            return;
         }

         this.reallocatePositionArray(CalleeSuccess);
         if( !CalleeSuccess )
         {
            // reallocation failed

            this.freeAllArrays();

            return;
         }

         this.AllocatedVertices = cast(uint)this.Positions.length;
      }

      // TODO< reallocate indices array >

      this.fillRawMemory(PositionDataWasNull);

      if( PositionDataWasNull )
      {
         ReturnCode = EnumBuildBufferResult.POSITIONORDATAWASNULL;
         return;
      }

      this.uploadToGpu();

      ReturnCode = EnumBuildBufferResult.SUCCESS;
   }
   
   final public void release()
   {
      assert(this.Vaos !is null, "this.Vaos must point to valid memory!");
      assert(this.Vbos !is null, "this.Vbos must point to valid memory!");

      this.freeAllArrays();

      glExt.glDeleteBuffers(cast(uint)this.Types.length, this.Vbos);
      freeMemory(this.Vbos);

      this.Vbos = null; // just to make sure

      glExt.glDeleteVertexArrays(1, this.Vaos);
      freeMemory(this.Vaos);

      this.Vaos = null; // just to make sure
   }

   final private bool reallocateDataArrays(ulong NewNumberOfDataArrays)
   {
      bool AllocationFailed;

      if( NewNumberOfDataArrays < this.RawData.length )
      {
         // free the memory segments which are too many

         foreach( DataI; NewNumberOfDataArrays..this.RawData.length )
         {
            this.RawData[DataI].free();
         }
      }

      AllocationFailed = false;

      bool calleeSuccess;
      this.RawData.resize(cast(uint)NewNumberOfDataArrays, calleeSuccess);
      if( !calleeSuccess ) {
         return false;
      }

      foreach( DataI; 0..NewNumberOfDataArrays )
      {
         this.RawData[DataI].configure(float.sizeof);
      }

      foreach( DataI; 0..NewNumberOfDataArrays )
      {
         bool CalleeSuccess;

         this.RawData[DataI].expandNeeded(this.Positions.length *3, CalleeSuccess);
         if( !CalleeSuccess )
         {
            AllocationFailed = true;
            break;
         }
      }

      if( AllocationFailed )
      {
         this.freeAllArrays();
         return false;
      }

      return true;
   }

   final private void reallocatePositionArray(out bool CalleeSuccess)
   {
      this.RawVertices.expandNeeded(this.Positions.length*3, CalleeSuccess);
   }

   final private void fillRawMemory(out bool PositionDataWasNull)
   {
      PositionDataWasNull = true;

      // Vertex Position Array
      foreach( i; 0..this.Positions.length )
      {
         if( this.Positions[i] is null )
         {
            return;
         }

         *(cast(float*)this.RawVertices[i*3 + 0]) = this.Positions[i].X;
         *(cast(float*)this.RawVertices[i*3 + 1]) = this.Positions[i].Y;
         *(cast(float*)this.RawVertices[i*3 + 2]) = this.Positions[i].Z;
      }

      foreach( DataI; 0..this.Data.length )
      {
         foreach( i; 0..this.Positions.length )
         {
            if( this.Data[DataI][i] is null )
            {
               return;
            }

            *(cast(float*)this.RawData[DataI][i*3 + 0]) = this.Data[DataI][i].X;
            *(cast(float*)this.RawData[DataI][i*3 + 1]) = this.Data[DataI][i].Y;
            *(cast(float*)this.RawData[DataI][i*3 + 2]) = this.Data[DataI][i].Z;
         }
      }

      PositionDataWasNull = false;
   }

   final private void freeAllArrays()
   {
      this.RawVertices.free();
      this.RawVertexIndices.free();

      foreach( i; 0..this.RawData.length )
      {
         this.RawData[i].free();
      }
   }

   final private void uploadToGpu()
   {
      Buffer.checkBoundBuffer(false);

      glExt.glBindVertexArray(this.Vaos[0]);

      glExt.glBindBuffer(glExt.GL_ELEMENT_ARRAY_BUFFER, this.VboIndices);
      glExt.glBufferData(glExt.GL_ELEMENT_ARRAY_BUFFER, this.PolygonCount*3 * ushort.sizeof, this.RawVertexIndices.unsafeGetPtr(), glExt.GL_STATIC_DRAW);


      glExt.glBindBuffer(glExt.GL_ARRAY_BUFFER, this.Vbos[0]);
      glExt.glBufferData(glExt.GL_ARRAY_BUFFER, this.Positions.length * 3*GLfloat.sizeof, this.RawVertices.unsafeGetPtr(), glExt.GL_STATIC_DRAW);
      glExt.glVertexAttribPointer(cast(GLuint)0, 3, GL_FLOAT, GL_FALSE, 0, null); 
      glExt.glEnableVertexAttribArray(0);

      foreach( DataI; 0..this.Data.length )
      {
         glExt.glBindBuffer(glExt.GL_ARRAY_BUFFER, this.Vbos[DataI+1]);
         glExt.glBufferData(glExt.GL_ARRAY_BUFFER, this.Positions.length * 3*GLfloat.sizeof, this.RawData[DataI].unsafeGetPtr(), glExt.GL_STATIC_DRAW);
         glExt.glVertexAttribPointer(cast(GLuint)DataI+1, 3, GL_FLOAT, GL_FALSE, 0, null);
         glExt.glEnableVertexAttribArray(cast(GLuint)DataI+1);
      }
 
      // TODO< error check >

      Buffer.bindNone();

      Buffer.checkBoundBuffer(false);
      // Vertices and colors can now be deleted
   }

   private GLuint *Vaos; /**< pointer to handler of the Vertex Array Object */
   private GLuint *Vbos; /**< pointer to one or many Vbo handlers */

   private uint VboIndices; /**< Vbo which is used for the indices */

   private EnumDatatype[] Types; /**< Types of the VBO's */

   private EnumBufferState BufferState = EnumBufferState.NOTCONFIGURED;

   private Array!(Vector!(3, float, true), true) Positions;

   private Array!(Array!(Vector!(3, float, true), true), true) Data;

   private uint PolygonCount;

   private Array!(MemoryBlock, true) RawData;
   private MemoryBlock RawVertices;
   private MemoryBlock RawVertexIndices; /**< is use for directly storing the indices to the Vertices of the polygons (without GC'ed memory) */

   private uint AllocatedVertices = 0;

   private bool FirstBuild = true;
}