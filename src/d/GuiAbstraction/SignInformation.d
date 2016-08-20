module Client.GuiAbstraction.SignInformation;

/** \brief Informations about a Sign, is used for drawing of text
 * 
 */
class SignInformation
{
   public uint TopSpacing; // is the Freetype bitmap_top attribute
   // is the position of the Sign from the Bottom

   public uint PositionX;
   
   public uint Row;

   public uint AdvanceX;
}
