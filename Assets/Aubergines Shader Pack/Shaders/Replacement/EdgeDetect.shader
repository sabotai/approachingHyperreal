Shader "Aubergine/Replacement/EdgeDetect" {
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
				half2 uv[3] : TEXCOORD0;
			};

			v2f vert (a2v v) {
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				half2 tUV = v.texcoord.xy;
				o.uv[0] = tUV;
				o.uv[1] = tUV + float2(-0.005, -0.005);
				o.uv[2] = tUV + float2(0.005, -0.005);
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
					half4 col = tex2D(_MainTex, i.uv[0]);

					half3 p1 = col.rgb;
					half3 p2 = tex2D( _MainTex, i.uv[1] ).rgb;
					half3 p3 = tex2D( _MainTex, i.uv[2] ).rgb;

					half3 diff = p1 * 2 - p2 - p3;
					half len = dot(diff,diff);
					if( len >= 0.001f )
						col.rgb = 0;
						
					return col;
				}
			ENDCG
		}
	}
}