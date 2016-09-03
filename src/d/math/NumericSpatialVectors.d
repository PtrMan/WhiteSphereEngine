module math.NumericSpatialVectors;

import core.simd;

private mixin template SpatialVectorMixin(bool isClass) {
	protected const uint ALIGNMENTSIZE = ((Size/4) + ((Size % 4) != 0 ? 1 : 0)) * 4;

	protected enum ISSIMDDOUBLE4ARRAY = is(Type==double) && is(double4);
	protected enum ISSIMDFLOAT4ARRAY = is(Type==float) && is(float4);
	protected enum ISSIMDARRAY = ISSIMDDOUBLE4ARRAY || ISSIMDFLOAT4ARRAY;

	static if( ISSIMDDOUBLE4ARRAY || ISSIMDFLOAT4ARRAY ) {
		static if ( ISSIMDDOUBLE4ARRAY ) {
			protected align(16) double4 vectorArray[ALIGNMENTSIZE/4];
		}
		else static if ( ISSIMDFLOAT4ARRAY ) {
			protected align(16) float4 vectorArray[ALIGNMENTSIZE/4];
		}
	}
	else {
		protected align(16) Type array[ALIGNMENTSIZE];
	}


	// accessors for value access
	final Type opIndexAssign(Type value, size_t index) {
		static if( ISSIMDARRAY ) {
			return vectorArray[index/4].array[index%4] = value;
		}
		else {
			return array[index] = value;
		}
	}
		
	final Type opIndex(size_t index) const {
		static if( ISSIMDARRAY ) {
			return vectorArray[index/4].array[index%4];
		}
		else {
			return array[index];
		}
	}


    final typeof(this) opBinary(string op)(Type rhs) const {
    	ThisType result;
    	static if( isClass ) {
    		result = new ThisType;
    	}

        static if (op == "*") {
            static if (!Scalable) {
                static assert(0, "SpatialVector is not scalable!");
            }

            foreach( i; 0..Size ) {
                result[i] = this[i] * rhs;
            }
            
            return result;
        }
        else {
            static assert(0, "Operator "~op~" not implemented");
        }
    }
    
    final typeof(this) opOpAssign(string op)(typeof(this) rhs) {
        static if (op == "+") {
        	static if( ISSIMDARRAY && __traits(compiles, this.vectorArray[0]+=rhs.vectorArray[0]) ) {
        		foreach( i; 0..Size/4 ) {
        			this.vectorArray[i]+=rhs.vectorArray[i];
        		}
        	}
        	else {
	            foreach( i; 0..Size ) {
	                this.array[i] += rhs.array[i];
	            }
        	}
        }
        else static if (op == "-") {
            static if( ISSIMDARRAY && __traits(compiles, this.vectorArray[0]-=rhs.vectorArray[0]) ) {
        		foreach( i; 0..Size/4 ) {
        			this.vectorArray[i]-=rhs.vectorArray[i];
        		}
        	}
        	else {
	            foreach( i; 0..Size ) {
	                this.array[i] -= rhs.array[i];
	            }
        	}
        }
        else {
            static assert(0, "Operator "~op~" not implemented");
        }

        return this;
    }

    final typeof(this) opBinary(string op)(typeof(this) rhs) {
        typeof(this) result;
        static if( isClass ) {
    		result = new typeof(this)();
    	}

        static if (op == "+") {
        	static if( ISSIMDARRAY && __traits(compiles, this.vectorArray[0]+rhs.vectorArray[0]) ) {
        		foreach( i; 0..Size/4 ) {
        			result.vectorArray[i] = this.vectorArray[i]+rhs.vectorArray[i];
        		}
        	}
        	else {
	            foreach( i; 0..Size ) {
	                result.array[i] = this.array[i] + rhs.array[i];
	            }
        	}

            return result;
        }
        else static if (op == "-") {
            static if( ISSIMDARRAY && __traits(compiles, this.vectorArray[0]-rhs.vectorArray[0]) ) {
        		foreach( i; 0..Size/4 ) {
        			result.vectorArray[i] = this.vectorArray[i]-rhs.vectorArray[i];
        		}
        	}
        	else {
	            foreach( i; 0..Size ) {
	                result.array[i] = this.array[i] - rhs.array[i];
	            }
        	}

            return result;
        }
        else {
            static assert(0, "Operator "~op~" not implemented");
        }
    }


    final @property Type x() const {
        return this[0];
    }

    final @property Type x(Type value) {
        return this[0] = value;
    }

    final @property Type y() const {
        return this[1];
    }

    final @property Type y(Type value) {
        return this[1] = value;
    }

    static if (Size >= 3) {
        final @property Type z() const {
            return this[2];
        }

        final @property Type z(Type value) {
            return this[2] = value;
        }
    }
    
    static if (Size >= 4) {
        final @property Type w() const {
            return this[3];
        }

        final @property Type w(Type value) {
            return this[3] = value;
        }
    }
}

