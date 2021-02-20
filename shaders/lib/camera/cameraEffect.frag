#if !defined _INCLUDE_CAMERA_
#define _INCLUDE_CAMERA_

#define AUTO_CAMERA 1                   //[0 1 2 3]
//0: Off | 1: All | 2: Aperture only | 3: Shutter only
    #define SENSOR_SIZE 11              //[4 6 8 9 11 16 17]
    #define FOCAL_POINT 0               //[0 1 2 4 8 16 24 32 40 48 56 64 72 80 88 96 104 112 120 128 136 144 152 160 168 176 184 192 200 208 216 224 232 240 248 256]
    #define CAMERA_APERTURE 2.8         //[1.4 2.0 2.8 4.0 5.6 8.0 11.0 16.0 22.0 32.0]
    #define CAMERA_SHUTTER_SPEED 1600   //[1 2 4 8 10 20 30 50 75 100 150 200 300 400 500 600 700 800 900 1000 1100 1200 1300 1400 1500 1600 1700 1800 1900 2000]
    #define CAMERA_ISO 400              //[50 75 100 200 400 800 1600 3200]
    #define CAMERA_EV 0.0               //[-4.0 -3.9 -3.8 -3.7 -3.6 -3.5 -3.4 -3.3 -3.2 -3.1 -3.0 -2.9 -2.8 -2.7 -2.6 -2.5 -2.4 -2.3 -2.2 -2.1 -2.0 -1.9 -1.8 -1.7 -1.6 -1.5 -1.4 -1.3 -1.2 -1.1 -1.0 -0.9 -0.8 -0.7 -0.6 -0.5 -0.4 -0.3 -0.2 -0.1 0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3.0 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4.0]

//#define MOTION_BLUR // It's motion blur.

#define DOF 1 //[0 1 2]
//0: Off | 1: Auto | 2: Manuel
	#define HEXAGONAL_BOKEH
		#define FRINGE_OFFSET 0.2 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

	#define FOCUS_BLUR
		//#define LINK_FOCUS_TO_BRIGHTNESS_BAR
	#define BLUR_AMOUNT 4.8 // [0.4 0.8 1.6 3.2 4.8 6.4 8.0 9.6]
	
	#define DISTANCE_BLUR
	#define MAX_DISTANCE_BLUR_AMOUNT 0.9 // [0.1 0.2 0.4 0.6 0.9 1.2 1.5 1.8]
	#define DISTANCE_BLUR_RANGE 360 // [60 120 180 240 360 480 600 720 960 1200]
		
	#define EDGE_BLUR
	#define EDGE_BLUR_AMOUNT 1.75  // [0.5 0.75 1.0 1.25 1.5 1.75 2.0]
	#define EDGE_BLUR_DECLINE 3.0  // [0.3 0.6 0.9 1.2 1.5 1.8 1.9 2.0 2.1 2.4 3.0 3.3 3.6 3.9 4.2]

#include "camera.glsl"

uniform float NfocalLength;

