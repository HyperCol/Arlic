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

#define SHADOW_MAP_BIAS 0.90


/////////ADJUSTABLE VARIABLES//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////ADJUSTABLE VARIABLES//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//Only enable one of these.
//#define ENABLE_SOFT_SHADOWS		// Simple soft shadows
#define VARIABLE_PENUMBRA_SHADOWS	// Contact-hardening (area) shadows

#define COLORED_SHADOWS // Tinted shadows from stained glass


//#define PIXEL_SHADOWS // Pixel-locked shadows 
#define TEXTURE_RESOLUTION 128 // Resolution of current resource pack. This needs to be set properly for POM! [16 32 64 128 256 512]


//#define BASIC_AMBIENT

#define GI_RENDER_RESOLUTION 0 // Render resolution of GI. 0 = High. 1 = Low. Set to 1 for faster but blurrier GI. [0 1]

#define TORCHLIGHT_BRIGHTNESS 0.5 // How bright is light from torches, fire, etc. [0.25 0.5 0.75 1.0 1.5 2.0]

#define NEW_SKY_LIGHT



/////////INTERNAL VARIABLES////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////INTERNAL VARIABLES////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Do not change the name of these variables or their type. The Shaders Mod reads these lines and determines values to send to the inner-workings
//of the shaders mod. The shaders mod only reads these lines and doesn't actually know the real value assigned to these variables in GLSL.
//Some of these variables are critical for proper operation. Change at your own risk.


const int 		shadowMapResolution 	= 2048;	// Shadowmap resolution [1024 2048 4096]
const float 	shadowDistance 			= 120.0; // Shadow distance. Set lower if you prefer nicer close shadows. Set higher if you prefer nicer distant shadows. [80.0 120.0 180.0 240.0]
const float 	shadowIntervalSize 		= 4.0f;
const bool 		shadowHardwareFiltering0 = true;

const bool 		shadowtex1Mipmap = true;
const bool 		shadowtex1Nearest = false;
const bool 		shadowcolor0Mipmap = true;
const bool 		shadowcolor0Nearest = false;
const bool 		shadowcolor1Mipmap = true;
const bool 		shadowcolor1Nearest = false;


const int 		RGBA8 					= 1;
const int 		RGBA16 					= 2;
const int 		RGBA16F 				= 2;
const int 		gcolorFormat 			= RGBA16;
const int 		gdepthFormat 			= RGBA16;
const int 		gnormalFormat 			= RGBA16;
const int 		compositeFormat 		= RGBA16;
const int 		colortex4Format 		= RGBA8;
const int 		colortex5Format 		= RGBA8;
const int 		colortex6Format 		= RGBA16;
const int 		colortex7Format 		= RGBA16;	//temportal anti-aliasing

const float 	eyeBrightnessHalflife 	= 10.0f;
const float 	wetnessHalflife 		= 300.0f;
const float 	drynessHalflife 		= 40.0f;

const int 		superSamplingLevel 		= 0;

const float		sunPathRotation 		= -40.0; // [-0.5 -1 -1.5 -2 -2.5 -3 -3.5 -4 -4.5 -5 -5.5 -6 -6.5 -7 -7.5 -8 -8.5 -9 -9.5 -10 -10.5 -11 -11.5 -12 -12.5 -13 -13.5 -14 -14.5 -15 -15.5 -16 -16.5 -17 -17.5 -18 -18.5 -19 -19.5 -20 -20.5 -21 -21.5 -22 -22.5 -23 -23.5 -24 -24.5 -25 -25.5 -26 -26.5 -27 -27.5 -28 -28.5 -29 -29.5 -30 -30.5 -31 -31.5 -32 -32.5 -33 -33.5 -34 -34.5 -35 -35.5 -36 -36.5 -37 -37.5 -38 -38.5 -39 -39.5 -40 -40.5 -41 -41.5 -42 -42.5 -43 -43.5 -44 -44.5 -45 -45.5 -46 -46.5 -47 -47.5 -48 -48.5 -49 -49.5 -50 -50.5 -51 -51.5 -52 -52.5 -53 -53.5 -54 -54.5 -55 -55.5 -56 -56.5 -57 -57.5 -58 -58.5 -59 -59.5 -60 -60.5 -61 -61.5 -62 -62.5 -63 -63.5 -64 -64.5 -65 -65.5 -66 -66.5 -67 -67.5 -68 -68.5 -69 -69.5 -70 -70.5 -71 -71.5 -72 -72.5 -73 -73.5 -74 -74.5 -75 -75.5 -76 -76.5 -77 -77.5 -78 -78.5 -79 -79.5 -80 -80.5 -81 -81.5 -82 -82.5 -83 -83.5 -84 -84.5 -85 -85.5 -86 -86.5 -87 -87.5 -88 -88.5 -89 -89.5 -90]
const float 	ambientOcclusionLevel 	= 0.01f;

const int 		noiseTextureResolution  = 64;


//END OF INTERNAL VARIABLES//

//const bool gaux1MipmapEnabled = true;

#define BANDING_FIX_FACTOR 1.0f

uniform sampler2D gcolor;
uniform sampler2D gdepth;
uniform sampler2D gdepthtex;
uniform sampler2D gnormal;
uniform sampler2D composite;
uniform sampler2D shadowtex1;
uniform sampler2DShadow shadow;
uniform sampler2D shadowcolor;
uniform sampler2D shadowcolor1;
uniform sampler2D noisetex;
uniform sampler2D gaux1;
uniform sampler2D gaux2;
uniform sampler2D gaux3;
uniform sampler2D depthtex1;
uniform sampler2D depthtex0;

varying vec2 texcoord;
varying vec3 lightVector;

uniform int worldTime;
uniform int frameCounter;

uniform mat4 gbufferProjection;
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferModelView;
uniform mat4 shadowProjectionInverse;
uniform mat4 shadowProjection;
uniform mat4 shadowModelView;
uniform mat4 shadowModelViewInverse;

uniform vec3 shadowLightVector;
uniform vec3 sunVectorView;
uniform vec3 cameraPosition;
uniform vec3 upVector;

uniform float near;
uniform float far;
uniform float viewWidth;
uniform float viewHeight;
uniform float rainStrength;
uniform float wetness;
uniform float aspectRatio;
uniform float frameTimeCounter;
uniform float sunAngle;
uniform vec3 skyColor;

uniform int   isEyeInWater;
uniform float eyeAltitude;
uniform ivec2 eyeBrightness;
uniform ivec2 eyeBrightnessSmooth;
uniform int   fogMode;


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

uniform int heldBlockLightValue;





/////////////////////////FUNCTIONS/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////FUNCTIONS/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#include "/lib/common.glsl"
#include "/lib/antialiasing/taaProjection.glsl"
#include "/lib/materials.glsl"
#include "/lib/packing.glsl"
#include "/lib/lighting/lighting.glsl"
#include "/lib/lighting/lightmap.glsl"

//Get gbuffer textures
vec3  	GetAlbedoLinear(in vec2 coord) {			//Function that retrieves the diffuse texture and convert it into linear space.
	return pow(texture2D(gcolor, coord).rgb, vec3(2.2f));
}

vec3  	GetAlbedoGamma(in vec2 coord) {			//Function that retrieves the diffuse texture and leaves it in gamma space.
	return texture2D(gcolor, coord).rgb;
}

vec3  	GetWaterNormals(in vec2 coord) {				//Function that retrieves the screen space surface normals. Used for lighting calculations
	return NormalDecode(texture2D(gnormal, texcoord.xy).xy);
}


vec3  	GetNormals(in vec2 coord) {				//Function that retrieves the screen space surface normals. Used for lighting calculations
	return NormalDecode(texture2D(gnormal, texcoord.xy).xy);
}

float 	GetDepth(in vec2 coord) {					//Function that retrieves the scene depth. 0 - 1, higher values meaning farther away
	return texture2D(depthtex0, coord).r;
}

float 	GetDepthLinear(in vec2 coord) {					//Function that retrieves the scene depth. 0 - 1, higher values meaning farther away
	//return 2.0f * near * far / (far + near - (2.0f * texture2D(depthtex1, coord).x - 1.0f) * (far - near));
	return (near * far) / (texture2D(depthtex0, coord).x * (near - far) + far);
}

