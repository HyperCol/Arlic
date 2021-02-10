#version 120

/*
                                                                
                       H                                         
                       HCHCHC                  H                
                       HCHCHCHCHC            HCH                
                       HCHCHCHCHCHCHCH    HCHCHCH               
                      HCHCHCHCHCHCHCHCHCHCHCHCHCHC              
           HCHCHCHCHCHCHCHCHCHCHCHCH HCHCHCHCHCHCHC             
     HCHCHCHCHCHCHCHCHCHCHCHCHCHC  HCHCHCHCHCHCHCHC             
        HCHCHCHCHCHCHC HCHCH         HCHCHCHCHCHCHCH            
          HCHCHCHCHCHC H                     HCHCHCH            
          HCHCHCHCHCH                      HCHCHCHCHCHCHCHCHCH  
         HCHCH HCHCH                        HCHCHCHCHCHCHCHC    
       HCHCHCHCH  HC                          HCHCHCHCHCHCH     
      HCHCHCHCHCH                              HCHCHCHCHCH      
     HCHCHCHCHCHCHC                         HCHC HCHCHCH        
   HCHCHCHCHCHCHCHCH                        HCHCHCHCHCH         
  HCHCHCHCHCHCHCHCHCHC                     HCHCHCHCHC           
            HCHCHCHCH                  HC HCHCHCHCHCHCH         
             HCHCHCHCHCHCHCHCHC   HCHCHCH HCHCHCHCHCHCHCHC      
             HCHCHCHCHCHCHCHC  HCHCHCHCHCHCHCHCHCHCHCHCHCHC     
              HCHCHCHCHCHCHCHCHCHCHCHCHCHCHCHCHC                
              HCHCHCHCHCHCHCHCHCHCHCHCHCH                       
               HCHCHC        HCHCHCHCHCHC                       
                HCH             HCHCHCHCH                       
                                      HCH                       
										H


2021@HyperCol Studios
VisionLab is part of HyperCol Studios
Do not modify this code until you have read the LICENSE contained in the root directory of this shaderpack!

*/

/////////ADJUSTABLE VARIABLES//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////ADJUSTABLE VARIABLES//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define SHADOW_MAP_BIAS 0.90

//#define ENABLE_SSAO





/////////INTERNAL VARIABLES////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////INTERNAL VARIABLES////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Do not change the name of these variables or their type. The Shaders Mod reads these lines and determines values to send to the inner-workings
//of the shaders mod. The shaders mod only reads these lines and doesn't actually know the real value assigned to these variables in GLSL.
//Some of these variables are critical for proper operation. Change at your own risk.

const int 		shadowMapResolution 	= 2048;	// Shadowmap resolution [1024 2048 4096]
const float 	shadowDistance 			= 120.0; // Shadow distance [80.0 120.0 180.0 240.0]
const float 	shadowIntervalSize 		= 4.0f;
const bool 		shadowHardwareFiltering0 = true;

const bool 		shadowtex1Mipmap = true;
const bool 		shadowtex1Nearest = false;
const bool 		shadowcolor0Mipmap = true;
const bool 		shadowcolor0Nearest = false;
const bool 		shadowcolor1Mipmap = true;
const bool 		shadowcolor1Nearest = false;

const int 		noiseTextureResolution  = 64;


//END OF INTERNAL VARIABLES//

uniform sampler2D gdepthtex;
uniform sampler2D depthtex0;
uniform sampler2D depthtex1;

uniform sampler2D gdepth;
uniform sampler2D gnormal;

uniform sampler2D shadowtex1;
uniform sampler2D shadowcolor1;
uniform sampler2D shadowcolor;

uniform sampler2D noisetex;

uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowModelViewInverse;
uniform mat4 shadowProjection;
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferProjection;

varying vec2 texcoord;
varying vec3 lightVector;

varying float timeSunriseSunset;
varying float timeNoon;
varying float timeMidnight;
varying float timeSkyDark;

varying vec3 colorSunlight;
varying vec3 colorSkylight;
varying vec3 colorSunglow;
varying vec3 colorBouncedSunlight;
varying vec3 colorScatteredSunlight;
varying vec3 colorTorchlight;
varying vec3 colorWaterMurk;
varying vec3 colorWaterBlue;
varying vec3 colorSkyTint;

uniform float viewWidth;
uniform float viewHeight;
uniform float rainStrength;
uniform float wetness;
uniform float aspectRatio;
uniform float frameTimeCounter;
uniform float sunAngle;
uniform vec3 skyColor;
uniform vec3 cameraPosition;

