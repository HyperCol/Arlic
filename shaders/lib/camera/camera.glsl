/********************************************************
    © 2020 Continuum Graphics LLC. All Rights Reserved
 ********************************************************/

#if !defined _CAMERA_
#define _CAMERA_

#define CAMERA_EV 1.0
#define CAMERA_ISO 800
#define CAMERA_SHUTTER_SPEED (1.0/60.0)
#define CAMERA_APERTURE 1.0
 
#define MIN_SHUTTER 1/4000
#define MAX_SHUTTER 1/30
#define MIN_ISO 100
#define MAX_ISO 6400
#define MIN_APERTURE 1.8
#define MAX_APERTURE 22

float ComputeEV100(const float aperture2, const float shutterTime, const float ISO) {
    return log2(aperture2 / shutterTime * 100.0 / ISO);
}

float ConvertEV100ToExposure(float EV100) {
    return 1.0 / (1.2 * exp2(EV100)); //1.0 / (1.2 * exp2(EV100));
}

// Given an aperture, shutter speed, and exposure value compute the required ISO value
float ComputeISO(float aperture, float shutterSpeed, float ev) {
    return (pow2(aperture) * 100.0) / (shutterSpeed * exp2(ev));
}

// Given the camera settings compute the current exposure value
float ComputeEV(float aperture, float shutterSpeed, float iso) {
    return log2((pow2(aperture) * 100.0) / (shutterSpeed * iso));
}

// Using the light metering equation compute the target exposure value
float ComputeTargetEV(float averageLuminance) {
    // K is a light meter calibration constant
    const float K = 12.5;

    return log2(averageLuminance * 100.0 / K);
}

void ApplyAperturePriority(float focalLength,
                          float targetEV,
                          inout float aperture,
                          inout float shutterSpeed,
                          inout float iso) {
    // Start with the assumption that we want a shutter speed of 1/f
    shutterSpeed = 1.0 / (focalLength * 1000.0);

    // Compute the resulting ISO if we left the shutter speed here
    iso = clamp(ComputeISO(aperture, shutterSpeed, targetEV), MIN_ISO, MAX_ISO);

    // Figure out how far we were from the target exposure value
    float evDiff = targetEV - ComputeEV(aperture, shutterSpeed, iso);

    // Compute the final shutter speed
    shutterSpeed = clamp(shutterSpeed * pow(2.0f, -evDiff), MIN_SHUTTER, MAX_SHUTTER);
}

void ApplyShutterPriority(float focalLength,
                          float targetEV,
                          inout float aperture,
                          inout float shutterSpeed,
                          inout float iso) {
    // Start with the assumption that we want an aperture of 4.0
    aperture = 4.0;

    // Compute the resulting ISO if we left the aperture here
    iso = clamp(ComputeISO(aperture, shutterSpeed, targetEV), MIN_ISO, MAX_ISO);

    // Figure out how far we were from the target exposure value
    float evDiff = targetEV - ComputeEV(aperture, shutterSpeed, iso);

    // Compute the final aperture
    aperture = clamp(aperture * pow(sqrt(2.0), evDiff), MIN_APERTURE, float(MAX_APERTURE));
}

void ApplyProgramAuto(float focalLength,
                      float targetEV,
                      inout float aperture,
                      inout float shutterSpeed,
                      inout float iso) {
    // Start with the assumption that we want an aperture of 4.0
    aperture = 4.0f;

    // Start with the assumption that we want a shutter speed of 1/f
    shutterSpeed = 1.0 / (focalLength * 1000.0);

    // Compute the resulting ISO if we left both shutter and aperture here
    iso = clamp(ComputeISO(aperture, shutterSpeed, targetEV), MIN_ISO, MAX_ISO);

    // Apply half the difference in EV to the aperture
    float evDiff = targetEV - ComputeEV(aperture, shutterSpeed, iso);
    aperture = clamp(aperture * pow(sqrt(2.0), evDiff * 0.5), MIN_APERTURE, MIN_APERTURE);

    // Apply the remaining difference to the shutter speed
    evDiff = targetEV - ComputeEV(aperture, shutterSpeed, iso);
    shutterSpeed = clamp(shutterSpeed * exp2(-evDiff), MIN_SHUTTER, MAX_SHUTTER);
}

float ComputeEV(float avgLuminance) {
    const float aperture  = CAMERA_APERTURE;
    const float aperture2 = aperture * aperture;
    const float shutterSpeed = 1.0 / CAMERA_SHUTTER_SPEED;
    const float ISO = CAMERA_ISO;
    const float EC = CAMERA_EV;

    //#ifndef AUTO_CAMERA
    //   float EV100 = ComputeEV100(aperture2, shutterSpeed, ISO);
    //#else
        //ApplyProgramAuto(CAMERA_FOCAL_LENGTH, EV100, aperture, shutterSpeed, ISO); //TODO: Temporal Feedback Camera Settings for DoF, motion blur, and film grain.
    //#endif

    float EV100 = ComputeTargetEV(avgLuminance);

    return ConvertEV100ToExposure(EV100 - EC);
}

#endif
