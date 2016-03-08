
import std.math : sqrt;

template ResizableNDArray(uint Dimensions, Type)
{
   class ResizableNDArray
   {
      private uint Size[Dimensions];
      private Type []Data;

      final private bool checkIndex(uint [Dimensions]Indices)
      {
         foreach( i; 0..Dimensions )
         {
            if( Indices[i] >= this.Size[i] )
            {
               return false;
            }
         }

         return true;
      }

      final private ref Type accessor(uint [Dimensions]Coordinate)
      {
         static if( Dimensions == 2 )
         {
            return this.Data[Coordinate[0] + Coordinate[1] *this.Size[0]];
         }
         else if( Dimensions == 3 )
         {
            return this.Data[Coordinate[0] + Coordinate[1] *this.Size[0] + Coordinate[2]*this.Size[0]*this.Size[1]];
         }
         else
         {
            static assert(false, "Case for more than 3 Dimensions or for one Dimension is not implemented!");
         }

         //this.Data[X + Y * this.Size[0]] = Value;
         
      }

      final public void setAt(uint [Dimensions]Coordinate, Type Value, out bool Success)
      {
         Success = false;

         if( !this.checkIndex(Coordinate) )
         {
            return;
         }

         this.accessor(Coordinate) = Value;

         //this.Data[X + Y * this.Size[0]] = Value;
         Success = true;
      }
      
      final public Type getAt(uint [Dimensions]Coordinate, out bool Success)
      {
         Success = false;

         if( !this.checkIndex(Coordinate))
         {
            return Type.init;
         }

         Success = true;

         //return this.Content[X + Y * this.Size[0]];
         return this.accessor(Coordinate);
      }

      final public void resize(uint [Dimensions]NewSize)
      {
         this.Size = NewSize;

         this.Data.length = 0;

         static if( Dimensions == 2 )
         {
            this.Data.length = NewSize[0]*NewSize[1];
         }
         else if( Dimensions == 3 )
         {
            this.Data.length = NewSize[0]*NewSize[1]*NewSize[2];
         }
      }

      final public uint[Dimensions] getSize()
      {
         return this.Size;
      }
   }
}

/** \brief More usable Vector special for 3d stuff
 *
 */
class Vector3f
{
   // NOTE< maybe SSE this? >
   private float Data[3];

   this(float X, float Y, float Z)
   {
      this.X = X;
      this.Y = Y; 
      this.Z = Z;
   }
   
   @property float X()
   {
      return this.Data[0];
   }

   @property float X(float Value)
   {
      return this.Data[0] = Value;
   }

   @property float Y()
   {
      return this.Data[1];
   }

   @property float Y(float Value)
   {
      return this.Data[1] = Value;
   }

   @property float Z()
   {
      return this.Data[2];
   }

   @property float Z(float Value)
   {
      return this.Data[2] = Value;
   }

   final public Vector3f opBinary(string op)(Vector3f Rhs)
   {
      Vector3f Return = new Vector3f(0.0f, 0.0f, 0.0f);

      static if (op == "+")
      {
         Return.Data[0] = this.Data[0] + Rhs.Data[0];
         Return.Data[1] = this.Data[1] + Rhs.Data[1];
         Return.Data[2] = this.Data[2] + Rhs.Data[2];

         return Return;
      }
      else static if (op == "-")
      {
         Return.Data[0] = this.Data[0] - Rhs.Data[0];
         Return.Data[1] = this.Data[1] - Rhs.Data[1];
         Return.Data[2] = this.Data[2] - Rhs.Data[2];

         return Return;
      }
      else
      {
         static assert(0, "Operator "~op~" not implemented");
      }
   }

   // TOUML
   // TODOCU
   final public Vector3f scale(float Scale)
   {
      Vector3f Return = new Vector3f(0.0f, 0.0f, 0.0f);

      Return.Data[0] = this.Data[0] * Scale;
      Return.Data[1] = this.Data[1] * Scale;
      Return.Data[2] = this.Data[2] * Scale;

      return Return;
   }

   // TOUML
   /** \brief returns the normalized Vector
    *
    * \return ...
    */
   final public Vector3f normalized()
   {
      float Length, RLength;

      Length = this.getLength();

      // we do it to avliad divide by zero
      if( Length == 0.0f )
      {
         Length = 1.0f;
      }

      RLength = 1.0f/Length;

      return this.scale(RLength);
   }

   /** \brief calclates dot product between two vectors
    *
    * \param Other ...
    */
   final float dot(Vector3f Other)
   {
      return this.Data[0]*Other.Data[0] + this.Data[1]*Other.Data[1] + this.Data[2]*Other.Data[2];
   }

   // TOUML
   /** \brief returns the length
    *
    * \return ...
    */
   final public float getLength()
   {
      return sqrt(this.Data[0]*this.Data[0] + this.Data[1]*this.Data[1] + this.Data[2]*this.Data[2]);
   }

   // TOUML
   /** \brief return the squaredLength
    *
    * \return ...
    */
   final public float getSquaredLength()
   {
      return this.Data[0]*this.Data[0] + this.Data[1]*this.Data[1] + this.Data[2]*this.Data[2];
   }

   // TOUML
   /** \brief clones the Vector
    *
    * \return a clone with the same values
    */
   final public Vector3f clone()
   {
      return new Vector3f(this.X, this.Y, this.Z);
   }

   final public void debugIt()
   {
      writeln(this.X, ",", this.Y, ",", this.Z);
   }
}

