




#define CLOUD_CLEAR_ALTITUDE 		800 	// [400 500 600 700 800 1000 1250 1500 1750 2000]
#define CLOUD_CLEAR_THICKNESS 		1400 	// [500 600 700 800 900 1000 1100 1200 1300 1400 1500 1600 1700 1800 1900 2000 2250 2500 2750 3000 4000 5000]
#define CLOUD_CLEAR_COVERY 			-0.1 	// [-0.5 -0.4 -0.3 -0.2 -0.1 0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.2 1.4 1.6 1.8 2.0]
#define CLOUD_CLEAR_DENSITY 		1.0 	// [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.5 3.0 5.0]
#define CLOUD_CLEAR_SUNLIGHTING		1.0		// [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.5 3.0 5.0]
#define CLOUD_CLEAR_SKYLIGHTING		1.0		// [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.5 3.0 5.0]
#define CLOUD_CLEAR_SUNLIGHT_LENGTH 150.0 	// [70.0 80.0 90.0 100.0 110.0 120.0 130.0 140.0 150.0 170.0 200.0 250.0 300.0]
#define CLOUD_CLEAR_SKYLIGHT_LENGTH 100.0 	// [70.0 80.0 90.0 100.0 110.0 120.0 130.0 140.0 150.0 170.0 200.0 250.0 300.0]
#define CLOUD_CLEAR_FBM_OCTSCALE	2.6 	// [2.0 2.1 2.2 2.3 2.4 2.5 2.55 2.6 2.65 2.7 2.75 2.8 2.85 2.9 2.95 3.0 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4.0]
#define CLOUD_CLEAR_UPPER_LIMIT 	0.5 	// [0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]
#define CLOUD_CLEAR_LOWER_LIMIT 	0.15 	// [0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]

#define CLOUD_RAIN_ALTITUDE 		500 	// [400 500 600 800 1000 1250 1500 1750 2000]
#define CLOUD_RAIN_THICKNESS 		2000 	// [500 600 700 800 900 1000 1100 1200 1300 1400 1500 1600 1700 1800 1900 2000 2250 2500 2750 3000 4000 5000]
#define CLOUD_RAIN_COVERY 			1.4 	// [-0.5 -0.4 -0.3 -0.2 -0.1 0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.2 1.4 1.6 1.8 2.0]
#define CLOUD_RAIN_DENSITY 			0.7 	// [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.5 3.0 5.0]
#define CLOUD_RAIN_SUNLIGHTING		2.5		// [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.5 3.0 5.0]
#define CLOUD_RAIN_SKYLIGHTING		0.4		// [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.5 3.0 5.0]
#define CLOUD_RAIN_SUNLIGHT_LENGTH 	200.0	// [70.0 80.0 90.0 100.0 110.0 120.0 130.0 140.0 150.0 170.0 200.0 250.0 300.0]
#define CLOUD_RAIN_SKYLIGHT_LENGTH 	100.0 	// [70.0 80.0 90.0 100.0 110.0 120.0 130.0 140.0 150.0 170.0 200.0 250.0 300.0]
#define CLOUD_RAIN_FBM_OCTSCALE		3.1 	// [2.0 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3.0 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4.0]
#define CLOUD_RAIN_UPPER_LIMIT 		0.8 	// [0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]
#define CLOUD_RAIN_LOWER_LIMIT 		0.3 	// [0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]


#define VC_MARCHING 				1 		// [1 0]

#define CLOUD_GENUINE_ALTITUDE 		450 	// [-100 -80 -60 -50 -40 -30 -20 -10 0 10 20 30 40 50 60 80 100 150 200 250 300 350 400 450 500 600 800 1000]
#define CLOUD_GENUINE_ACCURACY 		40 		// [20 30 40 50 75 100]
#define CLOUD_GENUINE_DISTENCE 		10000 	// [4000 6000 8000 10000 12500 15000 17500 20000]

#define CLOUD_FAKE_ACCURACY 		17 		// [11 17 25 37 55 83 125]
#define CLOUD_FBM_OCTAVES			4 		// [4 5 6 7 8 9]
#define CLOUD_NOISE_SCALE 			0.00045 // [0.001 0.00095 0.0009 0.00085 0.0008 0.00075 0.0007 0.00065 0.0006 0.00055 0.0005 0.00045 0.0004 0.00035 0.0003 0.00025 0.0002]

