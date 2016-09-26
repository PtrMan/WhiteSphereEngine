// see
// https://de.wikipedia.org/wiki/Bin%C3%A4re_Exponentiation#Pseudocode_.28alternativer_Algorithmus.29
float pow(float base, uint exponent) {
  float result = cast(float)1;
  
  float activePotence = base;
  
  while(exponent != 0) {
    if( (exponent & 1) != 0 ) {
      result *= activePotence;
    }
    activePotence *= activePotence;
    exponent /= 2;
  }
  
  return result;
}


private void pow2(float* result, float* arr, size_t length) {
  align(64) float *arrAligned = arr;
  
  foreach( i; 0..length ) {
    result[i] = pow(arrAligned[i], 2);
  }
}

private void pow3(float* result, float* arr, size_t length) {
  align(64) float *arrAligned = arr;
  
  foreach( i; 0..length ) {
    result[i] = pow(arrAligned[i], 3);
  }
}

private void pow4(float* result, float* arr, size_t length) {
  align(64) float *arrAligned = arr;
  
  foreach( i; 0..length ) {
    result[i] = pow(arrAligned[i], 4);
  }
}

import std.math : sqrt;

// x^0.5 which is just sqrt
private void pow05(float* result, float* arr, size_t length) {
  align(64) float *arrAligned = arr;
  
  foreach( i; 0..length ) {
    result[i] = sqrt(arrAligned[i]);
  }
}

// x^0.25
private void pow025(float* result, float* arr, size_t length) {
  align(64) float *arrAligned = arr;
  
  foreach( i; 0..length ) {
    result[i] = sqrt(sqrt(arrAligned[i]));
  }
}

// fast x^0.75
private void pow075(float* result, float* arr, size_t length) {
  align(64) float *arrAligned = arr;
  
  foreach( i; 0..length ) {
    result[i] = sqrt(sqrt(pow(arrAligned[i], 3)));
  }
}



// utility AI
// described in https://alastaira.wordpress.com/2013/01/25/at-a-glance-functions-for-modelling-utility-based-game-ai/

enum EnumUtilityFunction {
	POW2,
	POW3,
	POW4,

	POW075,
}

 // TODO< with parameters for each curve of the action
struct ActionDescriptor {
	EnumUtilityFunction function_;
	float multiplier = 1.0f; // gets applied after the function
}

struct UtilityDescriptor {
	ActionDescriptor[] utilityActions;

	int actionWithHighestUtility = -1;

	float highestUtility;
}


