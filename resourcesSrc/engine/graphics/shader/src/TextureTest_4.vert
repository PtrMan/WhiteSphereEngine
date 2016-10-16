#version 430
#extension GL_ARB_separate_shader_objects : enable
#extension GL_ARB_shading_language_420pack : enable

layout (location = 0) in vec4 position;
layout (location = 1) in vec2 inTextureCoordinate;

layout (location = 0) out vec4 fragmentPosition;
layout (location = 1) out vec2 fragmentTextureCoordinate;

layout(std430, push_constant) uniform PushConstants
{
    mat4 mvp;
} constants;

void main() {
    gl_Position = constants.mvp * position;
    fragmentTextureCoordinate = inTextureCoordinate;

    fragmentPosition = constants.mvp * position;
}
