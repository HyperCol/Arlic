#if !defined INCLUDE_COMMON
#define INCLUDE_COMMON

uniform float near;
uniform float far;
uniform vec2 pixel;
uniform vec2 resolution;

const float PI = 3.14159265;
const float Pi = 3.14159265;

#define pow2(x) (x * x)
#define pow3(x) (x * pow2(x))
#define pow4(x) (x * pow3(x))
#define pow5(x) (x * pow4(x))

float saturate(float x) {
	return clamp(x, 0.0, 1.0);
}

vec2 saturate(vec2 x) {
	return clamp(x, vec2(0.0), vec2(1.0));
}

vec3 saturate(vec3 x) {
	return clamp(x, vec3(0.0), vec3(1.0));
}

vec3 nvec3(vec4 x){ 
	return x.xyz / x.w;
}

vec4 nvec4(vec3 x){
	 return vec4(x, 1.0);
}

vec3 Linear(vec3 color){
	return pow(color, vec3(1.0 / 2.2));
}

vec3 Gamma(vec3 color){
	return pow(color, vec3(2.2));
}
#endif