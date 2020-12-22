#if !(defined _INCLUDE_UNIFORM)
#define _INCLUDE_UNIFORM

#ifndef VIEW_WIDTH
#define VIEW_WIDTH
uniform float viewWidth;                        // viewWidth
uniform float viewHeight;                       // viewHeight
uniform vec2 pixel;
#endif

uniform float screenBrightness;                 //screen brightness (0.0-1.0)

uniform float near;
uniform float far;

uniform vec3 skyColor;
uniform vec3 BiomeType;
uniform int isEyeInWater;

uniform float wetness;
uniform float rainStrength;
uniform float rain0;
uniform float rain1;

uniform ivec2 eyeBrightness;
uniform float centerDepthSmooth;
uniform ivec2 eyeBrightnessSmooth;

uniform sampler2D depthtex0;
uniform sampler2D depthtex1;

//matrix
uniform mat4 shadowModelView;
uniform mat4 shadowModelViewInverse;
uniform mat4 shadowProjection;
uniform mat4 shadowProjectionInverse;

uniform mat4 gbufferPreviousModelView;
uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferPreviousProjection;
uniform mat4 gbufferProjection;
uniform mat4 gbufferProjectionInverse;

//in eye space
uniform vec3 upPosition;
uniform vec3 sunPosition;
uniform vec3 moonPosition;
uniform vec3 shadowLightPosition;

uniform vec3 sunVectorView;
uniform vec3 moonVectorView;
uniform vec3 shadowLightVectorView;

//in world space
uniform vec3 sunVector;
uniform vec3 moonVector;
uniform vec3 shaderLightVector;

uniform vec3 cameraPosition;
uniform vec3 previousCameraPosition;

//time
uniform vec4 Time;
uniform vec4 nTime;
uniform vec4 SunTime0;

uniform float frameTimeCounter;
uniform int worldTime;
uniform int moonPhase;
uniform float day_cycle;
uniform float cloud_coverage;

//#define WorldTimeAnimation

#ifdef WorldTimeAnimation
float frametime = float(worldTime)/20.0;
#else
float frametime = frameTimeCounter;
#endif

//float rain0 = rainStrength * smoothstep(0.0, 0.5, BiomeType.y);
//float rain1 = rainStrength * smoothstep(0.5, 1.0, BiomeType.y);
#endif 