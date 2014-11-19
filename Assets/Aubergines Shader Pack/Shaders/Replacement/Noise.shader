Shader "Aubergine/Replacement/Noise" {
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
					float2 t = i.uv;
					float x = t.x * t.y * 123456 * _Time.y;
					x = fmod(x, 13) * fmod(x, 123);
					float dx = fmod(x, 0.01);
					float dy = fmod(x, 0.012);
					half4 col1 = tex2D(_MainTex, t+(float2(dx, dy) * 0.5));
					half4 col2 = tex2D(_MainTex, t-(float2(dx, dy) * 0.5));
					return lerp(col1, col2, 0.5);
				}
			ENDCG
		}
	}
}