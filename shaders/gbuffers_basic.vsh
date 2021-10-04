#version 460 compatibility

#include "/libs/antialiasing/taaProjection.glsl"

out vec4 color;

void main() {
	gl_Position = ftransform();

	TAAProjection(gl_Position);
	
	color = gl_Color;

	gl_FogFragCoord = gl_Position.z;
}