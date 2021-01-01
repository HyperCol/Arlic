#version 130

/*
 _______ _________ _______  _______  _
(  ____ \\__   __/(  ___  )(  ____ )( )
| (    \/   ) (   | (   ) || (    )|| |
| (_____    | |   | |   | || (____)|| |
(_____  )   | |   | |   | ||  _____)| |
      ) |   | |   | |   | || (      (_)
/\____) |   | |   | (___) || )       _
\_______)   )_(   (_______)|/       (_)

Do not modify this code until you have read the LICENSE.txt contained in the root directory of this shaderpack!

*/

//#define SMOOTH_CLOUDS // Smooth out dither pattern from volumetric clouds. Not necessary if HQ Volumetric Clouds is enabled.
#define CREPUSCULAR_RAYS // Light rays from sunlight

//#define COMPOSITE2_FINAL

/* DRAWBUFFERS:2 */
const bool gcolorMipmapEnabled = true;
const bool gdepthMipmapEnabled = true;
const bool compositeMipmapEnabled = false;

uniform sampler2D gcolor;
uniform sampler2D gdepth;
uniform sampler2D gdepthtex;
uniform sampler2D depthtex1;
uniform sampler2D gnormal;
uniform sampler2D composite;
uniform sampler2D noisetex;
//uniform sampler2D gaux1;
//uniform sampler2D gaux1;
uniform sampler2D gaux2;
uniform sampler2D gaux3;
uniform sampler2D gaux4;

uniform float near;
uniform float far;
uniform float viewWidth;
uniform float viewHeight;
uniform float rainStrength;
uniform float wetness;
uniform float aspectRatio;
uniform float frameTimeCounter;
uniform int worldTime;
uniform int   isEyeInWater;

uniform mat4 gbufferProjection;
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferPreviousProjection;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferPreviousModelView;
uniform mat4 shadowModelViewInverse;
uniform mat4 gbufferModelView;

uniform vec3 cameraPosition;
uniform vec3 previousCameraPosition;
uniform vec3 fogColor;

varying vec4 texcoord;

varying vec3 lightVector;
varying vec3 upVector;
uniform ivec2 eyeBrightnessSmooth;

varying float timeSunriseSunset;
varying float timeNoon;
varying float timeMidnight;
varying float timeSkyDark;

varying vec3 colorSunlight;
varying vec3 colorSkylight;
varying vec3 colorBouncedSunlight;




#define ANIMATION_SPEED 1.0f


#define FRAME_TIME frameTimeCounter * ANIMATION_SPEED


/////////////////////////FUNCTIONS/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////FUNCTIONS/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

float saturate(float x)
{
	return clamp(x, 0.0, 1.0);
}

vec3 GetNormals(in vec2 coord) {
	vec3 normal = vec3(0.0f);
		 normal = texture2DLod(gnormal, coord.st, 0).rgb;
	normal = normal * 2.0f - 1.0f;

	normal = normalize(normal);

	return normal;
}

float GetDepth(in vec2 coord) {
	return texture2D(gdepthtex, coord).x;
}

float 	ExpToLinearDepth(in float depth)
{
	return 2.0f * near * far / (far + near - (2.0f * depth - 1.0f) * (far - near));
}

float GetDepthLinear(vec2 coord) {
    return 2.0 * near * far / (far + near - (2.0 * texture2D(gdepthtex, coord).x - 1.0) * (far - near));
}

vec4 	GetTransparentAlbedo(in vec2 coord)
{
	return pow(texture2D(gaux4, coord), vec4(2.2));
}

vec4  	GetViewSpacePosition(in vec2 coord) {	//Function that calculates the screen-space position of the objects in the scene using the depth texture and the texture coordinates of the full-screen quad
	float depth = GetDepth(coord);
		  //depth += float(GetMaterialMask(coord, 5)) * 0.38f;
	vec4 fragposition = gbufferProjectionInverse * vec4(coord.s * 2.0f - 1.0f, coord.t * 2.0f - 1.0f, 2.0f * depth - 1.0f, 1.0f);
		 fragposition /= fragposition.w;

	return fragposition;
}

float 	GetMaterialIDs(in vec2 coord) {			//Function that retrieves the texture that has all material IDs stored in it
	return texture2DLod(gdepth, coord, 0).r;
}

float 	GetTransparentID(in vec2 coord)
{
	return texture2D(gaux3, coord).a;
}

vec3 GetSunlightVisibility(in vec2 coord)
{
	return texture2D(gaux2, coord).rgb;
}

float cubicPulse(float c, float w, float x)
{
	x = abs(x - c);
	if (x > w) return 0.0f;
	x /= w;
	return 1.0f - x * x * (3.0f - 2.0f * x);
}

bool 	GetMaterialMask(in vec2 coord, in int ID, in float matID) {
		  matID = floor(matID * 255.0f);

	if (matID == ID) {
		return true;
	} else {
		return false;
	}
}

bool 	GetSkyMask(in vec2 coord, in float matID)
{
	matID = floor(matID * 255.0f);

	if (matID < 1.0f || matID > 254.0f)
	{
		return true;
	} else {
		return false;
	}
}

bool 	GetSkyMask(in vec2 coord)
{
	float matID = GetMaterialIDs(coord);
	matID = floor(matID * 255.0f);

	if (matID < 1.0f || matID > 254.0f)
	{
		return true;
	} else {
		return false;
	}
}

float 	GetSpecularity(in vec2 coord)
{
	return texture2D(composite, coord).r;
}

float 	GetRoughness(in vec2 coord)
{
	return pow(texture2D(composite, coord).b, 1.5);
}



bool  	GetWaterMask(in float matID) {					//Function that returns "true" if a pixel is water, and "false" if a pixel is not water.
	matID = floor(matID * 255.0f);

	if (matID >= 35.0f && matID <= 51) {
		return true;
	} else {
		return false;
	}
}

bool  	GetStainedGlassMask(in float matID) {					//Function that returns "true" if a pixel is water, and "false" if a pixel is not water.
	matID = floor(matID * 255.0f);

	if (matID >= 55.0f && matID <= 70.0f) {
		return true;
	} else {
		return false;
	}
}

bool  	GetIceMask(in float matID) {					//Function that returns "true" if a pixel is water, and "false" if a pixel is not water.
	matID = floor(matID * 255.0f);

	if (matID == 4) {
		return true;
	} else {
		return false;
	}
}

bool  	GetWaterMask(in vec2 coord) {					//Function that returns "true" if a pixel is water, and "false" if a pixel is not water.
	float matID = floor(GetMaterialIDs(coord) * 255.0f);

	if (matID >= 35.0f && matID <= 51) {
		return true;
	} else {
		return false;
	}
}

float 	GetLightmapSky(in vec2 coord) {
	return texture2DLod(gdepth, texcoord.st, 0).b;
}

vec3 convertScreenSpaceToWorldSpace(vec2 co) {
    vec4 fragposition = gbufferProjectionInverse * vec4(vec3(co, texture2DLod(gdepthtex, co, 0).x) * 2.0 - 1.0, 1.0);
    fragposition /= fragposition.w;
    return fragposition.xyz;
}

vec3 convertCameraSpaceToScreenSpace(vec3 cameraSpace) {
    vec4 clipSpace = gbufferProjection * vec4(cameraSpace, 1.0);
    vec3 NDCSpace = clipSpace.xyz / clipSpace.w;
    vec3 screenSpace = 0.5 * NDCSpace + 0.5;
		 screenSpace.z = 0.1f;
    return screenSpace;
}

float  	CalculateDitherPattern1() {
	int[16] ditherPattern = int[16] (0 , 9 , 3 , 11,
								 	 13, 5 , 15, 7 ,
								 	 4 , 12, 2,  10,
								 	 16, 8 , 14, 6 );

	vec2 count = vec2(0.0f);
	     count.x = floor(mod(texcoord.s * viewWidth, 4.0f));
		 count.y = floor(mod(texcoord.t * viewHeight, 4.0f));

	int dither = ditherPattern[int(count.x) + int(count.y) * 4];

	return float(dither) / 17.0f;
}

float  	CalculateDitherPattern2() {
	int[16] ditherPattern = int[16] (4 , 12, 2,  10,
								 	 16, 8 , 14, 6 ,
								 	 0 , 9 , 3 , 11,
								 	 13, 5 , 15, 7 );

	vec2 count = vec2(0.0f);
	     count.x = floor(mod(texcoord.s * viewWidth, 4.0f));
		 count.y = floor(mod(texcoord.t * viewHeight, 4.0f));

	int dither = ditherPattern[int(count.x) + int(count.y) * 4];

	return float(dither) / 17.0f;
}

vec3 	CalculateNoisePattern1(vec2 offset, float size) {
	vec2 coord = texcoord.st;

	coord *= vec2(viewWidth, viewHeight);
	coord = mod(coord + offset, vec2(size));
	coord /= 64.0f;

	return texture2D(noisetex, coord).xyz;
}

