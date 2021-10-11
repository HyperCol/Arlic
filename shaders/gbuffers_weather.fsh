#version 330 compatibility


uniform sampler2D tex;
uniform sampler2D lightmap;

in vec4 color;
in vec4 texcoord;
in vec4 lmcoord;

void main() {
	vec4 albedo = texture(tex, texcoord.st) * color;

	if(albedo.a < 0.2) discard;

	vec4 lightmap = vec4(0.0f, 0.0f, 0.0f, 1.0f);
	
	//Separate lightmap types
	lightmap.r = clamp((lmcoord.s * 33.05f / 32.0f) - 1.05f / 32.0f, 0.0f, 1.0f);
	lightmap.b = clamp((lmcoord.t * 33.05f / 32.0f) - 1.05f / 32.0f, 0.0f, 1.0f);

	lightmap.b = pow(lightmap.b, 1.0f);
	lightmap.r = pow(lightmap.r, 1.0f);

	gl_FragData[0] = vec4(albedo.rgb, 1.0);
	gl_FragData[1] = vec4(63.1 / 255.0, lmcoord.r, lmcoord.b, 1.0);
	gl_FragData[2] = vec4(vec3(0.0), 1.0);
	gl_FragData[3] = vec4(vec3(0.0), 1.0);
		
	
	
	
	
	
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