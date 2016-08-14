module graphics.MeshComponent;

import core.memory : GC;

// A isomporphism (in enlish it is equal to) for a buffer for a attribute of an vertex of an mesh
class MeshComponent {
	enum EnumType {
		FLOAT4,
		DOUBLE4,
	}
	
	protected struct Value {
		union {
			float[4] floatValue;
			double[4] doubleValue;
		}
	}
	
	// arr is usually GC allocated memory with nonscanning flag
	public static MeshComponent makeFloat4(float[4]* arr, size_t length) {
		MeshComponent result = new MeshComponent(EnumType.FLOAT4);
		
		// we don't want to scan this memory because there are no ptr's
		result.array = cast(Value*)GC.malloc(Value.sizeof * length, GC.BlkAttr.NO_SCAN);
		
		foreach( i; 0..length ) {
			result.array[i].floatValue = arr[i];
		}
		
		return result;
	}
	
	// arr is usually GC allocated memory with nonscanning flag
	public static MeshComponent makeDouble4(double[4]* arr, size_t length) {
		MeshComponent result = new MeshComponent(EnumType.DOUBLE4);
		
		// we don't want to scan this memory because there are no ptr's
		result.array = cast(Value*)GC.malloc(Value.sizeof * length, GC.BlkAttr.NO_SCAN);
		
		foreach( i; 0..length ) {
			result.array[i].doubleValue = arr[i];
		}
		
		return result;
	}

	
	// disable ctor
	protected final this(EnumType type) {
		this.protectedType = type;
	}
	
	
	// not static
	public class Float4Accessor {
		public final float[4] opIndex(size_t index) {
			assert(index < length);
			// no need to check type because this accessor can only get retrived by getFloatAccessor
			
			return array[index].floatValue;
		}
	}
	
	// not static
	public class Double4Accessor {
		public final double[4] opIndex(size_t index) {
			assert(index < length);
			// no need to check type because this accessor can only get retrived by getFloatAccessor
			
			return array[index].doubleValue;
		}
	}
	
	
	public final Float4Accessor getFloat4Accessor() {
		assert(type == EnumType.FLOAT4);
		return new Float4Accessor;
	}
	
	public final Double4Accessor getDouble4Accessor() {
		assert(type == EnumType.DOUBLE4);
		return new Double4Accessor;
	}
	
	public final @property EnumType type() {
		return protectedType;
	}
	
	package size_t length; // used for range checks
	package Value* array; // usually allocated in nonscanned GC memory
	protected EnumType protectedType;
}

/* uncommented because we dont need this class
class MeshComponentModifier {
	public final this(MeshComponent meshComponent) {
		this.meshComponent = meshComponent;
	}
	
	protected MeshComponent meshComponent;
}*/