float 	ExpToLinearDepth(in float depth)
{
	//return 2.0f * near * far / (far + near - (2.0f * depth - 1.0f) * (far - near));
	return (near*far)/(depth*(near-far)+far);
}

float GetTransparentLightmapSky(in vec2 coord)
{
	return pow(texture2D(gaux3, coord).b, 8.3f);
}

float 	GetUnderwaterLightmapSky(in vec2 coord) {
	return texture2D(composite, coord).r;
}


//Specularity
float 	GetSpecularity(in vec2 coord) {			//Function that retrieves how reflective any surface/pixel is in the scene. Used for reflections and specularity
	return texture2D(composite, texcoord.st).r;
}

float 	GetGlossiness(in vec2 coord) {			//Function that retrieves how reflective any surface/pixel is in the scene. Used for reflections and specularity
	return texture2D(composite, texcoord.st).g;
}



//Material IDs

float 	GetTransparentID(in vec2 coord)
{
	return texture2D(gaux3, coord).a;
}


bool  	GetSky(in vec2 coord) {					//Function that returns true for any pixel that is part of the sky, and false for any pixel that isn't part of the sky
	float matID = GetMaterialIDs(coord);		//Gets texture that has all material IDs stored in it
	//	  matID = floor(matID * 255.0f);		//Scale texture from 0-1 float to 0-255 integer format

	if (matID == 0.0f) {						//Checks to see if the current pixel's material ID is 0 = the sky
		return true;							//If the current pixel has the material ID of 0 (sky material ID), Return "this pixel is part of the sky"
	} else {
		return false;							//Return "this pixel is not part of the sky"
	}
}

float  	GetWaterMask(in vec2 coord, in float matID) {					//Function that returns "true" if a pixel is water, and "false" if a pixel is not water.
	//matID = (matID * 255.0f);

	if (matID >= 35.0f && matID <= 51) {
		return 1.0f;
	} else {
		return 0.0f;
	}
}

float  	GetStainedGlassMask(in vec2 coord, in float matID) {					//Function that returns "true" if a pixel is water, and "false" if a pixel is not water.
	//matID = (matID * 255.0f);

	if (matID >= 55.0f && matID <= 70.0f) {
		return 1.0f;
	} else {
		return 0.0f;
	}
}

float  	GetIceMask(in vec2 coord, in float matID) {					//Function that returns "true" if a pixel is water, and "false" if a pixel is not water.
	//matID = (matID * 255.0f);

	if (matID == 4.0f) {
		return 1.0f;
	} else {
		return 0.0f;
	}
}




//Surface calculations
vec4  	GetScreenSpacePosition(in vec2 coord) {	//Function that calculates the screen-space position of the objects in the scene using the depth texture and the texture coordinates of the full-screen quad
	float depth = GetDepth(coord);
		  depth += float(GetMaterialMask(coord, 5, GetMaterialIDs(coord))) * 0.38f;
		  //float handMask = float(GetMaterialMask(coord, 5, GetMaterialIDs(coord)));
	vec4 fragposition = gbufferProjectionInverse * vec4(coord.s * 2.0f - 1.0f, coord.t * 2.0f - 1.0f, 2.0f * depth - 1.0f, 1.0f);
		 fragposition /= fragposition.w;

		 //fragposition.xyz *= mix(1.0f, 15.0f, handMask);

	return fragposition;
}

vec4  	GetScreenSpacePosition(in vec2 coord, in float depth) {	//Function that calculates the screen-space position of the objects in the scene using the depth texture and the texture coordinates of the full-screen quad
		  //depth += float(GetMaterialMask(coord, 5)) * 0.38f;
	vec4 fragposition = gbufferProjectionInverse * vec4(coord.s * 2.0f - 1.0f, coord.t * 2.0f - 1.0f, 2.0f * depth - 1.0f, 1.0f);
		 fragposition /= fragposition.w;

	return fragposition;
}

vec4 	GetWorldSpacePosition(in vec2 coord, in float depth)
{
	vec4 pos = GetScreenSpacePosition(coord, depth);
	pos = gbufferModelViewInverse * pos;
	pos.xyz += cameraPosition.xyz;

	return pos;
}

vec4 	GetCloudSpacePosition(in vec2 coord, in float depth, in float distanceMult)
{
	// depth *= 30.0f;

	float linDepth = depth;

	float expDepth = (far * (linDepth - near)) / (linDepth * (far - near));

	//Convert texture coordinates and depth into view space
	vec4 viewPos = gbufferProjectionInverse * vec4(coord.s * 2.0f - 1.0f, coord.t * 2.0f - 1.0f, 2.0f * expDepth - 1.0f, 1.0f);
		 viewPos /= viewPos.w;

	//Convert from view space to world space
	vec4 worldPos = gbufferModelViewInverse * viewPos;

	worldPos.xyz *= distanceMult;
	worldPos.xyz += cameraPosition.xyz;

	return worldPos;
}

vec4 	ScreenSpaceFromWorldSpace(in vec4 worldPosition)
{
	worldPosition.xyz -= cameraPosition;
	worldPosition = gbufferModelView * worldPosition;
	return worldPosition;
}



void 	DoNightEye(inout vec3 color) {			//Desaturates any color input at night, simulating the rods in the human eye

	float amount = 0.2f; 						//How much will the new desaturated and tinted image be mixed with the original image
	vec3 rodColor = vec3(0.2f, 0.4f, 1.0f); 	//Cyan color that humans percieve when viewing extremely low light levels via rod cells in the eye
	float colorDesat = dot(color, vec3(1.0f)); 	//Desaturated color

	color = mix(color, vec3(colorDesat) * rodColor, timeMidnight * amount);
	//color.rgb = color.rgb;
}


float 	ExponentialToLinearDepth(in float depth)
{
	vec4 worldposition = vec4(depth);
	worldposition = gbufferProjection * worldposition;
	return worldposition.z;
}

float 	LinearToExponentialDepth(in float linDepth)
{
	float expDepth = (far * (linDepth - near)) / (linDepth * (far - near));
	return expDepth;
}

void 	DoLowlightEye(inout vec3 color) {			//Desaturates any color input at night, simulating the rods in the human eye

	float amount = 0.8f; 						//How much will the new desaturated and tinted image be mixed with the original image
	vec3 rodColor = vec3(0.2f, 0.4f, 1.0f); 	//Cyan color that humans percieve when viewing extremely low light levels via rod cells in the eye
	float colorDesat = dot(color, vec3(1.0f)); 	//Desaturated color

	color = mix(color, vec3(colorDesat) * rodColor, amount);
	// color.rgb = color.rgb;
}

void 	FixLightFalloff(inout float lightmap) { //Fixes the ugly lightmap falloff and creates a nice linear one
	float additive = 5.35f;
	float exponent = 40.0f;

	lightmap += additive;							//Prevent ugly fast falloff
	lightmap = pow(lightmap, exponent);			//Curve light falloff
	lightmap = max(0.0f, lightmap);		//Make sure light properly falls off to zero
	lightmap /= pow(1.0f + additive, exponent);
}


float 	CalculateLuminance(in vec3 color) {
	return (color.r * 0.2126f + color.g * 0.7152f + color.b * 0.0722f);
}

vec3 	Glowmap(in vec3 albedo, in float mask, in float curve, in vec3 emissiveColor) {
	vec3 color = albedo * (mask);
		 color = pow(color, vec3(curve));
		 color = vec3(CalculateLuminance(color));
		 color *= emissiveColor;

	return color;
}


float 	ChebyshevUpperBound(in vec2 moments, in float distance) {
	if (distance <= moments.x)
		return 1.0f;

	float variance = moments.y - (moments.x * moments.x);
		  variance = max(variance, 0.000002f);

	float d = distance - moments.x;
	float pMax = variance / (variance + d*d);

	return pMax;
}

float  	CalculateDitherPattern() {
	const int[4] ditherPattern = int[4] (0, 2, 1, 4);

	vec2 count = vec2(0.0f);
	     count.x = floor(mod(texcoord.s * viewWidth, 2.0f));
		 count.y = floor(mod(texcoord.t * viewHeight, 2.0f));

	int dither = ditherPattern[int(count.x) + int(count.y) * 2];

	return float(dither) / 4.0f;
}

