// TODO< get rid of this code :/ >

module Client.GuiAbstraction.GuiDrawer;

import std.string : stringIndexOf = indexOf;

import Engine.Common.Vector;
import Client.GuiAbstraction.Color;

import Client.Engine3d.Engine3d;
import Client.Texture;
import Client.opengl.gl;
import Engine.Common.WideString;

import std.math : sqrt, acos, sin;

import Client.GuiAbstraction.ClosedLoop;

import Client.GuiAbstraction.FreetypeRenderer;

import Client.Engine3d.Buffer;
import Client.Engine3d.ShaderProgram;
import Engine.Common.Matrix44;

// for debugging
import std.stdio : writeln;

/** \brief Abstraction for drawing stuff for the Gui
 *
 */
class GuiDrawer
{
   this()
   {
      this.SignBuffer = new Buffer();
      this.SingleLineBuffer = new Buffer();
      this.MultiLineBuffer = new Buffer();
   }

   final public bool configure(float ScreenAspectRatio, ShaderProgram SignProgram, ShaderProgram LineProgram, ShaderProgram MultilineProgram)
   in
   {
      assert(SignProgram !is null);
      assert(LineProgram !is null);
      assert(MultilineProgram !is null);
   }
   body
   {
      Buffer.EnumConfigureResult ConfigureResult;
      bool CalleeSuccess;

      this.SignBuffer.configure([Buffer.EnumDatatype.VERTEXPOSITION, Buffer.EnumDatatype.DATA2D], ConfigureResult);
      if( ConfigureResult != Buffer.EnumConfigureResult.SUCCESS )
      {
         return false;
      }

      this.SignBuffer.setVerticesCount(4);

      this.SignBuffer.setPolygonCount(2, CalleeSuccess);
      if( !CalleeSuccess )
      {
         return false;
      }

      this.SignBuffer.setVertexIndex(0, 0);
      this.SignBuffer.setVertexIndex(1, 1);
      this.SignBuffer.setVertexIndex(2, 2);

      this.SignBuffer.setVertexIndex(3, 0);
      this.SignBuffer.setVertexIndex(4, 2);
      this.SignBuffer.setVertexIndex(5, 3);




      this.SingleLineBuffer.configure([Buffer.EnumDatatype.VERTEXPOSITION], ConfigureResult);
      if( ConfigureResult != Buffer.EnumConfigureResult.SUCCESS )
      {
         return false;
      }

      this.SingleLineBuffer.setVerticesCount(4);

      this.SingleLineBuffer.setPolygonCount(2, CalleeSuccess);
      if( !CalleeSuccess )
      {
         return false;
      }

      this.SingleLineBuffer.setVertexIndex(0, 0);
      this.SingleLineBuffer.setVertexIndex(1, 1);
      this.SingleLineBuffer.setVertexIndex(2, 2);

      this.SingleLineBuffer.setVertexIndex(3, 0);
      this.SingleLineBuffer.setVertexIndex(4, 2);
      this.SingleLineBuffer.setVertexIndex(5, 3);





      this.MultiLineBuffer.configure([Buffer.EnumDatatype.VERTEXPOSITION, Buffer.EnumDatatype.DATA3D], ConfigureResult);
      if( ConfigureResult != Buffer.EnumConfigureResult.SUCCESS )
      {
         return false;
      }




      // matrix calculation

      this.ModelViewMatrix = Matrix44.createIdentity();

      this.ModelViewMatrix.mul(Matrix44.createTranslation(0.0f, /*ScreenAspectRatio*/1.0f, 0.0f));
      this.ModelViewMatrix.mul(Matrix44.createScale(1.0f, -1.0f, 0.0f));

      // misc

      this.SignProgram = SignProgram;
      this.LineProgram = LineProgram;
      this.MultilineProgram = MultilineProgram;

      return true;
   }

   // TODO< build in initialize and deinitialize?
   final public void setFreetypeRenderer(FreetypeRenderer Freetype)
   in
   {
      assert(Freetype !is null);
   }
   body
   {
      this.Freetype = Freetype;
   }

