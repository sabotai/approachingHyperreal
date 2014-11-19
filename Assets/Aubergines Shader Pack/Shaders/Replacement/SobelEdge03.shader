Shader "Aubergine/Replacement/SobelEdge03" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {

		CGINCLUDE
			#include "UnityCG.cginc"
			
			struct a2v {
				float4 vertex : POSITION;
				float4 texcoord : TEXCOORD0;
			};
			
			struct v2f {
				float4 pos : SV_POSITION;
				half2 uv : TEXCOORD0;
			};
			
			v2f vert (a2v v) {
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.texcoord.xy;
				return o;
			}
		ENDCG

		Pass {
			Lighting Off Fog { Mode Off }
			CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag

				sampler2D _MainTex;
				uniform float4 _MainTex_TexelSize;

				half4 frag (v2f i) : COLOR {
					//Change _Threshold value to customize
					float _Threshold = 4.7;
					//Sobel
					float off = _MainTex_TexelSize;
					half4 s00 = tex2D(_MainTex, i.uv + float2(-off, -off));
					half4 s01 = tex2D(_MainTex, i.uv + float2(0, -off));
					half4 s02 = tex2D(_MainTex, i.uv + float2(off, -off));
					
					half4 s10 = tex2D(_MainTex, i.uv + float2(-off, 0));
					half4 s12 = tex2D(_MainTex, i.uv + float2(off, 0));
					
					half4 s20 = tex2D(_MainTex, i.uv + float2(-off, off));
					half4 s21 = tex2D(_MainTex, i.uv + float2(0, off));
					half4 s22 = tex2D(_MainTex, i.uv + float2(off, off));
					
					half4 sX = s00 + 2 * s10 + s20 - s02 - 2 * s12 - s22;
					half4 sY = s00 + 2 * s01 + s02 - s20 - 2 * s21 - s22;
					
					half4 eSqr = sX * sX + sY * sY;
					return (1.0 - dot(eSqr, _Threshold)) * tex2D(_MainTex, i.uv);
				}
			ENDCG
		}
	}
}