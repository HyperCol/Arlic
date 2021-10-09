#define PLANE_CLOUDS

#define PC_COVERAGE 0.5 // [0 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.2 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.3 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.4 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.5 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.6 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.7 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.8 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.9 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1]

#define PC_NOISE_SCALE 0.03

#define PC_ALTITUDE 4000



vec4 GetNoise(sampler2D noiseSampler, vec2 position) {
	return texture(noiseSampler, position / 1e4);
}

vec2 cubeSmooth(vec2 x){
    return x * x * (3.0 - 2.0 * x);
}

float Get2DNoise(vec2 pos)
{
	vec2 p = floor(pos);
	vec2 f = cubeSmooth(fract(pos));

	vec2 uv =  p + f + 0.5;

	return texture2D(noisetex, uv / noiseTextureResolution).x;
}




const float tau         = radians(360.0);
const float phi         = sqrt(5.0) * 0.5 + 0.5;
const float goldenAngle = tau / (phi + 1.0);

const mat2 rotateGoldenAngle = mat2(cos(goldenAngle), -sin(goldenAngle), sin(goldenAngle), cos(goldenAngle));


float Get2DCloudsDensity(vec2 position, vec2 cloudsTime) {
	position *= PC_NOISE_SCALE;

	position += vec2(GetNoise(noisetex, position * vec2(2.0, 0.7) - cloudsTime).x * 50.0);
	//position += vec2(GetNoise(noisetex, position * vec2(6.0, -2.0) - cloudsTime).x * 20.0);


	float noise = 0.0;
	{
		const int octaves = 5;
		const float alpha = 0.85;
		const float freqGain = 3.6;

		vec2 noisePosition = position;
		noise = GetNoise(noisetex, noisePosition - cloudsTime).x;
		float weightSum = 1.0;
		mat2 rot = freqGain * rotateGoldenAngle;

		for (int i = 1; i < octaves; ++i)
		{
			float f = pow(freqGain, i);
			vec2 noisePosition = rot * (noisePosition - cloudsTime * sqrt(i + 1.0));
			noisePosition *= vec2(1.0 - 0.35 * sqrt(i), 1.0 + 0.05 * sqrt(i));
			float weight = 1.0 / pow(f, alpha);
			noise += GetNoise(noisetex, noisePosition).x * weight;
			weightSum += weight;
			rot *= freqGain * rotateGoldenAngle;
		}
		noise /= weightSum;
	}

	float density = saturate(noise + PC_COVERAGE - 1.0);
	density = density * density;
	return density;
}

//--// Lighting //------------------------------------------------------------//



void Calculate2DClouds(inout vec3 color, vec3 viewVector, vec3 viewOffset, float dither, vec3 atmosphere) {
	vec3 viewPosition = cameraPosition + viewOffset;

	Ray ray;
	ray.dir = viewVector;
	ray.origin = vec3(0.0, eyeAltitude, 0.0);

	Plane plane;
	plane.normal = vec3(0.0, 1.0, 0.0);
	plane.origin = vec3(0.0, PC_ALTITUDE, 0.0);

	Intersection rps = RayPlaneIntersection(ray, plane);
	float centerDistance = rps.distance;
	if (centerDistance <= 0.0) return;
	vec3 centerPosition = rps.pos;

	float frameTime = 0.8 * (frameTimeCounter * CLOUD_SPEED + 10.0 * FTC_OFFSET);
	vec2 cloudsTime = vec2(frameTime, -frameTime * 0.2);

	float density = Get2DCloudsDensity(centerPosition.xz, cloudsTime);
	if (density <= 0.0) return;

	vec3 cloudColor = color + (colorSunlight + colorSkylight * 0.002) * density * 400.0;

	//color += (colorSunlight + colorSkylight * 0.01) * density * 200.0;

	color = mix(color, pow(cloudColor * 0.0001, vec3(1.0 / 2.2)), saturate(exp2(-centerDistance * 0.00006)));
	color *= 2.8;
}
