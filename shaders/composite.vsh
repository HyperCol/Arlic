#version 120

varying vec4 texcoord;

uniform vec3 sunPosition;
uniform vec3 moonPosition;
uniform vec3 upPosition;
uniform float rainStrength;
uniform vec3 skyColor;
uniform float sunAngle;

uniform int worldTime;

varying vec3 lightVector;
varying vec3 upVector;

varying float timeSunriseSunset;
varying float timeNoon;
varying float timeMidnight;
varying float timeSkyDark;

varying vec3 colorSunlight;
varying vec3 colorSkylight;
varying vec3 colorSunglow;
varying vec3 colorBouncedSunlight;
varying vec3 colorScatteredSunlight;
varying vec3 colorTorchlight;
varying vec3 colorWaterMurk;
varying vec3 colorWaterBlue;
varying vec3 colorSkyTint;


float CubicSmooth(in float x)
{
	return x * x * (3.0f - 2.0f * x);
}

float clamp01(float x)
{
	return clamp(x, 0.0, 1.0);
}


void main() {
	gl_Position = ftransform();
	
	texcoord = gl_MultiTexCoord0;

	if (sunAngle < 0.5f) {
		lightVector = normalize(sunPosition);
	} else {
		lightVector = normalize(moonPosition);
	}

	vec3 sunVector = normalize(sunPosition);

	upVector = normalize(upPosition);
	
	
	float timePow = 4.0f;

	float LdotUp = dot(upVector, sunVector);
	float LdotDown = dot(-upVector, sunVector);

	timeNoon = 1.0 - pow(1.0 - clamp01(LdotUp), timePow);
	timeSunriseSunset = 1.0 - timeNoon;
	timeMidnight = CubicSmooth(CubicSmooth(clamp01(LdotDown * 20.0f + 0.4)));
	timeMidnight = 1.0 - pow(1.0 - timeMidnight, 2.0);
	timeSunriseSunset *= 1.0 - timeMidnight;
	timeNoon *= 1.0 - timeMidnight;

	// timeSkyDark = clamp01(LdotDown);
	// timeSkyDark = pow(timeSkyDark, 3.0f);
	timeSkyDark = 0.0f;


	float horizonTime = CubicSmooth(clamp01((1.0 - abs(LdotUp)) * 4.0f - 3.0f));
	horizonTime = 1.0 - pow(1.0 - horizonTime, 3.0);
	
	const float rayleigh = 0.02f;


	colorWaterMurk = vec3(0.2f, 0.5f, 0.95f);
	colorWaterBlue = vec3(0.2f, 0.5f, 0.95f);
	colorWaterBlue = mix(colorWaterBlue, vec3(1.0f), vec3(0.5f));

//colors for shadows/sunlight and sky
	
	vec3 sunrise_sun;
	 sunrise_sun.r = 1.00;
	 sunrise_sun.g = 0.58;
	 sunrise_sun.b = 0.00;
	 sunrise_sun *= 0.65f;
	
	vec3 sunrise_amb;
	 sunrise_amb.r = 0.30 ;
	 sunrise_amb.g = 0.595;
	 sunrise_amb.b = 0.70 ;	
	 sunrise_amb *= 1.0f;
	 
	
	vec3 noon_sun;
	 noon_sun.r = mix(1.00, 1.00, rayleigh);
	 noon_sun.g = mix(1.00, 0.75, rayleigh);
	 noon_sun.b = mix(1.00, 0.00, rayleigh);	 
	
	vec3 noon_amb;
	 noon_amb.r = 0.00 ;
	 noon_amb.g = 0.3  ;
	 noon_amb.b = 0.999;
	
	// vec3 sunset_sun;
	//  sunset_sun.r = 1.0 ;
	//  sunset_sun.g = 0.58;
	//  sunset_sun.b = 0.0 ;
	//  sunset_sun *= 0.65f;
	
	// vec3 sunset_amb;
	//  sunset_amb.r = 1.0;
	//  sunset_amb.g = 0.0;
	//  sunset_amb.b = 0.0;	
	//  sunset_amb *= 1.0f;
	
	vec3 midnight_sun;
	 midnight_sun.r = 1.0;
	 midnight_sun.g = 1.0;
	 midnight_sun.b = 1.0;
	
	vec3 midnight_amb;
	 midnight_amb.r = 0.0 ;
	 midnight_amb.g = 0.23;
	 midnight_amb.b = 0.99;


	colorSunlight = sunrise_sun * timeSunriseSunset  +  noon_sun * timeNoon  +  midnight_sun * timeMidnight;



	sunrise_amb = vec3(0.19f, 0.35f, 0.7f) * 0.15f;
	noon_amb    = vec3(0.15f, 0.29f, 0.99f);
	midnight_amb = vec3(0.005f, 0.01f, 0.02f) * 0.025f;
	
	colorSkylight = sunrise_amb * timeSunriseSunset  +  noon_amb * timeNoon  +  midnight_amb * timeMidnight;

	vec3 colorSunglow_sunrise;
	 colorSunglow_sunrise.r = 1.00f * timeSunriseSunset;
	 colorSunglow_sunrise.g = 0.46f * timeSunriseSunset;
	 colorSunglow_sunrise.b = 0.00f * timeSunriseSunset;
	 
	vec3 colorSunglow_noon;
	 colorSunglow_noon.r = 1.0f * timeNoon;
	 colorSunglow_noon.g = 1.0f * timeNoon;
	 colorSunglow_noon.b = 1.0f * timeNoon;
	 
	vec3 colorSunglow_midnight;
	 colorSunglow_midnight.r = 0.05f * 0.8f * 0.0055f * timeMidnight;
	 colorSunglow_midnight.g = 0.20f * 0.8f * 0.0055f * timeMidnight;
	 colorSunglow_midnight.b = 0.90f * 0.8f * 0.0055f * timeMidnight;
	
	 colorSunglow = colorSunglow_sunrise + colorSunglow_noon + colorSunglow_midnight;
	 
	 
	 
	
	 //colorBouncedSunlight = mix(vec3(0.64f, 0.73f, 0.34f), colorBouncedSunlight, 0.5f);
	 //colorBouncedSunlight = colorSunlight;
	 
	//colorSkylight.g *= 0.95f;
	 
	 //colorSkylight = mix(colorSkylight, vec3(dot(colorSkylight, vec3(1.0))), SKY_DESATURATION);
	 
	 float sun_fill = 0.0;
	
	 //colorSkylight = mix(colorSkylight, colorSunlight, sun_fill);
	 vec3 colorSkylight_rain = vec3(2.0, 2.0, 2.38) * 0.25f * (1.0f - timeMidnight * 0.9995f); //rain
	 colorSkylight = mix(colorSkylight, colorSkylight_rain, rainStrength); //rain
	

				
	//Saturate sunlight colors
	colorSunlight = pow(colorSunlight, vec3(4.2f));
	
	colorSunlight *= 1.0f - horizonTime;

	
	 colorBouncedSunlight = mix(colorSunlight, colorSkylight, 0.15f);
	 
	 colorScatteredSunlight = mix(colorSunlight, colorSkylight, 0.15f);

	 colorSunglow = pow(colorSunglow, vec3(2.5f));
	 
	//colorSunlight = vec3(1.0f, 0.5f, 0.0f);

	//Make ambient light darker when not day time
	// colorSkylight = mix(colorSkylight, colorSkylight * 0.03f, timeSunrise);
	// colorSkylight = mix(colorSkylight, colorSkylight * 1.0f, timeNoon);
	// colorSkylight = mix(colorSkylight, colorSkylight * 0.3f, timeSunset);
	// colorSkylight = mix(colorSkylight, colorSkylight * 0.0080f, timeMidnight);
	// colorSkylight *= mix(1.0f, 0.001f, timeMidnightLin);
	// colorSkylight *= mix(1.0f, 0.001f, timeSunriseLin);
	//colorSkylight = vec3(0.3f) * vec3(0.17f, 0.37f, 0.8f);

	// colorSkylight = vec3(0.0f, 0.0f, 1.0f);
	// colorSunlight = vec3(1.0f, 1.0f, 0.0f); //fuf
	
	//Make sunlight darker when not day time
	colorSunlight = mix(colorSunlight, colorSunlight * 0.5f, timeSunriseSunset);
	colorSunlight = mix(colorSunlight, colorSunlight * 1.0f, timeNoon);
	colorSunlight = mix(colorSunlight, colorSunlight * 0.00020f, timeMidnight);
	
	//Make reflected light darker when not day time
	colorBouncedSunlight = mix(colorBouncedSunlight, colorBouncedSunlight * 0.5f, timeSunriseSunset);
	colorBouncedSunlight = mix(colorBouncedSunlight, colorBouncedSunlight * 1.0f, timeNoon);
	colorBouncedSunlight = mix(colorBouncedSunlight, colorBouncedSunlight * 0.000015f, timeMidnight);
	
	//Make scattered light darker when not day time
	colorScatteredSunlight = mix(colorScatteredSunlight, colorScatteredSunlight * 0.5f, timeSunriseSunset);
	colorScatteredSunlight = mix(colorScatteredSunlight, colorScatteredSunlight * 1.0f, timeNoon);
	colorScatteredSunlight = mix(colorScatteredSunlight, colorScatteredSunlight * 0.000015f, timeMidnight);

	//Make scattered light darker when not day time
	// colorSkyTint = mix(colorSkyTint, colorSkyTint * 0.5f, timeSunrise);
	// colorSkyTint = mix(colorSkyTint, colorSkyTint * 1.0f, timeNoon);
	// colorSkyTint = mix(colorSkyTint, colorSkyTint * 0.5f, timeSunset);
	// colorSkyTint = mix(colorSkyTint, colorSkyTint * 0.0045f, timeMidnight);
	


	float colorSunlightLum = colorSunlight.r + colorSunlight.g + colorSunlight.b;
		  colorSunlightLum /= 3.0f;

	colorSunlight = mix(colorSunlight, vec3(colorSunlightLum), vec3(rainStrength));

	
	//Torchlight color
	float torchWhiteBalance = 0.05f;
	colorTorchlight = vec3(1.00f, 0.22f, 0.00f);
	colorTorchlight = mix(colorTorchlight, vec3(1.0f), vec3(torchWhiteBalance));

	colorTorchlight = pow(colorTorchlight, vec3(0.99f));


	//colorSkylight = vec3(0.1f);
	
}
