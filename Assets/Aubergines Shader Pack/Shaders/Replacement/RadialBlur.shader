Shader "Aubergine/Replacement/RadialBlur" {
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

				half4 frag (v2f i) : COLOR {
					half4 col = 0;
					float2 center = float2(0.5, 0.5);
					i.uv -= center;
					for(int a = 0; a<12; a++) {
						float scale = 1 + (-0.2 * a/(11.0));
						col += tex2D(_MainTex, i.uv*scale + center);
					}
					col /= 12;
					return col;
				}
			ENDCG
		}
	}
}