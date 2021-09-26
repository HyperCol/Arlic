#version 330 compatibility

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
VacGrd is part of HyperCol Studios
Do not modify this code until you have read the LICENSE contained in the root directory of this shaderpack!

*/
#define SHADOW_MAP_BIAS 0.90

/////////ADJUSTABLE VARIABLES//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////ADJUSTABLE VARIABLES//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


#define ENABLE_SSAO	// Screen space ambient occlusion.
#define GI	// Indirect lighting from sunlight.

#define GI_QUALITY 0.5 // Number of GI samples. More samples=smoother GI. High performance impact! [0.5 1.0 2.0]
#define GI_ARTIFACT_REDUCTION // Reduces artifacts on back edges of blocks at the cost of performance.
#define GI_RENDER_RESOLUTION 0 // Render resolution of GI. 0 = High. 1 = Low. Set to 1 for faster but blurrier GI. [0 1]
#define GI_RADIUS 0.75 // How far indirect light can spread. Can help to reduce artifacts with low GI samples. [0.5 0.75 1.0]

#define WAVE_HEIGHT 0.75 //[0.0 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2.0 2.05 2.1 2.15 2.2 2.25 2.3 2.35 2.4 2.45 2.5 2.55 2.6 2.65 2.7 2.75 2.8 2.85 2.9 2.95 3.0 3.05 3.1 3.15 3.2 3.25 3.3 3.35 3.4 3.45 3.5 3.55 3.6 3.65 3.7 3.75 3.8 3.85 3.9 3.95 4.0 4.05 4.1] 
#define WATER_SPEED 1.0    //[0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2.0 2.1 2.32.4 2.5 2.6 2.7 2.8 2.9 3.0 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4.0]
//#define WATER_SPEED_LIGHT_BAR_LINKER

/////////INTERNAL VARIABLES////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////INTERNAL VARIABLES////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Do not change the name of these variables or their type. The Shaders Mod reads these lines and determines values to send to the inner-workings
//of the shaders mod. The shaders mod only reads these lines and doesn't actually know the real value assigned to these variables in GLSL.
//Some of these variables are critical for proper operation. Change at your own risk.

const int 		shadowMapResolution 	= 2048;	// Shadowmap resolution [1024 2048 4096]
const float 	shadowDistance 			= 120.0; // Shadow distance. Set lower if you prefer nicer close shadows. Set higher if you prefer nicer distant shadows. [80.0 120.0 180.0 240.0]
const float 	shadowIntervalSize 		= 4.0f;
const bool 		shadowHardwareFiltering0 = true;

const bool 		shadowtex1Mipmap = true;
const bool 		shadowtex1Nearest = false;
const bool 		shadowcolor0Mipmap = true;
const bool 		shadowcolor0Nearest = false;
const bool 		shadowcolor1Mipmap = true;
const bool 		shadowcolor1Nearest = false;

const float 	eyeBrightnessHalflife 	= 10.0f;
const float 	wetnessHalflife 		= 300.0f;
const float 	drynessHalflife 		= 40.0f;

const int 		superSamplingLevel 		= 0;

