module whiteSphereEngine.common.IMap2d;

import linopterixed.linear.Vector;

interface IMap2d(Type) {
    void setAt(SpatialVectorStruct!(2,int) position, Type value);
    Type getAt(SpatialVectorStruct!(2,int) position) pure const;

    @property uint width() pure const;
    @property uint height() pure const;
}
