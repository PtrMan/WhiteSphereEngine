// vectortest

import NumericSpatialVectors;

import std.stdio;

void main(string[] args)
    {
        int x = 5;
        int y = 6;
        SpatialVector!(3,float) position = new SpatialVector!(3,float)(x, y, 5.0f);
        writeln(position.x);
        writeln(position.y);
        SpatialVector!(3,float) position2 = position + position;
        writeln(position2 is null);
        writeln(position2.data[0]);
        writeln(position2.data[1]);
}


/*
    {
        int x = 5;
        int y = 6;
        SpatialVector2!int position = new SpatialVector2!int(x, y);
        writeln(position.x);
        writeln(position.y);
        auto position2 = position + position;
        writeln(position2.data[0]);
        writeln(position2.data[1]);

        writeln("BEFORE");
        SpatialVector2!int convolutionPosition = cast(SpatialVector2!int)(position - new SpatialVector2!int(10/2, 0));
        //writeln(position - new SpatialVector2!int(10/2, 0));
       // writeln(convolutionPosition);
        writeln("XXX");
        writeln(convolutionPosition.x, " ", convolutionPosition.y);
        return;
    }
*/