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
 
//#define FINAL_ALT_COLOR_SOURCE 
//#define AVERAGE_EXPOSURE // Uses the average screen brightness to calculate exposure. Disable for old exposure behavior.

#define VERSION 0.9.0      //Arlic Shaders VERSION.

uniform sampler2D gcolor;
uniform sampler2D gdepth;
uniform sampler2D gdepthtex;
uniform sampler2D gaux3;
uniform sampler2D composite;

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferPreviousModelView;
uniform mat4 gbufferPreviousProjection;

uniform vec3 previousCameraPosition;
uniform vec3 cameraPosition;

varying vec2 texcoord;
varying vec3 lightVector;

uniform float aspectRatio;
uniform float frameTimeCounter;

uniform ivec2 eyeBrightness;
uniform float centerDepthSmooth;
uniform ivec2 eyeBrightnessSmooth;

uniform float rainStrength;
uniform int isEyeInWater;

varying float timeSunriseSunset;
varying float timeNoon;
varying float timeMidnight;

varying vec3 colorSunlight;
varying vec3 colorSkylight;

#define BANDING_FIX_FACTOR 1.0f

#extension GL_ARB_shader_texture_lod: require
const bool compositeMipmapEnabled = true;
const bool gnormalMipmapEnabled = true;

//#define TAA_ToneMapping

#include "/lib/common.glsl"
//#include "/lib/uniform.glsl"
#include "/lib/materials.glsl"
#include "/lib/antialiasing/taa.glsl"

/////////////////////////FUNCTIONS/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////FUNCTIONS/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
vec3 	GetTextureLod(in sampler2D tex, in vec2 coord, in int level) {				//Perform a texture lookup with BANDING_FIX_FACTOR compensation
	return pow(texture2DLod(tex, coord, level).rgb, vec3(2.2));
}

float GetSunlightVisibility(in vec2 coord) {
	return texture2D(gdepth, coord).g;
}

float 	GetDepth(in vec2 coord) {
	return texture2D(gdepthtex, coord).x;
}

float 	GetDepthLinear(in vec2 coord) {					//Function that retrieves the scene depth. 0 - 1, higher values meaning farther away
	return 2.0f * near * far / (far + near - (2.0f * texture2D(gdepthtex, coord).x - 1.0f) * (far - near));
}

vec3 	GetColorTexture(in vec2 coord) {
	//#ifdef FINAL_ALT_COLOR_SOURCE
	//return GetTextureLod(gcolor, coord.st, 0).rgb;
	//#else
	return pow(texture2D(gaux3, coord.st).rgb, vec3(2.2));
	//#endif
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

    vec4 sample0 = texture2D(tex, vec2(offset.x, offset.z) / resolution);
    vec4 sample1 = texture2D(tex, vec2(offset.y, offset.z) / resolution);
    vec4 sample2 = texture2D(tex, vec2(offset.x, offset.w) / resolution);
    vec4 sample3 = texture2D(tex, vec2(offset.y, offset.w) / resolution);

    float sx = s.x / (s.x + s.y);
    float sy = s.z / (s.z + s.w);

    return mix( mix(sample3, sample2, sx), mix(sample1, sample0, sx), sy);
}

float Luminance(in vec3 color)
{
	return dot(color.rgb, vec3(0.2125f, 0.7154f, 0.0721f));
}

float  	CalculateDitherPattern1() {
	int[16] ditherPattern = int[16] (0 , 9 , 3 , 11,
								 	 13, 5 , 15, 7 ,
								 	 4 , 12, 2,  10,
								 	 16, 8 , 14, 6 );

	vec2 count = vec2(0.0f);
	     count.x = floor(mod(texcoord.s * resolution.x, 4.0f));
		 count.y = floor(mod(texcoord.t * resolution.y, 4.0f));

	int dither = ditherPattern[int(count.x) + int(count.y) * 4];

	return float(dither) / 17.0f;
}

float R2_dither(){
	vec2 alpha = vec2(0.75487765, 0.56984026);
	
	return fract(alpha.x * gl_FragCoord.x + alpha.y * gl_FragCoord.y);
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

void Sharpen(inout vec3 color, float shapreness){
	vec3 sharpen = vec3(0.0);

	for(float i = -1.0; i <= 1.0; i += 1.0){
		for(float j = -1.0; j <= 1.0; j += 1.0){
			if(i == 0.0 && j == 0.0) continue;
			sharpen += GetColorTexture(texcoord.st + vec2(i, j) * pixel);
		}
	}

	sharpen *= 0.125;

	color += (color - sharpen) * shapreness * 0.0025;
	color = clamp(color, vec3(0.0), vec3(1.0));
}

#include "/lib/camera/cameraEffect.frag"
#include "/lib/tone.frag"

/////////////////////////MAIN//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////MAIN//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void main() {

	Camera cam = init_camera();
	Tone tone = init_tone(texcoord.st, cam.exposure);	//Sample color texture

	float isHand = GetMaterialMask(texcoord.st, 5);

	#ifdef MOTION_BLUR
		MotionBlur(tone.color, isHand);
	#endif

	#ifdef DOF
		DOF_Blur(tone.color, cam, isHand);
	#endif

	#ifdef Enabled_TemportalAntiAliasing
		#if TAA_Post_Sharpeness > 0
			Sharpen(tone.color, TAA_Post_Sharpeness);
		#endif

		//tone.color = max(vec3(0.0), InverseToneMapping(tone.color) * 0.001 * 0.0625);
		//tone.color *= 0.001 * 0.0625;
		//tone.color = tone.color / 0.001;
		//tone.color *= 3.0;
	#endif

	tone.color *= 16000.0;
	//tone.color *= ConvertEV100ToExposure(ComputeEV100(4.0 * 4.0, 0.0045, ComputeISO(4.0, 0.0045, ComputeTargetEV(texture2D(gaux3, vec2(0.5)).a + 0.0001))));

	//tone.color *= comp

	Hue_Adjustment(tone);

	//tone.color = pow(tone.color, vec3(1.0 / 2.2));
	
	gl_FragColor = vec4(tone.color, 1.0f);

}
