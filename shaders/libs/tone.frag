#if !(defined _INCLUDE_TONE)
#define _INCLUDE_TONE

struct Tone {
	float exposure;
	float brightness;
	float contrast;
	float saturation;
	float vibrance;
	
	vec3 s;
	vec3 m;
	vec3 h;
	bool p;
	
	vec3 color;
	vec3 blur;
	vec3 hsl;
	
	float useAdjustment;
	float blurIndex;
	float useToneMap;
};

#define VIGNETTE
#ifdef VIGNETTE
uniform vec3 vignetteColor;

vec3 vignette(vec3 color) {
    float dist = distance(texcoord, vec2(0.5f));
    dist = dist * 1.7 - 0.65;
    dist = smoothstep(0.0, 1.0, dist);
    return mix(color, vignetteColor, dist);//vec3(hurt);//
}
#endif

uniform float nightVision;
uniform float blindness;
uniform float valLive;

#define SHADER_NIGHT_VISION 0.0 //[-0.5 -0.4 -0.3 -0.2 -0.1 0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

float getLightness(vec3 rgbColor) {
    float r = rgbColor.r, g = rgbColor.g, b = rgbColor.b;
    float minval = min(r, min(g, b));
    float maxval = max(r, max(g, b));
    return ( maxval + minval ) / 2.0;
}

vec3 colorBalance(vec3 rgbColor, float l, vec3 s, vec3 m, vec3 h, bool p) {
    float r = rgbColor.r, g = rgbColor.g, b = rgbColor.b;
    
    s *= clamp((l - 0.333) / -0.25 + 0.5, 0.0, 1.0) * 0.7;
    m *= clamp((l - 0.333) /  0.25 + 0.5, 0.0, 1.0) *
         clamp((l + 0.333 - 1.0) / -0.25 + 0.5, 0.0, 1.0) * 0.7;
    h *= clamp((l + 0.333 - 1.0) /  0.25 + 0.5, 0.0, 1.0) * 0.7;
    
    vec3 newColor = rgbColor;
    newColor += s;
    newColor += m;
    newColor += h;
    newColor = clamp(newColor, vec3(0.0), vec3(1.0));
    
    if(p) {
        float nl = getLightness(newColor);
        newColor *= l / nl;
    }
    return newColor;
}

vec3 colorBalance(vec3 rgbColor, vec3 s, vec3 m, vec3 h, bool p) {
	return colorBalance(rgbColor, getLightness(rgbColor), s, m, h, p);
}

vec3 tonemap(in vec3 color, float adapted_lum) {
	color *= adapted_lum;

	const float a = 2.51f;
	const float b = 0.03f;
	const float c = 2.43f;
	const float d = 0.59f;
	const float e = 0.14f;
	const vec3 f = vec3(13.134f);
	
	//return (color*(a*color+b))/(color*(c*color+d)+e);
	
	color = pow(color, vec3(1.4));
	color *= (4.0 - rain0 * 3.0);
	//color = clamp(color, vec3(0.0), vec3(1.0));
	//color = pow(color, vec3(1.07, 1.04, 1.0));
	
	vec3 curr = (color*(a*color+b))/(color*(c*color+d)+e);
	vec3 whiteScale = 1.0f / ((f*(a*f+b))/(f*(c*f+d)+e));
	return curr*whiteScale;
}

#define HUE_ADJUSTMENT

#define TONE 0 //[0 1 2 3 4 5 6 7]

#define BRIGHTNESS 	1.0 	//[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5]
#define CONTRAST 	1.0   	//[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5]
#define SATURATION 	1.0 	//[0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.2 1.5 2.0 2.5 3.0]
#define VIBRANCE 	1.0 	//[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.2 1.5 2.0 2.5 3.0]
#define HUE 		0.0		//[-0.5 -0.45 -0.4 -0.35 -0.3 -0.25 -0.2 -0.15 -0.13 -0.1 -0.09 -0.08 -0.07 -0.06 -0.05 -0.04 -0.03 -0.02 -0.01 0.0 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.13 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5]

#define COLOR_BALANCE_S_R 0.0 //[-1.0 -0.9 -0.8 -0.7 -0.6 -0.5 -0.4 -0.3 -0.2 -0.1 0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define COLOR_BALANCE_S_G 0.0 //[-1.0 -0.9 -0.8 -0.7 -0.6 -0.5 -0.4 -0.3 -0.2 -0.1 0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define COLOR_BALANCE_S_B 0.0 //[-1.0 -0.9 -0.8 -0.7 -0.6 -0.5 -0.4 -0.3 -0.2 -0.1 0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define COLOR_BALANCE_M_R 0.0 //[-1.0 -0.9 -0.8 -0.7 -0.6 -0.5 -0.4 -0.3 -0.2 -0.1 0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define COLOR_BALANCE_M_G 0.0 //[-1.0 -0.9 -0.8 -0.7 -0.6 -0.5 -0.4 -0.3 -0.2 -0.1 0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define COLOR_BALANCE_M_B 0.0 //[-1.0 -0.9 -0.8 -0.7 -0.6 -0.5 -0.4 -0.3 -0.2 -0.1 0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define COLOR_BALANCE_H_R 0.0 //[-1.0 -0.9 -0.8 -0.7 -0.6 -0.5 -0.4 -0.3 -0.2 -0.1 0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define COLOR_BALANCE_H_G 0.0 //[-1.0 -0.9 -0.8 -0.7 -0.6 -0.5 -0.4 -0.3 -0.2 -0.1 0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
#define COLOR_BALANCE_H_B 0.0 //[-1.0 -0.9 -0.8 -0.7 -0.6 -0.5 -0.4 -0.3 -0.2 -0.1 0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
//#define KEEP_BROGHTNESS

