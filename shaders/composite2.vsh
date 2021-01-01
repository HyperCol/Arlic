#version 120

#define MOON_LIGHT_NIGHT  0.6  // [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define SKYLIGHT_NIGHT  3.8    // [0.2 0.6 1.0 1.4 1.8 2.2 2.6 3.0 3.4 3.8 4.2 4.6 5.0]
#define FANTASIC_NIGHTSKY  0.0 // [0.0 0.5 1.0 1.5 2.0 3.0 4.0 5.0]

#define SKYLIGHT_NIGHT_R 0.6   //[0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2.0 2.05 2.1 2.15 2.2 2.25 2.3 2.35 2.4 2.45 2.5 2.55 2.6]  
#define SKYLIGHT_NIGHT_G 0.45  //[0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2.0 2.05 2.1 2.15 2.2 2.25 2.3 2.35 2.4 2.45 2.5 2.55 2.6]  
#define SKYLIGHT_NIGHT_B 4.0   //[0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2.0 2.05 2.1 2.15 2.2 2.25 2.3 2.35 2.4 2.45 2.5 2.55 2.6 2.6 52.7 2.7 52.8 2.85 2.9 2.95 3.0 3.05 3.1 3.15 3.2 3.25 3.3 3.35 3.4 3.45 3.5 3.55 3.6 3.65 3.7 3.75 3.8 3.85 3.9 3.95 4.0 4.05 4.1]  

#define SKYLIGHT_DAY_RED 0.6   //[0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2.0 2.05 2.1 2.15 2.2 2.25 2.3 2.35 2.4 2.45 2.5 2.55 2.6]  
#define SKYLIGHT_DAY_GREEN 1.0 //[0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2.0 2.05 2.1 2.15 2.2 2.25 2.3 2.35 2.4 2.45 2.5 2.55 2.6]  
#define SKYLIGHT_DAY_BULE 0.6  //[0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2.0 2.05 2.1 2.15 2.2 2.25 2.3 2.35 2.4 2.45 2.5 2.55 2.6]

#define SKY_DESATURATION 0.0f

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


	float timePow = 3.2f;

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
	 sunrise_sun.r = 1.0;
	 sunrise_sun.g = 0.6;
	 sunrise_sun.b = 0.0;
	 sunrise_sun *= 1.55f;

	vec3 sunrise_amb;
	 sunrise_amb.r = 0.30 ;
	 sunrise_amb.g = 0.595;
	 sunrise_amb.b = 0.70 ;
	 sunrise_amb *= 1.0f;


	vec3 noon_sun;
	 noon_sun.r = mix(0.90, 1.00, rayleigh);
	 noon_sun.g = mix(0.80, 0.75, rayleigh);
	 noon_sun.b = mix(0.60, 0.00, rayleigh); 

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
	if (FANTASIC_NIGHTSKY > 0){
	 midnight_sun.r = 1.2f;
	 midnight_sun.g = 2.0f/sqrt(0.5*FANTASIC_NIGHTSKY+1);
	 midnight_sun.b = 2.5f;
	 }else{
	 midnight_sun.r = 1.2f;
	 midnight_sun.g = 2.0f;
	 midnight_sun.b = 2.5f;
	 }
	 midnight_sun *= MOON_LIGHT_NIGHT;
	
	vec3 midnight_amb;
	 midnight_amb.r = 0.0 ;
	 midnight_amb.g = 0.23;
	 midnight_amb.b = 0.99;


	colorSunlight = sunrise_sun * timeSunriseSunset  +  noon_sun * timeNoon  +  midnight_sun * timeMidnight;



	sunrise_amb = vec3(0.19f, 0.35f, 0.7f) * 0.15f;
	noon_amb	= vec3(0.15 * SKYLIGHT_DAY_RED, 0.375 * SKYLIGHT_DAY_GREEN, 1.34f * SKYLIGHT_DAY_BULE) * 0.62f;
		if (FANTASIC_NIGHTSKY > 0){
			//midnight_amb = vec3(0.6f, 0.45f/FANTASIC_NIGHTSKY, 4.0f) * 0.0003f * SKYLIGHT_NIGHT;
			midnight_amb = vec3(SKYLIGHT_NIGHT_R, SKYLIGHT_NIGHT_G / FANTASIC_NIGHTSKY, SKYLIGHT_NIGHT_B) * 0.0003f * SKYLIGHT_NIGHT;
		}else{
			midnight_amb = vec3(0.005f, 0.25f, 1.0f) * 0.001f * SKYLIGHT_NIGHT;
		}

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
	colorSunlight = pow(colorSunlight, vec3(2.9f));

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
