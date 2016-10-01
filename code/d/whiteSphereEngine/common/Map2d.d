module Map2d;

import IMap2d : IMap2d;
import NumericSpatialVectors;

class Map2d(Type) : IMap2d!Type {
    public final this(uint width, uint height) {
        privateWidth = width;
        privateHeight = height;

        array = new Type[width*height];
    }

    public final void setAt(SpatialVector!(2,int) position, Type value) {
        array[position.x + position.y * width] = value;
    }

    public final Type getAt(SpatialVector!(2,int) position) {
        return array[position.x + position.y * width];
    }

    public final @property uint width() {
        return privateWidth;
    }

    public final @property uint height() {
        return privateHeight;
    }

    private Type[] array;
    private uint privateWidth, privateHeight;
}
