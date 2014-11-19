Shader "Aubergine/Objects/NoLights/Flame" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		Tags { "Queue" = "Transparent" "RenderType"="Transparent" "IgnoreProjector"="True" }
		LOD 100
		Pass {
			Blend SrcAlpha OneMinusSrcAlpha
			ZWrite Off Lighting Off Fog { Mode Off }

			CGPROGRAM
				#pragma exclude_renderers flash
				#pragma fragmentoption ARB_precision_hint_fastest
				#pragma vertex vert
				#pragma fragment frag
				#include "UnityCG.cginc"

				sampler2D _MainTex;
				float4 _MainTex_ST;

				struct a2f {
					float4 vertex : POSITION;
					float4 texcoord : TEXCOORD0;
				};

				struct v2f {
					float4 Pos : SV_POSITION;
					float4 Uv : TEXCOORD0;
				};

				v2f vert (a2f v) {
					v2f o;
					o.Pos = mul(UNITY_MATRIX_MVP, v.vertex);
					o.Uv.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.Uv.zw = float2(0, _Time.y) / 50;
					return o;
				}

				half4 frag( v2f i ) : COLOR {
					half4 c = 0;
					half a = tex2D(_MainTex, i.Uv.xy).a;
					c.rgb += tex2D(_MainTex, 0.5*i.Uv.xy - i.Uv.zw).rgb;
					c.rgb += tex2D(_MainTex, 0.4*i.Uv.xy - i.Uv.zw).rgb;
					c.rgb += tex2D(_MainTex, 0.3*i.Uv.xy - i.Uv.zw).rgb;
					c.rgb += tex2D(_MainTex, 0.2*i.Uv.xy - i.Uv.zw).rgb;
					c.rgb += tex2D(_MainTex, 0.1*i.Uv.xy - i.Uv.zw).rgb;
					c.a = pow(a * c.rgb, 2);
					return c;
				}
			ENDCG
		}
	} 
	FallBack Off
}