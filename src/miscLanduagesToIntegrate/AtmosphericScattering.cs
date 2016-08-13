using UnityEngine;

// after http://www.scratchapixel.com/lessons/3d-advanced-lessons/simulating-the-colors-of-the-sky/atmospheric-scattering/

public class AtmosphericScattering
{
	 /* this is the height of the end of the athmosphere */
	const float AtmosphereHeight = 60000.0f;
	
	const float H0 = (0.25f * AtmosphereHeight);
	
	// this is the Mie Phase Function
	static private float PhaseFnMie(float Mu, float G)
	{
		float Term0;
		
		Term0 = (2.0f + G*G)*(1.0f + G*G - 2.0f*G*Mu);
		Term0 = Mathf.Sqrt(Term0*Term0*Term0);
		
		return 3.0f/(8.0f*Mathf.PI) * (((1.0f-G*G)*(1.0f + Mu*Mu))/Term0);
	}
	
	// this is the Rayleigh Phase Function
	static private float PhaseFnRayleigh(float Mu)
	{
		return (3.0f/(16.0f*Mathf.PI))*(1.0f + Mu*Mu);
	}
	
	static private float T(Vector3 PA, Vector3 PB, int Type, int Color0)
	{
		if( Type == 0 ) // mie
		{
			// TODO< add the beta E thing (beta E is the sum of beta S and beta A) >
			
			Vector3 Diff, P;
			int SampleCount = 10, i;
			float BetaS = 210e-5f;
			float Sum = 0.0f;
			
			Diff = PB-PA;
			
			P = PA;
			
			for( i = 0; i < SampleCount; i++ )
			{
				Sum = Sum + BetaS*Mathf.Exp(-P.y/1200.0f);
				
				P = P + Diff/(float)SampleCount;
			}
			
			return Mathf.Exp(-Sum);
		
		}
		else // rayleigh
		{
			float BetaEZero;
			int SampleCount = 10, i;
			float Sum = 0.0f;
			Vector3 Diff, P;
			
			Diff = PB-PA;
			
			P = PA;
			
			// TODO< make this wavelengthvariable >
			
			// Text
			// (33.1e-6m-1, 13.5e-6m-1, 5.8e-6m-1 for wavelengths 440, 550 and 680
			if( Color0 == 2 )
			{
				BetaEZero = 33.1e-6f;
			}
			else if( Color0 == 1 )
			{
				BetaEZero = 13.5e-6f;
			}
			else
			{
				BetaEZero = 5.8e-6f;
			}
			
			for( i = 0; i < SampleCount; i++)
			{
				Sum = Sum + Mathf.Exp(-P.y/8000.0f);
				
				P = P + Diff/(float)SampleCount;
			}
			
			return Mathf.Exp(-BetaEZero * Sum);
		}
	}
	
	
	// SunDirection : from where is the sun comming (vector goes from sun to viewer)
	
	// Type is the type of the scattering
	// 0 : Mie
	// 1 : Rayleigh
	
	// Color0
	// 0 : red
	// 1 : green
	// 2 : blue
	static public float skyColor2(Vector3 RayDirection, Vector3 SunDirection, float SunIntensity, float MieValue, int Type, int Color0)
	{
		float DotProduct, P, Multiplicator, IntegralResult = 0.0f;
		Vector3 PA, PC, X, RayNormal;
		int IntegralI, SampleCount = 10;
		float Distance;
		
		// calculate P term
		// is this right?
		DotProduct = RayDirection.x * SunDirection.x + RayDirection.y * SunDirection.y + RayDirection.z * SunDirection.z;
		
		if( Type == 0 )
		{
			P = PhaseFnMie(DotProduct, MieValue);
		}
		else
		{
			P = PhaseFnRayleigh(DotProduct);
		}
		
		// calculate PA
		// TODO< use the Ray-Sphere intersection >
		
		Multiplicator = AtmosphereHeight / RayDirection.y;
		PA = RayDirection * Multiplicator;
		
		// set PC
		PC = new Vector3(0.0f, 0.0f, 0.0f);
		
		// calculate the integral
		Distance = (PA-PC).magnitude;
		RayNormal = (PA-PC).normalized;
		
		X = PC;
		
		
		for( IntegralI = 0; IntegralI < SampleCount; IntegralI++ )
		{
			Vector3 PS; // Position of the Sun for this Sample
			float SunDirectionLength;
			float BetaS1;
			float IntegralTemp;
			
			// Calculate PS
			SunDirectionLength = (AtmosphereHeight - X.y) / -SunDirection.y;
			PS = X + SunDirectionLength * -SunDirection;
			
			// calculate Beta S
			if( Type == 0 ) // Mie
			{
				BetaS1 = 210e-5f * Mathf.Exp(-X.y/1200.0f);
			}
			else // Rayleigh
			{
				float BetaEZero;
				
				// 33.1e-6m-1, 13.5e-6m-1, 5.8e-6m-1 for wavelengths 440, 550 and 680
				if( Color0 == 2 )
				{
					BetaEZero = 33.1e-6f;
				}
				else if( Color0 == 1 )
				{
					BetaEZero = 13.5e-6f;
				}
				else
				{
					BetaEZero = 5.8e-6f;
				}
				
				BetaS1 = BetaEZero * Mathf.Exp(-X.y/8000.0f); 
			}
			
			IntegralTemp = T(PC, X, Type, Color0) * T(X, PS, Type, Color0) * BetaS1;
			
			IntegralResult = IntegralResult + IntegralTemp * (Distance/(float)SampleCount);
			
			X = X + RayNormal * (Distance/(float)SampleCount);
		}
		
		
		return SunIntensity * P * IntegralResult;
	}
	
