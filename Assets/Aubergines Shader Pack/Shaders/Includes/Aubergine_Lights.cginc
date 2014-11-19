#ifndef AUBERGINE_LIGHTS_INCLUDED
#define AUBERGINE_LIGHTS_INCLUDED

fixed _LightWrapAmount;
fixed4 _LightRimColor;
fixed _LightRimPower, _LightRimBias;
fixed4 _LightWarmColor, _LightCoolColor;
fixed _LightWarmPower, _LightCoolPower;
fixed3 _AnisoTangents;
fixed4 _LightColorBack, _LightColorSide;

inline fixed4 LightingAub_Lambert (SurfaceOutput s, fixed3 lightDir, fixed atten) {
	//Calculate Diffuse Term
	fixed NL = dot(s.Normal, lightDir);
	fixed diff = max(NL, 0);
	fixed3 diffColor = s.Albedo * _LightColor0.rgb;
	//Sum up
	fixed4 c;
	c.rgb = (diffColor * diff) * (atten * 2);
	c.a = s.Alpha;
	return c;
}

inline fixed4 LightingAub_LambertWrap (SurfaceOutput s, fixed3 lightDir, fixed atten) {
	//Calculate Diffuse Term
	fixed NL = dot(s.Normal, lightDir) + _LightWrapAmount;
	fixed diff = max(NL, 0) / (1.0 + _LightWrapAmount);
	fixed3 diffColor = s.Albedo * _LightColor0.rgb;
	//Sum up
	fixed4 c;
	c.rgb = (diffColor * diff) * (atten * 2);
	c.a = s.Alpha;
	return c;
}

inline fixed4 LightingAub_Phong (SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten) {
	//Calculate Diffuse Term
	fixed NL = dot(s.Normal, lightDir);
	fixed diff = max(NL, 0);
	fixed3 diffColor = s.Albedo * _LightColor0.rgb;
	//Calculate Specular Term
	half3 r = reflect(-viewDir, s.Normal);
	fixed LR = dot(lightDir, r);
	float spec = pow(max(LR, 0), s.Specular * 128.0) * s.Gloss;
	fixed3 specColor = _SpecColor.rgb * _LightColor0.rgb;
	//Sum up
	fixed4 c;
	c.rgb = ((diffColor * diff) + (specColor * spec)) * (atten * 2);
	c.a = s.Alpha + (_LightColor0.a * _SpecColor.a * spec * atten);
	return c;
}

inline fixed4 LightingAub_Blinn (SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten) {
	//Calculate Diffuse Term
	fixed NL = dot(s.Normal, lightDir);
	fixed diff = max(NL, 0);
	fixed3 diffColor = s.Albedo * _LightColor0.rgb;
	//Calculate Specular Term
	half3 h = normalize(lightDir + viewDir);
	half NH = dot(s.Normal, h);
	float spec = pow(max(NH, 0), s.Specular * 128.0) * s.Gloss;
	fixed3 specColor = _SpecColor.rgb * _LightColor0.rgb;
	//Sum up
	fixed4 c;
	c.rgb = ((diffColor * diff) + (specColor * spec)) * (atten * 2);
	c.a = s.Alpha + (_LightColor0.a * _SpecColor.a * spec * atten);
	return c;
}

inline fixed4 LightingAub_Isotropic (SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten) {
	//Calculate Diffuse Term
	fixed NL = dot(s.Normal, lightDir);
	fixed diff = max(NL, 0);
	fixed3 diffColor = s.Albedo * _LightColor0.rgb;
	//Calculate Specular Term
	half3 h = normalize(lightDir + viewDir);
	half NH = dot(s.Normal, h);
	half NH2 = NH * NH;
	float spec = exp(-(s.Specular * 128.0) * (1.0 - NH2) / NH2) * s.Gloss;
	fixed3 specColor = _SpecColor.rgb * _LightColor0.rgb;
	//Sum up
	fixed4 c;
	c.rgb = ((diffColor * diff) + (specColor * spec)) * (atten * 2);
	c.a = s.Alpha + (_LightColor0.a * _SpecColor.a * spec * atten);
	return c;
}

