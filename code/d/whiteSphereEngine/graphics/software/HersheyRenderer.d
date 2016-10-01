module whiteSphereEngine.graphics.software.HersheyRenderer;

import whiteSphereEngine.graphics.software.SoftwareRasterizer;
import whiteSphereEngine.graphics.font.Hershey : hersheyInterpreter, EnumHersheyCommandType = EnumType;

import linopterixed.linear.Vector : SpatialVectorStruct, componentMultiplication;

import std.file : readText;
import std.array : split;

// renders the hershey "font" with our software rasterizer
class HersheyRenderer {
	// TODO LOW< maybe we should pass in a transformation matrix? >
	final void renderCommandAtIndex(SoftwareRasterizer rasterizer, uint index, SpatialVectorStruct!(2,float) center, SpatialVectorStruct!(2,float) scale, out float leftScaled, out float rightScaled) {
		string commands;

		string indexCommands() @safe {
			return hersheyCommands[index];
		}

		commands = indexCommands();

		hersheyRendererDriver.rasterizer = rasterizer;
		hersheyRendererDriver.center = center;
		hersheyRendererDriver.scale = scale;

		// render it
		hersheyInterpreter(commands, hersheyRendererDriver);

		leftScaled = hersheyRendererDriver.positionLeft * scale.x;
		rightScaled = hersheyRendererDriver.positionRight * scale.x;
	}

	final void load() {
		hersheyCommands = readText("resources/engine/graphics/font/hershey").split("\n");
	}

	private string[] hersheyCommands;
	private SoftwareRendererDriver *hersheyRendererDriver = new SoftwareRendererDriver;
}

private struct SoftwareRendererDriver {
	float positionLeft, positionRight;
	SoftwareRasterizer rasterizer;
	SpatialVectorStruct!(2,float) center, scale;

	SpatialVectorStruct!(2,float) lastPosition;

	final void raise() {
		// we just ignore it
	}

	final void command(EnumHersheyCommandType commandType, float x, float y) {
		SpatialVectorStruct!(2,float) currentPosition = SpatialVectorStruct!(2,float).make(x, y).componentMultiplication(scale) + center;

		if( commandType == EnumHersheyCommandType.MOVE ) {
			lastPosition = currentPosition;
			return;
		}

		// TODO< put vector conversion into math >
		SpatialVectorStruct!(2,int) aInt = SpatialVectorStruct!(2,int).make(cast(int)lastPosition.x, cast(int)lastPosition.y);
		SpatialVectorStruct!(2,int) bInt = SpatialVectorStruct!(2,int).make(cast(int)currentPosition.x, cast(int)currentPosition.y);

		rasterizer.drawLine(aInt, bInt);
		lastPosition = currentPosition;
	}

	final void setPositions(float left, float right) {
		positionLeft = left;
		positionRight = right;
	}
}