	static public void skyColor(Vector3 RayDirection, Vector3 SunDirection, float SunIntensity, float MieValue, float MieScale, ref float R, ref float G, ref float B)
	{
		float MieResult;
		float RResult;
		float GResult;
		float BResult;
		
		MieResult = skyColor2(RayDirection, SunDirection, SunIntensity, MieValue, 0, 0/*not used*/) * MieScale;
		
		RResult = skyColor2(RayDirection, SunDirection, SunIntensity, 0.0f/* not used */, 1, 0);
		GResult = skyColor2(RayDirection, SunDirection, SunIntensity, 0.0f/* not used */, 1, 1);
		BResult = skyColor2(RayDirection, SunDirection, SunIntensity, 0.0f/* not used */, 1, 2);
		
		R = MieResult + RResult;
		G = MieResult + GResult;
		B = MieResult + BResult;
	}
	
	/*
	static private float MiePhaseFn2(float Phi, float G)
	{
		float Term0, Term1, Term2, PhiSqr;
		
		Term0 = 1.5f * ((1.0f-G*G)/(2.0f+G*G));
		
		PhiSqr = Mathf.Cos(Phi)*Mathf.Cos(Phi);
		Term1 = (1.0f + PhiSqr);
		
		Term2 = 1.0f+G*G - 2.0f*G*Mathf.Cos(Phi);
		Term2 = Mathf.Sqrt(Term2*Term2*Term2);
		
		return Term0 * Term1 / Term2;
	}
	
	* NOTE
	 * k returns the "scattering constant" for the Wavelength Delta
	 * Delta is an int because it simplifies the code
	 *
	static private float k(int Delta)
	{
		return 1.0f;
	}
	
	static private float outScatteringFn(Vector3 PA, Vector3 PB, int Delta)
	{
		float IntegralResult = 0.0f;
		Vector3 Diff, Normal, CurrentPos;
		float Distance, StepDistance;
		int Stepi;
		
		
		Diff = PB-PA;
		Normal = Diff.normalized;
		Distance = Diff.magnitude;
		StepDistance = Distance / 50.0f;
		
		// TODO< better integration method >
		
		CurrentPos = PA;
		
		for( Stepi = 0; Stepi < 50; Stepi++ )
		{
			// the y coordinate is the Height
			
			IntegralResult = IntegralResult + StepDistance * Mathf.Exp( -CurrentPos.y / H0 );
			
			CurrentPos += (Normal * StepDistance);
		}
		
		return Mathf.PI*4.0f * k(Delta) * IntegralResult;
	}
	
	// SunVector is the direction to the sun (must be normalized)
	static public float scatter(int Delta, Vector3 PA, Vector3 PB, Vector3 SunVector)
	{
		// TODO
		
		Vector3 P;
		Vector3 PC; // Point to from point to sun
		Vector3 Diff, Normal;
		float Distance, StepDistance;
		int Stepi;
		
		float IntegralResult = 0.0f;
		float DotProduct;
		
		Diff = PB-PA;
		Normal = Diff.normalized;
		Distance = Diff.magnitude;
		StepDistance = Distance / 50.0f;
		
		P = PA;
		
		for( Stepi = 0; Stepi < 50; Stepi++ )
		{
			float YDist, SunVectorMul;
			float CurrentValue;
			
			// Calculate Pc
			
			YDist = 80000.0f - P.y;
			SunVectorMul = YDist / SunVector.y;
			
			// hack
			SunVectorMul = Mathf.Max(SunVectorMul, 100000.0f);
			
			PC = P + SunVectorMul * SunVector;
			
			CurrentValue = Mathf.Exp( -P.y / H0 ) * Mathf.Exp(-outScatteringFn(P, PC, Delta) - outScatteringFn(P, PA, Delta) );
			
			
			IntegralResult = IntegralResult + StepDistance * CurrentValue;
			
			P = P + (Normal * StepDistance);
		}
		
		DotProduct = SunVector.x * Normal.x + SunVector.y * Normal.y + SunVector.z * Normal.z;
		
		return k(Delta) *  sun intensity 100000.0f * MiePhaseFn2(Mathf.acos(DotProduct), -0.75f) * IntegralResult;
	}
	
	*/
}
