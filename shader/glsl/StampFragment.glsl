#version 140
 
precision highp float; // needed only for version 1.30
 
//in  vec3 ex_Color;
in  vec3 ex_coordinate;
out vec4 out_Color;
 
void main(void) {
	float distanceFromOrigin = ex_coordinate.x*ex_coordinate.x + ex_coordinate.y*ex_coordinate.y;

	if( distanceFromOrigin > 1.0f ) {
		out_Color = vec4(0.0, 0.0, 0.0, 0.0);
	}
	else {
		float value = 1.0 - sqrt(distanceFromOrigin);

		out_Color = vec4(value, value, value,1.0);
	}
}