float R2_dither(){
	vec2 alpha = vec2(0.75487765, 0.56984026);
	
	return fract(alpha.x * gl_FragCoord.x + alpha.y * gl_FragCoord.y);
}

float BlueNoise(vec2 coord)
{
	vec2 noiseCoord = vec2(coord.st * vec2(viewWidth, viewHeight)) / 64.0;
	noiseCoord += vec2(sin(frameCounter * 0.75), cos(frameCounter * 0.75));

	noiseCoord = (floor(noiseCoord * 64.0) + 0.5) / 64.0;

	float blueNoise = texture2DLod(noisetex, noiseCoord.st, 0).b;

	return blueNoise;
}

vec2 BlueNoiseXY(vec2 coord)
{
	return vec2(BlueNoise(coord.st), BlueNoise(coord.st + 32.0 / vec2(viewWidth, viewHeight)));
}


float  	CalculateDitherPattern2() {
	const int[64] ditherPattern = int[64] ( 1, 49, 13, 61,  4, 52, 16, 64,
										   33, 17, 45, 29, 36, 20, 48, 32,
										    9, 57,  5, 53, 12, 60,  8, 56,
										   41, 25, 37, 21, 44, 28, 40, 24,
										    3, 51, 15, 63,  2, 50, 14, 62,
										   35, 19, 47, 31, 34, 18, 46, 30,
										   11, 59,  7, 55, 10, 58,  6, 54,
										   43, 27, 39, 23, 42, 26, 38, 22);

	vec2 count = vec2(0.0f);
	     count.x = floor(mod(texcoord.s * viewWidth, 8.0f));
		 count.y = floor(mod(texcoord.t * viewHeight, 8.0f));

	int dither = ditherPattern[int(count.x) + int(count.y) * 8];

	return float(dither) / 64.0f;
}

vec3 	CalculateNoisePattern1(vec2 offset, float size) {
	vec2 coord = texcoord.st;

	coord *= vec2(viewWidth, viewHeight);
	coord = mod(coord + offset, vec2(size));
	coord /= noiseTextureResolution;

	return texture2D(noisetex, coord).xyz;
}


void DrawDebugSquare(inout vec3 color) {

	vec2 pix = vec2(1.0f / viewWidth, 1.0f / viewHeight);

	vec2 offset = vec2(0.5f);
	vec2 size = vec2(0.0f);
		 size.x = 1.0f / 2.0f;
		 size.y = 1.0f / 2.0f;

	vec2 padding = pix * 0.0f;
		 size += padding;

	if ( texcoord.s + offset.s / 2.0f + padding.x / 2.0f > offset.s &&
		 texcoord.s + offset.s / 2.0f + padding.x / 2.0f < offset.s + size.x &&
		 texcoord.t + offset.t / 2.0f + padding.y / 2.0f > offset.t &&
		 texcoord.t + offset.t / 2.0f + padding.y / 2.0f < offset.t + size.y
		)
	{

		int[16] ditherPattern = int[16] (0, 3, 0, 3,
										 2, 1, 2, 1,
										 0, 3, 0, 3,
										 2, 1, 2, 1);

		vec2 count = vec2(0.0f);
		     count.x = floor(mod(texcoord.s * viewWidth, 4.0f));
			 count.y = floor(mod(texcoord.t * viewHeight, 4.0f));

		int dither = ditherPattern[int(count.x) + int(count.y) * 4];
		color.rgb = vec3(float(dither) / 3.0f);


	}

}

/////////////////////////STRUCTS///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////STRUCTS///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

struct MCLightmapStruct {		//Lightmaps directly from MC engine
	float torch;				//Light emitted from torches and other emissive blocks
	float sky;					//Light coming from the sky
	float lightning;			//Light coming from lightning

	vec3 torchVector; 			//Vector in screen space that represents the direction of average light transfered
	vec3 skyVector;
} mcLightmap;



struct DiffuseAttributesStruct {			//Diffuse surface shading attributes
	float roughness;			//Roughness of surface. More roughness will use Oren Nayar reflectance.
	float translucency; 		//How translucent the surface is. Translucency represents how much energy will be transfered through the surface
	vec3  translucencyColor; 	//Color that will be multiplied with sunlight for backsides of translucent materials.
};

struct MaterialsDataStruct {
	float smoothness;
	float roughness;
	float metallic;
	float material;
	float metals;
	float emissive;

	vec3 F0;
};

struct SpecularAttributesStruct {			//Specular surface shading attributes
	float specularity;			//How reflective a surface is
	float extraSpecularity;		//Additional reflectance for specular reflections from sun only
	float glossiness;			//How smooth or rough a specular surface is
	float metallic;				//from 0 - 1. 0 representing non-metallic, 1 representing fully metallic.
	float gain;					//Adjust specularity further
	float base;					//Reflectance when the camera is facing directly at the surface normal. 0 allows only the fresnel effect to add specularity
	float fresnelPower; 		//Curve of fresnel effect. Higher values mean the surface has to be viewed at more extreme angles to see reflectance
};

struct SkyStruct { 				//All sky shading attributes
	vec3 	albedo;				//Diffuse texture aka "color texture" of the sky
	vec3 	tintColor; 			//Color that will be multiplied with the sky to tint it
	vec3 	sunglow;			//Color that will be added to the sky simulating scattered light arond the sun/moon
	vec3 	sunSpot; 			//Actual sun surface
};

struct WaterStruct {
	vec3 albedo;
};

struct MaskStruct {

	float matIDs;

	float sky;
	float land;
	float grass;
	float leaves;
	float ice;
	float hand;
	float translucent;
	float glow;
	float sunspot;
	float goldBlock;
	float ironBlock;
	float diamondBlock;
	float emeraldBlock;
	float sand;
	float sandstone;
	float stone;
	float cobblestone;
	float wool;
	float clouds;

	float torch;
	float lava;
	float glowstone;
	float fire;

	float water;

	float volumeCloud;

	float stainedGlass;

};

struct CloudsStruct {
	vec3 albedo;
};

struct AOStruct {
	float skylight;
	float scatteredUpLight;
	float bouncedSunlight;
	float scatteredSunlight;
	float constant;
};

struct Ray {
	vec3 dir;
	vec3 origin;
};

struct Plane {
	vec3 normal;
	vec3 origin;
};

struct SurfaceStruct { 			//Surface shading properties, attributes, and functions

	//Attributes that change how shading is applied to each pixel
		DiffuseAttributesStruct  diffuse;			//Contains all diffuse surface attributes
		SpecularAttributesStruct specular;			//Contains all specular surface attributes
		MaterialsDataStruct materials;

	SkyStruct 	    sky;			//Sky shading attributes and properties
	WaterStruct 	water;			//Water shading attributes and properties
	MaskStruct 		mask;			//Material ID Masks
	CloudsStruct 	clouds;
	AOStruct 		ao;				//ambient occlusion

	//Properties that are required for lighting calculation
		vec3 	albedo;					//Diffuse texture aka "color texture"
		vec3 	normal;					//Screen-space surface normals
		vec3	texturedNormal;
		vec3	flatNormal;
		float 	depth;					//Scene depth
		float   linearDepth; 			//Linear depth

		vec4	screenSpacePosition;	//Vector representing the screen-space position of the surface
		vec4 	worldSpacePosition;
		vec3 	viewVector; 			//Vector representing the viewing direction
		vec3 	lightVector; 			//Vector representing sunlight direction
		Ray 	viewRay;
		vec3 	worldLightVector;
		vec3  	upVector;				//Vector representing "up" direction
		float 	NdotL; 					//dot(normal, lightVector). used for direct lighting calculation
		vec3 	debug;

		float 	shadow;
		float 	cloudShadow;

		float 	cloudAlpha;
} surface;

struct LightmapStruct {			//Lighting information to light the scene. These are untextured colored lightmaps to be multiplied with albedo to get the final lit and textured image.
	vec3 sunlight;				//Direct light from the sun
	vec3 skylight;				//Ambient light from the sky
	vec3 bouncedSunlight;		//Fake bounced light, coming from opposite of sun direction and adding to ambient light
	vec3 scatteredSunlight;		//Fake scattered sunlight, coming from same direction as sun and adding to ambient light
	vec3 scatteredUpLight; 		//Fake GI from ground
	vec3 torchlight;			//Light emitted from torches and other emissive blocks
	vec3 lightning;				//Light caused by lightning
	vec3 nolight;				//Base ambient light added to everything. For lighting caves so that the player can barely see even when no lights are present
	vec3 specular;				//Reflected direct light from sun
	vec3 translucent;			//Light on the backside of objects representing thin translucent materials
	vec3 sky;					//Color and brightness of the sky itself
	vec3 underwater;			//underwater lightmap
	vec3 heldLight;
} lightmap;

