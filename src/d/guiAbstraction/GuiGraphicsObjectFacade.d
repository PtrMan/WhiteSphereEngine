module guiAbstraction.GuiGraphicsObjectFacade;

import math.NumericSpatialVectors;
import math.VectorAlias;

import graphics;
import graphics.MeshComponentConverter;

/** 
 * is used to return certain GraphicsObjects which are needed by the GUI code
 * GUI components hold their GraphicsObject as long as they want and return it to either the engine or a pool of meshes over this Facade
 *
 */
class GuiGraphicsObjectFacade {
	// description of a object which should be created or returned with some GUI properties
	static struct Description {
		enum EnumType {
			BUTTON, // button with the sharph corners
			SIGN, // sign for the text rendering 
		}
		
		EnumType type;
	}
	
	final this(AbstractGraphicsEngine graphicsEngine) {
		this.graphicsEngine = graphicsEngine;
	}
	
	final GraphicsObject giveGraphicsObjectByDescription(Description description) {
		final switch( description.type ) with(Description.EnumType) {
			case SIGN: return graphicsEngine.createGraphicsObject(decoratedMeshForSign);
			case BUTTON: assert(false, "BUTTON not implemented, TODO");
		}
	}
	
	final void returnGraphicsObjectByDescription(GraphicsObject graphicsObject, Description description) {
		graphicsEngine.disposeGraphicsObject(graphicsObject);
	}
	
	final void initialize() {
		{ // make decorated mesh for sign(s)
			final size_t positionComponentIndex = 0;
			
			AbstractMeshComponent positionComponent, relativeTextureComponent;
			positionComponent = relativeTextureComponent = toImmutableMeshComponent([new Vector4p(0.0, 0.0, 0.0, 0.0), new Vector4p(1.0, 0.0, 0.0, 0.0), new Vector4p(1.0, 1.0, 0.0, 0.0), new Vector4p(0.0, 1.0, 0.0, 0.0)]);
			AbstractMeshComponent indexMeshComponent = ImmutableMeshComponent.makeUint32([0, 1, 2, 0, 2, 3]);
			
			Mesh signMesh = new Mesh([positionComponent, relativeTextureComponent], indexMeshComponent, positionComponentIndex);
			
			decoratedMeshForSign = graphicsEngine.createMeshWithDecorationForMesh(signMesh);
		}
		
	}
	
	final void dispose() {
		graphicsEngine.disposeMeshWithDecoration(decoratedMeshForSign);
	}
	
	protected AbstractDecoratedMesh decoratedMeshForSign;
	
	
	protected AbstractGraphicsEngine graphicsEngine;
}