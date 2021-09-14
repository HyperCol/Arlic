#define Enabled_Temporal_Antialiasing

#if !defined _TAAPROJECTION_
#define _TAAPROJECTION_

uniform vec2 jitter;

void TAAProjection(inout vec4 c) {
    #ifdef Enabled_Temporal_Antialiasing
    c.xy -= jitter * c.w * 2.0;
    #endif
}

#endif