struct Vector2d {
	float x, y;
}

// used to retrive the projected size of an 3d object to the screen
interface IProjectedSize : ISize {
}

interface ISize {
	@property Vector2d size();
}

float[] layoutHorizontally(ISize[] elements, float spacing) {
	float[] resultLayout;
	resultLayout.length = elements.length;

	float running = 0.0f;

	foreach( i, iterationElement; elements ) {
		resultLayout[i] = running;
		running += (iterationElement.size.x + spacing);
	}

	return resultLayout;
}
