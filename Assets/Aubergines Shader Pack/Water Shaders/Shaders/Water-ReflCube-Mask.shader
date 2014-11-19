Shader "Aubergine/Objects/NoLights/Water/ReflCube-Mask" {
	Properties {
		_Color("Main Color", Color) = (0, 0.15, 0.115, 1)
		_WaveTex("Wave Texture", 2D) = "bump" {}
		_CubeTex("Reflection Texture", Cube) = "" {}
		_WaveSpeed("Wave Speed", Range(0.0, 0.2)) = 0.01
		_MaskTex("Mask Texture", 2D) = "white" {}
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
				sampler2D _WaveTex, _MaskTex;
				fixed4 _WaveTex_ST;
				samplerCUBE _CubeTex;
				fixed _WaveSpeed;

				struct v2f {
					float4 Pos : SV_POSITION;
					float4 Uv : TEXCOORD0;
					fixed3 View : TEXCOORD1;
					fixed3 T2W0 : TEXCOORD2;
					fixed3 T2W1 : TEXCOORD3;
					fixed3 T2W2 : TEXCOORD4;
				};

				v2f vert (appdata_tan v) {
					v2f o;
					o.Pos = mul(UNITY_MATRIX_MVP, v.vertex);
					o.Uv.xy = TRANSFORM_TEX(v.texcoord, _WaveTex);
					o.Uv.zw = v.texcoord.xy;
					o.View = WorldSpaceViewDir(v.vertex);
					o.View.x *= -1;
					TANGENT_SPACE_ROTATION;
					o.T2W0 = mul(rotation, _Object2World[0].xyz * unity_Scale.w);
					o.T2W1 = mul(rotation, _Object2World[1].xyz * unity_Scale.w);
					o.T2W2 = mul(rotation, _Object2World[2].xyz * unity_Scale.w);
					return o;
				}

				fixed4 frag(v2f i) : COLOR {
					half speed = _Time.y * _WaveSpeed;
					//Tangent Space Normals
					fixed4 bump = tex2D(_WaveTex, i.Uv.xy + speed);
					bump += tex2D(_WaveTex, i.Uv.xy - speed);
					bump *= 0.5;
					fixed3 normal = UnpackNormal(bump);
					fixed3 normalW;
					normalW.x = dot(i.T2W0, normal.xyz);
					normalW.y = dot(i.T2W1, normal.xyz);
					normalW.z = dot(i.T2W2, normal.xyz);
					normalW = normalize(normalW);
					i.View = normalize(i.View);

					//Reflection
					fixed3 reflCol = texCUBE(_CubeTex, reflect(-i.View, normalW)).rgb;
					//Refraction
					fixed3 refrCol = texCUBE(_CubeTex, refract(-i.View, normalW, 0.66)).rgb;
					//Fresnel term
					fixed EdotN = max(dot(i.View, normalW), 0);
					fixed facing = (1.0 - EdotN);
					//half fresnel = 1 - EdotN * 1.3f;
					//half fresnel = 0.20 + (1.0 - 0.20) - pow(facing, 5.0);
					//half fresnel = 0.02 + 0.97 * pow(facing, 5.0);
					fixed fresnel = 1 / pow(1 + EdotN, 5);

					fixed mask = tex2D(_MaskTex, i.Uv.zw).r;

					fixed3 deepCol = (refrCol * mask + _Color * (1 - mask));
					fixed3 waterCol = (_Color * facing + deepCol * (1.0 - facing));
					fixed3 finalColor = fresnel * reflCol + waterCol;

					return fixed4(finalColor, 1);
				}
			ENDCG
		}
	} 
	FallBack Off
}