using System;

public interface IRasterizePoint
{
	void setAt(int x, int y);
}

public class BresenhamAlgorithm
{
	// code is from http://de.wikipedia.org/wiki/Bresenham-Algorithmus
	static public void line(int x0, int y0, int x1, int y1, IRasterizePoint rasterizer)
	{
  		int dx =  Math.Abs(x1-x0), sx = x0<x1 ? 1 : -1;
  		int dy = -Math.Abs(y1-y0), sy = y0<y1 ? 1 : -1;
  		int err = dx+dy, e2; /* error value e_xy */
 
  		for(;;)
		{
			rasterizer.setAt(x0, y0);

    		if (x0==x1 && y0==y1) break;
    		e2 = 2*err;
    		if (e2 > dy) { err += dy; x0 += sx; }
    		if (e2 < dx) { err += dx; y0 += sy; }
  		}
	}
}
