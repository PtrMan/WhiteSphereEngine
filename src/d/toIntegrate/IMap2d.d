module IMap2d;

import NumericSpatialVectors;

interface IMap2d(Type) {
    void setAt(SpatialVector!(2,int) position, Type value);
    Type getAt(SpatialVector!(2,int) position);

    @property uint width();
    @property uint height();
}
