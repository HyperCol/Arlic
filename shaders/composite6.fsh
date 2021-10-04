#version 460 compatibility

/*
                                                                
                       H                                         
                       HCHCHC                  H                
                       HCHCHCHCHC            HCH                
                       HCHCHCHCHCHCHCH    HCHCHCH               
                      HCHCHCHCHCHCHCHCHCHCHCHCHCHC              
           HCHCHCHCHCHCHCHCHCHCHCHCH HCHCHCHCHCHCHC             
     HCHCHCHCHCHCHCHCHCHCHCHCHCHC  HCHCHCHCHCHCHCHC             
        HCHCHCHCHCHCHC HCHCH         HCHCHCHCHCHCHCH            
          HCHCHCHCHCHC H                     HCHCHCH            
          HCHCHCHCHCH                      HCHCHCHCHCHCHCHCHCH  
         HCHCH HCHCH                        HCHCHCHCHCHCHCHC    
       HCHCHCHCH  HC                          HCHCHCHCHCHCH     
      HCHCHCHCHCH                              HCHCHCHCHCH      
     HCHCHCHCHCHCHC                         HCHC HCHCHCH        
   HCHCHCHCHCHCHCHCH                        HCHCHCHCHCH         
  HCHCHCHCHCHCHCHCHCHC                     HCHCHCHCHC           
            HCHCHCHCH                  HC HCHCHCHCHCHCH         
             HCHCHCHCHCHCHCHCHC   HCHCHCH HCHCHCHCHCHCHCHC      
             HCHCHCHCHCHCHCHC  HCHCHCHCHCHCHCHCHCHCHCHCHCHC     
              HCHCHCHCHCHCHCHCHCHCHCHCHCHCHCHCHC                
              HCHCHCHCHCHCHCHCHCHCHCHCHCH                       
               HCHCHC        HCHCHCHCHCHC                       
                HCH             HCHCHCHCH                       
                                      HCH                       
										H


2021@HyperCol Studios
VacGrd is part of HyperCol Studios
Do not modify this code until you have read the LICENSE contained in the root directory of this shaderpack!

*/

/* DRAWBUFFERS:2 */

#define LF

const bool colortex5MipmapEnabled = true;

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D gdepthtex;
uniform sampler2D colortex2;
uniform sampler2D colortex3;
uniform sampler2D noisetex;

uniform float aspectRatio;
uniform float viewWidth;
uniform float viewHeight;
uniform float rainStrength;

uniform vec3 sunPosition;
uniform vec3 moonPosition;

uniform int   isEyeInWater;
uniform int worldTime;

uniform mat4 gbufferProjection;
uniform float frameTimeCounter;
in float timeSunrise;
in float timeNoon;
in float timeSunset;
in float timeMidnight;

in vec4 texcoord;

float timeDay = 1.0 - timeMidnight;
float timeNoonNight = timeMidnight + timeNoon;
float timeSunriseSunset = 1.0 - timeNoonNight;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
float distratio(vec2 pos, vec2 pos2, float ratio) {
    float xvect = pos.x*ratio-pos2.x*ratio;
    float yvect = pos.y-pos2.y;
    return sqrt(xvect*xvect + yvect*yvect);
}

float gen_circular_lens(vec2 center, float size) {
    return 1.0-pow(min(distratio(texcoord.xy,center,aspectRatio),size)/size,10.0);
}

vec2 noisepattern(vec2 pos) {
    return vec2(abs(fract(sin(dot(pos ,vec2(18.9898f,28.633f))) * 4378.5453f)),abs(fract(sin(dot(pos.yx ,vec2(18.9898f,28.633f))) * 4378.5453f)));
} 

float yDistAxis (in float degrees) {
	
	vec4 tpos = vec4(sunPosition,1.0)*gbufferProjection;
		 tpos = vec4(tpos.xyz/tpos.w,1.0);
	vec2 lightPos = tpos.xy/tpos.z;
		 lightPos = (lightPos + 1.0f)/2.0f;
			 
	return abs((lightPos.y-lightPos.x*(degrees))-(texcoord.y-texcoord.x*(degrees)));
		
}

