Shader "Aubergine/Replacement/Ripple" {
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
					float2 tUV = i.uv;
					float2 p = (-1.0 + 2.0 * tUV) - float2(0, 0);
					float len = length(p);
					float2 fUV = tUV + (p/len) * cos(len*16 - _Time.y * 4) * 0.009;

					float4 col = tex2D(_MainTex, fUV);
					return col;
				}
			ENDCG
		}
	}
}