#define ADAPTIVE_OCTAVES
#define ADAPTIVE_OCTAVES_LEVEL 		4		// [3 4 5]
#define ADAPTIVE_OCTAVES_DISTANCE 	30.0 	// [20.0 25.0 30.0 35.0 40.0 50.0]

#define CLOUD_SUNLIGHT_QUALITY 		3 		// [3 4 5 7 10 15 20]
#define CLOUD_SKYLIGHT_QUALITY 		2 		// [2 3 4 5 7 10 15 20]


#define ATMO_TRAINSITION_DISTANCE 	25000 	// [6000 8000 10000 12500 15000 17500 20000 25000 30000 50000]

#define CLOUD_SPEED 				1.0 	// [0.0 0.25 0.5 0.75 1.0 1.5 2.0 3.0 4.0 5.0 7.5 10.0 15.0 20.0 30.0 40.0 50.0 75.0 100.0]

#define FTC_OFFSET 					0 		// [0 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100 105 110 115 120 125 130 135 140 145 150 155 160 165 170 175 180 185 190 195 200 205 210 215 220 225 230 235 240 245 250 255 260 265 270 275 280 285 290 295 300 305 310 315 320 325 330 335 340 345 350 355]

float remap(float e0, float e1, float x)
{
	return saturate((x - e0) / (e1 - e0));
}

Intersection RayPlaneIntersection(in Ray ray, in Plane plane)
{
	float rayPlaneAngle = dot(ray.dir, plane.normal);

	float planeRayDist = 100000000.0f;
	vec3 intersectionPos = ray.dir * planeRayDist;

	if (rayPlaneAngle > 0.0001f || rayPlaneAngle < -0.0001f)
	{
		planeRayDist = dot((plane.origin - ray.origin), plane.normal) / rayPlaneAngle;
		intersectionPos = ray.origin + ray.dir * planeRayDist;
		// intersectionPos = -intersectionPos;

		// intersectionPos += cameraPosition.xyz;
	}

	Intersection i;

	i.pos = intersectionPos;
	i.distance = planeRayDist;
	i.angle = rayPlaneAngle;

	return i;
}


//Optimize by not needing to do a dot product every time
float MiePhase(float g, vec3 dir, vec3 lightDir)
{
	float VdotL = dot(dir, lightDir);

	float g2 = g * g;
	float theta = fma(VdotL, 0.5f, 0.5f);
	float anisoFactor = 1.5 * ((1.0 - g2) / (2.0 + g2)) * (fma(theta, theta, 1.0f) / (1.0 + g2 - 2.0 * g * theta)) + g * theta;

	return anisoFactor;
}

struct CloudProperties
{
	float altitude;
	float thickness;
	float coverage;
	float density;
	float sunlighting;
	float skylighting;
	float sunlightLength;
	float skylightLength;
	float octScale;
	float lowerLimit;
	float upperLimit;
};

CloudProperties CloudPropertiesLerp(CloudProperties cp1, CloudProperties cp2, float x)
{
	CloudProperties cp;

	cp.altitude 		= mix(cp1.altitude, cp2.altitude, x);
	cp.thickness 		= mix(cp1.thickness, cp2.thickness, x);
	cp.coverage 		= mix(cp1.coverage, cp2.coverage, x);
	cp.density 			= mix(cp1.density, cp2.density, x);
	cp.sunlighting 		= mix(cp1.sunlighting, cp2.sunlighting, x);
	cp.skylighting 		= mix(cp1.skylighting, cp2.skylighting, x);
	cp.sunlightLength 	= mix(cp1.sunlightLength, cp2.sunlightLength, x);
	cp.skylightLength 	= mix(cp1.skylightLength, cp2.skylightLength, x);
	cp.octScale 		= mix(cp1.octScale, cp2.octScale, x);
	cp.lowerLimit		= mix(cp1.lowerLimit, cp2.lowerLimit, x);
	cp.upperLimit		= mix(cp1.upperLimit, cp2.upperLimit, x);

	return cp;
}