struct ShadingStruct {			//Shading calculation variables
	float   direct;
	float 	waterDirect;
	float 	bounced; 			//Fake bounced sunlight
	float 	skylight; 			//Light coming from sky
	float 	scattered; 			//Fake scattered sunlight
	float   scatteredUp; 		//Fake GI from ground
	float 	specular; 			//Reflected direct light
	float 	translucent; 		//Backside of objects lit up from the sun via thin translucent materials
	vec3 	sunlightVisibility; //Shadows
	float 	heldLight;
} shading;

struct GlowStruct {
	vec3 torch;
	vec3 lava;
	vec3 glowstone;
	vec3 fire;
};

struct FinalStruct {			//Final textured and lit images sorted by what is illuminating them.

	GlowStruct 		glow;		//Struct containing emissive material final images

	vec3 sunlight;				//Direct light from the sun
	vec3 skylight;				//Ambient light from the sky
	vec3 bouncedSunlight;		//Fake bounced light, coming from opposite of sun direction and adding to ambient light
	vec3 scatteredSunlight;		//Fake scattered sunlight, coming from same direction as sun and adding to ambient light
	vec3 scatteredUpLight; 		//Fake GI from ground
	vec3 torchlight;			//Light emitted from torches and other emissive blocks
	vec3 lightning;				//Light caused by lightning
	vec3 nolight;				//Base ambient light added to everything. For lighting caves so that the player can barely see even when no lights are present
	vec3 translucent;			//Light on the backside of objects representing thin translucent materials
	vec3 sky;					//Color and brightness of the sky itself
	vec3 underwater;			//underwater colors
	vec3 heldLight;


} final;

struct Intersection {
	vec3 pos;
	float distance;
	float angle;
};




/////////////////////////STRUCT FUNCTIONS//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////STRUCT FUNCTIONS//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Mask
void 	CalculateMasks(inout MaskStruct mask) {
		//if (isEyeInWater > 0)
			//mask.sky = 0.0f;
		//else
		mask.sky 			= step(65534.5, mask.matIDs);
		mask.land	 		= 1.0 - mask.sky;
		
		mask.grass 			= GetMaterialMask(texcoord.st, 2, mask.matIDs);
		mask.leaves	 		= GetMaterialMask(texcoord.st, 3, mask.matIDs);
		mask.hand	 		= GetMaterialMask(texcoord.st, 5, mask.matIDs);
		mask.translucent	= GetMaterialMask(texcoord.st, 6, mask.matIDs);

		mask.glow	 		= GetMaterialMask(texcoord.st, 10, mask.matIDs);
		mask.sunspot 		= GetMaterialMask(texcoord.st, 11, mask.matIDs);

		mask.goldBlock 		= GetMaterialMask(texcoord.st, 20, mask.matIDs);
		mask.ironBlock 		= GetMaterialMask(texcoord.st, 21, mask.matIDs);
		mask.diamondBlock	= GetMaterialMask(texcoord.st, 22, mask.matIDs);
		mask.emeraldBlock	= GetMaterialMask(texcoord.st, 23, mask.matIDs);
		mask.sand	 		= GetMaterialMask(texcoord.st, 24, mask.matIDs);
		mask.sandstone 		= GetMaterialMask(texcoord.st, 25, mask.matIDs);
		mask.stone	 		= GetMaterialMask(texcoord.st, 26, mask.matIDs);
		mask.cobblestone	= GetMaterialMask(texcoord.st, 27, mask.matIDs);
		mask.wool			= GetMaterialMask(texcoord.st, 28, mask.matIDs);
		mask.clouds 		= GetMaterialMask(texcoord.st, 29, mask.matIDs);

		mask.torch 			= GetMaterialMask(texcoord.st, 30, mask.matIDs);
		mask.lava 			= GetMaterialMask(texcoord.st, 31, mask.matIDs);
		mask.glowstone 		= GetMaterialMask(texcoord.st, 32, mask.matIDs);
		mask.fire 			= GetMaterialMask(texcoord.st, 33, mask.matIDs);
	
		//float transparentID = GetTransparentID(texcoord.st);

		mask.water 			= GetMaterialMask(texcoord.st, 35, mask.matIDs);
		mask.stainedGlass 	= GetMaterialMask(texcoord.st, 55, mask.matIDs);
		mask.ice		 	= GetMaterialMask(texcoord.st, 4, mask.matIDs);

		mask.volumeCloud 	= 0.0f;
}

//Surface
void 	CalculateNdotL(inout SurfaceStruct surface) {		//Calculates direct sunlight without visibility check
	float direct = dot(surface.normal.rgb, surface.lightVector);
		  direct = direct * 1.0f + 0.0f;
		  //direct = clamp(direct, 0.0f, 1.0f);

	surface.NdotL = direct;
}

float 	CalculateDirectLighting(in SurfaceStruct surface) {

	//Tall grass translucent shading
	if (surface.mask.grass > 0.5f) {

		return clamp(dot(surface.lightVector, surface.upVector) * 0.8 + 0.2, 0.0, 1.0);


	//Leaves
	} else if (surface.mask.leaves > 0.5f) {

		// if (surface.NdotL > -0.01f) {
		// 	return surface.NdotL * 0.99f + 0.01f;
		// } else {
		// 	return abs(surface.NdotL) * 0.25f;
		// }

		return 0.5f;


	//clouds
	} else if (surface.mask.clouds > 0.5f) {

		return 0.5f;


	} else if (surface.mask.ice > 0.5f) {

		return pow(surface.NdotL * 0.5 + 0.5, 2.0f);

	//Default lambert shading
	} else {
		const float PI = 3.14159;
		const float roughness = 0.95;

		// interpolating normals will change the length of the normal, so renormalize the normal.
		vec3 normal = normalize(surface.normal.xyz);


		vec3 eyeDir = normalize(-surface.screenSpacePosition.xyz);

		// normal = normalize(normal + surface.lightVector * pow(clamp(dot(eyeDir, surface.lightVector), 0.0, 1.0), 5.0) * 0.5);

		// normal = normalize(normal + eyeDir * clamp(dot(normal, eyeDir), 0.0f, 1.0f));

		// calculate intermediary values
		float NdotL = dot(normal, surface.lightVector.xyz);
		float NdotV = dot(normal, eyeDir);

		float angleVN = acos(NdotV);
		float angleLN = acos(NdotL);

		float alpha = max(angleVN, angleLN);
		float beta = min(angleVN, angleLN);
		float gamma = dot(eyeDir - normal * dot(eyeDir, normal), surface.lightVector - normal * dot(surface.lightVector, normal));

		float roughnessSquared = roughness * roughness;

		// calculate A and B
		float A = 1.0 - 0.5 * (roughnessSquared / (roughnessSquared + 0.57));

		float B = 0.45 * (roughnessSquared / (roughnessSquared + 0.09));

		float C = sin(alpha) * tan(beta);

		// put it all together
		float L1 = max(0.0, NdotL) * (A + B * max(0.0, gamma) * C);

		//return max(0.0f, surface.NdotL * 0.99f + 0.01f);
		return clamp(L1, 0.0f, 1.0f);
	}
}