float noise (in float offset)
{
	vec2 coord = texcoord.st + vec2(offset);
	float noise = clamp(fract(sin(dot(coord ,vec2(12.9898f,78.233f))) * 43758.5453f),0.0f,1.0f)*2.0f-1.0f;
	return noise;
}

float noise (in vec2 coord, in float offset)
{
	coord += vec2(offset);
	float noise = clamp(fract(sin(dot(coord ,vec2(12.9898f,78.233f))) * 43758.5453f),0.0f,1.0f)*2.0f-1.0f;
	return noise;
}

void 	DoNightEye(inout vec3 color) {			//Desaturates any color input at night, simulating the rods in the human eye

	float amount = 0.8f; 						//How much will the new desaturated and tinted image be mixed with the original image
	vec3 rodColor = vec3(0.2f, 0.5f, 1.0f); 	//Cyan color that humans percieve when viewing extremely low light levels via rod cells in the eye
	float colorDesat = dot(color, vec3(1.0f)); 	//Desaturated color

	color = mix(color, vec3(colorDesat) * rodColor, timeMidnight * amount);
	//color.rgb = color.rgb;
}


float Get3DNoise(in vec3 pos)
{
	pos.z += 0.0f;

	pos.xyz += 0.5f;

	vec3 p = floor(pos);
	vec3 f = fract(pos);

	f.x = f.x * f.x * (3.0f - 2.0f * f.x);
	f.y = f.y * f.y * (3.0f - 2.0f * f.y);
	f.z = f.z * f.z * (3.0f - 2.0f * f.z);

	vec2 uv =  (p.xy + p.z * vec2(17.0f)) + f.xy;
	vec2 uv2 = (p.xy + (p.z + 1.0f) * vec2(17.0f)) + f.xy;

	// uv -= 0.5f;
	// uv2 -= 0.5f;

	vec2 coord =  (uv  + 0.5f) / 64.0f;
	vec2 coord2 = (uv2 + 0.5f) / 64.0f;
	float xy1 = texture2D(noisetex, coord).x;
	float xy2 = texture2D(noisetex, coord2).x;
	return mix(xy1, xy2, f.z);
	//return texture2D(noisetex, pos.xz / 64.0f).x;
}

float Get3DNoiseBillow(in vec3 pos)
{
	pos.z += 0.0f;

	pos.xyz += 0.5f;

	vec3 p = floor(pos);
	vec3 f = fract(pos);

	f.x = f.x * f.x * (3.0f - 2.0f * f.x);
	f.y = f.y * f.y * (3.0f - 2.0f * f.y);
	f.z = f.z * f.z * (3.0f - 2.0f * f.z);

	vec2 uv =  (p.xy + p.z * vec2(17.0f)) + f.xy;
	vec2 uv2 = (p.xy + (p.z + 1.0f) * vec2(17.0f)) + f.xy;

	// uv -= 0.5f;
	// uv2 -= 0.5f;

	vec2 coord =  (uv  + 0.5f) / 64.0f;
	vec2 coord2 = (uv2 + 0.5f) / 64.0f;
	float xy1 = texture2D(noisetex, coord).x;
	float xy2 = texture2D(noisetex, coord2).x;
	//return mix(xy1, xy2, f.z);
	return abs(mix(xy1, xy2, f.z) * 2.0 - 1.0);
	//return texture2D(noisetex, pos.xz / 64.0f).x;
}

float Get3DNoiseRidges(in vec3 pos)
{
	pos.z += 0.0f;

	pos.xyz += 0.5f;

	vec3 p = floor(pos);
	vec3 f = fract(pos);

	f.x = f.x * f.x * (3.0f - 2.0f * f.x);
	f.y = f.y * f.y * (3.0f - 2.0f * f.y);
	f.z = f.z * f.z * (3.0f - 2.0f * f.z);

	vec2 uv =  (p.xy + p.z * vec2(17.0f)) + f.xy;
	vec2 uv2 = (p.xy + (p.z + 1.0f) * vec2(17.0f)) + f.xy;

	// uv -= 0.5f;
	// uv2 -= 0.5f;

	vec2 coord =  (uv  + 0.5f) / 64.0f;
	vec2 coord2 = (uv2 + 0.5f) / 64.0f;
	float xy1 = texture2D(noisetex, coord).x;
	float xy2 = texture2D(noisetex, coord2).x;
	//return mix(xy1, xy2, f.z);
	return 1.0 - abs(mix(xy1, xy2, f.z) * 2.0 - 1.0);
	//return texture2D(noisetex, pos.xz / 64.0f).x;
}




vec3 Get3DNoise2(in vec3 pos)
{
	pos.z += 0.0f;

	pos.xyz += 0.5f;

	vec3 p = floor(pos);
	vec3 f = fract(pos);

	// f.x = f.x * f.x * (3.0f - 2.0f * f.x);
	// f.y = f.y * f.y * (3.0f - 2.0f * f.y);
	// f.z = f.z * f.z * (3.0f - 2.0f * f.z);

	vec2 uv =  (p.xy + p.z * vec2(17.0f)) + f.xy;
	vec2 uv2 = (p.xy + (p.z + 1.0f) * vec2(17.0f)) + f.xy;

	// uv -= 0.5f;
	// uv2 -= 0.5f;

	vec2 coord =  (uv  + 0.5f) / 64.0;
	vec2 coord2 = (uv2 + 0.5f) / 64.0;
	vec3 xy1 = texture2D(noisetex, coord).rgb;
	vec3 xy2 = texture2D(noisetex, coord2).rgb;
	return mix(xy1, xy2, vec3(f.z));
}

/////////////////////////STRUCTS///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////STRUCTS///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

struct MaskStruct {

	float matIDs;

	bool sky;
	bool land;
	bool tallGrass;
	bool leaves;
	bool ice;
	bool hand;
	bool translucent;
	bool glow;
	bool goldBlock;
	bool ironBlock;
	bool diamondBlock;
	bool emeraldBlock;
	bool sand;
	bool sandstone;
	bool stone;
	bool cobblestone;
	bool wool;

	bool torch;
	bool lava;
	bool glowstone;
	bool fire;

	bool water;
	bool stainedGlass;

};

struct Ray {
	vec3 dir;
	vec3 origin;
};

struct Plane {
	vec3 normal;
	vec3 origin;
};

struct SurfaceStruct {
	MaskStruct 		mask;			//Material ID Masks

	//Properties that are required for lighting calculation
		vec3 	color;					//Diffuse texture aka "color texture"
		vec3 	normal;					//Screen-space surface normals
		float 	depth;					//Scene depth
		float 	linearDepth;			//Scene depth

		float 	rDepth;
		float  	specularity;
		vec3 	specularColor;
		float 	roughness;
		float   fresnelPower;
		float 	baseSpecularity;
		Ray 	viewRay;
		float skylight;


		vec4 	viewSpacePosition;
		vec4 	worldSpacePosition;
		vec3 	worldLightVector;
		vec3  	upVector;
		vec3 	lightVector;

		vec3 	sunlightVisibility;

		vec4 	reflection;

		float 	cloudAlpha;
} surface;

struct Intersection {
	vec3 pos;
	float distance;
	float angle;
};



/////////////////////////STRUCT FUNCTIONS//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////STRUCT FUNCTIONS//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void 	CalculateMasks(inout MaskStruct mask) {
	mask.sky 			= GetSkyMask(texcoord.st, mask.matIDs);
	mask.land	 		= !mask.sky;
	mask.tallGrass 		= GetMaterialMask(texcoord.st, 2, mask.matIDs);
	mask.leaves	 		= GetMaterialMask(texcoord.st, 3, mask.matIDs);
	mask.hand	 		= GetMaterialMask(texcoord.st, 5, mask.matIDs);
	mask.translucent	= GetMaterialMask(texcoord.st, 6, mask.matIDs);

	mask.glow	 		= GetMaterialMask(texcoord.st, 10, mask.matIDs);

	mask.goldBlock 		= GetMaterialMask(texcoord.st, 20, mask.matIDs);
	mask.ironBlock 		= GetMaterialMask(texcoord.st, 21, mask.matIDs);
	mask.diamondBlock	= GetMaterialMask(texcoord.st, 22, mask.matIDs);
	mask.emeraldBlock	= GetMaterialMask(texcoord.st, 23, mask.matIDs);
	mask.sand	 		= GetMaterialMask(texcoord.st, 24, mask.matIDs);
	mask.sandstone 		= GetMaterialMask(texcoord.st, 25, mask.matIDs);
	mask.stone	 		= GetMaterialMask(texcoord.st, 26, mask.matIDs);
	mask.cobblestone	= GetMaterialMask(texcoord.st, 27, mask.matIDs);
	mask.wool			= GetMaterialMask(texcoord.st, 28, mask.matIDs);

	mask.torch 			= GetMaterialMask(texcoord.st, 30, mask.matIDs);
	mask.lava 			= GetMaterialMask(texcoord.st, 31, mask.matIDs);
	mask.glowstone 		= GetMaterialMask(texcoord.st, 32, mask.matIDs);
	mask.fire 			= GetMaterialMask(texcoord.st, 33, mask.matIDs);

	float transparentID = GetTransparentID(texcoord.st);

	mask.water 			= GetWaterMask(transparentID);
	mask.stainedGlass 	= GetStainedGlassMask(transparentID);
	mask.ice 			= GetIceMask(transparentID);
}

