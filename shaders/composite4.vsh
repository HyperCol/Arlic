#version 120

varying vec4 texcoord;

uniform float sunAngle;

uniform vec3 sunPosition;
uniform vec3 moonPosition;

uniform int worldTime;

varying float timeSunrise;
varying float timeNoon;
varying float timeSunset;
varying float timeMidnight;

float cubeSmooth(in float x)
{
	return x * x * (3.0f - 2.0f * x);
}

void main() {
	gl_Position = ftransform();
	
	float timePow = 3.2f;
	float timefract = worldTime;
	
	float timeSunriseLin  = ((clamp(sunAngle, 0.95, 1.0f)  - 0.95f) / 0.05f) + (1.0 - (clamp(sunAngle, 0.0, 0.25) / 0.25f));  
	float timeNoonLin     = ((clamp(sunAngle, 0.0, 0.25f)) 	       / 0.25f)  - (		 (clamp(sunAngle, 0.25f, 0.5f) - 0.25f) / 0.25f);
	float timeSunsetLin   = ((clamp(sunAngle, 0.25f, 0.5f) - 0.25f) / 0.25f) - (		 (clamp(sunAngle, 0.5f, 0.52) - 0.5f) / 0.02f);  
	float timeMidnightLin = ((clamp(sunAngle, 0.5f, 0.52f) - 0.5f) / 0.02f)  - (		 (clamp(sunAngle, 0.95, 1.0) - 0.95f) / 0.05f);

	timeSunriseLin = cubeSmooth(timeSunriseLin);
	timeNoonLin = cubeSmooth(timeNoonLin);
	timeSunsetLin = cubeSmooth(timeSunsetLin);
	timeMidnightLin = cubeSmooth(timeMidnightLin);
	
	timeSunrise  = pow(timeSunriseLin, timePow);
	timeNoon     = 1.0f - pow(1.0f - timeNoonLin, timePow);
	timeSunset   = pow(timeSunsetLin, timePow);
	timeMidnight = 1.0f - pow(1.0f - timeMidnightLin, timePow);	
	
	texcoord = gl_MultiTexCoord0;
}
