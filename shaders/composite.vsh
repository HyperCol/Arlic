#version 120

#define SKY_DESATURATION 0.0f

#define MOON_LIGHT_NIGHT  0.6 // [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define SKYLIGHT_NIGHT  3.8// [0.2 0.6 1.0 1.4 1.8 2.2 2.6 3.0 3.4 3.8 4.2 4.6 5.0]
#define FANTASIC_NIGHTSKY  0.0 // [0.0 0.5 1.0 1.5 2.0 3.0 4.0 5.0]
#define WHITE_TORCH_LIGHT 0.0 // [-0.02 -0.01 0.0 0.025 0.05 0.1 0.15 0.25 0.5 0.75 1.0]
#define SKYLIGHT_DAY_RED 0.6 // [0.4 0.6 0.8 1.0 1.2 1.4 1.6]
#define SKYLIGHT_DAY_GREEN 1.0 // [0.4 0.6 0.8 1.0 1.2 1.4 1.6]
#define SKYLIGHT_DAY_BULE 0.6 // [0.4 0.6 0.8 1.0 1.2 1.4 1.6]
#define NSL
//#define GOLDENSKY
#define ACES_TONEMAPPING
#define WEATHER
//#define OLD_PHOTOS
varying vec4 texcoord;

uniform vec3 sunPosition;
uniform vec3 moonPosition;
uniform vec3 upPosition;
uniform float rainStrength;
uniform vec3 skyColor;
uniform float sunAngle;

uniform int worldTime;
uniform int moonPhase;

varying vec3 lightVector;
varying vec3 upVector;

varying float timeSunrise;
varying float timeNoon;
varying float timeSunset;
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

float weather(in vec2 coord) {
#ifdef WEATHER
if (worldTime>6000){
return 2+moonPhase;
}else{
return 1+moonPhase;
}
#else
return 0.0f;
#endif
}

float cubeSmooth(in float x)
{
	return x * x * (3.0f - 2.0f * x);
}


