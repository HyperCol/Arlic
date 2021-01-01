#version 120

varying vec4 color;
varying vec4 texcoord;
varying vec4 lmcoord;
varying vec3 worldPosition;


attribute vec4 mc_Entity;

uniform int worldTime;
uniform vec3 cameraPosition;
uniform float frameTimeCounter;
uniform float rainStrength;
uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowModelViewInverse;
uniform mat4 gbufferProjection;
uniform mat4 gbufferProjectionInverse;

uniform float aspectRatio;

uniform sampler2D noisetex;

varying vec3 normal;
varying vec3 tangent;
varying vec3 binormal;
varying vec2 waves;

varying float distance;
//varying float idCheck;

varying float materialIDs;

varying mat3 tbnMatrix;
varying vec4 vertexPos;
varying vec3 vertexViewVector;

uniform int entityId;

void main() {



	texcoord = gl_MultiTexCoord0;

	lmcoord = gl_TextureMatrix[1] * gl_MultiTexCoord1;
	
	vec4 viewpos = gbufferModelViewInverse * gl_ModelViewMatrix * gl_Vertex;
	vec4 position = viewpos;

	worldPosition = viewpos.xyz + cameraPosition.xyz;

	
	//Entity checker
	// if (mc_Entity.x == 1920.0f)
	// {
	// 	texcoord.st = vec2(0.2f);
	// }


	vec4 locposition = gl_ModelViewMatrix * gl_Vertex;
	
	distance = sqrt(locposition.x * locposition.x + locposition.y * locposition.y + locposition.z * locposition.z);


	gl_Position = gl_ProjectionMatrix * gbufferModelView * position;


	color = gl_Color;

	// float colorDiff = abs(color.r - color.g);
	// 	  colorDiff += abs(color.r - color.b);
	// 	  colorDiff += abs(color.g - color.b);

	// if (colorDiff < 0.001f && mc_Entity.x != -1.0f && mc_Entity.x != 63 && mc_Entity.x != 68 && mc_Entity.x != 323) {

	// 	float lum = color.r + color.g + color.b;
	// 		  lum /= 3.0f;

	// 	if (lum < 0.92f) {
	// 		color.rgb = vec3(1.0f);
	// 	}

	// }	
	
	gl_FogFragCoord = gl_Position.z;


	
	
	normal = normalize(gl_NormalMatrix * gl_Normal);

	//if(distance < 80.0f){	
		if (gl_Normal.x > 0.5) {
			//  1.0,  0.0,  0.0
			tangent  = normalize(gl_NormalMatrix * vec3( 0.0,  0.0,  1.0));
			binormal = normalize(gl_NormalMatrix * vec3( 0.0, -1.0,  0.0));
		} else if (gl_Normal.x < -0.5) {
			// -1.0,  0.0,  0.0
			tangent  = normalize(gl_NormalMatrix * vec3( 0.0,  0.0,  1.0));
			binormal = normalize(gl_NormalMatrix * vec3( 0.0, -1.0,  0.0));
		} else if (gl_Normal.y > 0.5) {
			//  0.0,  1.0,  0.0
			tangent  = normalize(gl_NormalMatrix * vec3( 1.0,  0.0,  0.0));
			binormal = normalize(gl_NormalMatrix * vec3( 0.0,  0.0,  1.0));
		} else if (gl_Normal.y < -0.5) {
			//  0.0, -1.0,  0.0
			tangent  = normalize(gl_NormalMatrix * vec3( 1.0,  0.0,  0.0));
			binormal = normalize(gl_NormalMatrix * vec3( 0.0,  0.0,  1.0));
		} else if (gl_Normal.z > 0.5) {
			//  0.0,  0.0,  1.0
			tangent  = normalize(gl_NormalMatrix * vec3( 1.0,  0.0,  0.0));
			binormal = normalize(gl_NormalMatrix * vec3( 0.0, -1.0,  0.0));
		} else if (gl_Normal.z < -0.5) {
			//  0.0,  0.0, -1.0
			tangent  = normalize(gl_NormalMatrix * vec3( 1.0,  0.0,  0.0));
			binormal = normalize(gl_NormalMatrix * vec3( 0.0, -1.0,  0.0));
		}
	//}

	
	tbnMatrix = mat3(tangent.x, binormal.x, normal.x,
                     tangent.y, binormal.y, normal.y,
                     tangent.z, binormal.z, normal.z);

	vertexPos = gl_Vertex;	
}