vec4 	ComputeRaytraceReflection(inout SurfaceStruct surface)
{
	float reflectionRange = 2.0f;
    float initialStepAmount = 1.0 - clamp(0.1f / 100.0, 0.0, 0.99);
		  initialStepAmount *= 1.0f;


	 // vec2 dither = CalculateNoisePattern1(vec2(0.0f), 4.0f).xy * 2.0f - 1.0f;
	 // vec3 ditherNormal = vec3(0.0f);
	 // 	 ditherNormal.x = dither.x;
	 // 	 ditherNormal.y = dither.y;
	 // 	 ditherNormal.z = sqrt(1.0f - dither.x * dither.x - dither.y * dither.y);
	 // 	 ditherNormal.z = -1.0f;

	 // 	 ditherNormal = normalize(ditherNormal);
	 // 	 ditherNormal -= normalize(surface.viewSpacePosition.xyz) * 1.0f;



    vec2 screenSpacePosition2D = texcoord.st;
    vec3 cameraSpacePosition = convertScreenSpaceToWorldSpace(screenSpacePosition2D);

    vec3 cameraSpaceNormal = surface.normal;
    	 //cameraSpaceNormal += ditherNormal * 0.65f * surface.roughness;

    vec3 cameraSpaceViewDir = normalize(cameraSpacePosition);
    vec3 cameraSpaceVector = initialStepAmount * normalize(reflect(cameraSpaceViewDir,cameraSpaceNormal));
    vec3 cameraSpaceVectorFar = far * normalize(reflect(cameraSpaceViewDir,cameraSpaceNormal));
	vec3 oldPosition = cameraSpacePosition;
    vec3 cameraSpaceVectorPosition = oldPosition + cameraSpaceVector;
    vec3 currentPosition = convertCameraSpaceToScreenSpace(cameraSpaceVectorPosition);
    vec4 color = vec4(pow(texture2D(gcolor, screenSpacePosition2D).rgb, vec3(3.0f + 1.2f)), 0.0);
    const int maxRefinements = 3;
	int numRefinements = 0;
    int count = 0;
	vec2 finalSamplePos = vec2(0.0f);

	int numSteps = 0;

    //while(count < far/initialStepAmount*reflectionRange)
    for (int i = 0; i < 40; i++)
    {
        if(currentPosition.x < 0 || currentPosition.x > 1 ||
           currentPosition.y < 0 || currentPosition.y > 1 ||
           currentPosition.z < 0 || currentPosition.z > 1 ||
           -cameraSpaceVectorPosition.z > far * 1.4f ||
           -cameraSpaceVectorPosition.z < 0.0f)
        {
		   break;
		}

        vec2 samplePos = currentPosition.xy;
        float sampleDepth = convertScreenSpaceToWorldSpace(samplePos).z;

        float currentDepth = cameraSpaceVectorPosition.z;
        float diff = sampleDepth - currentDepth;
        float error = length(cameraSpaceVector / pow(2.0f, numRefinements));

        //If a collision was detected, refine raymarch
        if(diff >= 0 && diff <= error * 2.00f && numRefinements <= maxRefinements)
        {
        	//Step back
        	cameraSpaceVectorPosition -= cameraSpaceVector / pow(2.0f, numRefinements);
        	++numRefinements;
		//If refinements run out
		}
		else if (diff >= 0 && diff <= error * 4.0f && numRefinements > maxRefinements)
		{
			finalSamplePos = samplePos;
			break;
		}



        cameraSpaceVectorPosition += cameraSpaceVector / pow(2.0f, numRefinements);

        if (numSteps > 1)
        cameraSpaceVector *= 1.375f;	//Each step gets bigger

		currentPosition = convertCameraSpaceToScreenSpace(cameraSpaceVectorPosition);
        count++;
        numSteps++;
    }

	color = pow(texture2DLod(gcolor, finalSamplePos, 0), vec4(2.2f));

	if (finalSamplePos.x == 0.0f || finalSamplePos.y == 0.0f) {
		color.a = 0.0f;
	}

	if (GetSkyMask(finalSamplePos))
		color.a = 0.0f;

	// if (GetWaterMask(finalSamplePos))
	// 	color.a = 0.0f;

	//color.a *= clamp(1 - pow(distance(vec2(0.5), finalSamplePos)*2.0, 2.0), 0.0, 1.0);
	// color.a *= 1.0f - float(GetMaterialMask(finalSamplePos, 0, surface.mask.matIDs));

	//surface.color = vec3(numSteps / 10000000.0f);

    return color;
}

float 	CalculateLuminance(in vec3 color) {
	return (color.r * 0.2126f + color.g * 0.7152f + color.b * 0.0722f);
}

float   CalculateSunglow(in SurfaceStruct surface) {

	float curve = 4.0f;

	vec3 npos = normalize(surface.viewSpacePosition.xyz);
	vec3 halfVector2 = normalize(-surface.lightVector + npos);
	float factor = 1.0f - dot(halfVector2, npos);

	return factor * factor * factor * factor;
}

float   CalculateReflectedSunglow(in SurfaceStruct surface) {

	float curve = 4.0f;

	vec3 npos = normalize(surface.viewSpacePosition.xyz);
	surface.lightVector = reflect(surface.lightVector, surface.normal);
	vec3 halfVector2 = normalize(-surface.lightVector + npos);
	float factor = 1.0f - dot(halfVector2, npos);

	return factor * factor * factor * factor;
}

float   CalculateAntiSunglow(in SurfaceStruct surface) {

	float curve = 4.0f;

	vec3 npos = normalize(surface.viewSpacePosition.xyz);
	vec3 halfVector2 = normalize(surface.lightVector + npos);
	float factor = 1.0f - dot(halfVector2, npos);

	return factor * factor * factor * factor;
}

float   CalculateSunspot(in SurfaceStruct surface) {

	float curve = 1.0f;

	vec3 npos = normalize(surface.viewSpacePosition.xyz);
	vec3 halfVector2 = normalize(-surface.lightVector + npos);

	float sunProximity = abs(1.0f - dot(halfVector2, npos));

	//surface.roughness = 0.5f;

	float sizeFactor = 0.959f - surface.roughness * 0.7f;

	float sunSpot = (clamp(sunProximity, sizeFactor, 0.96f) - sizeFactor) / (0.96f - sizeFactor);
		  sunSpot = pow(cubicPulse(1.0f, 1.0f, sunSpot), 2.0f);

	// if (sunProximity > 0.96f) {
	// 	return 1.0f;
	// } else {
	// 	return 0.0f;
	// }

	float result = sunSpot / (surface.roughness * 20.0f + 0.1f);

	return result;
	//return 0.0f;
}

