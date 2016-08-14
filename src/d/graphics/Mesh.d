module graphics.Mesh;

import graphics.MeshComponent;

class Mesh {
	public final this(MeshComponent[] meshComponents, size_t positionComponentIndex) {
		assert(positionComponentIndex < meshComponents.length);
		
		this.protectedMeshComponents = meshComponents;
		this.positionComponentIndex = positionComponentIndex;
		cacheMeshComponentAccessors();
	}
	
	final protected void cacheMeshComponentAccessors() {
		cachedFloat4Accessors.length = numberOfComponents;
		cachedDouble4Accessors.length = numberOfComponents;
		
		foreach( i, iterationComponent; protectedMeshComponents ) {
			final switch( iterationComponent.type ) with(MeshComponent.EnumType) {
				case FLOAT4:
				cachedFloat4Accessors[i] = iterationComponent.getFloat4Accessor();
				break;
				
				case DOUBLE4:
				cachedDouble4Accessors[i] = iterationComponent.getDouble4Accessor();
				break;
			}
		}
	}
	
	final protected @property numberOfComponents() {
		return protectedMeshComponents.length;
	}
	
	final public MeshComponent.Float4Accessor getFloat4AccessorForComponentIndex(size_t index) {
		assert(cachedFloat4Accessors[index] !is null);
		return cachedFloat4Accessors[index];
	}
	
	final public MeshComponent.Double4Accessor getDouble4AccessorForComponentIndex(size_t index) {
		assert(cachedDouble4Accessors[index] !is null);
		return cachedDouble4Accessors[index];
	}
	
	final public @property MeshComponent.Double4Accessor double4PositionAccessor() {
		return getDouble4AccessorForComponentIndex(positionComponentIndex);
	}
	
	final public @property MeshComponent.Float4Accessor float4PositionAccessor() {
		return getFloat4AccessorForComponentIndex(positionComponentIndex);
	}
	
	
	// members are not changable from the outside after setting them
	protected MeshComponent[] protectedMeshComponents;
	protected MeshComponent.Float4Accessor[] cachedFloat4Accessors; // elements are null for non-float4
	protected MeshComponent.Double4Accessor[] cachedDouble4Accessors; // elements are null for non-float4
	
	
	protected size_t positionComponentIndex;
}
