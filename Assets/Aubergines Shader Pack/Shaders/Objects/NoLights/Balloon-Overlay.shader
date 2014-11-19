Shader "Aubergine/Objects/NoLights/Balloon-Overlay" {
	Properties {
		_Color ("Main Color", Color) = (1, 1, 1, 1)
		_Amount ("Baloon Amount", Range(0.0, 0.1)) = 0.1
		_Cutoff ("Alpha Cutoff", Range(0.0, 5.0)) = 2.5
	}
	SubShader {
		Tags { "Queue" = "Overlay" "RenderType"="Transparent" "IgnoreProjector"="True" }
		LOD 100
		Pass {
			Blend SrcAlpha OneMinusSrcAlpha
			ZWrite Off Lighting Off Fog { Mode Off }
			ZTest Always

			CGPROGRAM
				#pragma exclude_renderers flash
				#pragma fragmentoption ARB_precision_hint_fastest
				#pragma vertex vert
				#pragma fragment frag
				#include "UnityCG.cginc"

				fixed4 _Color;
				fixed _Amount, _Cutoff;

				struct a2f {
					float4 vertex : POSITION;
					fixed3 normal : NORMAL;
				};

				struct v2f {
					float4 Pos : SV_POSITION;
					fixed3 NorW : TEXCOORD0;
					half3 VieW : TEXCOORD1;
				};

				v2f vert (a2f v) {
					v2f o;
					//o.NorW = mul((float3x3)_World2Object, v.normal);
					o.NorW = mul((float3x3)_Object2World, v.normal * unity_Scale.w);
					float4 Po = v.vertex;
					Po += (_Amount * normalize(fixed4(v.normal.xyz, 0)));
					o.VieW = _WorldSpaceCameraPos.xyz - mul(_Object2World, Po);
					o.Pos = mul(UNITY_MATRIX_MVP, Po);
					return o;
				}

				fixed4 frag( v2f i ) : COLOR {
					fixed3 Nn = normalize(i.NorW);
					fixed3 Vn = normalize(i.VieW);
					fixed edge = 1.0 - dot(Vn, Nn);
					edge = pow(edge, _Cutoff);
					fixed3 res = edge * _Color.rgb;
					return fixed4(res, edge);
				}
			ENDCG
		}
	} 
	FallBack Off
}