const float		sunPathRotation 		= 0.0; // [-90.0 -89.5 -89.0 -88.5 -88.0 -87.5 -87.0 -86.5 -86.0 -85.5 -85.0 -84.5 -84.0 -83.5 -83.0 -82.5 -82.0 -81.5 -81.0 -80.5 -80.0 -79.5 -79.0 -78.5 -78.0 -77.5 -77.0 -76.5 -76.0 -75.5 -75.0 -74.5 -74.0 -73.5 -73.0 -72.5 -72.0 -71.5 -71.0 -70.5 -70.0 -69.5 -69.0 -68.5 -68.0 -67.5 -67.0 -66.5 -66.0 -65.5 -65.0 -64.5 -64.0 -63.5 -63.0 -62.5 -62.0 -61.5 -61.0 -60.5 -60.0 -59.5 -59.0 -58.5 -58.0 -57.5 -57.0 -56.5 -56.0 -55.5 -55.0 -54.5 -54.0 -53.5 -53.0 -52.5 -52.0 -51.5 -51.0 -50.5 -50.0 -49.5 -49.0 -48.5 -48.0 -47.5 -47.0 -46.5 -46.0 -45.5 -45.0 -44.5 -44.0 -43.5 -43.0 -42.5 -42.0 -41.5 -41.0 -40.5 -40.0 -39.5 -39.0 -38.5 -38.0 -37.5 -37.0 -36.5 -36.0 -35.5 -35.0 -34.5 -34.0 -33.5 -33.0 -32.5 -32.0 -31.5 -31.0 -30.5 -30.0 -29.5 -29.0 -28.5 -28.0 -27.5 -27.0 -26.5 -26.0 -25.5 -25.0 -24.5 -24.0 -23.5 -23.0 -22.5 -22.0 -21.5 -21.0 -20.5 -20.0 -19.5 -19.0 -18.5 -18.0 -17.5 -17.0 -16.5 -16.0 -15.5 -15.0 -14.5 -14.0 -13.5 -13.0 -12.5 -12.0 -11.5 -11.0 -10.5 -10.0 -9.5 -9.0 -8.5 -8.0 -7.5 -7.0 -6.5 -6.0 -5.5 -5.0 -4.5 -4.0 -3.5 -3.0 -2.5 -2.0 -1.5 -1.0 -0.5 0.0 0.5 1.0 1.5 2.0 2.5 3.0 3.5 4.0 4.5 5.0 5.5 6.0 6.5 7.0 7.5 8.0 8.5 9.0 9.5 10.0 10.5 11.0 11.5 12.0 12.5 13.0 13.5 14.0 14.5 15.0 15.5 16.0 16.5 17.0 17.5 18.0 18.5 19.0 19.5 20.0 20.5 21.0 21.5 22.0 22.5 23.0 23.5 24.0 24.5 25.0 25.5 26.0 26.5 27.0 27.5 28.0 28.5 29.0 29.5 30.0 30.5 31.0 31.5 32.0 32.5 33.0 33.5 34.0 34.5 35.0 35.5 36.0 36.5 37.0 37.5 38.0 38.5 39.0 39.5 40.0 40.5 41.0 41.5 42.0 42.5 43.0 43.5 44.0 44.5 45.0 45.5 46.0 46.5 47.0 47.5 48.0 48.5 49.0 49.5 50.0 50.5 51.0 51.5 52.0 52.5 53.0 53.5 54.0 54.5 55.0 55.5 56.0 56.5 57.0 57.5 58.0 58.5 59.0 59.5 60.0 60.5 61.0 61.5 62.0 62.5 63.0 63.5 64.0 64.5 65.0 65.5 66.0 66.5 67.0 67.5 68.0 68.5 69.0 69.5 70.0 70.5 71.0 71.5 72.0 72.5 73.0 73.5 74.0 74.5 75.0 75.5 76.0 76.5 77.0 77.5 78.0 78.5 79.0 79.5 80.0 80.5 81.0 81.5 82.0 82.5 83.0 83.5 84.0 84.5 85.0 85.5 86.0 86.5 87.0 87.5 88.0 88.5 89.0 89.5 90.0]
const float 	ambientOcclusionLevel 	= 0.01f;

const int 		noiseTextureResolution  = 64;


//END OF INTERNAL VARIABLES//

uniform sampler2D depthtex1;

uniform sampler2D shadowtex1;

uniform sampler2D shadowcolor;
uniform sampler2D shadowcolor1;

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;
uniform sampler2D colortex4;
uniform sampler2D colortex5;
uniform sampler2D colortex6;

uniform sampler2D noisetex;

uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowModelViewInverse;
uniform mat4 shadowProjection;
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferProjection;

in vec4 texcoord;
in vec3 lightVector;

