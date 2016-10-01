import whiteSphereEngine.graphics.software.HersheyRenderer;
import whiteSphereEngine.graphics.software.SoftwareRasterizer;

import linopterixed.linear.Vector : SpatialVectorStruct;

// for debugging
import std.stdio;

void main() {
	SoftwareRasterizer rasterizer = new SoftwareRasterizer;

	HersheyRenderer hersheyRenderer = new HersheyRenderer;
	hersheyRenderer.load();

	rasterizer.setRenderSize(SpatialVectorStruct!(2,int).make(32,32));

	float leftScaled, rightScaled;

	SpatialVectorStruct!(2,float) center = SpatialVectorStruct!(2,float).make(16.0f, 16.0f);
	SpatialVectorStruct!(2,float) scale = SpatialVectorStruct!(2,float).make(1.0f, 1.0f);

	int index = 1;
	hersheyRenderer.renderCommandAtIndex(rasterizer, 1, center, scale, /*out*/leftScaled, /*out*/rightScaled);

	//rasterizer.drawLine(SpatialVectorStruct!(2,int).make(1,1), SpatialVectorStruct!(2,int).make(5,7));

	// debug image

	foreach( y; 0..rasterizer.image.height ) {
		foreach( x; 0..rasterizer.image.width ) {
			const bool pixel = rasterizer.image.getAt(SpatialVectorStruct!(2,int).make(x,y));
			write(pixel ? "x" : " ");
		}

		writeln();
	}
}
