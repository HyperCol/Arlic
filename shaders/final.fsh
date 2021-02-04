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
	
	//#define DISTANCE_BLUR
	#define MaxDistanceBlurAmount 0.9 // [0.1 0.2 0.4 0.6 0.9 1.2 1.5 1.8]
	#define DistanceBlurRange 360 // [60 120 180 240 360 480 600 720 960 1200]
		
	#define EDGE_BLUR
	#define EdgeBlurAmount 1.75  // [0.5 0.75 1.0 1.25 1.5 1.75 2.0]
	#define EdgeBlurDecline 3.0  // [0.3 0.6 0.9 1.2 1.5 1.8 1.9 2.0 2.1 2.4 3.0 3.3 3.6 3.9 4.2]


//#define CUSTOM_TONED
#define CUSTOM_T_R 100 // [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255]
#define CUSTOM_T_G 100 // [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255]
#define CUSTOM_T_B 100 // [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255]
#define CUSTOM_T_L 25 // [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 ]

#define VERSION 0.5.2      //Arlic Shaders VERSION.

uniform sampler2D gcolor;
uniform sampler2D gdepth;
uniform sampler2D gdepthtex;
uniform sampler2D gnormal;
uniform sampler2D composite;
uniform sampler2D noisetex;

varying vec4 texcoord;
varying vec3 lightVector;

uniform int worldTime;

uniform float near;
uniform float far;
uniform float viewWidth;
uniform float viewHeight;
uniform float rainStrength;
uniform float screenBrightness;
uniform float wetness;
uniform float aspectRatio;
uniform float frameTimeCounter;
uniform sampler2D shadowcolor;
uniform sampler2D shadowcolor1;
uniform sampler2D shadowtex1;

uniform float centerDepthSmooth;

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferPreviousProjection;

uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferPreviousModelView;

uniform vec3 cameraPosition;
uniform vec3 previousCameraPosition;

uniform int   isEyeInWater;
uniform float eyeAltitude;
uniform ivec2 eyeBrightness;
uniform ivec2 eyeBrightnessSmooth;
uniform int   fogMode;

varying float timeSunriseSunset;
varying float timeNoon;
varying float timeMidnight;

varying vec3 colorSunlight;
varying vec3 colorSkylight;

#define BANDING_FIX_FACTOR 1.0f


const bool gnormalMipmapEnabled = true;

/////////////////////////FUNCTIONS/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////FUNCTIONS/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
vec3 	GetTexture(in sampler2D tex, in vec2 coord) {				//Perform a texture lookup with BANDING_FIX_FACTOR compensation
	return pow(texture2D(tex, coord).rgb, vec3(BANDING_FIX_FACTOR + 1.2f));
}

vec3 	GetTextureLod(in sampler2D tex, in vec2 coord, in int level) {				//Perform a texture lookup with BANDING_FIX_FACTOR compensation
	return pow(texture2DLod(tex, coord, level).rgb, vec3(BANDING_FIX_FACTOR + 1.2f));
}

vec3 	GetTexture(in sampler2D tex, in vec2 coord, in int LOD) {	//Perform a texture lookup with BANDING_FIX_FACTOR compensation and lod offset
	return pow(texture2D(tex, coord, LOD).rgb, vec3(BANDING_FIX_FACTOR));
}

float GetSunlightVisibility(in vec2 coord)
{
	return texture2D(gdepth, coord).g;
}

float 	GetDepth(in vec2 coord) {
	return texture2D(gdepthtex, coord).x;
}

float 	GetDepthLinear(in vec2 coord) {					//Function that retrieves the scene depth. 0 - 1, higher values meaning farther away
	return 2.0f * near * far / (far + near - (2.0f * texture2D(gdepthtex, coord).x - 1.0f) * (far - near));
}

vec3 	GetColorTexture(in vec2 coord) {
	#ifdef FINAL_ALT_COLOR_SOURCE
	return GetTextureLod(gcolor, coord.st, 0).rgb;
	#else
	return GetTextureLod(gnormal, coord.st, 0).rgb;
	#endif
}

