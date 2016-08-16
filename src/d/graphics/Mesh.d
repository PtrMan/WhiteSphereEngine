module graphics.Mesh;

import graphics.AbstractMeshComponent;

class Mesh {
	public final this(AbstractMeshComponent[] meshComponents, AbstractMeshComponent indexMeshComponent, size_t positionComponentIndex) {
		assert(positionComponentIndex < meshComponents.length);
		checkMeshComponentsHaveEqualSize(meshComponents);
		
		this.protectedIndexMeshComponent = indexMeshComponent;
		this.protectedMeshComponents = meshComponents;
		this.positionComponentIndex = positionComponentIndex;
		
		assert(indexMeshComponent.dataType == AbstractMeshComponent.EnumDataType.UINT32);
		cacheMeshComponentAccessors();
		checkIndexComponentIndicesInRange(indexMeshComponent, numberOfVertices);
	}
	
	protected static checkMeshComponentsHaveEqualSize(AbstractMeshComponent[] meshComponents) {
		assert(meshComponents.length > 0);
		
		size_t lengthOfFirstComponent = meshComponents[0].length;
		
		foreach( iterationComponent; meshComponents ) {
			// TODO< should be an exception >
			assert(iterationComponent.length == lengthOfFirstComponent);
		}
	}
	
	protected static checkIndexComponentIndicesInRange(AbstractMeshComponent indexMeshComponent, size_t numberOfVertices) {
		AbstractMeshComponent.Uint32Accessor accessor = indexMeshComponent.getUint32Accessor();
		foreach( i; 0..indexMeshComponent.length ) {
			// TODO< should throw exception on missmatch >
			assert(accessor[i] < numberOfVertices);
		}
	}

	
	
	
	final protected void cacheMeshComponentAccessors() {
		cachedFloat4Accessors.length = numberOfComponents;
		cachedDouble4Accessors.length = numberOfComponents;
		
		foreach( i, iterationComponent; protectedMeshComponents ) {
			final switch( iterationComponent.dataType ) with(AbstractMeshComponent.EnumDataType) {
				case FLOAT4:
				cachedFloat4Accessors[i] = iterationComponent.getFloat4Accessor();
				break;
				
				case DOUBLE4:
				cachedDouble4Accessors[i] = iterationComponent.getDouble4Accessor();
				break;
				
				case UINT32:
				assert(false, "Not jet supported cache of accessors for UINT32 component");
				break;
			}
		}
	}
	
	final protected @property numberOfComponents() {
		return protectedMeshComponents.length;
	}
	
	final public AbstractMeshComponent.Uint32Accessor getUint32AccessorForIndexBuffer() {
		return protectedIndexMeshComponent.getUint32Accessor();
	}
	
	final public AbstractMeshComponent.Float4Accessor getFloat4AccessorByComponentIndex(size_t index) {
		assert(cachedFloat4Accessors[index] !is null);
		return cachedFloat4Accessors[index];
	}
	
	final public AbstractMeshComponent.Double4Accessor getDouble4AccessorByComponentIndex(size_t index) {
		assert(cachedDouble4Accessors[index] !is null);
		return cachedDouble4Accessors[index];
	}
	
	final public @property AbstractMeshComponent.Double4Accessor double4PositionAccessor() {
		return getDouble4AccessorByComponentIndex(positionComponentIndex);
	}
	
	final public @property AbstractMeshComponent.Float4Accessor float4PositionAccessor() {
		return getFloat4AccessorByComponentIndex(positionComponentIndex);
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
	
	final public @property AbstractMeshComponent indexBufferMeshComponent() {
		return protectedIndexMeshComponent;
	}
	
	
	// members are not changable from the outside after setting them
	protected AbstractMeshComponent protectedIndexMeshComponent;
	protected AbstractMeshComponent[] protectedMeshComponents;
	protected AbstractMeshComponent.Float4Accessor[] cachedFloat4Accessors; // elements are null for non-float4
	protected AbstractMeshComponent.Double4Accessor[] cachedDouble4Accessors; // elements are null for non-float4
	
	protected size_t positionComponentIndex;
}
