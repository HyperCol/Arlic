<<<<<<< HEAD
#define TAA_blend 0.95

=======
>>>>>>> e791f6bfc7e8b945603c3d9b59878a446e19d942
#if !defined _TAA_
#define _TAA_

#include "/libs/antialiasing/taaProjection.glsl"

<<<<<<< HEAD
#ifndef Hardbaked_HDR
#define Hardbaked_HDR 0.001
#endif

#define TAA_Post_Sharpeness 50		//[0 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100]
#define TAA_Sharpeness 50		    //[0 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100]

vec3 Tonemapping(in vec3 c) {
  c *= 1.0 / Hardbaked_HDR;
  return c / (c + 1.0);
}

vec3 InverseTonemapping(in vec3 c) {
  return (-c / min(vec3(1e-5), c - 1.0)) * Hardbaked_HDR;
}

vec3 RGB_GAMMA(in vec3 c) {
  return pow(c, vec3(2.2));
}

vec3 GAMMA_RGB(in vec3 c) {
  return pow(c, vec3(1.0 / 2.2));
}

=======
#define TAA_Post_Sharpeness 50		//[0 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100]
#define TAA_Sharpeness 50		    //[0 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100]

>>>>>>> e791f6bfc7e8b945603c3d9b59878a446e19d942
	vec3 RGB_YCoCg(vec3 c)
	{
		// Y = R/4 + G/2 + B/4
		// Co = R/2 - B/2
		// Cg = -R/4 + G/2 - B/4

    //c = pow(c, vec3(2.2));
    //return c;

		return vec3(
			 c.x/4.0 + c.y/2.0 + c.z/4.0,
			 c.x/2.0 - c.z/2.0,
			-c.x/4.0 + c.y/2.0 - c.z/4.0
		);
	}

	vec3 YCoCg_RGB(vec3 c)
	{
		// R = Y + Co - Cg
		// G = Y + Cg
		// B = Y - Co - Cg
    //return c;

    c = clamp(vec3(
			c.x + c.y - c.z,
			c.x + c.z,
			c.x - c.y - c.z
		), vec3(0.0), vec3(1.0));

		//return pow(c, vec3(1.0 / 2.2));
		return c;
	}

    vec3 clipToAABB(vec3 color, vec3 minimum, vec3 maximum) {
        vec3 p_clip = 0.5 * (maximum + minimum);
        vec3 e_clip = 0.5 * (maximum - minimum);

        vec3 v_clip = color - p_clip;
        vec3 v_unit = v_clip.xyz / e_clip;
        vec3 a_unit = abs(v_unit);
        float ma_unit = max(a_unit.x, max(a_unit.y, a_unit.z));

        if (ma_unit > 1.0) return p_clip + v_clip / ma_unit;
        
        return color;// point inside aabb
    }

    vec3 GetClosest(in vec2 coord){
        vec3 closest = vec3(0.0, 0.0, 1.0);

        for(float i = -1.0; i <= 1.0; i += 1.0){
        for(float j = -1.0; j <= 1.0; j += 1.0){
            vec2 neighborhood = vec2(i, j) / vec2(viewWidth, viewHeight);
            float neighbor = (texture2D(depthtex0, coord + neighborhood).x);

            if(neighbor < closest.z){
            closest.z = neighbor;
            closest.xy = neighborhood;
            }
        }
        }

        closest.xy += coord;
        //closest.z = texture2D(depthtex0, closest.xy).x;

        return closest;
    }

    vec2 CalculateVector(in vec3 coord){
        vec4 view = gbufferProjectionInverse * vec4(coord * 2.0 - 1.0, 1.0);
            view /= view.w;
            view = gbufferModelViewInverse * view;
            view.xyz += cameraPosition - previousCameraPosition;
            view = gbufferPreviousModelView * view;
            view = gbufferPreviousProjection * view;
            view /= view.w;
            view.xy = view.xy * 0.5 + 0.5;

        vec2 velocity = coord.xy - view.xy;

        if(coord.z < 0.7) 
        velocity *= 0.001;

        return velocity;
    }

  vec4 ReprojectSampler(in sampler2D tex, in vec2 pixelPos){
    vec4 result = vec4(0.0);

    vec2 position = vec2(viewWidth, viewHeight) * pixelPos;
    vec2 centerPosition = floor(position - 0.5) + 0.5;

    vec2 f = position - centerPosition;
    vec2 f2 = f * f;
    vec2 f3 = f * f2;

    float c = TAA_Sharpeness  * 0.01;
    vec2 w0 =         -c  *  f3 + 2.0 * c          *  f2 - c  *  f;
    vec2 w1 =  (2.0 - c)  *  f3 - (3.0 - c)        *  f2            + 1.0;
    vec2 w2 = -(2.0 - c)  *  f3 + (3.0 - 2.0 * c)  *  f2 + c  *  f;
    vec2 w3 =          c  *  f3 - c                *  f2;
    vec2 w12 = w1 + w2;

    vec2 tc12 = (centerPosition + w2 / w12) / vec2(viewWidth, viewHeight);
    vec3 centerColor = texture2D(tex, vec2(tc12.x, tc12.y)).rgb;
    vec2 tc0 = (centerPosition - 1.0) / vec2(viewWidth, viewHeight);
    vec2 tc3 = (centerPosition + 2.0) / vec2(viewWidth, viewHeight);

    result = vec4(texture2D(tex, vec2(tc12.x, tc0.y)).rgb, 1.0) * (w12.x * w0.y) +
          	 vec4(texture2D(tex, vec2(tc0.x, tc12.y)).rgb, 1.0) * (w0.x * w12.y) +
          	 vec4(centerColor, 1.0) * (w12.x * w12.y) +
           	 vec4(texture2D(tex, vec2(tc3.x, tc12.y)).rgb, 1.0) * (w3.x * w12.y) +
          	 vec4(texture2D(tex, vec2(tc12.x, tc3.y)).rgb, 1.0) * (w12.x * w3.y);

    result /= result.a;

    //result.rgb = pow(result.rgb, vec3(2.2));
    //result.rgb = pow(result.rgb, vec3(1.0 / 2.2));

    return result;
  }

