#ifndef INCLUDE_PACKING
#define INCLUDE_PACKING
#endif

float pack2x8(in vec2 x){
  float pack = dot(floor(x * 255.0), vec2(1.0, 256.0));
        pack /= (1.0 + 256.0) * 255.0;

  return pack;
}

float pack2x8(in float x, in float y){return pack2x8(vec2(x, y));}

vec2 unpack2x8(in float x){
  x *= 256.0;
  vec2 pack = vec2(fract(x), floor(x));
       pack *= vec2(256.0 / 255.0, 1.0 / 255.0);

  return pack;
}

float unpack2x8X(in float packge){return (256.0 / 255.0) * fract(packge * (256.0));}
float unpack2x8Y(in float packge){return (1.0 / 255.0) * floor(packge * (256.0));}

vec2 NormalEncode(vec3 n) {
  n = normalize(n);

    vec2 enc = normalize(n.xy) * (sqrt(-n.z*0.5+0.5));
    enc = enc*0.5+0.5;
    return enc;
}

vec3 NormalDecode(vec2 enc) {
    vec4 nn = vec4(2.0 * enc - 1.0, 1.0, -1.0);
    float l = dot(nn.xyz,-nn.xyw);
    nn.z = l;
    nn.xy *= sqrt(l);
    return nn.xyz * 2.0 + vec3(0.0, 0.0, -1.0);
}