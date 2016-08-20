module Client.GuiAbstraction.Button;

import Client.GuiAbstraction.IButton;
import Client.GuiAbstraction.IClickable;
import Client.GuiAbstraction.ClosedLoop;
import Client.GuiAbstraction.Color;
import Engine.Common.Vector;
import Engine.Common.WideString;
import Client.GuiAbstraction.GuiDrawer;

// TOUML
/** \brief A Button
 *
 */
// TODO< set Text Color >
class Button : IButton, IClickable {
   private ClosedLoop Outline;
   private Vector2f Position;
   
   private Color BorderColor;
   private Color BackgroundColor;

   private float OutlineWidth = 0.0f;
   private WideString Text; /**< reference/pointer to the displayed text */
   private Vector2f SignScale;
   private Vector2f Size; /**< size of the Button */
   public bool WasClicked = false; /**< will be set to true if it has received a click */

   this()
   {
      this.Position = new Vector2f(0.0f, 0.0f);
   }

   // NOTE< allready documentated >
   final public void setPosition(Vector2f Position)
   {
      this.Position = Position;
   }

   // NOTE< allready documentated >
   final public void setText(WideString Text)
   {
      this.Text = Text;
   }

   // NOTE< allready documentated >
   public void setSignScale(Vector2f Scale)
   {
      this.SignScale = Scale;
   }

   /** \brief sets the Width of the Outline
    *
    * \param Width ... , must be greater than 0.0f
    */
   final public void setOutlineWidth(float Width)
   {
      if( Width < 0.0f )
      {
         Width = 0.0f;
      }

      this.OutlineWidth = Width;
   }

   /** \brief ...
    *
    * \param BorderColor ...
    */
   final public void setBorderColor(Color BorderColor)
   {
      this.BorderColor = BorderColor;
   }

   final public void setBackgroundColor(Color BackgroundColor)
   {
      this.BackgroundColor = BackgroundColor;
   }

   // NOTE< allready documentated >
   final public void setSize(Vector2f Size)
   {
      float InsetWidth = 0.05f;
      float InsetHeight = 0.02f;

      this.Outline = new ClosedLoop();

      this.Outline.Points ~= new Vector2f(0.0f, 0.0f);
      this.Outline.Points ~= new Vector2f(Size.X, 0.0f);
      this.Outline.Points ~= new Vector2f(Size.X, Size.Y-InsetHeight);
      this.Outline.Points ~= new Vector2f(Size.X-InsetWidth, Size.Y);
      this.Outline.Points ~= new Vector2f(0.0f, Size.Y);

      this.Size = Size.clone();
   }

   // NOTE< allready documentated >
   final public void render(GuiDrawer Drawer)
   {
      bool CalleeSuccess;
      Vector2f TextPosition;
      Color TextColor;
      float TextWidth;

      assert(this.Outline !is null  , "this.Outline was null!");
      assert(this.Text !is null     , "this.Text was null!");
      assert(this.SignScale !is null, "this.SignScale was null!");

      // TODO< modify >
      TextColor.setRgb(0.0f, 0.0f, 0.0f);

      Drawer.drawFillClosedLines(this.Outline, this.Position, this.BackgroundColor, 0.0f, 0, CalleeSuccess);
      if( !CalleeSuccess )
      {
         // TODO< log it >
      }

      Drawer.drawClosedLines(this.Outline, this.Position, this.BorderColor, this.BorderColor, 0.0f, this.OutlineWidth, CalleeSuccess);
      if( !CalleeSuccess )
      {
         // TODO< log it >
      }

      // TODO< calculate >
      TextWidth = Drawer.getTextWidth(this.Text, this.SignScale);

      TextPosition = new Vector2f(this.Position.X + this.Size.X * 0.5f - TextWidth * 0.5f, this.Position.Y + this.Size.Y*0.5f + this.SignScale.Y*0.3f);

      
      // TODO< draw text >
      Drawer.drawText(this.Text, TextPosition, this.SignScale, TextColor);
   }

   void mouseDown(Vector2f Position)
   {
      // do nothing
   }

   void mouseUp(Vector2f Position)
   {
      if( Position.X > this.Position.X && Position.Y > this.Position.Y && Position.X < this.Position.X + this.Size.X && Position.Y < this.Position.Y + this.Size.Y )
      {
         this.WasClicked = true;
      }
   }
}
