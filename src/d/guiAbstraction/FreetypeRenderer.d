module Client.GuiAbstraction.FreetypeRenderer;

import std.string : toStringz;

import Client.Api.Freetype;

import Client.GuiAbstraction.SignInformation;

import std.stdio : writeln, write; // just for debugging

// TOUML
// TODOCU

class FreetypeRenderer
{
   private static uint []Chars = [
      ' ',
      'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
      'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
      '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
      '.', ',', ';', ':', '-', '_', '\'', '+', '#', '*', '~',
      '!', '"', '§', '$', '%', '&', '/', '(', ')', '=', '?', '`', '^',
      '´', '{', '[', ']', '}', '\\'
      // sz, euro?
   ];


   private FT_Library FreeTypeLib;
   private FT_Face Face;

   // Temporary bitmap used to convert from 1 bit to 8 bit representation
   private FT_Bitmap TempBitmap;

   private bool LibraryInited = false;

   private SignInformation []InfoArray;

   private uint FixedSignHeight, FixedSignWidth;
   private uint BitmapWidth, BitmapHeight;

   final public void initialize(out bool Success)
   {
      int Error;

      Success = false;

      assert(!LibraryInited, "initialize called more than once!");

      Error = FT_Init_FreeType(&(this.FreeTypeLib));

      if( Error )
      {
         return;
      }

      FT_Bitmap_New(&(this.TempBitmap));

      this.LibraryInited = true;
      Success = true;
      return;
   }

   final public void deinitialize()
   {
      assert(this.LibraryInited, "deinitialize called without succesfully calling initialize!");

      FT_Bitmap_Done(this.FreeTypeLib, &TempBitmap);
      FT_Done_FreeType(this.FreeTypeLib);

      this.LibraryInited = false;
   }

   final public void render(string FontName, uint FixedSignWidth, uint FixedSignHeight, out bool[] Bitmap, uint BitmapWidth, uint BitmapHeight, out bool Success)
   {
      int Error;
      uint CurrentX;
      uint CurrentRow;

      Success = false;

      this.FixedSignHeight = FixedSignHeight;
      this.FixedSignWidth  = FixedSignWidth;
      this.BitmapWidth     = BitmapWidth;
      this.BitmapHeight    = BitmapHeight;

      // create bitmap
      Bitmap = new bool[BitmapWidth*BitmapHeight];

      Error = FT_New_Face(this.FreeTypeLib, FontName.toStringz, 0, &(this.Face));

      if( Error )
      {
         return;
      }

      Error = FT_Set_Pixel_Sizes(
         this.Face,   /* handle to face object */
         FixedSignWidth, /* pixel_width           */
         FixedSignHeight /* pixel_height          */
      );

      if( Error )
      {
         return;
      }

      CurrentX = 0;
      CurrentRow = 0;

      // for testing we just render the "A"

      for( uint i = 0; i < FreetypeRenderer.Chars.length; )
      {
         uint Char;
         uint GlyphIndex;
         uint AdvanceX;
         SignInformation NewSignInformation;

         Char = FreetypeRenderer.Chars[i];

         GlyphIndex = FT_Get_Char_Index(this.Face, Char);

         Error = FT_Load_Glyph(this.Face, GlyphIndex, /* Flags */ 0);

         if( Error )
         {
            return;
         }

         AdvanceX = this.Face.glyph.advance.x/64;

         // +2 because we need some spacing
         if( CurrentX + AdvanceX + 2> 255 )
         {
            // Sign needs to be on next Row

            CurrentX = 0;
            CurrentRow++;

            continue;
         }

         // draw Sign/Glyph

         Error = FT_Render_Glyph(
            this.Face.glyph,   /* glyph slot  */
            FT_Render_Mode.FT_RENDER_MODE_MONO /* render mode */
         );

         if( Error )
         {
            return;
         }

         // convert

         Error = FT_Bitmap_Convert(
            this.FreeTypeLib,
            &(this.Face.glyph.bitmap), /* source */
            &(this.TempBitmap),        /* destination */
            1                          /* alignment */
         );

         if( Error )
         {
            // render error
            return;
         }

         // draw it to the texture
         this.drawToTexture(CurrentX, CurrentRow, FixedSignHeight, BitmapWidth, BitmapHeight, Bitmap);

         writeln(this.Face.glyph.bitmap_top);

         NewSignInformation = new SignInformation();
         NewSignInformation.TopSpacing = this.Face.glyph.bitmap_top;
         NewSignInformation.PositionX = CurrentX;
         NewSignInformation.Row = CurrentRow;
         NewSignInformation.AdvanceX = AdvanceX;

         this.InfoArray ~= NewSignInformation;

         // +2 because we need some spacing
         CurrentX += AdvanceX + 2;

         i += 1;
      }

      Success = true;
   }

