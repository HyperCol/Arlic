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

#define WATER_COLOR_F_R 0.15 //[0.0 0.09 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.55 1.7 1.75 1.8 1.85 1.9 1.95 2.0 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3.0 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4.0]
#define WATER_COLOR_F_G 0.6375 //[0.0 0.09 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.6375 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.55 1.7 1.75 1.8 1.85 1.9 1.95 2.0 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3.0 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4.0]
#define WATER_COLOR_F_B 0.75 //[0.0 0.09 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.55 1.7 1.75 1.8 1.85 1.9 1.95 2.0 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3.0 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4.0]

#define WAVE_HEIGHT 0.75 //[0.0 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2.0 2.05 2.1 2.15 2.2 2.25 2.3 2.35 2.4 2.45 2.5 2.55 2.6 2.65 2.7 2.75 2.8 2.85 2.9 2.95 3.0 3.05 3.1 3.15 3.2 3.25 3.3 3.35 3.4 3.45 3.5 3.55 3.6 3.65 3.7 3.75 3.8 3.85 3.9 3.95 4.0 4.05 4.1] 
#define WATER_SPEED 1.0    //[0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2.0 2.1 2.32.4 2.5 2.6 2.7 2.8 2.9 3.0 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4.0]

#define SHADOW_MAP_BIAS 0.90

const int 		shadowMapResolution 	= 2048;	// Shadowmap resolution [1024 2048 4096]
const float 	shadowDistance 			= 120.0; // Shadow distance. Set lower if you prefer nicer close shadows. Set higher if you prefer nicer distant shadows. [80.0 120.0 180.0 240.0]
const float 	shadowIntervalSize 		= 4.0f;
const bool 		shadowHardwareFiltering0 = true;

const bool 		shadowtex1Mipmap 		= true;
const bool 		shadowtex1Nearest 		= true;
const bool 		shadowcolor0Mipmap 		= true;
const bool 		shadowcolor0Nearest 	= true;
const bool 		shadowcolor1Mipmap 		= true;
const bool 		shadowcolor1Nearest 	= true;

uniform sampler2D gcolor;
uniform sampler2D gdepth;
uniform sampler2D gnormal;
uniform sampler2D composite;

uniform sampler2D gaux1;
uniform sampler2D gaux2;
uniform sampler2D gaux3;

uniform sampler2D depthtex0;
uniform sampler2D depthtex1;

uniform sampler2DShadow shadowtex0;
uniform sampler2D shadowtex1;
uniform sampler2D shadowcolor0;

uniform sampler2D noisetex;

uniform mat4 gbufferProjection;
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;

uniform float rainStrength;
uniform float frameTimeCounter;
uniform float screenBrightness;

uniform vec3 upVector;
uniform vec3 shadowLightVector;

uniform int isEyeInWater;

uniform ivec2 eyeBrightnessSmooth;

varying float timeNoon;
varying float timeMidnight;
varying float timeSunriseSunset;

varying vec3 colorSunlight;
varying vec3 colorSkylight;
varying vec3 colorTorchlight;
varying vec3 lightVector;

varying vec2 texcoord;

#include "/lib/common.glsl"
#include "/lib/antialiasing/taaProjection.glsl"
#include "/lib/materials.glsl"
#include "/lib/packing.glsl"
#include "/lib/lighting/lightmap.glsl"
#include "/lib/lighting/lighting.glsl"

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

vec4  	GetScreenSpacePosition(in vec2 coord, in float depth) {	//Function that calculates the screen-space position of the objects in the scene using the depth texture and the texture coordinates of the full-screen quad
		  //depth += float(GetMaterialMask(coord, 5)) * 0.38f;
	vec4 fragposition = gbufferProjectionInverse * vec4(coord.s * 2.0f - 1.0f, coord.t * 2.0f - 1.0f, 2.0f * depth - 1.0f, 1.0f);
		 fragposition /= fragposition.w;

	return fragposition;
}

