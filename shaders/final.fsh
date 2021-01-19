#version 120

/////////////////////////CONFIGURABLE VARIABLES////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////CONFIGURABLE VARIABLES////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#define version 1.9 // [1.9]

#define SATURATION_BOOST 0.2f			//How saturated the final image should be. 0 is unchanged saturation. Higher values create more saturated image

#define BLOOM_EFFECTS 
#define BLOOM_STRENGTH 0.006 // How strong the bloom effect is. [0.002 0.006 0.011 0.016 0.021 0.026 0.036 0.046 0.056]

//#define LOCAL_OPERATOR					//Use local operator when tone mapping. Local operators increase image sharpness and local contrast but can cause haloing

	//#define HEXAGON_LENS

//#define LENS_FLARE

	//#define COLOR_BOOST
	
		//#define SATURATION 0.8 // [0.2 0.35 0.5 0.65 0.8 0.95 1.1 1.25 1.4 1.55 1.7 2.0 2.3 2.6 2.9 3.2 3.5]
		
		//#define DOF1						//景深1 
		//#define DOF2						//景深2 
		#define MAX_BLUR_AMOUNT 1.2 // [0.2 0.4 0.6 0.9 1.2 1.5 1.9 2.3 2.7]
		//#define NOHANDDOF
		
		//#define Cinematic_Effect1						//电影挡条1_透明
		//#define Cinematic_Effect2						//电影挡条2_不透明
		#define CINEMATICEFFECTWIDTH 0.1 // [0.05 0.075 0.1]
		
		#define DARKNESS 2.5 // [0.25 0.5 0.75 1.0 1.5 2.0 2.5 3.0 3.5 4.0 5.0 7.0 9.0 12.0]
		#define ACES_TONEMAPPING
		
		#define DOF

	#define HEXAGONAL_BOKEH
		const float FringeOffset = 0.25;

	#define FOCUS_BLUR
		//#define LINK_FOCUS_TO_BRIGHTNESS_BAR
	#define BlurAmount 4.8 // [0.4 0.8 1.6 3.2 4.8 6.4 8.0 9.6]
	
	#define DISTANCE_BLUR
	#define MaxDistanceBlurAmount 0.9 // [0.1 0.2 0.4 0.6 0.9 1.2 1.5 1.8]
	#define DistanceBlurRange 480 // [60 120 180 240 360 480 600 720 960 1200]
		
	#define EDGE_BLUR
	#define EdgeBlurAmount 1.25  // [0.5 0.75 1.0 1.25 1.5 1.75 2.0]
	#define EdgeBlurDecline 2.4  // [0.3 0.6 0.9 1.2 1.5 1.8 2.1 2.4 3.0 3.3 3.6 3.9 4.2]
		
		#define NOCALCULATECLOUDSNIGHT
		
		#define LOW_QUALITY_CALCULATECLOUDS
		
		//#define BRIGHTNESS 0.9  // [0.5 0.6 0.7 0.8 0.9 1 1.1 1.2 1.3 1.4 1.5]
		
		#define WEATHER
		
		#define RAINFOG
		
		
//color pallet from JMSEUS
//#define CUSTOM_TONED
#define CUSTOM_T_R 100 // [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255]
#define CUSTOM_T_G 100 // [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255]
#define CUSTOM_T_B 100 // [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255]
#define CUSTOM_T_L 25 // [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 ]

/////////////////////////END OF CONFIGURABLE VARIABLES/////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////END OF CONFIGURABLE VARIABLES/////////////////////////////////////////////////////////////////////////////////////////////////////////////

#include "/libs/uniform.glsl"

uniform sampler2D gcolor;
uniform sampler2D gdepth;
uniform sampler2D gdepthtex;
uniform sampler2D gnormal;
uniform sampler2D composite;
uniform sampler2D noisetex;
uniform sampler2D gaux1;
uniform sampler2D gaux2;
//uniform sampler2D depthtex0;

uniform float aspectRatio;

varying vec4 texcoord;
varying vec3 lightVector;

varying float timeSunrise;
varying float timeNoon;
varying float timeSunset;
varying float timeMidnight;

#define BANDING_FIX_FACTOR 1.0f

float pw = 1.0/ viewWidth;
float ph = 1.0/ viewHeight;


float time = worldTime;
float TimeSunrise  = ((clamp(time, 23000.0, 24000.0) - 23000.0) / 1000.0) + (1.0 - (clamp(time, 0.0, 2000.0)/2000.0));
float TimeNoon     = ((clamp(time, 0.0, 2000.0)) / 2000.0) - ((clamp(time, 10000.0, 12000.0) - 10000.0) / 2000.0);
float TimeSunset   = ((clamp(time, 10000.0, 12000.0) - 10000.0) / 2000.0) - ((clamp(time, 12000.0, 12750.0) - 12000.0) / 750.0);
float TimeMidnight = ((clamp(time, 12000.0, 12750.0) - 12000.0) / 750.0) - ((clamp(time, 23000.0, 24000.0) - 23000.0) / 1000.0);

#include "/libs/tone.frag"

/////////////////////////FUNCTIONS/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////FUNCTIONS/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
float weather(in vec2 coord) {
#ifdef WEATHER
if (worldTime>14000){
return 2+moonPhase;
}else{
return 1+moonPhase;
}
#else
return 0.0f;
#endif
}

vec3	GetTexture(in sampler2D tex, in vec2 coord) {				//Perform a texture lookup with BANDING_FIX_FACTOR compensation
	return pow(texture2D(tex, coord).rgb, vec3(BANDING_FIX_FACTOR + 1.2f));
}

vec3	GetTextureLod(in sampler2D tex, in vec2 coord, in int level) {				//Perform a texture lookup with BANDING_FIX_FACTOR compensation
	return pow(texture2DLod(tex, coord, level).rgb, vec3(BANDING_FIX_FACTOR + 1.2f));
}

vec3	GetTexture(in sampler2D tex, in vec2 coord, in int LOD) {	//Perform a texture lookup with BANDING_FIX_FACTOR compensation and lod offset
	return pow(texture2D(tex, coord, LOD).rgb, vec3(BANDING_FIX_FACTOR));
}

float	GetDepth(in vec2 coord) {
	return texture2D(gdepthtex, coord).x;
}

float	GetDepthLinear(in vec2 coord) {					//Function that retrieves the scene depth. 0 - 1, higher values meaning farther away
	return 2.0f * near * far / (far + near - (2.0f * texture2D(gdepthtex, coord).x - 1.0f) * (far - near));
}

vec3	GetColorTexture(in vec2 coord) {
	return GetTextureLod(gnormal, coord.st, 0).rgb;
}

float	GetMaterialIDs(in vec2 coord) {			//Function that retrieves the texture that has all material IDs stored in it
	return texture2D(gdepth, coord).r;
}

