module guiAbstraction.IButton;

import math.NumericSpatialVectors;
import math.VectorAlias;
import guiAbstraction.GuiDrawer;


/** \brief Interface for a GUI Button
 *
 */
interface IButton {
	/** \brief set size
	 *
	 * \param Size ...
	 */
	void setSize(Vector2f size);

	/** \brief is called from the rendering Stuff if the GUI is drawn
	 *
	 * \param Drawer is a Context that contains all mthods for drawing
	 */
	void render(GuiDrawer drawer);

	/** \brief set Position
	 *
	 * \param Position ...
	 */
	void setPosition(Vector2f position);

    /** \brief set Text content
	 *
	 * \param Text ...
	 */
	void setText(string text);

	/** \brief sets the scale of one sign
	 *
	 * \param Scale ...
	 */
	void setSignScale(Vector2f scale);
}
