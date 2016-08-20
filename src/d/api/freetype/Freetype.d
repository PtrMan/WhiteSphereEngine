module api.freetype.Freetype;

// NOTE< quick hacked structures, offsets can be wrong >

private alias immutable(char) FT_String;
private alias int FT_Int;
private alias ushort FT_UShort;
private alias short FT_Short;
private alias uint FT_ULong;
private alias uint FT_UInt;

private alias uint FT_F26Dot6;

// hack
private alias ubyte[8] FT_Generic;

alias void* FT_Library;

//alias uint/*?*/ FT_GlyphSlot;
alias FT_GlyphSlotRec_  *FT_GlyphSlot;

alias FT_FaceRec_ *FT_Face;

public struct FT_Bitmap
{
   int             rows;
   int             width;
   int             pitch;
   ubyte*  buffer;
   short           num_grays;
   char            pixel_mode;
   char            palette_mode;
   void*           palette;
}

private struct FT_Vector
{
   uint x, y; // is it uint?
}

private struct FT_GlyphSlotRec_
{
	FT_Library        library;
   FT_Face           face;
   FT_GlyphSlot      next;
   FT_UInt           reserved;       /* retained for binary compatibility */
   FT_Generic        generic;

   /*FT_Glyph_Metrics*//*quick hack*/ubyte[32]  metrics;
   /*FT_Fixed*/void*          linearHoriAdvance;
   /*FT_Fixed*/void*          linearVertAdvance;
   /+/*FT_Vector*//* quick hack */ubyte[8]         advance;+/
   FT_Vector                  advance;

   /*FT_Glyph_Format*/void*   format;

   FT_Bitmap         bitmap;
   FT_Int            bitmap_left;
   FT_Int            bitmap_top;

   /*FT_Outline*/void*        outline;

   FT_UInt           num_subglyphs;
   /*FT_SubGlyph*/void*       subglyphs;

   void*             control_data;
   long              control_len;

   /*FT_Pos*/void*            lsb_delta;
   /*FT_Pos*/void*            rsb_delta;

   void*             other;

   /*FT_Slot_Internal*/void*  internal;
}

private struct FT_FaceRec_
{
	int num_faces;
   int face_index;

   int face_flags;
   int style_flags;

   int num_glyphs;

   FT_String *family_name;
   FT_String *style_name;

   int num_fixed_sizes;
   /*FT_Bitmap_Size*//* just fill it up */byte[16] available_sizes;

   FT_Int            num_charmaps;
   /*FT_CharMap*/void*       charmaps;

   FT_Generic       generic;

   /*# The following member variables (down to `underline_thickness') */
   /*# are only relevant to scalable outlines; cf. @FT_Bitmap_Size    */
   /*# for bitmap fonts.                                              */
   /*FT_BBox*/int           bbox;

   FT_UShort         units_per_EM;
   FT_Short          ascender;
   FT_Short          descender;
   FT_Short          height;

   FT_Short          max_advance_width;
   FT_Short          max_advance_height;

   FT_Short          underline_position;
   FT_Short          underline_thickness;

   FT_GlyphSlot      glyph;
   /*FT_Size*/int           size;
   /*FT_CharMap*/int        charmap;

   /*@private begin */

   /*FT_Driver*/void*         driver;
   /*FT_Memory*/void*         memory;
   /*FT_Stream*/void*         stream;

   /*FT_ListRec*/void*        sizes_list;

   /*FT_Generic*/void*        autohint;   /* face-specific auto-hinter data */
   void*             extensions; /* unused                         */

   /*FT_Face_Internal*/void*  internal;

   /*@private end */
}

public enum FT_Render_Mode
{
   FT_RENDER_MODE_NORMAL = 0,
   FT_RENDER_MODE_LIGHT,
   FT_RENDER_MODE_MONO,
   FT_RENDER_MODE_LCD,
   FT_RENDER_MODE_LCD_V,

   FT_RENDER_MODE_MAX

}

extern(C)
{
	int FT_Init_FreeType(FT_Library *library);
	int FT_Done_FreeType(FT_Library  library);

	int FT_New_Face(FT_Library library, immutable(char) *filepathname, int face_index, FT_Face *aface);

	int FT_Set_Pixel_Sizes(FT_Face face, uint pixel_width, uint pixel_height);
	int FT_Set_Char_Size(FT_Face face, FT_F26Dot6 char_width, FT_F26Dot6 char_height, FT_UInt horz_resolution, FT_UInt vert_resolution);

	int FT_Load_Glyph(FT_Face face, uint glyph_index, int load_flags);
	int FT_Get_Char_Index(FT_Face face, FT_ULong charcode);
	int FT_Render_Glyph(FT_GlyphSlot slot, FT_Render_Mode render_mode);

	void FT_Bitmap_New(FT_Bitmap *abitmap);

	int FT_Bitmap_Convert(
		FT_Library        library,
      /*const */FT_Bitmap  *source,
      FT_Bitmap        *target,
      FT_Int            alignment
   );

   int FT_Bitmap_Done(
    	FT_Library  library,
      FT_Bitmap  *bitmap
   );

}
