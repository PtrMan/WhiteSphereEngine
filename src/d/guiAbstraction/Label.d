module guiAbstraction.Label;

import math.NumericSpatialVectors;
import math.VectorAlias;

import guiAbstraction.ILabel;
import guiAbstraction.Color;
import guiAbstraction.GuiDrawer;

// TODO< change LabelView to Label >

class Label : ILabel {
	private Vector2f position;
	private Vector2f signScale;
	private Color color;
	private string text;

	final this() {
		position = new Vector2f(0.0f, 0.0f);
	}

	void setPosition(Vector2f position) {
		// Position is allready checked

		this.position = position;
	}
   
	void setText(WideString text) {
		// Text is allready checked

		this.Text = Text;
	}
   
	void render(GuiDrawer drawObject) {
		assert(text !is null, "Text was null!");
		assert(signScale !is null, "SignScale was null!");
		// no assert for Position because it is gurantueed to be non null

		drawObject.drawText(text, position, signScale, colorObject);
	}

	void setColor(Color color) {
		this.color = color;
	}

	void setSignScale(Vector2f scale) {
		// Scale is allready checked

		this.signScale = scale;
	}
}
