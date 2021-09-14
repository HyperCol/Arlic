#if !defined _PACKING_
#define _PACKING_

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


#endif