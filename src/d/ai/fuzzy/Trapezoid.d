module ai.fuzzy.Trapezoid;

class Trapezoid {
	public final this(float x0, float x1, float y1, float x2, float y2, float x3) {
		this.x0 = x0;
		this.x1 = x1;
		this.y1 = y1;
		this.x2 = x2;
		this.y2 = y2;
		this.x3 = x3;
	}
	
	public float x0;
	public float x1, y1;
	public float x2, y2;
	public float x3;
}
