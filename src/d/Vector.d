module Vector;

import std.math : sqrt;

alias Vector!(2, float, true) Vector2f;
alias Vector!(3, float, true) Vector3f;
alias Vector!(2, int, false) Vector2i;

/** \brief Template for a Position/Vector
 *
 */
template Vector(uint Size, Type, bool UseSse)
{
   class Vector
   {
      private const Type NULL = cast(Type)0;

      static if( Size == 2 )
      {
         this(Type X, Type Y)
         {
            this.X = X;
            this.Y = Y; 
         }
      }
      else static if( Size == 3 )
      {
         this(Type X, Type Y, Type Z)
         {
            this.X = X;
            this.Y = Y;
            this.Z = Z;
         }
      }
      else
      {
         static assert(false, "Size is not valid!");
      }


      @property Type X()
      {
         return this.Data[0];
      }

      @property Type X(Type Value)
      {
         return this.Data[0] = Value;
      }

      @property Type Y()
      {
         return this.Data[1];
      }

      @property Type Y(Type Value)
      {
         return this.Data[1] = Value;
      }

      static if( Size == 3 )
      {
          @property Type Z()
         {
            return this.Data[2];
         }

         @property Type Z(Type Value)
         {
            return this.Data[2] = Value;
         }
      }

      /** \brief calclates dot product between two vectors
       *
       * \param Other ...
       */
      final Type dot(Vector!(Size, Type, UseSse) Other)
      {
         Type Result;

         Result = NULL;

         // NOTE< compiler is as of v2.063 too stupid to optimize this
         /*foreach( Index; 0..2 )
         {
            Result = Result + this.Data[Index]*Other.Data[Index];
         }*/

         Result = Result + this.Data[0]*Other.Data[0];
         Result = Result + this.Data[1]*Other.Data[1];

         static if( Size == 3 )
         {
            Result = Result + this.Data[2]*Other.Data[2];            
         }

         return Result;
      }

      static if( __traits(isFloating, Type) )
      {
         // TOUML
         /** \brief returns the length
          *
          * \return ...
          */
         final public Type getLength()
         {
            return sqrt(this.dot(this));
         }

         // TOUML
         /** \brief returns the normalized Vector
          *
          * \return ...
          */
         final public Vector!(Size, Type, UseSse) normalized()
         {
            Type Length, RLength;

            Length = this.getLength();

            // we do it to avliad divide by zero
            if( Length == NULL )
            {
               Length = 1.0f;
            }

            RLength = 1.0f/Length;

            return this.scale(RLength);
         }
      }
      
      /** \brief return the squaredLength
       *
       * \return ...
       */
      final public Type getSquaredLength()
      {
         return this.dot(this);
      }

      /** \brief clones the Vector
       *
       * \return a clone with the same values
       */
      final public Vector!(Size, Type, UseSse) clone()
      {
         static if (Size == 2)
         {
            return new Vector!(Size, Type, UseSse)(this.X, this.Y);
         }
         else static if (Size == 3)
         {
            return new Vector!(Size, Type, UseSse)(this.X, this.Y, this.Z);
         }
         else
         {
            static assert(false, "invalid");
         }
      }

      // TODOCU
      final public Vector!(Size, Type, UseSse) scale(Type Scale)
      {
         static if (Size == 2)
         {
            Vector!(Size, Type, UseSse) Return = new Vector!(Size, Type, UseSse)(NULL, NULL);
         }
         else static if (Size == 3)
         {
            Vector!(Size, Type, UseSse) Return = new Vector!(Size, Type, UseSse)(NULL, NULL, NULL);
         }
         
         Return.Data[0] = this.Data[0] * Scale;
         Return.Data[1] = this.Data[1] * Scale;

         static if( Size == 3 )
         {
            Return.Data[2] = this.Data[2] * Scale;            
         }

         return Return;
      }

      final public Vector!(Size, Type, UseSse) opBinary(string op)(Vector!(Size, Type, UseSse) Rhs)
      {
         static if (Size == 2)
         {
            Vector!(Size, Type, UseSse) Return = new Vector!(Size, Type, UseSse)(NULL, NULL);
         }
         else static if (Size == 3)
         {
            Vector!(Size, Type, UseSse) Return = new Vector!(Size, Type, UseSse)(NULL, NULL, NULL);
         }

         static if (op == "+")
         {
            Return.Data[0] = this.Data[0] + Rhs.Data[0];
            Return.Data[1] = this.Data[1] + Rhs.Data[1];

            static if (Size >= 3)
            {
               Return.Data[2] = this.Data[2] + Rhs.Data[2];
            }

            return Return;
         }
         else static if (op == "-")
         {
            Return.Data[0] = this.Data[0] - Rhs.Data[0];
            Return.Data[1] = this.Data[1] - Rhs.Data[1];

            static if (Size >= 3)
            {
               Return.Data[2] = this.Data[2] - Rhs.Data[2];
            }

            return Return;
         }
         else
         {
            static assert(0, "Operator "~op~" not implemented");
         }
      }

      static if (Size == 2)
      {
         /** \brief rotates the Vector 90 degrees
          *
          * makes only sense with directions
          *
          * \return ...
          */
         final public Vector!(Size, Type, UseSse) flip90Degree()
         {
            return new Vector!(Size, Type, UseSse)(-this.Data[1], this.Data[0]);
         }
      }

      final public void multiply(Vector!(Size, Type, UseSse) Other)
      {
         this.Data[0] *= Other.Data[0];
         this.Data[1] *= Other.Data[1];

         static if ( Size == 3 )
         {
            this.Data[2] *= Other.Data[2];
         }
      }

      // NOTE< maybe SSE this? >
      protected Type Data[Size];
   }
}