in float timeSunriseSunset;
in float timeNoon;
in float timeMidnight;
in float timeSkyDark;
uniform float screenBrightness;

in vec3 colorSunlight;
in vec3 colorSkylight;
in vec3 colorSunglow;
in vec3 colorBouncedSunlight;
in vec3 colorScatteredSunlight;
in vec3 colorTorchlight;
in vec3 colorWaterMurk;
in vec3 colorWaterBlue;
in vec3 colorSkyTint;

uniform float near;
uniform float far;
uniform float viewWidth;
uniform float viewHeight;
uniform float rainStrength;
uniform float wetness;
uniform float aspectRatio;
uniform float frameTimeCounter;
uniform float sunAngle;
uniform vec3 skyColor;
uniform vec3 cameraPosition;

/////////////////////////FUNCTIONS/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////FUNCTIONS/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

vec3  	GetNormals(in vec2 coord) {				//Function that retrieves the screen space surface normals. Used for lighting calculations
	return texture(colortex2, coord.st).rgb * 2.0f - 1.0f;
}

float 	GetDepth(in vec2 coord) {
	return texture(depthtex1, coord.st).x;
}

vec4  	GetScreenSpacePosition(in vec2 coord) {	//Function that calculates the screen-space position of the objects in the scene using the depth texture and the texture coordinates of the full-screen quad
	float depth = GetDepth(coord);
	vec4 fragposition = gbufferProjectionInverse * vec4(coord.s * 2.0f - 1.0f, coord.t * 2.0f - 1.0f, 2.0f * depth - 1.0f, 1.0f);
		 fragposition /= fragposition.w;
	
	return fragposition;
}

vec3 	CalculateNoisePattern1(vec2 offset, float size) {
	vec2 coord = texcoord.st;

	coord *= vec2(viewWidth, viewHeight);
	coord = mod(coord + offset, vec2(size));
	coord /= noiseTextureResolution;

	return texture(noisetex, coord).xyz;
}

vec2 DistortShadowSpace(in vec2 pos)
{
	vec2 signedPos = pos * 2.0f - 1.0f;

	float dist = sqrt(signedPos.x * signedPos.x + signedPos.y * signedPos.y);
	float distortFactor = (1.0f - SHADOW_MAP_BIAS) + dist * SHADOW_MAP_BIAS;
	signedPos.xy *= 0.95 / distortFactor;

	pos = signedPos * 0.5f + 0.5f;

	return pos;
}

vec3 Contrast(in vec3 color, in float contrast)
{
	float colorLength = length(color);
	vec3 nColor = color / colorLength;

	colorLength = pow(colorLength, contrast);

	return nColor * colorLength;
}

float 	GetMaterialIDs(in vec2 coord) {			//Function that retrieves the texture that has all material IDs stored in it
	return texture(colortex1, coord).r;
}

float GetSkylight(in vec2 coord)
{
	return textureLod(colortex1, coord, 0).b;
}

float 	GetMaterialMask(in vec2 coord, const in int ID) {
	float matID = (GetMaterialIDs(coord) * 255.0f);

	//Catch last part of sky
	if (matID > 254.0f) {
		matID = 0.0f;
	}

	if (matID == ID) {
		return 1.0f;
	} else {
		return 0.0f;
	}
}

bool 	GetSkyMask(in vec2 coord)
{
	float matID = GetMaterialIDs(coord);
	matID = floor(matID * 255.0f);

	if (matID < 1.0f || matID > 254.0f)
	{
		return true;
	} else {
		return false;
	}
}

#define OFF 0
#define Entities 1
#define Blocks 2

#define Disabled_AO_On OFF	//[OFF Entities Blocks]

