#version 450

layout (location = 1) in vec2 fragmentTextureCoordinate;

layout (location = 0) out uvec4 out_Color;

void main() {
  out_Color = uvec4(fragmentTextureCoordinate.x*1024.0, fragmentTextureCoordinate.y*1024.0, 512, 1024 );
}
