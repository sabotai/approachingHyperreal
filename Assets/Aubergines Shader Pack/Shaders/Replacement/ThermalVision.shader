Shader "Aubergine/Replacement/ThermalVision" {
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
				float4 res;

				half4 frag (v2f i) : COLOR {
					half4 col = tex2D(_MainTex, i.uv);
					half4 cols[3];
					cols[0] = float4(0.0,0.0,1.0,1.0);
					cols[1] = float4(1.0,1.0,0.0,1.0);
					cols[2] = float4(1.0,0.0,0.0,1.0);
					float lum = dot(col.rgb, float3(0.3, 0.59, 0.11));
					int ix = (lum < 0.5) ? 0 : 1;
					if (ix == 0) {
						//res = col;
						res = cols[0] * (lum-float(ix)*0.5)/0.5 + (1 - (lum-float(ix)*0.5)/0.5) * cols[1];
					}
					if (ix == 1) {
						res = cols[1] * (lum-float(ix)*0.5)/0.5 + (1 - (lum-float(ix)*0.5)/0.5) * cols[2];
					}
					return res;
				}
			ENDCG
		}
	}
}