   // TOUML
   /** \brief returns the width of the Text
    *
    * is a helper function which draw nothing
    *
    * \param Text ...
    * \param SignScale base size of the signs
    * \return ...
    */
   final public float getTextWidth(WideString Text, Vector2f SignScale)
   in
   {
      assert(Text !is null);
      assert(SignScale !is null);

      assert(SignScale.X > 0.0f);
      assert(SignScale.Y > 0.0f);
   }
   body
   {
      float SumWidth;

      SumWidth = 0.0f;

      foreach(uint Sign; Text.getSigns())
      {
         bool CalleeSuccess;
         float AdvanceX;
         float TopX, TopY;
         float BottomX, BottomY;
         uint TopSpacing;

         this.Freetype.getBitmapCoordinatesFor(Sign, TopSpacing, AdvanceX, TopX, TopY, BottomX, BottomY, CalleeSuccess);

         if( !CalleeSuccess )
         {
            // error, ignore

            continue;
         }

         SumWidth += (AdvanceX * SignScale.X);
      }

      return SumWidth;
   }

   // TODO< doc >
   // gurantuees that the length of the returned string is smaller than MaxWidth

   // TODO< getTextWidth is a subset of this functionality, factor out
   final public void getTextWhichFitsWidth(WideString String, Vector2f SignScale, float MaxWidth, string EndingWith)
   in
   {
      assert(String !is null);
      assert(SignScale !is null);

      assert(MaxWidth > 0.0f);
      
      assert(SignScale.X > 0.0f);
      assert(SignScale.Y > 0.0f);
   }
   body
   {
      float EndingWithWidth;
      float CurrentWidth;
      uint TextIndex;
      float []SignWidthArray;
      float []SignWithEndingArray;

      scope(exit)
      {
         // check for length gurantueee

         float RealLength;

         RealLength = this.getTextWidth(String, SignScale);

         assert(RealLength < MaxWidth);
      }

      EndingWithWidth = 0.0f;

      if( true )
      {
         foreach( Sign; EndingWith )
         {
            bool CalleeSuccess;
            float AdvanceX;
            float TopX, TopY;
            float BottomX, BottomY;
            uint TopSpacing;

            this.Freetype.getBitmapCoordinatesFor(cast(uint)Sign, TopSpacing, AdvanceX, TopX, TopY, BottomX, BottomY, CalleeSuccess);

            if( !CalleeSuccess )
            {
               // error, ignore

               continue;
            }

            EndingWithWidth += (AdvanceX * SignScale.X);
         }
      }

      CurrentWidth = 0.0f;

      foreach( Sign; String.getSigns() )
      {
         bool CalleeSuccess;
         float AdvanceX;
         float TopX, TopY;
         float BottomX, BottomY;
         uint TopSpacing;

         this.Freetype.getBitmapCoordinatesFor(Sign, TopSpacing, AdvanceX, TopX, TopY, BottomX, BottomY, CalleeSuccess);

         if( !CalleeSuccess )
         {
            // error, ignore

            continue;
         }

         CurrentWidth += (AdvanceX * SignScale.X);

         SignWidthArray ~= CurrentWidth;
         SignWithEndingArray ~= (CurrentWidth + EndingWithWidth);
      }

      if( String.getLength() == 0 )
      {
         return;
      }

      uint CurrentI;

      for( CurrentI = 0; CurrentI < String.getLength(); CurrentI++ )
      {
         if( SignWithEndingArray[CurrentI] > MaxWidth )
         {
            if( CurrentI == 0 )
            {
               String.minimizeLengthTo(0);

               return;
            }
            else
            {
               String.minimizeLengthTo(CurrentI-1);
               String.appendDString(EndingWith);

               return;
            }
         }
      }
   }
   