vec3 	ComputeReflectedSkyGradient(in SurfaceStruct surface) {
	float curve = 5.0f;
	surface.viewSpacePosition.xyz = reflect(surface.viewSpacePosition.xyz, surface.normal);
	vec3 npos = normalize(surface.viewSpacePosition.xyz);

	//surface.upVector = reflect(upVector, surface.normal);
	//surface.lightVector = reflect(lightVector, surface.normal);

	vec3 halfVector2 = normalize(-surface.upVector + npos);
	float skyGradientFactor = dot(halfVector2, npos);
	float skyGradientRaw = skyGradientFactor;
	float skyDirectionGradient = skyGradientFactor;

	if (dot(halfVector2, npos) > 0.75)
		skyGradientFactor = 1.5f - skyGradientFactor;

	skyGradientFactor = pow(skyGradientFactor, curve);

	vec3 skyColor = CalculateLuminance(pow(gl_Fog.color.rgb, vec3(2.2f))) * colorSkylight;

	skyColor *= mix(skyGradientFactor, 1.0f, clamp((0.12f - (timeNoon * 0.1f)) + rainStrength, 0.0f, 1.0f));
	skyColor *= pow(skyGradientFactor, 2.5f) + 0.2f;
	skyColor *= (pow(skyGradientFactor, 1.1f) + 0.425f) * 0.5f;
	skyColor.g *= skyGradientFactor * 1.0f + 1.0f;


	vec3 linFogColor = pow(gl_Fog.color.rgb, vec3(2.2f));

	float fogLum = max(max(linFogColor.r, linFogColor.g), linFogColor.b);


	float fadeSize = 0.0f;

	float fade1 = clamp(skyGradientFactor - 0.05f, 0.0f, 0.2f) / 0.2f;
		  fade1 = fade1 * fade1 * (3.0f - 2.0f * fade1);
	vec3 color1 = vec3(12.0f, 8.0, 4.7f) * 0.15f;
		 color1 = mix(color1, vec3(2.0f, 0.55f, 0.2f), vec3(timeSunriseSunset));

	skyColor *= mix(vec3(1.0f), color1, vec3(fade1));

	float fade2 = clamp(skyGradientFactor - 0.11f, 0.0f, 0.2f) / 0.2f;
	vec3 color2 = vec3(2.7f, 1.0f, 2.8f) / 20.0f;
		 color2 = mix(color2, vec3(1.0f, 0.15f, 0.5f), vec3(timeSunriseSunset));


	skyColor *= mix(vec3(1.0f), color2, vec3(fade2 * 0.5f));




	float horizonGradient = 1.0f - distance(skyDirectionGradient, 0.72f + fadeSize) / (0.72f + fadeSize);
		  horizonGradient = pow(horizonGradient, 10.0f);
		  horizonGradient = max(0.0f, horizonGradient);

	float sunglow = CalculateSunglow(surface);
		  horizonGradient *= sunglow * 2.0f+ (0.65f - timeSunriseSunset * 0.55f);

	vec3 horizonColor1 = vec3(1.5f, 1.5f, 1.5f);
		 horizonColor1 = mix(horizonColor1, vec3(1.5f, 1.95f, 1.5f) * 2.0f, vec3(timeSunriseSunset));
	vec3 horizonColor2 = vec3(1.5f, 1.2f, 0.8f) * 1.0f;
		 horizonColor2 = mix(horizonColor2, vec3(1.9f, 0.6f, 0.4f) * 2.0f, vec3(timeSunriseSunset));

	skyColor *= mix(vec3(1.0f), horizonColor1, vec3(horizonGradient) * (1.0f - timeMidnight));
	skyColor *= mix(vec3(1.0f), horizonColor2, vec3(pow(horizonGradient, 2.0f)) * (1.0f - timeMidnight));

	float grayscale = fogLum / 10.0f;
		  grayscale /= 3.0f;

	float rainSkyBrightness = 1.2f;
		  rainSkyBrightness *= mix(0.05f, 10.0f, timeMidnight);

	skyColor = mix(skyColor, vec3(grayscale * colorSkylight.r) * 0.06f * vec3(0.85f, 0.85f, 1.0f), vec3(rainStrength));


	skyColor /= fogLum;


	float antiSunglow = CalculateAntiSunglow(surface);

	skyColor *= 1.0f + pow(sunglow, 1.1f) * (7.0f + timeNoon * 1.0f) * (1.0f - rainStrength) * 0.4;
	skyColor *= mix(vec3(1.0f), colorSunlight * 11.0f, clamp(vec3(sunglow) * (1.0f - timeMidnight) * (1.0f - rainStrength), vec3(0.0f), vec3(1.0f)));
	skyColor *= 1.0f + antiSunglow * 2.0f * (1.0f - rainStrength);


	if (surface.mask.water)
	{
		vec3 sunspot = vec3(CalculateSunspot(surface)) * colorSunlight * surface.sunlightVisibility;
			 sunspot *= 2.0f;
			 sunspot *= 1.0f - timeMidnight;
			 sunspot *= 1.0f - rainStrength;


		skyColor += sunspot;
	}

	skyColor *= pow(1.0f - clamp(skyGradientRaw - 0.75f, 0.0f, 0.25f) / 0.25f, 3.0f);

	skyColor *= mix(1.0f, 4.5f, timeNoon);

	skyColor = mix(skyColor, colorSunlight * 2.0, pow(sunglow, 6.0) * (1.0 - rainStrength));


	return skyColor;
}

Intersection 	RayPlaneIntersectionWorld(in Ray ray, in Plane plane)
{
	float rayPlaneAngle = dot(ray.dir, plane.normal);

	float planeRayDist = 100000000.0f;
	vec3 intersectionPos = ray.dir * planeRayDist;

	if (rayPlaneAngle > 0.0001f || rayPlaneAngle < -0.0001f)
	{
		planeRayDist = dot((plane.origin), plane.normal) / rayPlaneAngle;
		intersectionPos = ray.dir * planeRayDist;
		intersectionPos = -intersectionPos;

		intersectionPos += cameraPosition.xyz;
	}

	Intersection i;

	i.pos = intersectionPos;
	i.distance = planeRayDist;
	i.angle = rayPlaneAngle;

	return i;
}


float GetCoverage(in float coverage, in float density, in float clouds)
{
	clouds = clamp(clouds - (1.0f - coverage), 0.0f, 1.0f - density) / (1.0f - density);
	clouds = max(0.0f, clouds * 1.1f - 0.1f);
	clouds = clouds = clouds * clouds * (3.0f - 2.0f * clouds);
	clouds = pow(clouds, 1.0f);
	return clouds;
}

float pcurve(float x, float a, float b)
{
	float k = pow(a+b, a+b) / (pow(a,a)*pow(b,b));
	return k * pow(x, a) * pow(1.0 - x, b);
}

