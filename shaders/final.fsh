#version 330 compatibility

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
 
#define VERSION 0.9.0      //Arlic Shaders VERSION.

//#define FINAL_ALT_COLOR_SOURCE 
#define AVERAGE_EXPOSURE // Uses the average screen brightness to calculate exposure. Disable for old exposure behavior.

//#define MOTION_BLUR // It's motion blur.

#define ACES_TONEMAPPING
	#define DARKNESS 4.25 // [0.25 0.5 0.75 1.0 1.5 2.0 2.5 3.0 3.5 4.0 4.25 5.0 7.0 9.0 12.0]
#define TONEMAP_STRENGTH 3.0 // Determines how bright colors are compressed during tonemapping. Lower levels result in more filmic soft look. Higher levels result in more natural vibrant look. [2.0 3.0 4.0]
#define BRIGHTNESS_LEVEL 1.5 // Pre-tonemapping brightness levels. [1.0 1.25 1.5 1.75 2.0]
#define SATURATION_STRENGTH 0.0 // [-2.0 -1.95 -1.9 -1.85 -1.8 -1.75 -1.7 -1.65 -1.6 -1.55 -1.5 -1.45 -1.4 -1.35 -1.3 -1.25 -1.2 -1.15 -1.1 -0.05 0.0 0.05 1.0 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.17 1.75 1.8 1.85 1.9 1.95 2.0]
#define MAX_BLUR_AMOUNT 1.2 // [0.2 0.4 0.6 0.9 1.2 1.5 1.9 2.3 2.7]

#define DOF
	#define HEXAGONAL_BOKEH
		const float FringeOffset = 0.25;

	#define FOCUS_BLUR
		//#define LINK_FOCUS_TO_BRIGHTNESS_BAR
	#define BlurAmount 4.8 // [0.4 0.8 1.6 3.2 4.8 6.4 8.0 9.6]
	
	#define DISTANCE_BLUR
	#define MaxDistanceBlurAmount 0.9 // [0.1 0.2 0.4 0.6 0.9 1.2 1.5 1.8]
	#define DistanceBlurRange 360 // [60 120 180 240 360 480 600 720 960 1200]
		
	#define EDGE_BLUR
	#define EdgeBlurAmount 1.75  // [0.5 0.75 1.0 1.25 1.5 1.75 2.0]
	#define EdgeBlurDecline 3.0  // [0.3 0.6 0.9 1.2 1.5 1.8 1.9 2.0 2.1 2.4 3.0 3.3 3.6 3.9 4.2]

in vec4 texcoord;
in vec3 lightVector;

uniform float aspectRatio;

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D gdepthtex;
uniform sampler2D colortex2;
uniform sampler2D colortex3;

uniform sampler2D shadowcolor;
uniform sampler2D shadowcolor1;
uniform sampler2D shadowtex1;

in float timeSunriseSunset;
in float timeNoon;
in float timeMidnight;

in vec3 colorSunlight;
in vec3 colorSkylight;

#define BANDING_FIX_FACTOR 1.0f

#extension GL_ARB_shader_texture_lod: require
const bool colortex3MipmapEnabled = true;
const bool colortex2MipmapEnabled = true;

#include "/libs/uniform.glsl"

/////////////////////////FUNCTIONS/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////FUNCTIONS/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
vec3 	GetTexture(in sampler2D tex, in vec2 coord) {				//Perform a texture lookup with BANDING_FIX_FACTOR compensation
	return pow(texture(tex, coord).rgb, vec3(BANDING_FIX_FACTOR + 1.2f));
}

vec3 	GetTextureLod(in sampler2D tex, in vec2 coord, in int level) {				//Perform a texture lookup with BANDING_FIX_FACTOR compensation
	return pow(textureLod(tex, coord, level).rgb, vec3(BANDING_FIX_FACTOR + 1.2f));
}

vec3 	GetTexture(in sampler2D tex, in vec2 coord, in int LOD) {	//Perform a texture lookup with BANDING_FIX_FACTOR compensation and lod offset
	return pow(texture(tex, coord, LOD).rgb, vec3(BANDING_FIX_FACTOR));
}

float GetSunlightVisibility(in vec2 coord)
{
	return texture(colortex1, coord).g;
}

float 	GetDepth(in vec2 coord) {
	return texture(gdepthtex, coord).x;
}

float 	GetDepthLinear(in vec2 coord) {					//Function that retrieves the scene depth. 0 - 1, higher values meaning farther away
	return 2.0f * near * far / (far + near - (2.0f * texture(gdepthtex, coord).x - 1.0f) * (far - near));
}

vec3 	GetColorTexture(in vec2 coord) {
	#ifdef FINAL_ALT_COLOR_SOURCE
	return GetTextureLod(colortex0, coord.st, 0).rgb;
	#else
	return GetTextureLod(colortex2, coord.st, 0).rgb;
	#endif
}