   // TOUML change
   // TODO< add success ? >
   /** \brief Draws Text
    *
    * \brief Text ...
    * \brief Position ...
    * \brief SignScale Scale of one Sign
    * \brief ColorObject is the Color of the Signs
    */
   final public void drawText(WideString Text, Vector2f Position, Vector2f SignScale, Color ColorObject)
   in
   {
      assert(Text !is null);
      assert(Position !is null);
      assert(SignScale !is null);

      assert(SignScale.X > 0.0f);
      assert(SignScale.Y > 0.0f);
   }
   body
   {
      // pixel to texture
      float pixToTex(uint Pixel)
      {
         return cast(float)Pixel * (1.0f/256.0f);
      }

      bool CalleeSuccess;
      Texture TextureObj;
      float PosX, PosY;
      float TextColorR, TextColorG, TextColorB;
      Buffer.EnumBuildBufferResult BuildBufferResult;

      assert(!(this.Freetype is null), "this.Freetype was null!");

      uint MatrixModelViewLocation = this.SignProgram.getUniformLocation("modelViewMatrix");
      uint MatrixProjectionLocation = this.SignProgram.getUniformLocation("projectionMatrix");

      TextureObj = this.Engine.getTextureByName("Signs", CalleeSuccess);
      if( !CalleeSuccess )
      {
         // return an error?
         return;
      }

      PosX = Position.X;
      PosY = Position.Y;

      //Color DebugColor;
      //DebugColor.setRgb(1.0f, 0.0f, 0.0f);
      //this.drawLine(Position.X, Position.Y, Position.X + 0.5f, Position.Y, 0.015f, DebugColor);

      ColorObject.getRgb(TextColorR, TextColorG, TextColorB);

      //glColor3f(TextColorR, TextColorG, TextColorB);
      
      // NOTE< depth buffer is allready disabled! >
      glEnable(GL_BLEND);
      glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); 
      
      glBindTexture(GL_TEXTURE_2D, TextureObj.Id);

      float FixedSignHeightAsFloat;

      FixedSignHeightAsFloat = cast(float)this.Freetype.getFixedSignHeight();

      foreach( Sign; Text.getSigns() )
      {
         float AdvanceX;
         float TopX, TopY;
         float BottomX, BottomY;
         uint TopSpacing;

         this.Freetype.getBitmapCoordinatesFor(Sign, TopSpacing, AdvanceX, TopX, TopY, BottomX, BottomY, CalleeSuccess);

         if( !CalleeSuccess )
         {
            // we do it because we called glBegin() and other stuff
            continue;
         }

         float RelativeTopSpacing = cast(float)TopSpacing / FixedSignHeightAsFloat;

         float SignSizeX = AdvanceX * SignScale.X;

         this.SignBuffer.setData(0, 0, new Vector3f(TopX, BottomY, 0.0f));
         this.SignBuffer.setPosition(0, new Vector3f(PosX, PosY+SignScale.Y    - RelativeTopSpacing*SignScale.Y, 0.0f));

         this.SignBuffer.setData(1, 0, new Vector3f(TopX, TopY, 0.0f));
         this.SignBuffer.setPosition(1, new Vector3f(PosX, PosY                - RelativeTopSpacing*SignScale.Y, 0.0f));

         this.SignBuffer.setData(2, 0, new Vector3f(BottomX, TopY, 0.0f));
         this.SignBuffer.setPosition(2, new Vector3f(PosX+SignSizeX, PosY - RelativeTopSpacing*SignScale.Y, 0.0f));

         this.SignBuffer.setData(3, 0, new Vector3f(BottomX, BottomY, 0.0f));
         this.SignBuffer.setPosition(3, new Vector3f(PosX+SignSizeX, PosY+SignScale.Y  - RelativeTopSpacing*SignScale.Y, 0.0f));

         this.SignBuffer.toBuiltState(BuildBufferResult);
         if( BuildBufferResult != Buffer.EnumBuildBufferResult.SUCCESS )
         {
            // failture, exit quitly
            return;
         }

         this.SignProgram.useThis();

         // TODO< GC could move the pointer >
         ShaderProgram.uniformMatrix(MatrixModelViewLocation, this.ModelViewMatrix.transpose().getRawData().ptr);

         // TODO< GC could move the pointer >
         ShaderProgram.uniformMatrix(MatrixProjectionLocation, this.Engine.getOrthoProjectionMatrix().transpose().getRawData().ptr);

         this.SignBuffer.bindThis();
         this.SignBuffer.drawThis();
         Buffer.bindNone();

         this.SignBuffer.toModifyState(CalleeSuccess);
         if( !CalleeSuccess )
         {
            // failture, exit quitly
            return;
         }

         PosX += SignSizeX;
      }

