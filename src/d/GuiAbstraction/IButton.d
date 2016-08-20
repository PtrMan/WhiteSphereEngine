module Client.GuiAbstraction.IButton;

import Engine.Common.Vector;
import Client.GuiAbstraction.GuiDrawer;
import Engine.Common.WideString;

// TOUML

/** \brief Interface for a GUI Button
 *
 */
interface IButton
{
   /** \brief set size
    *
    * \param Size ...
    */
   public void setSize(Vector2f Size);

   /** \brief is called from the rendering Stuff if the GUI is drawn
    *
    * \param Drawer is a Context that contains all mthods for drawing
    */
   public void render(GuiDrawer Drawer);

   /** \brief set Position
    *
    * \param Position ...
    */
   public void setPosition(Vector2f Position);

    /** \brief set Text content
    *
    * \param Text ...
    */
   public void setText(WideString Text);

   /** \brief sets the scale of one sign
    *
    * \param Scale ...
    */
   public void setSignScale(Vector2f Scale);
}