inline fixed4 LightingAub_OrenNayar (SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten) {
	//Calculate Diffuse Term (Specular value is the roughness)
	fixed NL = dot(s.Normal, lightDir);
	half NV = dot(s.Normal, viewDir);
	half3 lProj = normalize(lightDir - s.Normal * NL);
	half3 vProj = normalize(viewDir - s.Normal * NV);
	half cx = max(dot(lProj, vProj), 0);
	half cosa = max(NL, NV);
	half cosb = min(NL, NV);
	half dx = sqrt((1.0-cosa * cosa) * (1.0-cosb * cosb)) / cosb;
	half a = 1.0-(0.5 * ((s.Specular * 128.0) / ((s.Specular * 128.0) + 0.33)));
	half b = 0.45 * ((s.Specular * 128.0) / ((s.Specular * 128.0) + 0.09));
	fixed diff = max(NL, 0) * (a + b * cx * dx) * s.Gloss;
	fixed3 diffColor = s.Albedo * _LightColor0.rgb;
	//Sum up
	fixed4 c;
	c.rgb = (diffColor * diff) * (atten * 2);
	c.a = s.Alpha;
	return c;
}

//TODO: Tangents is wrong, it should be passed from a vertex shader
//It will do for now.
inline fixed4 LightingAub_AnisotropicWrap (SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten) {
	half3 h = normalize(lightDir + viewDir);
	fixed3 tang = normalize (2.0 * _AnisoTangents - 1.0);
	half dot1 = dot(tang, h) - s.Specular;
	half dot2 = dot(s.Normal, h);
	half p = dot1/dot2;
	fixed3 diffColor = s.Albedo * _LightColor0.rgb;
	fixed3 specColor = _SpecColor.rgb * _LightColor0.rgb;
	//Sum up
	fixed4 c;
	c.rgb = (diffColor + specColor ) * exp(-p * p);
	c.a = s.Alpha;
	return c;
}

inline fixed4 LightingAub_Minnaert (SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten) {
	//Calculate Diffuse Term
	fixed d1 = pow(max(dot(s.Normal, lightDir), 0), 1.0 + _LightWrapAmount);
	fixed d2 = pow(1.0 - dot(s.Normal, viewDir), 1.0 - _LightWrapAmount);
	fixed diff = d1 * d2;
	fixed3 diffColor = s.Albedo * _LightColor0.rgb;
	//Sum up
	fixed4 c;
	c.rgb = (diffColor * diff) * (atten * 2);
	c.a = s.Alpha;
	return c;
}

inline fixed4 LightingAub_Toon (SurfaceOutput s, fixed3 lightDir, fixed atten) {
	//Calculate Diffuse Term
	fixed NL = dot(s.Normal, lightDir);
	fixed diff = 0.2 + max(NL, 0);
	fixed3 diffColor = s.Albedo * _LightColor0.rgb;
	//Sum up
	fixed4 c;
	if (diff < 0.4) c.rgb = (diffColor * diff) * (atten * 2) * 0.3;
	else if (diff < 0.7) c.rgb = (diffColor * diff) * (atten * 2) * 0.6;
	else c.rgb = (diffColor * diff) * (atten * 2) * 1.3;
	c.a = s.Alpha;
	return c;
}

inline fixed4 LightingAub_Gooch (SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten) {
	//Calculate Diffuse Term
	fixed NL = dot(s.Normal, lightDir);
	fixed3 kCool = min(_LightCoolColor.rgb + _LightCoolPower * (s.Albedo * _LightColor0.rgb), 1.0);
	fixed3 kWarm = min(_LightWarmColor.rgb + _LightWarmPower * (s.Albedo * _LightColor0.rgb), 1.0);
	fixed3 diffColor = lerp(kCool, kWarm, NL);
	//Calculate Specular Term
	fixed3 r = normalize(reflect(-lightDir, s.Normal));
	float spec = pow(max(dot(r, viewDir), 0), 32);
	//Sum up
	fixed4 c;
	c.rgb = min(diffColor + spec, 1.0);
	c.a = s.Alpha;
	return c;
}

inline fixed4 LightingAub_RimPhong (SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten) {
	//Calculate Diffuse Term
	fixed NL = dot(s.Normal, lightDir);
	fixed diff = max(NL, 0);
	fixed3 diffColor = s.Albedo * _LightColor0.rgb;
	//Calculate Specular Term
	half3 r = reflect(-viewDir, s.Normal);
	fixed LR = dot(lightDir, r);
	float spec = pow(max(LR, 0), s.Specular * 128.0) * s.Gloss;
	fixed3 specColor = _SpecColor.rgb * _LightColor0.rgb;
	//Calculate Rim Term
	float rim = pow(1.0 + _LightRimBias - max(dot(s.Normal, viewDir), 0), _LightRimPower);
	//Sum up
	fixed4 c;
	c.rgb = ((diffColor * diff + (_LightRimColor.rgb * rim)) + (specColor * spec)) * (atten * 2);
	c.a = s.Alpha + (_LightColor0.a * _SpecColor.a * spec * atten);
	return c;
}