      //Buffer.bindNone();

      ShaderProgram.useNone(); // NOTE< not possible with OpenGL 3.x or 4.x
      
      glDisable(GL_BLEND);

      // disable texture
      // NOTE< maybe invalid with openGL 3.x or 4.x >
      glBindTexture(GL_TEXTURE_2D, 0);
   }

   // TOUML
   final public void drawBox(Vector2f Position, Vector2f Size, float Width, Color ColorObject)
   {
      this.drawLine(Position.X + Width               , Position.Y                              , Position.X + Width             , Position.Y + Size.Y               , Width, ColorObject);
      this.drawLine(Position.X                              , Position.Y - Width               , Position.X + Size.X               , Position.Y- Width         , Width, ColorObject);
      this.drawLine(Position.X                              , Position.Y + Size.Y + Width, Position.X + Size.X               , Position.Y + Size.Y + Width, Width, ColorObject);
      this.drawLine(Position.X - Width + Size.X, Position.Y                              , Position.X - Width + Size.X             , Position.Y + Size.Y               , Width, ColorObject);
   }

   // TODO< build wrapper method around this to draw dotted lines or not ... with all parameters and parameter wrappers and everything >
   // TODO< add 2x2 matrix for the transformations and remove offset >
   // TOUML
   /** \brief draws a closed loop as connected lines
    *
    * \param Loop the Shape that should be drawn
    * \param Offset this is added to all Positions
    * \param ColorInner Inner color
    * \param ColorOuter Outer color
    * \param Transparency ...
    * \param Width (Absolute) Width
    * \param Success is true on Success
    */
   /* NOTE<
    * the algorithm to add the vertices and polygons to the buffer is taken straigth from the OpenGL 2.X implementation
    * this means that we need far more vertices than needed because it is duplicated
    * >
    */
   final public void drawClosedLines(ClosedLoop Loop, Vector2f Offset, Color ColorInner, Color ColorOuter, float Transparency, float Width, out bool Success)
   {
      bool CalleeSuccess;
      uint IndexLast;
      Vector2f FlipedBefore; // is the normal of the 90 degree fliped direction of the line before

      float ColorInnerR, ColorInnerG, ColorInnerB;
      float ColorOuterR, ColorOuterG, ColorOuterB;

      // directions before and after the point
      Vector2f DirBefore, DirAfter;

      // Averaged Direction
      Vector2f DirAvg;

      Vector2f FlipedAfter;

      // experimental
      float AngleBefore, AngleAfter;

      uint CurrentVertexIndex;
      uint CurrentPolygonIndex;

      uint MatrixModelViewLocation;
      uint MatrixProjectionLocation;

      Buffer.EnumBuildBufferResult BuildBufferResult;

      void nestedDrawLine(Vector2f PosBegin, Vector2f NormalBefore, float MulWidthBefore, Vector2f PosEnd, Vector2f NormalAfter, float MulWidthAfter)
      {
         float WidthBefore, WidthAfter;

         WidthBefore = Width * MulWidthBefore * 0.2f;
         WidthAfter  = Width * MulWidthAfter  * 0.2f;


         this.MultiLineBuffer.setData    (CurrentVertexIndex    , 0, new Vector3f(ColorInnerR, ColorInnerG, ColorInnerB));
         this.MultiLineBuffer.setPosition(CurrentVertexIndex    , new Vector3f(PosBegin.X + Offset.X + NormalBefore.X * WidthBefore, PosBegin.Y + Offset.Y + NormalBefore.Y * WidthBefore, 0.0f));

         this.MultiLineBuffer.setData    (CurrentVertexIndex + 1, 0, new Vector3f(ColorOuterR, ColorOuterG, ColorOuterB));
         this.MultiLineBuffer.setPosition(CurrentVertexIndex + 1, new Vector3f(PosBegin.X + Offset.X - NormalBefore.X * WidthBefore, PosBegin.Y + Offset.Y - NormalBefore.Y * WidthBefore, 0.0f));

         this.MultiLineBuffer.setData    (CurrentVertexIndex + 2, 0, new Vector3f(ColorOuterR, ColorOuterG, ColorOuterB));
         this.MultiLineBuffer.setPosition(CurrentVertexIndex + 2, new Vector3f(PosEnd.X + Offset.X - NormalAfter.X    * WidthAfter , PosEnd.Y + Offset.Y - NormalAfter.Y    * WidthAfter, 0.0f));
         
         this.MultiLineBuffer.setData    (CurrentVertexIndex + 3, 0, new Vector3f(ColorInnerR, ColorInnerG, ColorInnerB));
         this.MultiLineBuffer.setPosition(CurrentVertexIndex + 3, new Vector3f(PosEnd.X + Offset.X + NormalAfter.X    * WidthAfter , PosEnd.Y + Offset.Y + NormalAfter.Y    * WidthAfter, 0.0f));

         this.MultiLineBuffer.setVertexIndex(CurrentPolygonIndex*3  , CurrentVertexIndex  );
         this.MultiLineBuffer.setVertexIndex(CurrentPolygonIndex*3+1, CurrentVertexIndex+1);
         this.MultiLineBuffer.setVertexIndex(CurrentPolygonIndex*3+2, CurrentVertexIndex+2);

         this.MultiLineBuffer.setVertexIndex((CurrentPolygonIndex+1)*3  , CurrentVertexIndex);
         this.MultiLineBuffer.setVertexIndex((CurrentPolygonIndex+1)*3+1, CurrentVertexIndex+2);
         this.MultiLineBuffer.setVertexIndex((CurrentPolygonIndex+1)*3+2, CurrentVertexIndex+3);

         CurrentVertexIndex += 4;
         CurrentPolygonIndex += 2;
      }

      Success = false;

      // we need more than 2 points
      if( Loop.Points.length < 3 )
      {
         return;
      }



      MatrixModelViewLocation = this.MultilineProgram.getUniformLocation("modelViewMatrix");
      MatrixProjectionLocation = this.MultilineProgram.getUniformLocation("projectionMatrix");


      this.MultiLineBuffer.setVerticesCount(Loop.Points.length * 4);

      this.MultiLineBuffer.setPolygonCount(Loop.Points.length * 2, CalleeSuccess);
      if( !CalleeSuccess )
      {
         return;
      }

      CurrentVertexIndex = 0;
      CurrentPolygonIndex = 0;

      ColorInner.getRgb(ColorInnerR, ColorInnerG, ColorInnerB);
      ColorOuter.getRgb(ColorOuterR, ColorOuterG, ColorOuterB);

      IndexLast = Loop.Points.length-1;

      ///////
      // draw line from last Point to first
      ///////

      DirBefore = (Loop.Points[0] - Loop.Points[IndexLast]).normalized();
      DirAfter  = (Loop.Points[1] - Loop.Points[0        ]).normalized();

      AngleBefore = acos(DirBefore.dot(DirAfter.scale(-1.0f)));

      DirAvg = (DirBefore + DirAfter).normalized();

      /* NOTE< warning, confusion ahead
       *       the meaning of the variables "FlipedBefore" and "FlipedAfter" are twisted, so that we don'T have here to switch them
       * >
       */
      FlipedBefore = DirAvg.flip90Degree();

      DirBefore = (Loop.Points[IndexLast] - Loop.Points[IndexLast-1]).normalized();
      DirAfter  = (Loop.Points[0        ] - Loop.Points[IndexLast  ]).normalized();

      AngleAfter = acos(DirBefore.dot(DirAfter.scale(-1.0f)));

      DirAvg = (DirBefore + DirAfter).normalized();

      FlipedAfter = DirAvg.flip90Degree();

      // OpenGL
      nestedDrawLine(Loop.Points[IndexLast], FlipedAfter, 1.0f/sin(AngleAfter*0.5f), Loop.Points[0], FlipedBefore, 1.0f/sin(AngleBefore*0.5f));

      for( uint i = 1; i < Loop.Points.length; i++ )
      {
         Vector2f PosAfter;

         if( i == Loop.Points.length-1 )
         {
            PosAfter = Loop.Points[0];
         }
         else
         {
            PosAfter = Loop.Points[i+1];
         }

         DirBefore = (Loop.Points[i  ] - Loop.Points[i-1]).normalized();
         DirAfter  = (PosAfter         - Loop.Points[i  ]).normalized();

         AngleAfter = acos(DirBefore.dot(DirAfter.scale(-1.0f)));

         DirAvg = (DirBefore + DirAfter).normalized();

         FlipedAfter = DirAvg.flip90Degree();

         // OpenGL
         nestedDrawLine(Loop.Points[i-1], FlipedBefore, 1.0f/sin(AngleBefore*0.5f), Loop.Points[i], FlipedAfter, 1.0f/sin(AngleAfter*0.5f));

         FlipedBefore = FlipedAfter;
         AngleBefore = AngleAfter;
      }


      this.MultiLineBuffer.toBuiltState(BuildBufferResult);
      if( BuildBufferResult != Buffer.EnumBuildBufferResult.SUCCESS )
      {
         // failture, exit quitly
         return;
      }

      this.MultilineProgram.useThis();

      // TODO< GC could move the pointer >
      ShaderProgram.uniformMatrix(MatrixModelViewLocation, this.ModelViewMatrix.transpose().getRawData().ptr);

      // TODO< GC could move the pointer >
      ShaderProgram.uniformMatrix(MatrixProjectionLocation, this.Engine.getOrthoProjectionMatrix().transpose().getRawData().ptr);

      this.MultiLineBuffer.bindThis();
      this.MultiLineBuffer.drawThis();
      Buffer.bindNone();

      this.MultiLineBuffer.toModifyState(CalleeSuccess);
      if( !CalleeSuccess )
      {
         // failture, exit quitly
         return;
      }

      Success = true;
   }

   // TOUML
   /** \brief fills a closed loop
    *
    * \param Loop the Shape that should be drawn
    * \param Offset this is added to all positions
    * \param FillColor ...
    * \param Transparency ...
    * \param StartIndex the index of the points where the Polygon-fan begins (IGNORED)
    * \param Success true on success
    */
   final public void drawFillClosedLines(ClosedLoop Loop, Vector2f Offset, Color FillColor, float Transparency, uint StartIndex, out bool Success)
   {
      float FillColorR, FillColorG, FillColorB;

      Success = false;

      // we need more than 2 points
      if( Loop.Points.length < 3 )
      {
         return;
      }

      FillColor.getRgb(FillColorR, FillColorG, FillColorB);

      glBegin(GL_TRIANGLE_FAN);

      glColor3f(FillColorR, FillColorG, FillColorB);

      for( uint i = 0; i < Loop.Points.length; i++ )
      {
         Vector2f Position;

         Position = Loop.Points[i];

         glVertex3f(Offset.X + Position.X, Offset.Y + Position.Y, 0.0f);
      }

      glEnd();

      Success = true;
   }

   // TOUML
   final public void drawLine(float X1, float Y1, float X2, float Y2, float Width, Color ColorObject)
   {
      float Nx;
      float Ny;
      float RLength;
      float RotatedNx;
      float RotatedNy;

      float ColorR, ColorG, ColorB;

      Buffer.EnumBuildBufferResult BuildBufferResult;
      bool CalleeSuccess;

      uint MatrixModelViewLocation = this.LineProgram.getUniformLocation("modelViewMatrix");
      uint MatrixProjectionLocation = this.LineProgram.getUniformLocation("projectionMatrix");

      // TODO< replace normal calculation with vector algebra >
      // TODO< do nothing if distance is 0.0f >
      Nx = X2 - X1;
      Ny = Y2 - Y1;

      RLength = 1.0f/sqrt(Nx*Nx + Ny*Ny);

      Nx *= RLength;
      Ny *= RLength;

      RotatedNx = -Ny;
      RotatedNy = Nx;

      ColorObject.getRgb(ColorR, ColorG, ColorB);

      this.SingleLineBuffer.setPosition(0, new Vector3f(X1 + RotatedNx*Width, Y1 + RotatedNy*Width, 0.0f));
      this.SingleLineBuffer.setPosition(1, new Vector3f(X1 - RotatedNx*Width, Y1 - RotatedNy*Width, 0.0f));
      this.SingleLineBuffer.setPosition(2, new Vector3f(X2 - RotatedNx*Width, Y2 - RotatedNy*Width, 0.0f));
      this.SingleLineBuffer.setPosition(3, new Vector3f(X2 + RotatedNx*Width, Y2 + RotatedNy*Width, 0.0f));

      this.SingleLineBuffer.toBuiltState(BuildBufferResult);
      if( BuildBufferResult != Buffer.EnumBuildBufferResult.SUCCESS )
      {
         // failture, exit quitly
         return;
      }

      this.LineProgram.useThis();

      // TODO< GC could move the pointer >
      ShaderProgram.uniformMatrix(MatrixModelViewLocation, this.ModelViewMatrix.transpose().getRawData().ptr);

      // TODO< GC could move the pointer >
      ShaderProgram.uniformMatrix(MatrixProjectionLocation, this.Engine.getOrthoProjectionMatrix().transpose().getRawData().ptr);

      this.SingleLineBuffer.bindThis();
      this.SingleLineBuffer.drawThis();

      this.SingleLineBuffer.toModifyState(CalleeSuccess);
      if( !CalleeSuccess )
      {
         // failture, exit quitly
         return;
      }

      Buffer.bindNone();

      ShaderProgram.useNone(); // NOTE< not possible with OpenGL 3.x or 4.x
   }

   // TOUML
   /** \brief draws the mouse cursor on the screen
    *
    * \param X ...
    * \param Y ...
    */
   final public void drawMouseCursor(float X, float Y)
   {
      Texture TextureObj;
      bool CalleeSuccess;

      TextureObj = this.Engine.getTextureByName("Mouse", CalleeSuccess);
      if( !CalleeSuccess )
      {
         // return an error?
         return;
      }

      glColor3f(1.0f, 1.0f, 0.0f);
      glBindTexture(GL_TEXTURE_2D, TextureObj.Id);

      glBegin(GL_QUADS);

      glTexCoord2f(0.0f, 1.0f);
      glVertex3f(X, Y, 0.0f);

      glTexCoord2f(0.0f, 0.0f);
      glVertex3f(X, Y - 0.05f, 0.0f);

      glTexCoord2f(1.0f, 0.0f);
      glVertex3f(X + 0.05f, Y - 0.05f, 0.0f);

      glTexCoord2f(1.0f, 1.0f);
      glVertex3f(X + 0.05f, Y, 0.0f);

      glEnd();
   }

   final public void setEngine3d(Engine3d Engine)
   {
      this.Engine = Engine;
   }

   private Engine3d Engine;
   private FreetypeRenderer Freetype; // TOUML

   private Buffer SignBuffer;
   private Buffer SingleLineBuffer;
   private Buffer MultiLineBuffer;

   private Matrix44 ModelViewMatrix; /*< contains the transformation matrix for the correct 2d transformation */

   private ShaderProgram SignProgram; /*< Shader for the signs */
   private ShaderProgram LineProgram; /*< Shader for the line drawing */
   private ShaderProgram MultilineProgram; /*< Shader for line drawing */
}
