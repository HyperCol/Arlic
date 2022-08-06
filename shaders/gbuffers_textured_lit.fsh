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
VacGrd is part of HyperCol Studios
Do not modify this code until you have read the LICENSE contained in the root directory of this shaderpack!

*/


////////////////////////////////////////////////////ADJUSTABLE VARIABLES/////////////////////////////////////////////////////////

#define NORMAL_MAP_MAX_ANGLE 0.95f   		//The higher the value, the more extreme per-pixel normal mapping (bump mapping) will be.

#define Lab_PBR 0
#define SEUS_Renewed 1

#define PBR_Format Lab_PBR		//[Lab_PBR SEUS_Renewed]

///////////////////////////////////////////////////END OF ADJUSTABLE VARIABLES///////////////////////////////////////////////////



uniform sampler2D tex;
uniform sampler2D lightmap;
uniform sampler2D normals;
uniform sampler2D specular;
//uniform float rainStrength;
uniform float wetness;


in vec4 color;
in vec4 texcoord;
in vec4 lmcoord;

in vec3 normal;
in vec3 tangent;
in vec3 binormal;
in vec3 globalNormal;

in float distance;

const int GL_LINEAR = 9729;
const int GL_EXP = 2048;

const float bump_distance = 78.0f;
const float fademult = 0.1f;

#include "/libs/packing.glsl"

void main() {	
	vec4 albedo = texture(tex, texcoord.st) * color;

	if (albedo.a < 0.2){
		discard;
	}
	
	albedo.a = 1.0;

		
	vec4 spec = texture(specular, texcoord.st);

	#if PBR_Format == Lab_PBR
	float material_emissive = textureLod(specular, texcoord.xy, 0).a;
		  material_emissive = material_emissive * step(material_emissive, 0.999) * (255.0 / 254.0);
	#elif PBR_Format == SEUS_Renewed
	float material_emissive = textureLod(specular, texcoord.xy, 0).b;
	#endif

	spec.a = material_emissive;

	//store lightmap in auxilliary texture. r = torch light. g = lightning. b = sky light.
	vec4 lightmap = vec4(0.0f, 0.0f, 0.0f, 1.0f);
	
	//Separate lightmap types
	lightmap.r = clamp((lmcoord.s * 33.05f / 32.0f) - 1.05f / 32.0f, 0.0f, 1.0f);
	lightmap.b = clamp((lmcoord.t * 33.05f / 32.0f) - 1.05f / 32.0f, 0.0f, 1.0f);

	lightmap.b = pow(lightmap.b, 1.0f);
	lightmap.r = pow(lightmap.r, 1.0f);

	float wetfactor = clamp(lightmap.b - 0.9f, 0.0f, 0.1f) / 0.1f;
	
	
	vec4 frag2;
	
	if (distance < bump_distance) {
	
			vec3 bump = texture(normals, texcoord.st).rgb * 2.0f - 1.0f;
			
			float bumpmult = clamp(bump_distance * fademult - distance * fademult, 0.0f, 1.0f) * NORMAL_MAP_MAX_ANGLE;
	              //bumpmult *= 1.0f - (spec.g * 0.9f * wetness * wetfactor);
				  
			bump = bump * vec3(bumpmult, bumpmult, bumpmult) + vec3(0.0f, 0.0f, 1.0f - bumpmult);
			
		
			mat3 tbnMatrix = mat3(tangent.x, binormal.x, normal.x,
								  tangent.y, binormal.y, normal.y,
						     	  tangent.z, binormal.z, normal.z);
			
			frag2 = vec4(bump * tbnMatrix * 0.5 + 0.5, 1.0);
			
	} else {
	
			frag2 = vec4((normal) * 0.5f + 0.5f, 1.0f);		
			
	}		

	float mats_1 = 1.0f;
		  mats_1 += 0.1f;

	gl_FragData[0] = vec4(vec3(0.0), 0.2);
	gl_FragData[1] = vec4(mats_1/255.0f, lightmap.r, lightmap.b, 1.0f);
	gl_FragData[2] = frag2;
	gl_FragData[3] = vec4(pack2x8(spec.rg), pack2x8(spec.ba), 0.0f, 1.0);	
	gl_FragData[4] = vec4(albedo.rgb, 1.0);
}
/* DRAWBUFFERS:01235 */