float GetAO(in vec4 screenSpacePosition, in vec3 normal, in vec2 coord, in vec3 dither)
{
	//Determine origin position
	vec3 origin = screenSpacePosition.xyz;

	vec3 randomRotation = normalize(dither.xyz * vec3(2.0f, 2.0f, 1.0f) - vec3(1.0f, 1.0f, 0.0f));

	vec3 tangent = normalize(randomRotation - normal * dot(randomRotation, normal));
	vec3 bitangent = cross(normal, tangent);
	mat3 tbn = mat3(tangent, bitangent, normal);

	float aoRadius   = 0.15f * -screenSpacePosition.z;
		  //aoRadius   = 0.8f;
	float zThickness = 0.25f * -screenSpacePosition.z;
		  //zThickness = 2.2f;

	vec3 	samplePosition 		= vec3(0.0f);
	float 	intersect 			= 0.0f;
	vec4 	sampleScreenSpace 	= vec4(0.0f);
	float 	sampleDepth 		= 0.0f;
	float 	distanceWeight 		= 0.0f;
	float 	finalRadius 		= 0.0f;

	int numRaysPassed = 0;

	float ao = 0.0f;

	for (int i = 0; i < 4; i++)
	{
		vec3 kernel = vec3(texture(noisetex, vec2(0.1f + (i * 1.0f) / 64.0f)).r * 2.0f - 1.0f, 
					     texture(noisetex, vec2(0.1f + (i * 1.0f) / 64.0f)).g * 2.0f - 1.0f,
					     texture(noisetex, vec2(0.1f + (i * 1.0f) / 64.0f)).b * 1.0f);
			 kernel = normalize(kernel);
			 kernel *= pow(dither.x + 0.01f, 1.0f);

		samplePosition = tbn * kernel;
		samplePosition = samplePosition * aoRadius + origin;

			sampleScreenSpace = gbufferProjection * vec4(samplePosition, 0.0f);
			sampleScreenSpace.xyz /= sampleScreenSpace.w;
			sampleScreenSpace.xyz = sampleScreenSpace.xyz * 0.5f + 0.5f;

			//float isentities = GetMaterialMask(sampleScreenSpace.st, 7);
			//float iscube = 1.0 - isentities;

			#if Disabled_AO_On == OFF
			float disableAO = 0.0;
			#elif Disabled_AO_On == Entities
			float disableAO = GetMaterialMask(sampleScreenSpace.st, 7);
			#elif Disabled_AO_On == Blocks
			float disableAO = 1.0 - GetMaterialMask(sampleScreenSpace.st, 7);
			#endif

			//Check depth at sample point
			sampleDepth = GetScreenSpacePosition(sampleScreenSpace.xy).z;

			//If point is behind geometry, buildup AO
			if (sampleDepth >= samplePosition.z && sampleDepth - samplePosition.z < zThickness && disableAO < 0.5)
			{	
				ao += 1.0f;
			} else {

			}
	}
	ao /= 4;
	ao = 1.0f - ao;
	ao = pow(ao, 2.0f);

	return ao;
}