CloudProperties GetGlobalCloudProperties()
{
	CloudProperties cloudPropertiesClear;
	cloudPropertiesClear.altitude 			= CLOUD_CLEAR_ALTITUDE;
	cloudPropertiesClear.thickness 			= CLOUD_CLEAR_THICKNESS;
	cloudPropertiesClear.coverage 			= CLOUD_CLEAR_COVERY;
	cloudPropertiesClear.density 			= CLOUD_CLEAR_DENSITY;
	cloudPropertiesClear.sunlighting 		= CLOUD_CLEAR_SUNLIGHTING;
	cloudPropertiesClear.skylighting 		= CLOUD_CLEAR_SKYLIGHTING;
	cloudPropertiesClear.sunlightLength 	= CLOUD_CLEAR_SUNLIGHT_LENGTH;
	cloudPropertiesClear.skylightLength 	= CLOUD_CLEAR_SKYLIGHT_LENGTH;
	cloudPropertiesClear.octScale 			= CLOUD_CLEAR_FBM_OCTSCALE;
	cloudPropertiesClear.lowerLimit 		= CLOUD_CLEAR_LOWER_LIMIT;
	cloudPropertiesClear.upperLimit 		= CLOUD_CLEAR_UPPER_LIMIT;

	CloudProperties cloudPropertiesRain;
	cloudPropertiesRain.altitude 			= CLOUD_RAIN_ALTITUDE;
	cloudPropertiesRain.thickness 			= CLOUD_RAIN_THICKNESS;
	cloudPropertiesRain.coverage 			= CLOUD_RAIN_COVERY;
	cloudPropertiesRain.density 			= CLOUD_RAIN_DENSITY;
	cloudPropertiesRain.sunlighting 		= CLOUD_RAIN_SUNLIGHTING;
	cloudPropertiesRain.skylighting 		= CLOUD_RAIN_SKYLIGHTING;
	cloudPropertiesRain.sunlightLength 		= CLOUD_RAIN_SUNLIGHT_LENGTH;
	cloudPropertiesRain.skylightLength 		= CLOUD_RAIN_SKYLIGHT_LENGTH;
	cloudPropertiesRain.octScale 			= CLOUD_RAIN_FBM_OCTSCALE;
	cloudPropertiesRain.lowerLimit 			= CLOUD_RAIN_LOWER_LIMIT;
	cloudPropertiesRain.upperLimit 			= CLOUD_RAIN_UPPER_LIMIT;

	CloudProperties cp = CloudPropertiesLerp(cloudPropertiesClear, cloudPropertiesRain, wetness);

	return cp;
}

float GetCloudHeightDensity(CloudProperties cp, vec3 worldPos)
{
	float w = 0.5;
	//cp.altitude += Get2DNoiseM(worldPos * 0.001) * 500.0;
	float highPoint = cp.altitude + cp.thickness * 1.0;
	float lowPoint =  cp.altitude;
	float midPoint = mix(lowPoint, highPoint, 0.1);

	float density = remap(lowPoint, midPoint, worldPos.y);
	density *= remap(highPoint, midPoint, worldPos.y);
	density = smoothstep(0.0, 1.0, density);

	return density;
}

vec3 cubeSmooth(vec3 x){
    return x * x * (3.0 - 2.0 * x);
}

float Calculate3DNoise(vec3 position){
    vec3 p = floor(position);
    vec3 b = cubeSmooth(fract(position));

    vec2 uv = 17.0 * p.z + p.xy + b.xy;
    vec2 rg = texture(noisetex, (uv + 0.5) / noiseTextureResolution).zw;

    return mix(rg.x, rg.y, b.z);
}



float CalculateCloudFBM(vec3 position, vec3 windDirection, int octaves, CloudProperties cp){
    const float octAlpha = 0.5; // The ratio of visibility between successive octaves
    float octScale = cp.octScale; // The downscaling factor between successive octaves
    float octShift = (octAlpha / octScale) / octaves; // Shift the FBM brightness based on how many octaves are active

    float accum = 0.0;
    float alpha = 0.5;
    vec3  shift = windDirection;

	position += windDirection;

    for (int i = 0; i < octaves; ++i) {
		accum += alpha * Calculate3DNoise(position);
        position = (position + shift) * octScale;
        alpha *= octAlpha;
    }

    return accum + octShift;
}