//TODO: Improvements possible: Adjust specularity, remove rim??
inline fixed4 LightingAub_SubSurfaceScatter (SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten) {
	half NL = dot(s.Normal, lightDir);
	half3 ln = s.Albedo * _LightColor0.rgb * (atten * 2) * (NL * 0.5 + 0.5);
	half inFactor = max(dot(-s.Normal, lightDir), 0) + (dot(-viewDir, lightDir) * 0.5 + 0.5);
	half3 inDirect = fixed3(0.5 * inFactor * _LightColor0.rgb * (atten * 2)) * 0.5;
	half NV = dot(s.Normal, viewDir);
	half3 rim = fixed3(1.0 - max(NV, 0));
	rim *= rim;
	rim *= max(NL, 0) * (_SpecColor.rgb * _LightColor0.rgb);
	fixed4 c;
	c.rgb = ln + inDirect;
	c.rgb += (rim * 0.1 * (atten * 2));
	c.rgb += pow(max(dot(lightDir, reflect(-viewDir, s.Normal)), 0), s.Specular * 128.0) * s.Gloss;
	c.a = s.Alpha;
	return c;
}

//TODO: Improvements possible.
inline fixed4 LightingAub_SubSurfaceScatterA (SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten) {
	fixed NL = dot(s.Normal, lightDir);
	half3 ln = s.Albedo * _LightColor0.rgb * (atten * 2) * (NL * 0.5 + 0.5);
	half inFactor = max(dot(-s.Normal, lightDir), 0) + (dot(-viewDir, lightDir) * 0.5 + 0.5);
	half3 indirect = fixed3(0.5 * inFactor * _LightColor0.rgb * (atten * 2)) * 0.5;
	fixed4 c;
	c.rgb = ln + indirect;
	c.a = s.Alpha;
	return c;
}

inline fixed4 LightingAub_Lommel (SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten) {
	//Calculate Diffuse Term
	fixed a = max(dot(s.Normal, lightDir), 0);
	fixed b = max(dot(s.Normal, viewDir), 0);
	fixed diff = a / (a + b);
	fixed3 diffColor = s.Albedo * _LightColor0.rgb;
	//Calculate Specular Term
	//half3 h = normalize(lightDir + viewDir);
	//half NH = dot(s.Normal, h);
	//float spec = pow(max(NH, 0), s.Specular * 128.0) * s.Gloss;
	half3 r = reflect(-viewDir, s.Normal);
	fixed LR = dot(lightDir, r);
	float spec = pow(max(LR, 0), s.Specular * 128.0) * s.Gloss;
	fixed3 specColor = _SpecColor.rgb * _LightColor0.rgb;
	//Sum up
	fixed4 c;
	c.rgb = ((diffColor * diff) + (specColor * spec)) * (atten * 2);
	c.a = s.Alpha + (_LightColor0.a * _SpecColor.a * spec * atten);
	return c;
}

//TODO: How does unity calculate intensity??
inline fixed4 LightingAub_BiDirectional (SurfaceOutput s, fixed3 lightDir, fixed atten) {
	//Calculate Diffuse Term
	fixed diff1 = max(dot(s.Normal, lightDir), 0);
	fixed diff2 = max(dot(s.Normal, -lightDir), 0);
	//Sum up
	fixed4 c;
	c.rgb = s.Albedo * (_LightColor0.rgb * diff1 + _LightColorBack.rgb * diff2) * (atten * 2);
	c.a = s.Alpha;
	return c;
}

//TODO: How does unity calculate intensity??
inline fixed4 LightingAub_Hemispheric (SurfaceOutput s, fixed3 lightDir, fixed atten) {
	//Calculate Diffuse Term
	fixed diff = (dot(s.Normal, lightDir) + 1.0) * 0.5;
	//Sum up
	fixed4 c;
	c.rgb = s.Albedo * lerp(_LightColorBack.rgb, _LightColor0.rgb, diff) * (atten * 2);
	c.a = s.Alpha;
	return c;
}

//TODO: How does unity calculate intensity??
inline fixed4 LightingAub_TriDirectional (SurfaceOutput s, fixed3 lightDir, fixed atten) {
	//Calculate Diffuse Term
	fixed diff1 = max(dot(s.Normal, lightDir), 0);
	fixed diff2 = 1.0 - abs(dot(s.Normal, lightDir));
	fixed diff3 = max(dot(-s.Normal, lightDir), 0);
	//Sum up
	fixed4 c;
	c.rgb = s.Albedo * (_LightColor0.rgb * diff1 + _LightColorBack.rgb * diff2 + _LightColorSide.rgb * diff3) * (atten * 2);
	c.a = s.Alpha;
	return c;
}
#endif