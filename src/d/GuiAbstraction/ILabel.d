module Client.GuiAbstraction.ILabel;

import Engine.Common.Vector;
import Engine.Common.WideString;
import Client.GuiAbstraction.Color;
import Client.GuiAbstraction.GuiDrawer;

/** \brief Interface for a GUI Label
 *
 */
interface ILabel
{
   /** \brief set Position
    *
    * \param Position ...
    */
	public void setPosition(Vector2f Position)
   in
   {
      assert(Position !is null, "Position was null!");
   }
   
   /** \brief set Text content
    *
    * \param Text ...
    */
   public void setText(WideString Text)
   in
   {
      assert(Text !is null, "Text was null!");
   }
   
   
   /** \brief is called from the rendering Stuff if the GUI is drawn
    *
    * \param DrawObject is a Context that contains all mthods for drawing
   */
   public void render(GuiDrawer DrawObject);
   
   /** \brief sets the color of the Text
    *
    * \param Color ...
    */
   public void setColor(Color ColorObject);

   /** \brief sets the scale of one sign
    *
    * \param Scale ...
    */
   public void setSignScale(Vector2f Scale)
   in
   {
      assert(Scale !is null, "Scale was null!");
   }
}
