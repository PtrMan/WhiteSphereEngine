#version 430
#extension GL_ARB_separate_shader_objects : enable
#extension GL_ARB_shading_language_420pack : enable

layout (location = 0) in vec4 fragmentPosition;
layout (location = 1) in vec2 fragmentTextureCoordinate;

/* version for UINT
layout (location = 0) out uvec4 out_Color;

void main() {
  out_Color = uvec4(0.5, 0.25, 254.0, 1.0);
}
*/


// version for UNORM
layout (location = 0) out vec4 out_Color;

layout(binding = 0) uniform sampler2D texSampler;

void main() {
	vec4 textureSample = texture(texSampler, fragmentTextureCoordinate);


  out_Color = textureSample;//vec4(abs(textureSample.x), abs(textureSample.y), 1.0, 1.0);
}
