float F0ToIOR(in float F0) {
	return 1.0 / ((2.0 / (sqrt(max(0.02, F0)) + 1.0)) - 1.0);
}

float IORToF0(in float ior_material, float ior_eyes_in) {
	return pow((ior_material - ior_eyes_in) / (ior_material + ior_eyes_in), 2.0);
}

float IORToF0(in float ior) {
	return pow((ior - 1.0) / (ior + 1.0), 2.0);
}

float SchlickFresnel(in float cosTheta){
	return pow(1.0 - cosTheta, 5.0);
}

vec3 SchlickFresnel(in vec3 F0, in float cosTheta){
	return F0 + (1.0 - F0) * SchlickFresnel(cosTheta);
}

vec3 SchlickFresnel(in vec3 F0, in vec3 L, in vec3 v){
	vec3 h = normalize(L + v);
	float vdoth = max(0.0, dot(v, h));

	return F0 + (1.0 - F0) * SchlickFresnel(vdoth);
}

float DistributionTerm( float roughness, float ndoth ) {
	float d	 = ( ndoth * roughness - ndoth ) * ndoth + 1.0;
	return roughness / ( d * d * 3.14159265 );
}

float SmithGGX(float roughness, float cosTheta) {
  float r2 = roughness * roughness;
  float c2 = cosTheta * cosTheta;

  return (2.0 * cosTheta) / (cosTheta + sqrt(r2 + (1.0 - r2) * c2));
}

float VisibilityTerm(float roughness, float cosThetaIn, float cosThetaOut) {
    return SmithGGX(roughness, cosThetaIn) * SmithGGX(roughness, cosThetaOut);
}

vec4 ImportanceSampleGGX(in vec2 E, in float roughness){
  	float Phi = E.x * 2.0 * 3.14159265;
  	float CosTheta = sqrt((1 - E.y) / ( 1 + (roughness - 1) * E.y));
	float SinTheta = sqrt(1 - CosTheta * CosTheta);

  	vec3 H = vec3(cos(Phi) * SinTheta, sin(Phi) * SinTheta, CosTheta);
  	float D = DistributionTerm(roughness, CosTheta) * CosTheta;

  	return vec4(H, D);
}

vec3 CalculateDisneyDiffuse(in vec3 L, in vec3 v, in vec3 normal, in vec3 albedo, in vec3 F0, in float roughness, in float metallic) {
	vec3 h = normalize(L + v);

	float ldoth = max(0.0, dot(L, h));
	float ndotv = max(0.0, dot(normal, v));
	float ndotl = max(0.0, dot(normal, L));

	if(ndotl < 1e-5) return vec3(0.0);

	float FD90 = ldoth * ldoth * roughness * 2.0 + 0.5;
  	float FDV = 1.0 + (FD90 - 1.0) * SchlickFresnel(ndotv);
  	float FDL = 1.0 + (FD90 - 1.0) * SchlickFresnel(ndotl);

	//vec3 kD = 1.0 - SchlickFresnel(F0, ldoth);
	//kD *= (1.0 - metallic) * step(metallic, 0.9);

	vec3 diffuse = albedo * ((1.0 / 3.14159265) * FDL * FDV * saturate((ndotl - 0.2) / (1.0 - 0.2)));

	return diffuse;
}

vec3 CalculateSpecularLighting(in vec3 L, in vec3 v, in vec3 normal, in vec3 albedo, in vec3 F0, in float roughness, in float metallic) {
	vec3 h = normalize(v + L);

	float ndotl = max(0.0, dot(normal, L));
	float ndotv = max(0.0, dot(normal, v));
	float ndoth = max(0.0, dot(normal, h));

	vec3 f = SchlickFresnel(F0, saturate(dot(h, v)));
	float d = DistributionTerm(roughness, ndoth);
	float g = VisibilityTerm(roughness, ndotv, ndotl);
	float c = max(1e-5, ndotv * ndotl * 4.0);

	vec3 fr = f * (d * g / c * ndotl);

	return fr;
}