vec3 	CalculateSunlightVisibility(inout SurfaceStruct surface, in ShadingStruct shadingStruct) {				//Calculates shadows
	if (rainStrength >= 0.99f)
		return vec3(1.0f);


	if (shadingStruct.direct > 0.0f) {
		float distance = sqrt(  surface.screenSpacePosition.x * surface.screenSpacePosition.x 	//Get surface distance in meters
							  + surface.screenSpacePosition.y * surface.screenSpacePosition.y
							  + surface.screenSpacePosition.z * surface.screenSpacePosition.z);

		#ifdef Enabled_TemportalAntiAliasing
		vec4 ssp = GetScreenSpacePosition(texcoord.xy - jitter);
		#else
		vec4 ssp = surface.screenSpacePosition;
		#endif

		vec4 worldposition = vec4(0.0f);
			 worldposition = gbufferModelViewInverse * ssp;		//Transform from screen space to world space


		#if defined PIXEL_SHADOWS
			worldposition.xyz += cameraPosition.xyz + 0.001;
			worldposition.xyz = floor(worldposition.xyz * TEXTURE_RESOLUTION) / TEXTURE_RESOLUTION;
			worldposition.xyz -= cameraPosition.xyz;
		#endif

		float yDistanceSquared  = worldposition.y * worldposition.y;

		worldposition = shadowModelView * worldposition;	//Transform from world space to shadow space
		float comparedepth = -worldposition.z;				//Surface distance from sun to be compared to the shadow map

		worldposition = shadowProjection * worldposition;
		worldposition /= worldposition.w;

		float dist = sqrt(worldposition.x * worldposition.x + worldposition.y * worldposition.y);
		float distortFactor = (1.0f - SHADOW_MAP_BIAS) + dist * SHADOW_MAP_BIAS;
		worldposition.xy *= 0.95f / distortFactor;
		worldposition.z = mix(worldposition.z, 0.5, 0.8);
		worldposition = worldposition * 0.5f + 0.5f;		//Transform from shadow space to shadow map coordinates

		float shadowMult = 0.0f;																			//Multiplier used to fade out shadows at distance
		float shading = 0.0f;

		float fademult = 0.15f;
			shadowMult = clamp((shadowDistance * 41.4f * fademult) - (distance * fademult), 0.0f, 1.0f);	//Calculate shadowMult to fade shadows out

		if (shadowMult > 0.0) 
		{

			float diffthresh = dist * 1.0f + 0.10f;
				  diffthresh *= 1.0f / (shadowMapResolution / 2048.0f);
				  //diffthresh /= shadingStruct.direct + 0.1f;


			#ifdef PIXEL_SHADOWS
				  //diffthresh += 1.5;
			#endif


			#ifdef ENABLE_SOFT_SHADOWS
			#ifndef VARIABLE_PENUMBRA_SHADOWS

				int count = 0;
				float spread = 1.0f / shadowMapResolution;

				vec3 noise = CalculateNoisePattern1(vec2(0.0), 64.0);

				for (float i = -0.5f; i <= 0.5f; i += 1.0f) 
				{
					for (float j = -0.5f; j <= 0.5f; j += 1.0f) 
					{
						float angle = noise.x * 3.14159 * 2.0;

						mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));

						vec2 coord = vec2(i, j) * rot;

						shading += shadow2D(shadow, vec3(worldposition.st + coord * spread, worldposition.z - 0.0008f * diffthresh)).x;
						count += 1;
					}
				}
				shading /= count;

			#endif
			#endif

			#ifdef VARIABLE_PENUMBRA_SHADOWS

				float vpsSpread = 0.125 / distortFactor;

				float avgDepth = 0.0;
				float minDepth = 11.0;
				int c;

				for (int i = -1; i <= 1; i++)
				{
					for (int j = -1; j <= 1; j++)
					{
						vec2 lookupCoord = worldposition.xy + (vec2(i, j) / shadowMapResolution) * 8.0 * vpsSpread;
						//avgDepth += pow(texture2DLod(shadowtex1, lookupCoord, 2).x, 4.1);
						float depthSample = texture2DLod(shadowtex1, lookupCoord, 2).x;
						minDepth = min(minDepth, texture2DLod(shadowtex1, lookupCoord, 2).x);
						avgDepth += pow(min(max(0.0, worldposition.z - depthSample) * 1.0, 0.15), 2.0);
						c++;
					}
				}

				avgDepth /= c;
				avgDepth = pow(avgDepth, 1.0 / 2.0);

				// float penumbraSize = min(abs(worldposition.z - minDepth), 0.15);
				float penumbraSize = avgDepth;

				int count = 0;
				float spread = penumbraSize * 0.0125 * vpsSpread + 0.5 / shadowMapResolution;

				vec3 noise = CalculateNoisePattern1(vec2(0.0), 64.0);

				diffthresh *= 0.5 + avgDepth * 50.0;

				for (float i = -2.0f; i <= 2.0f; i += 1.0f) 
				{
					for (float j = -2.0f; j <= 2.0f; j += 1.0f) 
					{
						float angle = noise.x * 3.14159 * 2.0;

						mat2 rot = mat2(cos(angle), -sin(angle), sin(angle), cos(angle));

						vec2 coord = vec2(i, j) * rot;

						shading += shadow2D(shadow, vec3(worldposition.st + coord * spread, worldposition.z - 0.0012f * diffthresh)).x;
						count += 1;
					}
				}
				shading /= count;

			#endif

			#ifndef VARIABLE_PENUMBRA_SHADOWS
			#ifndef ENABLE_SOFT_SHADOWS
				//diffthresh *= 2.0f;
				shading = shadow2DLod(shadow, vec3(worldposition.st, worldposition.z - 0.0006f * diffthresh), 0).x;
			#endif
			#endif

		}

		//shading = mix(1.0f, shading, shadowMult);

		surface.shadow = shading;

		vec3 result = vec3(shading);


		///*
		#ifdef COLORED_SHADOWS
		float shadowNormalAlpha = texture2DLod(shadowcolor1, worldposition.st, 0).a;

		vec3 noise2 = CalculateNoisePattern1(vec2(0.0), 64.0);

		//worldposition.st += (noise2.xy * 2.0 - 1.0) / shadowMapResolution;

		if (shadowNormalAlpha < 0.5)
		{
			result = mix(vec3(1.0), pow(texture2DLod(shadowcolor, worldposition.st, 0).rgb, vec3(1.6)), vec3(1.0 - shading));
			float solidDepth = texture2DLod(shadowtex1, worldposition.st, 0).x;
			float solidShadow = 1.0 - clamp((worldposition.z - solidDepth) * 1200.0, 0.0, 1.0); 
			result *= solidShadow;
		}
		#endif
		//*/

		result = mix(vec3(1.0), result, shadowMult);

		return result;
	} else {
		return vec3(0.0f);
	}
}

float 	CalculateBouncedSunlight(in SurfaceStruct surface) {

	float NdotL = surface.NdotL;
	float bounced = clamp(-NdotL + 0.95f, 0.0f, 1.95f) / 1.95f;
		  bounced = bounced * bounced * bounced;

	return bounced;
}

float 	CalculateScatteredSunlight(in SurfaceStruct surface) {

	float NdotL = surface.NdotL;
	float scattered = clamp(NdotL * 0.75f + 0.25f, 0.0f, 1.0f);
		  //scattered *= scattered * scattered;

	return scattered;
}

float 	CalculateSkylight(in SurfaceStruct surface) {

	if (surface.mask.clouds > 0.5f) {
		return 1.0f;

	} else if (surface.mask.leaves > 0.5) {

	 	return dot(surface.normal, surface.upVector) * 0.35 + 0.65;

	} else if (surface.mask.grass > 0.5f) {

		return 1.6f;

	} else {

		float skylight = dot(surface.normal, surface.upVector);
			  skylight = skylight * 0.4f + 0.6f;

		return skylight;
	}
}

float 	CalculateScatteredUpLight(in SurfaceStruct surface) {
	float scattered = dot(surface.normal, surface.upVector);
		  scattered = scattered * 0.5f + 0.5f;
		  scattered = 1.0f - scattered;

	return scattered;
}

float CalculateHeldLightShading(in SurfaceStruct surface)
{
	vec3 lightPos = vec3(0.0f);
	vec3 lightVector = normalize(lightPos - surface.screenSpacePosition.xyz);
	float lightDist = length(lightPos.xyz - surface.screenSpacePosition.xyz);

	float atten = 1.0f / (pow(lightDist, 2.0f) + 0.5f);
	float NdotL = 1.0f;

	return atten * NdotL;
}

float   CalculateSunglow(in SurfaceStruct surface) {

	float curve = 4.0f;

	vec3 npos = normalize(surface.screenSpacePosition.xyz);
	vec3 halfVector2 = normalize(-surface.lightVector + npos);
	float factor = 1.0f - dot(halfVector2, npos);

	return factor * factor * factor * factor;
}