// see https://www.cs.drexel.edu/~david/Classes/CS430/Lectures/L-09_BSplines_NURBS.pdf
struct NurbsHelper
{
   // Bernstein polynom
   static private float B(uint K, uint D, float T, ref float []Knots)
   {
      if( D == 0 )
      {
         if( Knots[K] <= T && T < Knots[K+1] )
         {
            return 1.0f;
         }
         return 0.0f;
      }
      else
      {
         float PartA, PartB;

         PartA = (T - Knots[K]) / (Knots[K+D] - Knots[K]);
         PartB = (Knots[K+D+1] - T) / (Knots[K+D+1] - Knots[K+1]);

         return PartA * B(K, D-1, T, Knots) + PartB * B(K+1, D-1, T, Knots);
      }
   }

   // for testing public
   // old code
   /*
   static public Vector3f C(float U, ref float []Knots, Vector3f []ControlPoints, float []Weights, uint Degree)
   {
      float Divisor;
      Vector3f Result;

      Result = new Vector3f(0.0f, 0.0f, 0.0f);

      Divisor = 0.0f;

      foreach( i; 0..Weights.length )
      {
         Divisor += Weights[i]*B(i, Degree, U, Knots);
      }

      foreach( i; 0..Weights.length )
      {
         Result = Result + ControlPoints[i].scale( Weights[i]*B(i, Degree, U, Knots) );
      }

      Result.scale(1.0f / Divisor);

      return Result;
   }
   */

   static public Vector3f OneDimension(float U, ref float []Knots, Vector3f []ControlPoints, float []Weights, uint Degree)
   {
      Vector3f Result;

      Result = new Vector3f(0.0f, 0.0f, 0.0f);
      
      foreach( i; 0..Weights.length )
      {
         Result = Result + ControlPoints[i].scale( R(U, i, Knots, Weights, Degree) );
      }

      return Result;
   }

   // for testing public
   static public Vector3f TwoDimensions(float U, float V, uint k, uint l, uint N, uint M, ref float []Knots, ResizableNDArray!(2, Vector3f) Controlpoints, ResizableNDArray!(2, float) Weights)
   {
      Vector3f Result;

      Result = new Vector3f(0.0f, 0.0f, 0.0f);

      foreach( j; 0..l )
      {
         foreach( i; 0..k )
         {
            bool CalleeSuccess;

            Result = Result + Controlpoints.getAt([i, j], CalleeSuccess).scale(R2d(U, V, i, j, N, M, Knots, Weights)) ;
            assert(CalleeSuccess);
         }
      }

      return Result;
   }

   /** \brief Rational basis function for two dimensions
    * 
    * 
    * \param U the U coordinate
    * \param V the V coordinate
    * TODO
    */
   static private float R2d(float U, float V, uint I, uint J, uint N, uint M, float []Knots, ResizableNDArray!(2, float) Weights )
   {
      uint[2] Dimensions;
      float Divisor, Dividend;
      bool CalleeSuccess;

      Dimensions = Weights.getSize();

      Divisor = 0.0f;
      // NOTE< maybe some dimensions here are twisted >

      foreach( P; 0..Dimensions[0] )
      {
         foreach( Q; 0..Dimensions[1] )
         {
            Divisor += (B(P, N, U, Knots) * B(Q, M, V, Knots) * Weights.getAt([P, Q], CalleeSuccess));
            assert(CalleeSuccess);
         }
      }

      Dividend = B(I, N, U, Knots) * B(J, M, V, Knots) * Weights.getAt([I, J], CalleeSuccess);
      assert(CalleeSuccess);

      return Dividend / Divisor;
   }
   
   // I notation is from wikipedia
   // N notation from wikipedia is degree
   // http://en.wikipedia.org/wiki/Non-uniform_rational_B-spline
   static private float R(float U, uint I, ref float []Knots, float []Weights, uint Degree)
   {
      float Divisor;

      Divisor = 0.0f;

      foreach( i; 0..Weights.length )
      {
         Divisor += Weights[i]*B(i, Degree, U, Knots);
      }

      return (Weights[I]*B(I, Degree, U, Knots)) / Divisor;
   }
}

import std.stdio : writeln;

void main()
{
   float []MyTValues = [0.0f, 1.0f, 2.0f, 3.0f, 4.0f, 5.0f, 6.0f, 7.0f];
   uint Degree = 1;

   float []Weights = [1.0f, 1.0f, 1.0f, 1.0f, 1.0f];

   Vector3f []ControlPoints = [
      new Vector3f(0.0f, 0.0f, 0.0f),
      new Vector3f(2.0f, 5.0f, 0.0f),
      new Vector3f(4.0f, -4.0f, 0.0f),
      new Vector3f(7.0f, 3.0f, 0.0f),
      new Vector3f(8.0f, 2.0f, 0.0f)
   ];

   //Vector3f Y = X.C(0.0f, MyTValues, ControlPoints, Weights, Degree);

   foreach( i; 0..51)
   {
      float T;
      Vector3f Position;

      T = 1.0f + cast(float)i * 0.02f * (5.0f - 1.0f);

      //writeln(X.B(2, 4, T, MyTValues));

      Position = NurbsHelper.OneDimension(T, MyTValues, ControlPoints, Weights, Degree);

      writeln("result  ", Position.X, ",", Position.Y, ",", Position.Z);
   }

   ResizableNDArray!(2, float) NDArray;

   NDArray = new ResizableNDArray!(2, float)();
   NDArray.resize([5, 6]);

   bool CalleeSuccess;

   NDArray.getAt([3, 2], CalleeSuccess);
}