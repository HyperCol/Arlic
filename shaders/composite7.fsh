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

#define Enabled_TemportalAntiAliasing
	#define TAA_Sharpen 50		//[0 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100]

#define BANDING_FIX_FACTOR 1.0f

#define BLOOM_EFFECTS
    #define BLOOM_AMOUNT 1.0 // How strong the bloom effect is. [0.5 0.75 1.0 1.25 1.5]
    #define ATMOSPHERIC_HAZE 1.0 // Amount of haziness added to distant land. [0.0 0.5 1.0 1.5 2.0] 

#define Exposure_Delay 1.0 	//[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0]

uniform sampler2D depthtex0;

uniform sampler2D gcolor;
uniform sampler2D gaux3;
uniform sampler2D gaux2;
uniform sampler2D gdepthtex;
uniform sampler2D noisetex;

uniform sampler2D colortex7;
const bool colortex7Clear = false;
const vec4 colortex7ClearColor = vec4(vec3(0.0), 1.0);

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferPreviousModelView;
uniform mat4 gbufferPreviousProjection;

uniform vec3 previousCameraPosition;
uniform vec3 cameraPosition;

varying vec4 texcoord;

uniform float near;
uniform float far;
uniform float viewWidth;
uniform float viewHeight;

uniform float rainStrength;

uniform int   isEyeInWater;
uniform ivec2 eyeBrightnessSmooth;

uniform vec2 jitter;
uniform vec2 pixel;
uniform vec2 resolution;

uniform int frameCounter;
uniform float frameTimeCounter;

const bool gaux2MipmapEnabled = true;

vec3 	GetTextureLod(in sampler2D tex, in vec2 coord, in int level) {				//Perform a texture lookup with BANDING_FIX_FACTOR compensation
	return pow(texture2DLod(tex, coord, level).rgb, vec3(BANDING_FIX_FACTOR + 1.2f));
}

vec3 	GetColorTexture(in vec2 coord) {
	return GetTextureLod(gaux3, coord.st, 0).rgb;
}

float 	GetDepthLinear(in vec2 coord) {					//Function that retrieves the scene depth. 0 - 1, higher values meaning farther away
	return 2.0f * near * far / (far + near - (2.0f * texture2D(gdepthtex, coord).x - 1.0f) * (far - near));
}

