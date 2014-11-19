Shader "Aubergine/Objects/NoLights/Cardio" {
	Properties {
		_Rate ("Rate", Float) = 15.0
		_Speed ("Speed", Float) = 3.0
		_Amplitude ("Amplitude", Range(0.0, 1.0)) = 0.1
		_Color ("Color", COLOR) = (0.6, 0.7, 0.8, 1.0)
		_Thickness ("Line Thickness", Float) = 16.0
		_Offset ("Line Offset", Range(0.0, 1.0)) = 0.0
	}
	SubShader {
		Tags { "Queue" = "Transparent" "RenderType"="Transparent" "IgnoreProjector"="True" }
		LOD 200
		Pass {
			//Blend one one gives a glowing effect if theres a bright color behind
			//Blend One One
			Blend SrcAlpha OneMinusSrcAlpha
			ZWrite Off Lighting Off Fog { Mode Off }

			CGPROGRAM
				#pragma exclude_renderers flash
				#pragma fragmentoption ARB_precision_hint_fastest
				#pragma vertex vert
				#pragma fragment frag
				#include "UnityCG.cginc"
			
				struct a2f {
					float4 vertex : POSITION;
					float4 texcoord : TEXCOORD0;
				};

				struct v2f {
					float4 Pos : SV_POSITION;
					float2 Uv : TEXCOORD0;
				};

				float _Rate, _Speed, _Amplitude, _Thickness, _Offset;
				fixed4 _Color;

				v2f vert (a2f v) {
					v2f o;
					o.Pos = mul(UNITY_MATRIX_MVP, v.vertex);
					o.Uv = v.texcoord.xy;
					return o;
				}

				fixed4 frag( v2f i ) : COLOR {
					float2 p = -1.0 + 2.0 * i.Uv;
					half x = _Speed * _Time.y + _Rate * p.x;
					half base = (1.0 + cos(x*2.5 + _Time.y)) * (1.0 + sin(x*3.5 + _Time.y));
					half z = frac(0.05*x);
					z = max(z, 1.0-z);
					z = pow(z, 10.0);
					float pulse = exp(-10000.0 * z);
					fixed4 c = pow(clamp(1.0-abs(p.y-(_Amplitude*base+pulse-_Offset)), 0.0, 1.0), _Thickness) * _Color;
					return c;
				}
			ENDCG
		}
	} 
	FallBack Off
}