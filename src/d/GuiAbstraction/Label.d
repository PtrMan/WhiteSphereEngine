module Client.GuiAbstraction.Label;

import Engine.Common.Vector;
import Engine.Common.WideString;
import Client.GuiAbstraction.ILabel;
import Client.GuiAbstraction.Color;
import Client.GuiAbstraction.GuiDrawer;

// TODO< uml, change LabelView to Label >

class Label : ILabel
{
   private Vector2f Position;
   private Vector2f SignScale;
   private Color ColorObject;
   private WideString Text;

   this()
   {
      this.Position = new Vector2f(0.0f, 0.0f);
   }

   public void setPosition(Vector2f Position)
   {
      // Position is allready checked

      this.Position = Position;
   }
   
   public void setText(WideString Text)
   {
      // Text is allready checked

      this.Text = Text;
   }
   
   public void render(GuiDrawer DrawObject)
   {
      assert(this.Text !is null, "Text was null!");
      assert(this.SignScale !is null, "SignScale was null!");
      // no assert for Position because it is gurantueed to be non null

      DrawObject.drawText(this.Text, this.Position, this.SignScale, this.ColorObject);
   }
   
   public void setColor(Color ColorObject)
   {
      this.ColorObject = ColorObject;
   }

   public void setSignScale(Vector2f Scale)
   {
      // Scale is allready checked

      this.SignScale = Scale;
   }
}