#ifdef HEXAGONAL_BOKEH
const vec2 offsets[60] = vec2[60] (	vec2(  0.2165,  0.1250 ),
                                    vec2(  0.0000,  0.2500 ),
                                    vec2( -0.2165,  0.1250 ),
                                    vec2( -0.2165, -0.1250 ),
                                    vec2( -0.0000, -0.2500 ),
                                    vec2(  0.2165, -0.1250 ),
                                    vec2(  0.4330,  0.2500 ),
                                    vec2(  0.0000,  0.5000 ),
                                    vec2( -0.4330,  0.2500 ),
                                    vec2( -0.4330, -0.2500 ),
                                    vec2( -0.0000, -0.5000 ),
                                    vec2(  0.4330, -0.2500 ),
                                    vec2(  0.6495,  0.3750 ),
                                    vec2(  0.0000,  0.7500 ),
                                    vec2( -0.6495,  0.3750 ),
                                    vec2( -0.6495, -0.3750 ),
                                    vec2( -0.0000, -0.7500 ),
                                    vec2(  0.6495, -0.3750 ),
                                    vec2(  0.8660,  0.5000 ),
                                    vec2(  0.0000,  1.0000 ),
                                    vec2( -0.8660,  0.5000 ),
                                    vec2( -0.8660, -0.5000 ),
                                    vec2( -0.0000, -1.0000 ),
                                    vec2(  0.8660, -0.5000 ),
                                    vec2(  0.2163,  0.3754 ),
                                    vec2( -0.2170,  0.3750 ),
                                    vec2( -0.4333, -0.0004 ),
                                    vec2( -0.2163, -0.3754 ),
                                    vec2(  0.2170, -0.3750 ),
                                    vec2(  0.4333,  0.0004 ),
                                    vec2(  0.4328,  0.5004 ),
                                    vec2( -0.2170,  0.6250 ),
                                    vec2( -0.6498,  0.1246 ),
                                    vec2( -0.4328, -0.5004 ),
                                    vec2(  0.2170, -0.6250 ),
                                    vec2(  0.6498, -0.1246 ),
                                    vec2(  0.6493,  0.6254 ),
                                    vec2( -0.2170,  0.8750 ),
                                    vec2( -0.8663,  0.2496 ),
                                    vec2( -0.6493, -0.6254 ),
                                    vec2(  0.2170, -0.8750 ),
                                    vec2(  0.8663, -0.2496 ),
                                    vec2(  0.2160,  0.6259 ),
                                    vec2( -0.4340,  0.5000 ),
                                    vec2( -0.6500, -0.1259 ),
                                    vec2( -0.2160, -0.6259 ),
                                    vec2(  0.4340, -0.5000 ),
                                    vec2(  0.6500,  0.1259 ),
                                    vec2(  0.4325,  0.7509 ),
                                    vec2( -0.4340,  0.7500 ),
                                    vec2( -0.8665, -0.0009 ),
                                    vec2( -0.4325, -0.7509 ),
                                    vec2(  0.4340, -0.7500 ),
                                    vec2(  0.8665,  0.0009 ),
                                    vec2(  0.2158,  0.8763 ),
                                    vec2( -0.6510,  0.6250 ),
                                    vec2( -0.8668, -0.2513 ),
                                    vec2( -0.2158, -0.8763 ),
                                    vec2(  0.6510, -0.6250 ),
                                    vec2(  0.8668,  0.2513 ));
#else
const vec2 offsets[60] = vec2[60] ( vec2(  0.0000,  0.2500 ),
                                    vec2( -0.2165,  0.1250 ),
                                    vec2( -0.2165, -0.1250 ),
                                    vec2( -0.0000, -0.2500 ),
                                    vec2(  0.2165, -0.1250 ),
                                    vec2(  0.2165,  0.1250 ),
                                    vec2(  0.0000,  0.5000 ),
                                    vec2( -0.2500,  0.4330 ),
                                    vec2( -0.4330,  0.2500 ),
                                    vec2( -0.5000,  0.0000 ),
                                    vec2( -0.4330, -0.2500 ),
                                    vec2( -0.2500, -0.4330 ),
                                    vec2( -0.0000, -0.5000 ),
                                    vec2(  0.2500, -0.4330 ),
                                    vec2(  0.4330, -0.2500 ),
                                    vec2(  0.5000, -0.0000 ),
                                    vec2(  0.4330,  0.2500 ),
                                    vec2(  0.2500,  0.4330 ),
                                    vec2(  0.0000,  0.7500 ),
                                    vec2( -0.2565,  0.7048 ),
                                    vec2( -0.4821,  0.5745 ),
                                    vec2( -0.6495,  0.3750 ),
                                    vec2( -0.7386,  0.1302 ),
                                    vec2( -0.7386, -0.1302 ),
                                    vec2( -0.6495, -0.3750 ),
                                    vec2( -0.4821, -0.5745 ),
                                    vec2( -0.2565, -0.7048 ),
                                    vec2( -0.0000, -0.7500 ),
                                    vec2(  0.2565, -0.7048 ),
                                    vec2(  0.4821, -0.5745 ),
                                    vec2(  0.6495, -0.3750 ),
                                    vec2(  0.7386, -0.1302 ),
                                    vec2(  0.7386,  0.1302 ),
                                    vec2(  0.6495,  0.3750 ),
                                    vec2(  0.4821,  0.5745 ),
                                    vec2(  0.2565,  0.7048 ),
                                    vec2(  0.0000,  1.0000 ),
                                    vec2( -0.2588,  0.9659 ),
                                    vec2( -0.5000,  0.8660 ),
                                    vec2( -0.7071,  0.7071 ),
                                    vec2( -0.8660,  0.5000 ),
                                    vec2( -0.9659,  0.2588 ),
                                    vec2( -1.0000,  0.0000 ),
                                    vec2( -0.9659, -0.2588 ),
                                    vec2( -0.8660, -0.5000 ),
                                    vec2( -0.7071, -0.7071 ),
                                    vec2( -0.5000, -0.8660 ),
                                    vec2( -0.2588, -0.9659 ),
                                    vec2( -0.0000, -1.0000 ),
                                    vec2(  0.2588, -0.9659 ),
                                    vec2(  0.5000, -0.8660 ),
                                    vec2(  0.7071, -0.7071 ),
                                    vec2(  0.8660, -0.5000 ),
                                    vec2(  0.9659, -0.2588 ),
                                    vec2(  1.0000, -0.0000 ),
                                    vec2(  0.9659,  0.2588 ),
                                    vec2(  0.8660,  0.5000 ),
                                    vec2(  0.7071,  0.7071 ),
                                    vec2(  0.5000,  0.8660 ),
                                    vec2(  0.2588,  0.9659 ));
