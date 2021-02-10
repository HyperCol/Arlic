#ifndef INCLUDE_LIGHTMAP
#define INCLUDE_LIGHTMAP
#endif

float GetParallaxShadow(in vec2 coord)
{
	return 1.0 - texture2D(gdepth, coord).b;
}

//Lightmaps
float 	GetLightmapTorch(in vec2 coord) {			//Function that retrieves the lightmap of light emitted by emissive blocks like torches and lava
	float lightmap = unpack2x8X(texture2D(gdepth, coord).r);

	//Apply inverse square law and normalize for natural light falloff
	lightmap 		= clamp(lightmap * 1.22f, 0.0f, 1.0f);
	lightmap 		= 1.0f - lightmap;
	lightmap 		*= 5.6f;
	lightmap 		= 1.0f / pow((lightmap + 0.8f), 2.0f);
	lightmap 		-= 0.02435f;

	// if (lightmap <= 0.0f)
		// lightmap = 1.0f;

	lightmap 		= max(0.0f, lightmap);
	lightmap 		*= 0.008f;
	lightmap 		= clamp(lightmap, 0.0f, 1.0f);
	lightmap 		= pow(lightmap, 0.9f);
	return lightmap * 1.0;


}

float 	GetLightmapSky(in vec2 coord) {			//Function that retrieves the lightmap of light emitted by the sky. This is a raw value from 0 (fully dark) to 1 (fully lit) regardless of time of day
	//return pow(texture2D(gdepth, coord).b, 8.3f);

	float light = unpack2x8Y(texture2D(gdepth, coord).r);

	light = 1.0 - light * 0.834;
	light = 1.0 / light - 1;
	light = light / 5.0;

	light = max(0.0, light * 1.05 - 0.05);

	return pow(light, 2.0);
}

float 	GetLightmapTorch(in sampler2D tex, in vec2 coord) {			//Function that retrieves the lightmap of light emitted by emissive blocks like torches and lava
	float lightmap = unpack2x8X(texture2D(tex, coord).r);

	//Apply inverse square law and normalize for natural light falloff
	lightmap 		= clamp(lightmap * 1.22f, 0.0f, 1.0f);
	lightmap 		= 1.0f - lightmap;
	lightmap 		*= 5.6f;
	lightmap 		= 1.0f / pow((lightmap + 0.8f), 2.0f);
	lightmap 		-= 0.02435f;

	// if (lightmap <= 0.0f)
		// lightmap = 1.0f;

	lightmap 		= max(0.0f, lightmap);
	lightmap 		*= 0.008f;
	lightmap 		= clamp(lightmap, 0.0f, 1.0f);
	lightmap 		= pow(lightmap, 0.9f);
	return lightmap * 1.0;


}

float 	GetLightmapSky(in sampler2D tex, in vec2 coord) {			//Function that retrieves the lightmap of light emitted by the sky. This is a raw value from 0 (fully dark) to 1 (fully lit) regardless of time of day
	//return pow(texture2D(gdepth, coord).b, 8.3f);

	float light = unpack2x8Y(texture2D(tex, coord).r);

	light = 1.0 - light * 0.834;
	light = 1.0 / light - 1;
	light = light / 5.0;

	light = max(0.0, light * 1.05 - 0.05);

	return pow(light, 2.0);
}