float GetCloudDensity(CloudProperties cp, vec3 worldPos, int octaves)
{

	float wind 			=  -0.0025 * (frameTimeCounter * CLOUD_SPEED + 10.0 * FTC_OFFSET);
    vec3  windDirection = vec3(wind, 0.0, -0.6 * wind);
    vec3  cloudPos      = worldPos * CLOUD_NOISE_SCALE;

    float clouds = CalculateCloudFBM(cloudPos, windDirection, octaves, cp);


	float normalizedHeight  = saturate((worldPos.y - cp.altitude) / cp.thickness);
	float heightAttenuation = saturate(normalizedHeight / cp.lowerLimit) * saturate((1.0 - normalizedHeight) / (1.0 - cp.upperLimit));


	clouds  = clouds * heightAttenuation * (2.0 + cp.coverage) - (0.9 * heightAttenuation + normalizedHeight * 0.5 + 0.1);
	clouds  = saturate(clouds * 4.5 * cp.density);

	return clouds;
}


vec4 SampleVolumetricClouds(CloudProperties cp, vec3 worldPos, vec3 worldDir, vec3 atmosphere)
{
	float eyeLength = length(worldPos - cameraPosition);

	int octaves = CLOUD_FBM_OCTAVES;

	#ifdef ADAPTIVE_OCTAVES
		octaves += max(ADAPTIVE_OCTAVES_LEVEL - int(floor(sqrt(eyeLength) / ADAPTIVE_OCTAVES_DISTANCE)), 0);
	#endif

	float density = GetCloudDensity(cp, worldPos, octaves);
	float softDensity = density;
	density = smoothstep(0.0, 0.6, density); 	//final cloud edge resolve


	//Early out if no cloud here
	if (density < 0.0001)
	{
		return vec4(0.0, 0.0, 0.0, 0.0);
	}



	//lighting..
	float sunlightExtinction = 0.0;
	for (int i = 1; i <= CLOUD_SUNLIGHT_QUALITY; i++)
	{
		float fi = float(i) / 2;
		fi = pow(fi, 1.5);
		vec3 checkPos = worldLightVector * fi * cp.sunlightLength + worldPos /*make clouds look denser towards sun * (1.5 - sunAngle)*/;

		float densityCheck = GetCloudDensity(cp, checkPos, octaves);

		sunlightExtinction += densityCheck;

	}
	float sunlightEnergy = (2.0 - 1.7 * wetness) / (sunlightExtinction * 10.0 + 1.0);
	//powder term
	float powderFactor = exp2(-softDensity * 12.0 / cp.sunlighting);
	powderFactor *= saturate(sunlightEnergy * sunlightEnergy * 10.5);
	powderFactor = MiePhase(powderFactor * 0.3, worldDir, worldLightVector);
	sunlightEnergy *= powderFactor;
	//Extra edge highlight
	float sunlightEnergyEX = MiePhase(0.7, worldDir, worldLightVector) * sunlightEnergy * (0.4 + 0.7 * wetness);



	//Cone trace skylight energy
	float skylightExtinction = 0.0;
	for (int i = 1; i < CLOUD_SKYLIGHT_QUALITY; i++)
	{
		float fi = float(i) / 2;
		vec3 checkPos =  worldPos + vec3(0.0, 1.0, 0.0) * fi * cp.skylightLength;

		float densityCheck = GetCloudDensity(cp, checkPos, octaves - 1);

		skylightExtinction += densityCheck;
	}
	float skylightEnergy = (0.5 - 0.35 * wetness) / (skylightExtinction * 5.0 + 1.0);




	vec3 cloudColor = vec3(0.0);
	cloudColor += sunlightEnergy;
	cloudColor *= 1.0 + sunlightEnergyEX;
	cloudColor *= cp.sunlighting * colorSunlight * 24.0;

	cloudColor += cp.skylighting * skylightEnergy * colorSkylight;

	#ifdef AURORA
	cloudColor += sunlightEnergy * vec3(0.0,1.0,0.5) * 0.0025 * timeMidnight * AURORA_STRENGTH;
	#endif

	cloudColor = mix(atmosphere, cloudColor, saturate(pow(1.0 - eyeLength / ATMO_TRAINSITION_DISTANCE, 0.7 + 0.3 * wetness)));
	cloudColor *= 10.0;
	//cloudColor = vec3(powderFactor);


	return vec4(cloudColor, density);
}

