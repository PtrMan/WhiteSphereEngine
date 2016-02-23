module Convolution;

import IMap2d : IMap2d;
import NumericSpatialVectors;

template ConvolutionLinear(int incrementX, int incrementY, Type) {
    public static Type convoluteAt(IMap2d!Type map, Type[] kernel, SpatialVector!(2,int) position) {
        SpatialVector!(2,int) currentPosition = position.clone();
        Type result = cast(Type)0.0;

        for( int counter = 0; counter < kernel.length; counter++ ) {
            result += (map.getAt(currentPosition) * kernel[counter]);

            currentPosition.x = currentPosition.x + incrementX;
            currentPosition.y = currentPosition.y + incrementY;
        }

        return result;
    }
}

// without warparound
public void convoluteSeperable(IMap2d!float inputAndOutput, IMap2d!float temp, float[] kernel) {
    foreach( int y; 0..inputAndOutput.height) {
        foreach( int x; kernel.length/2..inputAndOutput.width-kernel.length/2) {
            SpatialVector!(2,int) position = new SpatialVector!(2,int)(x, y);
            SpatialVector!(2,int) convolutionPosition = position - new SpatialVector!(2,int)(kernel.length/2, 0);
            float convolutionResult = ConvolutionLinear!(1, 0, float).convoluteAt(inputAndOutput, kernel, convolutionPosition);
            temp.setAt(position, convolutionResult);
        }
    }

    foreach( int y; kernel.length/2..inputAndOutput.height-kernel.length/2) {
        foreach( int x; 0..inputAndOutput.width) {
            SpatialVector!(2,int) position = new SpatialVector!(2,int)(x, y);
            SpatialVector!(2,int) convolutionPosition = position - new SpatialVector!(2,int)(0, kernel.length/2);
            float convolutionResult = ConvolutionLinear!(0, 1, float).convoluteAt(temp, kernel, convolutionPosition);
            inputAndOutput.setAt(position, convolutionResult);
        }
    }
}
