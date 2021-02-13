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

#define Enabled_TemportalAntiAliasing
#define TAA_Post_Sharpen 50		//[0 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100]

#define Vaule 0
//#define CurrentEyeLightMap 0
#define Average 1

#define Exposure_Setting Average	//[Vaule Average]
#define BRIGHTNESS_LEVEL 1.0 //[0.125 0.25 0.5 0.75 1.0 1.25 1.5 1.75 2.0]
#define SATURATION_STRENGTH 0.0 // [-1.0 -0.95 -0.9 -0.85 -0.8 -0.75 -0.7 -0.65 -0.6 -0.55 -0.5 -0.45 -0.4 -0.35 -0.3 -0.25 -0.2 -0.15 -0.1 -0.05 0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]

//#define MOTION_BLUR // It's motion blur.

//#define DARKNESS 4.25 //removed  [0.25 0.5 0.75 1.0 1.5 2.0 2.5 3.0 3.5 4.0 4.25 5.0 7.0 9.0 12.0]

#define ACES_TONEMAPPING
#define TONEMAP_STRENGTH 1.0 //[0.25 0.33 0.5 1.0 2.0 3.0 4.0]

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


//#define CUSTOM_TONED
#define CUSTOM_T_R 100 // [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255]
#define CUSTOM_T_G 100 // [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255]
#define CUSTOM_T_B 100 // [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255]
#define CUSTOM_T_L 25 // [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 ]

#define VERSION 0.9.0      //Arlic Shaders VERSION.

uniform sampler2D gcolor;
uniform sampler2D gdepth;
uniform sampler2D gdepthtex;
uniform sampler2D gaux3;
uniform sampler2D composite;

varying vec4 texcoord;
varying vec3 lightVector;

uniform float aspectRatio;

varying float timeSunriseSunset;
varying float timeNoon;
varying float timeMidnight;

varying vec3 colorSunlight;
varying vec3 colorSkylight;

#define BANDING_FIX_FACTOR 1.0f

#extension GL_ARB_shader_texture_lod: require
const bool compositeMipmapEnabled = true;
const bool gnormalMipmapEnabled = true;

#include "/lib/uniform.glsl"
#include "/lib/materials.glsl"

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
	return GetTextureLod(gaux3, coord.st, 0).rgb;
	//#endif
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

float Luminance(in vec3 color)
{
	return dot(color.rgb, vec3(0.2125f, 0.7154f, 0.0721f));
}

float ld(float depth) {
    return (near * far) / (depth * (near - far) + far);
}

float ild(float ldepth) {
	return ((near * far) / ldepth - far) / (near - far);
}

vec2 fake_refract = vec2(sin(frameTimeCounter*1.7 + texcoord.x*50.0 + texcoord.y*25.0),cos(frameTimeCounter*2.5 + texcoord.y*100.0 + texcoord.x*25.0)) * isEyeInWater;

void  DOF_Blur(out vec3 color, in float isHand) {

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
	aaa += timeMidnight;
	bbb = 0.0;
	}
	#else
	float aaa = 1.0;
	float bbb = 0.0;
	#endif
	
	#ifdef FOCUS_BLUR
		#ifdef LINK_FOCUS_TO_BRIGHTNESS_BAR
			naive += (screenBrightness - depth) * 0.4 * 0.01 * BlurAmount * (1.0 - isHand * 0.85);
		#else
			naive += (depth - centerDepthSmooth) * 0.01 * BlurAmount * (1.0 - isHand * 0.85);
		#endif
	#endif

	if (depth <= 0.99999){
	#ifdef DISTANCE_BLUR
	#ifdef NOCALCULATECLOUDSNIGHT
		naive += clamp(1-(exp(-pow(ld(depth)/DistanceBlurRange*far,4.0-rainStrength)*3)),0.0,0.001 * (MaxDistanceBlurAmount*aaa+bbb - 0.5 * timeMidnight));
	#else
	naive += clamp(1-(exp(-pow(ld(depth)/DistanceBlurRange*far,4.0-rainStrength)*3)),0.0,0.001 * (MaxDistanceBlurAmount*aaa+bbb));
	#endif
	#endif
	}

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
	}
	color = col / 60.0;
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

void 	MotionBlur(inout vec3 color, float isHand) {
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

void AverageExposure(inout vec3 color)
{
	float avglod = int(log2(min(viewWidth, viewHeight))) - 1;
	color /= pow(Luminance(texture2DLod(gaux3, vec2(0.5, 0.5), avglod).rgb), 1.1) + 0.0001;
}

vec3 InverseToneMapping(in vec3 color){
	float a = 0.000033;
	float b = 0.01;

	float lum = max(color.r, max(color.g, color.b));

	if(bool(step(lum, a))) color;

	return color/lum*((a*a-(2.0*a-b)*lum)/(b-lum));
}

void Sharpen(inout vec3 color){
	vec3 sharpen = vec3(0.0);

	for(float i = -1.0; i <= 1.0; i += 1.0){
		for(float j = -1.0; j <= 1.0; j += 1.0){
			if(i == 0.0 && j == 0.0) continue;
			sharpen += GetColorTexture(texcoord.st + vec2(i, j) * pixel);
		}
	}

	sharpen *= 0.125;

	color += (color - sharpen) * TAA_Post_Sharpen * 0.005;
	color = clamp(color, vec3(0.0), vec3(1.0));
}

#include "/lib/tone.frag"

/////////////////////////MAIN//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////MAIN//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void main() {

	Tone tone = init_tone(texcoord.st);	//Sample color texture

	//color = InverseToneMapping(color) * 0.001;

	float isHand = GetMaterialMask(texcoord.st, 5);

	#ifdef MOTION_BLUR
		MotionBlur(tone.color, isHand);
	#endif

	#ifdef DOF
		DOF_Blur(tone.color, isHand);
	#endif

	#ifdef Enabled_TemportalAntiAliasing
		#if TAA_Post_Sharpen > 0
		//	Sharpen(color);
		#endif

		//color = InverseToneMapping(color) * 0.001;
	#endif

	Hue_Adjustment(tone);
	
	gl_FragColor = vec4(tone.color, 1.0f);

}