void WaterFog(inout vec3 color, vec3 lightVector, float skylightMap, float isWater)
{
	// return;
	if (bool(isWater) || isEyeInWater > 0)
	{
		float depth = texture2D(depthtex1, texcoord.st).x;
		float depthSolid = texture2D(depthtex0, texcoord.st).x;

		vec4 viewSpacePosition = GetScreenSpacePosition(texcoord.st, depth);
		vec4 viewSpacePositionSolid = GetScreenSpacePosition(texcoord.st, depthSolid);

		vec3 viewVector = normalize(viewSpacePosition.xyz);


		float waterDepth = distance(viewSpacePosition.xyz, viewSpacePositionSolid.xyz);
		if (isEyeInWater > 0)
		{
			waterDepth = length(viewSpacePosition.xyz) * 0.5;		
			if (bool(isWater))
			{
				waterDepth = length(viewSpacePositionSolid.xyz) * 0.5;		
			}	
		}


		float fogDensity = 0.20;
		float visibility = 1.0f / (pow(exp(waterDepth * fogDensity), 1.0f));
		float visibility2 = 1.0f / (pow(exp(waterDepth * fogDensity), 1.0f));

		vec3 waterNormal = NormalDecode(texture2D(gnormal, texcoord.xy).xy);

		// vec3 waterFogColor = vec3(1.0, 1.0, 0.1);	//murky water
		// vec3 waterFogColor = vec3(0.2, 0.95, 0.0) * 1.0; //green water
		// vec3 waterFogColor = vec3(0.4, 0.95, 0.05) * 2.0; //green water
		// vec3 waterFogColor = vec3(0.7, 0.95, 0.00) * 0.75; //green water
		// vec3 waterFogColor = vec3(0.2, 0.95, 0.4) * 5.0; //green water
		// vec3 waterFogColor = vec3(0.2, 0.95, 1.0) * 1.0; //clear water
		vec3 waterFogColor = vec3(WATER_COLOR_F_R, WATER_COLOR_F_G, WATER_COLOR_F_B); //clear water
			  waterFogColor *= 0.01 * dot(vec3(0.33333), colorSunlight);
			  waterFogColor *= (1.0 - rainStrength * 0.95);
			  waterFogColor *= isEyeInWater * 2.0 + 1.0;

		if (isEyeInWater == 0)
		{
			waterFogColor *= skylightMap;
		}
		else
		{
			waterFogColor *= pow(eyeBrightnessSmooth.y / 240.0f, 6.0f);
		}

		// float scatter = CalculateSunglow(surface);

		vec3 viewVectorRefracted = refract(viewVector, waterNormal, 1.0 / 1.3333);
		float scatter = 1.0 / (pow(saturate(dot(-lightVector, viewVectorRefracted) * 0.5 + 0.5) * 20.0, 2.0) + 0.1);
		//vec3 reflectedLightVector = reflect(lightVector, upVector);
			  //scatter += (1.0 / (pow(saturate(dot(-reflectedLightVector, viewVectorRefracted) * 0.5 + 0.5) * 30.0, 2.0) + 0.1)) * saturate(1.0 - dot(lightVector, upVector) * 1.4);

		// scatter += pow(saturate(dot(-lightVector, viewVectorRefracted) * 0.5 + 0.5), 3.0) * 0.02;
		if (isEyeInWater < 1)
		{
			waterFogColor = mix(waterFogColor, colorSunlight * 21.0 * waterFogColor, vec3(scatter * (1.0 - rainStrength)));
		}

		// color *= pow(vec3(0.7, 0.88, 1.0) * 0.99, vec3(waterDepth * 0.45 + 0.2));
		// color *= pow(vec3(0.7, 0.88, 1.0) * 0.99, vec3(waterDepth * 0.45 + 1.0));
		color *= pow(vec3(0.4, 0.72, 1.0) * 0.99, vec3(waterDepth * 0.25 + 0.25));
		// color *= pow(vec3(0.7, 1.0, 0.2) * 0.8, vec3(waterDepth * 0.15 + 0.1));
		color = mix(waterFogColor, color, saturate(visibility));



	}
}

float   CalculateSunglow(in vec3 L, in vec3 v) {

	float curve = 4.0f;

	vec3 npos = v;
	vec3 halfVector2 = normalize(-L + npos);
	float factor = 1.0f - dot(halfVector2, npos);

	return factor * factor * factor * factor;
}

void 	AddSunglow(in vec3 L, in vec3 v, inout vec3 color) {
	float sunglowFactor = CalculateSunglow(L, v);
	float antiSunglowFactor = CalculateSunglow(-L, v);

	color *= 1.0f + pow(sunglowFactor, 1.1f) * (7.0f + timeNoon * 1.0f) * (1.0f - rainStrength) * 0.4;
	color *= mix(vec3(1.0f), colorSunlight * 11.0f, pow(clamp(vec3(sunglowFactor) * (1.0f - timeMidnight) * (1.0f - rainStrength), vec3(0.0f), vec3(1.0f)), vec3(2.0f)));
	color = mix(color, colorSunlight * (0.25 + timeSunriseSunset * 0.25), pow(clamp(vec3(sunglowFactor) * (1.0f - timeMidnight) * (1.0f - rainStrength), vec3(0.0f), vec3(1.0f)), vec3(5.0f)));

	color *= 1.0f + antiSunglowFactor * 2.0f * (1.0f - rainStrength);
	//surface.sky.albedo *= mix(vec3(1.0f), colorSunlight, antiSunglowFactor);
}