void init_tone(out Tone t, vec2 texcoord) {
	t.exposure = get_exposure();
	
	t.color = texture(composite, texcoord).rgb;
	//t.blur = texture(gaux4, texcoord).rgb;// * (1.0 + t.exposure);
	
	t.useAdjustment = 1.0;
	t.blurIndex = 0.0;
	//t.useToneMap = 1.0;
	
	#if TONE == 1
	t.brightness = 1.05;
	t.contrast = 0.8;
	t.saturation = 1.5;
	t.vibrance = 1.2;
	
	t.s = vec3(0.15, 0.1, 0.2);
	t.m = vec3(0.1, 0.0, 0.0);
	t.h = vec3(0.2, 0.1, 0.0);
	t.p = true;
	#elif TONE == 2
	t.brightness = 1.0;
	t.contrast = 0.9;
	t.saturation = 1.0;
	t.vibrance = 0.8;
	
	t.s = vec3(0.1, 0.0, 0.0);
	t.m = vec3(0.0);
	t.h = vec3(0.0, -0.1, -0.1);
	t.p = true;
	#elif TONE == 3
	t.brightness = 0.95;
	t.contrast = 1.0;
	t.saturation = 1.0;
	t.vibrance = 1.1;
	
	t.s = vec3(0.4, 0.2, 0.9);
	t.m = vec3(0.4, 0.4, 0.8);
	t.h = vec3(-0.1, 0.1, 0.6);
	t.p = true;
	#elif TONE == 4
	t.brightness = 1.0;
	t.contrast = 0.9;
	t.saturation = 1.1;
	t.vibrance = 1.0;
	
	t.s = vec3(-0.1, 0.0, 0.1);
	t.m = vec3(0.0, 0.05, 0.1);
	t.h = vec3(-0.1, 0.1, 0.3);
	t.p = true;
	#elif TONE == 5
	t.brightness = 0.9;
	t.contrast = 0.8;
	t.saturation = 0.4;
	t.vibrance = 0.8;
	
	t.s = vec3(0.0);
	t.m = vec3(0.0);
	t.h = vec3(-0.08);
	t.p = false;
	#elif TONE == 6
	t.brightness = 1.0;
	t.contrast = 1.2;
	t.saturation = 2.0;
	t.vibrance = 2.0;
	
	t.s = vec3(0.0);
	t.m = vec3(0.0);
	t.h = vec3(0.0);
	t.p = false;
	#elif TONE == 7
	t.brightness = BRIGHTNESS;
	t.contrast = CONTRAST;
	t.saturation = SATURATION;
	t.vibrance = 1.0 / VIBRANCE;
	
	t.s = vec3(COLOR_BALANCE_S_R, COLOR_BALANCE_S_G, COLOR_BALANCE_S_B);
	t.m = vec3(COLOR_BALANCE_M_R, COLOR_BALANCE_M_G, COLOR_BALANCE_M_B);
	t.h = vec3(COLOR_BALANCE_H_R, COLOR_BALANCE_H_G, COLOR_BALANCE_H_B);
	#ifdef KEEP_BROGHTNESS
	t.p = true;
	#else
	t.p = false;
	#endif
	#else
	t.brightness = 1.0;
	t.contrast = 1.0;
	t.saturation = 1.0;
	t.vibrance = 1.1;
	
	t.s = vec3(0.0);
	t.m = vec3(0.0);
	t.h = vec3(0.0);
	t.p = false;
	#endif
}

void Hue_Adjustment(inout Tone t) {
	//blur & dof
	//t.blurIndex = clamp(t.blurIndex, 0.0, 1.0);
	t.color = mix(t.color, t.blur, t.blurIndex);
	
	// This will turn it into gamma space
	#ifdef BLACK_AND_WHITE
	t.saturation = 0.0;
	#elif MC_VERSION >= 11202
	t.saturation *= valLive;
	#endif

	//tonemap
	vec3 color = t.color;
	if (t.useToneMap > 0) t.color = mix(t.color, tonemap(color, t.exposure), t.useToneMap);
	
	//hue
	#ifdef HUE_ADJUSTMENT
	if (t.useAdjustment > 0) {
		#ifdef TONE_DEBUG
		if (tex.x < 0.5) {
		#endif
			t.color *= t.brightness;
			t.color = mix(vec3(0.5), t.color, t.contrast);
			
			float lum = dot(t.color, vec3(0.2125, 0.7154, 0.0721));
			t.color = mix(vec3(lum), t.color, t.saturation);
			
			float mn = min(t.color.r, min(t.color.g, t.color.b));
			float mx = max(t.color.r, max(t.color.g, t.color.b));
			float sat = (1.0 - (mx - mn)) * (1.0 - mx) * lum * 5.0;
			vec3 l = vec3((mn + mx) * 0.5);
			
			t.color = mix(t.color, mix(l, t.color, t.vibrance), sat);
			
			t.color = colorBalance(t.color, t.s, t.m, t.h, t.p);
		#ifdef TONE_DEBUG
		}
		#endif
	}
	#endif
	
	#ifdef VIGNETTE
	t.color = vignette(t.color);
	#endif
	
	// Apply night vision gamma and blindness
	t.color = pow(t.color, vec3(1.0 - plus(nightVision, SHADER_NIGHT_VISION) * 0.6 + blindness));	
	
	t.color = mix(color, t.color, t.useAdjustment);
	//t.color = vignetteColor;
	t.color = toGamma(t.color);
}
#endif 