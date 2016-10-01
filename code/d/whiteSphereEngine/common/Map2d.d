module whiteSphereEngine.common.Map2d;

import whiteSphereEngine.common.IMap2d : IMap2d;
import linopterixed.linear.Vector;

class Map2d(Type, bool checkRange) : IMap2d!Type {
    public final this(uint width, uint height) {
        privateWidth = width;
        privateHeight = height;

        array = new Type[width*height];
    }

    public final void setAt(SpatialVectorStruct!(2,int) position, Type value) {
        static if( checkRange ) {
            if( position.x < 0 || position.x >= privateWidth || position.y < 0 || position.y >= privateHeight ) {
                return;
            }
        }

        array[position.x + position.y * width] = value;
    }

    public final Type getAt(SpatialVectorStruct!(2,int) position) pure const {
        static if( checkRange ) {
            if( position.x < 0 || position.x >= privateWidth || position.y < 0 || position.y >= privateHeight ) {
                return Type.init;
            }
        }

        return array[position.x + position.y * width];
    }

    public final @property uint width() pure const {
        return privateWidth;
    }

    public final @property uint height() pure const {
        return privateHeight;
    }

    private Type[] array;
    private uint privateWidth, privateHeight;
}