// next generation from ProjectSci
/** \brief Template for a Position/Vector
 *
 */
template SpatialVector(uint Size, Type, bool Scalable = true) {
    class SpatialVector {
        alias Type ComponentType;
        private alias SpatialVector!(Size, Type, Scalable) ThisType;

    	mixin SpatialVectorMixin!true;
    	
        final this() {
        }

        final this(Type[Size] parameter ...) {
            foreach( size_t i; 0..Size ) {
                this[i] = parameter[i];
            }
        }

        


        final SpatialVector!(Size, Type, Scalable) clone() {
        	Type[Size] array;
        	foreach( i; 0..Size ) {
        		array[i] = this[i];
        	}

            return new SpatialVector!(Size, Type, Scalable)(array);
        }

        /* uncommented because we can't anymore access the raw pointer easily, because its either an array or an array of vectors
		final @property Type* ptr() {
			return data.ptr;
		}
		*/
    }
}

template SpatialVectorStruct(uint Size, Type, bool Scalable = true) {
    struct SpatialVectorStruct {
        private alias SpatialVectorStruct!(Size, Type, Scalable) ThisType;
        alias Type ComponentType;
    	
        mixin SpatialVectorMixin!false;

        final void opAssign(typeof(this) rhs) {
            foreach( i; 0..Size ) {
                this[i] = rhs[i];
            }
        }

        final ThisType clone() {
            ThisType result;

            foreach( i; 0..Size ) {
                result[i] = this[i];
            }
            return result;
        }

        /* uncommented because we can't anymore access the raw pointer easily, because its either an array or an array of vectors
        final @property Type* ptr() {
            return data.ptr;
        }
        */
    }
}

unittest {
    alias SpatialVector!(5, float) VectorType;
    { // addition
        VectorType vecA, vecB, vecResult;
        vecA = new VectorType();
        vecB = new VectorType();
        vecA[0] = 1.0f;
        vecB[0] = 2.0f;
        vecA[4] = 4.0f;
        vecB[4] = 8.0f;
        vecResult = vecA + vecB;
        assert(vecResult[0] == 3.0f);
        assert(vecResult[4] == 12.0f);
    }

    { // mul
        VectorType vecB, vecResult;
        vecB = new VectorType();
        vecB[0] = 2.0f;
        vecB[4] = 8.0f;
        vecResult = vecB*4.0f;
        assert(vecResult[0] == 8.0f);
        assert(vecResult[4] == 32.0f);
    }
}


unittest {
    alias SpatialVectorStruct!(5, float) VectorType;
    { // addition
        VectorType vecA, vecB;
        vecA[0] = 1.0f;
        vecB[0] = 2.0f;
        vecA[4] = 4.0f;
        vecB[4] = 8.0f;
        VectorType vecResult = vecA + vecB;
        assert(vecResult[0] == 3.0f);
        assert(vecResult[4] == 12.0f);
    }

    { // mul
        VectorType vecB;
        vecB[0] = 2.0f;
        vecB[4] = 8.0f;
        VectorType vecResult = vecB*4.0f;
        assert(vecResult[0] == 8.0f);
        assert(vecResult[4] == 32.0f);
    }
}

