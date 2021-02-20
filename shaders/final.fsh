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
#include "/lib/camera/cameraEffect.frag"

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
		DOF_Blur(tone.color, isHand);
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

	//float aperture = 4.0; float shutterSpeed = 0.0; float iso = 0.0;

	tone.color *= 1000.0;
	tone.color *= 8.0;
	//tone.color /= texture2D(gaux3, vec2(0.5)).a;

	//float EV100 = ComputeTargetEV(texture2D(gaux3, vec2(0.5)).a + 0.0001);
	//tone.color *= ConvertEV100ToExposure(EV100 - 0.0);
	//tone.color *= ConvertEV100ToExposure(ComputeEV100(4.0 * 4.0, 0.0045, 100.0));
	//tone.color *= ConvertEV100ToExposure(ComputeEV100(4.0 * 4.0, 0.0045, ComputeISO(4.0, 0.0045, ComputeTargetEV(texture2D(gaux3, vec2(0.5)).a + 0.0001))));

	//tone.color *= comp

	//#if Exposure_Setting == Average

	//#elif Exposure_Setting == vaule
		//color /= 0.001;
		//color 
	//#endif

	Hue_Adjustment(tone);

	//tone.color = pow(tone.color, vec3(1.0 / 2.2));
	
	gl_FragColor = vec4(tone.color, 1.0f);

}