<<<<<<< HEAD
  void ResolverAABB(in vec2 coord, inout vec3 minColor, inout vec3 maxColor, in float scale){
=======
  void ResolverAABB(in sampler2D colorSampler, in vec2 coord, inout vec3 minColor, inout vec3 maxColor){
>>>>>>> e791f6bfc7e8b945603c3d9b59878a446e19d942
    vec3 sampleColor = vec3(0.0);
    float totalWeight = 0.0;

    vec3 m1 = vec3(0.0);
    vec3 m2 = vec3(0.0);

<<<<<<< HEAD
    for(float i = -1.0; i <= 1.0; i += 1.0){
      for(float j = -1.0; j <= 1.0; j += 1.0){
        vec2 samplePosition = vec2(i, j);
        vec3 sampleColor = RGB_YCoCg(Tonemapping(RGB_GAMMA(texture2DLod(colortex2, coord + samplePosition / vec2(viewWidth, viewHeight), 0).rgb)));

        m1 += sampleColor;
        m2 += sampleColor * sampleColor;
      }
    }

    m1 /= 9.0;
	  m2 /= 9.0;

    vec3 stddev = sqrt(m2 - m1 * m1);

    //float scale = 2.0;
=======
	for(float i = -1.0; i <= 1.0; i += 1.0){
		for(float j = -1.0; j <= 1.0; j += 1.0){
			vec2 samplePosition = vec2(i, j);
			vec3 sampleColor = RGB_YCoCg(texture2D(colortex2, coord + samplePosition / vec2(viewWidth, viewHeight)).rgb);

			m1 += sampleColor;
			m2 += sampleColor * sampleColor;
		}
	}

    m1 /= 9.0;
	m2 /= 9.0;

    vec3 stddev = sqrt(m2 - m1 * m1);

    float scale = 2.0;
>>>>>>> e791f6bfc7e8b945603c3d9b59878a446e19d942

    minColor = m1 - stddev * scale;
    maxColor = m1 + stddev * scale;

<<<<<<< HEAD
    vec3 centerColor = RGB_YCoCg(Tonemapping(RGB_GAMMA(texture2DLod(colortex2, coord, 0).rgb)));
=======
    vec3 centerColor = RGB_YCoCg(texture2D(colorSampler, coord).rgb);
>>>>>>> e791f6bfc7e8b945603c3d9b59878a446e19d942
    minColor = min(minColor, centerColor);
    maxColor = max(maxColor, centerColor);
  }

void CalculateClampColor(in vec2 coord, inout vec3 minColor, inout vec3 maxColor){
<<<<<<< HEAD
	for(float i = -1.0; i <= 1.0; i += 1.0){
		for(float j = -1.0; j <= 1.0; j += 1.0){
			vec2 samplePosition = vec2(i, j);
			vec3 sampleColor = RGB_YCoCg(Tonemapping(RGB_GAMMA(texture2DLod(colortex2, coord + samplePosition / vec2(viewWidth, viewHeight), 0).rgb)));
=======
    /*
	vec3 m1 = vec3(0.0);
	vec3 m2 = vec3(0.0);

	for(float i = -1.0; i <= 1.0; i += 1.0){
		for(float j = -1.0; j <= 1.0; j += 1.0){
			vec2 samplePosition = vec2(i, j);
			vec3 sampleColor = RGB_YCoCg(texture2D(colortex2, coord + samplePosition * pixel).rgb);

			m1 += sampleColor;
			m2 += sampleColor * sampleColor;
		}
	}

	m1 /= 9.0;
	m2 /= 9.0;

	vec3 v = sqrt(m2 - m1 * m1) * 1.0;

	maxColor = m1 + v;
	minColor = m1 - v;


		*/
	for(float i = -1.0; i <= 1.0; i += 1.0){
		for(float j = -1.0; j <= 1.0; j += 1.0){
			vec2 samplePosition = vec2(i, j);
			vec3 sampleColor = RGB_YCoCg(texture2D(colortex2, coord + samplePosition / vec2(viewWidth, viewHeight)).rgb);//GetColorTexture(coord + samplePosition * pixel);
>>>>>>> e791f6bfc7e8b945603c3d9b59878a446e19d942

			minColor = min(minColor, sampleColor);
			maxColor = max(maxColor, sampleColor);
		}
	}
	
}

vec3 TemportalAntiAliasing(in vec2 coord){
	vec2 unjitter = coord + jitter;

<<<<<<< HEAD
	vec3 currentColor = RGB_YCoCg(Tonemapping(RGB_GAMMA(texture2DLod(colortex2, unjitter, 0).rgb)));
	vec3 maxColor = vec3(-1.0);
	vec3 minColor = vec3(1.0);
  ResolverAABB(unjitter, minColor, maxColor, 2.0);
  //vec3 maxColor = currentColor;
  //vec3 minColor = currentColor;
	//CalculateClampColor(unjitter, minColor, maxColor);
=======
	vec3 currentColor = RGB_YCoCg(texture2D(colortex2, unjitter).rgb);
	vec3 maxColor = currentColor;
	vec3 minColor = currentColor;
	CalculateClampColor(unjitter, minColor, maxColor);
>>>>>>> e791f6bfc7e8b945603c3d9b59878a446e19d942

	vec3 closest = GetClosest(unjitter);	//vec3(unjitter, texture2D(depthtex0, unjitter).x)
	vec2 velocity = CalculateVector(closest);

	vec2 reprojectCoord = texcoord.st - velocity;

<<<<<<< HEAD
	vec3 previousSample = RGB_YCoCg(RGB_GAMMA(ReprojectSampler(colortex7, reprojectCoord).rgb));

	vec3 antialiasing = previousSample;
	  	 antialiasing = clamp(antialiasing, minColor, maxColor);

	float blend = TAA_blend;
		    blend *= float(floor(reprojectCoord) == vec2(0.0));
		    blend *= mix(1.0, 0.8, min(1.0, length(velocity * vec2(viewWidth, viewHeight))));

	antialiasing = mix(currentColor, antialiasing, blend);

	return (YCoCg_RGB(antialiasing));
}
=======
	vec3 previousSample = RGB_YCoCg(ReprojectSampler(colortex7, reprojectCoord).rgb);

	vec3 antialiasing = previousSample;
		 antialiasing = clamp(antialiasing, minColor, maxColor);

	float blend = 0.95;
		  blend *= float(floor(reprojectCoord) == vec2(0.0));
		  blend *= mix(1.0, 0.7071, min(1.0, length(velocity * vec2(viewWidth, viewHeight))));

	antialiasing = mix(currentColor, antialiasing, blend);

	return YCoCg_RGB(antialiasing);
}

>>>>>>> e791f6bfc7e8b945603c3d9b59878a446e19d942
#endif