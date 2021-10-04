#version 460 compatibility

out vec4 color;
out vec4 texcoord;

#include "/libs/antialiasing/taaProjection.glsl"

void main() {
	gl_Position = ftransform();
	TAAProjection(gl_Position);
	
	color = gl_Color;
	
	texcoord = gl_TextureMatrix[0] * gl_MultiTexCoord0;

	gl_FogFragCoord = gl_Position.z;
}