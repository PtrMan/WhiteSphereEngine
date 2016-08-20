module Client.GuiAbstraction.EditField;

import Client.GuiAbstraction.Color;
import Client.GuiAbstraction.GuiDrawer;
import Client.GuiAbstraction.IClickable;

import Engine.Common.Vector;
import Engine.Common.WideString;

// TOUML
class EditField : IClickable
{
	private Vector2f Position;
   private Color TextColor;
   private WideString Text;
   private uint MaxSigns;
   private float Width;
   private Vector2f SignScale;
   private float BorderWidth;
   private Color BorderColor;
   private Vector2f Size;

   public bool WasClicked;

   this()
   {
      this.Text = new WideString();
   }

   // TOUML
   final public void setPosition(Vector2f Position)
   {
      this.Position = Position;
   }

   final public void setSize(Vector2f Size)
   {
      this.Size = Size;
   }
   
   /*
   public void setWidth(float Width)
   {
      if( Width < 0.0f )
      {
         Width = 0.0f;
      }

      this.Width = Width;
   }
   */

   final public void setBorderWidth(float Width)
   {
      this.BorderWidth = Width;
   }

   public void setMaxSigns(uint Max)
   {
      this.MaxSigns = Max;
   }

   public void setText(WideString Text)
   {
      // TODO< limit length >

      this.Text = Text;
   }

   public WideString getText()
   {
      return this.Text;
   }
   
   // TOUML
   public void render(GuiDrawer Drawer)
   {
      assert(!(this.Position is null), "Position was null!");
      assert(!(this.Size is null), "Size was null!");
      assert(!(this.SignScale is null), "SignScale was null!");
      // TODO< draw cursor >

      Drawer.drawBox(this.Position, this.Size, this.BorderWidth, this.BorderColor);
      
      Drawer.drawText(this.Text, this.Position, this.SignScale, this.TextColor);
   }
   
   public void setTextColor(Color NewColor)
   {
      this.TextColor = NewColor;
   }

   final public void setBorderColor(Color NewColor)
   {
      this.BorderColor = BorderColor;
   }

   public void setSignScale(Vector2f Scale)
   {
      this.SignScale = Scale;
   }

   // ALLREADYDOC
   // from IClickabled
   public void mouseDown(Vector2f Position)
   {
      // do nothing
   }

   // ALLREADYDOC
   // from IClickable
   public void mouseUp (Vector2f Position)
   {
      if( Position.X > this.Position.X && Position.Y > this.Position.Y && Position.X < this.Position.X + this.Size.X && Position.Y < this.Position.Y + this.Size.Y )
      {
         this.WasClicked = true;
      }
   }
}
