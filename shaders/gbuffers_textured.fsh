#version 120

uniform sampler2D texture;
uniform sampler2D specular;

varying vec4 color;
varying vec4 texcoord;
varying vec4 lmcoord;

varying vec3 normal;

#include "/lib/packing.glsl"

void main() {
	vec4 albedo = texture2D(texture, texcoord.xy);

	vec2 texturedNormal = NormalEncode(normal);
	vec2 flatNormal = NormalEncode(normal);

	vec4 speculars = texture2D(specular, texcoord.xy);

	float smoothness = speculars.r;
	float metallic = speculars.g;
	float material = floor(speculars.b * 255.0);
	float emissive = speculars.a * step(speculars.a, 0.999);

	float packageMaterialData = pack2x8(smoothness, metallic);
	float encodeTextureMaterialID = 0.0;
	float encodeBlocksMaterialID = 254.0 / 65535.0;

	float packageLightMap = pack2x8(lmcoord.xy);

	/* DRAWBUFFERS:0123 */
	gl_FragData[0] = albedo;
	gl_FragData[1] = vec4(packageLightMap, emissive, 0.0, 1.0);
	gl_FragData[2] = vec4(texturedNormal, flatNormal);
	gl_FragData[3] = vec4(packageMaterialData, encodeTextureMaterialID, encodeBlocksMaterialID, 1.0);
}