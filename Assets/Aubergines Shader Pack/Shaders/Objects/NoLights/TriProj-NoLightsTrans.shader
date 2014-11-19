Shader "Aubergine/Objects/NoLights/TriProj-NoLightsTrans" {
	Properties {
		_MainTex ("MainTex (RGBA)", 2D) = "white" {}
	}
	SubShader {
		Tags { "Queue" = "Transparent" "RenderType"="Transparent" "IgnoreProjector"="True" }
		LOD 200
		Pass {
			Blend SrcAlpha OneMinusSrcAlpha
			ZWrite Off Lighting Off

			CGPROGRAM
				#pragma exclude_renderers flash
				#pragma fragmentoption ARB_precision_hint_fastest
				#pragma vertex vert
				#pragma fragment frag
				#include "UnityCG.cginc"

				sampler2D _MainTex;
				half4 _MainTex_ST;

				struct a2f {
					float4 vertex : POSITION;
					fixed3 normal : NORMAL;
				};

				struct v2f {
					float4 Pos : SV_POSITION;
					float3 PosW : TEXCOORD0;
					fixed3 Nor : TEXCOORD1;
				};

				v2f vert (a2f v) {
					v2f o;
					o.Pos = mul(UNITY_MATRIX_MVP, v.vertex);
					o.Nor = mul((float3x3)_Object2World, v.normal * unity_Scale.w);
					o.PosW = mul(_Object2World, v.vertex);
					return o;
				}

				fixed4 frag( v2f i ) : COLOR {
					//fixed3 bw = ((abs(i.Nor)) - 0.2) * 7;
					fixed3 bw = abs(i.Nor);
					bw = max(bw, 0);
					bw /= (bw.x + bw.y + bw.z).xxx;

					float2 uvx = (i.PosW.yz - _MainTex_ST.zw) * _MainTex_ST.xy;
					float2 uvy = (i.PosW.xz - _MainTex_ST.zw) * _MainTex_ST.xy;
					float2 uvz = (i.PosW.xy - _MainTex_ST.zw) * _MainTex_ST.xy;

					fixed4 c1 = tex2D(_MainTex, uvx);
					fixed4 c2 = tex2D(_MainTex, uvy);
					fixed4 c3 = tex2D(_MainTex, uvz);

					fixed4 col = (c1 * bw.xxxx) + (c2 * bw.yyyy) + (c3 * bw.zzzz);
					return col;
				}
			ENDCG
		}
	} 
	FallBack Off
}