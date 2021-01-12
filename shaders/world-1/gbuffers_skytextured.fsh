#version 120

//sun and moon

uniform sampler2D texture;

varying vec4 color;
varying vec4 texcoord;

const int GL_LINEAR = 9729;
const int GL_EXP = 2048;

/* DRAWBUFFERS:0 */

uniform int fogMode;

float Luminance(in vec3 color)
{
	return dot(color.rgb, vec3(0.3333f, 0.3333f, 0.3333f));
}

void main() {

	vec4 tex = texture2D(texture, texcoord.st);

	gl_FragData[0] = tex * color;

	float matID = 0.0f;

	// float texLum = Luminance(tex.rgb);

	// if (texLum >= 0.6f) {
	// 	matID = 11.0f;
	// }

	gl_FragData[1] = vec4(matID / 255.0f, 0.0f, 1.0f, 1.0);
	
	gl_FragData[2] = vec4(0.0f, 0.0f, 0.0f, 1.0f);
	gl_FragData[3] = vec4(0.0f, 0.0f, 0.0f, 1.0f);
	//gl_FragData[3] = vec4(0.0f, 0.0f, 0.0f, 1.0f);
	//gl_FragData[6] = vec4(0.0f, 0.0f, 0.0f, 1.0f);
		
		
	if (fogMode == GL_EXP) {
		gl_FragData[0].rgb = mix(gl_FragData[0].rgb, gl_Fog.color.rgb, 1.0 - clamp(exp(-gl_Fog.density * gl_FogFragCoord), 0.0, 1.0));
	} else if (fogMode == GL_LINEAR) {
		gl_FragData[0].rgb = mix(gl_FragData[0].rgb, gl_Fog.color.rgb, clamp((gl_FogFragCoord - gl_Fog.start) * gl_Fog.scale, 0.0, 1.0));
	}
	
	//gl_FragData[7] = vec4(0.0f, 0.0f, 0.0f, 0.0f);
}