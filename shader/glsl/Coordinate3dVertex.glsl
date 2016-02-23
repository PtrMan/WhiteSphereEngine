#version 140
 
in  vec3 in_Position;
in  vec3 in_coordinate;
out vec3 ex_coordinate;

void main(void) {
	gl_Position = vec4(in_Position, 1.0);
	ex_coordinate = in_coordinate;
}
