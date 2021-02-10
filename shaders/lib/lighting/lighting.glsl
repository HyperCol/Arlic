#ifndef INCLUDE_LIGHTING
#define INCLUDE_LIGHTING
#endif

float SchlickFresnel(in float u) {
    return pow5(saturate(1.0 - u));
}

vec3 SchlickFresnel(vec3 F0, float u) {
    return mix(F0, vec3(1.0), SchlickFresnel(u));
}

float GTR1(float NdotH, float a)
{
    if (a >= 1) return 1/PI;

    float a2 = a*a;
    float t = 1 + (a2-1)*NdotH*NdotH;
    return (a2-1) / (PI*log(a2)*t);
}

float smithG_GGX(float NdotV, float alphaG) {
    float a = alphaG*alphaG;
    float b = NdotV*NdotV;
    return 1 / (NdotV + sqrt(a + b - a*b));
}

vec3 Diffuse_Burley_Disney( vec3 DiffuseColor, float Roughness, float NoV, float NoL, float VoH )
{
	float FD90 = 0.5 + 2 * VoH * VoH * Roughness;
	float FdV = 1 + (FD90 - 1) * pow5( 1 - NoV );
	float FdL = 1 + (FD90 - 1) * pow5( 1 - NoL );
	return DiffuseColor * ( (1 / PI) * FdV * FdL );
}

vec3 CalculateDiffuseLighting(in vec3 L, in vec3 v, in vec3 n0, vec3 n1, vec3 albedo, in float attenuation, vec3 F0, float roughness, float metallic, float material){
    vec3 h = normalize(L + v);

    float ndotv = max(0.0, dot(n1, v));
    float ndotl = max(0.0, dot(n0, L));
    float ldoth = max(0.0, dot(L, h));

    if(bool(step(ndotl, 0.1))) return vec3(0.0);

    vec3 kD = vec3(step(metallic, 0.9));

    vec3 diffuse = Diffuse_Burley_Disney(albedo, roughness, ndotv, ndotl, ldoth); 

    return diffuse / pow2(attenuation) * ndotl * kD * (1.0 - metallic) * step(metallic, 0.9);
}

vec3 CalculateSpecularLighting(in vec3 L, in vec3 v, in vec3 n0, vec3 n1, vec3 albedo, in float attenuation, vec3 F0, float roughness, float metallic, float material){
    vec3 h = normalize(L + v);

    float ndotv = max(0.0, dot(n1, v));
    float ndotl = max(0.0, dot(n0, L));
    float ndoth = max(0.0, dot(n0, h));
    float ldoth = max(0.0, dot(L, h));

    if(bool(step(ndotl, 0.1))) return vec3(0.0);

    vec3 f = SchlickFresnel(F0, ldoth);
    float d = GTR1(ndoth, roughness);
    float g = smithG_GGX(ndotv, roughness) * smithG_GGX(ndotl, roughness);
    float c = 4.0 * ndotl * ndotv + 1e-5;

    return f * d * min(1.0, g / c) * ndotl / pow2(attenuation) * 0.1;
}

vec3 CalculateSpecularLightingNormalized(in vec3 L, in vec3 v, in vec3 n0, vec3 n1, vec3 albedo, in float attenuation, vec3 F0, float roughness, float metallic, float material){
    vec3 h = normalize(L + v);

    float ndotv = max(0.0, dot(n0, v));
    float ndotl = max(0.0, dot(n1, L));
    float ndoth = max(0.0, dot(n1, h));
    float ldoth = max(0.0, dot(L, h));

    //if(bool(step(ndotl, 0.1))) return vec3(0.0);

    vec3 f = SchlickFresnel(F0, ldoth);
    float d = GTR1(ndoth, roughness);
    float g = smithG_GGX(ndotv, roughness) * smithG_GGX(ndotl, roughness);
    float c = 4.0 * ndotl * ndotv + 1e-5;

    //return f;
    return f * saturate(d * min(1.0, g / c) * ndotl);
}

vec4 ImportanceSampleGGX(in vec2 E, in float roughness){
  roughness *= roughness;
  roughness = clamp(roughness, 0.0001, 0.9999);

  float Phi = E.x * 2.0 * PI;
  float CosTheta = sqrt((1 - E.y) / ( 1 + (roughness - 1) * E.y));
	float SinTheta = sqrt(1 - CosTheta * CosTheta);

  vec3 H = vec3(cos(Phi) * SinTheta, sin(Phi) * SinTheta, CosTheta);
  float D = GTR1(roughness, CosTheta) * CosTheta;

  return vec4(H, 1.0 / D);
}