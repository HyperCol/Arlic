#version 120

//upper majority of sky

varying vec4 color;

const int GL_LINEAR = 9729;
const int GL_EXP = 2048;

uniform int fogMode;




void main() {
	
	vec3 skyColor = color.rgb * 0.9f;
	float skyColorBoost = 0.0f;
	
		 skyColor.r = skyColor.r * (1.0f + skyColorBoost) - (skyColor.g * skyColorBoost / 2.0f) - (skyColor.b * skyColorBoost / 2.0f);
		 skyColor.g = skyColor.g * (1.0f + skyColorBoost) - (skyColor.r * skyColorBoost / 2.0f) - (skyColor.b * skyColorBoost / 2.0f);
		 skyColor.b = skyColor.b * (1.0f + skyColorBoost) - (skyColor.r * skyColorBoost / 2.0f) - (skyColor.g * skyColorBoost / 2.0f);

		 skyColor.rgb = gl_Fog.color.rgb;

	/* DRAWBUFFERS:03 */
	gl_FragData[0] = vec4(skyColor.rgb, color.a);
	gl_FragData[1] = vec4(0.0, 0.0, 1.0, 1.0);
}