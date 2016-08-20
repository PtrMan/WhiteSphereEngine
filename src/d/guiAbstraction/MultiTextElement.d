module guiAbstraction.MultiTextElement;

import math.NumericSpatialVectors;
import math.VectorAlias;

import guiAbstraction.Color;
import guiAbstraction.GuiDrawer;


// TODOCU

class MultiTextElement {
	private static class Element {
		enum EnumType {
		NEWLINE,
		TEXT
	}

	public EnumType type;
	public string text;
	public Color color;
	public float signHeight = 0.0f;

	final this(EnumType Type) {
		this.type = type;
	}
	
	final void render(GuiDrawer drawer) {
		uint lineBeginI;
		Vector2f currentPosition;

		assert(position !is null, "this.Position was null!");

		currentPosition = position.clone(); // clone needed?
		
		lineBeginI = 0;
		
		for(;;) {
			uint iterationI;
			uint lastElementOfLine;
			uint i;
			float lineHeight;

			if( lineBeginI >= elements.length ) {
				break;
			}

			// NOTE< doesn't have to be touched for implementing of position caching >
			lastElementOfLine = findLastElementOfLine(lineBeginI);

			// NOTE< doesn't have to be touched for implementing of position caching >
			lineHeight = getMaxHeightOfElements(lineBeginI, lastElementOfLine);

			// draw

			for( i = lineBeginI; i <= /* right */ lastElementOfLine; i++ ) {
				// TODO< better position calculation >
				Drawer.drawText(elements[i].text, (currentPosition + new Vector2f(0.0f, lineHeight)), new Vector2f(0.05f, elements[i].signHeight), this.elements[i].color);

				currentPosition.X = currentPosition.X + drawer.getTextWidth(elements[i].text, new Vector2f(0.05f, 0.0f));
			}

			// skip all following linebreaks
			for(;;) {
				lastElementOfLine++;

				if( lastElementOfLine >= elements.length ) {
					break;
				}

				if( elements[lastElementOfLine].type == Element.EnumType.NEWLINE ) {
					// more current position
					CurrentPosition.x = position.x;
					CurrentPosition.y = CurrentPosition.y + elements[lastElementOfLine].signHeight;
				}
				else {
					break;
				}
			}

			// TODO

			lineBeginI = lastElementOfLine; // just for testing
		}
	}

	final private uint findLastElementOfLine(uint lineBeginI) {
		assert(lineBeginI < this.Elements.length, "LineBeginI out of bounds!");

		for( uint currentI = lineBeginI;; currentI++ ) {
			if( CurrentI >= this.Elements.length ) {
				return this.Elements.length-1;
			}

			if( elements[currentI].type == Element.EnumType.NEWLINE ) {
				if( currentI > 0 ) {
					return currentI-1;
				}
				return currentI;
			}
		}
	}
   
	final private float getMaxHeightOfElements(uint startIndex, uint endIndex) {
		uint i;
		float maxHeight = 0.0f;

		assert(startIndex >= 0, "StartIndex out of bounds!");
		assert(startIndex < this.Elements.length, "StartIndex out of bounds!");
		
		assert(endIndex >= 0, "EndIndex out of bounds!");
		assert(endIndex < this.Elements.length, "EndIndex out of bounds!");

		assert(startIndex <= endIndex, "EndIndex greater than StartIndex!");

		for( i = startIndex; i < endIndex; i++ ) {
			if( elements[i].type == Element.EnumType.TEXT ) {
				maxHeight = max(maxHeight, elements[i].signHeight);
			}
		}

		return MaxHeight;
	}

	final @property void position(Vector2f newPosition) {
		position = newPosition;
	}

	public Element[] elements;

	protected Vector2f protectedPosition;
}
