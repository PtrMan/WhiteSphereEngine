#version 430
#extension GL_ARB_separate_shader_objects : enable
#extension GL_ARB_shading_language_420pack : enable

layout (location = 0) in vec4 fragmentPosition;
layout (location = 1) in vec2 fragmentTextureCoordinate;

layout (location = 0) out vec4 out_color;
layout (location = 1) out vec4 out_normal;
layout (location = 2) out float out_depth;

layout(binding = 0) uniform sampler2D texSampler;

void main() {
	vec4 textureSample = texture(texSampler, fragmentTextureCoordinate);


	out_color = textureSample;//vec4(abs(textureSample.x), abs(textureSample.y), 1.0, 1.0);
	out_normal = vec4(0, 0, -1, 0);
	out_depth = fragmentPosition.z;
}
