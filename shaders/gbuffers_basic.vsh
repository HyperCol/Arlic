#version 330 compatibility

#include "/libs/antialiasing/taaProjection.glsl"

out vec4 color;

void main() {
	gl_Position = ftransform();

#ifdef Enabled_TemportalAntiAliasing
	gl_Position.xy += jitter * 2.0 * gl_Position.w;
#endif
	
	color = gl_Color;

	gl_FogFragCoord = gl_Position.z;
}