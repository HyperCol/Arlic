#if !defined _INCLUDE_CAMERA_
#define _INCLUDE_CAMERA_

#define AUTO_CAMERA
//0: Off | 1: All | 2: Aperture only | 3: Shutter only
    #define SENSOR_SIZE 11              //[4 6 8 9 11 16 17]
    #define FOCAL_POINT 0               //[0 1 2 4 8 16 24 32 40 48 56 64 72 80 88 96 104 112 120 128 136 144 152 160 168 176 184 192 200 208 216 224 232 240 248 256]
    #define CAMERA_APERTURE 2.8         //[1.4 2.0 2.8 4.0 5.6 8.0 11.0 16.0 22.0 32.0]
    #define CAMERA_SHUTTER_SPEED 1600   //[1 2 4 8 10 20 30 50 75 100 150 200 300 400 500 600 700 800 900 1000 1100 1200 1300 1400 1500 1600 1700 1800 1900 2000]
    #define CAMERA_ISO 400              //[50 75 100 200 400 800 1600 3200]
    #define CAMERA_EV 0.0               //[-4.0 -3.9 -3.8 -3.7 -3.6 -3.5 -3.4 -3.3 -3.2 -3.1 -3.0 -2.9 -2.8 -2.7 -2.6 -2.5 -2.4 -2.3 -2.2 -2.1 -2.0 -1.9 -1.8 -1.7 -1.6 -1.5 -1.4 -1.3 -1.2 -1.1 -1.0 -0.9 -0.8 -0.7 -0.6 -0.5 -0.4 -0.3 -0.2 -0.1 0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3.0 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4.0]

//#define MOTION_BLUR // It's motion blur.

#define DOF 1 //[0 1 2]
//0: Off | 1: Auto | 2: Manual
    #define DOF_SAMPLES 10
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

#define pow2(x) (x * x)

#include "camera.glsl"

uniform float NfocalLength;

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

    /*
    float aperture;         //光圈
    float iso;              //感光度
    float shutterSpeed;     //快门速度
    */

    float ev100;            //曝光值
    float avgLuminance;     //平均亮度

    float exposure;

    #if DOF > 0
        Dof dof_cfg;
    #endif
} cam;

float ld(float depth) {
    return (near * far) / (depth * (near - far) + far);
}

float ild(float ldepth) {
	return ((near * far) / ldepth - far) / (near - far);
}

void ComputeEV(inout Camera c) {
    const float aperture  = CAMERA_APERTURE;
    const float aperture2 = aperture * aperture;
    const float shutterSpeed = 1.0 / CAMERA_SHUTTER_SPEED;
    const float ISO = CAMERA_ISO;
    const float EC = CAMERA_EV;

    #ifndef AUTO_CAMERA
        /*c.aperture = aperture;
        c.shutterSpeed = shutterSpeed;
        c.iso = ISO;*/
        c.ev100 = ComputeEV100(aperture2, shutterSpeed, ISO);
    #else
        c.ev100 = ComputeTargetEV(c.avgLuminance * 480.0);
        /*#if AUTO_CAMERA == 1
            ApplyProgramAuto(c.ev100, c);
        #elif AUTO_CAMERA == 2
            ApplyAperturePriority(c.ev100, c);
        #elif AUTO_CAMERA == 3
            ApplyShutterPriority(c.ev100, c);
        #endif*/
        //ApplyProgramAuto(CAMERA_FOCAL_LENGTH, EV100, aperture, shutterSpeed, ISO); //TODO: Temporal Feedback Camera Settings for DoF, motion blur, and film grain.
    #endif

    c.exposure = ConvertEV100ToExposure(c.ev100 - EC);
}

