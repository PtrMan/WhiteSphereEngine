module whiteSphereEngine.graphics.software.SoftwareRasterizer;

import whiteSphereEngine.graphics.software.algorithms.BresenhamAlgorithm : IRasterizePoint, bresenhamLine = line;

import whiteSphereEngine.common.Map2d;

//import whiteSphereEngine.common.IMap2d : IMap2d;
import linopterixed.linear.Vector;

class SoftwareRasterizer {
	private alias Map2d!(bool, true) ImageType;

	// just for testing a bool image and a direct array!
	ImageType image;

	final this() {
		drawer = new Drawer(this);
	}

	final void setRenderSize(SpatialVectorStruct!(2,int) size) {
		image = new ImageType(size.x, size.y);
	}

	final void drawLine(SpatialVectorStruct!(2,int) a, SpatialVectorStruct!(2,int) b) {
		bresenhamLine(a.x, a.y, b.x, b.y, drawer);
	}

	private Drawer drawer;
}

private class Drawer : IRasterizePoint {
	final this(SoftwareRasterizer rasterizer) {
		this.rasterizer = rasterizer;
	}

	public void setAt(int x, int y) {
		rasterizer.image.setAt(SpatialVectorStruct!(2,int).make(x, y), true);
	}

	private SoftwareRasterizer rasterizer;
}
