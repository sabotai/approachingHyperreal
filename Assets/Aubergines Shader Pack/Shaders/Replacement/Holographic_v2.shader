Shader "Aubergine/Replacement/Holographic_v2" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		Tags { "Queue" = "Transparent" }

		CGINCLUDE
			#include "UnityCG.cginc"

			struct v2f {
				float4 pos : SV_POSITION;
				half2 uv : TEXCOORD0;
				float alpha : TEXCOORD1;
			};
			
			v2f vert (appdata_base v) {
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				float3 C = WorldSpaceViewDir(v.vertex);
				float3 N = mul(_Object2World, float4(v.normal, 0)).xyz;
				float NdotC = dot(N, C);
				NdotC = clamp(NdotC, 0.0, 1.0);
				half2 tUV;
				tUV.x = NdotC;
				tUV.y = 0;
				o.uv = tUV;
				o.alpha = 1.0-NdotC;
				return o;
			}
		ENDCG

		Pass {
			Blend DstColor OneMinusDstAlpha
			ZWrite Off
			
			Lighting Off Fog { Mode Off }
			CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag

				sampler2D _MainTex, _HoloTex;

				half4 frag (v2f i) : COLOR {
					half4 c = tex2D (_HoloTex, i.uv);
					c.a = i.alpha;
					return c;
				}
			ENDCG
		}
	}
}