float 	GetMaterialIDs(in vec2 coord) {			//Function that retrieves the texture that has all material IDs stored in it
	return texture(colortex1, coord).r;
}

float saturate(float x)
{
	return clamp(x, 0.0, 1.0);
}

vec4  	GetWorldSpacePosition(in vec2 coord) {	//Function that calculates the screen-space position of the objects in the scene using the depth texture and the texture coordinates of the full-screen quad
	float depth = GetDepth(coord);
		  //depth += float(GetMaterialMask(coord, 5)) * 0.38f;
	vec4 fragposition = gbufferProjectionInverse * vec4(coord.s * 2.0f - 1.0f, coord.t * 2.0f - 1.0f, 2.0f * depth - 1.0f, 1.0f);
		 fragposition /= fragposition.w;

	return fragposition;
}

vec4 cubic(float x)
{
    float x2 = x * x;
    float x3 = x2 * x;
    vec4 w;
    w.x =   -x3 + 3*x2 - 3*x + 1;
    w.y =  3*x3 - 6*x2       + 4;
    w.z = -3*x3 + 3*x2 + 3*x + 1;
    w.w =  x3;
    return w / 6.f;
}

vec4 BicubicTexture(in sampler2D tex, in vec2 coord)
{
	vec2 resolution = vec2(viewWidth, viewHeight);

	coord *= resolution;

	float fx = fract(coord.x);
    float fy = fract(coord.y);
    coord.x -= fx;
    coord.y -= fy;

    fx -= 0.5;
    fy -= 0.5;

    vec4 xcubic = cubic(fx);
    vec4 ycubic = cubic(fy);

    vec4 c = vec4(coord.x - 0.5, coord.x + 1.5, coord.y - 0.5, coord.y + 1.5);
    vec4 s = vec4(xcubic.x + xcubic.y, xcubic.z + xcubic.w, ycubic.x + ycubic.y, ycubic.z + ycubic.w);
    vec4 offset = c + vec4(xcubic.y, xcubic.w, ycubic.y, ycubic.w) / s;

    vec4 sample0 = texture(tex, vec2(offset.x, offset.z) / resolution);
    vec4 sample1 = texture(tex, vec2(offset.y, offset.z) / resolution);
    vec4 sample2 = texture(tex, vec2(offset.x, offset.w) / resolution);
    vec4 sample3 = texture(tex, vec2(offset.y, offset.w) / resolution);

    float sx = s.x / (s.x + s.y);
    float sy = s.z / (s.z + s.w);

    return mix( mix(sample3, sample2, sx), mix(sample1, sample0, sx), sy);
}

bool 	GetMaterialMask(in vec2 coord, in int ID) {
	float	  matID = floor(GetMaterialIDs(coord) * 255.0f);

	//Catch last part of sky
	if (matID > 254.0f) {
		matID = 0.0f;
	}

	if (matID == ID) {
		return true;
	} else {
		return false;
	}
}

