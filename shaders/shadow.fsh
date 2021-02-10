#version 120

//#define WATER_SPEED_LIGHT_BAR_LINKER

uniform sampler2D tex;

uniform sampler2D noisetex;

uniform mat4 gbufferModelView;

uniform float frameTimeCounter;
uniform float screenBrightness;

varying vec3 shadowViewPosition;
varying vec3 shadowLightVector;

varying vec4 texcoord;
varying vec4 color;
varying vec3 normal;
varying vec3 tangent;
varying vec3 binormal;
varying vec3 rawNormal;

varying float materialIDs;
varying float iswater;
varying float isStainedGlass;

varying vec4 lmcoord;

#define WATER_SPEED 1.0    //[0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2.0 2.1 2.32.4 2.5 2.6 2.7 2.8 2.9 3.0 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4.0]
#define WAVE_HEIGHT 0.75 //[0.0 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2.0 2.05 2.1 2.15 2.2 2.25 2.3 2.35 2.4 2.45 2.5 2.55 2.6 2.65 2.7 2.75 2.8 2.85 2.9 2.95 3.0 3.05 3.1 3.15 3.2 3.25 3.3 3.35 3.4 3.45 3.5 3.55 3.6 3.65 3.7 3.75 3.8 3.85 3.9 3.95 4.0 4.05 4.1] 

#include "/lib/common.glsl"
#include "/lib/lighting/lighting.glsl"

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

float Parabola(in float x, in float k)
{
	x / 2.0f;
	return pow(4.0f * x * (1.0f - x), k);
}

float AlmostIdentity(in float x, in float m, in float n)
{
	if (x > m) return x;

	float a = 2.0f * n - m;
	float b = 2.0f * m - 3.0f * n;
	float t = x / m;

	return (a * t + b) * t * t + n;
}

float GetWaves(vec3 position, in float scale) {
  float speed = 0.9f;

float waveWaterSpeed = WATER_SPEED;
#ifdef WATER_SPEED_LIGHT_BAR_LINKER
      waveWaterSpeed *= pow(screenBrightness * 2.0f, 4.0);
#endif
#define FRAME_TIME frameTimeCounter * waveWaterSpeed

  //speed = mix(speed, 0.0f, isice);

  vec2 p = position.xz / 20.0f;

  p.xy -= position.y / 20.0f;

  p.x = -p.x;

  p.x += (FRAME_TIME / 40.0f) * speed;
  p.y -= (FRAME_TIME / 40.0f) * speed;

  float weight = 1.0f;
  float weights = weight;

  float allwaves = 0.0f;

  float wave = textureSmooth(noisetex, (p * vec2(2.0f, 1.2f))  + vec2(0.0f,  p.x * 2.1f) ).x; 			p /= 2.1f; 	/*p *= pow(2.0f, 1.0f);*/ 	p.y -= (FRAME_TIME / 20.0f) * speed; p.x -= (FRAME_TIME / 30.0f) * speed;
  allwaves += wave;

  weight = 4.1f;
  weights += weight;
      wave = textureSmooth(noisetex, (p * vec2(2.0f, 1.4f))  + vec2(0.0f,  -p.x * 2.1f) ).x;	p /= 1.5f;/*p *= pow(2.0f, 2.0f);*/ 	p.x += (FRAME_TIME / 20.0f) * speed;
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

  allwaves /= weights;

  return allwaves;
}

vec3 GetWavesNormal(vec3 position, in float scale, in mat3 tbnMatrix) {

	//vec4 modelView = (shadowViewPosition);

	vec3 viewVector = normalize(tbnMatrix * position);

		 viewVector = normalize(viewVector);

	const float sampleDistance = 13.0f;

	position -= vec3(0.005f, 0.0f, 0.005f) * sampleDistance;

	float wavesCenter = GetWaves(position, scale);
	float wavesLeft = GetWaves(position + vec3(0.01f * sampleDistance, 0.0f, 0.0f), scale);
	float wavesUp   = GetWaves(position + vec3(0.0f, 0.0f, 0.01f * sampleDistance), scale);

	vec3 wavesNormal;
		 wavesNormal.r = wavesCenter - wavesLeft;
		 wavesNormal.g = wavesCenter - wavesUp;

		 wavesNormal.r *= 20.0f * WAVE_HEIGHT / sampleDistance;
		 wavesNormal.g *= 20.0f * WAVE_HEIGHT / sampleDistance;

		//  wavesNormal.b = sqrt(1.0f - wavesNormal.r * wavesNormal.r - wavesNormal.g * wavesNormal.g);
     wavesNormal.b = 1.0;
		 wavesNormal.rgb = normalize(wavesNormal.rgb);



	return wavesNormal.rgb;
}

void main() {

	vec4 tex = texture2D(tex, texcoord.st, 0) * color;

	//if(tex.a < 0.2 && iswater < 0.5) discard;
	//tex.a = 1.0;

	//tex.rgb = vec3(0.0);

	//tex.rgb = pow(tex.rgb, vec3(1.1f));


	float NdotL = 1.0;

	//tex.rgb = normalize(tex.rgb) * pow(length(tex.rgb), 0.5);

	float skylight = clamp((lmcoord.t * 33.05f / 32.0f) - 1.05f / 32.0f, 0.0f, 1.0f);

	vec3 toLight = normal.xyz;

	vec3 shadowNormal = normal.xyz;

	bool isTranslucent = abs(materialIDs - 3.0f) < 0.1f
					  //|| abs(materialIDs - 2.0f) < 0.1f
					  || abs(materialIDs - 4.0f) < 0.1f
					  //|| abs(materialIDs - 11.0f) < 0.1f
					  ;

	if (isTranslucent)
	{
		shadowNormal = vec3(0.0f, 0.0f, 0.0f);
		NdotL = 1.0f;
	}

	//tex.rgb *= pow(skylight, 10.0);

	float na = skylight * 0.8 + 0.2;

	if (isStainedGlass > 0.5) {
		//tex.rgba = vec4(1.0);
	}

	if(iswater > 0.5) {
		mat3 tbn = mat3(tangent, binormal, normal);
		vec3 n = GetWavesNormal(shadowViewPosition, 1.0, tbn);

		vec3 F0 = vec3(0.02);

		float cosTheta = max(0.0, dot(n, shadowLightVector));

		vec3 v = -shadowLightVector;
		vec3 l = normalize(reflect(shadowLightVector, n));
		vec3 h = normalize(l + v);

		vec3 f = SchlickFresnel(F0, max(0.0, dot(h, v)));
		vec3 kD = 1.0 - f;
	
		//float light = 1.0 - f;

		tex.rgb = kD * cosTheta;
		tex.a = 1.0;
	}

	if (normal.z < 0.0)
	{
		tex.rgb = vec3(0.0);
	}

	if(tex.a < 0.2) discard;

	gl_FragData[0] = vec4(tex.rgb, tex.a);
	gl_FragData[1] = vec4(shadowNormal.xyz * 0.5 + 0.5, na);
}
