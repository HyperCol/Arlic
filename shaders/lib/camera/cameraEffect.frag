#if !defined _INCLUDE_CAMERA_
#define _INCLUDE_CAMERA_

#define AUTO_CAMERA

#define TARGET_EV 
#define FOCAL_LENGTH 0 //[0 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 65 70 75 80 85 90 95 100 110 120 130 140 150 160 170 180 190 200 220 240 260 280 300 320 340 360 380 400 420 440 460 480 500]
#define 

#include "camera.glsl"

struct Camera {
    float aperture;         //光圈
    float focalLength;      //焦距
    float shutterSpeed;     //快门速度

    float ev100;            //曝光值
    float iso;              //感光度
    float avgLuminance;     //平均亮度
};

Camera init_camera() {
    Camera camera;

}

#endif