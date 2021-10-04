//#define VCFOG
#define VCFOG_RANGE 			10000	// [6000 8000 10000 12500 15000 17500 20000]
#define VCFOG_DENSITY 			100.0	// [50.0 70.0 100.0 150.0 200.0]
#define VCFOG_QUALITY 			32		// [16 24 32 48 64 128]
//#define VCFOG_HIGH_ACCURACY
#define VCFOG_H_FADE_HEIGHT 	700 	// [500 700 1000]
#define VCFOG_H_FADE_MIDPOINT 	50.0 	// [50.0 70.0 100.0]
#define VCFOG_D_FADE_RATIO 		0.05	// [0.03 0.05 0.07 0.1]


void VolumetricFogCloud(inout vec3 color, in vec3 worldDir, in CloudProperties cp, in float noise){

	float rayDensity = 0.0;

	int steps = VCFOG_QUALITY;

	vec3 start = gbufferModelViewInverse[3].xyz;
	vec3 end = worldDir * VCFOG_RANGE;

	vec3 increment = (end - start) / steps;
	vec3 rayPosition = increment * noise + cameraPosition;


	float VoL = dot(worldDir, worldLightVector);

	float planeLevel1 = cp.altitude + cp.thickness * cp.lowerLimit;
	float planeLevel2 = cp.altitude + cp.thickness * (cp.upperLimit + 0.8) * 0.5;
	float midPoint = VCFOG_H_FADE_MIDPOINT;
	float lowPoint = planeLevel1 + VCFOG_H_FADE_HEIGHT;

	float cloudDensity, rayLengthVertical, rayVerticalDensity;

	float an = 1.0;
	float fadeRatio = 1.0 - 160000.0 * VCFOG_D_FADE_RATIO / steps / VCFOG_RANGE;

	for (int i = 1; i <= steps; i++, rayPosition += increment)
	{

		if(rayPosition.y > planeLevel1) break;

		#ifdef VCFOG_HIGH_ACCURACY
			cloudDensity = CloudVolumetricFogHQ(rayPosition, worldLightVector, cp);
		#else
			cloudDensity = CloudVolumetricFog(rayPosition, worldLightVector, cp, planeLevel1, planeLevel2);
		#endif

		rayLengthVertical = planeLevel1 - rayPosition.y;

		rayVerticalDensity = remap(0.0, midPoint, rayLengthVertical);
		rayVerticalDensity *= remap(lowPoint, midPoint, rayLengthVertical);
		rayVerticalDensity = smoothstep(0.0, 1.0, rayVerticalDensity);

		cloudDensity *= rayVerticalDensity;

		rayDensity += cloudDensity * an;

		an *= fadeRatio;
	}
	rayDensity /= steps;


	vec3 rayColor = rayDensity * colorSunlight * VCFOG_DENSITY;

	rayColor *= pow((VoL + 1.0) * 0.5, 2.0);


	color += rayColor;
}