vec4 CloudColor2(in vec4 worldPosition, in float sunglow, in vec3 worldLightVector, in float altitude, in float heightFactor, const bool isShadowPass)
{

	//worldPosition.xz /= 1.0f + max(0.0f, length(worldPosition.xz - cameraPosition.xz) / 5000.0f);

	vec3 p = worldPosition.xyz / 130.0f;


	float t = frameTimeCounter * 1.0f;
		  t *= 0.05;
		  //t *= 0.00;


	//  p += (Get3DNoise(p * 2.0f + vec3(0.0f, t * 0.01f, 0.0f)) * 2.0f - 1.0f) * 0.1f;
	//  p.z -= (Get3DNoise(p * 0.25f + vec3(0.0f, t * 0.01f, 0.0f)) * 2.0f - 1.0f) * 0.5f;
	//  p.x -= (Get3DNoise(p * 0.125f + vec3(0.0f, t * 0.01f, 0.0f)) * 2.0f - 1.0f) * 1.2f;
	// p.xz -= (Get3DNoise(p * 0.0525f + vec3(0.0f, t * 0.01f, 0.0f)) * 2.0f - 1.0f) * 1.7f;


	p.x *= 0.5f;
	p.x -= t * 0.01f;

	vec3 p1 = p * vec3(1.0f, 0.5f, 1.0f)  + vec3(0.0f, t * 0.01f, 0.0f);

	float noise  = 	Get3DNoise(p * vec3(1.0f, 0.5f, 1.0f) + vec3(0.0f, t * 0.01f, 0.0f)) * 1.3;		p *= 2.0f;	p.x -= t * 0.557f;	vec3 p2 = p;	
		  noise += (2.0f - abs(Get3DNoise(p) * 2.0f - 0.0f)) * (0.35f);								p *= 3.0f;	p.xz -= t * 0.905f;	p.x *= 2.0f;	vec3 p3 = p; 	float largeNoise = noise;
		  noise += (3.0f - abs(Get3DNoise(p) * 3.0f - 0.0f)) * (0.085f);							p *= 3.0f;	p.xz -= t * 3.905f;	vec3 p4 = p;
		  noise += (3.0f - abs(Get3DNoise(p) * 3.0f - 0.0f)) * (0.035f);							p *= 3.0f;	p.xz -= t * 3.905f;
		  if (!isShadowPass)
		  {
		 		noise += ((Get3DNoise(p))) * (0.04f);												p *= 3.0f;
		  		noise += ((Get3DNoise(p))) * (0.020f);
		  }
		  noise /= 2.375f;


	//cloud height coverage falloff

	//cloud edge
	float coverage = 0.5f;
		  coverage = mix(coverage, 0.87f, rainStrength);

		  float dist = length(worldPosition.xz - cameraPosition.xz * 0.5) * 0.5;
		  coverage *= max(0.0f, 1.0f - dist / 4000.0f);
	float density = 0.71f - rainStrength * 0.3;

	if (isShadowPass)
	{
		return vec4(GetCoverage(0.4f, 0.4f, noise));
	}

	noise = GetCoverage(coverage, density, noise);

	const float lightOffset = 0.2f;

	noise *= pcurve(heightFactor, 0.5, 2.5) * saturate(heightFactor * 8.0 - 1.0);
	//noise *= heightFactor;

	if (noise < 0.0001)
	{
		return vec4(0.0, 0.0, 0.0, 0.0);
	}


	float sundiff = Get3DNoise(p1 + worldLightVector.xyz * lightOffset) * 1.3;
		  sundiff += (2.0f - abs(Get3DNoise(p2 + worldLightVector.xyz * lightOffset / 2.0f) * 2.0f - 0.0f)) * (0.35f);
		  				float largeSundiff = sundiff;
		  				      largeSundiff = -GetCoverage(coverage, 0.0f, largeSundiff * 1.3f);
		  // sundiff += (3.0f - abs(Get3DNoise(p3 + worldLightVector.xyz * lightOffset / 5.0f) * 3.0f - 0.0f)) * (0.035f);
		  // sundiff += (3.0f - abs(Get3DNoise(p4 + worldLightVector.xyz * lightOffset / 8.0f) * 3.0f - 0.0f)) * (0.015f);
		  sundiff /= 1.1f;
		  sundiff *= max(0.0f, 1.0f - dist / 10000.0f);
		  sundiff = -GetCoverage(coverage * 1.1f, -0.2f, sundiff);
		  //sundiff *= pow(cos((heightFactor * 2.0 - 1.0) * 3.14159265 * 0.5) * 0.5 + 0.5, 0.8);
		  //sundiff *= pcurve(max(0.0, heightFactor - worldLightVector.y * 0.1 - 0.05) * 0.5, 0.5, 1.5);
		  sundiff *= pow(saturate(heightFactor * 1.5), 1.0);
		  sundiff *= mix(1.0, pow(saturate((1.0 - heightFactor) * (1.0 + largeNoise * 1.0)), 1.0), 0.6);
	float secondOrder 	= pow(clamp(sundiff * 1.0f + 1.2f, 0.0f, 1.0f), 2.7f);
	float firstOrder 	= pow(clamp(sundiff * 0.9f + 1.1f, 0.0f, 1.0f), 13.0f);
	float thirdOrder 	= pow(clamp(-largeNoise * 1.0 + 2.0, 0.0, 3.0), 1.0);



	float directLightFalloff = mix(firstOrder * 2.0, secondOrder * 3.0, 0.15);
	float anisoBackFactor = mix(clamp(pow(noise, 1.3f) * 7.5f, 0.0f, 2.0f), 1.0f, pow(sunglow, 1.0f));

		  directLightFalloff *= anisoBackFactor * 0.8 + 0.2;
	 	  //directLightFalloff *= mix(11.5f, 1.0f, pow(sunglow, 0.5f));

	 	 //directLightFalloff *= 0.5 + pow(1.0 - noise, 18.0) * 0.9;



	vec3 colorDirect = colorSunlight * 0.215f;
		 colorDirect = mix(colorDirect, colorDirect * vec3(0.2f, 0.5f, 1.0f), timeMidnight);
		 //colorDirect *= 1.0f + pow(sunglow, 2.0f) * 300.0f * pow(directLightFalloff, 1.1f) * (1.0f - rainStrength);
		 //colorDirect *= 1.0f + rainStrength * 3.25;
	 	 colorDirect *= 1.0 + 115.0 * pow((1.0 - noise), 5.0) * firstOrder * firstOrder * pow(sunglow, 1.0) * (1.0 - rainStrength);


	vec3 colorAmbient = mix(colorSkylight, colorSunlight * 2.0f, vec3(0.15f)) * 0.03f;
		 colorAmbient *= mix(1.0f, 0.3f, timeMidnight);
		 colorAmbient *= mix(1.0, 0.1, heightFactor);
		 //colorAmbient = mix(colorAmbient, colorAmbient * 8.0f + colorSunlight * 0.0f, vec3(clamp(pow(1.0f - noise, 12.0f) * 1.0f, 0.0f, 1.0f)));
		 //colorAmbient *= thirdOrder;
		 //colorAmbient *= 0.0;
		 //colorAmbient += colorSunlight * pow(thirdOrder, 3.0) * 0.02;

	//directLightFalloff *= 1.0f;

	directLightFalloff *= mix(1.0, 0.175, rainStrength);

	//directLightFalloff += (pow(Get3DNoise(p3), 2.0f) * 0.5f + pow(Get3DNoise(p3 * 1.5f), 2.0f) * 0.25f) * 0.02f;
	//directLightFalloff *= Get3DNoise(p2);

	vec3 color = mix(colorAmbient, colorDirect, vec3(min(1.0f, directLightFalloff)));

	//color = colorAmbient;

	color *= 1.0f;

	color = mix(color, color * 0.9, rainStrength);

	vec4 result = vec4(color.rgb, noise);

	return result;

}
void ReflectedCloudPlane(inout vec3 color, SurfaceStruct surface)
{
	//Initialize view ray
	vec3 viewVector = normalize(surface.viewSpacePosition.xyz);
		 viewVector = reflect(viewVector, surface.normal.xyz);
	vec4 worldVector = gbufferModelViewInverse * (vec4(-viewVector.xyz, 0.0f));

	surface.viewRay.dir = normalize(worldVector.xyz);
	surface.viewRay.origin = vec3(0.0f);

	float sunglow = CalculateReflectedSunglow(surface);


	float cloudsAltitude = 540.0f;
	float cloudsThickness = 150.0f;

	float cloudsUpperLimit = cloudsAltitude + cloudsThickness * 0.5f;
	float cloudsLowerLimit = cloudsAltitude - cloudsThickness * 0.5f;

	float density = 1.0f;

	float planeHeight = cloudsUpperLimit;
	float stepSize = 25.5f;
	planeHeight -= cloudsThickness * 0.5f;


	Plane pl;
	pl.origin = vec3(0.0f, cameraPosition.y - planeHeight, 0.0f);
	pl.normal = vec3(0.0f, 1.0f, 0.0f);

	Intersection i = RayPlaneIntersectionWorld(surface.viewRay, pl);

	if (i.angle < 0.0f)
	{
		vec4 cloudSample = CloudColor2(vec4(i.pos.xyz * 0.5f + vec3(30.0f), 1.0f), sunglow, surface.worldLightVector, cloudsAltitude, 0.15, false);
		 	 cloudSample.a = min(1.0f, cloudSample.a * density);

		color.rgb = mix(color.rgb, cloudSample.rgb * 0.18f, cloudSample.a);

		// cloudSample = CloudColor2(vec4(i.pos.xyz * 1.65f + vec3(10.0f) + vec3(i.pos.z * 0.5f, 0.0f, 330.0f), 1.0f), sunglow, surface.worldLightVector, cloudsAltitude, cloudsThickness, false);
		// cloudSample.a = min(1.0f, cloudSample.a * density);

		// color.rgb = mix(color.rgb, cloudSample.rgb * 0.18f, cloudSample.a);
	}
}

void CloudPlane(inout SurfaceStruct surface)
{
	//Initialize view ray
	vec4 worldVector = gbufferModelViewInverse * (vec4(-GetViewSpacePosition(texcoord.st).xyz, 0.0));

	surface.viewRay.dir = normalize(worldVector.xyz);
	surface.viewRay.origin = vec3(0.0f);

	float sunglow = CalculateSunglow(surface);



	float cloudsAltitude = 540.0f;
	float cloudsThickness = 140.0f;

	float cloudsUpperLimit = cloudsAltitude + cloudsThickness * 0.5f;
	float cloudsLowerLimit = cloudsAltitude - cloudsThickness * 0.5f;

	float density = 6.0f;

	float planeHeight = cloudsAltitude;
	//float stepSize = 25.5f;
	//planeHeight -= cloudsThickness * 0.85f;




	vec3 original = surface.color.rgb;

	const int numSamples =20;

	float dither = CalculateDitherPattern1();

	planeHeight -= dither * (cloudsThickness / numSamples);

	float heightFactor = 0.0 + dither / numSamples;

	for (int j = 0; j < numSamples; j++)
	{
		Plane pl;
		pl.origin = vec3(0.0f, cameraPosition.y - planeHeight, 0.0f);
		pl.normal = vec3(0.0f, 1.0f, 0.0f);

		Intersection i = RayPlaneIntersectionWorld(surface.viewRay, pl);

		if (i.angle < 0.0f)
		{
			if (i.distance < surface.linearDepth || surface.mask.sky)
			{
				vec4 cloudSample = CloudColor2(vec4(i.pos.xyz * 0.5f + vec3(30.0f), 1.0f), sunglow, surface.worldLightVector, cloudsAltitude, heightFactor, false);
				 	 cloudSample.a = min(1.0f, cloudSample.a * density);

				surface.color.rgb = mix(surface.color.rgb, cloudSample.rgb * 0.001f, cloudSample.a);

				// cloudSample = CloudColor2(vec4(i.pos.xyz * 0.65f + vec3(10.0f) + vec3(i.pos.z * 0.5f, 0.0f, 330.0f), 1.0f), sunglow, surface.worldLightVector, cloudsAltitude, cloudsThickness, false);
				// cloudSample.a = min(1.0f, cloudSample.a * density);

				// surface.color.rgb = mix(surface.color.rgb, cloudSample.rgb * 0.001f, cloudSample.a);

			}
		}

		planeHeight -= cloudsThickness / numSamples;
		heightFactor += 1.0 / numSamples;
	}

	surface.color.rgb = mix(surface.color.rgb, original, surface.cloudAlpha);
}

