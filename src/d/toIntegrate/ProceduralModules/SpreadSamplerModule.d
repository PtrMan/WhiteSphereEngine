import std.variant : Variant;

class ArrayOfVariants {
	public Variant[] array;
}

/**
 * Modular elements inspired by the snowrop engine
 *
 * For procedural generation the modules can be put together by a configuration or a GUI
 *
 */
interface IModule {
	// called at configuration or reconfiguration time
	void configure(Variant[string] configuration);

	void setInput(uint index, ArrayOfVariants array);

	void activate();

	Variant[] getResult();
}


import std.random : Random, uniform, rndGen;
import std.math : sqrt;
static import BoxMullerTransform;

/**
 * Calculates a delta after a chosen distribution
 * result are just component scalars
 *
 * for now just implemented for the 2d case
 */
class DistributionSamplerModule : IModule {
	public this() {
		random = rndGen;
	}

	public final void configure(Variant[string] configuration) {
		distribution = configuration["distribution"].get!(string);

		if( distribution == "gaussian" ) {
			gaussianSigma = configuration["gaussianSigma"].get!(double);
		}
		else if( distribution == "circular" ) {
			circularSampleRadius = configuration["circularSampleRadius"].get!(double);
		}
		else {
			// TODO< error handling, throw error or return error code >
			return;
		}

		enable3d = configuration["enable3d"].get!(bool);
	}

	public final void setInput(uint index, ArrayOfVariants array) {
		// has no input, doesn't do anything
	}

	// expects two parameters, it is the coordinate as double values
	public final void activate() {
		if( distribution == "gaussian" ) {
			generateGaussianOffset(resultX, resultY, resultZ);
		}
		else if( distribution == "circular" ) {
			generateRandomCircularSample(resultX, resultY, resultZ);

		}
		else {
			// TODO< error handling, throw error or return error code >
			return;
		}
	}

	public final Variant[] getResult() {
		Variant[] result;
		result ~= Variant(resultX);
		result ~= Variant(resultY);
		if( enable3d ) {
			result ~= Variant(resultZ);
		}
		return result;
	}

	protected final generateRandomCircularSample(out double x, out double y, out double z) {
		for(;;) {
			x = uniform(-circularSampleRadius, circularSampleRadius, random);
			y = uniform(-circularSampleRadius, circularSampleRadius, random);

			if( enable3d ) {
				z = uniform(-circularSampleRadius, circularSampleRadius, random);
			}
			else {
				z = 0.0;
			}

			if( sqrt(x*x + y*y + z*z) < circularSampleRadius ) {
				return;
			}
		}
	}

	protected final generateGaussianOffset(out double x, out double y, out double z) {
		BoxMullerTransform.generateDualGaussian!double(random, gaussianSigma, 0.0, x, y);

		if( enable3d ) {
			z = BoxMullerTransform.generateSingleGaussian!double(random, gaussianSigma, 0.0);
		}
	}


	protected Random random;

	protected string distribution;

	protected double gaussianSigma;
	protected double circularSampleRadius;

	protected bool enable3d;
	protected double resultX, resultY, resultZ;
}

/**
 * applies a scalar operation to all arguments
 *
 */
class ScalarOperationModule : IModule {
	public final void configure(Variant[string] configuration) {
		operation = configuration["operation"].get!(string);
	}

	public final void setInput(uint index, ArrayOfVariants array) {
		if( index >= 2 ) {
			// TODO< error handling, throw error or return error code >
			return;
		}

		// has no input, doesn't do anything
		inputs[index] = array;
	}

	public final void activate() {
		if( inputs[0] is null || inputs[1] is null ) {
			// TODO< error handling, throw error or return error code >
			return;
		}

		if( inputs[0].array.length != inputs[1].array.length ) {
			// TODO< error handling, throw error or return error code >
			"Arrays must have the same length!";
			return;
		}

		uint operationWidth = inputs[0].array.length;

		result.array.length = operationWidth;
		for( uint i; 0..operationWidth ) {
			result.array[i] = applyOperation(inputs[0].array[i].get!(double), inputs[1].array[i].get!(double));
		}
	}


	public final Variant[] getResult() {
		return result.array;
	}

	protected double applyOperation(double a, double b) {
		if( operation == "+" ) {
			return a + b;
		}
		else if( operation == "-" ) {
			return a - b;
		}
		else if( operation == "*" ) {
			return a * b;
		}
		else if( operation == "/" ) {
			return a / b;
		}
		else {
			// TODO< error handling, throw error or return error code >
			"Invalid operation '" ~ operation ~ "'!";
			return;
		}
	}

	protected string operation;

	protected ArrayOfVariants result = new ArrayOfVariants();
	protected ArrayOfVariants[2] inputs;
}


// integrated quick dirty test
import std.stdio : writeln;

void main(string[] args) {
	IModule testSpreadSampler = new DistributionSamplerModule();

	{
		Variant[string] configureParameters;
		configureParameters["enable3d"] = false;
		configureParameters["distribution"] = "circular";
		configureParameters["circularSampleRadius"] = 5.0;
		testSpreadSampler.configure(configureParameters);
	}

	{
		ArrayOfVariants array = new ArrayOfVariants();
		testSpreadSampler.setInput(0, array);
	}

	testSpreadSampler.activate();


	{
		Variant[] result = testSpreadSampler.getResult();

		writeln(result[0].get!(double));
		writeln(result[1].get!(double));
	}
}

