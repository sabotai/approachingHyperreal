Shader "Aubergine/Replacement/HolywoodNight" {
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
					half4x4 mtx;
					mtx[0][0] = 0.5149; mtx[0][1] = 0.3244; mtx[0][2] = 0.1607; mtx[0][3] = 0.0;
					mtx[1][0] = 0.2654; mtx[1][1] = 0.6704; mtx[1][2] = 0.0642; mtx[1][3] = 0.0;
					mtx[2][0] = 0.0248; mtx[2][1] = 0.1248; mtx[2][2] = 0.8504; mtx[2][3] = 0.0;
					mtx[3][0] = 0.0000; mtx[3][1] = 0.0000; mtx[3][2] = 0.0000; mtx[3][3] = 0.0;
					half4 col;
					half lum;
					col = tex2D(_MainTex, i.uv);
					col = mul(mtx, col);
					col = max(col, half4(0.01, 0, 0, 1));
					lum = col.y * (1.33 * (1 + (col.y + col.z) / col.x) - 1.68);
					half4 oCol;
					oCol.xyz = half3(0.62, 0.6, 1.0) * (lum * 0.13);
					oCol.w = col.w;
					return oCol;
				}
			ENDCG
		}
	}
}