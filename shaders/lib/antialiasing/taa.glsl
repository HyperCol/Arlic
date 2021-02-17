#ifndef _TAA_
    #define _TAA_
#endif

#ifndef _TAAPROJECTION_
    #include "/lib/antialiasing/taaProjection.glsl"
#endif

#define TAA_Post_Sharpeness 50		//[0 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100]
#define TAA_Sharpeness 50		    //[0 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100]

#ifdef TAA_ToneMapping
    #define TAA_ToneMapping_A 0.0000156
    #define TAA_ToneMapping_B 0.5

    vec3 ToneMapping(in vec3 color){
        float a = TAA_ToneMapping_A;
        float b = TAA_ToneMapping_B;

        float lum = max(color.r, max(color.g, color.b));

        if(bool(step(lum, a))) return color;

        return color/lum*((a*a-b*lum)/(2.0*a-b-lum));
    }

    vec3 InverseToneMapping(in vec3 color){
        float a = TAA_ToneMapping_A;
        float b = TAA_ToneMapping_B;

        float lum = max(color.r, max(color.g, color.b));

        if(bool(step(lum, a))) color;

        return color/lum*((a*a-(2.0*a-b)*lum)/(b-lum));
    }
#endif

#ifdef TAA_TemportalAntiAliasing
	vec3 RGB_YCoCg(vec3 c)
	{
		// Y = R/4 + G/2 + B/4
		// Co = R/2 - B/2
		// Cg = -R/4 + G/2 - B/4

    c = pow(c, vec3(2.2));
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
            vec2 neighborhood = vec2(i, j) * pixel;
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

    vec2 position = resolution * pixelPos;
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

    vec2 tc12 = pixel * (centerPosition + w2 / w12);
    vec3 centerColor = texture2D(tex, vec2(tc12.x, tc12.y)).rgb;
    vec2 tc0 = pixel * (centerPosition - 1.0);
    vec2 tc3 = pixel * (centerPosition + 2.0);

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

  void ResolverAABB(in sampler2D colorSampler, in vec2 coord, inout vec3 minColor, inout vec3 maxColor){
    vec3 sampleColor = vec3(0.0);
    float totalWeight = 0.0;

    vec3 m1 = vec3(0.0);
    vec3 m2 = vec3(0.0);

	for(float i = -1.0; i <= 1.0; i += 1.0){
		for(float j = -1.0; j <= 1.0; j += 1.0){
			vec2 samplePosition = vec2(i, j);
			vec3 sampleColor = RGB_YCoCg(texture2D(gaux3, coord + samplePosition * pixel).rgb);

			m1 += sampleColor;
			m2 += sampleColor * sampleColor;
		}
	}

    m1 /= 9.0;
	m2 /= 9.0;

    vec3 stddev = sqrt(m2 - m1 * m1);

    float scale = 2.0;

    minColor = m1 - stddev * scale;
    maxColor = m1 + stddev * scale;

    vec3 centerColor = RGB_YCoCg(texture2D(colorSampler, coord).rgb);
    minColor = min(minColor, centerColor);
    maxColor = max(maxColor, centerColor);
  }

void CalculateClampColor(in vec2 coord, inout vec3 minColor, inout vec3 maxColor){
    /*
	vec3 m1 = vec3(0.0);
	vec3 m2 = vec3(0.0);

	for(float i = -1.0; i <= 1.0; i += 1.0){
		for(float j = -1.0; j <= 1.0; j += 1.0){
			vec2 samplePosition = vec2(i, j);
			vec3 sampleColor = RGB_YCoCg(texture2D(gaux3, coord + samplePosition * pixel).rgb);

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
			vec3 sampleColor = RGB_YCoCg(texture2D(gaux3, coord + samplePosition * pixel).rgb);//GetColorTexture(coord + samplePosition * pixel);

			minColor = min(minColor, sampleColor);
			maxColor = max(maxColor, sampleColor);
		}
	}
	
}

vec3 TemportalAntiAliasing(in vec2 coord){
	vec2 unjitter = coord + jitter;

	vec3 currentColor = RGB_YCoCg(texture2D(gaux3, unjitter).rgb);
	vec3 maxColor = currentColor;
	vec3 minColor = currentColor;
	CalculateClampColor(unjitter, minColor, maxColor);

	vec3 closest = GetClosest(unjitter);	//vec3(unjitter, texture2D(depthtex0, unjitter).x)
	vec2 velocity = CalculateVector(closest);

	vec2 reprojectCoord = texcoord.st - velocity;

	vec3 previousSample = RGB_YCoCg(ReprojectSampler(colortex7, reprojectCoord).rgb);

	vec3 antialiasing = previousSample;
		 antialiasing = clamp(antialiasing, minColor, maxColor);

	float blend = 0.95;
		  blend *= float(floor(reprojectCoord) == vec2(0.0));
		  blend *= mix(1.0, 0.7071, min(1.0, length(velocity * resolution)));

	antialiasing = mix(currentColor, antialiasing, blend);

	return YCoCg_RGB(antialiasing);
}
#endif