float ratioDist (in float lensDist) {

	vec4 tpos = vec4(sunPosition,1.0)*gbufferProjection;
		 tpos = vec4(tpos.xyz/tpos.w,1.0);
	vec2 lightPos = tpos.xy/tpos.z*lensDist;
		 lightPos = (lightPos + 1.0f)/2.0f;
			 
	return distratio(lightPos.xy,texcoord.xy,aspectRatio);
		
}

float smoothCircleDist (in float lensDist) {
	vec4 tpos = vec4(sunPosition,1.0)*gbufferProjection;
		 tpos = vec4(tpos.xyz/tpos.w,1.0);
	vec2 lightPos = tpos.xy/tpos.z*lensDist;
		 lightPos = (lightPos + 1.0f)/2.0f;
			 
	return distratio(lightPos.xy, texcoord.xy, aspectRatio);		
}

float hash( float n ) {
	return fract(sin(n)*43758.5453);
}
	
float noise( in vec2 x ) {
	vec2 p = floor(x);
	vec2 f = fract(x);
    	 f = f*f*(3.0-2.0*f);
    float n = p.x + p.y*57.0;
    float res = mix(mix( hash(n+  0.0), hash(n+  1.0),f.x), mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y);
    return res;
}
 
float fbm( vec2 p ) {
    float f = 0.0;
          f += 0.50000*noise( p ); p = p*2.02;
          f += 0.25000*noise( p ); p = p*2.03;
          f += 0.12500*noise( p ); p = p*2.01;
          f += 0.06250*noise( p ); p = p*2.04;
          f += 0.03125*noise( p );
		
    return f/1.084375;
}

vec2 texel = vec2(1.0/viewWidth,1.0/viewHeight);
	
#define deg2rad 3.14159 / 180.
#define degrad 3.14159 / 10.

float hex(float lensDist, float size) {                        
	
	vec4 tpos = vec4(sunPosition,1.0)*gbufferProjection;
		 tpos = vec4(tpos.xyz/tpos.w,1.0);
	vec2 lightPos = tpos.xy/tpos.z*lensDist;
		 lightPos = (lightPos + 1.0f)/2.0f;
	
	vec2 uv = texcoord.xy;	
		size *= (viewHeight + viewWidth) / 1920.0;
	
	vec2 v = (lightPos / texel) - (uv / texel);			
    vec2 topBottomEdge = vec2(0., 1.);
	vec2 leftEdges = vec2(cos(30.*deg2rad), sin(30.*deg2rad));
	vec2 rightEdges = vec2(cos(30.*deg2rad), sin(30.*deg2rad));

	float dot1 = dot(abs(v), topBottomEdge);
	float dot2 = dot(abs(v), leftEdges);
	float dot3 = dot(abs(v), rightEdges);

	float dotMax = max(max((dot1), (dot2)), (dot3));
		
	return max(0.0, mix(0.0, mix(1.0, 1.0, floor(size - dotMax*1.1 + 0.99 )), floor(size - dotMax + 0.99 ))) * 0.1;
}	

