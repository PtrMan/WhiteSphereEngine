module whiteSphereEngine.graphics.software.algorithms.BresenhamAlgorithm;

interface IRasterizePoint {
	void setAt(int x, int y);
}

import std.math : abs;

// algorithm heavily inspired by http://www.k-achilles.de/algorithmen/bresenham-gerade.pdf
// we just use some array trickery to get rid of the duplicated code
void line(int x0, int y0, int x1, int y1, IRasterizePoint rasterizer) {
	int[2] d, /* d times two */d2,  step, current, end;

	d[0] = abs(x1-x0); step[0] = x0<x1 ? 1 : -1;
  	d[1] = abs(y1-y0); step[1] = y0<y1 ? 1 : -1;
  	d2[0] = 2*d[0];
  	d2[1] = 2*d[1];

  	current[0] = x0;
  	current[1] = y0;
  	end[0] = x1;
  	end[1] = y1;

	const uint xArrIndex = (d[1] <= d[0]) ? 0 : 1;

  	int f = -d[xArrIndex];

  	while( current[xArrIndex] != end[xArrIndex] ) {
  		rasterizer.setAt(current[0], current[1]);

  		f += d2[1-xArrIndex];

  		if( f > 0 ) {
  			current[1-xArrIndex] += step[1-xArrIndex];
  			f -= d2[xArrIndex];
  		}
  		current[xArrIndex] += step[xArrIndex];
  	}

	rasterizer.setAt(end[0], end[1]);
}