   /** \brief draws the current Glyph/Sign to the texture
    *
    * \param CurrentX is the CurrentX position in the Bitmap
    * \param CurrentRow is the Current row in the Bitmap (starts at 0)
    * \param FixedSignHeight is the Heiht of each Sign
    * \param BitmapWidth is the Width of the Bitmap
    * \param BitmapHeight is the Height of the Bitmap
    * \param Bitmap ...
    */
   final private void drawToTexture(uint CurrentX, uint CurrentRow, uint FixedSignHeight, uint BitmapWidth, uint BitmapHeight, ref bool []Bitmap)
   {
      for( int y = 0; y < this.TempBitmap.rows; y++ )
      {
         for( int x = 0; x < this.TempBitmap.width; x++ )
         {
            Bitmap[x + CurrentX + (CurrentRow * FixedSignHeight + y) * BitmapWidth] = (this.TempBitmap.buffer[y * this.TempBitmap.width + x] != 0);
         }
      }
   }

   /** \brief returns the Bitmap/Texture coordinates for a Sign
    *
    * \param Char ...
    * \param AdvanceX will on success contain the relative distance to the next character
    * \param TopSpacing spacing from Top of the Anchor to foot of the text, in pixels
    * \param TopX will contain Top X on success
    * \param TopY will contain Top Y on success
    * \param BottomX will contain Bottom X on success
    * \param BottomY will contain Bottom Y on success
    * \param Success will be true on success
    *
    * \note all returned Coordinates are relative tothe top left
    *
    */
   final public void getBitmapCoordinatesFor(uint Char, out uint TopSpacing, out float AdvanceX, out float TopX, out float TopY, out float BottomX, out float BottomY, out bool Success)
   {
      Success = false;

      for( uint CharI = 0; CharI < FreetypeRenderer.Chars.length; CharI++ )
      {
         if( FreetypeRenderer.Chars[CharI] == Char )
         {
            SignInformation SignInfo;

            if( this.InfoArray.length <= CharI )
            {
               return;
            }

            SignInfo = this.InfoArray[CharI];

            //SignWidth = cast(float)(SignInfo.SignWidth+5/*spacing*/)/cast(float)this.FixedSignWidth;
            AdvanceX = cast(float)SignInfo.AdvanceX/cast(float)this.FixedSignWidth;

            TopX = cast(float)SignInfo.PositionX/cast(float)this.BitmapWidth;
            TopY = cast(float)(this.FixedSignHeight*SignInfo.Row)/cast(float)this.BitmapHeight;

            BottomX = cast(float)(SignInfo.PositionX + SignInfo.AdvanceX-1)/cast(float)this.BitmapWidth;
            BottomY = cast(float)(this.FixedSignHeight*(SignInfo.Row+1)-1)/cast(float)this.BitmapHeight;

            TopSpacing = SignInfo.TopSpacing;

            Success = true;
            return;
         }
      }

      // NOTE< don't set Success to true because of fallthrough >
   }

   /** \brief return the Height of the Signs
    *
    * \return ...
    */
   final public float getFixedSignHeight()
   {
      return this.FixedSignHeight;
   }
}
