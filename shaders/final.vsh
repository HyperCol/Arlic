#version 120

#define OVERDRAW 1.0f

varying vec4 texcoord;

uniform int worldTime;

uniform vec3 sunPosition;
uniform vec3 moonPosition;
uniform vec3 upPosition;
uniform float rainStrength;
uniform float sunAngle;

varying float timeSunrise;
varying float timeNoon;
varying float timeSunset;
varying float timeMidnight;

varying vec3 lightVector;

void main() {
	gl_Position = ftransform();

	if (sunAngle < 0.5) {
		lightVector = normalize(sunPosition);
	} else {
		lightVector = normalize(moonPosition);
	}

	float timePow = 3.0f;
	float timefract = worldTime;

	timeSunrise	 = ((clamp(sunAngle, 0.95, 1.0f)  - 0.95f) / 0.05f) + (1.0 - (clamp(sunAngle, 0.0, 0.25) / 0.25f));
	timeNoon	 = ((clamp(sunAngle, 0.0, 0.25f))		   / 0.25f) - ( 	 (clamp(sunAngle, 0.25f, 0.5f) - 0.25f) / 0.25f);
	timeSunset	 = ((clamp(sunAngle, 0.25f, 0.5f) - 0.25f) / 0.25f) - ( 	 (clamp(sunAngle, 0.5f, 0.52) - 0.5f) / 0.02f);
	timeMidnight = ((clamp(sunAngle, 0.5f, 0.52f) - 0.5f) / 0.02f)	- ( 	 (clamp(sunAngle, 0.95, 1.0) - 0.95f) / 0.05f);

	timeSunrise	 = pow(timeSunrise, timePow);
	timeNoon	 = pow(timeNoon, 1.0f/timePow);
	timeSunset	 = pow(timeSunset, timePow);
	timeMidnight = pow(timeMidnight, 1.0f/timePow);

	texcoord = gl_MultiTexCoord0;

	// texcoord.st = texcoord.st * 2.0f - 1.0f;
	// texcoord.st /= 2.0f;
	// texcoord.st = texcoord.st * 0.5f + 0.5f;

	// texcoord = texcoord * 2.0f - 1.0f;
	// texcoord /= OVERDRAW;
	// texcoord = texcoord * 0.5f + 0.5f;
}
