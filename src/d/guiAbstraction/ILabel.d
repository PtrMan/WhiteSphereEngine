module Client.GuiAbstraction.ILabel;

import math.NumericSpatialVectors;
import math.VectorAlias;

import guiAbstraction.Color;
import guiAbstraction.GuiDrawer;

/** \brief Interface for a GUI Label
 *
 */
interface ILabel {
   /** \brief set position
	*
	* \param position ...
	*/
	void setPosition(Vector2f position)
	in {
		assert(position !is null, "Position was null!");
	}

	/** \brief set Text content
	 *
	 * \param Text ...
	 */
	void setText(string text)
	in {
		assert(text !is null, "Text was null!");
	}
	
	
	/** \brief is called from the rendering Stuff if the GUI is drawn
	 *
	 * \param drawObject is a Context that contains all mthods for drawing
	 */
	void render(GuiDrawer drawObject);
   
	/** \brief sets the color of the Text
	 *
	 * \param color ...
	 */
	void setColor(Color ColorObject);

	/** \brief sets the scale of one sign
	 *
	 * \param scale ...
	 */
	public void setSignScale(Vector2f scale)
	in {
		assert(scale !is null, "Scale was null!");
	}
}
