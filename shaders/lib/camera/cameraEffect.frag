#if !defined _INCLUDE_CAMERA_
#define _INCLUDE_CAMERA_

#define AUTO_CAMERA
    #define FOCAL_POINT 0              //[0 1 2 4 8 16 24 32 40 48 56 64 72 80 88 96 104 112 120 128 136 144 152 160 168 176 184 192 200 208 216 224 232 240 248 256]
    #define CAMERA_APERTURE 2.8         //[1.4 2.0 2.8 4.0 5.6 8.0 11.0 16.0 22.0 32.0]
    #define CAMERA_SHUTTER_SPEED 1600   //[1 2 4 8 10 20 30 50 75 100 150 200 300 400 500 600 700 800 900 1000 1100 1200 1300 1400 1500 1600 1700 1800 1900 2000]
    #define CAMERA_ISO 400              //[50 75 100 200 400 800 1600 3200]
    #define CAMERA_EV 0.0               //[-4.0 -3.9 -3.8 -3.7 -3.6 -3.5 -3.4 -3.3 -3.2 -3.1 -3.0 -2.9 -2.8 -2.7 -2.6 -2.5 -2.4 -2.3 -2.2 -2.1 -2.0 -1.9 -1.8 -1.7 -1.6 -1.5 -1.4 -1.3 -1.2 -1.1 -1.0 -0.9 -0.8 -0.7 -0.6 -0.5 -0.4 -0.3 -0.2 -0.1 0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3.0 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4.0]

#define DOF 1 //[0 1 2]
//0: Off, 1: Auto, 2: 
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

struct Dof {
    float FringeOffset;

    float BlurAmount;

    float MaxDistanceBlurAmount;
    float DistanceBlurRange;

    float EdgeBlurAmount;
    float EdgeBlurDecline;
};

struct Camera {
    float aperture;         //光圈
    float focalLength;      //焦距
    float shutterSpeed;     //快门速度

    float ev100;            //曝光值
    float iso;              //感光度
    float avgLuminance;     //平均亮度

    Dof dof_setting;
};

Camera init_camera() {
    Camera camera;

}

#endif