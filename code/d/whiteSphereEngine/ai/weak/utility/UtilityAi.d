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


private void conditionGreater(float* result, float* arr, float* parameterA, float* parameterB, size_t length) {
  align(64) float *arrAligned = arr;
  align(64) float *parameterAAligned = parameterA;
  align(64) float *resultAligned = result;
  
  foreach( i; 0..length ) {
    resultAligned[i] = cast(float)(arrAligned[i] > parameterAAligned[i]);
  }
}

private void conditionSmaller(float* result, float* arr, float* parameterA, float* parameterB, size_t length) {
  align(64) float *arrAligned = arr;
  align(64) float *parameterAAligned = parameterA;
  align(64) float *resultAligned = result;
  
  foreach( i; 0..length ) {
    resultAligned[i] = cast(float)(arrAligned[i] < parameterAAligned[i]);
  }
}


private void pow(uint Power)(float* result, float* arr, float* parameterA, float* parameterB, size_t length) {
  align(64) float *arrAligned = arr;
  
  foreach( i; 0..length ) {
    result[i] = pow(arrAligned[i], Power);
  }
}

import std.math : sqrt;

// x^0.5 which is just sqrt
private void pow05(float* result, float* arr, float* parameterA, float* parameterB, size_t length) {
  align(64) float *arrAligned = arr;
  
  foreach( i; 0..length ) {
    result[i] = sqrt(arrAligned[i]);
  }
}

// x^0.25
private void pow025(float* result, float* arr, float* parameterA, float* parameterB, size_t length) {
  align(64) float *arrAligned = arr;
  
  foreach( i; 0..length ) {
    result[i] = sqrt(sqrt(arrAligned[i]));
  }
}

// fast x^0.75
private void pow075(float* result, float* arr, float* parameterA, float* parameterB, size_t length) {
  align(64) float *arrAligned = arr;
  
  foreach( i; 0..length ) {
    result[i] = sqrt(sqrt(pow(arrAligned[i], 3)));
  }
}



// utility AI
// described in https://alastaira.wordpress.com/2013/01/25/at-a-glance-functions-for-modelling-utility-based-game-ai/

enum EnumUtilityFunction {
	POW2 = 0, // must be 0 because we use it as index
	POW3,
	POW4,

	POW025,
	POW05,
	POW075,

	CONDITIONSMALLER,
	CONDITIONGREATER,
}

 // TODO< with parameters for each curve of the action
struct ActionDescriptor {
	EnumUtilityFunction function_;
	float multiplier = 1.0f; // gets applied after the function

	float parameterA, parameterB;
}

struct UtilityDescriptor {
	ActionDescriptor[] utilityActions;

	int actionWithHighestUtility = -1;

	float highestUtility;
}


struct UtilityAi {
	final void utility(UtilityDescriptor[] utilityDescriptors, float[] x) {
		alias void function(float *arguments, float *result, float* parameterA, float* parameterB, size_t length) EvaluationFunctionType;

		static const EvaluationFunctionType[] evaluationFunctions = [
			&pow!2,
			&pow!3,
			&pow!4,
			&pow025,
			&pow05,
			&pow075,
			&conditionSmaller,
			&conditionGreater,
		];


		size_t[evaluationFunctions.length] arrayOfNumberOfUsedElementsInArray;

		foreach( i; 0..arrayOfNumberOfUsedElementsInArray.length ) {
			arrayOfNumberOfUsedElementsInArray[i] = 0;
		}

		// first we check in the debug version if we have enough space
		/*version(debug) {
			foreach( iterationDescriptorI, iterationUtilityDescriptor; utilityDescriptors ) {
				foreach( iterationUtilityAction; iterationUtilityDescriptor.utilityActions ) {
					arrayOfNumberOfUsedElementsInArray[cast(size_t)iterationUtilityAction.function_]++;
				}
			}	
		}*/

		// TODO
		//assert( numberOfUsedElementsInArrayPow2 <= TODO< number of allocated elements in pow2 );
		//assert( numberOfUsedElementsInArrayPow3 <= TODO< number of allocated elements in pow3 );
		//assert( numberOfUsedElementsInArrayPow4 <= TODO< number of allocated elements in pow4 );

		//assert( numberOfUsedElementsInArrayPow075 <= TODO< number of allocated elements in pow075 );

		foreach( i; 0..arrayOfNumberOfUsedElementsInArray.length ) {
			arrayOfNumberOfUsedElementsInArray[i] = 0;
		}

		// we now put the arguments into the SOA for the vectorized code from all UtilityDescriptors
		foreach( iterationDescriptorI, iterationUtilityDescriptor; utilityDescriptors ) {
			foreach( iterationUtilityAction; iterationUtilityDescriptor.utilityActions ) {
				// get the # of used elements in the array for the arguments for the function
				size_t numberOfUsedElementsInArray = arrayOfNumberOfUsedElementsInArray[cast(size_t)iterationUtilityAction.function_];
				// add the argument
				arrayArguments[cast(size_t)iterationUtilityAction.function_][numberOfUsedElementsInArray] = x[iterationDescriptorI];
				arrayParameterA[cast(size_t)iterationUtilityAction.function_][numberOfUsedElementsInArray] = iterationUtilityAction.parameterA;
				arrayParameterB[cast(size_t)iterationUtilityAction.function_][numberOfUsedElementsInArray] = iterationUtilityAction.parameterB;
				
				// increment the counter
				arrayOfNumberOfUsedElementsInArray[cast(size_t)iterationUtilityAction.function_]++;
			}
		}

		// calculate all SOA's
		foreach( i; 0..evaluationFunctions.length ) {
			evaluationFunctions[i](arrayArguments[i], arrayResults[i], arrayParameterA[i], arrayParameterB[i], arrayOfNumberOfUsedElementsInArray[i]);
		}

		// we actually have to unpack all SOA's into the coresponding UtilityDescriptor, we skip this, instead
		// we now decide the highest utility function

		// indices at the current values we point at in the results
		size_t[evaluationFunctions.length] arrayOfCurrentIndexInArray;

		foreach( i; 0..arrayOfNumberOfUsedElementsInArray.length ) {
			arrayOfCurrentIndexInArray[i] = 0;
		}


		foreach( iterationDescriptorI, iterationUtilityDescriptor; utilityDescriptors ) {
			iterationUtilityDescriptor.actionWithHighestUtility = -1;
			iterationUtilityDescriptor.highestUtility = -1.0f;
		}

		foreach( iterationDescriptorI, iterationUtilityDescriptor; utilityDescriptors ) {
			foreach( iterationUtilityActionIndex, ref iterationUtilityAction; iterationUtilityDescriptor.utilityActions ) {
				float currentUtility;

				currentUtility = arrayResults[cast(size_t)iterationUtilityAction.function_][arrayOfCurrentIndexInArray[cast(size_t)iterationUtilityAction.function_]++];

				currentUtility *= iterationUtilityAction.multiplier;

				if( currentUtility > iterationUtilityDescriptor.highestUtility ) {
					iterationUtilityDescriptor.highestUtility = currentUtility;
					iterationUtilityDescriptor.actionWithHighestUtility = iterationUtilityActionIndex;
				}
			}	
		}

	}

	private {
		float *[] arrayArguments;
		float *[] arrayParameterA;
		float *[] arrayParameterB;
		float *[] arrayResults;
	}
}