float   CalculateAntiSunglow(in SurfaceStruct surface) {

	float curve = 4.0f;

	vec3 npos = normalize(surface.screenSpacePosition.xyz);
	vec3 halfVector2 = normalize(surface.lightVector + npos);
	float factor = 1.0f - dot(halfVector2, npos);

	return factor * factor * factor * factor;
}

void 	GetLightVectors(inout MCLightmapStruct mcLightmap, in SurfaceStruct surface) {

	vec2 torchDiff = vec2(0.0f);
		 torchDiff.x = GetLightmapTorch(texcoord.st) - GetLightmapTorch(texcoord.st + vec2(1.0f / viewWidth, 0.0f));
		 torchDiff.y = GetLightmapTorch(texcoord.st) - GetLightmapTorch(texcoord.st + vec2(0.0f, 1.0f / viewWidth));

		 //torchDiff /= GetDepthLinear(texcoord.st);

	mcLightmap.torchVector.x = torchDiff.x * 200.0f;
	//mcLightmap.torchVector.x *= 1.0f - surface.viewVector.x;

	mcLightmap.torchVector.y = torchDiff.y * 200.0f;

	mcLightmap.torchVector.x = 1.0f;
	mcLightmap.torchVector.y = 0.0f;
	mcLightmap.torchVector.z = sqrt(1.0f - mcLightmap.torchVector.x * mcLightmap.torchVector.x + mcLightmap.torchVector.y + mcLightmap.torchVector.y);




	float torchNormal = dot(surface.normal.rgb, mcLightmap.torchVector.rgb);

	mcLightmap.torchVector.x = torchNormal;


	//mcLightmap.torchVector = mcLightmap.torchVector * 0.5f + 0.5f;
}

void 	AddSkyGradient(inout SurfaceStruct surface) {
	float curve = 5.0f;
	vec3 npos = normalize(surface.screenSpacePosition.xyz);
	vec3 halfVector2 = normalize(-surface.upVector + npos);
	float skyGradientFactor = dot(halfVector2, npos);
	float skyDirectionGradient = skyGradientFactor;

	if (dot(halfVector2, npos) > 0.75)
		skyGradientFactor = 1.5f - skyGradientFactor;

	skyGradientFactor = pow(skyGradientFactor, curve);

	surface.sky.albedo = CalculateLuminance(surface.sky.albedo) * colorSkylight;

	surface.sky.albedo *= mix(skyGradientFactor, 1.0f, clamp((0.12f - (timeNoon * 0.1f)) + rainStrength, 0.0f, 1.0f));
	surface.sky.albedo *= pow(skyGradientFactor, 2.5f) + 0.2f;
	surface.sky.albedo *= (pow(skyGradientFactor, 1.1f) + 0.425f) * 0.5f;
	surface.sky.albedo.g *= skyGradientFactor * 1.0f + 1.0f;


	vec3 linFogColor = pow(gl_Fog.color.rgb, vec3(2.2f));

	float fogLum = max(max(linFogColor.r, linFogColor.g), linFogColor.b);


	float fade1 = clamp(skyGradientFactor - 0.05f, 0.0f, 0.2f) / 0.2f;
		  fade1 = fade1 * fade1 * (3.0f - 2.0f * fade1);
	vec3 color1 = vec3(12.0f, 8.0, 4.7f) * 0.15f;
		 color1 = mix(color1, vec3(2.0f, 0.55f, 0.2f), vec3(timeSunriseSunset));

	surface.sky.albedo *= mix(vec3(1.0f), color1, vec3(fade1));

	float fade2 = clamp(skyGradientFactor - 0.11f, 0.0f, 0.2f) / 0.2f;
	vec3 color2 = vec3(2.7f, 1.0f, 2.8f) / 20.0f;
		 color2 = mix(color2, vec3(1.0f, 0.15f, 0.5f), vec3(timeSunriseSunset));

	surface.sky.albedo *= mix(vec3(1.0f), color2, vec3(fade2 * 0.5f));



	float horizonGradient = 1.0f - distance(skyDirectionGradient, 0.72f) / 0.72f;
		  horizonGradient = pow(horizonGradient, 10.0f);
		  horizonGradient = max(0.0f, horizonGradient);

	float sunglow = CalculateSunglow(surface);
		  horizonGradient *= sunglow * 2.0f + (0.65f - timeSunriseSunset * 0.55f);

	vec3 horizonColor1 = vec3(1.5f, 1.5f, 1.5f);
		 horizonColor1 = mix(horizonColor1, vec3(1.5f, 1.95f, 1.5f) * 2.0f, vec3(timeSunriseSunset));
	vec3 horizonColor2 = vec3(1.5f, 1.2f, 0.8f) * 1.0f;
		 horizonColor2 = mix(horizonColor2, vec3(1.9f, 0.6f, 0.4f) * 2.0f, vec3(timeSunriseSunset));

	surface.sky.albedo *= mix(vec3(1.0f), horizonColor1, vec3(horizonGradient) * (1.0f - timeMidnight));
	surface.sky.albedo *= mix(vec3(1.0f), horizonColor2, vec3(pow(horizonGradient, 2.0f)) * (1.0f - timeMidnight));

	float grayscale = fogLum / 10.0f;
		  grayscale /= 3.0f;

	surface.sky.albedo = mix(surface.sky.albedo, vec3(grayscale * colorSkylight.r) * 0.06f * vec3(0.85f, 0.85f, 1.0f), vec3(rainStrength));


	surface.sky.albedo /= fogLum;


	surface.sky.albedo *= mix(1.0f, 4.5f, timeNoon);



	// //Fake land
	//vec3 fakeLandColor = vec3(0.7f, 0.9f, 1.0f) * 0.012f;
	//surface.sky.albedo = mix(surface.sky.albedo, fakeLandColor, clamp(skyGradientFactor * 8.0f - 0.7f, 0.0f, 1.0f));


	surface.sky.albedo *= (surface.mask.sky);
}

vec4 BilateralUpsample(const in float scale, in vec2 offset, in float depth, in vec3 normal)
{
	vec2 recipres = vec2(1.0f / viewWidth, 1.0f / viewHeight);

	vec4 light = vec4(0.0f);
	float weights = 0.0f;

	for (float i = -0.5f; i <= 0.5f; i += 1.0f)
	{
		for (float j = -0.5f; j <= 0.5f; j += 1.0f)
		{
			vec2 coord = vec2(i, j) * recipres * 2.0f;

			float sampleDepth = GetDepthLinear(texcoord.st + coord * 2.0f * (exp2(scale)));
			vec3 sampleNormal = GetNormals(texcoord.st + coord * 2.0f * (exp2(scale)));
			//float weight = 1.0f / (pow(abs(sampleDepth - depth) * 1000.0f, 2.0f) + 0.001f);
			float weight = clamp(1.0f - abs(sampleDepth - depth) / 2.0f, 0.0f, 1.0f);
				  weight *= max(0.0f, dot(sampleNormal, normal) * 2.0f - 1.0f);
			//weight = 1.0f;

			light +=	pow(texture2DLod(gaux1, (texcoord.st) * (1.0f / exp2(scale )) + 	offset + coord, 1), vec4(2.2f, 2.2f, 2.2f, 1.0f)) * weight;

			weights += weight;
		}
	}


	light /= max(0.00001f, weights);

	if (weights < 0.01f)
	{
		light =	pow(texture2DLod(gaux1, (texcoord.st) * (1.0f / exp2(scale 	)) + 	offset, 2), vec4(2.2f, 2.2f, 2.2f, 1.0f));
	}


	// vec3 light =	texture2DLod(gcolor, (texcoord.st) * (1.0f / pow(2.0f, 	scale 	)) + 	offset, 2).rgb;


	return light;
}

vec4 Delta(vec3 albedo, vec3 normal, float skylight)
{
	float depth = GetDepthLinear(texcoord.st);

	vec4 delta = BilateralUpsample(GI_RENDER_RESOLUTION, vec2(0.0f, 0.0f), 		depth, normal);

	delta.rgb = delta.rgb * albedo * colorSunlight;

	delta.rgb *= 1.0f;

	delta.rgb *= 3.0f * delta.a * (1.0 - rainStrength) * pow(skylight, 0.05);

	// delta.rgb *= sin(frameTimeCounter) > 0.6 ? 0.0 : 1.0;

	return delta;
}

