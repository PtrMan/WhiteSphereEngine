module graphics.ImmutableMeshComponent;

import core.stdc.stdint;

import graphics.AbstractMeshComponent;
import linopterixed.linear.Vector;



// A isomporphism (in enlish it is equal to) for a buffer for a attribute of an vertex of an mesh
// is immutable, which allows the engine to potentially do some optimisations
class ImmutableMeshComponent : AbstractMeshComponent {
	public struct Value {
		public final this(float[4] floatValue) {
			this.floatValue = floatValue;
		}
		
		public final this(uint32_t uint32Value) {
			this.uint32Value = uint32Value;
		}
		
		public final this(double[4] doubleValue) {
			this.doubleValue = doubleValue;
		}
		
		
		union {
			float[4] floatValue;
			double[4] doubleValue;
			uint32_t uint32Value;
		}
	}
	
	protected final this(AbstractMeshComponent.EnumDataType dataType, immutable(Value[]) array) {
		super(dataType, AbstractMeshComponent.EnumType.IMMUTABLE);
		this.array = array;
	}
	
	
	public static ImmutableMeshComponent makeUint32(uint32_t[] arr) {
		Value[] tempArray;
		tempArray.length = arr.length;
		foreach( i; 0..arr.length ) {
			tempArray[i] = Value(arr[i]);
		}
		// note that we copy the whole array here, might be a bit heavy on the GC and CPU, we'll see
		return new ImmutableMeshComponent(AbstractMeshComponent.EnumDataType.UINT32, cast(immutable(Value[]))tempArray.dup);
	}
	
	public static ImmutableMeshComponent makeFloat4(float[4][] arr) {
		Value[] tempArray;
		tempArray.length = arr.length;
		foreach( i; 0..arr.length ) {
			tempArray[i] = Value(arr[i]);
		}
		// note that we copy the whole array here, might be a bit heavy on the GC and CPU, we'll see
		return new ImmutableMeshComponent(AbstractMeshComponent.EnumDataType.FLOAT4, cast(immutable(Value[]))tempArray.dup);
	}

	
	/+
	// arr is usually GC allocated memory with nonscanning flag
	public static MeshComponent makeUint32(uint32_t* arr, size_t length) {
		MeshComponent result = new MeshComponent(EnumType.UINT32);
		
		// we don't want to scan this memory because there are no ptr's
		result.array = cast(Value*)GC.malloc(Value.sizeof * length, GC.BlkAttr.NO_SCAN);
		result.protectedLength = length;
		
		foreach( i; 0..length ) {
			result.array[i].uint32Value = arr[i];
		}
		
		return result;
	}
	+/
	
		/+

	// arr is usually GC allocated memory with nonscanning flag
	public static MeshComponent makeFloat4(float[4]* arr, size_t length) {
		MeshComponent result = new MeshComponent(EnumType.FLOAT4);
		
		// we don't want to scan this memory because there are no ptr's
		result.array = cast(Value*)GC.malloc(Value.sizeof * length, GC.BlkAttr.NO_SCAN);
		result.protectedLength = length;
		
		foreach( i; 0..length ) {
			result.array[i].floatValue = arr[i];
		}
		
		return result;
	}
	
	public static MeshComponent makeFloat4(SpatialVector!(4, float)[] arr) {
		MeshComponent result = new MeshComponent(EnumType.FLOAT4);
		
		// we don't want to scan this memory because there are no ptr's
		result.array = cast(Value*)GC.malloc(Value.sizeof * arr.length, GC.BlkAttr.NO_SCAN);
		result.protectedLength = arr.length;
		
		foreach( i; 0..arr.length ) {
			foreach( j; 0..4 ) {
				result.array[i].floatValue[j] = arr[i].data[j];
			}
		}
		
		return result;
	}
	
	
	
	// arr is usually GC allocated memory with nonscanning flag
	public static MeshComponent makeDouble4(double[4]* arr, size_t length) {
		MeshComponent result = new MeshComponent(EnumType.DOUBLE4);
		
		// we don't want to scan this memory because there are no ptr's
		result.array = cast(Value*)GC.malloc(Value.sizeof * length, GC.BlkAttr.NO_SCAN);
		result.protectedLength = length;
		
		foreach( i; 0..length ) {
			result.array[i].doubleValue = arr[i];
		}
		
		return result;
	}
	
	public static MeshComponent makeDouble4(SpatialVector!(4, double)[] arr) {
		MeshComponent result = new MeshComponent(EnumType.DOUBLE4);
		
		// we don't want to scan this memory because there are no ptr's
		result.array = cast(Value*)GC.malloc(Value.sizeof * arr.length, GC.BlkAttr.NO_SCAN);
		result.protectedLength = arr.length;
		
		foreach( i; 0..arr.length ) {
			foreach( j; 0..4 ) {
				result.array[i].doubleValue[j] = arr[i].data[j];
			}
		}
		
		return result;
	}
	
	
	
	
	+/
	
	
	// not static
	public class Float4Accessor : AbstractMeshComponent.Float4Accessor {
		public final this() {}
		
		public override float[4] opIndex(size_t index) {
			assert(index < length);
			// no need to check type because this accessor can only get retrived by getFloatAccessor
			
			return array[index].floatValue;
		}
	}
	
	// not static
	public class Double4Accessor : AbstractMeshComponent.Double4Accessor {
		public final this() {}
		
		public override double[4] opIndex(size_t index) {
			assert(index < length);
			// no need to check type because this accessor can only get retrived by getFloatAccessor
			
			return array[index].doubleValue;
		}
	}
	
	// not static
	public class Uint32Accessor : AbstractMeshComponent.Uint32Accessor {
		public final this() {}
		
		public override uint32_t opIndex(size_t index) {
			assert(index < length);
			// no need to check type because this accessor can only get retrived by getFloatAccessor
			
			return array[index].uint32Value;
		}
	}

	
	public override AbstractMeshComponent.Float4Accessor getFloat4Accessor() {
		assert(dataType == EnumDataType.FLOAT4);
		return new Float4Accessor;
	}
	
	public override AbstractMeshComponent.Double4Accessor getDouble4Accessor() {
		assert(dataType == EnumDataType.DOUBLE4);
		return new Double4Accessor;
	}
	
	public override AbstractMeshComponent.Uint32Accessor getUint32Accessor() {
		assert(dataType == EnumDataType.UINT32);
		return new Uint32Accessor;
	}
	
	
	public override @property size_t length() {
		return array.length;
	}
	
	public immutable(Value[]) array;
}

/* uncommented because we dont need this class
class MeshComponentModifier {
	public final this(MeshComponent meshComponent) {
		this.meshComponent = meshComponent;
	}
	
	protected MeshComponent meshComponent;
}*/