vec4	GetWorldSpacePosition(in vec2 coord) {	//Function that calculates the screen-space position of the objects in the scene using the depth texture and the texture coordinates of the full-screen quad
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
	w.x =	-x3 + 3*x2 - 3*x + 1;
	w.y =  3*x3 - 6*x2		 + 4;
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

bool	GetMaterialMask(in vec2 coord, in int ID) {
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

bool	GetWaterMask(in vec2 coord) {					//Function that returns "true" if a pixel is water, and "false" if a pixel is not water.
	float matID = floor(GetMaterialIDs(coord) * 255.0f);

	if (matID >= 35.0f && matID <= 51) {
		return true;
	} else {
		return false;
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

void  DOF_Blur(inout vec3 color) {

	float depth= texture2D(gdepthtex, texcoord.st).x;
		depth += float(GetMaterialMask(texcoord.st, 5)) * 0.36f;

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
		naive += (depth - screenBrightness) * 0.01 * BlurAmount;
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

void 	DepthOfField1(inout vec3 color)
{

	float cursorDepth = centerDepthSmooth;

	bool isHand = GetMaterialMask(texcoord.st, 5);
	
	#ifdef NOHANDDOF
	if(isHand){
		color = GetColorTexture(texcoord.st);
		return;
	}
	#endif
	
	const float blurclamp = 0.014;  // MAX_BLUR_AMOUNT
	const float bias = 0.15;	//aperture - bigger values for shallower depth of field
	
	
	vec2 aspectcorrect = vec2(1.0, aspectRatio) * 1.5;

	float depth = texture2D(gdepthtex, texcoord.st).x;
		  depth += float(isHand) * 0.36f;

	float factor = (depth - cursorDepth);
	 
	vec2 dofblur = vec2(factor * bias)*MAX_BLUR_AMOUNT;

	
	

	vec3 col = vec3(0.0);
	col += GetColorTexture(texcoord.st);
	
	col += GetColorTexture(texcoord.st + (vec2( 0.0,0.4 )*aspectcorrect) * dofblur);
	col += GetColorTexture(texcoord.st + (vec2( 0.15,0.37 )*aspectcorrect) * dofblur);
	col += GetColorTexture(texcoord.st + (vec2( 0.29,0.29 )*aspectcorrect) * dofblur);
	col += GetColorTexture(texcoord.st + (vec2( -0.37,0.15 )*aspectcorrect) * dofblur);	
	col += GetColorTexture(texcoord.st + (vec2( 0.4,0.0 )*aspectcorrect) * dofblur);	
	col += GetColorTexture(texcoord.st + (vec2( 0.37,-0.15 )*aspectcorrect) * dofblur);	
	col += GetColorTexture(texcoord.st + (vec2( 0.29,-0.29 )*aspectcorrect) * dofblur);	
	col += GetColorTexture(texcoord.st + (vec2( -0.15,-0.37 )*aspectcorrect) * dofblur);
	col += GetColorTexture(texcoord.st + (vec2( 0.0,-0.4 )*aspectcorrect) * dofblur);	
	col += GetColorTexture(texcoord.st + (vec2( -0.15,0.37 )*aspectcorrect) * dofblur);
	col += GetColorTexture(texcoord.st + (vec2( -0.29,0.29 )*aspectcorrect) * dofblur);
	col += GetColorTexture(texcoord.st + (vec2( 0.37,0.15 )*aspectcorrect) * dofblur);	
	col += GetColorTexture(texcoord.st + (vec2( -0.4,0.0 )*aspectcorrect) * dofblur);	
	col += GetColorTexture(texcoord.st + (vec2( -0.37,-0.15 )*aspectcorrect) * dofblur);	
	col += GetColorTexture(texcoord.st + (vec2( -0.29,-0.29 )*aspectcorrect) * dofblur);	
	col += GetColorTexture(texcoord.st + (vec2( 0.15,-0.37 )*aspectcorrect) * dofblur);
	
	col += GetColorTexture(texcoord.st + (vec2( 0.15,0.37 )*aspectcorrect) * dofblur*0.9);
	col += GetColorTexture(texcoord.st + (vec2( -0.37,0.15 )*aspectcorrect) * dofblur*0.9);		
	col += GetColorTexture(texcoord.st + (vec2( 0.37,-0.15 )*aspectcorrect) * dofblur*0.9);		
	col += GetColorTexture(texcoord.st + (vec2( -0.15,-0.37 )*aspectcorrect) * dofblur*0.9);
	col += GetColorTexture(texcoord.st + (vec2( -0.15,0.37 )*aspectcorrect) * dofblur*0.9);
	col += GetColorTexture(texcoord.st + (vec2( 0.37,0.15 )*aspectcorrect) * dofblur*0.9);		
	col += GetColorTexture(texcoord.st + (vec2( -0.37,-0.15 )*aspectcorrect) * dofblur*0.9);	
	col += GetColorTexture(texcoord.st + (vec2( 0.15,-0.37 )*aspectcorrect) * dofblur*0.9);	
	
	col += GetColorTexture(texcoord.st + (vec2( 0.29,0.29 )*aspectcorrect) * dofblur*0.7);
	col += GetColorTexture(texcoord.st + (vec2( 0.4,0.0 )*aspectcorrect) * dofblur*0.7);	
	col += GetColorTexture(texcoord.st + (vec2( 0.29,-0.29 )*aspectcorrect) * dofblur*0.7);	
	col += GetColorTexture(texcoord.st + (vec2( 0.0,-0.4 )*aspectcorrect) * dofblur*0.7);	
	col += GetColorTexture(texcoord.st + (vec2( -0.29,0.29 )*aspectcorrect) * dofblur*0.7);
	col += GetColorTexture(texcoord.st + (vec2( -0.4,0.0 )*aspectcorrect) * dofblur*0.7);	
	col += GetColorTexture(texcoord.st + (vec2( -0.29,-0.29 )*aspectcorrect) * dofblur*0.7);	
	col += GetColorTexture(texcoord.st + (vec2( 0.0,0.4 )*aspectcorrect) * dofblur*0.7);
			
	col += GetColorTexture(texcoord.st + (vec2( 0.29,0.29 )*aspectcorrect) * dofblur*0.4);
	col += GetColorTexture(texcoord.st + (vec2( 0.4,0.0 )*aspectcorrect) * dofblur*0.4);	
	col += GetColorTexture(texcoord.st + (vec2( 0.29,-0.29 )*aspectcorrect) * dofblur*0.4);	
	col += GetColorTexture(texcoord.st + (vec2( 0.0,-0.4 )*aspectcorrect) * dofblur*0.4);	
	col += GetColorTexture(texcoord.st + (vec2( -0.29,0.29 )*aspectcorrect) * dofblur*0.4);
	col += GetColorTexture(texcoord.st + (vec2( -0.4,0.0 )*aspectcorrect) * dofblur*0.4);	
	col += GetColorTexture(texcoord.st + (vec2( -0.29,-0.29 )*aspectcorrect) * dofblur*0.4);	
	col += GetColorTexture(texcoord.st + (vec2( 0.0,0.4 )*aspectcorrect) * dofblur*0.4);	

	color = col/41;
	
}

void 	DepthOfField2(inout vec3 color)
{

	float cursorDepth = centerDepthSmooth;

	bool isHand = GetMaterialMask(texcoord.st, 5);
	
	#ifdef NOHANDDOF
	if(isHand){
		color = GetColorTexture(texcoord.st);
		return;
	}
	#endif
	
	const float blurclamp = 0.015;  // MAX_BLUR_AMOUNT
	const float bias = 0.125;	//aperture - bigger values for shallower depth of field
	
	
	vec2 aspectcorrect = vec2(1.0, aspectRatio) * 1.5;

	float depth = texture2D(gdepthtex, texcoord.st).x;
		  depth += float(isHand) * 0.36f;

	float factor = (depth - cursorDepth);
	 
	vec2 dofblur = vec2(factor * bias)*MAX_BLUR_AMOUNT;

	vec3 col = vec3(0.0);
	col += GetColorTexture(texcoord.st);
	

	
	
    col += GetColorTexture(texcoord.st + (vec2(  0.2165,  0.1250 )*aspectcorrect) * dofblur);
	col += GetColorTexture(texcoord.st + (vec2(  0.0000,  0.2500 )*aspectcorrect) * dofblur);
	col += GetColorTexture(texcoord.st + (vec2( -0.2165,  0.1250 )*aspectcorrect) * dofblur);
	col += GetColorTexture(texcoord.st + (vec2( -0.2165, -0.1250 )*aspectcorrect) * dofblur);	
	col += GetColorTexture(texcoord.st + (vec2( -0.0000, -0.2500 )*aspectcorrect) * dofblur);	
	col += GetColorTexture(texcoord.st + (vec2(  0.2165, -0.1250 )*aspectcorrect) * dofblur);	
	col += GetColorTexture(texcoord.st + (vec2(  0.4330,  0.2500 )*aspectcorrect) * dofblur);	
	col += GetColorTexture(texcoord.st + (vec2(  0.0000,  0.5000 )*aspectcorrect) * dofblur);
	col += GetColorTexture(texcoord.st + (vec2( -0.4330,  0.2500 )*aspectcorrect) * dofblur);	
	col += GetColorTexture(texcoord.st + (vec2( -0.4330, -0.2500 )*aspectcorrect) * dofblur);
	col += GetColorTexture(texcoord.st + (vec2( -0.0000, -0.5000 )*aspectcorrect) * dofblur);
	col += GetColorTexture(texcoord.st + (vec2(  0.4330, -0.2500 )*aspectcorrect) * dofblur);	
	col += GetColorTexture(texcoord.st + (vec2(  0.6495,  0.3750 )*aspectcorrect) * dofblur);	
	col += GetColorTexture(texcoord.st + (vec2(  0.0000,  0.7500 )*aspectcorrect) * dofblur);	
	col += GetColorTexture(texcoord.st + (vec2( -0.6495,  0.3750 )*aspectcorrect) * dofblur);	
	col += GetColorTexture(texcoord.st + (vec2( -0.6495, -0.3750 )*aspectcorrect) * dofblur);
	
	col += GetColorTexture(texcoord.st + (vec2( 0.15,0.37 )*aspectcorrect) * dofblur);
	col += GetColorTexture(texcoord.st + (vec2( -0.37,0.15 )*aspectcorrect) * dofblur);		
	col += GetColorTexture(texcoord.st + (vec2( 0.37,-0.15 )*aspectcorrect) * dofblur);		
	col += GetColorTexture(texcoord.st + (vec2( -0.15,-0.37 )*aspectcorrect) * dofblur);
	col += GetColorTexture(texcoord.st + (vec2( -0.15,0.37 )*aspectcorrect) * dofblur);
	col += GetColorTexture(texcoord.st + (vec2( 0.37,0.15 )*aspectcorrect) * dofblur);		
	col += GetColorTexture(texcoord.st + (vec2( -0.37,-0.15 )*aspectcorrect) * dofblur);	
	col += GetColorTexture(texcoord.st + (vec2( 0.15,-0.37 )*aspectcorrect) * dofblur);	
	
	col += GetColorTexture(texcoord.st + (vec2( 0.29,0.29 )*aspectcorrect) * dofblur);
	col += GetColorTexture(texcoord.st + (vec2( 0.4,0.0 )*aspectcorrect) * dofblur);	
	col += GetColorTexture(texcoord.st + (vec2( 0.29,-0.29 )*aspectcorrect) * dofblur);	
	col += GetColorTexture(texcoord.st + (vec2( 0.0,-0.4 )*aspectcorrect) * dofblur);	
	col += GetColorTexture(texcoord.st + (vec2( -0.29,0.29 )*aspectcorrect) * dofblur);
	col += GetColorTexture(texcoord.st + (vec2( -0.4,0.0 )*aspectcorrect) * dofblur);	
	col += GetColorTexture(texcoord.st + (vec2( -0.29,-0.29 )*aspectcorrect) * dofblur);	
	col += GetColorTexture(texcoord.st + (vec2( 0.0,0.4 )*aspectcorrect) * dofblur);
			
	col += GetColorTexture(texcoord.st + (vec2(  0.2170, -0.8750 )*aspectcorrect) * dofblur);
	col += GetColorTexture(texcoord.st + (vec2(  0.8663, -0.2496 )*aspectcorrect) * dofblur);
	col += GetColorTexture(texcoord.st + (vec2(  0.8663, -0.2496 )*aspectcorrect) * dofblur);
	col += GetColorTexture(texcoord.st + (vec2( -0.4340,  0.5000 )*aspectcorrect) * dofblur);	
	col += GetColorTexture(texcoord.st + (vec2( -0.6500, -0.1259 )*aspectcorrect) * dofblur);	
	col += GetColorTexture(texcoord.st + (vec2( -0.2160, -0.6259 )*aspectcorrect) * dofblur);
	col += GetColorTexture(texcoord.st + (vec2( -0.4,0.0 )*aspectcorrect) * dofblur);	
	col += GetColorTexture(texcoord.st + (vec2( -0.29,-0.29 )*aspectcorrect) * dofblur);	
	col += GetColorTexture(texcoord.st + (vec2( 0.0,0.4 )*aspectcorrect) * dofblur);	
	
	


	color = col/41;	
}

void	Vignette(inout vec3 color) {
	float dist = distance(texcoord.st, vec2(0.5f)) * 2.0f;
		  dist /= 1.5142f;

		  dist = pow(dist, 1.1f);

	color.rgb *= 1.0f - dist;

}

void CinematicEffect(inout vec3 color) {


if (texcoord.t > 1.0 - CINEMATICEFFECTWIDTH) {
color.rgb *= 0.0;
}


if (texcoord.t > 0.0 && texcoord.t < CINEMATICEFFECTWIDTH) {
color.rgb *= 0.0;
}


}

float CalculateDitherPattern1() {
	int[16] ditherPattern = int[16] (0 , 9 , 3 , 11,
									 13, 5 , 15, 7 ,
									 4 , 12, 2,	 10,
									 16, 8 , 14, 6 );

	vec2 count = vec2(0.0f);
		 count.x = floor(mod(texcoord.s * viewWidth, 4.0f));
		 count.y = floor(mod(texcoord.t * viewHeight, 4.0f));

	int dither = ditherPattern[int(count.x) + int(count.y) * 4];

	return float(dither) / 17.0f;
}


void TonemapVorontsov(inout vec3 color) {
	//color = pow(color, vec3(2.2f));			//Put gcolor back into linear space
	color.rgb *= 75000.0f;

	//Natural
	//Properties
		// float tonemapContrast		= 0.95f;
		// float tonemapSaturation	= 1.2f + SATURATION_BOOST;
		// float tonemapDecay			= 210.0f;
		// float tonemapCurve			= 100.0f;

	//Filmic
		float tonemapContrast		= 0.79f;
		float tonemapSaturation		= 0.85f;
		float tonemapDecay			= 121000.0f;
		float tonemapCurve			= 1.0f;

	color.rgb += 0.001f;

	vec3 colorN = normalize(color.rgb);

	vec3 clrfr = color.rgb/colorN.rgb;
		 clrfr = pow(clrfr.rgb, vec3(tonemapContrast));

	colorN.rgb = pow(colorN.rgb, vec3(tonemapSaturation));

	color.rgb = clrfr.rgb * colorN.rgb;

	color.rgb = (color.rgb * (1.0 + color.rgb/tonemapDecay))/(color.rgb + tonemapCurve);

	color.rgb = pow(color.rgb, vec3(1.0f / 2.2f));

	color.rgb *= 1.125f;

	color.rgb -= 0.025f;
}

void TonemapReinhard(inout vec3 color) {
	//color.rgb = pow(color.rgb, vec3(2.2f));			//Put color into linear space

	color.rgb *= 100000.0f;
	color.rgb = color.rgb / (1.0f + color.rgb);

	color.rgb = pow(color.rgb, vec3(1.0f / 2.2f)); //Put color into gamma space for correct display
	color.rgb *= 1.0f;
}


void TonemapReinhardLum(inout vec3 color) {
	//color.rgb = pow(color.rgb, vec3(2.2f));			//Put color into linear space

	color.rgb *= 100000.0f;

	float lum = dot(color.rgb, vec3(0.2125f, 0.7154f, 0.0721f));

	float white = 21.0f;
	float lumTonemap = (lum * (1.0f + (lum / white))) / (1.0f + lum);


	float factor = lumTonemap / lum;

	color.rgb *= factor;

	//color.rgb = color.rgb / (color.rgb + 1.0f);

	color.rgb = pow(color.rgb, vec3(1.0f / 2.2f)); //Put color into gamma space for correct display
	color.rgb *= 1.1f;
}


void SaturationBoost(inout vec3 color) {
	float satBoost = 0.07f;

	color.r = color.r * (1.0f + satBoost * 2.0f) - (color.g * satBoost) - (color.b * satBoost);
	color.g = color.g * (1.0f + satBoost * 2.0f) - (color.r * satBoost) - (color.b * satBoost);
	color.b = color.b * (1.0f + satBoost * 2.0f) - (color.r * satBoost) - (color.g * satBoost);
}

void TonemapReinhardLinearHybrid(inout vec3 color) {

	color.rgb *= 25000.0f;
	color.rgb = color.rgb / (1.0f + color.rgb);

	color.rgb = pow(color.rgb, vec3(1.0f / 2.2f)); //Put color into gamma space for correct display
	color.rgb *= 1.21f;
}

void SphericalTonemap(inout vec3 color)
{

	color.rgb = clamp(color.rgb, vec3(0.0f), vec3(1.0f));

	vec3 signedColor = color.rgb * 2.0f - 1.0f;

	vec3 sphericalColor = sqrt(1.0f - signedColor.rgb * signedColor.rgb);
		 sphericalColor = sphericalColor * 0.5f + 0.5f;
		 sphericalColor *= color.rgb;

	float sphericalAmount = 0.3f;

	color.rgb += sphericalColor.rgb * sphericalAmount;
	color.rgb *= 0.95f;
}

void LowtoneSaturate(inout vec3 color)
{
	color.rgb *= 1.125f;
	color.rgb -= 0.125f;
	color.rgb = clamp(color.rgb, vec3(0.0f), vec3(1.0f));
}

void ColorGrading(inout vec3 color)
{
	vec3 c = color.rgb;
		 c.r = 0.8f;
		 c.g = 0.8f;
		 c.b = 0.8f;
}

float	CalculateSunspot() {

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

struct BloomDataStruct
{
	vec3 blur0;
	vec3 blur1;
	vec3 blur2;
	vec3 blur3;
	vec3 blur4;
	vec3 blur5;
	vec3 blur6;

	vec3 bloom;
} bloomData;





/////////////////////////STRUCT FUNCTIONS//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////STRUCT FUNCTIONS//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void	CalculateBloom(inout BloomDataStruct bloomData) {		//Retrieve previously calculated bloom textures

	//constants for bloom bloomSlant
	const float	   bloomSlant = 0.25f;
	const float[7] bloomWeight = float[7] (pow(7.0f, bloomSlant),
										   pow(6.0f, bloomSlant),
										   pow(5.0f, bloomSlant),
										   pow(4.0f, bloomSlant),
										   pow(3.0f, bloomSlant),
										   pow(2.0f, bloomSlant),
										   1.0f
										   );

	vec2 recipres = vec2(1.0f / viewWidth, 1.0f / viewHeight);

	bloomData.blur0	 =	pow(texture2D(gcolor, (texcoord.st - recipres * 0.5f) * (1.0f / pow(2.0f,	2.0f	)) +	vec2(0.0f, 0.0f)		+ vec2(0.000f, 0.000f)	).rgb, vec3(1.0f + 1.2f));
	bloomData.blur1	 =	pow(texture2D(gcolor, (texcoord.st - recipres * 0.5f) * (1.0f / pow(2.0f,	3.0f	)) +	vec2(0.0f, 0.25f)		+ vec2(0.000f, 0.025f)	).rgb, vec3(1.0f + 1.2f));
	bloomData.blur2	 =	pow(texture2D(gcolor, (texcoord.st - recipres * 0.5f) * (1.0f / pow(2.0f,	4.0f	)) +	vec2(0.125f, 0.25f)		+ vec2(0.025f, 0.025f)	).rgb, vec3(1.0f + 1.2f));
	bloomData.blur3	 =	pow(texture2D(gcolor, (texcoord.st - recipres * 0.5f) * (1.0f / pow(2.0f,	5.0f	)) +	vec2(0.1875f, 0.25f)	+ vec2(0.050f, 0.025f)	).rgb, vec3(1.0f + 1.2f));
	bloomData.blur4	 =	pow(texture2D(gcolor, (texcoord.st - recipres * 0.5f) * (1.0f / pow(2.0f,	6.0f	)) +	vec2(0.21875f, 0.25f)	+ vec2(0.075f, 0.025f)	).rgb, vec3(1.0f + 1.2f));
	bloomData.blur5	 =	pow(texture2D(gcolor, (texcoord.st - recipres * 0.5f) * (1.0f / pow(2.0f,	7.0f	)) +	vec2(0.25f, 0.25f)		+ vec2(0.100f, 0.025f)	).rgb, vec3(1.0f + 1.2f));
	bloomData.blur6	 =	pow(texture2D(gcolor, (texcoord.st - recipres * 0.5f) * (1.0f / pow(2.0f,	8.0f	)) +	vec2(0.28f, 0.25f)		+ vec2(0.125f, 0.025f)	).rgb, vec3(1.0f + 1.2f));

	bloomData.bloom	 = bloomData.blur0 * bloomWeight[0];
	bloomData.bloom += bloomData.blur1 * bloomWeight[1];
	bloomData.bloom += bloomData.blur2 * bloomWeight[2];
	bloomData.bloom += bloomData.blur3 * bloomWeight[3];
	bloomData.bloom += bloomData.blur4 * bloomWeight[4];
	bloomData.bloom += bloomData.blur5 * bloomWeight[5];
	bloomData.bloom += bloomData.blur6 * bloomWeight[6];

}


void TonemapReinhard07(inout vec3 color, in BloomDataStruct bloomData)
{
	//Per-channel
	// vec3 n = vec3(0.9f);
	// vec3 g = vec3(0.00001f);
	// color.rgb = pow(color.rgb, n) / (pow(color.rgb, n) + pow(g, n));

	//Luminance
	float n = 0.6f;
	float lum = dot(color.rgb, vec3(0.2125f, 0.7154f, 0.0721f));
	float g = 0.000019f + lum * 0.0f;
	float white = 0.1f;
	float compressed = pow((lum * (1.0f + (lum / white))), n) / (pow(lum, n) + pow(g, n));

	float s = clamp(1.0f - compressed * 0.65f, 0.0f, 1.0f) * 0.65f;
	color.r = pow((color.r / lum), s) * (compressed);
	color.g = pow((color.g / lum), s) * (compressed);
	color.b = pow((color.b / lum), s) * (compressed);




	//color.rgb *= 30000.0f;



	color.rgb = pow(color.rgb, vec3(1.0f / 2.2f));
	color.rgb = max(vec3(0.0f), color.rgb * 1.15f - 0.15f);
	color.rgb *= 1.1f;
}


void	AddRainFogScatter(inout vec3 color, in BloomDataStruct bloomData)
{
	const float	   bloomSlant = 0.0f;
	const float[7] bloomWeight = float[7] (pow(7.0f, bloomSlant),
										   pow(6.0f, bloomSlant),
										   pow(5.0f, bloomSlant),
										   pow(4.0f, bloomSlant),
										   pow(3.0f, bloomSlant),
										   pow(2.0f, bloomSlant),
										   1.0f
										   );

	vec3 fogBlur = bloomData.blur0 * bloomWeight[6] +
				   bloomData.blur1 * bloomWeight[5] +
				   bloomData.blur2 * bloomWeight[4] +
				   bloomData.blur3 * bloomWeight[3] +
				   bloomData.blur4 * bloomWeight[2] +
				   bloomData.blur5 * bloomWeight[1] +
				   bloomData.blur6 * bloomWeight[0];

	float fogTotalWeight =	1.0f * bloomWeight[0] +
							1.0f * bloomWeight[1] +
							1.0f * bloomWeight[2] +
							1.0f * bloomWeight[3] +
							1.0f * bloomWeight[4] +
							1.0f * bloomWeight[5] +
							1.0f * bloomWeight[6];

	fogBlur /= fogTotalWeight;

	float linearDepth = GetDepthLinear(texcoord.st);

	float fogDensity = 0.03f * (rainStrength);
		  //fogDensity += texture2D(composite, texcoord.st).g * 0.1f;
	float visibility = 1.0f / (pow(exp(linearDepth * fogDensity), 1.0f));
	float fogFactor = 1.0f - visibility;
		  fogFactor = clamp(fogFactor, 0.0f, 1.0f);
		  fogFactor *= mix(0.0f, 1.0f, pow(eyeBrightnessSmooth.y / 240.0f, 6.0f));

	// bool waterMask = GetWaterMask(texcoord.st);
	// fogFactor = mix(fogFactor, 0.0f, float(waterMask));

	color = mix(color, fogBlur, fogFactor * 1.0f);
}


void TonemapReinhard05(inout vec3 color, BloomDataStruct bloomData)
{

	//color.b *= 0.85f;

	float averageLuminance = 0.00003f * DARKNESS * (1.5-0.5*timeNoon+0.5*timeSunrise+timeSunset)*(1-0.4*timeMidnight);
	float contrast = 0.9f;
	float adaptation = 0.75f;

	float lum = Luminance(color.rgb);
	vec3 blur = bloomData.blur1;
		 blur += bloomData.blur2;

	// float[7] gaussLums = float[7] (	lum,
	//								Luminance(bloomData.blur0),
	//								Luminance(bloomData.blur1),
	//								Luminance(bloomData.blur2),
	//								Luminance(bloomData.blur3),
	//								Luminance(bloomData.blur4),
	//								Luminance(bloomData.blur5));

	// float sMax = gaussLums[3];
	// float e = 0.51f;

	// for (int i = 3; i > 0; i -= 1)
	// {
	//	float dog = gaussLums[i] - gaussLums[i - 1];
	//		  dog /= (gaussLums[i - 1] + 0.000000000000000001f);

	//	if (abs(dog) > e)
	//		//sMax = mix(sMax, gaussLums[i - 1], clamp(abs(dog) / e, 0.0f, 1.0f));
	//		//sMax = abs(dog);
	//		sMax = gaussLums[i - 1];
	// }

	#ifdef LOCAL_OPERATOR
	vec3 ILocal = vec3(Luminance(blur));
		 ILocal -= pow(Luminance(bloomData.blur2), 4.1f) * 100000000000.0f;
		 ILocal = max(vec3(0.000000000001f), ILocal);

		 //ILocal = vec3(sMax * 2.25f);
	#endif



	#ifdef LOCAL_OPERATOR
	vec3 IGlobal = vec3(averageLuminance);
	vec3 IAverage = mix(ILocal, IGlobal, vec3(adaptation));
	#else
	vec3 IAverage = vec3(averageLuminance);
	#endif

	vec3 value = pow(color.rgb, vec3(contrast)) / (pow(color.rgb, vec3(contrast)) + pow(IAverage, vec3(contrast)));




	
	color.rgb = value * 1.2f;


	color.rgb = pow(color.rgb, vec3(1.0f / 2.2f));
	//color.rgb -= vec3(0.025f);
}

void aTonemapReinhard05(inout vec3 color, BloomDataStruct bloomData)
{
color.rgb *= 40000.0f/(DARKNESS * (1.5-0.5*timeNoon+0.5*timeSunrise+timeSunset)*(1-0.4*timeMidnight));
const float A = 2.51f;
const float B = 0.03f;
const float C = 2.43f;
const float D = 0.59f;
const float E = 0.14f;

color = (color * (A * color + B)) / (color * (C * color + D) + E);
color.rgb = pow(color.rgb, vec3(1.0f / 2.2f));
}

void LowlightFuzziness(inout vec3 color, in BloomDataStruct bloomData)
{
	float lum = Luminance(color.rgb);
	float factor = 1.0f - clamp(lum * 50000000.0f, 0.0f, 1.0f);
		  //factor *= factor * factor;


	float time = frameTimeCounter * 4.0f;
	vec2 coord = texture2D(noisetex, vec2(time, time / 64.0f)).xy;
	vec3 snow = BicubicTexture(noisetex, (texcoord.st + coord) / (512.0f / vec2(viewWidth, viewHeight))).rgb;	//visual snow
	vec3 snow2 = BicubicTexture(noisetex, (texcoord.st + coord) / (128.0f / vec2(viewWidth, viewHeight))).rgb;	//visual snow

	vec3 rodColor = vec3(0.2f, 0.4f, 1.0f) * 2.5;
	vec3 rodLight = dot(color.rgb + snow.r * 0.0000000005f, vec3(0.0f, 0.6f, 0.4f)) * rodColor;
	color.rgb = mix(color.rgb, rodLight, vec3(factor)); //visual acuity loss

	color.rgb += snow.rgb * snow2.rgb * snow.rgb * 0.000000002f;
}

//Lens Effects
float distratio(vec2 pos, vec2 pos2, float ratio) {
	float xvect = pos.x*ratio-pos2.x*ratio;
	float yvect = pos.y-pos2.y;
	return sqrt(xvect*xvect + yvect*yvect);
}

float yDistAxis (in float degrees) {

	vec4 tpos = vec4(sunPosition,1.0)*gbufferProjection;
		 tpos = vec4(tpos.xyz/tpos.w,1.0);
	vec2 lightPos = tpos.xy/tpos.z;
		 lightPos = (lightPos + 1.0f)/2.0f;

	return abs((lightPos.y-lightPos.x*(degrees))-(texcoord.y-texcoord.x*(degrees)));

}

float smoothCircleDist (in float lensDist) {

	vec4 tpos = vec4(sunPosition,1.0)*gbufferProjection;
		 tpos = vec4(tpos.xyz/tpos.w,1.0);
	vec2 lightPos = tpos.xy/tpos.z*lensDist;
		 lightPos = (lightPos + 1.0f)/2.0f;

	return distratio(lightPos.xy, texcoord.xy, aspectRatio);

}

float cirlceDist (float lensDist, float size) {

	vec4 tpos = vec4(sunPosition,1.0)*gbufferProjection;
		 tpos = vec4(tpos.xyz/tpos.w,1.0);
	vec2 lightPos = tpos.xy/tpos.z*lensDist;
		 lightPos = (lightPos + 1.0f)/2.0f;

	return pow(min(distratio(lightPos.xy, texcoord.xy, aspectRatio),size)/size,10.0);
}

vec2 texel = vec2(1.0/viewWidth,1.0/viewHeight);

float hex(float lensDist, float size)
{
	#define deg2rad 3.14159 / 180.
	vec4 tpos = vec4(sunPosition,1.0)*gbufferProjection;
		 tpos = vec4(tpos.xyz/tpos.w,1.0);
	vec2 lightPos = tpos.xy/tpos.z*lensDist;
		 lightPos = (lightPos + 1.0f)/2.0f;
	vec2 uv = texcoord.xy;

	size *= (viewHeight + viewWidth) / 1920.0;

	float r = 0.0;

	vec2 v = (lightPos / texel) - (uv / texel);
	vec2 topBottomEdge = vec2(0., 1.);
	vec2 leftEdges = vec2(cos(30.*deg2rad), sin(30.*deg2rad));
	vec2 rightEdges = vec2(cos(30.*deg2rad), sin(30.*deg2rad));

	float dot1 = dot(abs(v), topBottomEdge);
	float dot2 = dot(abs(v), leftEdges);
	float dot3 = dot(abs(v), rightEdges);
	float dotMax = max(max((dot1), (dot2)), (dot3));

	return max(0.0, mix(0.0, mix(1.0, 1.0, floor(size - dotMax*1.1 + 0.99 )), floor(size - dotMax + 0.99 ))) * 0.1;
}


float hash( float n ) {
	return fract(sin(n)*43758.5453);
}

float noise( in vec2 x ) {
	vec2 p = floor(x);
	vec2 f = fract(x);
	f = f*f*(3.0-2.0*f);
	float n = p.x + p.y*57.0;
	float res = mix(mix( hash(n+  0.0), hash(n+ 1.0),f.x), mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y);
	return res;
}

float fbm( vec2 p ) {
	float f = 0.0;
	f += 0.50000*noise( p ); p = p*2.02;
	f += 0.25000*noise( p ); p = p*2.03;
	f += 0.12500*noise( p ); p = p*2.01;
	f += 0.06250*noise( p ); p = p*2.04;
	f += 0.03125*noise( p );

	return f/0.984375;
}

void LensEffects(inout vec3 color)
{
	vec3 sunPos = sunPosition;
	vec4 tpos = vec4(sunPosition,1.0)*gbufferProjection;
	tpos = vec4(tpos.xyz/tpos.w,1.0);

	vec2 lightPos = tpos.xy/tpos.z;
	lightPos = (lightPos + 1.0f)/2.0f;

	float distof = min(min(1.0-lightPos.x,lightPos.x),min(1.0-lightPos.y,lightPos.y));
	float fading = clamp(1.0-step(distof,0.1)+pow(distof*10.0,5.0),0.0,1.0);
	float flare_power = 0.5;

	float time = float(worldTime);
	float transition_fading = 1.0-(clamp((time-12000.0)/500.0,0.0,1.0)-clamp((time-13000.0)/500.0,0.0,1.0)+clamp((time-22500.0)/100.0,0.0,1.0)-clamp((time-23300.0)/200.0,0.0,1.0));

	float sunvisibility = min(float(texture2D(gdepth, lightPos).r == 0), 1.0) * fading * transition_fading * flare_power;
	float sunvisibility2 = min(float(texture2D(gdepth, lightPos).r == 0), 1.0) * transition_fading * flare_power;
	float sunvisibility3 = min(texture2D(gaux2,vec2(0.0)).a*2.5,1.0) * fading * transition_fading;
	float sunvisibility4 = texture2D(gaux2,vec2(pw,ph)).a*(1-rainStrength*0.9);

	float lensBrightness = 0.0;
	float lensExpDT = 1.0;
	lensBrightness = 1.0 * lensExpDT;
	float truepos = 0.0f;

	if ((worldTime < 13000 || worldTime > 23000) && sunPos.z < 0) truepos = 1.0 * (TimeSunrise + TimeNoon + TimeSunset + TimeMidnight);
	if ((worldTime < 23000 || worldTime > 13000) && -sunPos.z < 0) truepos = 1.0 * TimeMidnight;


// Set up domain
	vec2 q = texcoord.xy + texcoord.x * 0.4;
	vec2 p = -1.0 + 3.0 * q;
	vec2 p2 = -1.0 + 3.0 * q + vec2(10.0, 10.0);

// Create noise using fBm
	float f = fbm(5.0 * p);
	float f2 = fbm(10.0 * p2);
	float cover = 0.35f;
	float sharpness = 0.99 * sunvisibility2;	// Brightness
	float c = f - (1.0 - cover);

	if ( c < 0.0 )
		 c = 0.0;
	f = 1.0 - (pow(1.0 - sharpness, c));
	float c2 = f2 - (1.0 - cover);
	if ( c2 < 0.0 )
		 c2 = 0.0;
	f2 = 1.0 - (pow(1.0 - sharpness, c2));

	float dirtylens = (f * 2.0) + (f2 / 1);
	float visibility = max(pow(max(1.2 - smoothCircleDist(1.0)/0.6,0.1),2.0)-0.1,0.0);

	vec3 dirtcolorSunrise = vec3(2.52, 0.9, 0.3) * 0.4 * TimeSunrise;
	vec3 dirtcolorNoon = vec3(2.52, 2.25, 2.0) * 0.2 * TimeNoon;
	vec3 dirtcolorSunset = vec3(2.52, 1.5, 0.8) * 0.4 * TimeSunset;
	vec3 dirtcolorNight = vec3(0.8, 1.0, 1.3) * 0.2 * TimeMidnight;
	vec3 dirtcolor = dirtcolorSunrise + dirtcolorNoon + dirtcolorSunset + dirtcolorNight;

	float lens_strength = 1.1 * lensBrightness;
	dirtcolor *= lens_strength;
	color += (dirtylens*visibility*truepos)*dirtcolor*(1.0-rainStrength*1.0);


if ((worldTime < 13000 || worldTime > 23000) && sunPos.z < 0 && isEyeInWater < 0.9)
	{


	if (sunvisibility > 0.01)
	{
		float visibility = max(pow(max(1.0 - smoothCircleDist(1.0)/1.5,0.1),1.0)-0.1,0.0);

		vec3 lenscolorSunrise = vec3(0.3, 1.3, 2.55) * TimeSunrise;
		vec3 lenscolorNoon = vec3(0.3, 1.3, 2.55) * TimeNoon;
		vec3 lenscolorSunset = vec3(0.3, 1.3, 2.55) * TimeSunset;
		vec3 lenscolorNight = vec3(0.6, 0.8, 1.3) * TimeMidnight;

		vec3 lenscolor = lenscolorSunrise + lenscolorNoon + lenscolorSunset + lenscolorNight;
		lenscolor *= lensBrightness * 0.3 ;
		float anamorphic_lens = max(pow(max(1.0 - yDistAxis(0.0)/0.8,0.1),10.0)-0.3,0.0);
		color += anamorphic_lens * lenscolor * visibility * truepos * sunvisibility * (1.0-rainStrength*1.0);
	}

	
	if (sunvisibility > 0.01)
	{
		float visibility = max(pow(max(1.0 - smoothCircleDist(1.0)/0.9,0.1),5.0)-0.1,0.0);
		float sun = max(pow(max(1.0 - smoothCircleDist(1.0)/0.5,0.1),5.0)-0.1,0.0);

		vec3 lenscolorSunrise = vec3(2.52, 1.5, 0.8) * TimeSunrise;
		vec3 lenscolorNoon = vec3(1.3, 1.3, 1.3) * TimeNoon;
		vec3 lenscolorSunset = vec3(1.52, 1.5, 0.8) * TimeSunset;

		vec3 lenscolor = lenscolorSunrise + lenscolorNoon + lenscolorSunset;
		lenscolor *= clamp(0.4 * lensBrightness - sun, 0.0, 1.0);

		float sunray1 = max(pow(max(1.0 - yDistAxis(1.5)/0.7,0.1),10.0)-0.6,0.0);
		float sunray2 = max(pow(max(1.0 - yDistAxis(-1.3)/0.7,0.1),10.0)-0.6,0.0);
		float sunray3 = max(pow(max(1.0 - yDistAxis(5.0)/1.5,0.1),10.0)-0.6,0.0);
		float sunray4 = max(pow(max(1.0 - yDistAxis(-4.8)/1.5,0.1),10.0)-0.6,0.0);

		float sunrays = min(sunray1 + sunray2 + sunray3 + sunray4, 1.0);
		color += lenscolor * sunrays * visibility * sunvisibility * (1.0-rainStrength*1.0);
	}


#ifdef HEXAGON_LENS
	if (sunvisibility > 0.01)
	{
		float hex1 = clamp(hex( 0.5, 50.0), 0.0, 0.99);
		float hex2 = clamp(hex( 0.2, 40.0), 0.0, 0.99);
		float hex3 = clamp(hex(-0.1, 30.0), 0.0, 0.99);
		float hex4 = clamp(hex(-0.4, 60.0), 0.0, 0.99);
		float hex5 = clamp(hex(-0.7, 70.0), 0.0, 0.99);
		float hex6 = clamp(hex(-1.0, 90.0), 0.0, 0.99);

		vec3 hexColor  = vec3(0.0);

		hexColor += hex1 * vec3( 0.1, 0.4, 1.0) * timeNoon;
		hexColor += hex2 * vec3( 0.2, 0.6, 1.0) * timeNoon;
		hexColor += hex3 * vec3( 0.6, 0.8, 1.0) * timeNoon;
		hexColor += hex4 * vec3( 0.2, 0.6, 1.0) * timeNoon;
		hexColor += hex5 * vec3( 0.2, 0.5, 1.0) * timeNoon;
		hexColor += hex6 * vec3( 0.1, 0.4, 1.0) * timeNoon;

		hexColor += hex1 * vec3( 1.2, 1.0, 0.2) * TimeSunrise;
		hexColor += hex2 * vec3( 1.2, 1.0, 0.2) * TimeSunrise;
		hexColor += hex3 * vec3( 1.2, 1.0, 0.2) * TimeSunrise;
		hexColor += hex4 * vec3( 1.2, 1.0, 0.2) * TimeSunrise;
		hexColor += hex5 * vec3( 1.2, 1.0, 0.2) * TimeSunrise;
		hexColor += hex6 * vec3( 1.2, 1.0, 0.2) * TimeSunrise;

		hexColor += hex1 * vec3( 1.2, 1.0, 0.2) * TimeSunset;
		hexColor += hex2 * vec3( 1.2, 1.0, 0.2) * TimeSunset;
		hexColor += hex3 * vec3( 1.2, 1.0, 0.2) * TimeSunset;
		hexColor += hex4 * vec3( 1.2, 1.0, 0.2) * TimeSunset;
		hexColor += hex5 * vec3( 1.2, 1.0, 0.2) * TimeSunset;
		hexColor += hex6 * vec3( 1.2, 1.0, 0.2) * TimeSunset;

		vec3 hexagon = hexColor;

		color.rgb += hexagon * 0.3 * lensBrightness * (1.0-rainStrength) * sunvisibility;
	}
#endif

	}
}

void LensFlare(inout vec3 color)
{
vec3 tempColor2 = vec3(0.0);
float pw = 1.0 / viewWidth;
float ph = 1.0 / viewHeight;
vec3 sP = sunPosition;

	vec4 tpos = vec4(sP,1.0)*gbufferProjection;
	tpos = vec4(tpos.xyz/tpos.w,1.0);
	vec2 lPos = tpos.xy / tpos.z;
	lPos = (lPos + 1.0f)/2.0f;
	//lPos = clamp(lPos, vec2(0.001f), vec2(0.999f));
	vec2 checkcoord = lPos;

if (checkcoord.x < 1.0f && checkcoord.x > 0.0f && checkcoord.y < 1.0f && checkcoord.y > 0.0f && timeMidnight < 1.0)
	{
	vec2 checkcoord;

	float sunmask = 0.0f;
	float sunstep = -4.5f;
	float masksize = 0.004f;

	for (int a = 0; a < 4; a++)
		{
		for(int b = 0; b < 4; b++)
			{
			checkcoord = lPos + vec2(pw*a*5.0f,ph*5.0f*b);
			bool sky = false;
			float matID = GetMaterialIDs(checkcoord);
			matID = floor(matID * 255.0f);

			//Catch last part of sky
			if (matID > 254.0f)
			{
				matID = 0.0f;
			}

			if (matID == 0)
			{
				sky = true;
			} else {
				sky = false;
			}


			if (checkcoord.x < 1.0f && checkcoord.x > 0.0f && checkcoord.y < 1.0f && checkcoord.y > 0.0f)
				{
					if (sky == true)
					{
						sunmask = 1.0f;
					} else {
						sunmask = 0.0f;
					}
				}
			}
		}

			sunmask *= 0.34 * (1.0f - timeMidnight);
			sunmask *= (1.0f - rainStrength);

		if (sunmask > 0.02)
		{
		//Detect if sun is on edge of screen
		float edgemaskx = clamp(distance(lPos.x, 0.5f)*8.0f - 3.0f, 0.0f, 1.0f);
		float edgemasky = clamp(distance(lPos.y, 0.5f)*8.0f - 3.0f, 0.0f, 1.0f);

		//Darken colors if the sun is visible
			float centermask = 1.0 - clamp(distance(lPos.xy, vec2(0.5f, 0.5f))*2.0, 0.0, 1.0);
				  centermask = pow(centermask, 1.0f);
				  centermask *= sunmask;

			color.r *= (1.0 - centermask * (1.0f - timeMidnight));
			color.g *= (1.0 - centermask * (1.0f - timeMidnight));
			color.b *= (1.0 - centermask * (1.0f - timeMidnight));

		 //Adjust global flare settings
			const float flaremultR = 0.8f;
			const float flaremultG = 1.0f;
			const float flaremultB = 1.5f;

			float flarescale = 1.0f;
			const float flarescaleconst = 1.0f;

		 //Flare gets bigger at center of screen

			//flarescale *= (1.0 - centermask);


//Lens
	float flarescale2 = 1.1f;
	float flarescale3 = 2.0f;
	float flarescale4 = 1.5f;

	vec3 tempColor = vec3(0.0);
	vec3 tempColor3 = vec3(0.0);
	vec3 tempColor4 = vec3(0.0);
	vec2 resolution = vec2(viewWidth, viewHeight);

	float PI = 3.141592;
	vec2 uv = (texcoord.xy);

	float random = fract(sin(dot(sunPosition.xy, vec2(12.9898, 78.233)))* 43758.5453);
		  random - 0.25f;

		if (random < 0.25f)
		{
			random = 0.25f;
		}

		float c = 0.0;
		float dx = uv.x - 0.5;
		float dy = uv.y - 0.5;
		c = (atan(dy, dx) / PI + 1.0) * 1.0;
		float t = (sin(random) + 1.0) * 1.0;
		c = tan(c * t * 1000.0);

		vec4 tempColor2 = vec4(c, c, c, 1.0 );

		if (tempColor2.r < 0.7f)
		{
			tempColor2.r = 0.7f;
		}
		else if (tempColor2.r > 1.0f)
		{
			tempColor2.r = 1.0f;
		}

	sin(tempColor2);


	//Center white flare
		 vec2 flare1scale = vec2(1.7f*flarescale, 1.7f*flarescale);
		float flare1pow = 12.0f;
		 vec2 flare1pos = vec2(lPos.x*aspectRatio*flare1scale.x, lPos.y*flare1scale.y);

		float flare1 = distance(flare1pos, vec2(texcoord.s*aspectRatio*flare1scale.x, texcoord.t*flare1scale.y));
			  flare1 = 0.5 - flare1;
			  flare1 = clamp(flare1, 0.0, 10.0) * clamp(-sP.z, 0.0, 1.0);
			  flare1 *= sunmask;
			  flare1 = pow(flare1, 1.8f);
			  flare1 *= flare1pow;

		color.r += flare1*0.7f*flaremultR;
		color.g += flare1*0.4f*flaremultG;
		color.b += flare1*0.2f*flaremultB;


	//Center white flare
		 vec2 flare1Bscale = vec2(0.5f*flarescale, 0.5f*flarescale);
		float flare1Bpow = 6.0f;
		 vec2 flare1Bpos = vec2(lPos.x*aspectRatio*flare1Bscale.x, lPos.y*flare1Bscale.y);

		float flare1B = distance(flare1Bpos, vec2(texcoord.s*aspectRatio*flare1Bscale.x, texcoord.t*flare1Bscale.y));
			  flare1B = 0.5 - flare1B;
			  flare1B = clamp(flare1B, 0.0, 10.0) * clamp(-sP.z, 0.0, 1.0);
			  flare1B *= sunmask;
			  flare1B = pow(flare1B, 1.8f);
			  flare1B *= flare1Bpow;

		color.r += flare1B*0.7f*flaremultR;
		color.g += flare1B*0.2f*flaremultG;
		color.b += flare1B*0.0f*flaremultB;



	//close ring flare red
		 vec2 flare6scale = vec2(1.2f*flarescale, 1.2f*flarescale);
		float flare6pow = 0.2f;
		float flare6fill = 5.0f;
		float flare6offset = -1.9f;
		 vec2 flare6pos = vec2(	 ((1.0 - lPos.x)*(flare6offset + 1.0) - (flare6offset*0.5))	 *aspectRatio*flare6scale.x,  ((1.0 - lPos.y)*(flare6offset + 1.0) - (flare6offset*0.5))  *flare6scale.y);

		float flare6 = distance(flare6pos, vec2(texcoord.s*aspectRatio*flare6scale.x, texcoord.t*flare6scale.y));
			  flare6 = 0.5 - flare6;
			  flare6 = clamp(flare6*flare6fill, 0.0, 1.0) * clamp(-sP.z, 0.0, 1.0);
			  flare6 = pow(flare6, 1.6f);
			  flare6 = sin(flare6*3.1415);
			  flare6 *= sunmask;

			  flare6 *= flare6pow;

		color.r += flare6*1.0f*flaremultR * (tempColor2.r);
		color.g += flare6*0.0f*flaremultG * (tempColor2.r);
		color.b += flare6*0.0f*flaremultB * (tempColor2.r);


	//close ring flare green
		 vec2 flare6Bscale = vec2(1.1f*flarescale, 1.1f*flarescale);
		float flare6Bpow = 0.2f;
		float flare6Bfill = 5.0f;
		float flare6Boffset = -1.9f;
		 vec2 flare6Bpos = vec2(  ((1.0 - lPos.x)*(flare6Boffset + 1.0) - (flare6Boffset*0.5))	*aspectRatio*flare6Bscale.x,  ((1.0 - lPos.y)*(flare6Boffset + 1.0) - (flare6Boffset*0.5))	*flare6Bscale.y);

		float flare6B = distance(flare6Bpos, vec2(texcoord.s*aspectRatio*flare6Bscale.x, texcoord.t*flare6Bscale.y));
			  flare6B = 0.5 - flare6B;
			  flare6B = clamp(flare6B*flare6Bfill, 0.0, 1.0) * clamp(-sP.z, 0.0, 1.0);
			  flare6B = pow(flare6B, 1.6f);
			  flare6B = sin(flare6B*3.1415);
			  flare6B *= sunmask;
			  flare6B *= flare6Bpow;

		color.r += flare6B*1.0f*flaremultR * (tempColor2.r);
		color.g += flare6B*0.4f*flaremultG * (tempColor2.r);
		color.b += flare6B*0.0f*flaremultB * (tempColor2.r);


	//close ring flare blue
		 vec2 flare6Cscale = vec2(0.9f*flarescale, 0.9f*flarescale);
		float flare6Cpow = 0.3f;
		float flare6Cfill = 5.0f;
		float flare6Coffset = -1.9f;
		 vec2 flare6Cpos = vec2(  ((1.0 - lPos.x)*(flare6Coffset + 1.0) - (flare6Coffset*0.5))	*aspectRatio*flare6Cscale.x,  ((1.0 - lPos.y)*(flare6Coffset + 1.0) - (flare6Coffset*0.5))	*flare6Cscale.y);

		float flare6C = distance(flare6Cpos, vec2(texcoord.s*aspectRatio*flare6Cscale.x, texcoord.t*flare6Cscale.y));
			  flare6C = 0.5 - flare6C;
			  flare6C = clamp(flare6C*flare6Cfill, 0.0, 1.0) * clamp(-sP.z, 0.0, 1.0);
			  flare6C = pow(flare6C, 1.8f);
			  flare6C = sin(flare6C*3.1415);
			  flare6C *= sunmask;
			  flare6C *= flare6Cpow;

		color.r += flare6C*0.5f*flaremultR * (tempColor2.r);
		color.g += flare6C*0.3f*flaremultG * (tempColor2.r);
		color.b += flare6C*0.0f*flaremultB * (tempColor2.r);


		}
	}
}

void MoonGlow(inout vec3 color)
{
	vec4 tpos = vec4(moonPosition, 1.0) * gbufferProjection;
	tpos = vec4(tpos.xyz / tpos.w, 1.0);
	vec2 lPos = tpos.xy / tpos.z;
	lPos = (lPos + 1.0f) / 2.0f;
	vec2 checkcoord = lPos;

	if (checkcoord.x < 1.0f && checkcoord.x > 0.0f && checkcoord.y < 1.0f && checkcoord.y > 0.0f && timeNoon < 1.0)
	{
	float sunmask = 0.0f;
	for (int i = 0; i < 4; i++)
		{
		for(int j = 0; j < 4; j++)
			{
			checkcoord = lPos + vec2((1.0 / viewWidth) * i * 5.0f, (1.0 / viewHeight) * 5.0f * j);
			float matID = GetMaterialIDs(checkcoord);
			if (floor(matID * 255.0f) == 0)
				{
				if (checkcoord.x < 1.0f && checkcoord.x > 0.0f && checkcoord.y < 1.0f && checkcoord.y > 0.0f)
					{
					sunmask = 1.0f;
					}
				}
			}
		}
	sunmask *= 0.34 * (1.0f - timeNoon);
	sunmask *= (1.0f - rainStrength);

	if (sunmask > 0.02)
		{
		vec2 flareScale = vec2(0.35f, 7.0f);
		vec2 flarePos = vec2(lPos.x * aspectRatio * flareScale.x, lPos.y * flareScale.y);
		float flare = distance(flarePos, vec2(texcoord.s * aspectRatio * flareScale.x, texcoord.t * flareScale.y));
		flare = 0.5 - flare;
		flare = clamp(flare * 2.0f, 0.0f, 1.0f) * clamp(-moonPosition.z, 0.0f, 0.5f);
		flare *= sunmask;
		flare = pow(flare, 1.0f);
		color.r += flare * 0.50f * 0.4f;
		color.g += flare * 0.50f * 0.7f;
		color.b += flare * 0.85f * 1.0f;
		}
	}
}

Tone tone;

/////////////////////////MAIN//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////MAIN//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void main()
{
	vec3 color = GetColorTexture(texcoord.st);

	if (isEyeInWater > 0) {
		DepthOfField1(color);
	}else{
		#ifdef DOF1
		DepthOfField1(color);
		#endif
	}
	
	#ifdef DOF2
		  DepthOfField2(color);
	#endif

	#ifdef DOF
	if (isEyeInWater <= 0) {
		DOF_Blur(color);
	}
	#endif
	
	#ifdef Cinematic_Effect1
	CinematicEffect(color);
	#endif
	
	#ifdef BLOOM_EFFECTS
	CalculateBloom(bloomData);
	color = mix(color, bloomData.bloom, vec3(BLOOM_STRENGTH));
	#endif

	#ifdef RAINFOG
	AddRainFogScatter(color, bloomData);
	#endif
	
	//Vignette(color);
	CalculateExposure(color);

	#ifdef ACES_TONEMAPPING
	aTonemapReinhard05(color, bloomData);
	#else
	TonemapReinhard05(color, bloomData);
	#endif

#ifdef LENS_FLARE
	LensFlare(color);
#endif

#ifdef HEXAGON_LENS
	LensEffects(color);
#endif

	MoonGlow(color);

	color = mix(color, vec3(dot(color, vec3(1.0 / 3.0))), vec3(1.0 - SATURATION));
	
	gl_FragColor = vec4(color.rgb, 1.0f);
	
	#ifdef COLOR_BOOST
	color.r = (color.r*1.3)+(color.b+color.g)*(-0.1);
    color.g = (color.g*1.2)+(color.r+color.b)*(-0.1);
    color.b = (color.b*1.1)+(color.r+color.g)*(-0.1);
	color = color / (color + 2.2) * (1.0+2.0);
#endif	

	#ifdef CUSTOM_TONED
		color.r = (color.r*(CUSTOM_T_R * 0.01))+(color.b+color.g)*(-0.1);
		color.g = (color.g*(CUSTOM_T_G * 0.01))+(color.r+color.b)*(-0.1);
		color.b = (color.b*(CUSTOM_T_B * 0.01))+(color.r+color.g)*(-0.1);

		color = color / (color + (5 - (CUSTOM_T_L * 0.1))) * (1.0+2.0);
    #endif	
	


#ifdef Cinematic_Effect2
CinematicEffect(color);
#endif

color *=BRIGHTNESS*(1+isEyeInWater*(1-timeMidnight)); 

	gl_FragColor = vec4(color.rgb, 1.0f);

}