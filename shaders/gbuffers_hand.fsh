#version 120





////////////////////////////////////////////////////ADJUSTABLE VARIABLES/////////////////////////////////////////////////////////

#define NORMAL_MAP_MAX_ANGLE 0.95f   		//The higher the value, the more extreme per-pixel normal mapping (bump mapping) will be.

///////////////////////////////////////////////////END OF ADJUSTABLE VARIABLES///////////////////////////////////////////////////

uniform sampler2D texture;
uniform sampler2D lightmap;
uniform sampler2D normals;
uniform sampler2D specular;
//uniform float rainStrength;
uniform float wetness;


varying vec4 color;
varying vec4 texcoord;
varying vec4 lmcoord;

varying vec3 normal;
varying vec3 tangent;
varying vec3 binormal;
varying vec3 globalNormal;

varying float distance;

const int GL_LINEAR = 9729;
const int GL_EXP = 2048;

const float bump_distance = 78.0f;
const float fademult = 0.1f;

#include "/lib/packing.glsl"

void main() {	

if (texture2D(texture, texcoord.st).a == 0.0f){
	//discard;
}

		
	vec4 spec = texture2D(specular, texcoord.st);

	//store lightmap in auxilliary texture. r = torch light. g = lightning. b = sky light.
	vec4 lightmap = vec4(0.0f, 0.0f, 0.0f, 1.0f);
	
	//Separate lightmap types
	lightmap.r = clamp((lmcoord.s * 33.05f / 32.0f) - 1.05f / 32.0f, 0.0f, 1.0f);
	lightmap.b = clamp((lmcoord.t * 33.05f / 32.0f) - 1.05f / 32.0f, 0.0f, 1.0f);
	
	lightmap.r = pow(lightmap.r, 3.0f);

	float wetfactor = clamp(lightmap.b - 0.9f, 0.0f, 0.1f) / 0.1f;
	
	
	vec4 frag2;
	
	if (distance < bump_distance) {
	
			vec3 bump = texture2D(normals, texcoord.st).rgb * 2.0f - 1.0f;
			
			float bumpmult = clamp(bump_distance * fademult - distance * fademult, 0.0f, 1.0f) * NORMAL_MAP_MAX_ANGLE;
	              bumpmult *= 1.0f - (spec.g * 0.9f * wetness * wetfactor);
				  
			bump = bump * vec3(bumpmult, bumpmult, bumpmult) + vec3(0.0f, 0.0f, 1.0f - bumpmult);
			
		
			mat3 tbnMatrix = mat3(tangent.x, binormal.x, normal.x,
								  tangent.y, binormal.y, normal.y,
						     	  tangent.z, binormal.z, normal.z);
			
			frag2 = vec4(bump * tbnMatrix * 0.5 + 0.5, 1.0);
			
	} else {
	
			frag2 = vec4((normal) * 0.5f + 0.5f, 1.0f);		
			
	}

	vec4 albedo = texture2D(texture, texcoord.st) * color;

	vec2 texturedNormal = NormalEncode(frag2.xyz) * 2.0 - 1.0;
	vec2 flatNormal = NormalEncode(normal);

	vec4 speculars = texture2D(specular, texcoord.xy);

	float smoothness = speculars.r;
	float metallic = speculars.g;
	float material = floor(speculars.b * 255.0);
	float emissive = speculars.a * step(speculars.a, 0.999);

	float packageMaterialData = pack2x8(smoothness, metallic);
	float encodeTextureMaterialID = material / 65535.0;
	float encodeBlocksMaterialID = 5.0 / 65535.0;

	float packageLightMap = pack2x8(lightmap.rb);

	/* DRAWBUFFERS:0123 */
	gl_FragData[0] = albedo;
	gl_FragData[1] = vec4(packageLightMap, emissive, 0.0, 1.0);
	gl_FragData[2] = vec4(texturedNormal, flatNormal);
	gl_FragData[3] = vec4(packageMaterialData, encodeTextureMaterialID, encodeBlocksMaterialID, 1.0);
}