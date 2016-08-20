module Client.GuiAbstraction.MultiTextElement;

import Engine.Math.Math : max;
import Engine.Common.WideString;
import Engine.Common.Vector;

import Client.GuiAbstraction.Color;
import Client.GuiAbstraction.GuiDrawer;


// TOUML
// TODOCU

class MultiTextElement
{
   private static class Element
   {
      enum EnumType
      {
         NEWLINE,
         TEXT
      }

      public EnumType Type;
      public WideString Text;
      public Color OfColor;
      public float SignHeight = 0.0f;

      this(EnumType Type)
      {
         this.Type = Type;
         this.Text = new WideString();
      }
   }

   final public void render(GuiDrawer Drawer)
   {
      uint LineBeginI;
      Vector2f CurrentPosition;

      assert(!(this.Position is null), "this.Position was null!");

      CurrentPosition = this.Position.clone(); // clone needed?
      
      LineBeginI = 0;
      
      for(;;)
      {
         uint IterationI;
         uint LastElementOfLine;
         uint i;
         float LineHeight;

         if( LineBeginI >= this.Elements.length )
         {
            break;
         }

         // NOTE< doesn't have to be touched for implementing of position caching >
         LastElementOfLine = this.findLastElementOfLine(LineBeginI);

         // NOTE< doesn't have to be touched for implementing of position caching >
         LineHeight = this.getMaxHeightOfElements(LineBeginI, LastElementOfLine);

         // draw

         for( i = LineBeginI; i <= /* right */ LastElementOfLine; i++ )
         {
            // TODO< better position calculation >
            Drawer.drawText(this.Elements[i].Text, (CurrentPosition + new Vector2f(0.0f, LineHeight)), new Vector2f(0.05f, this.Elements[i].SignHeight), this.Elements[i].OfColor);

            CurrentPosition.X = CurrentPosition.X + Drawer.getTextWidth(this.Elements[i].Text, new Vector2f(0.05f, 0.0f));
         }

         // skip all following linebreaks
         for(;;)
         {
            LastElementOfLine++;

            if( LastElementOfLine >= this.Elements.length )
            {
               break;
            }

            if( this.Elements[LastElementOfLine].Type == Element.EnumType.NEWLINE )
            {
               // more current position
               CurrentPosition.X = this.Position.X;
               CurrentPosition.Y = CurrentPosition.Y + this.Elements[LastElementOfLine].SignHeight;
            }
            else
            {
               break;
            }
         }
         
         // TODO

         LineBeginI = LastElementOfLine; // just for testing
      }
   }

   final private uint findLastElementOfLine(uint LineBeginI)
   {
      uint CurrentI;

      assert(LineBeginI < this.Elements.length, "LineBeginI out of bounds!");

      for( CurrentI = LineBeginI;; CurrentI++ )
      {
         if( CurrentI >= this.Elements.length )
         {
            return this.Elements.length-1;
         }

         if( this.Elements[CurrentI].Type == Element.EnumType.NEWLINE )
         {
            if( CurrentI > 0 )
            {
               return CurrentI-1;
            }
            return CurrentI;
         }
      }
   }
   
   final private float getMaxHeightOfElements(uint StartIndex, uint EndIndex)
   {
      uint i;
      float MaxHeight = 0.0f;

      assert(StartIndex >= 0, "StartIndex out of bounds!");
      assert(StartIndex < this.Elements.length, "StartIndex out of bounds!");
      
      assert(EndIndex >= 0, "EndIndex out of bounds!");
      assert(EndIndex < this.Elements.length, "EndIndex out of bounds!");

      assert(StartIndex <= EndIndex, "EndIndex greater than StartIndex!");

      for( i = StartIndex; i < EndIndex; i++ )
      {
         if( this.Elements[i].Type == Element.EnumType.TEXT )
         {
            MaxHeight = max(MaxHeight, this.Elements[i].SignHeight);
         }
      }

      return MaxHeight;
   }

   final public void setPosition(Vector2f Position)
   {
      this.Position = Position;
   }

   public Element []Elements;

   private Vector2f Position;
}
