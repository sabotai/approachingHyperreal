Shader "Aubergine/Replacement/Emboss" {
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
					half4 col = tex2D(_MainTex, i.uv);
					col -= tex2D(_MainTex, i.uv+0.001)*2.0;
					col += tex2D(_MainTex, i.uv-0.001)*2.0;
					col.rgb = (col.r+col.g+col.b)/3.0;
					return col;
				}
			ENDCG
		}
	}
}