vec3 IntersectXZPlane(vec3 rayDir, vec3 offset, float planeHeight)
{
	return rayDir * (planeHeight - offset.y - cameraPosition.y) / rayDir.y;
}

vec4 VolumetricClouds(vec3 worldDir, vec3 worldOffset, vec3 atmosphere, CloudProperties cloudProperties, float noise)
{
	vec4 cloudAccum = vec4(0.0, 0.0, 0.0, 1.0);

	if(worldDir.y > 0)
	{
	//no clouds in front of sun
	// cloudProperties.coverage *= mix(0.0, 1.0, 1.0 - pow(saturate(dot(worldDir, worldLightVector) * 0.5 + 0.5), 48.0));
	CloudProperties cp = cloudProperties;

	//cp.coverage += pow(dot(-worldDir, worldLightVector) * 0.5 + 0.5, 2.0) * 0.3;
	#if VC_MARCHING

		float raySteps = CLOUD_FAKE_ACCURACY;
		float rayStepSize = 1.0 / raySteps;
		float actualCloudHeightGuess = 0.6;

		vec3 rayStartPos = IntersectXZPlane(worldDir, worldOffset, fma(cloudProperties.thickness, 0.05f, cloudProperties.altitude)) + worldOffset + cameraPosition;

		vec3 rayIncrement = (worldDir * cloudProperties.thickness * actualCloudHeightGuess * rayStepSize) / abs(worldDir.y);
		// vec3 rayIncrement = worldDir * 40.1;
		float rayIncrementLength = length(rayIncrement);


		vec3 rayPos = rayStartPos;
		rayPos += rayIncrement * noise;



		for (int i = 0; i < raySteps; i++)
		{
			//When fully opaque, stop
			if (cloudAccum.a < 0.00001)
			{
				break;
			}

			vec4 cloudSample = SampleVolumetricClouds(cp, rayPos, worldDir, atmosphere);
			cloudAccum.rgb += (cloudSample.rgb * cloudSample.a) * cloudAccum.a;
			cloudAccum.a *= 1.0 - cloudSample.a;

			rayPos += rayIncrement;
		}


	#else

		float raySteps = CLOUD_GENUINE_ACCURACY * fma(wetness, 3.0, 1.0);
		float rayStepSize = 10000.0 / raySteps;

		float rayDepth = 0.0 + noise * rayStepSize;

		for (int i = 0; i < raySteps; i++)
		{
			vec3 rayPos = (worldDir * rayDepth) + cameraPosition;

			// cloudProperties.thickness *= 1.05;
			// cp.altitude *= 0.99;
			// cloudProperties.coverage *= 1.03;
			// cloudProperties.density = saturate(cloudProperties.density * 1.05);
			// cloudProperties.density = 0.5;

			// cloudProperties.thickness = mix(200.0, 900.0, Get2DNoiseM(rayPos * 0.001));

			// cloudProperties.thickness = 200.0 + length(rayPos - cameraPosition) * 0.1;
			cp.altitude = CLOUD_GENUINE_ALTITUDE - length(rayPos - cameraPosition) * 0.0525;
			// cloudProperties.coverage = mix(-0.1, 0.5, Get2DNoiseM(rayPos * 0.0015));



			//When fully opaque, stop
			if (cloudAccum.a < 0.00001)
			{
				break;
			}

			//early out if not in correct altitude range
			if (GetCloudHeightDensity(cp, rayPos) < 0.5)
			{
				rayDepth += rayStepSize;
				continue;
			}

			vec4 cloudSample = SampleVolumetricClouds(cp, rayPos, worldDir, atmosphere);
			cloudAccum.rgb += (cloudSample.rgb * cloudSample.a) * cloudAccum.a;
			cloudAccum.a *= 1.0 - cloudSample.a;

			rayDepth += rayStepSize;
		}
	#endif
	}
return cloudAccum;
}




