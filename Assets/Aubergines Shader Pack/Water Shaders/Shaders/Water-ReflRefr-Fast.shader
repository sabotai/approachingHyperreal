Shader "Aubergine/Objects/NoLights/Water/ReflRefr-Fast" {
	Properties {
		_Color("Main Color", Color) = (0, 0.15, 0.115, 1)
		_WaveTex("Wave Texture", 2D) = "bump" {}
		_WaveSpeed("Wave Speed", Range(0.0, 0.2)) = 0.01
		_Refraction("Refraction Amount", Range(0.0, 1.0)) = 0.5
	}
	SubShader {
		Tags { "Queue"="Geometry" "RenderType"="Opaque" }
		LOD 200

		Pass {
			Lighting Off Fog { Mode Off }

			CGPROGRAM
				#pragma fragmentoption ARB_precision_hint_fastest
				#pragma vertex vert
				#pragma fragment frag
				#include "UnityCG.cginc"

				fixed4 _Color;
				sampler2D _WaveTex, _ReflectionTex, _RefractionTex;
				fixed4 _WaveTex_ST;
				fixed _WaveSpeed, _Refraction;

				struct v2f {
					float4 Pos : SV_POSITION;
					float2 Uv : TEXCOORD0;
					fixed3 View : TEXCOORD1;
					fixed4 SPos : TEXCOORD2;
				};

				v2f vert (appdata_tan v) {
					v2f o;
					o.Pos = mul(UNITY_MATRIX_MVP, v.vertex);
					o.Uv = TRANSFORM_TEX(v.texcoord, _WaveTex);
					o.View = ObjSpaceViewDir(v.vertex);
					o.View.x *= -1;
					o.SPos = ComputeScreenPos(o.Pos);
					return o;
				}

				fixed4 frag(v2f i) : COLOR {
					half speed = _Time.y * _WaveSpeed;
					//Fake tangent Space Normals
					fixed4 bump = tex2D(_WaveTex, i.Uv + speed) + tex2D(_WaveTex, i.Uv - speed);
					bump *= 0.5;
					fixed3 normalW = normalize(UnpackNormal(bump).rbg);
					i.View = normalize(i.View);

					//Reflection
					fixed4 projUv = i.SPos;
					projUv.xy += normalW.rb;
					fixed3 reflCol = tex2Dproj(_ReflectionTex, UNITY_PROJ_COORD(projUv)).rgb;
					//Refraction
					fixed3 refrCol = tex2Dproj(_RefractionTex, UNITY_PROJ_COORD(projUv)).rgb;
					//Fresnel term
					fixed EdotN = max(dot(i.View, normalW), 0);
					fixed facing = (1.0 - EdotN);
					//half fresnel = 1 - EdotN * 1.3f;
					//half fresnel = 0.20 + (1.0 - 0.20) - pow(facing, 5.0);
					//half fresnel = 0.02 + 0.97 * pow(facing, 5.0);
					fixed fresnel = 1 / pow(1 + EdotN, 5);

					fixed3 deepCol = (refrCol * _Refraction + _Color * (1 - _Refraction));
					fixed3 waterCol = (_Color * facing + deepCol * (1.0 - facing));
					fixed3 finalColor = fresnel * reflCol + waterCol;

					return fixed4(finalColor, 1);
				}
			ENDCG
		}
	} 
	FallBack Off
}