#endif

struct Dof {
    float focalDepth;

    float FringeOffset;

    float BlurAmount;

    float MaxDistanceBlurAmount;
    float DistanceBlurRange;

    float EdgeBlurAmount;
    float EdgeBlurDecline;
};

struct Camera {
    float focalLength;      //焦距

    float aperture;         //光圈
    float iso;              //感光度
    float shutterSpeed;     //快门速度

    float ev100;            //曝光值
    float avgLuminance;     //平均亮度

    float exposure;

    #if DOF > 0
        Dof dof_cfg;
    #endif
};

float ld(float depth) {
    return (near * far) / (depth * (near - far) + far);
}

float ild(float ldepth) {
	return ((near * far) / ldepth - far) / (near - far);
}

void ApplyAperturePriority(float targetEV, inout Camera c) {
    // Start with the assumption that we want a shutter speed of 1/f
    c.shutterSpeed = 1.0 / (c.focalLength * 1000.0);

    // Compute the resulting ISO if we left the shutter speed here
    c.iso = clamp(ComputeISO(c.aperture, c.shutterSpeed, targetEV), MIN_ISO, MAX_ISO);

    // Figure out how far we were from the target exposure value
    float evDiff = targetEV - ComputeEV(c.aperture, c.shutterSpeed, c.iso);

    // Compute the final shutter speed
    c.shutterSpeed = clamp(c.shutterSpeed * pow(2.0f, -evDiff), MIN_SHUTTER, MAX_SHUTTER);
}

void ApplyShutterPriority(float targetEV, inout Camera c) {
    // Start with the assumption that we want an aperture of 4.0
    c.aperture = 4.0;

    // Compute the resulting ISO if we left the aperture here
    c.iso = clamp(ComputeISO(c.aperture, c.shutterSpeed, targetEV), MIN_ISO, MAX_ISO);

    // Figure out how far we were from the target exposure value
    float evDiff = targetEV - ComputeEV(c.aperture, c.shutterSpeed, c.iso);

    // Compute the final aperture
    c.aperture = clamp(c.aperture * pow(sqrt(2.0), evDiff), MIN_APERTURE, float(MAX_APERTURE));
}