/////////////////////////FUNCTIONS/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////FUNCTIONS/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#include "/lib/common.glsl"
#include "/lib/antialiasing/taaProjection.glsl"
#include "/lib/packing.glsl"
#include "/lib/lighting/lighting.glsl"

vec3  	GetNormals(in vec2 coord) {				//Function that retrieves the screen space surface normals. Used for lighting calculations
	return NormalDecode(texture2D(gnormal, texcoord.xy).xy);
}

float 	GetDepth(in vec2 coord) {
	return texture2D(depthtex1, coord.st).x;
}

vec4  	GetScreenSpacePosition(in vec2 coord) {	//Function that calculates the screen-space position of the objects in the scene using the depth texture and the texture coordinates of the full-screen quad
	float depth = GetDepth(coord);
	vec4 fragposition = gbufferProjectionInverse * vec4(coord.s * 2.0f - 1.0f, coord.t * 2.0f - 1.0f, 2.0f * depth - 1.0f, 1.0f);
		 fragposition /= fragposition.w;
	
	return fragposition;
}

vec3 	CalculateNoisePattern1(vec2 offset, float size) {
	vec2 coord = texcoord.st;

	coord *= vec2(viewWidth, viewHeight);
	coord = mod(coord + offset, vec2(size));
	coord /= noiseTextureResolution;

	return texture2D(noisetex, coord).xyz;
}

vec2 DistortShadowSpace(in vec2 pos)
{
	vec2 signedPos = pos * 2.0f - 1.0f;

	float dist = sqrt(signedPos.x * signedPos.x + signedPos.y * signedPos.y);
	float distortFactor = (1.0f - SHADOW_MAP_BIAS) + dist * SHADOW_MAP_BIAS;
	signedPos.xy *= 0.95 / distortFactor;

	pos = signedPos * 0.5f + 0.5f;

	return pos;
}

vec3 Contrast(in vec3 color, in float contrast)
{
	float colorLength = length(color);
	vec3 nColor = color / colorLength;

	colorLength = pow(colorLength, contrast);

	return nColor * colorLength;
}

float 	GetMaterialIDs(in vec2 coord) {			//Function that retrieves the texture that has all material IDs stored in it
	return texture2D(gdepth, coord).r;
}

float GetSkylight(in vec2 coord)
{
	return texture2DLod(gdepth, coord, 0).b;
}

float 	GetMaterialMask(in vec2 coord, const in int ID) {
	float matID = (GetMaterialIDs(coord) * 255.0f);

	//Catch last part of sky
	if (matID > 254.0f) {
		matID = 0.0f;
	}

	if (matID == ID) {
		return 1.0f;
	} else {
		return 0.0f;
	}
}

bool GetSkyMask(in vec2 coord) {
	return bool(step(0.9999, texture2D(depthtex0, coord).x));
}

float R2_dither(){
	vec2 alpha = vec2(0.75487765, 0.56984026);
	
	#ifdef Enabled_TemportalAntiAliasing
	vec2 jittering = jitter * resolution;
	#else
	vec2 jittering = vec2(0.0);
	#endif

	return fract(alpha.x * (gl_FragCoord.x - jittering.x) + alpha.y * (gl_FragCoord.y - jittering.y));
}

float R2_dither(vec2 coord){
	vec2 alpha = vec2(0.75487765, 0.56984026);
	
	#ifdef Enabled_TemportalAntiAliasing
	coord -= jitter;
	#endif

	return fract(alpha.x * coord.x + alpha.y * coord.y);
}