vec4 	ComputeFakeSkyReflection(in SurfaceStruct surface) {

	vec3 cameraSpacePosition = convertScreenSpaceToWorldSpace(texcoord.st);
	vec3 cameraSpaceNormal = surface.normal;
	vec3 cameraSpaceViewDir = normalize(cameraSpacePosition);
	vec4 color = vec4(0.0f);

	color.rgb = ComputeReflectedSkyGradient(surface);
	ReflectedCloudPlane(color.rgb, surface);
	color.rgb *= 0.006f;
	color.rgb *= mix(1.0f, 20000.0f, timeSkyDark);

	float viewVector = dot(cameraSpaceViewDir, cameraSpaceNormal);

	color.a = pow(clamp(1.0f + viewVector, 0.0f, 1.0f), surface.fresnelPower) * (1.0f - surface.baseSpecularity) + surface.baseSpecularity;

	if (viewVector > 0.0f) {
		color.a = 1.0f - pow(clamp(viewVector, 0.0f, 1.0f), 1.0f / surface.fresnelPower) * (1.0f - surface.baseSpecularity) + surface.baseSpecularity;
		color.rgb = vec3(0.0f);
	}


	DoNightEye(color.rgb);

	color.rgb *= mix(1.0f, 0.125f, timeMidnight);

	return color;
}

void 	CalculateSpecularReflections(inout SurfaceStruct surface) {

	float specularity = surface.specularity * surface.specularity * surface.specularity;
	      specularity = max(0.0f, specularity * 1.15f - 0.15f);
	surface.specularColor = vec3(1.0f);
	//surface.specularity = 1.0f;
	//surface.roughness *= surface.roughness;

	bool defaultItself = false;

	surface.rDepth = 0.0f;

	if (surface.mask.sky)
		specularity = 0.0f;



	if (surface.mask.ironBlock)
	{
		surface.baseSpecularity = 1.0f;
		//specularity = 1.0f;
		//surface.roughness = 0.0f;
	}

	if (surface.mask.goldBlock)
	{
		//surface.specularity = 1.0f;
		surface.roughness = 0.4f;
		surface.baseSpecularity = 1.0f;
		surface.specularColor = vec3(1.0f, 0.32f, 0.002f);
		surface.specularColor = mix(surface.specularColor, vec3(1.0f), vec3(0.015f));
	}

	if (surface.mask.water || surface.mask.ice)
	{
		specularity = 1.0f;
		surface.roughness = 0.0f;
		surface.fresnelPower = 6.0f;
		surface.baseSpecularity = 0.02f;
	}


	vec3 original = surface.color.rgb;

	if (specularity > 0.00f) {

		vec3 noise3 = vec3(noise(0.0f), noise(1.0f), noise(2.0f));

		surface.normal += noise3 * 0.00f;

		vec4 reflection = ComputeRaytraceReflection(surface);
		//vec4 reflection = vec4(0.0f);


		vec4 fakeSkyReflection = ComputeFakeSkyReflection(surface);

		vec3 noSkyToReflect = vec3(0.0f);

		if (defaultItself)
		{
			noSkyToReflect = surface.color.rgb;
		}

		fakeSkyReflection.rgb = mix(noSkyToReflect, fakeSkyReflection.rgb, clamp(surface.skylight * 16 - 5, 0.0f, 1.0f));
		reflection.rgb = mix(reflection.rgb, fakeSkyReflection.rgb, pow(vec3(1.0f - reflection.a), vec3(10.1f)));
		reflection.a = fakeSkyReflection.a * specularity;


		reflection.rgb *= surface.specularColor;

		surface.color.rgb = mix(surface.color.rgb, reflection.rgb, vec3(reflection.a));
		surface.reflection = reflection;
	}

	surface.color.rgb = mix(surface.color.rgb, original, vec3(surface.cloudAlpha));
}

void CalculateSpecularHighlight(inout SurfaceStruct surface)
{
	if (!surface.mask.sky && !surface.mask.water || surface.mask.ice)
	{
		//surface.specularity = 0.51f;
		//surface.roughness = 0.2f;


		vec3 halfVector = normalize(lightVector - normalize(surface.viewSpacePosition.xyz));

		float HdotN = max(0.0f, dot(halfVector, surface.normal.xyz));

		float NdotL = clamp(dot(lightVector, surface.normal.xyz), 0.0, 1.0);

		// surface.roughness = sin(FRAME_TIME * 3.1415f) * 0.5f + 0.5f;

		// surface.roughness = 0.75;

		float fresnel = pow(1.0 - dot(halfVector, normalize(-surface.viewSpacePosition.xyz)), 5.0) * 0.99 + 0.01;

		float gloss = pow(1.0f - surface.roughness + 0.01f, 4.5f);
		// gloss = 0.0;

		// gloss = clamp(gloss + fresnel * fresnel * fresnel * 0.1, 0.0f, 1.0f);

		// HdotN = clamp(HdotN * (1.0f + gloss * 0.01f), 0.0f, 1.0f);

		//float spec = pow(HdotN, gloss * 1200.0f + 2.0f);
		//	  spec += pow(HdotN, gloss * 600.0f + 1.0f) * 0.5;
		//	  spec += pow(HdotN, gloss * 300.0f + 1.0f) * 0.25;
		//	  spec += pow(HdotN, gloss * 150.0f + 1.0f) * 0.125;
		float spec = 1.0 / (pow((1.0 - HdotN) * (gloss * 8000.0 + 0.25), 1.5) + 1.1);

		//spec *= float(!surface.mask.sky);



		// float fresnel = pow(clamp(1.0f + dot(normalize(surface.viewSpacePosition.xyz), surface.normal.xyz), 0.0f, 1.0f), surface.fresnelPower) * (1.0f - surface.baseSpecularity) + surface.baseSpecularity;

		float NdotV = dot(surface.normal.xyz, normalize(-surface.viewSpacePosition.xyz));

		spec *= fresnel;
		spec *= NdotL;

		//spec *= pow(1.0f - surface.roughness, 1.5f) * 80000.0f;
		spec *= gloss * 8000.0f + 0.25f;
		// spec *= 100.08;
		spec *= 0.09;
		// spec *= 1.0 + pow((1.0 - clamp(NdotV, 0.0, 1.0)), 20.0) * 100.0;
		// spec *= surface.specularity * surface.specularity * surface.specularity;
		spec *= 1.0f - rainStrength;

		vec3 specularHighlight = spec * mix(colorSunlight, vec3(0.2f, 0.5f, 1.0f) * 0.0005f, vec3(timeMidnight)) * surface.specularColor * surface.sunlightVisibility;

		specularHighlight *= pow(surface.skylight, 0.1);

		surface.color += specularHighlight / 500.0f;
	}
}

vec3 ReorientNormal(vec3 n1, vec3 n2)
{
    float a = 1/(1 + n1.z);
    float b = -n1.x*n1.y*a;

    // Form a basis
    vec3 b1 = vec3(1 - n1.x*n1.x*a, b, -n1.x);
    vec3 b2 = vec3(b, 1 - n1.y*n1.y*a, -n1.y);
    vec3 b3 = n1;

    if (n1.z < -0.9999999) // Handle the singularity
    {
        b1 = vec3( 0, -1, 0);
        b2 = vec3(-1,  0, 0);
    }

    // Rotate n2 via the basis
    vec3 r = n2.x*b1 + n2.y*b2 + n2.z*b3;

    return normalize(r);
}

