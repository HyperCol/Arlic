#version 120


uniform sampler2D texture;
uniform sampler2D lightmap;

varying vec4 color;
varying vec4 texcoord;
varying vec4 lmcoord;

void main() {

	//discard;
	gl_FragData[0] = vec4(texture2D(texture, texcoord.st).rgb, texture2D(texture, texcoord.st).a * 1.0f) * color;
	gl_FragData[1] = vec4(0.0f);
	gl_FragData[2] = vec4(0.0f);
	gl_FragData[3] = vec4(0.0f);
		
	
	
	
	
	
	/*
	//store lightmap in auxilliary texture. r = torch light. g = lightning. b = sky light.
	
	vec3 lightmaptorch = texture2D(lightmap, vec2(lmcoord.s, 0.00f)).rgb;
	vec3 lightmapsky   = texture2D(lightmap, vec2(0.0f, lmcoord.t)).rgb;
	
	//vec4 lightmap = texture2D(lightmap, lmcoord.st);
	vec4 lightmap = vec4(0.0f, 0.0f, 0.0f, 1.0f);
	
	//Separate lightmap types
	lightmap.r = dot(lightmaptorch, vec3(1.0f));
	lightmap.b = dot(lightmapsky, vec3(1.0f));
	*/
	
	
	
	//gl_FragData[5] = vec4(lightmap.rgb, texture2D(texture, texcoord.st).a * color.a * 0.0f);
	//gl_FragData[6] = vec4(0.0f, 0.0f, 1.0f, 0.0f);
	//gl_FragData[7] = vec4(0.0f, 0.0f, 0.0f, 0.0f);
		
}