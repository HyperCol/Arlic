#version 120

#define SHADOW_MAP_BIAS 0.90


varying vec4 texcoord;
varying vec4 vPosition;
varying vec4 color;
varying vec4 lmcoord;

varying vec3 normal;
varying vec3 tangent;
varying vec3 binormal;
varying vec3 rawNormal;
varying vec3 shadowLightVector;

varying vec3 shadowViewPosition;

attribute vec4 mc_Entity;
attribute vec4 at_tangent;

varying float materialIDs;
varying float iswater;
varying float isStainedGlass;
uniform float screenBrightness;

uniform sampler2D noisetex;
uniform float frameTimeCounter;
uniform float rainStrength;
uniform vec3 cameraPosition;
uniform vec3 shadowLightPosition;

uniform mat4 shadowProjectionInverse;
uniform mat4 shadowProjection;
uniform mat4 shadowModelViewInverse;
uniform mat4 shadowModelView;
uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjection;

#define WAVING_GRASS
#define WAVING_WHEAT
#define WAVING_LEAVES
#define WAVING_VINES
#define WAVING_LILIES
#define WAVING_LAVA

#define GRASS_MOVEMENT  0.85 //[0.00000085 0.000085 0.0085 0.55 0.65 0.85 0.95 1.0]Default is 0.85, Lower nimbers means slower
#define GRASS_SPEED     1.0  //[1.0 100.0 500.0 1000.0 5000.0]Default is 1.0, Higher numbers means slower

#define PLANT_WAVE_SPEED 1.0 //[0.25 0.5 0.75 1.0 1.5 2.0 2.5 3.0 3.5 4.0 4.5 5.0 5.5 6.0 6.5 7.0 7.5 8.0 8.5 9.0 9.5 10.0 11.0 12.0 13.0 14.0 15.0 16.0 17.0] //Lower numbers means faster, Higher numbers means slower
//#define PLANT_SPEED_LIGHT_BAR_LINKER


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
	int resolution = 64;

	coord *= resolution;

	float fx = fract(coord.x);
    float fy = fract(coord.y);
    coord.x -= fx;
    coord.y -= fy;

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

vec3 calcLavaMove(in vec3 pos) {
	float fy = fract(pos.y + 0.001);
  float PIs = 3.1415927;
	if (fy > 0.002) {
		float wave = 0.05 * sin(2 * PIs / 4 * frameTimeCounter / 3 + 2 * PIs * 2 / 16 * pos.x + 2 * PIs * 5 / 16 * pos.z)
				   + 0.05 * sin(2 * PIs / 3 * frameTimeCounter / 3 - 2 * PIs * 3 / 16 * pos.x + 2 * PIs * 4 / 16 * pos.z);
		return vec3(0, clamp(wave, -fy, 1.0-fy), 0);
	} else {
		return vec3(0);
	}
}

vec4 TextureSmooth(in sampler2D tex, in vec2 coord)
{
	int level = 0;
	vec2 res = vec2(64.0f);
	coord = coord * res;
	vec2 i = floor(coord);
	vec2 f = fract(coord);
	f = f * f * (3.0f - 2.0f * f);
	//f = 1.0f - (cos(f * 3.1415f) * 0.5f + 0.5f);

	//i -= vec2(0.5f);

	vec2 icoordCenter 		= i / res;
	vec2 icoordRight 		= (i + vec2(1.0f, 0.0f)) / res;
	vec2 icoordUp	 		= (i + vec2(0.0f, 1.0f)) / res;
	vec2 icoordUpRight	 	= (i + vec2(1.0f, 1.0f)) / res;


	vec4 texCenter 	= texture2DLod(tex, icoordCenter, 	level);
	vec4 texRight 	= texture2DLod(tex, icoordRight, 	level);
	vec4 texUp 		= texture2DLod(tex, icoordUp, 		level);
	vec4 texUpRight	= texture2DLod(tex, icoordUpRight,  level);

	texCenter = mix(texCenter, texUp, vec4(f.y));
	texRight  = mix(texRight, texUpRight, vec4(f.y));

	vec4 result = mix(texCenter, texRight, vec4(f.x));
	return result;
}

float Impulse(in float x, in float k)
{
	float h = k*x;
    return pow(h*exp(1.0f-h), 5.0f);
}