bool 	GetMaterialMask(in vec2 coord, in int ID, float matID) {
	matID = floor(matID * 255.0f);

	//Catch last part of sky
	if (matID > 254.0f) {
		matID = 0.0f;
	}

	if (matID == ID) {
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

bool  	GetSkyMask(in vec2 coord) {					//Function that returns "true" if a pixel is water, and "false" if a pixel is not water.
	float matID = floor(GetMaterialIDs(coord) * 255.0f);

	if (matID >= 0.1f) {
		return false;
	} else {
		return true;
	}
}

float Luminance(in vec3 color)
{
	return dot(color.rgb, vec3(0.2125f, 0.7154f, 0.0721f));
}

float ld(float depth) {
    return near / (far + near - depth * (far - near));
}

vec2 fake_refract = vec2(sin(frameTimeCounter*1.7 + texcoord.x*50.0 + texcoord.y*25.0),cos(frameTimeCounter*2.5 + texcoord.y*100.0 + texcoord.x*25.0)) * isEyeInWater;
/*
void SaturationBoost(inout vec3 color) {
	float satBoost = SATURATION_STRENGTH;

	color.r = color.r * (0.97f + satBoost * 1.0f) - (color.g * satBoost) - (color.b * satBoost);
	color.g = color.g * (0.97f + satBoost * 1.0f) - (color.r * satBoost) - (color.b * satBoost);
	color.b = color.b * (0.97f + satBoost * 1.0f) - (color.r * satBoost) - (color.g * satBoost);
}
*/

void SaturationBoost(inout vec3 color) {
	float satBoost = (SATURATION_STRENGTH * 0.2);

	color.r = color.r * (1.0f + satBoost) - (color.g * satBoost) - (color.b * satBoost);
	color.g = color.g * (1.0f + satBoost) - (color.r * satBoost) - (color.b * satBoost);
	color.b = color.b * (1.0f + satBoost) - (color.r * satBoost) - (color.g * satBoost);
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

float R2_dither(){
	vec2 alpha = vec2(0.75487765, 0.56984026);
	
	return fract(alpha.x * gl_FragCoord.x + alpha.y * gl_FragCoord.y);
}

void 	MotionBlur(inout vec3 color) {
	float depth = GetDepth(texcoord.st);
	vec4 currentPosition = vec4(texcoord.x * 2.0f - 1.0f, texcoord.y * 2.0f - 1.0f, 2.0f * depth - 1.0f, 1.0f);

	vec4 fragposition = gbufferProjectionInverse * currentPosition;
	fragposition = gbufferModelViewInverse * fragposition;
	fragposition /= fragposition.w;
	fragposition.xyz += cameraPosition;

	vec4 previousPosition = fragposition;
	previousPosition.xyz -= previousCameraPosition;
	previousPosition = gbufferPreviousModelView * previousPosition;
	previousPosition = gbufferPreviousProjection * previousPosition;
	previousPosition /= previousPosition.w;

	vec2 velocity = (currentPosition - previousPosition).st * 0.12f;
	float maxVelocity = 0.05f;
		 velocity = clamp(velocity, vec2(-maxVelocity), vec2(maxVelocity));


	bool isHand = GetMaterialMask(texcoord.st, 5);
	velocity *= 1.0f - float(isHand);

	int samples = 0;

	float dither = R2_dither();

	color.rgb = vec3(0.0f);

	for (int i = 0; i < 2; ++i) {
		vec2 coord = texcoord.st + velocity * (i - 0.5);
			 coord += vec2(dither) * 0.08f * velocity;

		if (coord.x > 0.0f && coord.x < 1.0f && coord.y > 0.0f || coord.y < 1.0f) {

			color += GetColorTexture(coord).rgb;
			samples += 1;

		}
	}

	color.rgb /= samples;


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
	color.rgb *= 350.0;
}

float   CalculateSunspot() {

	float curve = 1.0f;

	vec3 npos = normalize(GetWorldSpacePosition(texcoord.st).xyz);
	vec3 halfVector2 = normalize(-lightVector + npos);

	float sunProximity = 1.0f - dot(halfVector2, npos);

	return clamp(sunProximity - 0.9f, 0.0f, 0.1f) / 0.1f;

	//return sunSpot / (surface.glossiness * 50.0f + 1.0f);
	//return 0.0f;
}

/////////////////////////STRUCTS///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////STRUCTS///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



struct MaskStruct {

	float matIDs;

	bool sky;
	bool land;
	bool grass;
	bool leaves;
	bool ice;
	bool hand;
	bool translucent;
	bool glow;
	bool sunspot;
	bool goldBlock;
	bool ironBlock;
	bool diamondBlock;
	bool emeraldBlock;
	bool sand;
	bool sandstone;
	bool stone;
	bool cobblestone;
	bool wool;
	bool clouds;

	bool torch;
	bool lava;
	bool glowstone;
	bool fire;

	bool water;

	bool volumeCloud;

} mask;


/////////////////////////STRUCT FUNCTIONS//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////STRUCT FUNCTIONS//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Mask
void 	CalculateMasks(inout MaskStruct mask) {
		mask.sky 			= GetMaterialMask(texcoord.st, 0, mask.matIDs);
		mask.land	 		= GetMaterialMask(texcoord.st, 1, mask.matIDs);
		mask.grass 			= GetMaterialMask(texcoord.st, 2, mask.matIDs);
		mask.leaves	 		= GetMaterialMask(texcoord.st, 3, mask.matIDs);
		mask.ice		 	= GetMaterialMask(texcoord.st, 4, mask.matIDs);
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

		mask.water 			= GetWaterMask(texcoord.st);
}

void AverageExposure(inout vec3 color)
{
	float avglod = int(log2(min(viewWidth, viewHeight))) - 1;
	color /= pow(Luminance(textureLod(colortex2, vec2(0.5, 0.5), avglod).rgb), 1.1) + 0.0001;
}

#include "/libs/tone.frag"

Tone tone;

/////////////////////////MAIN//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////MAIN//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void main() {

	init_tone(tone, texcoord.st);

	mask.matIDs = GetMaterialIDs(texcoord.st);
	CalculateMasks(mask);

	#ifdef MOTION_BLUR
		MotionBlur(tone.color);
	#endif

	#ifdef AVERAGE_EXPOSURE
	AverageExposure(tone.color);
	#else
	CalculateExposure(tone.color);
	#endif

	Hue_Adjustment(tone);

	//tone.color = texture(colortex2, texcoord.st).rgb*50.0;
	gl_FragColor = vec4(tone.color, 1.0f);

}