struct UtilityAi {
	final void utility(UtilityDescriptor[] utilityDescriptors, float[] x) {
		size_t numberOfUsedElementsInArrayPow2 = 0;
		size_t numberOfUsedElementsInArrayPow3 = 0;
		size_t numberOfUsedElementsInArrayPow4 = 0;
		size_t numberOfUsedElementsInArrayPow075 = 0;

		// first we check in the debug version if we have enough space
		version(debug) {
			foreach( iterationDescriptorI, iterationUtilityDescriptor; utilityDescriptors ) {
				foreach( iterationUtilityAction; iterationUtilityDescriptor.utilityActions ) {
					final switch(iterationUtilityAction.function_) with (EnumUtilityFunction) {
						case POW2:
						numberOfUsedElementsInArrayPow2++;
						break;

						case POW3:
						numberOfUsedElementsInArrayPow3++;
						break;

						case POW4:
						numberOfUsedElementsInArrayPow4++;
						break;


						case POW075:
						numberOfUsedElementsInArrayPow075++;
						break;
					}
				}
			}	
		}

		// TODO
		//assert( numberOfUsedElementsInArrayPow2 <= TODO< number of allocated elements in pow2 );
		//assert( numberOfUsedElementsInArrayPow3 <= TODO< number of allocated elements in pow3 );
		//assert( numberOfUsedElementsInArrayPow4 <= TODO< number of allocated elements in pow4 );

		//assert( numberOfUsedElementsInArrayPow075 <= TODO< number of allocated elements in pow075 );


		numberOfUsedElementsInArrayPow2 = 0;
		numberOfUsedElementsInArrayPow3 = 0;
		numberOfUsedElementsInArrayPow4 = 0;

		numberOfUsedElementsInArrayPow075 = 0;

		// we now put the arguments into the SOA for the vectorized code from all UtilityDescriptors
		foreach( iterationDescriptorI, iterationUtilityDescriptor; utilityDescriptors ) {
			foreach( iterationUtilityAction; iterationUtilityDescriptor.utilityActions ) {
				final switch(iterationUtilityAction.function_) with (EnumUtilityFunction) {
					case POW2:
					arrayPow2Arguments[numberOfUsedElementsInArrayPow2] = x[iterationDescriptorI];
					numberOfUsedElementsInArrayPow2++;
					break;

					case POW3:
					arrayPow3Arguments[numberOfUsedElementsInArrayPow3] = x[iterationDescriptorI];
					numberOfUsedElementsInArrayPow3++;
					break;

					case POW4:
					arrayPow4Arguments[numberOfUsedElementsInArrayPow4] = x[iterationDescriptorI];
					numberOfUsedElementsInArrayPow4++;
					break;


					case POW075:
					arrayPow075Arguments[numberOfUsedElementsInArrayPow075] = x[iterationDescriptorI];
					numberOfUsedElementsInArrayPow075++;
					break;

				}
			}
		}

		// calculate all SOA's
		pow2(arrayPow2Arguments, arrayPow2Results, numberOfUsedElementsInArrayPow2);
		pow3(arrayPow3Arguments, arrayPow3Results, numberOfUsedElementsInArrayPow3);
		pow4(arrayPow4Arguments, arrayPow4Results, numberOfUsedElementsInArrayPow4);

		pow075(arrayPow075Arguments, arrayPow075Results, numberOfUsedElementsInArrayPow075);

		// we actually have to unpack all SOA's into the coresponding UtilityDescriptor, we skip this, instead
		// we now decide the highest utility function

		// indices at the current values we point at in the results
		size_t currentIndexInArrayPow2 = 0;
		size_t currentIndexInArrayPow3 = 0;
		size_t currentIndexInArrayPow4 = 0;

		size_t currentIndexInArrayPow075 = 0;

		foreach( iterationDescriptorI, iterationUtilityDescriptor; utilityDescriptors ) {
			iterationUtilityDescriptor.actionWithHighestUtility = -1;
			iterationUtilityDescriptor.highestUtility = -1.0f;
		}

		foreach( iterationDescriptorI, iterationUtilityDescriptor; utilityDescriptors ) {
			foreach( iterationUtilityActionIndex, ref iterationUtilityAction; iterationUtilityDescriptor.utilityActions ) {
				float currentUtility;

				final switch(iterationUtilityAction.function_) with (EnumUtilityFunction) {
					case POW2:
					currentUtility = arrayPow2Results[currentIndexInArrayPow2];
					currentIndexInArrayPow2++;
					break;

					case POW3:
					currentUtility = arrayPow3Results[currentIndexInArrayPow3];
					currentIndexInArrayPow3++;
					break;

					case POW4:
					currentUtility = arrayPow4Results[currentIndexInArrayPow4];
					currentIndexInArrayPow4++;
					break;


					case POW075:
					currentUtility = arrayPow075Results[currentIndexInArrayPow075];
					currentIndexInArrayPow075++;
					break;

				}

				currentUtility *= iterationUtilityAction.multiplier;

				if( currentUtility > iterationUtilityDescriptor.highestUtility ) {
					iterationUtilityDescriptor.highestUtility = currentUtility;
					iterationUtilityDescriptor.actionWithHighestUtility = iterationUtilityActionIndex;
				}
			}	
		}

	}

	private {
		float *arrayPow2Arguments; // aligned to 64 byte boundary
		float *arrayPow2Results; // aligned to 64 byte boundary

		float *arrayPow3Arguments; // aligned to 64 byte boundary
		float *arrayPow3Results; // aligned to 64 byte boundary

		float *arrayPow4Arguments; // aligned to 64 byte boundary
		float *arrayPow4Results; // aligned to 64 byte boundary


		float *arrayPow075Arguments; // aligned to 64 byte boundary
		float *arrayPow075Results; // aligned to 64 byte boundary
	}
}

