#if !defined _BAYER_
#define _BAYER_
float bayer2(vec2 a) {
	a = floor(a);

	return fract(dot(a, vec2(0.5, a.y * 0.75)));
}

float bayer4(const vec2 a)   { return bayer2 (0.5   * a) * 0.25     + bayer2(a); }
float bayer8(const vec2 a)   { return bayer4 (0.5   * a) * 0.25     + bayer2(a); }
float bayer16(const vec2 a)  { return bayer4 (0.25  * a) * 0.0625   + bayer4(a); }
float bayer32(const vec2 a)  { return bayer8 (0.25  * a) * 0.0625   + bayer4(a); }
float bayer64(const vec2 a)  { return bayer8 (0.125 * a) * 0.015625 + bayer8(a); }
float bayer128(const vec2 a) { return bayer16(0.125 * a) * 0.015625 + bayer8(a); }
#endif