float 	GetMaterialIDs(in vec2 coord) {			//Function that retrieves the texture that has all material IDs stored in it
	return texture2D(gdepth, coord).r;
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

    vec4 sample0 = texture2D(tex, vec2(offset.x, offset.z) / resolution);
    vec4 sample1 = texture2D(tex, vec2(offset.y, offset.z) / resolution);
    vec4 sample2 = texture2D(tex, vec2(offset.x, offset.w) / resolution);
    vec4 sample3 = texture2D(tex, vec2(offset.y, offset.w) / resolution);

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


void  DOF_Blur(inout vec3 color) {

	float depth= texture2D(gdepthtex, texcoord.st).x;
		//depth += float(GetMaterialMask(texcoord.st, 5)) * 0.36f;

	float naive = 0.0;

	#ifdef LOW_QUALITY_CALCULATECLOUDS
	float aaa=0;
	#ifdef NOCALCULATECLOUDSNIGHT
	float bbb=1.5 - 0.6 * timeMidnight;
	#else
	float bbb=1.5;
	#endif
	if(weather(texcoord.st)==3){
	aaa +=timeMidnight;
	bbb *=0;
	}
	#else
	float aaa=1;
	float bbb=0;
	#endif
	
#ifdef FOCUS_BLUR
	#ifdef LINK_FOCUS_TO_BRIGHTNESS_BAR
		naive += (screenBrightness - depth) * 0.4 * 0.01 * BlurAmount;
	#else
		naive += (depth - centerDepthSmooth) * 0.01 * BlurAmount;
	#endif
#endif

#ifdef DISTANCE_BLUR
#ifdef NOCALCULATECLOUDSNIGHT
	naive += clamp(1-(exp(-pow(ld(depth)/DistanceBlurRange*far,4.0-rainStrength)*3)),0.0,0.001 * (MaxDistanceBlurAmount*aaa+bbb - 0.5 * timeMidnight));
#else
naive += clamp(1-(exp(-pow(ld(depth)/DistanceBlurRange*far,4.0-rainStrength)*3)),0.0,0.001 * (MaxDistanceBlurAmount*aaa+bbb));
#endif
#endif

#ifdef EDGE_BLUR
	naive += pow(distance(texcoord.st, vec2(0.5)),EdgeBlurDecline) * 0.01 * EdgeBlurAmount;
#endif

	vec2 aspectcorrect = vec2(1.0, aspectRatio) * 1.6;
	vec3 col = vec3(0.0);
	col += GetColorTexture(texcoord.st);



#ifdef HEXAGONAL_BOKEH
const vec2 offsets[60] = vec2[60] (	vec2(  0.2165,  0.1250 ),
									vec2(  0.0000,  0.2500 ),
									vec2( -0.2165,  0.1250 ),
									vec2( -0.2165, -0.1250 ),
									vec2( -0.0000, -0.2500 ),
									vec2(  0.2165, -0.1250 ),
									vec2(  0.4330,  0.2500 ),
									vec2(  0.0000,  0.5000 ),
									vec2( -0.4330,  0.2500 ),
									vec2( -0.4330, -0.2500 ),
									vec2( -0.0000, -0.5000 ),
									vec2(  0.4330, -0.2500 ),
									vec2(  0.6495,  0.3750 ),
									vec2(  0.0000,  0.7500 ),
									vec2( -0.6495,  0.3750 ),
									vec2( -0.6495, -0.3750 ),
									vec2( -0.0000, -0.7500 ),
									vec2(  0.6495, -0.3750 ),
									vec2(  0.8660,  0.5000 ),
									vec2(  0.0000,  1.0000 ),
									vec2( -0.8660,  0.5000 ),
									vec2( -0.8660, -0.5000 ),
									vec2( -0.0000, -1.0000 ),
									vec2(  0.8660, -0.5000 ),
									vec2(  0.2163,  0.3754 ),
									vec2( -0.2170,  0.3750 ),
									vec2( -0.4333, -0.0004 ),
									vec2( -0.2163, -0.3754 ),
									vec2(  0.2170, -0.3750 ),
									vec2(  0.4333,  0.0004 ),
									vec2(  0.4328,  0.5004 ),
									vec2( -0.2170,  0.6250 ),
									vec2( -0.6498,  0.1246 ),
									vec2( -0.4328, -0.5004 ),
									vec2(  0.2170, -0.6250 ),
									vec2(  0.6498, -0.1246 ),
									vec2(  0.6493,  0.6254 ),
									vec2( -0.2170,  0.8750 ),
									vec2( -0.8663,  0.2496 ),
									vec2( -0.6493, -0.6254 ),
									vec2(  0.2170, -0.8750 ),
									vec2(  0.8663, -0.2496 ),
									vec2(  0.2160,  0.6259 ),
									vec2( -0.4340,  0.5000 ),
									vec2( -0.6500, -0.1259 ),
									vec2( -0.2160, -0.6259 ),
									vec2(  0.4340, -0.5000 ),
									vec2(  0.6500,  0.1259 ),
									vec2(  0.4325,  0.7509 ),
									vec2( -0.4340,  0.7500 ),
									vec2( -0.8665, -0.0009 ),
									vec2( -0.4325, -0.7509 ),
									vec2(  0.4340, -0.7500 ),
									vec2(  0.8665,  0.0009 ),
									vec2(  0.2158,  0.8763 ),
									vec2( -0.6510,  0.6250 ),
									vec2( -0.8668, -0.2513 ),
									vec2( -0.2158, -0.8763 ),
									vec2(  0.6510, -0.6250 ),
									vec2(  0.8668,  0.2513 ));
									#else
									const vec2 offsets[60] = vec2[60] ( vec2(  0.0000,  0.2500 ),
									vec2( -0.2165,  0.1250 ),
									vec2( -0.2165, -0.1250 ),
									vec2( -0.0000, -0.2500 ),
									vec2(  0.2165, -0.1250 ),
									vec2(  0.2165,  0.1250 ),
									vec2(  0.0000,  0.5000 ),
									vec2( -0.2500,  0.4330 ),
									vec2( -0.4330,  0.2500 ),
									vec2( -0.5000,  0.0000 ),
									vec2( -0.4330, -0.2500 ),
									vec2( -0.2500, -0.4330 ),
									vec2( -0.0000, -0.5000 ),
									vec2(  0.2500, -0.4330 ),
									vec2(  0.4330, -0.2500 ),
									vec2(  0.5000, -0.0000 ),
									vec2(  0.4330,  0.2500 ),
									vec2(  0.2500,  0.4330 ),
									vec2(  0.0000,  0.7500 ),
									vec2( -0.2565,  0.7048 ),
									vec2( -0.4821,  0.5745 ),
									vec2( -0.6495,  0.3750 ),
									vec2( -0.7386,  0.1302 ),
									vec2( -0.7386, -0.1302 ),
									vec2( -0.6495, -0.3750 ),
									vec2( -0.4821, -0.5745 ),
									vec2( -0.2565, -0.7048 ),
									vec2( -0.0000, -0.7500 ),
									vec2(  0.2565, -0.7048 ),
									vec2(  0.4821, -0.5745 ),
									vec2(  0.6495, -0.3750 ),
									vec2(  0.7386, -0.1302 ),
									vec2(  0.7386,  0.1302 ),
									vec2(  0.6495,  0.3750 ),
									vec2(  0.4821,  0.5745 ),
									vec2(  0.2565,  0.7048 ),
									vec2(  0.0000,  1.0000 ),
									vec2( -0.2588,  0.9659 ),
									vec2( -0.5000,  0.8660 ),
									vec2( -0.7071,  0.7071 ),
									vec2( -0.8660,  0.5000 ),
									vec2( -0.9659,  0.2588 ),
									vec2( -1.0000,  0.0000 ),
									vec2( -0.9659, -0.2588 ),
									vec2( -0.8660, -0.5000 ),
									vec2( -0.7071, -0.7071 ),
									vec2( -0.5000, -0.8660 ),
									vec2( -0.2588, -0.9659 ),
									vec2( -0.0000, -1.0000 ),
									vec2(  0.2588, -0.9659 ),
									vec2(  0.5000, -0.8660 ),
									vec2(  0.7071, -0.7071 ),
									vec2(  0.8660, -0.5000 ),
									vec2(  0.9659, -0.2588 ),
									vec2(  1.0000, -0.0000 ),
									vec2(  0.9659,  0.2588 ),
									vec2(  0.8660,  0.5000 ),
									vec2(  0.7071,  0.7071 ),
									vec2(  0.5000,  0.8660 ),
									vec2(  0.2588,  0.9659 ));
#endif

			
	for ( int i = 0; i < 61; ++i) {
		col.g += GetColorTexture(texcoord.st + offsets[i]*aspectcorrect*naive).g;
	    col.r += GetColorTexture(texcoord.st + (offsets[i]*aspectcorrect + vec2(FringeOffset))*naive).r;
		col.b += GetColorTexture(texcoord.st + (offsets[i]*aspectcorrect - vec2(FringeOffset))*naive).b;
		if( isEyeInWater > 0)
        col += GetColorTexture(texcoord.st + fake_refract * 0.01 + offsets[i]*aspectcorrect*naive*isEyeInWater);
		
	}
	color = col/60;
}

void 	Vignette(inout vec3 color) {
	float dist = distance(texcoord.st, vec2(0.5f)) * 2.0f;
		  dist /= 1.5142f;

		  //dist = pow(dist, 1.1f);

	color.rgb *= 1.0f - dist * 0.5;

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
	color /= pow(Luminance(texture2DLod(gnormal, vec2(0.5, 0.5), avglod).rgb), 1.1) + 0.0001;
}


/////////////////////////MAIN//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////MAIN//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void main() {

	vec3 color = GetColorTexture(texcoord.st);	//Sample color texture

	mask.matIDs = GetMaterialIDs(texcoord.st);
	CalculateMasks(mask);

#ifdef MOTION_BLUR
	MotionBlur(color);
#endif

	#ifdef DOF
		DOF_Blur(color);
	#endif

	Vignette(color);

	#ifdef AVERAGE_EXPOSURE
	AverageExposure(color);
	#else
	CalculateExposure(color);
	#endif

	
	color *= 250.0 * BRIGHTNESS_LEVEL;

	#ifdef ACES_TONEMAPPING
		{
			color.rgb *= 1./(DARKNESS * (1.5-0.5*timeNoon+0.5*timeSunriseSunset)*(1-0.65*timeMidnight));
			const float A = 2.51f;
			const float B = 0.03f;
			const float C = 2.43f;
			const float D = 0.59f;
			const float E = 0.14f;

			color = (color * (A * color + B)) / (color * (C * color + D) + E);
			color.rgb = pow(color.rgb, vec3(1.0f / 2.2f));
		}
	#else
		const float p = TONEMAP_STRENGTH;
		color = (pow(color, vec3(p)) - color) / (pow(color, vec3(p)) - 1.0);
		color = pow(color, vec3(0.95 / 2.2));
		color *= 1.01;
	#endif


	color = clamp(color, vec3(0.0), vec3(1.0));




	//if (texture2D(composite, texcoord.st).g > 0.01f)
	//	color.g = 1.0f;

	//TonemapReinhardLinearHybrid(color);
	SaturationBoost(color);

	//color.rgb += highpass * 10000.0f;
	//LowtoneSaturate(color);

	//ColorGrading(color);

	//color.rgb = texture2DLod(shadowcolor, texcoord.st, 0).rgb * 1.0f;
	//color.rgb = texture2DLod(shadowcolor1, texcoord.st, 0).aaa * 1.0f;
	//color.rgb = vec3(texture2DLod(shadowtex1, texcoord.st, 0).x) * 1.0f;

	//color.rgb = texture2D(gdepth, texcoord.st).bbb * 0.8 + 0.2;

	//color.rgb = vec3(fwidth(GetDepthLinear(texcoord.st + vec2(0.5 / viewWidth, 0.5 / viewHeight)) + GetDepthLinear(texcoord.st - vec2(0.5 / viewWidth, 0.5 / viewHeight))));

	// color.rgb += fwidth(color.rgb) * 0.5;

	#ifdef CUSTOM_TONED
		color.r = (color.r*(CUSTOM_T_R * 0.01))+(color.b+color.g)*(-0.1);
		color.g = (color.g*(CUSTOM_T_G * 0.01))+(color.r+color.b)*(-0.1);
		color.b = (color.b*(CUSTOM_T_B * 0.01))+(color.r+color.g)*(-0.1);

		color = color / (color + (5 - (CUSTOM_T_L * 0.1))) * (1.0+2.0);
    #endif	
	
	gl_FragColor = vec4(color.rgb, 1.0f);

}