SpatialVector!(Size, Type) componentDivision(uint Size, Type)(SpatialVector!(Size, Type) vector, SpatialVector!(Size, Type) divisorVector) {
	return new SpatialVector!(Size, Type)(vector.x / divisorVector.x, vector.y / divisorVector.y, vector.z / divisorVector.z);
}


// method for better readability
SpatialVector!(Size, Type, true) scale(uint Size, Type)(SpatialVector!(Size, Type, true) vector, Type magnitude) {
    return cast(SpatialVector!(Size, Type, true))(vector * magnitude);
}
SpatialVectorStruct!(Size, Type, true) scale(uint Size, Type)(SpatialVectorStruct!(Size, Type, true) vector, Type magnitude) {
    return cast(SpatialVectorStruct!(Size, Type, true))(vector * magnitude);
}

import std.math : sqrt;

Type magnitude(Type, uint Size, bool Scalable)(SpatialVector!(Size, Type, Scalable) vector) {
	return cast(Type)sqrt(vector.magnitudeSquared());
}
Type magnitude(Type, uint Size, bool Scalable)(SpatialVectorStruct!(Size, Type, Scalable) vector) {
    return cast(Type)sqrt(vector.magnitudeSquared());
}

// TODO< implement for general case >

Type magnitudeSquared(Type)(SpatialVector!(Size, Type, Scalable) vector) {
	return dot(vector, vector);
}
Type magnitudeSquared(Type)(SpatialVectorStruct!(Size, Type, Scalable) vector) {
    return dot(vector, vector);
}


SpatialVector!(Size, Type) normalized(uint Size, Type)(SpatialVector!(Size, Type) vector) {
	Type length = magnitude(vector);
	return vector.scale(cast(Type)1.0 / length);
}
SpatialVectorStruct!(Size, Type) normalized(uint Size, Type)(SpatialVectorStruct!(Size, Type) vector) {
    Type length = magnitude(vector);
    return vector.scale(cast(Type)1.0 / length);
}

// TODO< put this into the mixin class and optimize it using core.simd intrinsics or LDC LLVM inline magic >
Type dot(uint Size, Type, bool Scalable)(SpatialVector!(Size, Type, Scalable) a, SpatialVector!(Size, Type, Scalable) b) {
    Type result = cast(Type)0;

    // NOTE< compiler is as of v2.063 too stupid to optimize this
    /*foreach( Index; 0..2 )
    {
        result = result + a.data[Index]*Other.data[Index];
    }*/

    result = result + a.data[0]*b.data[0];
    result = result + a.data[1]*b.data[1];

    static if( Size >= 3 ) {
        result = result + a.data[2]*b.data[2];
    }

    // TODO< size bigger than 3

    return result;
}

Type dot(uint Size, Type, bool Scalable)(SpatialVectorStruct!(Size, Type, Scalable) a, SpatialVectorStruct!(Size, Type, Scalable) b) {
    Type result = cast(Type)0;

    // NOTE< compiler is as of v2.063 too stupid to optimize this
    /*foreach( Index; 0..2 )
    {
        result = result + a.data[Index]*Other.data[Index];
    }*/

    result = result + a.data[0]*b.data[0];
    result = result + a.data[1]*b.data[1];

    static if( Size >= 3 ) {
        result = result + a.data[2]*b.data[2];
    }

    // TODO< size bigger than 3

    return result;
}

SpatialVector!(3, Type, Scalable) crossProduct(Type, Scalable)(SpatialVector!(3, Type, Scalable) a, SpatialVector!(3, Type, Scalable) b) {
	Type x = a.data[1] * b.data[2] - a.data[2] * b.data[1];
	Type y = a.data[2] * b.data[0] - a.data[0] * b.data[2];
	Type z = a.data[0] * b.data[1] - a.data[1] * b.data[0];
	return new SpatialVector!(3, Type, Scalable)(x, y, z);
}
