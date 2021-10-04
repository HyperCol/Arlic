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

const bool		colortex2MipmapEnabled = true;
/* DRAWBUFFERS:02 */

uniform sampler2D colortex2;
uniform sampler2D colortex7;
uniform sampler2D depthtex0;

uniform float aspectRatio;
uniform float viewWidth;
uniform float viewHeight;

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferPreviousModelView;
uniform mat4 gbufferPreviousProjection;

uniform vec3 cameraPosition;
uniform vec3 previousCameraPosition;

in vec4 texcoord;

#define Hardbaked_HDR 0.001

//#include "/libs/antialiasing/taa.glsl"

/////////////////////////FUNCTIONS/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////FUNCTIONS/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

vec3 CalculateBloom(in int LOD, in vec2 offset) {

	float scale = pow(2.0f, float(LOD));

	float padding = 0.02f;

	if (	texcoord.s - offset.s + padding < 1.0f / scale + (padding * 2.0f) 
		&&  texcoord.t - offset.t + padding < 1.0f / scale + (padding * 2.0f)
		&&  texcoord.s - offset.s + padding > 0.0f 
		&&  texcoord.t - offset.t + padding > 0.0f) {
		
		vec3 bloom = vec3(0.0f);
		float allWeights = 0.0f;

		for (int i = 0; i < 6; i++) {
			for (int j = 0; j < 6; j++) {

				float weight = 1.0f - distance(vec2(i, j), vec2(2.5f)) / 3.5;
					  weight = clamp(weight, 0.0f, 1.0f);
					  weight = 1.0f - cos(weight * 3.1415 / 2.0f);
					  weight = pow(weight, 2.0f);
				vec2 coord = vec2(i - 2.5, j - 2.5);
					 coord.x /= viewWidth;
					 coord.y /= viewHeight;
					 //coord *= 0.0f;

					 //coord.x -= 0.5f / viewWidth;
					 //coord.y -= 0.5f / viewHeight;

				vec2 finalCoord = (texcoord.st + coord.st - offset.st) * scale;

				if (weight > 0.0f)
				{
					bloom += pow(clamp(texture(colortex2, finalCoord, 0).rgb, vec3(0.0f), vec3(1.0f)), vec3(2.2f)) * weight;
					allWeights += 1.0f * weight;
				}
			}
		}

		bloom /= allWeights;

		return bloom;

	} else {
		return vec3(0.0f);
	}
	
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////MAIN//////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void main() {
	
	vec3 bloom  = CalculateBloom(2, vec2(0.0f)				+ vec2(0.000f, 0.000f)	);
		 bloom += CalculateBloom(3, vec2(0.0f, 0.25f)		+ vec2(0.000f, 0.025f)	);
		 bloom += CalculateBloom(4, vec2(0.125f, 0.25f)		+ vec2(0.025f, 0.025f)	);
		 bloom += CalculateBloom(5, vec2(0.1875f, 0.25f)	+ vec2(0.050f, 0.025f)	);
		 bloom += CalculateBloom(6, vec2(0.21875f, 0.25f)	+ vec2(0.075f, 0.025f)	);
		 bloom += CalculateBloom(7, vec2(0.25f, 0.25f)		+ vec2(0.100f, 0.025f)	);
		 bloom += CalculateBloom(8, vec2(0.28f, 0.25f)		+ vec2(0.125f, 0.025f)	);
		 bloom = pow(bloom, vec3(1.0f / (1.0f + 1.2f)));

	gl_FragData[0] = vec4(bloom.rgb, 1.0f);

	vec3 color = pow(textureLod(colortex2, texcoord.xy, 0).rgb, vec3(2.2));
	color = color * (1.0 / Hardbaked_HDR);
	color = color / (color + 1.0);
	color = pow(color, vec3(1.0 / 2.2));

	gl_FragData[1] = vec4(color, 1.0);

/*
	#ifdef Enabled_Temporal_Antialiasing
	vec3 antialiasing = TemportalAntiAliasing(texcoord.st);
	gl_FragData[1] = vec4(GAMMA_RGB(InverseTonemapping(antialiasing)), 1.0);
	gl_FragData[2] = vec4(GAMMA_RGB(antialiasing), 1.0);
	#else
	vec3 color = texture2D(colortex2, texcoord.xy).rgb;
	gl_FragData[1] = vec4(color, 1.0);
	gl_FragData[2] = vec4(0.0);
	#endif
*/
}