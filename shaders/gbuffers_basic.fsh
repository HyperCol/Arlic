#version 120

varying vec2 lmcoord;

varying vec4 color;

const int GL_LINEAR = 9729;
const int GL_EXP = 2048;

uniform int fogMode;

/* DRAWBUFFERS:0123 */

#include "/lib/packing.glsl"

void main() {

	vec4 lightmap = vec4(0.0f, 0.0f, 0.0f, 1.0f);
	
	//Separate lightmap types
	lightmap.r = clamp((lmcoord.s * 33.05f / 32.0f) - 1.05f / 32.0f, 0.0f, 1.0f);
	lightmap.b = clamp((lmcoord.t * 33.05f / 32.0f) - 1.05f / 32.0f, 0.0f, 1.0f);
	
	lightmap.r = pow(lightmap.r, 3.0f);

	vec4 albedo = color;

	gl_FragData[0] = vec4(albedo.rgb, 1.0);
	gl_FragData[1] = vec4(pack2x8(lightmap.rb), 0.0, 0.0, 1.0);
	gl_FragData[2] = vec4(0.0, 0.0, 0.0, 1.0);
	gl_FragData[3] = vec4(0.0, 0.0, 252.0 / 65535.0, 1.0);

	if (fogMode == GL_EXP) {
		gl_FragData[0].rgb = mix(gl_FragData[0].rgb, (gl_Fog.color.rgb * 1.0), 1.0 - clamp(exp(-gl_Fog.density * gl_FogFragCoord), 0.0, 1.0));
	} else if (fogMode == GL_LINEAR) {
		gl_FragData[0].rgb = mix(gl_FragData[0].rgb, (gl_Fog.color.rgb * 1.0), clamp((gl_FogFragCoord - gl_Fog.start) * gl_Fog.scale, 0.0, 1.0));
	}
	
	//gl_FragData[7] = vec4(0.0f, 0.0f, 0.0f, 0.0f);
}