vec4 GetLight(in int LOD, in vec2 offset, in float range, in float quality, vec3 noisePattern)
{
	float scale = pow(2.0f, float(LOD));

	float padding = 0.002f;

	if (	texcoord.s - offset.s + padding < 1.0f / scale + (padding * 2.0f) 
		&&  texcoord.t - offset.t + padding < 1.0f / scale + (padding * 2.0f)
		&&  texcoord.s - offset.s + padding > 0.0f 
		&&  texcoord.t - offset.t + padding > 0.0f) 
	{

		vec2 coord = (texcoord.st - offset.st) * scale;

		vec3 normal 				= GetNormals(coord.st);						//Gets the screen-space normals

		vec4 gn = gbufferModelViewInverse * vec4(normal.xyz, 0.0f);
			 gn = shadowModelView * gn;
			 gn.xyz = normalize(gn.xyz);

		vec3 shadowSpaceNormal = gn.xyz;

		vec4 screenSpacePosition 	= GetScreenSpacePosition(coord.st); 			//Gets the screen-space position
		vec3 viewVector 			= normalize(screenSpacePosition.xyz);


		float distance = sqrt(  screenSpacePosition.x * screenSpacePosition.x 	//Get surface distance in meters
							  + screenSpacePosition.y * screenSpacePosition.y 
							  + screenSpacePosition.z * screenSpacePosition.z);

		float materialIDs = texture(colortex1, coord).r * 255.0f;

		vec4 upVectorShadowSpace = shadowModelView * vec4(0.0f, 1.0, 0.0, 0.0);

		
		vec4 worldposition = gbufferModelViewInverse * screenSpacePosition;		//Transform from screen space to world space
			 worldposition = shadowModelView * worldposition;							//Transform from world space to shadow space
		float comparedepth = -worldposition.z;											//Surface distance from sun to be compared to the shadow map
		
		worldposition = shadowProjection * worldposition;								//Transform from shadow space to shadow projection space					
		worldposition /= worldposition.w;

		float d = sqrt(worldposition.x * worldposition.x + worldposition.y * worldposition.y);
		float distortFactor = (1.0f - SHADOW_MAP_BIAS) + d * SHADOW_MAP_BIAS;
		//worldposition.xy /= distortFactor;
		worldposition.z = mix(worldposition.z, 0.5, 0.8);
		worldposition = worldposition * 0.5f + 0.5f;		//Transform from shadow projection space to shadow map coordinates

		float shadowMult = 0.0f;														//Multiplier used to fade out shadows at distance
		float shad = 0.0f;
		vec3 fakeIndirect = vec3(0.0f);

		float fakeLargeAO = 0.0;


		float mcSkylight = GetSkylight(coord) * 0.8 + 0.2;

		float fademult = 0.15f;

		shadowMult = clamp((shadowDistance * 41.4f * fademult) - (distance * fademult), 0.0f, 1.0f);	//Calculate shadowMult to fade shadows out


		if (	shadowMult > 0.0) 
		{
			 

			//big shadow
			float rad = range;

			int c = 0;
			float s = 2.0f * rad / 2048;

			vec2 dither = noisePattern.xy - 0.5f;
			//vec2 dither = vec2(0.0f);

			float step = 1.0f / quality;

			for (float i = -2.0f; i <= 2.0f; i += step) {
				for (float j = -2.0f; j <= 2.0f; j += step) {

					vec2 offset = (vec2(i, j) + dither * step) * s;

					offset *= length(offset) * 15.0;
					offset *= GI_RADIUS * 1.0;

					vec2 coord =  worldposition.st + offset;
					vec2 lookupCoord = DistortShadowSpace(coord);

					#ifdef GI_ARTIFACT_REDUCTION
					float depthSample = textureLod(shadowtex1, lookupCoord, 0).x;
					#else
					float depthSample = textureLod(shadowtex1, lookupCoord, 2).x;
					#endif

					/*
					depthSample = depthSample * 2.0 - 1.0;
					depthSample -= 0.4;
					depthSample /= 0.2;
					depthSample = depthSample * 0.5 + 0.5;
					*/

					//depthSample = -3 + 5.0 * depthSample;
					vec3 samplePos = vec3(coord.x, coord.y, depthSample);


					vec3 lightVector = normalize(samplePos.xyz - worldposition.xyz);

					vec4 normalSample = textureLod(shadowcolor1, lookupCoord, 5);
					vec3 surfaceNormal = normalSample.rgb * 2.0f - 1.0f;
						 surfaceNormal.x = -surfaceNormal.x;
						 surfaceNormal.y = -surfaceNormal.y;

					float surfaceSkylight = normalSample.a;

					if (surfaceSkylight < 0.2)
					{
						surfaceSkylight = mcSkylight;
					}

					float NdotL = max(0.0f, dot(shadowSpaceNormal.xyz, lightVector * vec3(1.0, 1.0, -1.0)));
						  // NdotL = NdotL * 0.9f + 0.1f;

					if (abs(materialIDs - 3.0f) < 0.1f || abs(materialIDs - 2.0f) < 0.1f || abs(materialIDs - 11.0f) < 0.1f)
					{
						NdotL = 1.0f;
					}

					if (NdotL > 0.0)
					{
						bool isTranslucent = length(surfaceNormal) < 0.5f;

						if (isTranslucent)
						{
							surfaceNormal.xyz = vec3(0.0f, 0.0f, 1.0f);
						}

						//float leafMix = clamp(-surfaceNormal.b * 10.0f, 0.0f, 1.0f);


						float weight = dot(lightVector, surfaceNormal);
						float rawdot = weight;
						// float aoWeight = abs(weight);
							  // aoWeight *= clamp(dot(lightVector, upVectorShadowSpace.xyz), 0.0, 1.0);
						//weight = mix(weight, 1.0f, leafMix);
						if (isTranslucent)
						{
							weight = abs(weight) * 0.25f;
						}

						if (normalSample.a < 0.2)
						{
							weight = 0.5;
						}

						weight = max(weight, 0.0f);

						float dist = length(samplePos.xyz - worldposition.xyz - vec3(0.0f, 0.0f, 0.0f));
						if (dist < 0.0005f)
						{
							dist = 10000000.0f;
						}
						// float aoDist = length(samplePos.xyz - worldposition.xyz);
						// aoDist = aoDist < 0.001f ? 10000000.0f : aoDist;

						const float falloffPower = 2.0f;
						float distanceWeight = (1.0f / (pow(dist * (62260.0f / rad), falloffPower) + 100.1f));
							  //distanceWeight = max(0.0f, distanceWeight - 0.000009f);
							  distanceWeight *= pow(length(offset), 2.0) * 50000.0 + 1.01;
						
						// float aoDistanceWeight = (1.0f / (pow(aoDist * (13600.0f / rad), falloffPower) + 0.0001f * step));
							  // aoDistanceWeight = max(0.0f, aoDistanceWeight - 0.00009f);

						//Leaves self-occlusion
						if (rawdot < 0.0f)
						{
							distanceWeight = max(distanceWeight * 30.0f - 0.13f, 0.0f);
							distanceWeight *= 0.04f;
						}
							  

						//float skylightWeight = clamp(1.0 - abs(surfaceSkylight - mcSkylight) * 10.0, 0.0, 1.0);
						float skylightWeight = 1.0 / (max(0.0, surfaceSkylight - mcSkylight) * 50.0 + 1.0);


						vec3 colorSample = pow(textureLod(shadowcolor, lookupCoord, 5).rgb, vec3(2.2f));
						//colorSample 				= pow(colorSample, vec3(1.2f));

						//colorSample = Contrast(colorSample, 0.8f);

						//colorSample = normalize(colorSample) * pow(length(colorSample), 1.2f);

						//colorSample = mix(colorSample, vec3(dot(colorSample, vec3(0.3333f))), vec3(0.035f));
						//float colorMagnitude = dot(colorSample, vec3(0.3333f));
						//vec3 normalized = normalize(colorSample);
						// if (surfaceNormal.b < -0.1f && abs(materialIDs - 3.0f) < 0.1f)
						// {
						// 	float crossfade = clamp(1.0f - dist / 5.0f, 0.0f, 1.0f);
						// 	normalized = pow(normalized, vec3(mix(1.0f, 2.0f, crossfade)));
						// }
						//colorSample = normalized * colorMagnitude;


						fakeIndirect += colorSample * weight * distanceWeight * NdotL * skylightWeight;
						//fakeIndirect += skylightWeight * weight * distanceWeight * NdotL;
					// fakeLargeAO += aoDistanceWeight * NdotL;
					}
					c += 1;
				}
			}

			fakeIndirect /= c;
			// fakeLargeAO /= c;
			// fakeLargeAO = clamp(1.0 - fakeLargeAO * 500.0, 0.0, 1.0);
			// fakeLargeAO = pow(fakeLargeAO, 2.0);
		}

		fakeIndirect = mix(vec3(0.0f), fakeIndirect, vec3(shadowMult));


		float ao = 1.0f;
		// ao *= fakeLargeAO;
		bool isSky = GetSkyMask(coord.st);
		#ifdef ENABLE_SSAO
		if (!isSky)
		{
			ao *= GetAO(screenSpacePosition.xyzw, normal.xyz, coord.st, noisePattern.xyz);
		}
		#endif

		//fakeIndirect.rgb = vec3(mcSkylight / 1150.0);

		return vec4(fakeIndirect.rgb * 1400.0f * GI_RADIUS, ao);
	}
	else {
		return vec4(0.0f);
	}
}