vec3 NewSkyLight(float p, in SurfaceStruct surface){
	float a = -1.;
	float b = -0.24;
	float c = 6.0;
	float d = -0.8;
	float e = 0.45;
	


	vec3 sVector = surface.screenSpacePosition.xyz;
		 sVector = normalize(sVector);
	
	float cosT = dot(sVector, upVector); 
	float absCosT = max(cosT, 0.0);
	float cosS = dot(sunVectorView, upVector);		
	float cosY = dot(sunVectorView, sVector);
	float Y = acos(cosY);

	float SdotU = dot(sunVectorView, upVector);
	float MdotU = dot(moonVector, upVector);
	float sunVisibility = pow(clamp(SdotU+0.1, 0.0, 0.1) / 0.1, 2.0);	
	
	float L = (1 + -(exp(b / (absCosT + 0.01)))) * (1 + c * exp(d * Y) + e * cosY * cosY); 
		  //L = pow(L, 1.0 - rainStrength * 0.8)*(1.0 - rainStrength * 0.83);  
		  
	vec3 lightColor	= vec3(0.0);
		 //lightColor += vec3(1.0, 0.6, 0.0) * 3.0 * timeSunrise;
		 lightColor += vec3(5.5, 2.1, 0.0) * 1.5 * timeSunriseSunset;
		 
		 lightColor += vec3(0.0, 1.1, 5.0) * timeMidnight;
		 
		 lightColor *= 1-rainStrength;
		 
		 lightColor = pow(lightColor, vec3(2.2));
		 lightColor *= 1.0 - exp(-0.005 * pow(L, 4.0) * (1.0 - rainStrength * 0.985));	
		 lightColor *= p;
		 //lightColor = min(lightColor, vec3(p / 10.0));
		 lightColor *= sunVisibility;
		 
	return lightColor;
}

