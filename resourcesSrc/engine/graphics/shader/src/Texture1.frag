#version 450

layout (location = 1) in vec2 fragmentTextureCoordinate;

layout (location = 0) out uvec4 out_Color;

void main() {
  out_Color = uvec4(0.5, 0.25, 100.0, 1.0);
}