void CalculateGlossySpecularReflections(inout SurfaceStruct surface)
{
	float specularity = surface.specularity;
	float roughness = 0.7f;
	float spread = 0.01f;

	specularity *= 1.0f - float(surface.mask.sky);

	vec4 reflectionSum = vec4(0.0f);

	surface.fresnelPower = 6.0f;
	surface.baseSpecularity = 0.0f;

	if (surface.mask.ironBlock)
	{
		roughness = 0.9f;
		//specularity = 1.0f;
		//surface.baseSpecularity = 1.0f;
	}

	if (surface.mask.goldBlock)
	{
		specularity = 0.0f;
	}

	surface.baseSpecularity = 0.02;



	//if (specularity > 0.01f)
	//{
		float fresnel = 1.0f - clamp(-dot(normalize(surface.viewSpacePosition.xyz), surface.normal.xyz), 0.0f, 1.0f);

		for (int i = 1; i <= 10; i++)
		{
			vec2 translation = vec2(surface.normal.x, surface.normal.y) * i * spread;
				 translation *= vec2(1.0f, viewWidth / viewHeight);
			//vec2 scaling = (4.0f - vec2(fresnel) * 3.0f);

			float faceFactor = surface.normal.z;
				  faceFactor *= spread * 13.0f;

			vec2 scaling = vec2(1.0f + faceFactor * (i / 10.0f) * 2.0f);

			float r = float(i) + 4.0f;
				  r *= roughness * 0.8f;
			int 	ri = int(floor(r));
			float 	rf = fract(r);

			vec2 finalCoord = (((texcoord.st * 2.0f - 1.0f) * scaling) * 0.5f + 0.5f) + translation;

			float weight = (11 - i + 1) / 10.0f;
			reflectionSum.rgb += pow(texture2DLod(gcolor, finalCoord, r).rgb, vec3(2.2f));
		}



		reflectionSum.rgb /= 5.0f;

		fresnel *= 0.9 * (1.0 - surface.roughness * 0.3);
		fresnel = pow(fresnel, surface.fresnelPower);

		surface.color = mix(surface.color, reflectionSum.rgb * 1.0f, vec3(2.0) * fresnel * (1.0f - surface.baseSpecularity) + surface.baseSpecularity);
	//	}
	//surface.color.rgb *= vec3(1.0f) + reflectionSum.rgb * 400000.2f;
}

vec4 TextureSmooth(in sampler2D tex, in vec2 coord, in int level)
{
	vec2 res = vec2(viewWidth, viewHeight);
	coord = coord * res + 0.5f;
	vec2 i = floor(coord);
	vec2 f = fract(coord);
	f = f * f * (3.0f - 2.0f * f);
	coord = i + f;
	coord = (coord - 0.5f) / res;
	return texture2D(tex, coord, level);
}

void SmoothSky(inout SurfaceStruct surface)
{
	const float cloudHeight = 540.0f;
	const float cloudDepth = 140.0f;
	const float cloudMaxHeight = cloudHeight + cloudDepth / 2.0f;
	const float cloudMinHeight = cloudHeight - cloudDepth / 2.0f;

	float cameraHeight = cameraPosition.y;
	float surfaceHeight = surface.worldSpacePosition.y;

	vec3 combined = pow(TextureSmooth(gcolor, texcoord.st, 2).rgb, vec3(2.2f));
	vec3 original = surface.color;

	// surface.color = combined;

	if (surface.cloudAlpha > 0.000001f)
	{
		surface.color = combined;
	}

	if (cameraHeight < cloudMinHeight && surfaceHeight < cloudMinHeight - 10.0f && surface.mask.land)
	{
		surface.color = original;
	}

	if (cameraHeight > cloudMaxHeight && surfaceHeight > cloudMaxHeight && surface.mask.land)
	{
		surface.color = original;
	}

	if (cameraHeight > cloudMaxHeight - 20.0f)
	{
		surface.color = vec3(0.0);
	}
}


void FixNormals(inout vec3 normal, in vec3 viewPosition)
{
	vec3 V = normalize(viewPosition.xyz);
	vec3 N = normal;

	float NdotV = dot(N, V);

	N = normalize(mix(normal, -V, clamp(pow((NdotV * 1.0), 1.0), 0.0, 1.0)));
	N = normalize(N + -V * 0.1 * clamp(NdotV + 0.4, 0.0, 1.0));

	normal = N;
}

vec4 textureSmooth(in sampler2D tex, in vec2 coord)
{
	vec2 res = vec2(64.0f, 64.0f);

	coord *= res;
	coord += 0.5f;

	vec2 whole = floor(coord);
	vec2 part  = fract(coord);

	part.x = part.x * part.x * (3.0f - 2.0f * part.x);
	part.y = part.y * part.y * (3.0f - 2.0f * part.y);
	// part.x = 1.0f - (cos(part.x * 3.1415f) * 0.5f + 0.5f);
	// part.y = 1.0f - (cos(part.y * 3.1415f) * 0.5f + 0.5f);

	coord = whole + part;

	coord -= 0.5f;
	coord /= res;

	return texture2D(tex, coord);
}

float AlmostIdentity(in float x, in float m, in float n)
{
	if (x > m) return x;

	float a = 2.0f * n - m;
	float b = 2.0f * m - 3.0f * n;
	float t = x / m;

	return (a * t + b) * t * t + n;
}

float GetWaves(vec3 position, float frameTimeCounter) {
	float speed = 0.9f;

  vec2 p = position.xz / 20.0f;

  p.xy -= position.y / 20.0f;

  p.x = -p.x;

  p.x += (frameTimeCounter / 40.0f) * speed;
  p.y -= (frameTimeCounter / 40.0f) * speed;

  float weight = 1.0f;
  float weights = weight;

  float allwaves = 0.0f;

  float wave = textureSmooth(noisetex, (p * vec2(2.0f, 1.2f))  + vec2(0.0f,  p.x * 2.1f) ).x; 			p /= 2.1f; 	/*p *= pow(2.0f, 1.0f);*/ 	p.y -= (FRAME_TIME / 20.0f) * speed; p.x -= (FRAME_TIME / 30.0f) * speed;
  allwaves += wave;

  weight = 4.1f;
  weights += weight;
      wave = textureSmooth(noisetex, (p * vec2(2.0f, 1.4f))  + vec2(0.0f,  -p.x * 2.1f) ).x;	p /= 1.5f;/*p *= pow(2.0f, 2.0f);*/ 	p.x += (FRAME_TIME / 20.0f) * speed;
      wave *= weight;
  allwaves += wave;

  weight = 17.25f;
  weights += weight;
      wave = (textureSmooth(noisetex, (p * vec2(1.0f, 0.75f))  + vec2(0.0f,  p.x * 1.1f) ).x);		p /= 1.5f; 	p.x -= (FRAME_TIME / 55.0f) * speed;
      wave *= weight;
  allwaves += wave;

  weight = 15.25f;
  weights += weight;
      wave = (textureSmooth(noisetex, (p * vec2(1.0f, 0.75f))  + vec2(0.0f,  -p.x * 1.7f) ).x);		p /= 1.9f; 	p.x += (FRAME_TIME / 155.0f) * speed;
      wave *= weight;
  allwaves += wave;

  weight = 29.25f;
  weights += weight;
      wave = abs(textureSmooth(noisetex, (p * vec2(1.0f, 0.8f))  + vec2(0.0f,  -p.x * 1.7f) ).x * 2.0f - 1.0f);		p /= 2.0f; 	p.x += (FRAME_TIME / 155.0f) * speed;
      wave = 1.0f - AlmostIdentity(wave, 0.2f, 0.1f);
      wave *= weight;
  allwaves += wave;

  weight = 15.25f;
  weights += weight;
      wave = abs(textureSmooth(noisetex, (p * vec2(1.0f, 0.8f))  + vec2(0.0f,  p.x * 1.7f) ).x * 2.0f - 1.0f);
      wave = 1.0f - AlmostIdentity(wave, 0.2f, 0.1f);
      wave *= weight;
  allwaves += wave;

  allwaves /= weights;

  return allwaves;
}

vec3 GetWavesNormal(vec3 position, float time) {

	float WAVE_HEIGHT = 1.0;

	const float sampleDistance = 11.0f;

	position -= vec3(0.005f, 0.0f, 0.005f) * sampleDistance;

	float wavesCenter = GetWaves(position, time);
	float wavesLeft = GetWaves(position + vec3(0.01f * sampleDistance, 0.0f, 0.0f), time);
	float wavesUp   = GetWaves(position + vec3(0.0f, 0.0f, 0.01f * sampleDistance), time);

	vec3 wavesNormal;
		 wavesNormal.r = wavesCenter - wavesLeft;
		 wavesNormal.g = wavesCenter - wavesUp;

		 wavesNormal.r *= 10.0f * WAVE_HEIGHT / sampleDistance;
		 wavesNormal.g *= 10.0f * WAVE_HEIGHT / sampleDistance;

		 wavesNormal.b = sqrt(1.0f - wavesNormal.r * wavesNormal.r - wavesNormal.g * wavesNormal.g);
		 wavesNormal.rgb = normalize(wavesNormal.rgb);



	return wavesNormal.rgb;
}

