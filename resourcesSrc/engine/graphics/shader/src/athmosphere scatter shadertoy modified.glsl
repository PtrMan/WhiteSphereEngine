// orginal from https://www.shadertoy.com/view/lslXDr
// orginal function where the function calls to ray_vs_sphere(), optic(), density() are unrolled
// the function ray_vs_sphere() was bugged

// math const
const float PI = 3.14159265359;

//const int NUM_OUT_SCATTER = 10;
//const float FNUM_OUT_SCATTER = 10.0;

//const float FNUM_IN_SCATTER = 10.0;

void raySphereRaytraced(const vec3 spherePosition, const vec3 p, const vec3 dir, const float r, out float intersect, out float plus, out float minus) {
	vec3 pdiff = p - spherePosition;

	float a = 1.0; // dir*dir, is 1.0 because dir is assumed to be normalized
	float b = 2.0 * dot( pdiff, dir );
	float c = dot( pdiff, pdiff ) - r * r;

	float divTwoA = (1.0/a)*0.5;

	float inSqrt = intersect = b*b - 4.0*a*c;
	float sqrtResult = sqrt(inSqrt);

	plus = (-b + sqrtResult) * divTwoA;
	minus = (-b - sqrtResult) * divTwoA;
}




// Mie
// g : ( -0.75, -0.999 )
//      3 * ( 1 - g^2 )               1 + c^2
// F = ----------------- * -------------------------------
//      2 * ( 2 + g^2 )     ( 1 + g^2 - 2 * g * c )^(3/2)
float phase_mie( float g, float c, float cc ) {
	float gg = g * g;
	
	float a = ( 1.0 - gg ) * ( 1.0 + cc );

	float b = 1.0 + gg - 2.0 * g * c;
	b *= sqrt( b );
	b *= 2.0 + gg;	
	
	return 1.5 * a / b;
}

// Reyleigh
// g : 0
// F = 3/4 * ( 1 + c^2 )
float phase_reyleigh( float cc ) {
	return 0.75 * ( 1.0 + cc );
}

float density( vec3 p, const float R_INNER, const float SCALE_H ) {
	return exp( -( length( p ) - R_INNER ) * SCALE_H );
}

float optic( vec3 p, vec3 q, const vec3 centerPosition, const float SCALE_L, const float SCALE_H, const float R_INNER ) {
	const int NUM_OUT_SCATTER = 10; //needed because ue4 shader don't like it for some odd reason without it
	const float FNUM_OUT_SCATTER = 10.0;

	vec3 step = ( q - p ) / FNUM_OUT_SCATTER;
	vec3 v = p + step * 0.5;
	
	float sum = 0.0;
	for ( int i = 0; i < NUM_OUT_SCATTER; i++ ) {
		sum += density( v - centerPosition, R_INNER, SCALE_H );
		v += step;
	}
	sum *= length( step ) * SCALE_L;
	
	return sum;
}

vec3 in_scatter(const vec3 centerPosition, vec3 o, vec3 dir, const float intersectionEntry, const float intersectionExit, vec3 l, const float K_R, const vec3 C_R, const float K_M, const float G_M, const float E, const float SCALE_L, const float SCALE_H, const float R, const float R_INNER) {
	const int NUM_IN_SCATTER = 10; //needed because ue4 shader don't like it for some odd reason without it
	const float FNUM_IN_SCATTER = 10.0;

	float len = ( intersectionExit - intersectionEntry ) / FNUM_IN_SCATTER;
	vec3 step = dir * len;
	vec3 p = o + dir * intersectionEntry;
	vec3 v = p + dir * ( len * 0.5 );

	vec3 sum = vec3( 0.0 );
	for ( int i = 0; i < NUM_IN_SCATTER; i++ ) {
		float sphereIntersect, spherePlus, sphereMinus;

		raySphereRaytraced(centerPosition, v, l, R,  sphereIntersect, spherePlus, sphereMinus);
		vec3 u = v + l * spherePlus;
		
		float n = ( optic( p, v, centerPosition, SCALE_L, SCALE_H, R_INNER ) + optic( v, u, centerPosition, SCALE_L, SCALE_H, R_INNER ) ) * ( PI * 4.0 );
		
		sum += density( v - centerPosition, R_INNER, SCALE_H ) * exp( -n * ( K_R * C_R + K_M ) );

		v += step;
	}
	sum *= len * SCALE_L;
	
	float c  = dot( dir, -l );
	float cc = c * c;
	
	return sum * ( K_R * C_R * phase_reyleigh( cc ) + K_M * phase_mie( G_M, c, cc ) ) * E;
}

