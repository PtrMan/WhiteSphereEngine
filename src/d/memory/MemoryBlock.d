module MemoryBlock;

import MemoryAccessor;

struct MemoryBlock
{
   final public void configure(uint Elementsize) nothrow
   in
   {
      assert(Elementsize != 0);
   }
   body
   {
      this.Elementsize = Elementsize;
   }
   
   final void *opIndex(ulong Index) nothrow
   in
   {
      assert(Index < this.AllocatedElementsPrivate);
   }
   body
   {
      assert(this.Ptr !is null);

      return cast(void*)( cast(ulong)this.Ptr + Index * this.Elementsize );
   }

   /*
   final public void *index(uint Index, out bool Success)
   {
      Success = false;
      if( Index >= this.AllocatedElementsPrivate )
      {
         return null;
      }
      Success = true;
      return cast(void*)( cast(uint)this.Ptr + Index * this.Elementsize );  
   }*/

   /** \brief expands the Array if needed to fit the count 
    *
    * \param Elements number of Elements
    * \param Success true if successfull
    */
   final public void expandNeeded(ulong Elements, out bool Success) nothrow
   {
      Success = false;

      assert(this.Elementsize != 0);

      if( Elements == 0 )
      {
         return;
      }

      if( Elements <= this.AllocatedElementsPrivate )
      {
         Success = true;
         return;
      }
      else
      {
         if( this.Ptr is null )
         {
            this.Ptr = allocateMemoryNoScanNoMove(Elements * this.Elementsize);
            
            if( this.Ptr is null )
            {
               return;
            }

            this.AllocatedElementsPrivate = Elements;

            // fall througth
         }
         else
         {
            void *NewPtr = reallocateMemoryNoScanNoMove(this.Ptr, Elements * this.Elementsize);

            if( NewPtr is null )
            {
               return;
            }

            this.AllocatedElementsPrivate = Elements;

            // fall througth
         }

         Success = true;
      }
   }

   final public void free() nothrow
   {
      if( this.Ptr !is null )
      {
         freeMemory(this.Ptr);

         this.AllocatedElementsPrivate = 0;
         this.Ptr = null;
      }
   }

   final public void *unsafeGetPtr() nothrow
   {
      assert(this.Ptr !is null);

      return this.Ptr;
   }

   @property ulong allocatedElements() {
      return AllocatedElementsPrivate;
   }

   invariant()
   {
      if( Ptr !is null )
      {
         assert(AllocatedElementsPrivate != 0);
         assert(Elementsize != 0);
      }
      else
      {
         assert(AllocatedElementsPrivate == 0);
      }
   }

   private void *Ptr;
   private ulong AllocatedElementsPrivate;
   private uint Elementsize;
}