#version 330 compatibility

/* DRAWBUFFERS:0123 */

//clouds

uniform sampler2D tex;

in vec4 color;
in vec4 texcoord;
in vec4 lmcoord;

in vec3 normal;

const int GL_LINEAR = 9729;
const int GL_EXP = 2048;

uniform int fogMode;

void main() {

	vec4 lightmap = vec4(0.0f, 0.0f, 0.0f, 1.0f);
	
	//Separate lightmap types
	lightmap.r = clamp((lmcoord.s * 33.05f / 32.0f) - 1.05f / 32.0f, 0.0f, 1.0f);
	lightmap.b = clamp((lmcoord.t * 33.05f / 32.0f) - 1.05f / 32.0f, 0.0f, 1.0f);

	lightmap.b = pow(lightmap.b, 1.0f);
	lightmap.r = pow(lightmap.r, 1.0f);

	vec4 albedo = texture(tex, texcoord.st) * color;

	if(albedo.a < 0.2) discard;

	float maskid = 63.1;

	if (gl_FragCoord.z > 0.9999) {
		maskid = 255.1;
	}

	gl_FragData[0] = vec4(albedo.rgb, 1.0);
	gl_FragData[1] = vec4(maskid / 255.0, lightmap.r, lightmap.b, 1.0);
	gl_FragData[2] = vec4(normal.rgb * vec3(0.5) + vec3(0.5), 1.0);
	gl_FragData[3] = vec4(0.0, 0.0, 0.0, 1.0f);	
}