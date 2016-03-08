import std.algorithm : min, max;

// for debugging
import std.stdio : writeln, write;

class EdgeTableEdge
{   
   this(int YMin, int YMax, int XMin, float MDiv1)
   {
      this.YMin  = YMin;
      this.YMax  = YMax;
      this.XMin  = XMin;
      this.MDiv1 = MDiv1;
   }

   public int YMin;
   public int YMax;

   public int XMin;

   public float MDiv1;

   public int TempX;
}

class Edge
{
   this(int X0, int Y0, int X1, int Y1)
   {
      this.X0 = X0;
      this.Y0 = Y0;
      this.X1 = X1;
      this.Y1 = Y1;
   }

   public int X0, Y0, X1, Y1;
}

// coped from me
/** \brief removes element at index Index from Array
 *
 * \param Array is the Array
 * \param Index the index from that a Element 
 * \return Array without Elment
 */
Type[] removeAt(Type)(Type[] Array, uint Index)
{
   Type[] Output;
   uint i;

   if( Array.length == 0 )
   {
      // error
      return [];
   }

   if( Array.length == 1 )
   {
      return [];
   }

   Output = Array;

   for( i = Index; i < Array.length-1; i++ )
   {
      Output[i] = Output[i+1];
   }

   Output.length -= 1;

   return Output;
}

void exchange(ref int A, ref int B)
{
   int Temp;

   Temp = A;
   A = B;
   B = Temp;
}

class Rasterizer
{
   final public void setBitmapSize(uint Width, uint Height)
   {
      this.BitmapWidth = Width;
      this.BitmapHeight = Height;

      this.Bitmap.length = 0;
      this.Bitmap.length = Width*Height;
   }

   final public void rasterize()
   {
      this.calcEdgeTable();
      this.YYY();
   }

   final private void YYY()
   {
      EdgeTableEdge[] ActualEdgeTable;

      this.CurrentY = 2000000; // TODO Maximal value of int's

      foreach( CurrentEdge; this.EdgeTable )
      {
         this.CurrentY = min(CurrentEdge.YMin, this.CurrentY);
      }

      for(;;)
      {
         if( ActualEdgeTable.length == 0 && this.EdgeTable.length == 0 )
         {
            break;
         }

         uint i;

         for( i = 0; i < this.EdgeTable.length; i++ )
         {
            if( this.EdgeTable[i].YMin == this.CurrentY )
            {
               ActualEdgeTable ~= this.EdgeTable[i];

               this.EdgeTable = removeAt(this.EdgeTable, i);

               i--;
            }
         }

         for( i = 0; i < ActualEdgeTable.length; i++ )
         {
            if( ActualEdgeTable[i].YMax == this.CurrentY )
            {
               ActualEdgeTable = removeAt(ActualEdgeTable, i);
               i--;
            }
         }

         // calculate TempX

         /*
         foreach( ref CurrentEdge; ActualEdgeTable )
         {
            CurrentEdge.TempX = cast(int)( CurrentEdge.MDiv1 * cast(float)this.CurrentY );
         }
         */

         for( i = 0; i < ActualEdgeTable.length; i++ )
         {
            int StartX;

            StartX = ActualEdgeTable[i].XMin;

            if(  ActualEdgeTable[i].MDiv1 > 0.0f )
            {
               ActualEdgeTable[i].TempX = StartX + cast(int)( ActualEdgeTable[i].MDiv1 * cast(float)(ActualEdgeTable[i].YMax - CurrentY) );
            }
            else
            {
               ActualEdgeTable[i].TempX = StartX + cast(int)( ActualEdgeTable[i].MDiv1 * cast(float)(ActualEdgeTable[i].YMin - CurrentY) );
            }
         }

         ActualEdgeTable = Rasterizer.sortAfterX(ActualEdgeTable);

         this.fillScanlines(ActualEdgeTable);

         this.CurrentY++;
      }
   }

