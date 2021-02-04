#version 120



#include "Common.inc"


/*
 _______ _________ _______  _______  _ 
(  ____ \\__   __/(  ___  )(  ____ )( )
| (    \/   ) (   | (   ) || (    )|| |
| (_____    | |   | |   | || (____)|| |
(_____  )   | |   | |   | ||  _____)| |
      ) |   | |   | |   | || (      (_)
/\____) |   | |   | (___) || )       _ 
\_______)   )_(   (_______)|/       (_)

Do not modify this code until you have read the LICENSE.txt contained in the root directory of this shaderpack!

*/


//END OF INTERNAL VARIABLES//

/* DRAWBUFFERS:4 */

uniform sampler2D gaux1;

varying vec4 texcoord;

uniform float viewWidth;
uniform float viewHeight;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////MAIN//////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void main() 
{
	vec4 origColor = texture2D(gaux1, texcoord.st);

	vec3 wavesNormal = DecodeNormal(origColor.zw);
	vec3 wavesNormalr = DecodeNormal(texture2D(gaux1, mod(texcoord.st + vec2(0.5, 0.0), vec2(1.0))).zw);
	vec3 wavesNormalu = DecodeNormal(texture2D(gaux1, mod(texcoord.st + vec2(0.0, 0.5), vec2(1.0))).zw);
	vec3 wavesNormalur = DecodeNormal(texture2D(gaux1, mod(texcoord.st + vec2(0.5, 0.5), vec2(1.0))).zw);


	float lerpx = saturate((abs(texcoord.x - 0.5) * 2.0) * 3.0 - 2.0);
	float lerpy = saturate((abs(texcoord.y - 0.5) * 2.0) * 3.0 - 2.0);


	vec3 x0 = mix(wavesNormal, wavesNormalr, vec3(lerpx));
	vec3 x1 = mix(wavesNormalu, wavesNormalur, vec3(lerpx));
	vec3 seamlessWavesNormal = normalize(mix(x0, x1, vec3(lerpy)));



	gl_FragData[0] = vec4(origColor.xy, EncodeNormal(seamlessWavesNormal));
}

//change GetWavesNormal
//change material id getting of transparent blocks