float RepeatingImpulse(in float x, in float scale)
{
	float time = x;
		  time = mod(time, scale);

	return Impulse(time, 3.0f / scale);
}

vec3 nvec3(vec4 x){
	return x.xyz / x.w;
}

void main() {
	gl_Position = ftransform();

	lmcoord = gl_TextureMatrix[1] * gl_MultiTexCoord1;
	texcoord = gl_MultiTexCoord0;

	// /shadowLightVector = nvec3(gbufferModelViewInverse * vec4(normalize(shadowLightPosition), 1.0));
	shadowLightVector = mat3(gbufferModelViewInverse) * normalize(shadowLightPosition);
	shadowViewPosition = vec3(gbufferModelViewInverse * gbufferModelView * gl_Vertex);

	vec4 position = gl_Position;

		 //position *= position.w;

		 position = shadowProjectionInverse * position;
		 position = shadowModelViewInverse * position;
		 position.xyz += cameraPosition.xyz;
		 //position = gbufferModelView * position;

	float waveCoeff = 0.0f;
	//convert to world-space position

	materialIDs = 0.0f;


	iswater = 0.0;

	if (mc_Entity.x == 1971.0f)
	{
		iswater = 1.0f;
	}

	if (mc_Entity.x == 8 || mc_Entity.x == 9) {
		iswater = 1.0f;
	}

	float isice = 0.0f;


	
	if (mc_Entity.x == 79) {
		isice = 1.0f;
	}

	isStainedGlass = 0.0f;

	if (mc_Entity.x == 95 || mc_Entity.x == 160)
	{
		isStainedGlass = 1.0f;
	}


	//Grass
	if  (  mc_Entity.x == 31.0

		|| mc_Entity.x == 38.0f 	//Rose
		|| mc_Entity.x == 37.0f 	//Flower
		|| mc_Entity.x == 1925.0f 	//Biomes O Plenty: Medium Grass
		|| mc_Entity.x == 1920.0f 	//Biomes O Plenty: Thorns, barley
		|| mc_Entity.x == 1921.0f 	//Biomes O Plenty: Sunflower
		|| mc_Entity.x == 188.0f 	//Biomes O Plenty: Medium Grass
		|| mc_Entity.x == 176.0f 	//Biomes O Plenty: Desert Grass
		|| mc_Entity.x == 177.0f 	//Biomes O Plenty: Desert Grass
		|| mc_Entity.x == 178.0f 	//Lavender

		)
	{
			materialIDs = max(materialIDs, 2.0f);
	}

	//Wheat
	if (mc_Entity.x == 59.0) {
		materialIDs = max(materialIDs, 2.0f);
	}	
	
	//Leaves
	if   ( mc_Entity.x == 18.0 

		|| mc_Entity.x == 161.0f
		|| mc_Entity.x == 1962.0f //Biomes O Plenty: Leaves
		|| mc_Entity.x == 1924.0f //Biomes O Plenty: Leaves
		|| mc_Entity.x == 1923.0f //Biomes O Plenty: Leaves
		|| mc_Entity.x == 1926.0f //Biomes O Plenty: Leaves
		|| mc_Entity.x == 1936.0f //Biomes O Plenty: Giant Flower Leaves
		|| mc_Entity.x == 184.0f  //Yellow autumn leaves
		|| mc_Entity.x == 185.0f  //Dying leaves
		|| mc_Entity.x == 186.0f  //maple leaves
		|| mc_Entity.x == 187.0f  //maple leaves
		|| mc_Entity.x == 192.0f  //maple leaves
		|| mc_Entity.x == 249.0f  //Willow leaves
		|| mc_Entity.x == 248.0f  //Sacred Oak Leaves

		 ) {
		materialIDs = max(materialIDs, 3.0f);
	}
		
	//Ice
	if (  mc_Entity.x == 79.0f
	   || mc_Entity.x == 174.0f)
	{
		materialIDs = max(materialIDs, 4.0f);
	}

	//Cobweb
	if ( mc_Entity.x == 30.0f)
	{
		materialIDs = max(materialIDs, 11.0f);
	}

float Plants_Speed = PLANT_WAVE_SPEED;
   #ifdef PLANT_SPEED_LIGHT_BAR_LINKER
      Plants_Speed *= pow(screenBrightness * 2.0f, 4.0);
   #endif
#define FRAME_TIME frameTimeCounter * Plants_Speed


	float tick = FRAME_TIME;
	
	
float grassWeight = mod(texcoord.t * 16.0f, 1.0f / 16.0f);
float vineweight = mod(texcoord.t * 1.0f, 1.0f / 0.20f);


float lightWeight = clamp((lmcoord.t * 33.05f / 32.0f) - 1.05f / 32.0f, 0.0f, 1.0f);
	  lightWeight *= 1.1f;
	  lightWeight -= 0.1f;
	  lightWeight = max(0.0f, lightWeight);
	  lightWeight = pow(lightWeight, 5.0f);
	  
	  // if (texcoord.t < 0.65f) {
	  // 	grassWeight = 1.0f;
	  // } else {
	  // 	grassWeight = 0.0f;
	  // }	 

	  if (grassWeight < 0.01f) {
	  	grassWeight = 1.0f;
	  } else {
	  	grassWeight = 0.0f;
	  }

const float pi = 3.14159265358979323846264;

position.xyz += cameraPosition.xyz;
	
	  #ifdef WAVING_GRASS
	//Waving grass
	if (waveCoeff > 0.5f)
	{
		vec2 angleLight = vec2(0.0f);
		vec2 angleHeavy = vec2(0.0f);
		vec2 angle 		= vec2(0.0f);

		vec3 pn0 = position.xyz;
			 pn0.x -= FRAME_TIME / 3.0f;

		vec3 stoch = BicubicTexture(noisetex, pn0.xz / 64.0f).xyz;
		vec3 stochLarge = BicubicTexture(noisetex, position.xz / (64.0f * 6.0f)).xyz;

		vec3 pn = position.xyz;
			 pn.x *= 2.0f;
			 pn.x -= FRAME_TIME * 15.0f;
			 pn.z *= 8.0f;

		vec3 stochLargeMoving = BicubicTexture(noisetex, pn.xz / (64.0f * 10.0f)).xyz;



		vec3 p = position.xyz;
		 	 p.x += sin(p.z / 2.0f) * 1.0f;
		 	 p.xz += stochLarge.rg * 5.0f;

		float windStrength = mix(0.85f, 1.0f, rainStrength);
		float windStrengthRandom = stochLargeMoving.x;
			  windStrengthRandom = pow(GRASS_MOVEMENT * windStrengthRandom, mix(2.0f, 1.0f, rainStrength));
			  windStrength *= mix(windStrengthRandom, 0.5f, rainStrength * 0.25f);
			  //windStrength = 1.0f;

		//heavy wind
		float heavyAxialFrequency 			= 8.0f;
		float heavyAxialWaveLocalization 	= 0.9f;
		float heavyAxialRandomization 		= 13.0f;
		float heavyAxialAmplitude 			= 15.0f;
		float heavyAxialOffset 				= 15.0f;

		float heavyLateralFrequency 		= 6.732f;
		float heavyLateralWaveLocalization 	= 1.274f;
		float heavyLateralRandomization 	= 1.0f;
		float heavyLateralAmplitude 		= 6.0f;
		float heavyLateralOffset 			= 0.0f;

		//light wind
		float lightAxialFrequency 			= 5.5f;
		float lightAxialWaveLocalization 	= 1.1f;
		float lightAxialRandomization 		= 21.0f;
		float lightAxialAmplitude 			= 5.0f;
		float lightAxialOffset 				= 5.0f;

		float lightLateralFrequency 		= 5.9732f;
		float lightLateralWaveLocalization 	= 1.174f;
		float lightLateralRandomization 	= 0.0f;
		float lightLateralAmplitude 		= 1.0f;
		float lightLateralOffset 			= 0.0f;

		float windStrengthCrossfade = clamp(windStrength * 2.0f - 1.0f, 0.0f, 1.0f);
		float lightWindFade = clamp(windStrength * 2.0f, 0.2f, 1.0f);

		angleLight.x += sin(FRAME_TIME / GRASS_SPEED * lightAxialFrequency 		- p.x * lightAxialWaveLocalization		+ stoch.x * lightAxialRandomization) 	* lightAxialAmplitude 		+ lightAxialOffset;	
		angleLight.y += sin(FRAME_TIME / GRASS_SPEED * lightLateralFrequency 	- p.x * lightLateralWaveLocalization 	+ stoch.x * lightLateralRandomization) 	* lightLateralAmplitude  	+ lightLateralOffset;

		angleHeavy.x += sin(FRAME_TIME / GRASS_SPEED * heavyAxialFrequency 		- p.x * heavyAxialWaveLocalization		+ stoch.x * heavyAxialRandomization) 	* heavyAxialAmplitude 		+ heavyAxialOffset;	
		angleHeavy.y += sin(FRAME_TIME / GRASS_SPEED * heavyLateralFrequency 	- p.x * heavyLateralWaveLocalization 	+ stoch.x * heavyLateralRandomization) 	* heavyLateralAmplitude  	+ heavyLateralOffset;

		angle = mix(angleLight * lightWindFade, angleHeavy, vec2(windStrengthCrossfade));
		angle *= 2.0f;

		// //Rotate block pivoting from bottom based on angle
		position.x += (sin((angle.x / 180.0f) * 3.141579f)) * grassWeight * lightWeight						* 1.0f	;
		position.z += (sin((angle.y / 180.0f) * 3.141579f)) * grassWeight * lightWeight						* 1.0f	;
		position.y += (cos(((angle.x + angle.y) / 180.0f) * 3.141579f) - 1.0f)  * grassWeight * lightWeight	* 1.0f	;
	}
	  #endif


  #ifdef WAVING_WHEAT
//Wheat//
	if (mc_Entity.x == 59.0 && texcoord.t < 0.35) {
		float speed = 0.1;
		
		float magnitude = sin((tick * pi / (28.0)) + position.x + position.z) * 0.12 + 0.02;
			  magnitude *= grassWeight * 0.2f;
			  magnitude *= lightWeight;
		float d0 = sin(tick * pi / (122.0 * speed)) * 3.0 - 1.5 + position.z;
		float d1 = sin(tick * pi / (152.0 * speed)) * 3.0 - 1.5 + position.x;
		float d2 = sin(tick * pi / (122.0 * speed)) * 3.0 - 1.5 + position.x;
		float d3 = sin(tick * pi / (152.0 * speed)) * 3.0 - 1.5 + position.z;
		position.x += sin((tick * pi / (28.0 * speed)) + (position.x + d0) * 0.1 + (position.z + d1) * 0.1) * magnitude;
		position.z += sin((tick * pi / (28.0 * speed)) + (position.z + d2) * 0.1 + (position.x + d3) * 0.1) * magnitude;
	}
	
	//small leaf movement
	if (mc_Entity.x == 59.0 && texcoord.t < 0.35) {
		float speed = 0.04;
		
		float magnitude = (sin(((position.y + position.x)/2.0 + tick * pi / ((28.0)))) * 0.025 + 0.075) * 0.2;
			  magnitude *= grassWeight;
			  magnitude *= lightWeight;
		float d0 = sin(tick * pi / (112.0 * speed)) * 3.0 - 1.5;
		float d1 = sin(tick * pi / (142.0 * speed)) * 3.0 - 1.5;
		float d2 = sin(tick * pi / (112.0 * speed)) * 3.0 - 1.5;
		float d3 = sin(tick * pi / (142.0 * speed)) * 3.0 - 1.5;
		position.x += sin((tick * pi / (18.0 * speed)) + (-position.x + d0)*1.6 + (position.z + d1)*1.6) * magnitude * (1.0f + rainStrength * 2.0f);
		position.z += sin((tick * pi / (18.0 * speed)) + (position.z + d2)*1.6 + (-position.x + d3)*1.6) * magnitude * (1.0f + rainStrength * 2.0f);
		position.y += sin((tick * pi / (11.0 * speed)) + (position.z + d2) + (position.x + d3)) * (magnitude/3.0) * (1.0f + rainStrength * 2.0f);
	}
  #endif


	
	
  #ifdef WAVING_LEAVES
//Leaves//
		
	if (materialIDs == 3.0f && texcoord.t < 1.90 && texcoord.t > -1.0) {
		float speed = 0.05;


			  //lightWeight = max(0.0f, 1.0f - (lightWeight * 5.0f));
		
		float magnitude = (sin((position.y + position.x + tick * pi / ((28.0) * speed))) * 0.15 + 0.15) * 0.30 * lightWeight;
			  // magnitude *= grassWeight;
			  magnitude *= lightWeight;
		float d0 = sin(tick * pi / (112.0 * speed)) * 3.0 - 1.5;
		float d1 = sin(tick * pi / (142.0 * speed)) * 3.0 - 1.5;
		float d2 = sin(tick * pi / (132.0 * speed)) * 3.0 - 1.5;
		float d3 = sin(tick * pi / (122.0 * speed)) * 3.0 - 1.5;
		position.x += sin((tick * pi / (18.0 * speed)) + (-position.x + d0)*1.6 + (position.z + d1)*1.6) * magnitude * (1.0f + rainStrength * 1.0f);
		position.z += sin((tick * pi / (17.0 * speed)) + (position.z + d2)*1.6 + (-position.x + d3)*1.6) * magnitude * (1.0f + rainStrength * 1.0f);
		position.y += sin((tick * pi / (11.0 * speed)) + (position.z + d2) + (position.x + d3)) * (magnitude/2.0) * (1.0f + rainStrength * 1.0f);
		
	}
	

	//lower leaf movement
	if (materialIDs == 3.0f) {
		float speed = 0.075;


		
		float magnitude = (sin((tick * pi / ((28.0) * speed))) * 0.05 + 0.15) * 0.075 * lightWeight;
			  // magnitude *= 1.0f - grassWeight;
			  magnitude *= lightWeight;
		float d0 = sin(tick * pi / (122.0 * speed)) * 3.0 - 1.5;
		float d1 = sin(tick * pi / (142.0 * speed)) * 3.0 - 1.5;
		float d2 = sin(tick * pi / (162.0 * speed)) * 3.0 - 1.5;
		float d3 = sin(tick * pi / (112.0 * speed)) * 3.0 - 1.5;
		position.x += sin((tick * pi / (13.0 * speed)) + (position.x + d0)*0.9 + (position.z + d1)*0.9) * magnitude;
		position.z += sin((tick * pi / (16.0 * speed)) + (position.z + d2)*0.9 + (position.x + d3)*0.9) * magnitude;
		position.y += sin((tick * pi / (15.0 * speed)) + (position.z + d2) + (position.x + d3)) * (magnitude/1.0);
	}
  #endif

  #ifdef WAVING_VINES
    //large scale movement
    if(mc_Entity.x == 106.0 ) {
      float speed = 1.0;
      float magnitude = (sin(((position.y + position.x)/2.0 + tick * pi / ((88.0)))) * 0.05 + 0.15) * 0.26;
			magnitude *= vineweight;
			magnitude *= lightWeight;
		  float d0 = sin(tick * pi / (122.0 * speed)) * 3.0 - 1.5;
      float d1 = sin(tick * pi / (152.0 * speed)) * 3.0 - 1.5;
      float d2 = sin(tick * pi / (192.0 * speed)) * 3.0 - 1.5;
      float d3 = sin(tick * pi / (142.0 * speed)) * 3.0 - 1.5;
      position.x += sin((tick * pi / (16.0 * speed)) + (position.x + d0)*0.5 + (position.z + d1)*0.5 + (position.y)) * magnitude;
      position.z += sin((tick * pi / (18.0 * speed)) + (position.z + d2)*0.5 + (position.x + d3)*0.5 + (position.y)) * magnitude;
    }

    //small scale movement
    if(mc_Entity.x == 106.0 && texcoord.t < 0.20) {
      float speed = 1.0;
      float magnitude = (sin(((position.y + position.x)/8.0 + tick * pi / ((88.0)))) * 0.15 + 0.05) * 0.22;
      float d0 = sin(tick * pi / (112.0 * speed)) * 3.0 + 0.5;
      float d1 = sin(tick * pi / (142.0 * speed)) * 3.0 + 0.5;
      float d2 = sin(tick * pi / (112.0 * speed)) * 3.0 + 0.5;
      float d3 = sin(tick * pi / (142.0 * speed)) * 3.0 + 0.5;
      position.x += sin((tick * pi / (18.0 * speed)) + (-position.x + d0)*1.6 + (position.z + d1)*1.6) * magnitude;
      position.z += sin((tick * pi / (18.0 * speed)) + (position.z + d2)*1.6 + (-position.x + d3)*1.6) * magnitude;
      position.y += sin((tick * pi / (11.0 * speed)) + (position.z + d2) + (position.x + d3)) * (magnitude/4.0);
    }
  #endif

	#ifdef WAVING_LILIES
    //flowing water
    if(mc_Entity.x == 111.0 && texcoord.t > 0.05) {
      float speed = 2.7;
      float magnitude = (sin((tick * pi / ((28.0) * speed))) * 0.05 + 0.15) * 0.17;
      float d0 = sin(tick * pi / (132.0 * speed)) * 3.0 - 1.5;
      float d1 = sin(tick * pi / (132.0 * speed)) * 3.0 - 1.5;
      float d2 = sin(tick * pi / (132.0 * speed)) * 3.0 - 1.5;
      float d3 = sin(tick * pi / (132.0 * speed)) * 3.0 - 1.5;
      position.x += sin((tick * pi / (13.0 * speed)) + (position.x + d0)*0.9 + (position.z + d1)*0.9) * magnitude;
      position.y += sin((tick * pi / (15.0 * speed)) + (position.z + d2) + (position.x + d3)) * magnitude;
      position.y -= 0.04;
    }

    //still water
    if(mc_Entity.x == 111.0 && texcoord.t > 0.05) {
      float speed = 2.7;
      float magnitude = (sin((tick * pi / ((28.0) * speed))) * 0.05 + 0.15) * 0.17;
      float d0 = sin(tick * pi / (132.0 * speed)) * 3.0 - 1.5;
      float d1 = sin(tick * pi / (132.0 * speed)) * 3.0 - 1.5;
      float d2 = sin(tick * pi / (132.0 * speed)) * 3.0 - 1.5;
      float d3 = sin(tick * pi / (132.0 * speed)) * 3.0 - 1.5;
      position.x += sin((tick * pi / (13.0 * speed)) + (position.x + d0)*0.9 + (position.z + d1)*0.9) * magnitude;
      position.y += sin((tick * pi / (15.0 * speed)) + (position.z + d2) + (position.x + d3)) * magnitude;
      position.y -= 0.04;
    }
  #endif


  #ifdef WAVING_LAVA
    if(mc_Entity.x == 10.0 || mc_Entity.x == 11.0 ) {
      position.xyz += calcLavaMove(position.xyz + cameraPosition) * 0.25;
    }
  #endif

position.xyz -= cameraPosition.xyz;

	if (iswater > 0.5 || isice > 0.5)
	{
		//position.xyz += 10000.0;
	}


	//position = gbufferModelViewInverse * position;
	position.xyz -= cameraPosition.xyz;
	position = shadowModelView * position;
	position = shadowProjection * position;

	normal = normalize(gl_NormalMatrix * gl_Normal);
	tangent = normalize(gl_NormalMatrix * at_tangent.xyz);
  	binormal = cross(tangent, normal);

	vec3 worldNormal = gl_Normal;

	color = gl_Color;

	if (materialIDs != 2.0)
	{
		if (worldNormal.x > 0.85)
		{
			color.rgb *= 1.0 / 0.6;
		}
		if (worldNormal.x < -0.85)
		{
			color.rgb *= 1.0 / 0.6;
		}
		if (worldNormal.z > 0.85)
		{
			color.rgb *= 1.0 / 0.8;
		}
		if (worldNormal.z < -0.85)
		{
			color.rgb *= 1.0 / 0.8;
		}
		if (worldNormal.y < -0.85)
		{
			color.rgb *= 1.0 / 0.5;
		}
	}


	//position.z += pow(max(0.0, 1.0 - dot(normal, vec3(0.0, 0.0, 1.0))), 4.0) * 0.001;
	//position.z -= pow(clamp(dot(normal, vec3(0.0, 0.0, -1.0)) * 10.0, 0.0, 1.0), 1.0) * 0.016;


	gl_Position = position;



	float dist = sqrt(gl_Position.x * gl_Position.x + gl_Position.y * gl_Position.y);
	float distortFactor = (1.0f - SHADOW_MAP_BIAS) + dist * SHADOW_MAP_BIAS + 0.0;
	gl_Position.xy *= 0.95f / distortFactor;

	gl_Position.z = mix(gl_Position.z, 0.5, 0.8);

	//vec2 warp = abs(gl_Position.xy);
	

	//gl_Position.x /= warp.x * 0.90 + 0.1;
	//gl_Position.y /= warp.y * 0.9 + 0.1;




	vPosition = gl_Position;

	gl_FrontColor = gl_Color;


	
}