float Rectangle(float lensDist, float size) {                        
	
	vec4 tpos = vec4(sunPosition,1.0)*gbufferProjection;
		 tpos = vec4(tpos.xyz/tpos.w,1.0);
	vec2 lightPos = tpos.xy/tpos.z*lensDist;
		 lightPos = (lightPos + 1.0f)/2.0f;
	
	vec2 uv = texcoord.xy;	
		size *= (viewHeight + viewWidth) / 1920.0;
		
	vec2 v = (lightPos / texel) - (uv / texel);			
    vec2 topBottomEdge = vec2(0., 1.);
	vec2 leftEdges = vec2(cos(30.*degrad), sin(30.*degrad));
	vec2 rightEdges = vec2(cos(30.*degrad), sin(30.*degrad));

	float dot1 = dot(abs(v), topBottomEdge);
	float dot2 = dot(abs(v), leftEdges);
	float dot3 = dot(abs(v), rightEdges);

	float dotMax = max(max((dot1), (dot2)), (dot3));
		
	return max(0.0, mix(0.0, mix(1.0, 1.0, floor(size - dotMax*1.1 + 0.99 )), floor(size - dotMax + 0.99 ))) * 0.1;
}		
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void main() {
	vec4 color = texture(colortex2, texcoord.xy);
		 color.a = 1.0;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	vec3 sunPos = sunPosition;
	
	vec4 tpos = vec4(sunPosition,1.0)*gbufferProjection;
         tpos = vec4(tpos.xyz/tpos.w,1.0);
		 
    vec2 lightPos = tpos.xy/tpos.z;
		 lightPos = (lightPos + 1.0f)/2.0f;

    float distof = min(min(1.0-lightPos.x,lightPos.x),min(1.0-lightPos.y,lightPos.y));
	float fading = clamp(1.0-step(distof,0.1)+pow(distof*10.0,5.0),0.0,1.0);		 
	
	float time = float(worldTime);
	float transition_fading = 1.0-(clamp((time-12000.0)/500.0,0.0,1.0)-clamp((time-13000.0)/500.0,0.0,1.0) + clamp((time-22500.0)/100.0,0.0,1.0)-clamp((time-23300.0)/200.0,0.0,1.0));	 
	
    float sunvisibility = min(float(texture(colortex1, lightPos).r == 0), 1.0) * fading * transition_fading;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 

	float lensBrightness = 0.0;
	float lensExpDT = 1.0;

	#ifdef LF
		if (isEyeInWater < 0.5){
			lensBrightness = lensExpDT * 0.8 - 0.5 * timeSunrise - 0.6 * timeSunset;	  
		}else{
			lensBrightness = 0;	 
		}
	#else
			lensBrightness = 0;	 
	#endif
    float truepos = 0.0f;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	if ((worldTime < 13000 || worldTime > 23000) && sunPos.z < 0) truepos = 1.0 * (timeNoon + timeSunriseSunset); 
		if ((worldTime < 23000 || worldTime > 13000) && -sunPos.z < 0) truepos = 1.0 * timeMidnight;
if (sunvisibility > 0.01) {	
	vec2 q = texcoord.xy + texcoord.x * 0.4;
	vec2 p = -1.0 + 3.0 * q;
	vec2 p2 = -1.0 + 3.0 * q + vec2(10.0, 10.0);
    float f = fbm(15.0 * p);
	float f2 = fbm(10.0 * p2);	 
	float cover = 0.4f;
	float sharpness = 0.99 * sunvisibility;
	float c = f - (1.0 - cover);
	if ( c < 0.0 )
		  c = 0.0;			
		  f = 1.0 - (pow(1.0 - sharpness, c));
	float c2 = f2 - (1.0 - cover);
	if ( c2 < 0.0 )
		  c2 = 0.0;			
		  f2 = 1.0 - (pow(1.0 - sharpness, c2));
	float dirtylens = (f * 2.0) + (f2 / 1);

	
    float visibility = max(pow(max(1.2 - smoothCircleDist(1.0)/0.9,0.1),2.0)-0.1,0.0);
	
	vec3 dirtcolorSunriseset = vec3(2.00, 0.9, 0.3) * 0.4 * timeSunriseSunset;
	vec3 dirtcolorNoon = vec3(2.52, 2.25, 2.25) * 0.4 * timeNoon;
	vec3 dirtcolorNight = vec3(0.8, 1.0, 1.3) * 0.03 * timeMidnight;					
	vec3 dirtcolor = dirtcolorSunriseset + dirtcolorNoon + dirtcolorNight;
	
	float lens_strength = 0.045 * lensBrightness;
	     dirtcolor *= lens_strength;
	color += vec4((dirtylens*visibility*truepos)*dirtcolor * 0.05*(1.0-rainStrength*1.0),1.0);
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

if (sunvisibility > 0.01) {
			
	float visibility = max(pow(max(1.0 - smoothCircleDist(1.0)/1.1,0.1),1.0)-0.1,0.0);
			
	vec3 lenscolorSunrise = vec3(0.3, 1.3, 2.55) * timeSunriseSunset;
	vec3 lenscolorNoon = vec3(0.4, 1.5, 2.55) * timeNoon;
	vec3 lenscolorNight = vec3(0.6, 0.8, 1.3) * timeMidnight;
				
	vec3 lenscolor = lenscolorSunrise + lenscolorNoon + lenscolorNight * 0.1;

	float lens_strength = 0.008 * lensBrightness;
	lenscolor *= lens_strength;
				
	float anamorphic_lens = max(pow(max(1.0 - yDistAxis(0.0)/0.25,0.1),10.0)-0.3,0.0);
	color += vec4(anamorphic_lens * lenscolor * visibility * truepos * sunvisibility * (1.0-rainStrength*1.0),1.0);			
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
if (sunvisibility > 0.01) {
											
	float hex0 = clamp(hex(-0.1, 100.0), 0.0, 0.8);
	float hex1 = clamp(hex(-0.3, 40.0), 0.0, 0.8);
    float hex2 = clamp(hex(-0.7, 55.0), 0.1, 0.8);
	float hex3 = clamp(hex(-1.0, 90.0), 0.0, 0.8);
	float hex4 = clamp(hex(-0.5, 120.0), 0.0, 0.8);
	
	float Sun = clamp(hex(1.0, 50.0), 0.9, 0.8);	
	
	vec3 hexColor = hex0 * vec3(0.4, 1.0, 1.0);
	vec3 hex1Color = hex1 * vec3(0.2, 0.6, 1.0);
	vec3 hex2Color = hex2 * vec3(0.15, 0.45, 1.0);
	vec3 hex3Color = hex3 * vec3(0.1, 0.4, 1.0);
	vec3 hex4Color = hex4 * vec3(0.1, 0.3, 1.0);
	
	vec3 SunColor = Sun * vec3(1.1, 0.7, 0.0) * 0.25;
	
	vec3 hexagon = hexColor + hex1Color + hex2Color + hex3Color + hex4Color + SunColor;
				
    color += vec4(hexagon * 0.0025 * lensBrightness * (1.0-rainStrength) * (timeSunriseSunset + timeNoon) * sunvisibility,1.0);				
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
if (rainStrength > 0.01) {
		const float pi = 3.14159265359;
		float raindrops = 0.0;
		float time2 = frameTimeCounter * 0.2;
		float fake_refract  = sin(texcoord.x*30.0 + texcoord.y*50.0);
        vec3 watercolor = textureLod(colortex2, texcoord.st + fake_refract * 0.0075, 2).rgb;
			 watercolor = pow(watercolor, vec3(2.2));
			 
		float gen = cos(time2*pi)*0.5+0.5;
		vec2 pos = noisepattern(vec2(0.9347*floor(time2*0.5+0.5),-0.2533282*floor(time2*0.5+0.5)));
		raindrops += gen_circular_lens(pos,0.033)*gen*rainStrength;

		gen = cos(time2*pi)*0.5+0.5;
		pos = noisepattern(vec2(0.785282*floor(time2*0.5+0.5),-0.285282*floor(time2*0.5+0.5)));
		raindrops += gen_circular_lens(pos,0.033)*gen*rainStrength;

		gen = sin(time2*pi)*0.5+0.5;
		pos = noisepattern(vec2(-0.347*floor(time2*0.5+0.5),0.6847*floor(time2*0.5+0.5)));
		raindrops += gen_circular_lens(pos,0.033)*gen*rainStrength;

		gen = cos(time2*pi)*0.5+0.5;
		pos = noisepattern(vec2(0.3347*floor(time2*0.5+0.5),-0.2533282*floor(time2*0.5+0.5)));
		raindrops += gen_circular_lens(pos,0.033)*gen*rainStrength;

		gen = cos(time2*pi)*0.5+0.5;
		pos = noisepattern(vec2(0.385282*floor(time2*0.5+0.5),-0.185282*floor(time2*0.5+0.5)));
		raindrops += gen_circular_lens(pos,0.033)*gen*rainStrength;
		
		gen = cos(time2*pi)*0.5+0.5;
		pos = noisepattern(vec2(0.385282*floor(time2*0.5+0.5),0.285282*floor(time2*0.5+0.5)));
		raindrops += gen_circular_lens(pos,0.033)*gen*rainStrength;
		
		gen = cos(time2*pi)*0.5+0.5;
		pos = noisepattern(vec2(0.385282*floor(time2*0.5+0.5),-0.385282*floor(time2*0.5+0.5)));
		raindrops += gen_circular_lens(pos,0.033)*gen*rainStrength;
		
		gen = cos(time2*pi)*0.5+0.5;
		pos = noisepattern(vec2(0.385282*floor(time2*0.5+0.5),-0.85282*floor(time2*0.5+0.5)));
		raindrops += gen_circular_lens(pos,0.033)*gen*rainStrength;
		
		color += vec4(raindrops*watercolor * 300.0,1.0);				
}		
	gl_FragData[0] = color;
}