void ApplyProgramAuto(float targetEV, inout Camera c) {
    // Start with the assumption that we want an aperture of 4.0
    c.aperture = 4.0f;

    // Start with the assumption that we want a shutter speed of 1/f
    c.shutterSpeed = 1.0 / (c.focalLength * 1000.0);

    // Compute the resulting ISO if we left both shutter and aperture here
    c.iso = clamp(ComputeISO(c.aperture, c.shutterSpeed, targetEV), MIN_ISO, MAX_ISO);

    // Apply half the difference in EV to the aperture
    float evDiff = targetEV - ComputeEV(c.aperture, c.shutterSpeed, c.iso);
    c.aperture = clamp(c.aperture * pow(sqrt(2.0), evDiff * 0.5), MIN_APERTURE, MIN_APERTURE);

    // Apply the remaining difference to the shutter speed
    evDiff = targetEV - ComputeEV(c.aperture, c.shutterSpeed, c.iso);
    c.shutterSpeed = clamp(c.shutterSpeed * exp2(-evDiff), MIN_SHUTTER, MAX_SHUTTER);
}

void ComputeEV(inout Camera c) {
    const float aperture  = CAMERA_APERTURE;
    const float aperture2 = aperture * aperture;
    const float shutterSpeed = 1.0 / CAMERA_SHUTTER_SPEED;
    const float ISO = CAMERA_ISO;
    const float EC = CAMERA_EV;

    #if AUTO_CAMERA == 0
        c.aperture = aperture;
        c.shutterSpeed = shutterSpeed;
        c.iso = ISO;
        c.ev100 = ComputeEV100(aperture2, shutterSpeed, ISO);
    #else
        c.ev100 = ComputeTargetEV(c.avgLuminance);
        #if AUTO_CAMERA == 1
            ApplyProgramAuto(c.ev100, c);
        #elif AUTO_CAMERA == 2
            ApplyAperturePriority(c.ev100, c);
        #elif AUTO_CAMERA == 3
            ApplyShutterPriority(c.ev100, c);
        #endif
        //ApplyProgramAuto(CAMERA_FOCAL_LENGTH, EV100, aperture, shutterSpeed, ISO); //TODO: Temporal Feedback Camera Settings for DoF, motion blur, and film grain.
    #endif

    c.exposure = ConvertEV100ToExposure(c.ev100 - EC);
}

Camera init_camera() {
    Camera c;
    c.avgLuminance = texture2D(gaux3, vec2(0.5)).a + 0.0001;
    c.focalLength = SENSOR_SIZE * NfocalLength;

    ComputeEV(c);

    #if DOF > 0
    #ifndef LINK_FOCUS_TO_BRIGHTNESS_BAR
        #if FOCAL_POINT == 0
        c.dof_cfg.focalDepth = centerDepthSmooth;
        #else
        c.dof_cfg.focalDepth = ild(FOCAL_POINT);
        #endif
    #else
        c.dof_cfg.focalDepth = screenBrightness;
    #endif
    c.dof_cfg.focalDepth = min(c.dof_cfg.focalDepth, 0.9999);

    #if DOF == 1
        c.dof_cfg.FringeOffset = 0.1 * mix(c.focalLength, 1.0, 0.3);
        
        c.dof_cfg.BlurAmount = 2.5 + c.focalLength * 0.4;

        c.dof_cfg.MaxDistanceBlurAmount = 0.7 * mix(c.focalLength, 1.0, 0.8);
        c.dof_cfg.DistanceBlurRange = 360;

        c.dof_cfg.EdgeBlurAmount = 1.75;
        c.dof_cfg.EdgeBlurDecline = 3.0;
    #elif DOF == 2
        c.dof_cfg.FringeOffset = FRINGE_OFFSET;

        c.dof_cfg.BlurAmount = BLUR_AMOUNT;

        c.dof_cfg.MaxDistanceBlurAmount = MAX_DISTANCE_BLUR_AMOUNT;
        c.dof_cfg.DistanceBlurRange = DISTANCE_BLUR_RANGE;

        c.dof_cfg.EdgeBlurAmount = EDGE_BLUR_AMOUNT;
        c.dof_cfg.EdgeBlurDecline = EDGE_BLUR_DECLINE;
    #endif
    #endif
    return c;
}

