#version 120

varying vec4 color;
varying vec4 texcoord;
varying vec4 lmcoord;

#include "/lib/antialiasing/taaProjection.glsl"

void main() {
	gl_Position = ftransform();
	//gl_Position.z = 0.0f;

	#ifdef Enabled_TemportalAntiAliasing
		gl_Position.xy += jitter * 2.0 * gl_Position.w;
	#endif
	
	color = gl_Color;
	
	texcoord = gl_TextureMatrix[0] * gl_MultiTexCoord0;

	lmcoord = gl_TextureMatrix[1] * gl_MultiTexCoord1;
}