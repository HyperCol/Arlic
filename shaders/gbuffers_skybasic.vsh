#version 120

varying vec4 color;

#include "/lib/antialiasing/taaProjection.glsl"

void main() {
	gl_Position = ftransform();

	#ifdef Enabled_TemportalAntiAliasing
		gl_Position.xy += jitter * 2.0 * gl_Position.w;
	#endif

	color = gl_Color;

	gl_FogFragCoord = gl_Position.z;
}