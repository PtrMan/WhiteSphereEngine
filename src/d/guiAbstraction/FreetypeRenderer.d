module guiAbstraction.FreetypeRenderer;

import std.string : toStringz;

import api.freetype.Freetype;

import guiAbstraction.SignInformation;

import std.stdio : writeln, write; // just for debugging


class FreetypeRenderer {
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

	final void initialize(out bool success) {
		int Error;

		success = false;

		assert(!libraryInited, "initialize called more than once!");

		int error = FT_Init_FreeType(&(this.FreeTypeLib));
		if( error ) {
			return;
		}

		FT_Bitmap_New(&tempBitmap);

		libraryInited = true;
		success = true;
		return;
	}

	final void deinitialize() {
		assert(libraryInited, "deinitialize called without succesfully calling initialize!");

		FT_Bitmap_Done(freeTypeLib, &tempBitmap);
		FT_Done_FreeType(freeTypeLib);

		libraryInited = false;
	}

	final void render(string fontName, uint fixedSignWidth, uint fixedSignHeight, out bool[] bitmap, uint itmapWidth, uint bitmapHeight, out bool success) {
		success = false;

		this.fixedSignHeight = fixedSignHeight;
		this.fixedSignWidth  = fixedSignWidth;
		this.bitmapWidth     = bitmapWidth;
		this.bitmapHeight    = bitmapHeight;

		// create bitmap
		bitmap = new bool[bitmapWidth*bitmapHeight];

		int freetypeError = FT_New_Face(freeTypeLib, fontName.toStringz, 0, &face);

		if( freetypeError ) {
			return;
		}

		freetypeError = FT_Set_Pixel_Sizes(
			this.Face,   /* handle to face object */
			FixedSignWidth, /* pixel_width           */
			FixedSignHeight /* pixel_height          */
		);

		if( freetypeError ) {
			return;
		}

		uint currentX = 0;
		uint currentRow = 0;

		// for testing we just render the "A"

		foreach( i; 0..FreetypeRenderer.chars.length ) {
			uint GlyphIndex;
			SignInformation NewSignInformation;

			uint char = FreetypeRenderer.chars[i];

			uint glyphIndex = FT_Get_Char_Index(this.Face, Char);

			freetypeError = FT_Load_Glyph(face, glyphIndex, /* Flags */ 0);

			if( freetypeError ) {
	            return;
			}

			uint advanceX = this.Face.glyph.advance.x/64;

			// +2 because we need some spacing
			if( currentX + advanceX + 2 > 255 ) {
				// Sign needs to be on next Row

				currentX = 0;
				currentRow++;

				continue;
			}

			// draw Sign/Glyph
			freetypeError = FT_Render_Glyph(
				face.glyph,   /* glyph slot  */
				FT_Render_Mode.FT_RENDER_MODE_MONO /* render mode */
			);

			if( freetypeError ) {
				return;
			}

			// convert
			freetypeError = FT_Bitmap_Convert(
				freeTypeLib,
				&(face.glyph.bitmap), /* source */
				&(tempBitmap),        /* destination */
				1                          /* alignment */
			);

			if( freetypeError ) {
				// render error
				return;
			}

			// draw it to the texture
			drawToTexture(currentX, currentRow, fixedSignHeight, bitmapWidth, bitmapHeight, bitmap);

			writeln(face.glyph.bitmap_top);

			newSignInformation = new SignInformation();
			newSignInformation.topSpacing = this.Face.glyph.bitmap_top;
			newSignInformation.positionX = currentX;
			newSignInformation.row = currentRow;
			newSignInformation.advanceX = advanceX;

			this.infoArray ~= newSignInformation;

			// +2 because we need some spacing
			currentX += advanceX + 2;
		}

		success = true;
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
	final private void drawToTexture(uint currentX, uint currentRow, uint fixedSignHeight, uint bitmapWidth, uint bitmapHeight, ref bool[] bitmap) {
		for( int y = 0; y < this.TempBitmap.rows; y++ ) {
			for( int x = 0; x < this.TempBitmap.width; x++ ) {
				bitmap[x + currentX + (currentRow * fixedSignHeight + y) * bitmapWidth] = (tempBitmap.buffer[y * tempBitmap.width + x] != 0);
			}
		}
	}

	/** \brief returns the Bitmap/Texture coordinates for a Sign
	 *
	 * \param char ...
	 * \param advanceX will on success contain the relative distance to the next character
	 * \param topSpacing spacing from Top of the Anchor to foot of the text, in pixels
	 * \param topX will contain Top X on success
	 * \param topY will contain Top Y on success
	 * \param bottomX will contain Bottom X on success
	 * \param bottomY will contain Bottom Y on success
	 * \param success will be true on success
	 *
	 * \note all returned Coordinates are relative to the top left
	 *
	 */
	final void getBitmapCoordinatesFor(uint char, out uint topSpacing, out float advanceX, out float topX, out float topY, out float bottomX, out float bottomY, out bool success) {
		success = false;

		for( uint charI = 0; charI < FreetypeRenderer.Chars.length; charI++ ) {
			if( FreetypeRenderer.chars[charI] == char ) {
				SignInformation signInfo;

				if( infoArray.length <= charI ) {
					return;
				}

				signInfo = infoArray[CharI];

				//signWidth = cast(float)(signInfo.signWidth+5/*spacing*/)/cast(float)this.fixedSignWidth;
				advanceX = cast(float)SignInfo.advanceX/cast(float)fixedSignWidth;

				topX = cast(float)SignInfo.positionX/cast(float)bitmapWidth;
				topY = cast(float)(fixedSignHeight*SignInfo.row)/cast(float)bitmapHeight;

				bottomX = cast(float)(SignInfo.positionX + SignInfo.advanceX-1)/cast(float)bitmapWidth;
				bottomY = cast(float)(fixedSignHeight*(SignInfo.row+1)-1)/cast(float)bitmapHeight;

				topSpacing = SignInfo.topSpacing;

				success = true;
				return;
			}
		}

		// NOTE< don't set Success to true because of fallthrough >
	}

	/** \brief return the Height of the Signs
	 *
	 * \return ...
	 */
	final float getFixedSignHeight() {
		return this.fixedSignHeight;
	}
}
