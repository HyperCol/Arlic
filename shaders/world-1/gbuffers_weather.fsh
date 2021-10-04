#version 460 compatibility


uniform sampler2D tex;
uniform sampler2D lightmap;

in vec4 color;
in vec4 texcoord;
in vec4 lmcoord;

void main() {

	//discard;
	gl_FragData[0] = vec4(texture(tex, texcoord.st).rgb, texture(tex, texcoord.st).a * 1.0f) * color;
	gl_FragData[1] = vec4(0.0f);
	gl_FragData[2] = vec4(0.0f);
	gl_FragData[3] = vec4(0.0f);
		
	
	
	
	
	
	/*
	//store lightmap in auxilliary texture. r = torch light. g = lightning. b = sky light.
	
	vec3 lightmaptorch = texture(lightmap, vec2(lmcoord.s, 0.00f)).rgb;
	vec3 lightmapsky   = texture(lightmap, vec2(0.0f, lmcoord.t)).rgb;
	
	//vec4 lightmap = texture(lightmap, lmcoord.st);
	vec4 lightmap = vec4(0.0f, 0.0f, 0.0f, 1.0f);
	
	//Separate lightmap types
	lightmap.r = dot(lightmaptorch, vec3(1.0f));
	lightmap.b = dot(lightmapsky, vec3(1.0f));
	*/
	
	
	
	//gl_FragData[5] = vec4(lightmap.rgb, texture(texture, texcoord.st).a * color.a * 0.0f);
	//gl_FragData[6] = vec4(0.0f, 0.0f, 1.0f, 0.0f);
	//gl_FragData[7] = vec4(0.0f, 0.0f, 0.0f, 0.0f);
		
}