void CalculateMaterialData(inout SurfaceStruct surface, in vec2 coord){
	float packageMaterialData = texture2D(composite, coord).x;

	surface.materials.metallic		= max(0.02, unpack2x8Y(packageMaterialData));
	surface.materials.metals 		= step(0.9, surface.materials.metallic);
	surface.materials.F0			= mix(vec3(surface.materials.metallic), surface.albedo, surface.materials.metals);


	surface.materials.smoothness 	= unpack2x8X(packageMaterialData);
	surface.materials.roughness		= (1.0 - surface.materials.smoothness); 
	surface.materials.roughness 	*= surface.materials.roughness;
	surface.materials.material		= floor(texture2D(composite, coord).g * 65535.0);
	surface.materials.emissive		= texture2D(gdepth, coord).g; 
	surface.materials.emissive 		*= step(surface.materials.emissive, 0.999);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////MAIN//////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void main() {

	//Initialize surface properties required for lighting calculation for any surface that is not part of the sky
	surface.albedo 				= GetAlbedoLinear(texcoord.st);					//Gets the albedo texture

	surface.depth  				= GetDepth(texcoord.st);						//Gets the scene depth
	surface.linearDepth 		= ExpToLinearDepth(surface.depth); 				//Get linear scene depth

	surface.screenSpacePosition = GetScreenSpacePosition(texcoord.st); 			//Gets the screen-space position
	surface.worldSpacePosition  = gbufferModelViewInverse * surface.screenSpacePosition;
	surface.viewVector 			= normalize(surface.screenSpacePosition.rgb);	//Gets the view vector

	surface.texturedNormal		= NormalDecode(texture2D(gnormal, texcoord.xy).xy);
	surface.flatNormal			= NormalDecode(texture2D(gnormal, texcoord.xy).zw);
	surface.normal 				= mix(surface.flatNormal, surface.texturedNormal, step(0.2, dot(-surface.viewVector, surface.texturedNormal)));	//Gets the screen-space normals

	surface.lightVector 		= lightVector;									//Gets the sunlight vector
	//vec4 wlv 					= gbufferModelViewInverse * vec4(surface.lightVector, 1.0f);
	vec4 wlv 					= shadowModelViewInverse * vec4(0.0f, 0.0f, 1.0f, 0.0f);
	surface.worldLightVector 	= normalize(wlv.xyz);
	surface.upVector 			= upVector;										//Store the up vector

	surface.mask.matIDs 		= GetMaterialIDs(texcoord.st);					//Gets material ids
	CalculateMasks(surface.mask);

	if (surface.mask.water > 0.5)
	{
		//surface.albedo *= 1.9;
		//surface.albedo = mix(surface.albedo, vec3(0.5, 0.9, 0.1) * 0.15, vec3(0.5));
		//surface.albedo = mix(surface.albedo, vec3(0.5, 0.9, 0.1) * 0.15, vec3(saturate(dot(surface.normal, upVector) * 0.5 + 0.5)));
	}

	surface.albedo *= 1.0f - (surface.mask.sky); 						//Remove the sky from surface albedo, because sky will be handled separately

	//Initialize sky surface properties
	surface.sky.albedo 		= GetAlbedoLinear(texcoord.st) * (min(1.0f, (surface.mask.sky) + (surface.mask.sunspot)));							//Gets the albedo texture for the sky
	surface.sky.tintColor   = vec3(1.0f);

	AddSkyGradient(surface);



	//Initialize MCLightmap values
	mcLightmap.torch 		= GetLightmapTorch(texcoord.st);	//Gets the lightmap for light coming from emissive blocks
	mcLightmap.sky   		= GetLightmapSky(texcoord.st);		//Gets the lightmap for light coming from the sky

	mcLightmap.lightning    = 0.0f;								//gets the lightmap for light coming from lightning

	if (surface.mask.water > 0.5 || surface.mask.ice > 0.5)
	{
		mcLightmap.sky 		= GetTransparentLightmapSky(texcoord.st);
	}

	//Initialize default surface shading attributes
	surface.diffuse.roughness 			= 0.0f;					//Default surface roughness
	surface.diffuse.translucency 		= 0.0f;					//Default surface translucency
	surface.diffuse.translucencyColor 	= vec3(1.0f);			//Default translucency color

	surface.specular.specularity 		= GetSpecularity(texcoord.st);	//Gets the reflectance/specularity of the surface
	surface.specular.extraSpecularity 	= 0.0f;							//Default value for extra specularity
	surface.specular.glossiness 		= GetGlossiness(texcoord.st);
	surface.specular.metallic 			= 0.0f;							//Default value of how metallic the surface is
	surface.specular.gain 				= 1.0f;							//Default surface specular gain
	surface.specular.base 				= 0.0f;							//Default reflectance when the surface normal and viewing normal are aligned
	surface.specular.fresnelPower 		= 5.0f;							//Default surface fresnel power


	CalculateMaterialData(surface, texcoord);

	//Calculate surface shading
	CalculateNdotL(surface);
	shading.direct  			= CalculateDirectLighting(surface);				//Calculate direct sunlight without visibility check (shadows)

	shading.sunlightVisibility 	= CalculateSunlightVisibility(surface, shading);					//Calculate shadows and apply them to direct lighting
	shading.sunlightVisibility	*= colorSunlight;
	shading.sunlightVisibility	*= GetParallaxShadow(texcoord.st);

	shading.direct 				*= mix(1.0f, 0.0f, rainStrength);
	float caustics = 1.0;
	shading.direct *= caustics;
	shading.waterDirect 		= shading.direct;
	shading.direct 				*= pow(mcLightmap.sky, 0.1f);
	// shading.bounced 	= CalculateBouncedSunlight(surface);			//Calculate fake bounced sunlight
	shading.scattered 	= CalculateScatteredSunlight(surface);			//Calculate fake scattered sunlight
	shading.skylight 	= CalculateSkylight(surface);					//Calculate scattered light from sky
	shading.heldLight 	= CalculateHeldLightShading(surface);

	float ao = 1.0;

	vec4 delta = vec4(0.0);
	delta.a = 1.0;

	#ifndef BASIC_AMBIENT
		if (isEyeInWater < 1)
		{
			delta = Delta(surface.albedo.rgb, surface.normal.xyz, mcLightmap.sky);
		}

		ao = 1.0 - delta.a;
	#endif

	//Colorize surface shading and store in lightmaps
	vec3 eyeDirection = normalize(-surface.screenSpacePosition.xyz);

	lightmap.sunlight			= CalculateDiffuseLighting(shadowLightVector, -surface.viewVector, surface.texturedNormal, surface.normal, surface.albedo, 1.0, surface.materials.F0, surface.materials.roughness, surface.materials.metallic, 0.0);
	lightmap.sunlight			+= CalculateSpecularLighting(shadowLightVector, -surface.viewVector, surface.texturedNormal, surface.normal, surface.albedo, 1.0, surface.materials.F0, surface.materials.roughness, surface.materials.metallic, 0.0);
	lightmap.sunlight 			*= shading.sunlightVisibility;

	lightmap.skylight 			= vec3(mcLightmap.sky);
	lightmap.skylight 			*= mix(colorSkylight, colorBouncedSunlight, vec3(max(0.2f, (1.0f - pow(mcLightmap.sky + 0.13f, 1.0f) * 1.0f)))) + colorBouncedSunlight * (mix(0.3f, 2.8f, 0.0)) * (1.0f - rainStrength);
	lightmap.skylight 			*= shading.skylight;
	lightmap.skylight 			*= mix(1.0f, 5.0f, (surface.mask.clouds));
	lightmap.skylight 			*= mix(1.0f, 50.0f, (surface.mask.clouds) * timeSkyDark);
	lightmap.skylight 			*= surface.ao.skylight;
	lightmap.skylight 			+= mix(colorSkylight, colorSunlight, vec3(0.2f)) * vec3(mcLightmap.sky) * surface.ao.constant * 0.05f;
	lightmap.skylight 			*= mix(1.0f, 0.4f, rainStrength);
	lightmap.skylight 			*= ao;



	lightmap.scatteredSunlight  = vec3(shading.scattered) * colorSunlight * (1.0f - rainStrength);
	lightmap.scatteredSunlight 	*= pow(vec3(mcLightmap.sky), vec3(1.0f));
	lightmap.scatteredSunlight 	*= ao;

	lightmap.underwater 		= vec3(mcLightmap.sky) * colorSkylight;

	lightmap.torchlight 		= mcLightmap.torch * colorTorchlight;
	lightmap.torchlight 		*= ao;
	lightmap.torchlight 		*= pow(caustics, 0.5) * 0.4 + 0.6;

	lightmap.nolight 			= vec3(0.05f);
	lightmap.nolight 			*= surface.ao.constant;
	lightmap.nolight 			*= ao;

	lightmap.heldLight 			= vec3(shading.heldLight);
	lightmap.heldLight 			*= colorTorchlight;
	lightmap.heldLight 			*= ao;
	lightmap.heldLight 			*= heldBlockLightValue / 16.0f;




	//If eye is in water
	if (isEyeInWater > 0) {
		vec3 halfColor = mix(colorWaterMurk, vec3(1.0f), vec3(0.5f));
		lightmap.sunlight *= mcLightmap.sky * halfColor;
		lightmap.skylight *= halfColor;
		lightmap.bouncedSunlight *= 0.0f;
		lightmap.scatteredSunlight *= halfColor;
		lightmap.nolight *= halfColor;
		lightmap.scatteredUpLight *= halfColor;
	}

	surface.albedo.rgb = mix(surface.albedo.rgb, pow(surface.albedo.rgb, vec3(2.0f)), vec3((surface.mask.fire)));


	//Apply lightmaps to albedo and generate final shaded surface
	final.nolight 			= surface.albedo * lightmap.nolight;
	final.sunlight 			= lightmap.sunlight;
	final.skylight 			= surface.albedo * lightmap.skylight;
	final.bouncedSunlight 	= surface.albedo * lightmap.bouncedSunlight;
	final.scatteredSunlight = surface.albedo * lightmap.scatteredSunlight;
	final.scatteredUpLight  = surface.albedo * lightmap.scatteredUpLight;
	final.torchlight 		= surface.albedo * lightmap.torchlight;
	final.underwater        = surface.water.albedo * colorWaterBlue;
	final.underwater 		*= (lightmap.sunlight * 0.3f) + (lightmap.skylight * 0.06f) + (lightmap.torchlight * 0.0165) + (lightmap.nolight * 0.002f);


	//final.glow.torch 				= pow(surface.albedo, vec3(4.0f)) * float(surface.mask.torch);
	final.glow.lava 				= Glowmap(surface.albedo, surface.mask.lava,      4.0f, vec3(1.0f, 0.05f, 0.001f));

	final.glow.glowstone 			= Glowmap(surface.albedo, surface.mask.glowstone, 2.0f, colorTorchlight*0.1);
	final.torchlight 			   *= 1.0f - (surface.mask.glowstone);

	final.glow.fire 				= surface.albedo * (surface.mask.fire);
	final.glow.fire 				= pow(final.glow.fire, vec3(1.0f));

	final.glow.torch 				= pow(surface.albedo * (surface.mask.torch), vec3(4.4f));



	//Remove glow items from torchlight to keep control
	final.torchlight *= 1.0f - (surface.mask.lava);
	final.heldLight = lightmap.heldLight * surface.albedo;


	//Do night eye effect on outdoor lighting and sky
	DoNightEye(final.sunlight);
	DoNightEye(final.skylight);
	DoNightEye(final.bouncedSunlight);
	DoNightEye(final.scatteredSunlight);
	DoNightEye(surface.sky.albedo);
	DoNightEye(final.underwater);
	DoNightEye(delta.rgb);

	DoLowlightEye(final.nolight);



	surface.cloudShadow = 1.0f;
	const float sunlightMult = 0.21f;

	//Apply lightmaps to albedo and generate final shaded surface
	vec3 finalComposite = final.sunlight 			* 0.9f 	* 1.5f * sunlightMult				//Add direct sunlight
						+ final.skylight 			* 0.03f				//Add ambient skylight
						+ final.nolight 			* 0.0006f 			//Add base ambient light
						+ final.scatteredSunlight 	* 0.02f		* (1.0f - sunlightMult)					//Add fake scattered sunlight
						+ final.torchlight 			* 2.0f 		* TORCHLIGHT_BRIGHTNESS	//Add light coming from emissive blocks
						+ final.glow.lava			* 1.6f 		* TORCHLIGHT_BRIGHTNESS
						+ final.glow.glowstone		* 1.1f 		* TORCHLIGHT_BRIGHTNESS
						+ final.glow.fire			* 0.025f 	* TORCHLIGHT_BRIGHTNESS
						+ final.glow.torch			* 0.15f 	* TORCHLIGHT_BRIGHTNESS
						+ final.heldLight 			* 0.05f 	* TORCHLIGHT_BRIGHTNESS
						;

	delta.rgb *= mix(vec3(1.0), vec3(0.1, 0.3, 1.0) * 1.0, surface.mask.water);

	vec3 diffuse = finalComposite;
		 diffuse *= 1.0 - surface.materials.metals;

	finalComposite = max(vec3(0.0), diffuse);

	vec3 specular = colorSkylight * CalculateSpecularLightingNormalized(normalize(reflect(surface.viewVector, surface.normal)), -surface.viewVector, surface.normal, surface.normal, surface.albedo, 1.0, surface.materials.F0, surface.materials.roughness, surface.materials.metallic, 0.0);

	//Apply sky to final composite
	surface.sky.albedo *= 6.0f;

	#ifdef NEW_SKY_LIGHT
		 vec3 sL = NewSkyLight(0.045, surface) * float(surface.mask.sky);
		 surface.sky.albedo = surface.sky.albedo * surface.sky.tintColor + surface.sky.sunglow + sL;
	#else
		 surface.sky.albedo = surface.sky.albedo * surface.sky.tintColor + surface.sky.sunglow;
	#endif

	finalComposite 	+= surface.sky.albedo;		//Add sky to final image

	finalComposite *= 0.001f;												//Scale image down for HDR
	finalComposite.b *= 1.0f;

	 finalComposite = pow(finalComposite, vec3(1.0f / 2.2f)); 					//Convert final image into gamma 0.45 space to compensate for gamma 2.2 on displays



	/* DRAWBUFFERS:6 */	//01345
	gl_FragData[0] = vec4(finalComposite, 1.0);
}
