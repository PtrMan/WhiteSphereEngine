module graphics.Mesh;

import graphics.MeshComponent;

class Mesh {
	public final this(MeshComponent[] meshComponents, size_t positionComponentIndex) {
		assert(positionComponentIndex < meshComponents.length);
		checkMeshComponentsHaveEqualSize(meshComponents);
		
		this.protectedMeshComponents = meshComponents;
		this.positionComponentIndex = positionComponentIndex;
		cacheMeshComponentAccessors();
	}
	
	protected static checkMeshComponentsHaveEqualSize(MeshComponent[] meshComponents) {
		assert(meshComponents.length > 0);
		
		size_t lengthOfFirstComponent = meshComponents[0].length;
		
		foreach( iterationComponent; meshComponents ) {
			// TODO< should be an exception >
			assert(iterationComponent.length == lengthOfFirstComponent);
		}
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
	
	final public @property size_t numberOfVertices() {
		if( cachedFloat4Accessors[positionComponentIndex] !is null ) {
			return protectedMeshComponents[positionComponentIndex].length;
		}
		else if( cachedDouble4Accessors[positionComponentIndex] !is null ) {
			return protectedMeshComponents[positionComponentIndex].length;
		}
		
		assert(false);
	}
	
	
	// members are not changable from the outside after setting them
	protected MeshComponent[] protectedMeshComponents;
	protected MeshComponent.Float4Accessor[] cachedFloat4Accessors; // elements are null for non-float4
	protected MeshComponent.Double4Accessor[] cachedDouble4Accessors; // elements are null for non-float4
	
	
	protected size_t positionComponentIndex;
}