vec3 atmosphericScattering(const vec3 centerPosition, const vec3 eye, vec3 dir, vec3 l,  const float K_R, const vec3 C_R, const float K_M, const float G_M, const float E, const float SCALE_L, const float SCALE_H, const float R, const float R_INNER) {
	float sphereIntersect, outerSpherePlus, outerSphereMinus;

	raySphereRaytraced(centerPosition, eye, dir, R, sphereIntersect, outerSpherePlus, outerSphereMinus );

	float innerSpherePlus, innerSphereMinus;
	
	raySphereRaytraced(centerPosition, eye, dir, R_INNER, sphereIntersect, innerSpherePlus, innerSphereMinus );
	outerSpherePlus = min( outerSpherePlus, innerSphereMinus );

	vec3 resultColor = in_scatter(centerPosition, eye, dir, outerSphereMinus, outerSpherePlus, l,  K_R, C_R, K_M, G_M, E, SCALE_L, SCALE_H, R, R_INNER);
	return resultColor;
}











// angle : pitch, yaw
mat3 rot3xy( vec2 angle ) {
	vec2 c = cos( angle );
	vec2 s = sin( angle );
	
	return mat3(
		c.y      ,  0.0, -s.y,
		s.y * s.x,  c.x,  c.y * s.x,
		s.y * c.x, -s.x,  c.y * c.x
	);
}

// ray direction
vec3 ray_dir( float fov, vec2 size, vec2 pos ) {
	const float DEG_TO_RAD = PI / 180.0;

	vec2 xy = pos - size * 0.5;

	float cot_half_fov = tan( ( 90.0 - fov * 0.5 ) * DEG_TO_RAD );	
	float z = size.y * 0.5 * cot_half_fov;
	
	return normalize( vec3( xy, -z ) );
}



void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
		
	const float K_R = 0.166;
	const float K_M = 0.0025;
	const float E = 14.3; 						// light intensity
	const vec3  C_R = vec3( 0.3, 0.7, 1.0 ); 	// 1 / wavelength ^ 4
	const float G_M = -0.85;					// Mie g

	const float R = 150.0;
	const float R_INNER = 130.0;
	const float SCALE_H = 4.0 / ( R - R_INNER );
	const float SCALE_L = 1.0 / ( R - R_INNER );

	// default ray dir
	vec3 dir = ray_dir( 45.0, iResolution.xy, fragCoord.xy );
	
	// default ray origin
	vec3 eye = vec3( 0.0, 0.0, 400.0 );

	// rotate camera
	mat3 rot = rot3xy( vec2( 0.0, iGlobalTime * 0.5 ) );
	//dir = rot * dir;
	//eye = rot * eye;
	
	// sun light dir
	vec3 l = vec3( 0, 0, 1 );
	l = rot * l;

	vec3 centerPosition = vec3(40.0, 0.0, 0.0);

	float sphereIntersect, outerSpherePlus, outerSphereMinus;
			  
	raySphereRaytraced(centerPosition, eye, dir, R, sphereIntersect, outerSpherePlus, outerSphereMinus);
	if ( sphereIntersect < 0.0 ) {
		discard;
	}
	
	vec3 resultColor = atmosphericScattering(centerPosition, eye, dir, l,  K_R, C_R, K_M, G_M, E, SCALE_L, SCALE_H, R, R_INNER);

	fragColor = vec4( resultColor, 1.0 );
}