float CloudVolumetricFog(vec3 worldPos, vec3 worldLightVector, CloudProperties cp, float planeLevel1,  float planeLevel2)
{
	float cloudDensityOffset = 30.0 * cp.density;

	Ray ray;
	ray.dir = worldLightVector;
	ray.origin = worldPos.xyz;

	Plane plane;
	plane.normal = vec3(0.0, 1.0, 0.0);
	plane.origin = vec3(0.0, planeLevel1, 0.0);

	vec3 cloudCheckPos = RayPlaneIntersection(ray, plane).pos;
	float cloudDensity = 1.0 - saturate(GetCloudDensity(cp, cloudCheckPos, CLOUD_FBM_OCTAVES) * cloudDensityOffset);

	plane.origin = vec3(0.0, planeLevel2, 0.0);

	cloudCheckPos = RayPlaneIntersection(ray, plane).pos;
	cloudDensity *= 1.0 - saturate(GetCloudDensity(cp, cloudCheckPos, CLOUD_FBM_OCTAVES) * cloudDensityOffset);

	return cloudDensity;
}
///*
float CloudVolumetricFogHQ(vec3 worldPos, vec3 worldLightVector, CloudProperties cp)
{
	int steps = 13;

	Ray ray;
	ray.dir = worldLightVector;
	ray.origin = worldPos.xyz;

	Plane plane;
	plane.normal = vec3(0.0, 1.0, 0.0);
	plane.origin = vec3(0.0, fma(cp.thickness, 0.05f, cp.altitude), 0.0);

	float density = 0.0;

	float planeIncrement = cp.thickness / steps;

	for (int i = 0; i < steps; i++)
	{
		vec3 cloudCheckPos = RayPlaneIntersection(ray, plane).pos;
		float cloudDensity = GetCloudDensity(cp, cloudCheckPos, CLOUD_FBM_OCTAVES);

		density += cloudDensity;

		plane.origin.y += planeIncrement;
	}
	density /= steps;

	density = remap(0.007, 0.0069, density);


	return density;
}
//*/
float GetCloudPlaneDensity(vec3 worldPos, vec3 worldLightVector, CloudProperties cp)
{
	float planeLevel1 = cp.altitude + cp.thickness * cp.lowerLimit;
	float planeLevel2 = cp.altitude + cp.thickness * (cp.upperLimit + 0.8) * 0.5;
	float cloudDensityOffset = 3.0;

	Ray ray;
	ray.dir = worldLightVector;
	ray.origin = worldPos.xyz;

	Plane plane;
	plane.normal = vec3(0.0, 1.0, 0.0);
	plane.origin = vec3(0.0, planeLevel1, 0.0);

	int octaves = clamp(CLOUD_FBM_OCTAVES, 3, 5);
	//octaves = 3;

	vec3 cloudCheckPos = RayPlaneIntersection(ray, plane).pos;
	float cloudDensity = 1.0 - saturate(GetCloudDensity(cp, cloudCheckPos, octaves) * cloudDensityOffset);

	plane.origin = vec3(0.0, planeLevel2, 0.0);

	cloudCheckPos = RayPlaneIntersection(ray, plane).pos;
	cloudDensity *= 1.0 - saturate(GetCloudDensity(cp, cloudCheckPos, octaves) * cloudDensityOffset);

	return cloudDensity;
}

float CloudShadow(vec3 worldPos, vec3 worldLightVector, CloudProperties cp)
{
	worldPos.xyz += cameraPosition.xyz;
	float cloudDensity = GetCloudPlaneDensity(worldPos, worldLightVector, cp);

	float fadeAngle = 1.0 - pow((clamp(abs(worldLightVector.y), 0.1 ,0.3) - 0.1) * 5.0, 3.0);

	cloudDensity = mix(cloudDensity, 1.0 - wetness, fadeAngle);
	cloudDensity = remap(0.0, 0.5, cloudDensity);
	//cloudDensity = clamp(cloudDensity, 0.02, 1.0);

	return cloudDensity;
}
