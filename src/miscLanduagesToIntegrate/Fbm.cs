using System;

public class Fbm
{
	// see https://code.google.com/p/fractalterraingeneration/wiki/Fractional_Brownian_Motion
	public static float fbm2d(float grid, float gain, float lacunarity, uint octaves, float x, float y)
	{
		float total, frequency, amplitude;
		uint i;

		total = 0.0f;
		frequency = 1.0f/grid;
		amplitude = gain;
		
		for( i = 0; i < octaves; ++i )
		{
			total += SimplexNoise.aperiodicNoise2d(x * frequency, y * frequency) * amplitude;         
			frequency *= lacunarity;
			amplitude *= gain;
		}

		return total;
	}
}