#if DOF > 0
void  DOF_Blur(inout vec3 color, in Camera c, in float isHand) {

	float depth= texture2D(gdepthtex, texcoord.st).x;

	float naive = 0.0;

	#ifdef LOW_QUALITY_CALCULATECLOUDS
	    float aaa=0;
	#ifdef NOCALCULATECLOUDSNIGHT
	    float bbb=1.5 - 0.6 * timeMidnight;
	#else
	    float bbb=1.5;
	#endif
        if(weather(texcoord.st)==3){
            aaa += timeMidnight;
            bbb = 0.0;
        }
	#else
        float aaa = 1.0;
        float bbb = 0.0;
	#endif
	
    Dof dc = c.dof_cfg;

	#ifdef FOCUS_BLUR
		naive += pow(abs(depth - dc.focalDepth), 0.4 / c.focalLength + 0.6) * 0.01 * dc.BlurAmount * (1.0 - isHand * 0.95);
	#endif

	#ifdef DISTANCE_BLUR
        #ifdef NOCALCULATECLOUDSNIGHT
            naive += clamp(1-(exp(-pow(ld(depth)/dc.DistanceBlurRange*far,4.0-rainStrength)*3)),0.0,0.001 * (dc.MaxDistanceBlurAmount*aaa+bbb - 0.5 * timeMidnight) * min(1.0, naive + 0.3));
        #else
            naive += clamp(1-(exp(-pow(ld(depth)/dc.DistanceBlurRange*far,4.0-rainStrength)*3)),0.0,0.001 * (dc.MaxDistanceBlurAmount*aaa+bbb) * min(1.0, naive + 0.3));
        #endif
	#endif

	#ifdef EDGE_BLUR
	naive += pow(distance(texcoord.st, vec2(0.5)),dc.EdgeBlurDecline) * 0.01 * dc.EdgeBlurAmount;
	#endif

    vec2 aspectcorrect = vec2(1.0, aspectRatio) * 1.6;
			
	for ( int i = 0; i < 60; ++i) {
		color.g += GetColorTexture(texcoord.st + offsets[i]*aspectcorrect*naive).g;
	    color.r += GetColorTexture(texcoord.st + (offsets[i]*aspectcorrect + vec2(dc.FringeOffset))*naive).r;
		color.b += GetColorTexture(texcoord.st + (offsets[i]*aspectcorrect - vec2(dc.FringeOffset))*naive).b;
	}
	color /= 60.0;
}
#endif

void MotionBlur(inout vec3 color, float isHand) {
	float depth = GetDepth(texcoord.st);
	vec4 currentPosition = vec4(texcoord.x * 2.0f - 1.0f, texcoord.y * 2.0f - 1.0f, 2.0f * depth - 1.0f, 1.0f);

	vec4 fragposition = gbufferProjectionInverse * currentPosition;
	fragposition = gbufferModelViewInverse * fragposition;
	fragposition /= fragposition.w;
	//fragposition.xyz += cameraPosition;

	vec4 previousPosition = fragposition;
	//previousPosition.xyz -= previousCameraPosition;
	previousPosition = gbufferPreviousModelView * previousPosition;
	previousPosition = gbufferPreviousProjection * previousPosition;
	previousPosition /= previousPosition.w;

	vec2 velocity = (currentPosition - previousPosition).st * 0.12f;
	float maxVelocity = 0.05f;
		 velocity = clamp(velocity, vec2(-maxVelocity), vec2(maxVelocity));

	velocity *= 1.0f - float(isHand);

	int samples = 0;

	float dither = R2_dither();

	color.rgb = vec3(0.0f);

	for (int i = 0; i < 2; ++i) {
		vec2 coord = texcoord.st + velocity * (i - 0.5);
			 coord += vec2(dither) * 0.08f * velocity;

		if (coord.x > 0.0f && coord.x < 1.0f && coord.y > 0.0f || coord.y < 1.0f) {

			color += GetColorTexture(coord).rgb;
			samples += 1;

		}
	}

	color.rgb /= samples;
}
#endif