module math.NumericSpatialVectors;

import std.stdio;

template NumericVector(uint Size, Type) {
    class NumericVector {
        //protected const Type NULL = cast(Type)0;

        protected const uint ALIGNMENTSIZE = ((Size/4) + ((Size % 4) != 0 ? 1 : 0)) * 4;

        public align(16) Type data[ALIGNMENTSIZE];
    }
}


// next generation from ProjectSci
/** \brief Template for a Position/Vector
 *
 */
template SpatialVector(uint Size, Type, bool Scalable = true) {
    class SpatialVector : NumericVector!(Size, Type) {
        final public this() {
        }

        final public this(Type[Size] parameter ...) {
            foreach( uint i; 0..Size ) {
                data[i] = parameter[i];
            }
        }

        final public SpatialVector!(Size, Type, Scalable) opBinary(string op)(Type rhs) {
            SpatialVector!(Size, Type, Scalable) result = new SpatialVector!(Size, Type, Scalable)();

            static if (op == "*") {
                static if (!Scalable) {
                    static assert(0, "SpatialVector is not scalable!");
                }

                result.data[0] = this.data[0] * rhs;
                result.data[1] = this.data[1] * rhs;

                static if (Size >= 3) {
                   result.data[2] = this.data[2] * rhs;
                }

                // TODO< size bigger than 3 >
                
                return result;
            }
            else {
                static assert(0, "Operator "~op~" not implemented");
            }
        }
        
        final public SpatialVector!(Size, Type, Scalable) opOpAssign(string op)(SpatialVector!(Size, Type, Scalable) rhs) {
            static if (op == "+") {
                this.data[0] += rhs.data[0];
                this.data[1] += rhs.data[1];

                static if (Size >= 3) {
                   this.data[2] += rhs.data[2];
                }

                // TODO< size bigger than 3 >
            }
            else static if (op == "-") {
                this.data[0] -= rhs.data[0];
                this.data[1] -= rhs.data[1];

                static if (Size >= 3) {
                   this.data[2] -= rhs.data[2];
                }

                // TODO< size bigger than 3 >
                
            }
            else {
                static assert(0, "Operator "~op~" not implemented");
            }

            return this;
        }

        final public SpatialVector!(Size, Type, Scalable) opBinary(string op)(SpatialVector!(Size, Type, Scalable) rhs) {
            SpatialVector!(Size, Type, Scalable) result = new SpatialVector!(Size, Type, Scalable)();

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

        static if (Size >= 3) {
            final @property Type z() {
                return this.data[2];
            }

            final @property Type z(Type value) {
                return this.data[2] = value;
            }
        }

        public final SpatialVector!(Size, Type, Scalable) clone() {
            return new SpatialVector!(Size, Type, Scalable)(data[0..Size]);
        }


        /*
        */


    }
}

// method for better readability
SpatialVector!(Size, Type) scale(uint Size, Type)(SpatialVector!(Size, Type) vector, Type magnitude) {
    return cast(SpatialVector!(Size, Type))(vector * magnitude);
}

import std.math : sqrt;

// TODO< implement for general case >
Type magnitude(Type)(SpatialVector!(3, Type) vector) {
	return cast(Type)sqrt(vector.magnitudeSquared());
}

// TODO< implement for general case >
Type magnitudeSquared(Type)(SpatialVector!(3, Type) vector) {
	return vector.x*vector.x + vector.y*vector.y + vector.z*vector.z;
}


SpatialVector!(Size, Type) normalized(uint Size, Type)(SpatialVector!(Size, Type) vector) {
	Type length = magnitude(vector);
	return vector.scale(cast(Type)1.0 / length);
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

SpatialVector!(3, Type) crossProduct(Type)(SpatialVector!(3, Type) a, SpatialVector!(3, Type) b) {
	Type x = a.data[1] * b.data[2] - a.data[2] * b.data[1];
	Type y = a.data[2] * b.data[0] - a.data[0] * b.data[2];
	Type z = a.data[0] * b.data[1] - a.data[1] * b.data[0];
	return new SpatialVector!(3, Type)(x, y, z);
}


/*
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


    public final this(Type x, Type y, Type z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    public final SpatialVector3!Type clone() {
        return new SpatialVector3!Type(x, y, z);
    }
}
*/