float  	CalculateDitherPattern1() {
	const int[16] ditherPattern = int[16] (0 , 8 , 2 , 10,
									 	   12, 4 , 14, 6 ,
									 	   3 , 11, 1,  9 ,
									 	   15, 7 , 13, 5 );

	vec2 count = vec2(0.0f);
	     count.x = floor(mod(texcoord.s * viewWidth, 4.0f));
		 count.y = floor(mod(texcoord.t * viewHeight, 4.0f));

	int dither = ditherPattern[int(count.x) + int(count.y) * 4];

	return float(dither) / 16.0f;
}

void 	DoNightEye(inout vec3 color) {			//Desaturates any color input at night, simulating the rods in the human eye
	
	float amount = 0.8f; 						//How much will the new desaturated and tinted image be mixed with the original image
	vec3 rodColor = vec3(0.2f, 0.4f, 1.0f); 	//Cyan color that humans percieve when viewing extremely low light levels via rod cells in the eye
	float colorDesat = dot(color, vec3(1.0f)); 	//Desaturated color
	
	color = mix(color, vec3(colorDesat) * rodColor, timeMidnight * amount);
	//color.rgb = color.rgb;	
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

	return texture(tex, coord);
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

uniform vec2 jitter;

float R2Dither(vec2 coord){
	vec2 alpha = vec2(0.75487765, 0.56984026);
	
	coord *= vec2(viewWidth, viewHeight);

	return fract(alpha.x * coord.x + alpha.y * coord.y);
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////MAIN//////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void main() {

	vec3 noisePattern = CalculateNoisePattern1(vec2(0.0f), 4);
	vec4 screenSpacePosition = GetScreenSpacePosition(texcoord.st);
	vec4 worldSpacePosition = gbufferModelViewInverse * screenSpacePosition;
	vec4 worldLightVector = shadowModelViewInverse * vec4(0.0f, 0.0f, 1.0f, 0.0f);
	vec3 normal = GetNormals(texcoord.st);

	vec4 light = vec4(0.0, 0.0, 0.0, 1.0);
	#ifdef GI
		 light = GetLight(GI_RENDER_RESOLUTION, 		vec2(0.0f			), 16.0,  GI_QUALITY, noisePattern);
	#endif
	//light += GetLight(0, vec2(0.0f), 2.0f, 0.5f);

	if (light.r >= 1.0f)
	{
		light.r = 0.0f;
	}

	if (light.g >= 1.0f)
	{
		light.g = 0.0f;
	}

	if (light.b >= 1.0f)
	{
		light.b = 0.0f;
	}

	light.a = mix(light.a, 1.0, GetMaterialMask(texcoord.st * (GI_RENDER_RESOLUTION + 1.0), 5));


	gl_FragData[0] = vec4(pow(light.rgb, vec3(1.0 / 2.2)), light.a);
	gl_FragData[1] = vec4(GetWavesNormal(vec3(texcoord.s * 50.0, 1.0, texcoord.t * 50.0)).xy * 0.5 + 0.5, 0.0, 0.0);
}
/* DRAWBUFFERS:46 */
//change GetWavesNormal
//change material id getting of transparent blocks