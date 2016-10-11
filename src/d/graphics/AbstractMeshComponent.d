module graphics.AbstractMeshComponent;

import core.stdc.stdint;

// A isomporphism (in enlish it is equal to) for a buffer for a attribute of an vertex of an mesh
// can be mutable or immutable to allow the engine to optimize certain things
abstract class AbstractMeshComponent {
	enum EnumDataType {
		FLOAT4,
		FLOAT2,
		DOUBLE4,
		UINT32,
	}
	
	enum EnumType {
		MUTABLE,
		IMMUTABLE
	}
	
	
	public final this(EnumDataType dataType, EnumType type) {
		this.dataType = dataType;
		this.type = type;
	}
	
	public abstract class Float4Accessor {
		public abstract float[4] opIndex(size_t index);
	}

	public abstract class Float2Accessor {
		public abstract float[2] opIndex(size_t index);
	}
	
	public abstract class Double4Accessor {
		public abstract double[4] opIndex(size_t index);
	}
	
	public abstract class Uint32Accessor {
		public abstract uint32_t opIndex(size_t index);
	}
	
	public abstract Float4Accessor getFloat4Accessor();
	public abstract Float2Accessor getFloat2Accessor();
	public abstract Double4Accessor getDouble4Accessor();
	public abstract Uint32Accessor getUint32Accessor();
	
	public abstract @property size_t length();
	
	public immutable(EnumDataType) dataType;
	public immutable(EnumType) type;
}