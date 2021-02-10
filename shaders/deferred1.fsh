#version 120

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

uniform sampler2D gcolor;
uniform sampler2D gdepth;
uniform sampler2D gnormal;
uniform sampler2D composite;

uniform sampler2D depthtex0;

uniform mat4 gbufferProjectionInverse;

varying vec2 texcoord;

#include "/lib/common.glsl"
#include "/lib/packing.glsl"

void main() {
	vec3 albedo = texture2D(gcolor, texcoord).rgb;

	vec3 normal0 = NormalDecode(texture2D(gnormal, texcoord).xy);
	vec3 normal1 = NormalDecode(texture2D(gnormal, texcoord).zw);

	vec3 viewDirection = normalize(-nvec3(gbufferProjectionInverse * nvec4(vec3(texcoord, texture2D(depthtex0, texcoord).x) * 2.0 - 1.0)));
	if(dot(viewDirection, normal0) < 0.2) normal0 = normal1;

	vec4 data0 = vec4(pack2x8(albedo.rg), pack2x8(albedo.b, 1.0), NormalEncode(normal0));
	vec4 data1 = texture2D(gdepth, texcoord);
	vec4 data2 = texture2D(composite, texcoord);

	/* DRAWBUFFERS:456 */
	gl_FragData[0] = data0;
	gl_FragData[1] = data1;
	gl_FragData[2] = data2;
}