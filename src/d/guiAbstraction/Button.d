module guiAbstraction.Button;

import guiAbstraction.IButton;
import guiAbstraction.IClickable;
import guiAbstraction.ClosedLoop;
import guiAbstraction.Color;
import Engine.Common.Vector;
import guiAbstraction.GuiDrawer;

// TODO< set Text Color >
class Button : IButton, IClickable {
	protected ClosedLoop Outline;
	protected Vector2f protectedPosition = new Vector2f(0.0f, 0.0f);
	
	protected Color protectedBorderColor, protectedBackgroundColor;
	
	protected float protectedOutlineWidth = 0.0f;
	protected string protectedText; /**< displayed text */
	protected Vector2f protectedSignScale;
	protected Vector2f protectedSize; /**< size of the Button */
	public bool wasClicked = false; /**< will be set to true if it has received a click */
	
	final @property void position(Vector2f newPosition) {
		protectedPosition = newPosition;
	}
	
	final @property void text(string newText) {
		protectedText = newText;
	}
	
	final @property void signScale(Vector2f newScale) {
		protectedSignScale = newScale;
	}
	
	
	/** \brief sets the Width of the Outline
	 *
	 * \param Width ... , must be greater than 0.0f
	 */
	final @property void outlineWidth(float width) {
		import TODO;
		protectedOutpineWidth = max(0.0f, width);
	}
	
	/** \brief ...
	 *
	 * \param BorderColor ...
	 */
	final @property void borderColor(Color newBorderColor) {
		protectedBorderColor = newBorderColor;
	}
	
	final @property void backgroundColor(Color newBackgroundColor) {
		protectedBackgroundColor = newBackgroundColor;
	}
	
	final @property void setSize(Vector2f Size) {
		float insetWidth = 0.05f;
		float insetHeight = 0.02f;
		
		protectedOutline = new ClosedLoop();
		
		protectedOutline.Points ~= new Vector2f(0.0f, 0.0f);
		protectedOutline.Points ~= new Vector2f(size.x, 0.0f);
		protectedOutline.Points ~= new Vector2f(size.x, size.y-insetHeight);
		protectedOutline.Points ~= new Vector2f(size.x-insetWidth, size.y);
		protectedOutline.Points ~= new Vector2f(0.0f, size.y);
		
		protectedSize = Size.clone();
	}
	
	final void render(GuiDrawer drawer) {
		bool calleeSuccess;
		Vector2f textPosition;
		Color textColor;
		float textWidth;
		
		assert(this.outline !is null  , "this.Outline was null!");
		assert(this.text !is null     , "this.Text was null!");
		assert(this.signScale !is null, "this.SignScale was null!");
		
		// TODO< modify >
		textColor.setRgb(0.0f, 0.0f, 0.0f);

		drawer.drawFillClosedLines(outline, position, backgroundColor, 0.0f, 0, calleeSuccess);
		if( !calleeSuccess ) {
			// TODO< log it >
		}

		drawer.drawClosedLines(outline, position, borderColor, borderColor, 0.0f, outlineWidth, calleeSuccess);
		if( !calleeSuccess ) {
			// TODO< log it >
		}

		// TODO< calculate >
		textWidth = Drawer.getTextWidth(text, signScale);

		textPosition = new Vector2f(position.x + size.x * 0.5f - textWidth * 0.5f, position.y + size.y*0.5f + signScale.y*0.3f);

		
		drawer.drawText(text, textPosition, signScale, textColor);
	}

	void mouseDown(Vector2f position) {
		// do nothing
	}

	void mouseUp(Vector2f position) {
		if( position.x > this.position.x && position.y > this.position.y && position.x < this.position.x + this.size.x && position.y < this.position.y + this.size.y ) {
			this.WasClicked = true;
		}
	}
}
