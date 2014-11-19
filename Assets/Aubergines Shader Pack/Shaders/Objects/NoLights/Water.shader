Shader "Aubergine/Objects/NoLights/Water" {
	Properties {
		_Color ("Main Color", Color) = (1, 1, 1, 1)
		_ReflTex ("Reflection Texture", Cube) = "" {}
		_BumpTex ("Bump Map", 2D) = "bump" {}
		_Bumpiness ("Bump Amount", Range(0.0, 1.0)) = 0.5
		_Amount ("Reflection Amount", Range(0.0, 1.0)) = 0.5
		_Distortion ("Refraction Amount", Range(0.0, 1.0)) = 0.99
		_Speed ("Wave Speed", Range(0.0, 0.1)) = 0.01
	}
	SubShader {
		Tags { "Queue" = "Transparent-200" "RenderType"="Transparent" "IgnoreProjector"="True" }
		LOD 200
		Pass {
			Blend SrcAlpha OneMinusSrcAlpha
			//Blend SrcColor OneMinusSrcColor
			ZWrite Off Lighting Off Fog { Mode Off }

			CGPROGRAM
				#pragma exclude_renderers flash
				#pragma fragmentoption ARB_precision_hint_fastest
				#pragma vertex vert
				#pragma fragment frag
				#include "UnityCG.cginc"

				fixed4 _Color;
				fixed _Bumpiness, _Amount, _Distortion;
				half _Speed;
				samplerCUBE _ReflTex;
				sampler2D _BumpTex;
				float4 _BumpTex_ST;

				struct a2f {
					float4 vertex : POSITION;
					fixed3 normal : NORMAL;
					float4 texcoord : TEXCOORD0;
				};

				struct v2f {
					float4 Pos : SV_POSITION;
					float2 uv : TEXCOORD0;
					fixed3 Refl : TEXCOORD1;
					fixed3 Refr : TEXCOORD2;
				};

				v2f vert (a2f v) {
					v2f o;
					o.Pos = mul(UNITY_MATRIX_MVP, v.vertex);
					o.uv = TRANSFORM_TEX(v.texcoord, _BumpTex);
					half3 vDir = -WorldSpaceViewDir(v.vertex);
					//vDir.x *= -1.0;
					o.Refl = reflect(vDir, v.normal);
					o.Refr = refract(vDir, v.normal, _Distortion);
					return o;
				}

				fixed4 frag( v2f i ) : COLOR {
					fixed3 bump = UnpackNormal(tex2D(_BumpTex, i.uv + _Time.y * _Speed)) * _Bumpiness;
					bump += UnpackNormal(tex2D(_BumpTex, i.uv - _Time.y * _Speed)) * _Bumpiness;
					fixed3 reflC = texCUBE(_ReflTex, i.Refl + bump).rgb;
					fixed3 refrC = texCUBE(_ReflTex, i.Refr + bump).rgb;
					fixed3 c = lerp(reflC, refrC, _Amount) * _Color.rgb;
					return fixed4(c.rgb, _Color.a);
				}
			ENDCG
		}
	} 
	FallBack Off
}