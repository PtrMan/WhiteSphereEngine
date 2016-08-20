module Client.GuiAbstraction.IClickable;

import Engine.Common.Vector;

interface IClickable
{
   public void mouseDown(Vector2f Position);
   public void mouseUp(Vector2f Position);
}
