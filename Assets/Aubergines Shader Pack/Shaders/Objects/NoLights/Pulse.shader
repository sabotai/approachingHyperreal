//If you dont want Color tint, just remove all _Color variables
//To gain some extra speed
Shader "Aubergine/Objects/NoLights/Pulse" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Color ("Main Color", Color) = (1, 1, 1, 1)
		_Speed ("Speed", Range(0.0, 10)) = 10
		_Amplitude ("Amplitude", Range(0.0, 0.9)) = 0.01
	}
	SubShader {
		Tags { "Queue" = "Geometry" "RenderType"="Opaque" }
		LOD 100
		Pass {
			Lighting Off Fog { Mode Off }

			CGPROGRAM
				#pragma exclude_renderers flash
				#pragma fragmentoption ARB_precision_hint_fastest
				#pragma vertex vert
				#pragma fragment frag
				#include "UnityCG.cginc"

				sampler2D _MainTex;
				float4 _MainTex_ST;
				fixed4 _Color;
				float _Speed, _Amplitude;

				struct a2f {
					float4 vertex : POSITION;
					float4 texcoord : TEXCOORD0;
				};

				struct v2f {
					float4 Pos : SV_POSITION;
					float2 Uv : TEXCOORD0;
				};

				v2f vert (a2f v) {
					v2f o;
					half3 pulse =  1.0 - (sin(_Time.y * _Speed)*_Amplitude + _Amplitude) * 0.5;
					float4 Po = float4(v.vertex.xyz, 1);
					Po *= half4(pulse, 1);
					o.Pos = mul(UNITY_MATRIX_MVP, Po);
					o.Uv = TRANSFORM_TEX(v.texcoord, _MainTex);
					return o;
				}

				fixed4 frag( v2f i ) : COLOR {
					fixed4 c = tex2D(_MainTex, i.Uv) * _Color;
					return c;
				}
			ENDCG
		}
	} 
	FallBack Off
}