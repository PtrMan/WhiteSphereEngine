#include <cstdint>
#include <cstddef>

#include <cmath>


void multiMix(float **arrayOfSequences, float *laoudness, float *result, size_t channels, size_t length) {
  for( size_t i = 0; i < length; i++ ) {
    float mixed = 0.0f;
    
    for( size_t channelI = 0; channelI < channels; channelI++ ) {
    	mixed += (arrayOfSequences[0][i] * laoudness[i]);
    }
    
    result[i] = mixed;
  }
}
/*
float interpolateCubic(float y0, float y1, float x) {
	// see for formulas http://www.paulinternet.nl/?page=bicubic
	float a = 2.0f * y0 - 2.0f * y1;
	float b = -3.0f * y0 + 3.0f * y1;
	float c = 0.0f;
	float d = 0.0f;

	return a*x*x*x + b*x*x + c*x + d;
}*/

// see http://www.dspguide.com/ch19/1.htm
float recursiveFilter3(float a0, float y[3], float b[3]) {
  float result = a0;
  
  for( size_t i = 0; i < 3; i++ ) {
    result += (y[i] * b[i]);
  }
  
  return result;
}

// interpolation is the process of sampling up and lowpass filtering
// see http://dspguru.com/dsp/faqs/multirate/interpolation
// first three values in sink are used to fill the recursive filter
void interpolation(float *source, float *sink, size_t sinkLength, size_t factor,  float a0, float b[3]) {
  size_t iFactorCounter = factor;
  size_t sourceIndex = 0;
  
  for( size_t i = 0; i < sinkLength - 3; i++ ) {
    // optimized code for zero stuffing, without divisions
    float sourceValue;
    if( iFactorCounter == factor ) {
      sourceValue = source[sourceIndex++];
      iFactorCounter = 0;
    }
    else {
      sourceValue = 0.0f;
      iFactorCounter++;
    }
    
    

    sink[i+3] = recursiveFilter3(sourceValue, &sink[i], b);
  }
}



// used to calculate the factors of interpolation/"extrapolation(subsampling)"
// TODO< write this in c because it doesnt have to be fast >

bool tryFactorize(uint number, uint *arr, size_t &arrIndex) {
  arrIndex = 0;
  
  uint currentFactor = 1;
  uint currentDivisor = 2;
  
  for(;;) {
    bool remainderEqualsZero = (number % (currentFactor*currentDivisor)) == 0;
    if( remainderEqualsZero ) {
      arr[arrIndex++] = currentDivisor;
      
      if( currentFactor*currentDivisor >= number ) {
        return currentFactor*currentDivisor == number;
      }
      // else we are here
      
      currentFactor = currentFactor*currentDivisor;
      currentDivisor = 2;
    }
    
    currentDivisor++;
  }
}