float GetAO(in vec4 screenSpacePosition, in vec3 normal, in vec2 coord, in float dither)
{
	//Determine origin position
	vec3 origin = screenSpacePosition.xyz;

	vec3 randomRotation = vec3(cos(dither * 2.0 * Pi), sin(dither * 2.0 * Pi), 1.0);
	randomRotation.z = randomRotation.z - dot(randomRotation.xy, randomRotation.xy);
	//vec3 randomRotation = normalize(dither.xyz * vec3(2.0f, 2.0f, 1.0f) - vec3(1.0f, 1.0f, 0.0f));

	vec3 tangent = normalize(randomRotation - normal * dot(randomRotation, normal));
	vec3 bitangent = cross(normal, tangent);
	mat3 tbn = mat3(tangent, bitangent, normal);

	float aoRadius   = 0.15f * -screenSpacePosition.z;
		  //aoRadius   = 0.8f;
	float zThickness = 0.25f * -screenSpacePosition.z;
		  //zThickness = 2.2f;

	vec3 	samplePosition 		= vec3(0.0f);
	float 	intersect 			= 0.0f;
	vec4 	sampleScreenSpace 	= vec4(0.0f);
	float 	sampleDepth 		= 0.0f;
	float 	distanceWeight 		= 0.0f;
	float 	finalRadius 		= 0.0f;

	int numRaysPassed = 0;

	float ao = 0.0f;

	for (int i = 0; i < 4; i++)
	{
		vec3 kernel = vec3(texture2D(noisetex, vec2(0.1f + (i * 1.0f) / 64.0f)).r * 2.0f - 1.0f, 
					     texture2D(noisetex, vec2(0.1f + (i * 1.0f) / 64.0f)).g * 2.0f - 1.0f,
					     texture2D(noisetex, vec2(0.1f + (i * 1.0f) / 64.0f)).b * 1.0f);
			 kernel = normalize(kernel);
			 kernel *= pow(dither + 0.01f, 1.0f);

		samplePosition = tbn * kernel;
		samplePosition = samplePosition * aoRadius + origin;

			sampleScreenSpace = gbufferProjection * vec4(samplePosition, 0.0f);
			sampleScreenSpace.xyz /= sampleScreenSpace.w;
			sampleScreenSpace.xyz = sampleScreenSpace.xyz * 0.5f + 0.5f;

			//Check depth at sample point
			sampleDepth = GetScreenSpacePosition(sampleScreenSpace.xy).z;

			//If point is behind geometry, buildup AO
			if (sampleDepth >= samplePosition.z && sampleDepth - samplePosition.z < zThickness)
			{	
				ao += 1.0f;
			} else {

			}
	}
	ao /= 4;
	ao = 1.0f - ao;
	//ao = pow(ao, 2.0f);

	return ao;
}

vec4 GetLight(in float LOD, in vec2 offset, in float range, in float quality, vec3 noisePattern)
{
	float scale = exp2(LOD);

	float padding = 0.002f;
	/*
	if (	texcoord.s - offset.s + padding < 1.0f / scale + (padding * 2.0f) 
		&&  texcoord.t - offset.t + padding < 1.0f / scale + (padding * 2.0f)
		&&  texcoord.s - offset.s + padding > 0.0f 
		&&  texcoord.t - offset.t + padding > 0.0f)
		*/
	if(floor(texcoord.xy * scale - offset) == vec2(0.0))	
	{

		vec2 coord = (texcoord.st - offset.st) * scale;

		vec3 normal 				= GetNormals(coord.st);						//Gets the screen-space normals

		vec4 gn = gbufferModelViewInverse * vec4(normal.xyz, 0.0f);
			 gn = shadowModelView * gn;
			 gn.xyz = normalize(gn.xyz);

		vec3 shadowSpaceNormal = gn.xyz;

		vec4 screenSpacePosition 	= GetScreenSpacePosition(coord.st); 			//Gets the screen-space position
		vec3 viewVector 			= normalize(screenSpacePosition.xyz);

		float ao = 1.0f;
		// ao *= fakeLargeAO;
		bool isSky = GetSkyMask(coord.st);
		#ifdef ENABLE_SSAO
		if (!isSky)
		{
			ao *= GetAO(screenSpacePosition.xyzw, normal.xyz, coord.st, R2_dither(texcoord.xy * 0.25));
		}
		#endif

		//fakeIndirect.rgb = vec3(mcSkylight / 1150.0);

		return vec4(vec3(1.0), ao);
	}
	else {
		return vec4(0.0f);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////MAIN//////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void main() {
	vec3 noisePattern = CalculateNoisePattern1(vec2(0.0f), 4);
	vec4 screenSpacePosition = GetScreenSpacePosition(texcoord.st);
	vec4 worldSpacePosition = gbufferModelViewInverse * screenSpacePosition;
	vec4 worldLightVector = shadowModelViewInverse * vec4(0.0f, 0.0f, 1.0f, 0.0f);
	vec3 normal = GetNormals(texcoord.st);

	vec4 light = vec4(0.0, 0.0, 0.0, 1.0);
		 light = GetLight(0.0, vec2(0.0f), 16.0f,  2.0f, noisePattern);

	/* DRAWBUFFERS:4 */
	gl_FragData[0] = vec4(pow(light.rgb, vec3(1.0 / 2.2)), light.a);
}