void init_camera() {
    //cam.avgLuminance = texture(colortex7, vec2(0.5)).a + 0.0001;
    cam.focalLength = SENSOR_SIZE * NfocalLength;

    ComputeEV(cam);

    #if DOF > 0
    #ifndef LINK_FOCUS_TO_BRIGHTNESS_BAR
        #if FOCAL_POINT == 0
        cam.dof_cfg.focalDepth = ld(centerDepthSmooth);
        #else
        cam.dof_cfg.focalDepth = float(FOCAL_POINT);
        #endif
    #else
        cam.dof_cfg.focalDepth = screenBrightness;
    #endif
    cam.dof_cfg.focalDepth = min(cam.dof_cfg.focalDepth, 0.9999);

    #if DOF == 1
        cam.dof_cfg.FringeOffset = 0.1 * mix(cam.focalLength, 1.0, 0.3);
        
        cam.dof_cfg.BlurAmount = 2.5 + cam.focalLength * 0.4;

        cam.dof_cfg.MaxDistanceBlurAmount = 0.7 * mix(cam.focalLength, 1.0, 0.8);
        cam.dof_cfg.DistanceBlurRange = 360;

        cam.dof_cfg.EdgeBlurAmount = 2.6 / (cam.focalLength * 0.3 + 0.9);
        cam.dof_cfg.EdgeBlurDecline = 7.1 / (cam.focalLength * 0.2 + 1.5);
    #elif DOF == 2
        cam.dof_cfg.FringeOffset = FRINGE_OFFSET;

        cam.dof_cfg.BlurAmount = BLUR_AMOUNT;

        cam.dof_cfg.MaxDistanceBlurAmount = MAX_DISTANCE_BLUR_AMOUNT;
        cam.dof_cfg.DistanceBlurRange = DISTANCE_BLUR_RANGE;

        cam.dof_cfg.EdgeBlurAmount = EDGE_BLUR_AMOUNT;
        cam.dof_cfg.EdgeBlurDecline = EDGE_BLUR_DECLINE;
    #endif
    #endif
}

#if DOF > 0
uniform vec2 viewDimensions;

vec2 CalculateDistOffset(const vec2 prep, const float angle, const vec2 offset) {
    return offset * angle + prep * dot(prep, offset) * (1.0 - angle);
}

vec3 DepthOfField(bool isHand) { //OPTIMISATION: Add circular option for lower end hardware. TODO: Look over for accuracy and speed.
    #ifndef DOF
        return GetColorTexture(texcoord.st);
    #endif

    if (isHand) return GetColorTexture(texcoord.st);

    vec3 dof = vec3(0.0);
    vec3 weight = vec3(0.0);

    float r = 1.0;
    const float PI = radians(180.0);
    const float TAU = radians(360.0);
    const float HPI = PI * 0.5;
    const float PHI = sqrt(5.0) * 0.5 + 0.5;

    const float goldenAngle = TAU / PHI / PHI;
    const mat2 rot = mat2(
        cos(goldenAngle), -sin(goldenAngle),
        sin(goldenAngle),  cos(goldenAngle)
    );

    // Lens specifications referenced from Sigma 32mm F1.4 art.
    // Focal length of 32mm (assuming lens does not zoom), with a diaphram size of 25mm at F1.4.
    // For more accuracy to lens settings, set blades to 9.
    float aperture  = (cam.focalLength / CAMERA_APERTURE);

    float depth = ld(texture(depthtex0, texcoord.st).x);
    float pcoc = cam.dof_cfg.focalDepth;

    //vec2 maxPos = CalculateDistOffset(prep, angle, (r - 1.0) * sampleAngle * pcoc) * distOffsetScale;

    //float depth = ScreenToViewSpaceDepth(texture(depthtex0, texcoord + maxPos).x);
    //float pcoc = CalculateFocus(depth);

    vec2 sampleAngle = vec2(0.0, 1.0);

    const float sizeCorrect   = 1.0 / (sqrt(DOF_SAMPLES) * 1.35914091423);
    const float apertureScale = sizeCorrect * aperture;

    float lod = log2(abs(pcoc) * max(viewDimensions.x, viewDimensions.y) * apertureScale * aspectRatio);

    vec2 distOffsetScale = apertureScale * vec2(1.0, aspectRatio);

    vec2 toCenter = texcoord.xy - 0.5;
    vec2 prep = normalize(vec2(toCenter.y, -toCenter.x));
    float lToCenter = length(toCenter);
    float angle = cos(lToCenter * cam.dof_cfg.FringeOffset);

    for(int i = 0; i < DOF_SAMPLES; ++i) {
        r += 1.0 / r;
        sampleAngle = rot * sampleAngle;

        vec2 rSample = (r - 1.0) * sampleAngle;

        vec2 pos = CalculateDistOffset(prep, 1.0, rSample) * sizeCorrect;
        vec3 bokeh = texture2D(colortex2, pos * -0.25 + vec2(0.5, 0.5) ).rgb;

        vec2 maxPos = CalculateDistOffset(prep, angle, rSample * pcoc) * distOffsetScale;

        dof += GetColorTexture(texcoord.st + maxPos) * bokeh;
        weight += bokeh;
    }

    return dof / weight;
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