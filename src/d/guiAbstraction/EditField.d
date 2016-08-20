module guiAbstraction.EditField;

import guiAbstraction.Color;
import guiAbstraction.GuiDrawer;
import guiAbstraction.IClickable;

import math.NumericSpatialVectors;
import math.VectorAlias;

//import Engine.Common.WideString;

class EditField : IClickable {
	public Vector2f position;
	public Color textColor;
	public string text;
	public uint maxSigns;
	public float width;
	public Vector2f signScale;
	public float borderWidth;
	public Color borderColor;
	public Vector2f size;

	public bool wasClicked;

	final this() {
	}

	/* uncommented from the old source code
	public void setWidth(float width) {
		this.width = max(0.0f, width)
	}
	 */

	public void render(GuiDrawer drawer) {
		assert(this.Position !is null, "Position was null!");
		assert(this.Size !is null, "Size was null!");
		assert(this.SignScale !is null, "SignScale was null!");
		// TODO< draw cursor >

		drawer.drawBox(this.Position, this.Size, this.BorderWidth, this.BorderColor);
		
		drawer.drawText(this.Text, this.Position, this.SignScale, this.TextColor);
	}

	// from IClickabled
	void mouseDown(Vector2f position) {
		// do nothing
	}

	// from IClickable
	void mouseUp(Vector2f position) {
		if( position.x > this.Position.x && Position.y > this.Position.y && Position.x < this.Position.x + this.Size.x && Position.y < this.Position.y + this.Size.y ) {
			this.WasClicked = true;
		}
	}
}
