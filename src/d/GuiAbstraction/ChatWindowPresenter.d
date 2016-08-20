module Client.GuiAbstraction.ChatWindowPresenter;

import Client.GuiAbstraction.IChatWindowModel;
import Client.GuiAbstraction.GuiDrawer;

import Engine.Common.WideString;

// just for testing
import std.stdio : writeln;
import Engine.Common.Vector;
import Client.GuiAbstraction.Color;

import Client.GuiAbstraction.ClosedLoop;
import Engine.Common.Vector;

import Client.GuiAbstraction.Button;

// for testing
import Client.opengl.gl;

// NOTE< this is wrong because it is not the presenter >

/** \brief Presenter of the Chat Window
 *
 * (MVP Pattern)
 */
class ChatWindowPresenter
{
   private IChatWindowModel Model;

   // TOUML
   private Button Button0;

   // TOUML
   this()
   {
      this.Button0 = new Button();
      this.Button0.setPosition(new Vector2f(0.1f, 0.3f));
      this.Button0.setSize(new Vector2f(0.1f, 0.06f));
      this.Button0.setOutlineWidth(0.018f);
   }

   /** \brief Manages all stuff of the Presenter
    *
    */
   final public void doIt()
   {
      uint []LastSigns;
      WideString InputString;

      // get new Signs from the Model and append it to the text in the EditField

      LastSigns = this.Model.getLastSigns();

      //InputString = EditField.getText();

      // TODO< implement removing of the Signs at the current Cursor position >
      foreach(uint Char; LastSigns)
      {
         InputString.appendChar(cast(char)Char);
      }

      //EditField.setText(InputString);
   }

   /** \brief renders the stuff
    *
    * \param Drawer the Drawer Object that Draws the stuff
    *
    */
   final public void render(GuiDrawer Drawer)
   {
      //this.EditField.render(Drawer);

      // for testing
      Vector2f Pos, Size;
      Color ColorObj;

      Pos = new Vector2f(0.5f, 0.3f);

      Size = new Vector2f(0.2f, 0.1f);
      
      Drawer.drawBox(Pos, Size, 0.01f, ColorObj);

      // for testing too
      bool CalleeSuccess;
      ClosedLoop UsedLoop = new ClosedLoop();

      UsedLoop.Points ~= new Vector2f(0.3f, 0.1f);
      UsedLoop.Points ~= new Vector2f(0.5f, 0.1f);
      UsedLoop.Points ~= new Vector2f(0.4f, 0.3f);

      Drawer.drawClosedLines(
        UsedLoop,                 // Loop
        new Vector2f(0.0f, 0.0f), // Offset
        ColorObj,                 // ColorInner
        ColorObj,                 // ColorOuter
        0.5f,                     // Transperency
        0.01f,                    // Width
        CalleeSuccess             // Success
      );

      // twist coordinates to left-top orgin

      glPushMatrix();

      glTranslatef(0.0f, 1.0f, 0.0f);
      glScalef(1.0f, -1.0f, 0.0f);

      this.Button0.render(Drawer);

      glPopMatrix();
   }

   /** \brief ...
    *
    * \param Model ...
    */
   final public void setModel(IChatWindowModel Model)
   {
      this.Model = Model;
   }

}
