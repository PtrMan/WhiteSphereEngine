// just for copying code
/+
module NumericSpatialVectors;

template NumericVector(uint Size, Type) {
    class NumericVector {
        final public NumericVector!(Size, Type) opBinary(string op)(NumericVector!(Size, Type) rhs) {
            NumericVector!(Size, Type) result = new NumericVector!(Size, Type)();

            static if (op == "+") {
                result.data[0] = this.data[0] + rhs.data[0];
                result.data[1] = this.data[1] + rhs.data[1];

                static if (Size >= 3) {
                   result.data[2] = this.data[2] + rhs.data[2];
                }

                // TODO< size bigger than 3 >

                return result;
            }
            else static if (op == "-") {
                result.data[0] = this.data[0] - rhs.data[0];
                result.data[1] = this.data[1] - rhs.data[1];

                static if (Size >= 3) {
                   result.data[2] = this.data[2] - rhs.data[2];
                }

                // TODO< size bigger than 3 >
                
                return result;
            }
            else {
                static assert(0, "Operator "~op~" not implemented");
            }
        }

        static if(Size == 3) {
            final @property SpatialVector3!Type toSpatialVector3() {
                return cast(SpatialVector3!Type)this;
            }

            alias toSpatialVector3 this;
        }


        //protected const Type NULL = cast(Type)0;

        protected const uint ALIGNMENTSIZE = ((Size/4) + ((Size % 4) != 0 ? 1 : 0)) * 4;

        public align(16) Type data[ALIGNMENTSIZE];
    }
}


// next generation from ProjectSci
/** \brief Template for a Position/Vector
 *
 */
template SpatialVector(uint Size, Type) {
    class SpatialVector : NumericVector!(Size, Type) {
    }
}

// Only one copy of func needs to be written
SpatialVector!(Size, Type) scale(uint Size, Type)(SpatialVector!(Size, Type) vector, Type magnitude) {
    SpatialVector!(Size, Type) result = new SpatialVector!(Size, Type)();

    // TODO< help inlining >
    for(int i = 0; i < Size; i++ ) {
        result.data[i] = vector.data[i] * magnitude;
    }

    return result;
}

Type dot(uint Size, Type)(SpatialVector!(Size, Type) a, SpatialVector!(Size, Type) b) {
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



class SpatialVector2(Type) : SpatialVector!(2, Type) {
    final @property Type x() {
        return this.data[0];
    }

    final @property Type x(Type value) {
        return this.data[0] = value;
    }

    final @property Type y() {
        return this.data[1];
    }

    final @property Type y(Type value) {
        return this.data[1] = value;
    }

    public final this(Type x, Type y) {
        this.x = x;
        this.y = y;
    }

    public final SpatialVector2!Type clone() {
        return new SpatialVector2!Type(x, y);
    }
}

class SpatialVector3(Type) : SpatialVector!(3, Type) {
    final @property Type x() {
        return this.data[0];
    }

    final @property Type x(Type value) {
        return this.data[0] = value;
    }

    final @property Type y() {
        return this.data[1];
    }

    final @property Type y(Type value) {
        return this.data[1] = value;
    }

    final @property Type z() {
        return this.data[2];
    }

    final @property Type z(Type value) {
        return this.data[2] = value;
    }


    public final this(Type x, Type y, Type z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    public final SpatialVector3!Type clone() {
        return new SpatialVector3!Type(x, y, z);
    }
}
+/