void WaterRefraction(inout SurfaceStruct surface)
{
	if (surface.mask.water || surface.mask.ice || surface.mask.stainedGlass)
	{
		vec3 wavesNormal;
		if (surface.mask.water)
			 wavesNormal = GetWavesNormal(surface.worldSpacePosition.xyz + cameraPosition.xyz, frameTimeCounter).xzy;
		else if (surface.mask.ice || surface.mask.stainedGlass)
			 wavesNormal = GetWavesNormal((surface.worldSpacePosition.xyz + cameraPosition.xyz) * 4.0, 0.0).xzy;


		float opaqueDepth = ExpToLinearDepth(texture2D(depthtex1, texcoord.st).x);

		float waterDepth = opaqueDepth - surface.linearDepth;

		float refractAmount = saturate(waterDepth / 1.0) * 0.5;

		if (surface.mask.ice || surface.mask.stainedGlass)
		{
			refractAmount *= 0.5;
		}


		vec4 wnv = gbufferModelView * vec4(wavesNormal.xyz, 0.0);
		vec3 wavesNormalView = normalize(wnv.xyz);
		vec4 nv = gbufferModelView * vec4(0.0, 1.0, 0.0, 0.0);
			   nv.xyz = normalize(nv.xyz);
				 wavesNormalView.xy -= nv.xy;
		float aberration = 0.15;
		float refractionAmount = 1.82;
		vec2 refractCoord0 = texcoord.st - wavesNormalView.xy * refractAmount * (refractionAmount) / (surface.linearDepth + 0.0001);
		vec2 refractCoord1 = texcoord.st - wavesNormalView.xy * refractAmount * (refractionAmount + aberration) / (surface.linearDepth + 0.0001);
		vec2 refractCoord2 = texcoord.st - wavesNormalView.xy * refractAmount * (refractionAmount + aberration * 2.0) / (surface.linearDepth + 0.0001);


		if (refractCoord0.x > 1.0 || refractCoord0.x < 0.0 || refractCoord0.y > 1.0 || refractCoord0.y < 0.0)
			refractCoord0 = texcoord.st;

		if (refractCoord1.x > 1.0 || refractCoord1.x < 0.0 || refractCoord1.y > 1.0 || refractCoord1.y < 0.0)
			refractCoord1 = texcoord.st;

		if (refractCoord2.x > 1.0 || refractCoord2.x < 0.0 || refractCoord2.y > 1.0 || refractCoord2.y < 0.0)
			refractCoord2 = texcoord.st;
		// vec2 refractCoord = texcoord.st - wavesNormal.xy * 1.72 / (surface.linearDepth + 0.0001);


		// vec3 fakeViewVector = vec3(texcoord.st * 2.0 - 1.0, 0.1);
		// vec3 fakeRefractCoord = refract(fakeViewVector, surface.normal.xyz, 1.0 / 1.00001);
		
		/*
		surface.color.r = pow(texture2DLod(gcolor, refractCoord0.xy, 1).r, (2.2));
		surface.color.g = pow(texture2DLod(gcolor, refractCoord1.xy, 1).g, (2.2));
		surface.color.b = pow(texture2DLod(gcolor, refractCoord2.xy, 1).b, (2.2));
		*/


		///*

		float fogDensity = 0.40;
		float visibility = 1.0f / (pow(exp(waterDepth * fogDensity), 1.0f));


		vec4 blendWeights = vec4(1.0, 0.5, 0.25, 0.125);
		blendWeights = pow(blendWeights, vec4(visibility));

		float blendWeightsTotal = dot(blendWeights, vec4(1.0));

		surface.color = 
					(
					    pow(texture2DLod(gcolor, refractCoord0.xy, 1).rgb, vec3(2.2)) * blendWeights.x
					  + pow(texture2DLod(gcolor, refractCoord0.xy, 2).rgb, vec3(2.2)) * blendWeights.y
					  + pow(texture2DLod(gcolor, refractCoord0.xy, 3).rgb, vec3(2.2)) * blendWeights.z
					  + pow(texture2DLod(gcolor, refractCoord0.xy, 4).rgb, vec3(2.2)) * blendWeights.w
					) / blendWeightsTotal;
		//*/
	}
}

void AddCrepuscularRays(vec2 coord, inout SurfaceStruct surface)
{
	float rays = 0.0;
	float spread = 1.0;

	rays += texture2DLod(gdepth, coord + vec2(1.0 / viewWidth, 1.0 / viewHeight) * vec2(1.0, 1.0)		* spread, 2).g;
	rays += texture2DLod(gdepth, coord + vec2(1.0 / viewWidth, 1.0 / viewHeight) * vec2(1.0, -1.0)		* spread, 2).g;
	rays += texture2DLod(gdepth, coord + vec2(1.0 / viewWidth, 1.0 / viewHeight) * vec2(-1.0, 1.0)		* spread, 2).g;
	rays += texture2DLod(gdepth, coord + vec2(1.0 / viewWidth, 1.0 / viewHeight) * vec2(-1.0, -1.0)		* spread, 2).g;

	//rays *= 0.25;

	//rays *= surface.linearDepth / far;


	float sunglow = CalculateSunglow(surface);
	float antiSunglow = CalculateAntiSunglow(surface);

	vec3 rayColor = vec3(rays);

	float anisoHighlight = pow(1.0f / (pow((1.0f - sunglow) * 3.0f, 2.0f) + 1.1f) * 1.5f, 1.5f) + 0.5f;
		  anisoHighlight *= sunglow + 0.0f;
		  anisoHighlight += antiSunglow * 0.05f;

	rayColor *=  colorSunlight * 0.5f + colorSkylight * 4.0f + colorSunlight * (anisoHighlight * 120.0f);


	rayColor *= 1.0 - timeNoon * 0.9;


	DoNightEye(rayColor);


	surface.color += rayColor * 0.000001;
}

void CalculateExposure(inout vec3 color) {
	float exposureMax = 1.55f;
		  exposureMax *= mix(1.0f, 0.25f, timeSunriseSunset);
		  exposureMax *= mix(1.0f, 0.0f, timeMidnight);
		  exposureMax *= mix(1.0f, 0.25f, rainStrength);
	float exposureMin = 0.07f;
	float exposure = pow(eyeBrightnessSmooth.y / 240.0f, 6.0f) * exposureMax + exposureMin;

	//exposure = 1.0f;

	color.rgb /= vec3(exposure);
	color.rgb *= 200.0;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////MAIN//////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void main() {

	surface.color = pow(texture2DLod(gcolor, texcoord.st, 0).rgb, vec3(2.2f));
	surface.normal = GetNormals(texcoord.st);
	surface.depth = GetDepth(texcoord.st);
	surface.linearDepth 		= ExpToLinearDepth(surface.depth); 				//Get linear scene depth
	surface.viewSpacePosition = GetViewSpacePosition(texcoord.st);
	surface.worldSpacePosition = gbufferModelViewInverse * surface.viewSpacePosition;
	FixNormals(surface.normal, surface.viewSpacePosition.xyz);
	surface.lightVector = lightVector;
	surface.sunlightVisibility = GetSunlightVisibility(texcoord.st);
	surface.upVector 	= upVector;
	vec4 wlv 					= shadowModelViewInverse * vec4(0.0f, 0.0f, 0.0f, 1.0f);
	surface.worldLightVector 	= normalize(wlv.xyz);

	surface.specularity = GetSpecularity(texcoord.st);
	surface.roughness = 1.0f - GetRoughness(texcoord.st);
	surface.fresnelPower = 6.0f + surface.roughness * 0.0f;
	surface.baseSpecularity = 0.02f;

	surface.mask.matIDs = GetMaterialIDs(texcoord.st);
	CalculateMasks(surface.mask);

	surface.skylight = GetLightmapSky(texcoord.st);


	surface.cloudAlpha = 0.0f;
	#ifdef SMOOTH_CLOUDS
		surface.cloudAlpha = texture2D(composite, texcoord.st, 2).g;
		SmoothSky(surface);
	#endif

	if (surface.mask.water || surface.mask.ice)
		surface.sunlightVisibility = vec3(1.0);

	WaterRefraction(surface);
	//if (surface.mask.sky)
	//	CloudPlane(surface);



	vec4 transparentAlbedo = GetTransparentAlbedo(texcoord.st);

	if (surface.mask.stainedGlass || surface.mask.ice)
	{
		surface.color *= transparentAlbedo.rgb * 1.0;
	}

	if (isEyeInWater == 0)
	{
		CalculateSpecularReflections(surface);
		CalculateSpecularHighlight(surface);
		//CalculateGlossySpecularReflections(surface);
	}

	#ifdef CREPUSCULAR_RAYS
	AddCrepuscularRays(texcoord.st, surface);
	#endif


	//surface.color = surface.normal * 0.0001f;

	//surface.color = vec3(fwidth(surface.depth)) * 0.01f;

	//surface.color.rgb = surface.reflection.rgb;

	// surface.color += vec3(max(0.0, dot(surface.normal, normalize(surface.viewSpacePosition.xyz)))) / 100.0f;

	//surface.color = mix(surface.color, vec3(0.0), vec3(surface.cloudAlpha));

	surface.color = pow(surface.color, vec3(1.0f / 2.2f));
	gl_FragData[0] = vec4(surface.color, 1.0f);
	//gl_FragData[1] = vec4(surface.normal.xyz * 0.5 + 0.5, 1.0f);


}
