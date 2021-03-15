#version 330 compatibility


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
VisionLab is part of HyperCol Studios
Do not modify this code until you have read the LICENSE contained in the root directory of this shaderpack!

*/

/* DRAWBUFFERS:6 */

uniform sampler2D colortex6;

in vec4 texcoord;

uniform float viewWidth;
uniform float viewHeight;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////MAIN//////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void main() 
{
	vec4 origColor = texture(colortex6, texcoord.st);

	vec3 wavesNormal = vec3(origColor.xy * 2.0 - 1.0, 1.0);
	vec3 wavesNormalr = vec3(texture(colortex6, mod(texcoord.st + vec2(0.5, 0.0), vec2(1.0))).xy * 2.0 - 1.0, 1.0);
	vec3 wavesNormalu = vec3(texture(colortex6, mod(texcoord.st + vec2(0.0, 0.5), vec2(1.0))).xy * 2.0 - 1.0, 1.0);
	vec3 wavesNormalur = vec3(texture(colortex6, mod(texcoord.st + vec2(0.5, 0.5), vec2(1.0))).xy * 2.0 - 1.0, 1.0);


	float lerpx = clamp((abs(texcoord.x - 0.5) * 2.0) * 3.0 - 2.0, 0.0, 1.0);
	float lerpy = clamp((abs(texcoord.y - 0.5) * 2.0) * 3.0 - 2.0, 0.0, 1.0);


	vec3 x0 = mix(wavesNormal, wavesNormalr, vec3(lerpx));
	vec3 x1 = mix(wavesNormalu, wavesNormalur, vec3(lerpx));
	vec3 seamlessWavesNormal = normalize(mix(x0, x1, vec3(lerpy)));



	gl_FragData[0] = vec4(seamlessWavesNormal.xy * 0.5 + 0.5, origColor.zw);
	//gl_FragData[0] = vec4(origColor);
}

//change GetWavesNormal
//change material id getting of transparent blocks