float Luminance(in vec3 color)
{
	return dot(color.rgb, vec3(0.2125f, 0.7154f, 0.0721f));
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
	//vec2 resolution = vec2(viewWidth, viewHeight);

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

void 	CalculateBloom(inout BloomDataStruct bloomData) {		//Retrieve previously calculated bloom textures

	//constants for bloom bloomSlant
	const float    bloomSlant = 0.25f;
	const float[7] bloomWeight = float[7] (pow(7.0f, bloomSlant),
										   pow(6.0f, bloomSlant),
										   pow(5.0f, bloomSlant),
										   pow(4.0f, bloomSlant),
										   pow(3.0f, bloomSlant),
										   pow(2.0f, bloomSlant),
										   1.0f
										   );

	vec2 recipres = vec2(1.0f / viewWidth, 1.0f / viewHeight);

	bloomData.blur0  =  pow(BicubicTexture(gcolor, (texcoord.st - recipres * 0.5f) * (1.0f / exp2(2.0f 	)) + 	vec2(0.0f, 0.0f)		+ vec2(0.000f, 0.000f)	).rgb, vec3(1.0f + 1.2f));
	bloomData.blur1  =  pow(BicubicTexture(gcolor, (texcoord.st - recipres * 0.5f) * (1.0f / exp2(3.0f 	)) + 	vec2(0.0f, 0.25f)		+ vec2(0.000f, 0.025f)	).rgb, vec3(1.0f + 1.2f));
	bloomData.blur2  =  pow(BicubicTexture(gcolor, (texcoord.st - recipres * 0.5f) * (1.0f / exp2(4.0f 	)) + 	vec2(0.125f, 0.25f)		+ vec2(0.025f, 0.025f)	).rgb, vec3(1.0f + 1.2f));
	bloomData.blur3  =  pow(BicubicTexture(gcolor, (texcoord.st - recipres * 0.5f) * (1.0f / exp2(5.0f 	)) + 	vec2(0.1875f, 0.25f)	+ vec2(0.050f, 0.025f)	).rgb, vec3(1.0f + 1.2f));
	bloomData.blur4  =  pow(BicubicTexture(gcolor, (texcoord.st - recipres * 0.5f) * (1.0f / exp2(6.0f 	)) + 	vec2(0.21875f, 0.25f)	+ vec2(0.075f, 0.025f)	).rgb, vec3(1.0f + 1.2f));
	bloomData.blur5  =  pow(BicubicTexture(gcolor, (texcoord.st - recipres * 0.5f) * (1.0f / exp2(7.0f 	)) + 	vec2(0.25f, 0.25f)		+ vec2(0.100f, 0.025f)	).rgb, vec3(1.0f + 1.2f));
	bloomData.blur6  =  pow(BicubicTexture(gcolor, (texcoord.st - recipres * 0.5f) * (1.0f / exp2(8.0f 	)) + 	vec2(0.28f, 0.25f)		+ vec2(0.125f, 0.025f)	).rgb, vec3(1.0f + 1.2f));

	// bloomData.blur2 *= vec3(0.5, 0.5, 2.0);
	bloomData.blur4 *= vec3(1.0, 0.85, 0.85);
	bloomData.blur5 *= vec3(0.85, 0.85, 1.2);

 	bloomData.bloom  = bloomData.blur0 * bloomWeight[0];
 	bloomData.bloom += bloomData.blur1 * bloomWeight[1];
 	bloomData.bloom += bloomData.blur2 * bloomWeight[2];
 	bloomData.bloom += bloomData.blur3 * bloomWeight[3];
 	bloomData.bloom += bloomData.blur4 * bloomWeight[4];
 	bloomData.bloom += bloomData.blur5 * bloomWeight[5];
 	bloomData.bloom += bloomData.blur6 * bloomWeight[6];

}

void 	AddRainFogScatter(inout vec3 color, in BloomDataStruct bloomData)
{
	const float    bloomSlant = 1.0f;
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

	float fogTotalWeight = 	1.0f * bloomWeight[0] +
			       			1.0f * bloomWeight[1] +
			       			1.0f * bloomWeight[2] +
			       			1.0f * bloomWeight[3] +
			       			1.0f * bloomWeight[4] +
			       			1.0f * bloomWeight[5] +
			       			1.0f * bloomWeight[6];

	fogBlur /= fogTotalWeight;

	float linearDepth = GetDepthLinear(texcoord.st);

	float fogDensity = 0.007f * (rainStrength);

	fogDensity += 0.001 * ATMOSPHERIC_HAZE;

	if (isEyeInWater > 0)
		fogDensity = 0.2;

	float visibility = 1.0f / (pow(exp(linearDepth * fogDensity), 1.0f));
	float fogFactor = 1.0f - visibility;
		  fogFactor = clamp(fogFactor, 0.0f, 1.0f);

		  if (isEyeInWater < 1)
		  fogFactor *= mix(0.0f, 1.0f, pow(eyeBrightnessSmooth.y / 240.0f, 6.0f));

	color = mix(color, fogBlur, fogFactor * 1.0f);
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
	color.rgb = mix(color.rgb, rodLight, vec3(factor));	//visual acuity loss

	color.rgb += snow.rgb * snow2.rgb * snow.rgb * 0.000000002f;
}

float 	GetDepthLinear(in float depth) {
	return (near * far) / (depth * (near - far) + far);
}

vec3 GetClosest(in vec2 coord){
    vec3 closest = vec3(0.0, 0.0, 1.0);

    for(float i = -1.0; i <= 1.0; i += 1.0){
      for(float j = -1.0; j <= 1.0; j += 1.0){
        vec2 neighborhood = vec2(i, j) * pixel;
        float neighbor = GetDepthLinear(texture2D(depthtex0, coord + neighborhood).x);

        if(neighbor < closest.z){
          closest.z = neighbor;
          closest.xy = neighborhood;
        }
      }
    }

    closest.xy += coord;
	closest.z = texture2D(depthtex0, closest.xy).x;

    return closest;
  }

vec2 CalculateVector(in vec3 coord){
    vec4 view = gbufferProjectionInverse * vec4(coord * 2.0 - 1.0, 1.0);
         view /= view.w;
         view = gbufferModelViewInverse * view;
         view.xyz += cameraPosition - previousCameraPosition;
         view = gbufferPreviousModelView * view;
         view = gbufferPreviousProjection * view;
         view /= view.w;
         view.xy = view.xy * 0.5 + 0.5;

    vec2 velocity = coord.xy - view.xy;

    if(coord.z < 0.7) velocity *= 0.01;

    return velocity;
}

  vec4 ReprojectSampler(in sampler2D tex, in vec2 pixelPos){
    vec4 result = vec4(0.0);

    vec2 position = resolution * pixelPos;
    vec2 centerPosition = floor(position - 0.5) + 0.5;

    vec2 f = position - centerPosition;
    vec2 f2 = f * f;
    vec2 f3 = f * f2;

    float c = TAA_Sharpen  * 0.01;
    vec2 w0 =         -c  *  f3 + 2.0 * c          *  f2 - c  *  f;
    vec2 w1 =  (2.0 - c)  *  f3 - (3.0 - c)        *  f2            + 1.0;
    vec2 w2 = -(2.0 - c)  *  f3 + (3.0 - 2.0 * c)  *  f2 + c  *  f;
    vec2 w3 =          c  *  f3 - c                *  f2;
    vec2 w12 = w1 + w2;

    vec2 tc12 = pixel * (centerPosition + w2 / w12);
    vec3 centerColor = texture2D(tex, vec2(tc12.x, tc12.y)).rgb;
    vec2 tc0 = pixel * (centerPosition - 1.0);
    vec2 tc3 = pixel * (centerPosition + 2.0);

    result = vec4(texture2D(tex, vec2(tc12.x, tc0.y)).rgb, 1.0) * (w12.x * w0.y) +
          	 vec4(texture2D(tex, vec2(tc0.x, tc12.y)).rgb, 1.0) * (w0.x * w12.y) +
          	 vec4(centerColor, 1.0) * (w12.x * w12.y) +
           	 vec4(texture2D(tex, vec2(tc3.x, tc12.y)).rgb, 1.0) * (w3.x * w12.y) +
          	 vec4(texture2D(tex, vec2(tc12.x, tc3.y)).rgb, 1.0) * (w12.x * w3.y);

    result /= result.a;

    result.rgb = pow(result.rgb, vec3(2.2));

    return result;
  }

void CalculateClampColor(inout vec3 minColor, inout vec3 maxColor, in vec2 coord){
	for(int i = 0; i <= 3; i++){
		for(int j = 0; j <= 3; j++){
			vec2 samplePosition = vec2(i, j) - 1.0;
			vec3 sampleColor = GetColorTexture(coord + samplePosition * pixel);

			minColor = min(minColor, sampleColor);
			maxColor = max(maxColor, sampleColor);
		}
	}
}

vec3 TemportalAntiAliasing(in vec2 coord){
	vec2 unjitter = coord + jitter;

	vec3 currentColor = GetColorTexture(unjitter);
	vec3 maxColor = currentColor;
	vec3 minColor = currentColor;
	CalculateClampColor(minColor, maxColor, unjitter);

	vec3 closest = GetClosest(unjitter);	//vec3(unjitter, texture2D(depthtex0, unjitter).x)
	vec2 velocity = CalculateVector(closest);

	vec2 reprojectCoord = texcoord.st - velocity;

	vec3 previousSample = ReprojectSampler(colortex7, reprojectCoord).rgb;

	vec3 antialiasing = previousSample;
		 antialiasing = clamp(antialiasing, minColor, maxColor);

	float blend = 0.95;
		  blend *= float(floor(reprojectCoord) == vec2(0.0));
		  blend *= mix(1.0, 0.9, min(1.0, length(velocity * resolution)));

	antialiasing = mix(currentColor, antialiasing, blend);

	return antialiasing;
}

vec3 InverseToneMapping(in vec3 color){
	float a = 0.000033;
	float b = 0.03;

	float lum = max(color.r, max(color.g, color.b));

	if(bool(step(lum, a))) color;

	return color/lum*((a*a-(2.0*a-b)*lum)/(b-lum));
}

float 	CalculateLuminance(in vec3 color) {
	return (color.r * 0.2126f + color.g * 0.7152f + color.b * 0.0722f);
}

void main() {
    vec3 color = GetColorTexture(texcoord.st);	//Sample color texture

	vec3 antialiasing = color; 
	
	vec3 center = pow(texture2DLod(gaux2, vec2(0.5), viewHeight).rgb, vec3(2.2)) / 0.001;
		 center = 1.0 - exp(-center * 1.0);

	float maxFPS = 300.0;
	float minFPS = 2.0;
	float delay = pow(8.0, 1.0 + Exposure_Delay);

	float exposure = mix(CalculateLuminance(center),
						 pow(texture2D(colortex7, vec2(0.5)).a, 2.2),
						 1.0 - 1.0 / 60.0);

						 //clamp((1.0 + frameTimeCounter) / float(frameCounter + 1) * delay, 1.0 / minFPS, 1.0 - 1.0 / maxFPS));
	exposure = pow(exposure, 1.0 / 2.2);					 
	
	#ifdef Enabled_TemportalAntiAliasing
		antialiasing = TemportalAntiAliasing(texcoord.st);

		color = max(vec3(0.0), InverseToneMapping(antialiasing) * 0.001);
	#endif

    #ifdef BLOOM_EFFECTS
		CalculateBloom(bloomData); 
		color = mix(color, bloomData.bloom, vec3(0.0100f * BLOOM_AMOUNT)); 
		AddRainFogScatter(color, bloomData);
	#endif

	color = pow(color, vec3(1.0 / 2.2));
	antialiasing = pow(antialiasing, vec3(1.0 / 2.2));

	/* DRAWBUFFERS:67 */
    gl_FragData[0] = vec4(color, exposure);
	gl_FragData[1] = vec4(antialiasing, exposure);
}