void main() {
	gl_Position = ftransform();

	texcoord = gl_MultiTexCoord0;

	if (sunAngle < 0.5f) {
		lightVector = normalize(sunPosition);
	} else {
		lightVector = normalize(moonPosition);
	}

	upVector = normalize(upPosition);


	float timePow = 3.2f;
	float timefract = worldTime;

	// timeSunrise	= ((clamp(timefract, 23000.0, 24000.0) - 23000.0) / 1000.0) + (1.0 - (clamp(timefract, 0.0, 4000.0)/4000.0));
	// timeNoon		= ((clamp(timefract, 0.0, 4000.0)) / 4000.0) - ((clamp(timefract, 8000.0, 12000.0) - 8000.0) / 4000.0);
	// timeSunset	= ((clamp(timefract, 8000.0, 12000.0) - 8000.0) / 4000.0) - ((clamp(timefract, 12000.0, 12750.0) - 12000.0) / 750.0);
	// timeMidnight = ((clamp(timefract, 12000.0, 12750.0) - 12000.0) / 750.0) - ((clamp(timefract, 23000.0, 24000.0) - 23000.0) / 1000.0);



	float timeSunriseLin  = ((clamp(sunAngle, 0.95, 1.0f)  - 0.95f) / 0.05f) + (1.0 - (clamp(sunAngle, 0.0, 0.25) / 0.25f));
	float timeNoonLin	  = ((clamp(sunAngle, 0.0, 0.25f))		   / 0.25f)	 - (		 (clamp(sunAngle, 0.25f, 0.5f) - 0.25f) / 0.25f);
	float timeSunsetLin	  = ((clamp(sunAngle, 0.25f, 0.5f) - 0.25f) / 0.25f) - (		 (clamp(sunAngle, 0.5f, 0.52) - 0.5f) / 0.02f);
	float timeMidnightLin = ((clamp(sunAngle, 0.5f, 0.52f) - 0.5f) / 0.02f)	 - (		 (clamp(sunAngle, 0.95, 1.0) - 0.95f) / 0.05f);

	timeSunriseLin = cubeSmooth(timeSunriseLin);
	timeNoonLin = cubeSmooth(timeNoonLin);
	timeSunsetLin = cubeSmooth(timeSunsetLin);
	timeMidnightLin = cubeSmooth(timeMidnightLin);

	timeSkyDark = ((clamp(sunAngle, 0.5, 0.6) - 0.5) / 0.1) - ((clamp(timefract, 0.9, 1.0) - 0.9) / 0.1);
	timeSkyDark = pow(timeSkyDark, 3.0f);
	timeSkyDark = 0.0f;

	timeSunrise	 = pow(timeSunriseLin, timePow);
	timeNoon	 = 1.0f - pow(1.0f - timeNoonLin, timePow);
	timeSunset	 = pow(timeSunsetLin, timePow);
	timeMidnight = 1.0f - pow(1.0f - timeMidnightLin, timePow);


	float horizonTime = clamp(0.1f - abs(sunAngle - 0.5f), 0.0f, 0.1f) / 0.1f;
		  horizonTime += clamp(sunAngle - 0.9f, 0.0f, 0.1f) / 0.1f;
		  horizonTime += clamp(0.1 - sunAngle, 0.0f, 1.0f) / 0.1f;

		  horizonTime = pow(horizonTime, 2.0f);

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

vec3 sunset_sun;
	 sunset_sun.r = 1.6;
	 sunset_sun.g = 0.8;
	 sunset_sun.b = 0.3 ;
	 sunset_sun *= 1.15f;

	vec3 sunset_amb;
	 sunset_amb.r = 1.0;
	 sunset_amb.g = 0.0;
	 sunset_amb.b = 0.0;
	 sunset_amb *= 1.0f;
 
	vec3 midnight_sun;
	if (weather(texcoord.st)==3||weather(texcoord.st)==7){
	 midnight_sun.r = 1.2f;
	 midnight_sun.g = 1.6;
	 midnight_sun.b = 2.5f;
	}else{
	if (FANTASIC_NIGHTSKY > 0){
	 midnight_sun.r = 1.2f;
	 midnight_sun.g = 2.0f/sqrt(0.5*FANTASIC_NIGHTSKY+1);
	 midnight_sun.b = 2.5f;
	 }else{
	 midnight_sun.r = 1.2f;
	 midnight_sun.g = 2.0f;
	 midnight_sun.b = 2.5f;
	 }}
	 #ifdef ACES_TONEMAPPING
	 midnight_sun *= 1.4f;
	 #endif
	 midnight_sun *= MOON_LIGHT_NIGHT;
	 
	vec3 midnight_amb;
	 midnight_amb.r = 0.0 ;
	 midnight_amb.g = 0.23;
	 midnight_amb.b = 0.99;


	colorSunlight = sunrise_sun * timeSunrise  +  noon_sun * timeNoon  +  sunset_sun * timeSunset  +  midnight_sun * timeMidnight;



	sunrise_amb = vec3(1.5f, 0.5f, 1.1f) * 0.15f;
	#ifdef OLD_PHOTOS
	noon_amb	= vec3(0.25,0.5,0.8) * 0.62f;
	#else
	noon_amb	= vec3(0.15 * SKYLIGHT_DAY_RED, 0.375 * SKYLIGHT_DAY_GREEN, 1.34f * SKYLIGHT_DAY_BULE) * 0.62f;
	#endif
	
	if (weather(texcoord.st)==0){
	#ifdef GOLDENSKY
	sunset_amb	= vec3(0.8f, 0.4f, 0.5f) * 0.15f;	
	#else
	sunset_amb	= vec3(0.22f, 0.25f, 0.8f) * 0.45f;
	#endif
	}else{
	if (weather(texcoord.st)==2||weather(texcoord.st)==7||weather(texcoord.st)==4||weather(texcoord.st)==8){
	sunset_amb	= vec3(0.22f, 0.25f, 0.8f) * 0.45f;
	}else{
	sunset_amb	= vec3(0.8f, 0.4f, 0.5f) * 0.15f;
	}}
	
	
	
	if (weather(texcoord.st)==3||weather(texcoord.st)==7){
	midnight_amb = vec3(0.6f, 0.45f, 4.0f) * 0.0003f * SKYLIGHT_NIGHT;
	}else{
	if (FANTASIC_NIGHTSKY > 0){
	midnight_amb = vec3(0.6f, 0.45f/FANTASIC_NIGHTSKY, 4.0f) * 0.0003f * SKYLIGHT_NIGHT;
	}else{
	midnight_amb = vec3(0.005f, 0.25f, 1.0f) * 0.001f * SKYLIGHT_NIGHT;
	}}

	colorSkylight = sunrise_amb * timeSunrise  +  noon_amb * timeNoon  +  sunset_amb * timeSunset  +  midnight_amb * timeMidnight;

	vec3 colorSunglow_sunrise;
	 colorSunglow_sunrise.r = 1.00f * timeSunrise;
	 colorSunglow_sunrise.g = 0.46f * timeSunrise;
	 colorSunglow_sunrise.b = 0.00f * timeSunrise;

	vec3 colorSunglow_noon;
	 colorSunglow_noon.r = 1.0f * timeNoon;
	 colorSunglow_noon.g = 1.0f * timeNoon;
	 colorSunglow_noon.b = 1.0f * timeNoon;

	vec3 colorSunglow_sunset;
	 colorSunglow_sunset.r = 1.00f * timeSunset;
	 colorSunglow_sunset.g = 0.38f * timeSunset;
	 colorSunglow_sunset.b = 0.00f * timeSunset;

	vec3 colorSunglow_midnight;
	 colorSunglow_midnight.r = 0.05f * 0.8f * 0.0055f * timeMidnight;
	 colorSunglow_midnight.g = 0.20f * 0.8f * 0.0055f * timeMidnight;
	 colorSunglow_midnight.b = 0.90f * 0.8f * 0.0055f * timeMidnight;

	 colorSunglow = colorSunglow_sunrise + colorSunglow_noon + colorSunglow_sunset + colorSunglow_midnight;




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
	colorSunlight = mix(colorSunlight, colorSunlight * 0.5f, timeSunrise);
	colorSunlight = mix(colorSunlight, colorSunlight * 1.0f, timeNoon);
	colorSunlight = mix(colorSunlight, colorSunlight * 0.5f, timeSunset);
	colorSunlight = mix(colorSunlight, colorSunlight * 0.00020f, timeMidnight);

	//Make reflected light darker when not day time
	colorBouncedSunlight = mix(colorBouncedSunlight, colorBouncedSunlight * 0.5f, timeSunrise);
	colorBouncedSunlight = mix(colorBouncedSunlight, colorBouncedSunlight * 1.0f, timeNoon);
	colorBouncedSunlight = mix(colorBouncedSunlight, colorBouncedSunlight * 0.5f, timeSunset);
	colorBouncedSunlight = mix(colorBouncedSunlight, colorBouncedSunlight * 0.000015f, timeMidnight);

	//Make scattered light darker when not day time
	colorScatteredSunlight = mix(colorScatteredSunlight, colorScatteredSunlight * 0.5f, timeSunrise);
	colorScatteredSunlight = mix(colorScatteredSunlight, colorScatteredSunlight * 1.0f, timeNoon);
	colorScatteredSunlight = mix(colorScatteredSunlight, colorScatteredSunlight * 0.5f, timeSunset);
	colorScatteredSunlight = mix(colorScatteredSunlight, colorScatteredSunlight * 0.000015f, timeMidnight);

	//Make scattered light darker when not day time
	// colorSkyTint = mix(colorSkyTint, colorSkyTint * 0.5f, timeSunrise);
	// colorSkyTint = mix(colorSkyTint, colorSkyTint * 1.0f, timeNoon);
	// colorSkyTint = mix(colorSkyTint, colorSkyTint * 0.5f, timeSunset);
	// colorSkyTint = mix(colorSkyTint, colorSkyTint * 0.0045f, timeMidnight);



	float colorSunlightLum = colorSunlight.r + colorSunlight.g + colorSunlight.b;
		  colorSunlightLum /= 3.0f;

	colorSunlight = mix(colorSunlight, vec3(colorSunlightLum), vec3(rainStrength));

	colorSunlight *= 1.0f - horizonTime;

	//Torchlight color
	float torchWhiteBalance = 0.02f;
	colorTorchlight = vec3(0.8f + 0.2 * WHITE_TORCH_LIGHT, 0.24f + 0.76 * WHITE_TORCH_LIGHT, 0.00f + WHITE_TORCH_LIGHT);
	colorTorchlight = mix(colorTorchlight, vec3(1.0f), vec3(torchWhiteBalance));

	colorTorchlight = pow(colorTorchlight, vec3(0.99f));


	//colorSkylight = vec3(0.1f);

}