   final private void fillScanlines(EdgeTableEdge []Table)
   {
      if( Table.length == 1 )
      {
         // should never happen

         return;
      }
      else if( (Table.length % 2) == 0 )
      {
         uint i;

         for( i = 0; i < Table.length; i+=2 )
         {
            if( Table[i].TempX < Table[i + 1].TempX )
            {
               this.drawScanline(Table[i].TempX, Table[i + 1].TempX);
            }
         }
      }
      else
      {
         // should never happen

         // TODO
      }
   }

   final private void drawScanline(int XStart, int XEnd)
   in
   {
      assert(XStart < XEnd);
   }
   body
   {
      assert(this.CurrentY < this.BitmapHeight);

      foreach( CurrentX; XStart..min(XEnd, this.BitmapWidth) )
      {
         this.Bitmap[CurrentX + this.CurrentY * this.BitmapWidth] = true;
      }
   }

   final private void calcEdgeTable()
   {
      this.EdgeTable.length = 0;

      foreach( CurrentEdge; this.Edges )
      {
         int XMin, YMin, XMax, YMax;
         float OneDivM;
         float MTemp;

         int Y0, Y1;
         int X0, X1;

         X0 = CurrentEdge.X0;
         Y0 = CurrentEdge.Y0;
         X1 = CurrentEdge.X1;
         Y1 = CurrentEdge.Y1;

         if( Y0 == Y1 )
         {
            // horizontal line, skip
            continue;
         }
         if( Y0 > Y1 )
         {
            exchange(Y0, Y1);
            exchange(X0, X1);
         }

         XMin = min(X0, X1);
         XMax = max(X0, X1);

         YMin = Y0;//min(Y0, Y1); // old
         YMax = Y1;//max(Y0, Y1); // old

         MTemp = cast(float)X0 - cast(float)X1;

         // NOTE< div by zero can't happen >
         OneDivM = MTemp / (cast(float)YMax - cast(float)YMin);

         writeln("M ", OneDivM);

         this.EdgeTable ~= new EdgeTableEdge(YMin, YMax, XMin, OneDivM);
      }
   }

   private final static EdgeTableEdge []sortAfterX(EdgeTableEdge []Table)
   {
      // min sort

      uint i;

      for( i = 0; i < Table.length; i++ )
      {
         uint MinIndex = i;
         int MinX = Table[i].TempX;
         uint j;

         for( j = i + 1; j < Table.length; j++ )
         {
            if( Table[j].TempX < MinX )
            {
               MinX = Table[j].TempX;
               MinIndex = j;
            }
         }

         // swap
         EdgeTableEdge TempEdge;

         TempEdge = Table[i];
         Table[i] = Table[MinIndex];
         Table[MinIndex] = TempEdge;
      }

      return Table;
   }

   public Edge []Edges;

   private EdgeTableEdge []EdgeTable;

   private int CurrentY;

   public bool []Bitmap;
   private uint BitmapWidth, BitmapHeight;
}

void main()
{
   Rasterizer OfRasterizer;

   OfRasterizer = new Rasterizer();
   OfRasterizer.setBitmapSize(14, 14);

   OfRasterizer.Edges ~= new Edge(7, 1,  2, 3);
   //OfRasterizer.Edges ~= new Edge(7, 1,  13, 5);
   OfRasterizer.Edges ~= new Edge(13, 5,  7, 1);
   OfRasterizer.Edges ~= new Edge(2, 3, 2, 9);
   OfRasterizer.Edges ~= new Edge(2, 9, 7, 7);
   OfRasterizer.Edges ~= new Edge(7, 7, 13, 13);
   OfRasterizer.Edges ~= new Edge(13, 5, 13, 13);

   //OfRasterizer.Edges ~= new Edge(5, 1,  9, 7);
   //OfRasterizer.Edges ~= new Edge(1, 5,  8, 8);

   OfRasterizer.rasterize();

   // TODO< display >

   for( uint Y = 0; Y < 14; Y++ )
   {
      for( uint X = 0; X < 14; X++ )
      {
         if( OfRasterizer.Bitmap[X + Y * 14] )
         {
            write("X");
         }
         else
         {
            write(" ");
         }
      }
      writeln("");
   }
}
