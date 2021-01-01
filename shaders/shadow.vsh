#version 120

#define SHADOW_MAP_BIAS 0.9

varying vec4 texcoord;
varying vec4 vPosition;
varying vec4 color;
varying vec4 lmcoord;

attribute vec4 mc_Entity;

varying float materialIDs;

uniform sampler2D noisetex;
uniform float frameTimeCounter;
uniform int worldTime;
uniform float rainStrength;
uniform vec3 cameraPosition;

uniform mat4 shadowProjectionInverse;
uniform mat4 shadowProjection;
uniform mat4 shadowModelViewInverse;
uniform mat4 shadowModelView;
uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;



#define ANIMATION_SPEED 1.0f

//#define ANIMATE_USING_WORLDTIME

#define WAVE_PLANT_SPEED 1.0    //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3.0 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4.0 4.1 4.2 4.3 4.4 4.5 4.6 4.7 4.8 4.9 5.0 5.1 5.2 5.3 5.4 5.5 5.6 5.7 5.8 5.9 6.0] 

#ifdef ANIMATE_USING_WORLDTIME
#define FRAME_TIME worldTime * ANIMATION_SPEED / 20.0f
#else
#define FRAME_TIME frameTimeCounter * ANIMATION_SPEED
#endif

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


vec4 TextureSmooth(in sampler2D tex, in vec2 coord)
{
	int resolution = 64;

	coord *= resolution;
	vec2 i = floor(coord);
	vec2 f = fract(coord);
		 f = f * f * (3.0f - 2.0f * f);

	coord = (i + f) / resolution;

	vec4 result = texture2D(tex, coord);

	return result;
}

void main() {
	gl_Position = ftransform();

	lmcoord = gl_TextureMatrix[1] * gl_MultiTexCoord1;
	texcoord = gl_MultiTexCoord0;

	vec4 position = gl_Position;

		 //position *= position.w;

		 position = shadowProjectionInverse * position;
		 position = shadowModelViewInverse * position;
		 position.xyz += cameraPosition.xyz;
		 //position = gbufferModelView * position;

	//convert to world-space position

	materialIDs = 0.0f;

	//Grass
	if	(  mc_Entity.x == 31.0

		|| mc_Entity.x == 59.0f		//Wheat
		|| mc_Entity.x == 1925.0f	//Biomes O Plenty: Medium Grass
		|| mc_Entity.x == 1920.0f	//Biomes O Plenty: Thorns, barley
		|| mc_Entity.x == 1921.0f	//Biomes O Plenty: Sunflower

		)
	{
		materialIDs = max(materialIDs, 2.0f);
	}

	float grassWeight = mod(texcoord.t * 16.0f, 1.0f / 16.0f);

	float lightWeight = clamp((lmcoord.t * 33.05f / 32.0f) - 1.05f / 32.0f, 0.0f, 1.0f);
		  lightWeight *= 1.1f;
		  lightWeight -= 0.1f;
		  lightWeight = max(0.0f, lightWeight);
		  lightWeight = pow(lightWeight, 5.0f);

		  if (grassWeight < 0.01f) {
			grassWeight = 1.0f;
		  } else {
			grassWeight = 0.0f;
		  }

	//Waving grass
	//Waving grass
	if (materialIDs == 2.0f)
	{
		vec2 angleLight = vec2(0.0f);
		vec2 angleHeavy = vec2(0.0f);
		vec2 angle		= vec2(0.0f);

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
			  windStrengthRandom = pow(windStrengthRandom, mix(2.0f, 1.0f, rainStrength));
			  windStrength *= mix(windStrengthRandom, 0.5f, rainStrength * 0.25f);
			  //windStrength = 1.0f;

		//heavy wind
		float heavyAxialFrequency			= 8.0f * WAVE_PLANT_SPEED;
		float heavyAxialWaveLocalization	= 0.9f;
		float heavyAxialRandomization		= 13.0f;
		float heavyAxialAmplitude			= 15.0f;
		float heavyAxialOffset				= 15.0f;

		float heavyLateralFrequency			= 6.732f * WAVE_PLANT_SPEED;
		float heavyLateralWaveLocalization	= 1.274f;
		float heavyLateralRandomization		= 1.0f;
		float heavyLateralAmplitude			= 6.0f;
		float heavyLateralOffset			= 0.0f;

		//light wind
		float lightAxialFrequency			= 5.5f * WAVE_PLANT_SPEED;
		float lightAxialWaveLocalization	= 1.1f;
		float lightAxialRandomization		= 21.0f;
		float lightAxialAmplitude			= 5.0f;
		float lightAxialOffset				= 5.0f;

		float lightLateralFrequency			= 5.9732f * WAVE_PLANT_SPEED;
		float lightLateralWaveLocalization	= 1.174f;
		float lightLateralRandomization		= 0.0f;
		float lightLateralAmplitude			= 1.0f;
		float lightLateralOffset			= 0.0f;

		float windStrengthCrossfade = clamp(windStrength * 2.0f - 1.0f, 0.0f, 1.0f);
		float lightWindFade = clamp(windStrength * 2.0f, 0.2f, 1.0f);

		angleLight.x += sin(FRAME_TIME * lightAxialFrequency		- p.x * lightAxialWaveLocalization		+ stoch.x * lightAxialRandomization)	* lightAxialAmplitude		+ lightAxialOffset;
		angleLight.y += sin(FRAME_TIME * lightLateralFrequency	- p.x * lightLateralWaveLocalization	+ stoch.x * lightLateralRandomization)	* lightLateralAmplitude		+ lightLateralOffset;

		angleHeavy.x += sin(FRAME_TIME * heavyAxialFrequency		- p.x * heavyAxialWaveLocalization		+ stoch.x * heavyAxialRandomization)	* heavyAxialAmplitude		+ heavyAxialOffset;
		angleHeavy.y += sin(FRAME_TIME * heavyLateralFrequency	- p.x * heavyLateralWaveLocalization	+ stoch.x * heavyLateralRandomization)	* heavyLateralAmplitude		+ heavyLateralOffset;

		angle = mix(angleLight * lightWindFade, angleHeavy, vec2(windStrengthCrossfade));
		angle *= 2.0f;

		// //Rotate block pivoting from bottom based on angle
		position.x += (sin((angle.x / 180.0f) * 3.141579f)) * grassWeight * lightWeight 					* 1.0f;
		position.z += (sin((angle.y / 180.0f) * 3.141579f)) * grassWeight * lightWeight 					* 1.0f;
		position.y += (cos(((angle.x + angle.y) / 180.0f) * 3.141579f) - 1.0f)	* grassWeight * lightWeight * 1.0f;
	}


	//position = gbufferModelViewInverse * position;
	position.xyz -= cameraPosition.xyz;
	position = shadowModelView * position;
	position = shadowProjection * position;

	float iswater = 0.0;

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
if (iswater > 0.5 || isice > 0.5)
{
position.xyz += 10000.0;
}

	gl_Position = position;

	float dist = sqrt(gl_Position.x * gl_Position.x + gl_Position.y * gl_Position.y);
	float distortFactor = (1.0f - SHADOW_MAP_BIAS) + dist * SHADOW_MAP_BIAS;

	gl_Position.xy *= 1.0f / distortFactor;

	vPosition = gl_Position;

	gl_FrontColor = gl_Color;
	color = gl_Color;

}