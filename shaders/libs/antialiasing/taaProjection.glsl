<<<<<<< HEAD
#define Enabled_Temporal_Antialiasing

#if !defined _TAAPROJECTION_
#define _TAAPROJECTION_

uniform vec2 jitter;

void TAAProjection(inout vec4 c) {
    #ifdef Enbaled_Temporal_Antialiasing
    c.xy += jitter * c.w * 2.0;
    #endif
}

=======
#if !defined _TAAPROJECTION_
#define _TAAPROJECTION_

#define Enabled_TemportalAntiAliasing
uniform vec2 jitter;
>>>>>>> e791f6bfc7e8b945603c3d9b59878a446e19d942
#endif