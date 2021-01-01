#version 120

#define WAVE_HEIGHT 0.75f

#define WATER_PARALLAX

uniform sampler2D texture;
uniform sampler2D specular;
uniform sampler2D normals;
uniform sampler2D noisetex;

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferPreviousProjection;

uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferPreviousModelView;

uniform vec3 cameraPosition;
uniform vec3 previousCameraPosition;

uniform float frameTimeCounter;
uniform int worldTime;

uniform float rainStrength;

varying vec3 normal;
varying vec3 globalNormal;
varying vec3 tangent;
varying vec3 binormal;
varying vec3 viewVector;

varying vec4 color;
varying vec4 texcoord;
varying vec4 lmcoord;
varying vec3 worldPosition;
varying vec4 vertexPos;
varying float distance;

varying float iswater;
varying float isice;
varying float isStainedGlass;

#define ANIMATION_SPEED 1.0f


/* DRAWBUFFERS:02367 */



#define FRAME_TIME frameTimeCounter * ANIMATION_SPEED

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

  speed = mix(speed, 0.0f, isice);

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

vec3 GetWaterParallaxCoord(in vec3 position, in vec3 viewVector)
{
	vec3 parallaxCoord = position.xyz;

	vec3 stepSize = vec3(0.6f * WAVE_HEIGHT, 0.6f * WAVE_HEIGHT, 0.6f);

	float waveHeight = GetWaves(position, 1.0f);

		vec3 pCoord = vec3(0.0f, 0.0f, 1.0f);

		vec3 step = viewVector * stepSize;
		float distAngleWeight = ((distance * 0.2f) * (2.1f - viewVector.z)) / 2.0f;
		distAngleWeight = 1.0f;
		step *= distAngleWeight;

		float sampleHeight = waveHeight;

		for (int i = 0; sampleHeight < pCoord.z && i < 120; ++i)
		{
			pCoord.xy = mix(pCoord.xy, pCoord.xy + step.xy, clamp((pCoord.z - sampleHeight) / (stepSize.z * 0.2f * distAngleWeight / (-viewVector.z + 0.05f)), 0.0f, 1.0f));
			pCoord.z += step.z;
			//pCoord += step;
			sampleHeight = GetWaves(position + vec3(pCoord.x, 0.0f, pCoord.y), 1.0f);
		}

	parallaxCoord = position.xyz + vec3(pCoord.x, 0.0f, pCoord.y);

	return parallaxCoord;
}

vec3 GetWavesNormal(vec3 position, in float scale, in mat3 tbnMatrix) {

	vec4 modelView = (gl_ModelViewMatrix * vertexPos);

	vec3 viewVector = normalize(tbnMatrix * modelView.xyz);

		 viewVector = normalize(viewVector);


	#ifdef WATER_PARALLAX
	position = GetWaterParallaxCoord(position, viewVector);
	#endif


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

	vec4 tex = texture2D(texture, texcoord.st);
		 tex.a = 0.85f;

	float zero = 1.0f;
	float transx = 0.0f;
	float transy = 0.0f;
	//float iswater = 0.0f;

	float texblock = 0.0625f;

	bool backfacing = false;

	if (viewVector.z > 0.0f) {
		backfacing = true;
	} else {
		backfacing = false;
	}


	if (iswater > 0.5f && !backfacing) {
		vec4 albedo = texture2D(texture, texcoord.st).rgba;
		float lum = albedo.r + albedo.g + albedo.b;
			  lum /= 3.0f;

			  lum = pow(lum, 1.0f) * 1.0f;
			  lum += 0.0f;

		vec3 waterColor = color.rgb;

		waterColor = normalize(waterColor);

		tex = vec4(0.1f, 0.7f, 1.0f, 210.0f/255.0f);
		tex.rgb *= 0.4f * waterColor.rgb;
		// tex.rgb *= vec3(lum * 2.0);

		// tex = vec4(color.r, color.g, color.b, 0.4f);
		// tex.rgb *= vec3(0.9f, 1.0f, 0.1f) * 0.8f;

	} else if (iswater > 0.5f && backfacing) {
		tex = vec4(0.0, 0.0, 0.0f, 30.0f / 255.0f);
	}

	//store lightmap in auxilliary texture. r = torch light. g = lightning. b = sky light.

	//Separate lightmap types
	vec4 lightmap = vec4(0.0f, 0.0f, 0.0f, 1.0f);
	lightmap.r = clamp((lmcoord.s * 33.05f / 32.0f) - 1.05f / 32.0f, 0.0f, 1.0f);
	lightmap.b = clamp((lmcoord.t * 33.05f / 32.0f) - 1.05f / 32.0f, 0.0f, 1.0f);

	lightmap.b = pow(lightmap.b, 1.0f);
	lightmap.r = pow(lightmap.r, 3.0f);







	float matID = 4.0f;

	if (iswater > 0.5f)
	{
			matID = 35.0f;
	}

	if (isice > 0.5)
	{
		matID = 4;
	}

	if (isStainedGlass > 0.5)
	{
		matID = 55.0;
	}


	matID += 0.1f;

  // gl_FragData[0] = vec4(tex.rgb, 0.2);
	gl_FragData[0] = vec4(vec3(0.0, 0.0, 0.0), 0.2);
	//gl_FragData[1] = vec4(matID / 255.0f, lightmap.r, lightmap.b, 1.0);






	mat3 tbnMatrix = mat3 (tangent.x, binormal.x, normal.x,
							tangent.y, binormal.y, normal.y,
					     	tangent.z, binormal.z, normal.z);




	vec3 wavesNormal = GetWavesNormal(worldPosition, 1.0f, tbnMatrix);
	//vec3 wavesNormal = vec3(0.0f, 0.0f, 1.0f);


	vec3 waterNormal = wavesNormal * tbnMatrix;
	vec3 texNormal = texture2D(normals, texcoord.st).rgb * 2.0f - 1.0f;
		 texNormal = texNormal * tbnMatrix;


	waterNormal = mix(waterNormal, texNormal, isice + isStainedGlass);


	gl_FragData[1] = vec4(waterNormal.rgb * 0.5 + 0.5, 1.0f);


	vec4 spec = texture2D(specular, texcoord.st);

	gl_FragData[2] = vec4(spec.r, spec.b, 0.0f, 1.0);


	//gl_FragData[5] = vec4(lightmap.rgb, 0.0f);
	gl_FragData[3] = vec4(0.0f, lightmap.b, matID / 255.0f, 1.0f);
	gl_FragData[4] = vec4(texture2D(texture, texcoord.st).rgb, 1.0);


	//gl_FragData[7] = vec4(globalNormal * 0.5f + 0.5f, 1.0);
}
