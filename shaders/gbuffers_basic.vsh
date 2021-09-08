#version 330 compatibility

#include "/libs/antialiasing/taaProjection.glsl"

out vec4 color;

void main() {
	gl_Position = ftransform();

<<<<<<< HEAD
	TAAProjection(gl_Position);
=======
#ifdef Enabled_TemportalAntiAliasing
	gl_Position.xy += jitter * 2.0 * gl_Position.w;
#endif
>>>>>>> e791f6bfc7e8b945603c3d9b59878a446e19d942
	
	color = gl_Color;

	gl_FogFragCoord = gl_Position.z;
}