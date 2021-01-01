#version 120

uniform sampler2D tex;

varying vec4 texcoord;
varying vec4 color;


vec4 TextureSmooth(in sampler2D tex, in vec2 coord, in int level)
{
	float scale = pow(2.0f, float(level));
	vec2 atlasTiles = vec2(32.0f, 16.0f);
	float tileResolution = 128.0f;
		  tileResolution /= scale;
	vec2 res = atlasTiles * tileResolution;
	coord = coord * res;
	vec2 i = coord;
	vec2 f = fract(coord);
	//f = f * f * (3.0f - 2.0f * f);

	//i -= vec2(0.5f);

	vec2 minI = vec2(i.x - mod(i.x, tileResolution), i.y - mod(i.y, tileResolution));
	vec2 maxI = vec2(minI.x + tileResolution, minI.y + tileResolution);



	vec2 icoordCenter = i / res;
	vec2 icoordRight		= (i + vec2(1.0f, 0.0f));

		if (icoordRight.x < minI.x)
			icoordRight.x += tileResolution;
		else if (icoordRight.x > maxI.x)
			icoordRight.x -= tileResolution;

		if (icoordRight.y < minI.y)
			icoordRight.y += tileResolution;
		else if (icoordRight.y > maxI.y)
			icoordRight.y -= tileResolution;

		icoordRight /= res;


	vec2 icoordUp			= (i + vec2(0.0f, 1.0f));

		if (icoordUp.x < minI.x)
			icoordUp.x += tileResolution;
		else if (icoordUp.x > maxI.x)
			icoordUp.x -= tileResolution;

		if (icoordUp.y < minI.y)
			icoordUp.y += tileResolution;
		else if (icoordUp.y > maxI.y)
			icoordUp.y -= tileResolution;

		icoordUp /= res;


	vec2 icoordUpRight		= (i + vec2(1.0f, 1.0f));

		if (icoordUpRight.x < minI.x)
			icoordUpRight.x += tileResolution;
		else if (icoordUpRight.x > maxI.x)
			icoordUpRight.x -= tileResolution;

		if (icoordUpRight.y < minI.y)
			icoordUpRight.y += tileResolution;
		else if (icoordUpRight.y > maxI.y)
			icoordUpRight.y -= tileResolution;

		icoordUpRight /= res;



	vec4 texCenter	= texture2D(tex, icoordCenter);
	vec4 texRight	= texture2D(tex, icoordRight);
	vec4 texUp		= texture2D(tex, icoordUp);
	vec4 texUpRight = texture2D(tex, icoordUpRight);

//	if (alphaCheck)
//	{
		if (texCenter.a < 0.5f && texCenter.r + texCenter.g + texCenter.b < 0.1f)
			texCenter.rgb = max(texRight.rgb, max(texUp.rgb, texUpRight.rgb));
		else if (texCenter.a < 0.5f && texCenter.r + texCenter.g + texCenter.b > 0.1f)
			texCenter.rgb = min(texRight.rgb, min(texUp.rgb, texUpRight.rgb));

		if (texUp.a < 0.5f && texUp.r + texUp.g + texUp.b < 0.1f)
			texUp.rgb = max(texCenter.rgb, max(texRight.rgb, texUpRight.rgb));
		else if (texUp.a < 0.5f && texUp.r + texUp.g + texUp.b > 0.1f)
			texUp.rgb = min(texCenter.rgb, min(texRight.rgb, texUpRight.rgb));

		if (texRight.a < 0.5f && texRight.r + texRight.g + texRight.b < 0.1f)
			texRight.rgb = max(texCenter.rgb, max(texUpRight.rgb, texUp.rgb));
		else if (texRight.a < 0.5f && texRight.r + texRight.g + texRight.b > 0.1f)
			texRight.rgb = min(texCenter.rgb, min(texUpRight.rgb, texUp.rgb));

		if (texUpRight.a < 0.5f && texUpRight.r + texUpRight.g + texUpRight.b < 0.1f)
			texUpRight.rgb = max(texCenter.rgb, max(texUp.rgb, texRight.rgb));
		else if (texUpRight.a < 0.5f && texUpRight.r + texUpRight.g + texUpRight.b > 0.1f)
			texUpRight.rgb = min(texCenter.rgb, min(texUp.rgb, texRight.rgb));
//	}

	texCenter = mix(texCenter, texUp, vec4(f.y));
	texRight  = mix(texRight, texUpRight, vec4(f.y));

	vec4 result = mix(texCenter, texRight, vec4(f.x));
	return result;
}



void main() {

	vec4 tex = texture2D(tex, texcoord.st, 0) * color;


	gl_FragData[0] = tex;
}