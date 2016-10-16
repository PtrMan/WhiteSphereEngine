#version 450

layout (location = 1) in vec2 fragmentTextureCoordinate;

/* version for UINT
layout (location = 0) out uvec4 out_Color;

void main() {
  out_Color = uvec4(0.5, 0.25, 254.0, 1.0);
}
*/


// version for UNORM
layout (location = 0) out vec4 out_Color;

void main() {
  out_Color = uvec4(0.5, 0.25, 1.0, 1.0);
}