vec3 	AddSkyGradient(in vec3 position) {
	float curve = 5.0f;
	vec3 npos = normalize(position);
	vec3 halfVector2 = normalize(-upVector + npos);
	float skyGradientFactor = dot(halfVector2, npos);
	float skyDirectionGradient = skyGradientFactor;

	if (dot(halfVector2, npos) > 0.75)
		skyGradientFactor = 1.5f - skyGradientFactor;

	skyGradientFactor = pow(skyGradientFactor, curve);

	//vec3 color = CalculateLuminance(normalize(1e-5 + pow(texture2D(gcolor, texcoord.xy).rgb, vec3(2.2)))) * colorSkylight;
	vec3 color = colorSkylight;

	color *= mix(skyGradientFactor, 1.0f, clamp((0.12f - (timeNoon * 0.1f)) + rainStrength, 0.0f, 1.0f));
	color *= pow(skyGradientFactor, 2.5f) + 0.2f;
	color *= (pow(skyGradientFactor, 1.1f) + 0.425f) * 0.5f;
	color.g *= skyGradientFactor * 1.0f + 1.0f;


	vec3 linFogColor = pow(gl_Fog.color.rgb, vec3(2.2f));

	float fogLum = max(max(linFogColor.r, linFogColor.g), linFogColor.b);


	float fade1 = clamp(skyGradientFactor - 0.05f, 0.0f, 0.2f) / 0.2f;
		  fade1 = fade1 * fade1 * (3.0f - 2.0f * fade1);
	vec3 color1 = vec3(12.0f, 8.0, 4.7f) * 0.15f;
		 color1 = mix(color1, vec3(2.0f, 0.55f, 0.2f), vec3(timeSunriseSunset));

	color *= mix(vec3(1.0f), color1, vec3(fade1));

	float fade2 = clamp(skyGradientFactor - 0.11f, 0.0f, 0.2f) / 0.2f;
	vec3 color2 = vec3(2.7f, 1.0f, 2.8f) / 20.0f;
		 color2 = mix(color2, vec3(1.0f, 0.15f, 0.5f), vec3(timeSunriseSunset));

	color *= mix(vec3(1.0f), color2, vec3(fade2 * 0.5f));



	float horizonGradient = 1.0f - distance(skyDirectionGradient, 0.72f) / 0.72f;
		  horizonGradient = pow(horizonGradient, 10.0f);
		  horizonGradient = max(0.0f, horizonGradient);

	float sunglow = CalculateSunglow(lightVector, npos);
		  horizonGradient *= sunglow * 2.0f + (0.65f - timeSunriseSunset * 0.55f);

	vec3 horizonColor1 = vec3(1.5f, 1.5f, 1.5f);
		 horizonColor1 = mix(horizonColor1, vec3(1.5f, 1.95f, 1.5f) * 2.0f, vec3(timeSunriseSunset));
	vec3 horizonColor2 = vec3(1.5f, 1.2f, 0.8f) * 1.0f;
		 horizonColor2 = mix(horizonColor2, vec3(1.9f, 0.6f, 0.4f) * 2.0f, vec3(timeSunriseSunset));

	color *= mix(vec3(1.0f), horizonColor1, vec3(horizonGradient) * (1.0f - timeMidnight));
	color *= mix(vec3(1.0f), horizonColor2, vec3(pow(horizonGradient, 2.0f)) * (1.0f - timeMidnight));

	float grayscale = fogLum / 10.0f;
		  grayscale /= 3.0f;

	color = mix(color, vec3(dot(vec3(1.0 / 3.0), color)), vec3(rainStrength));


	//color /= fogLum;


	color *= mix(1.0f, 4.5f, timeNoon);
	color *= mix(1.0f, 1.0, timeMidnight);

	AddSunglow(lightVector, npos, color);

	color *= mix(1.0, 0.01, rainStrength);

	return color;
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

float GetWaves(vec3 position) {
	float speed = 0.9f;
	float waveWaterSpeed = WATER_SPEED;
#ifdef WATER_SPEED_LIGHT_BAR_LINKER
      waveWaterSpeed *= pow(screenBrightness * 2.0f, 4.0);
#endif
#define FRAME_TIME frameTimeCounter * waveWaterSpeed
  vec2 p = position.xz / 20.0f;

  p.xy -= position.y / 20.0f;

  p.x = -p.x;

  p.x += (FRAME_TIME / 40.0f) * speed;
  p.y -= (FRAME_TIME / 40.0f) * speed;

  float weight = 1.0f;
  float weights = weight;

  float allwaves = 0.0f;

  float wave = 0.0;
	//wave = textureSmooth(noisetex, (p * vec2(2.0f, 1.2f))  + vec2(0.0f,  p.x * 2.1f) ).x;
	p /= 2.1f; 	/*p *= pow(2.0f, 1.0f);*/ 	p.y -= (FRAME_TIME / 20.0f) * speed; p.x -= (FRAME_TIME / 30.0f) * speed;
  //allwaves += wave;

  weight = 4.1f;
  weights += weight;
      wave = textureSmooth(noisetex, (p * vec2(2.0f, 1.4f))  + vec2(0.0f,  -p.x * 2.1f) ).x;
			p /= 1.5f;/*p *= pow(2.0f, 2.0f);*/ 	p.x += (FRAME_TIME / 20.0f) * speed;
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

  // weight = 10.0f;
  // weights += weight;
  // 	wave = sin(length(position.xz * 5.0 + FRAME_TIME));
  //   wave *= weight;
  // allwaves += wave;

  allwaves /= weights;

  return allwaves;
}

vec3 GetWavesNormal(vec3 position) {

	const float sampleDistance = 11.0f;

	position -= vec3(0.005f, 0.0f, 0.005f) * sampleDistance;

	float wavesCenter = GetWaves(position);
	float wavesLeft = GetWaves(position + vec3(0.01f * sampleDistance, 0.0f, 0.0f));
	float wavesUp   = GetWaves(position + vec3(0.0f, 0.0f, 0.01f * sampleDistance));

	vec3 wavesNormal;
		 wavesNormal.r = wavesCenter - wavesLeft;
		 wavesNormal.g = wavesCenter - wavesUp;

		 wavesNormal.r *= 30.0f * WAVE_HEIGHT / sampleDistance;
		 wavesNormal.g *= 30.0f * WAVE_HEIGHT / sampleDistance;

		//  wavesNormal.b = sqrt(1.0f - wavesNormal.r * wavesNormal.r - wavesNormal.g * wavesNormal.g);
		 wavesNormal.b = 1.0;
		 wavesNormal.rgb = normalize(wavesNormal.rgb);



	return wavesNormal.rgb;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////MAIN//////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void main()  {
  /*
	vec4 origColor = texture2D(gaux3, texcoord.st);

	vec3 wavesNormal = vec3(origColor.xy * 2.0 - 1.0, 1.0);
	vec3 wavesNormalr = vec3(texture2D(gaux3, mod(texcoord.st + vec2(0.5, 0.0), vec2(1.0))).xy * 2.0 - 1.0, 1.0);
	vec3 wavesNormalu = vec3(texture2D(gaux3, mod(texcoord.st + vec2(0.0, 0.5), vec2(1.0))).xy * 2.0 - 1.0, 1.0);
	vec3 wavesNormalur = vec3(texture2D(gaux3, mod(texcoord.st + vec2(0.5, 0.5), vec2(1.0))).xy * 2.0 - 1.0, 1.0);


	float lerpx = clamp((abs(texcoord.x - 0.5) * 2.0) * 3.0 - 2.0, 0.0, 1.0);
	float lerpy = clamp((abs(texcoord.y - 0.5) * 2.0) * 3.0 - 2.0, 0.0, 1.0);


	vec3 x0 = mix(wavesNormal, wavesNormalr, vec3(lerpx));
	vec3 x1 = mix(wavesNormalu, wavesNormalur, vec3(lerpx));
	vec3 seamlessWavesNormal = normalize(mix(x0, x1, vec3(lerpy)));
  */

  vec3 color = vec3(0.0);

  float water 	= GetMaterialMask(texcoord.st, 35);
  float ice 	= GetMaterialMask(texcoord.st, 4);
  float glass 	= GetMaterialMask(texcoord.st, 55);

  float translucent = water + ice + glass;

  vec3 viewPosition  = nvec3(gbufferProjectionInverse * nvec4(vec3(texcoord, texture2D(depthtex1, texcoord).x) * 2.0 - 1.0));
  vec4 worldPosition = gbufferModelViewInverse * nvec4(viewPosition);
  vec3 viewDirection = normalize(viewPosition.xyz);
  vec3 eyeDirection  = -viewDirection;

  vec3 normal = NormalDecode(texture2D(gaux1, texcoord).zw);

  float packageMaterialData = texture2D(gaux3, texcoord).x;
  float smoothness 	= unpack2x8X(packageMaterialData);
  float metallic 		= max(0.02, unpack2x8Y(packageMaterialData));
  float roughness 	= pow2(1.0 - smoothness);
  float metals		= step(0.9, metallic);
  float emissive		= texture2D(gaux2, texcoord).y;
  float IOR = 1.0 / ((2.0 / (sqrt(metallic) + 1.0)) - 1.0);

  //vec2 refractCoord = vec2(0.0); vec4 blend = vec4(0.0);
  //WaterRefraction(refractCoord, blend, nvec3(gbufferProjectionInverse * nvec4(vec3(texcoord, texture2D(depthtex0, texcoord).x) * 2.0 - 1.0)), normal, IOR);

  //bool refracted = bool(GetMaterialMask(refractCoord.st, 35) + GetMaterialMask(refractCoord.st, 4) + GetMaterialMask(refractCoord.st, 55));

  if(bool(step(0.9999, (texture2D(depthtex1, texcoord.xy).x)))){
	  color = AddSkyGradient(viewPosition) * 6.0;
  }

  if(bool(translucent)){
	vec3 L = shadowLightVector;

	//vec3 sky = AddSkyGradient(viewPosition) * 6.0;

	vec3 albedo = vec3(unpack2x8(texture2D(gaux1, texcoord).r), unpack2x8X(texture2D(gaux1, texcoord).g));
		 albedo = Gamma(albedo);

  	vec3  F0 = mix(vec3(metallic), albedo, metals);

	vec4 shadowCoord = shadowProjection * shadowModelView * worldPosition;
		 shadowCoord /= shadowCoord.w;	float distortion = 0.95 / mix(1.0 - SHADOW_MAP_BIAS, 1.0, length(shadowCoord.xy));
		 shadowCoord.xy *= distortion;
		 shadowCoord.z = mix(shadowCoord.z, 0.5, 0.8);
		 shadowCoord.xyz = shadowCoord.xyz * 0.5 + 0.5;
		 shadowCoord.z -= 0.5 / float(shadowMapResolution);

	vec3 stained = Gamma(texture2D(shadowcolor0, shadowCoord.xy).rgb) * step(shadowCoord.z, texture2D(shadowtex1, shadowCoord.xy).x);

	stained = vec3(0.0);

	//
	float dither = R2_dither();

	//float opticalDepth = abs(texture2D(shadowtex1, shadowCoord)) * 2.0;

		//for(float i = -1.0; i <= 1.0; i += 1.0){
			for(int i = 0; i < 4; i++){
				float angle = (float(i) + dither) * 0.25 * 2.0 * Pi;
				vec2 coord = vec2(cos(angle), sin(angle)) / float(shadowMapResolution) * 1.0;

				vec3 stainedSample = Gamma(texture2DLod(shadowcolor0, shadowCoord.xy + coord, 1).rgb) * step(shadowCoord.z, texture2DLod(shadowtex1, shadowCoord.xy + coord, 1).x);

				stained += stainedSample;
			}
		//}

		stained /= 4.0;
	//

	vec3 shading = mix(vec3(1.0), stained, 1.0 - shadow2D(shadowtex0, shadowCoord.xyz).x);
		 shading *= 1.0 - rainStrength;

	vec3 diffuse = colorSunlight * CalculateDiffuseLighting(L, eyeDirection, normal, normal, albedo, 1.0, F0, roughness, metallic, 0.0) * shading;
		 diffuse += colorSkylight * albedo * GetLightmapSky(gaux2, texcoord) * 0.03;
		 diffuse += colorTorchlight * albedo * GetLightmapTorch(gaux2, texcoord) * 2.0;

	color += diffuse;

	WaterFog(color, lightVector, GetLightmapSky(texcoord.st), water);

	//color = texture2D(shadowcolor0, texcoord).rgb;
  }
  
  //color = Gamma(texture2D(gcolor, texcoord).rgb);
  color = Linear(color * 0.001);

  /* DRAWBUFFERS:6 */
  gl_FragData[0] = vec4(color, 1.0);
}

//change GetWavesNormal
//change material id getting of transparent blocks