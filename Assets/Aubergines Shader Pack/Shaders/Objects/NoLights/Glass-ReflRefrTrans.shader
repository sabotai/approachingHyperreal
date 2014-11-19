Shader "Aubergine/Objects/NoLights/Glass-ReflRefrTrans" {
	Properties {
		_Color ("Main Color", Color) = (1, 1, 1, 1)
		_ReflTex ("Reflection Texture", Cube) = "" {}
		_Amount ("Reflection Amount", Range(0.0, 1.0)) = 0.5
		_Distortion ("Refraction Amount", Range(0.0, 1.0)) = 0.99
	}
	SubShader {
		Tags { "Queue" = "Transparent" "RenderType"="Transparent" "IgnoreProjector"="True" }
		LOD 200
		Pass {
			Blend SrcAlpha OneMinusSrcAlpha
			ZWrite Off Lighting Off Fog { Mode Off }

			CGPROGRAM
				#pragma exclude_renderers flash
				#pragma fragmentoption ARB_precision_hint_fastest
				#pragma vertex vert
				#pragma fragment frag
				#include "UnityCG.cginc"

				fixed4 _Color;
				fixed _Amount, _Distortion;
				samplerCUBE _ReflTex;

				struct a2f {
					float4 vertex : POSITION;
					fixed3 normal : NORMAL;
				};

				struct v2f {
					float4 Pos : SV_POSITION;
					fixed3 Refl : TEXCOORD0;
					fixed3 Refr : TEXCOORD1;
				};

				v2f vert (a2f v) {
					v2f o;
					o.Pos = mul(UNITY_MATRIX_MVP, v.vertex);
					float3 vDir = -WorldSpaceViewDir(v.vertex);
					//vDir.x *= -1.0;
					o.Refl = reflect(vDir, v.normal);
					o.Refr = refract(vDir, v.normal, _Distortion);
					return o;
				}

				fixed4 frag( v2f i ) : COLOR {
					fixed3 reflC = texCUBE(_ReflTex, i.Refl).rgb;
					fixed3 refrC = texCUBE(_ReflTex, i.Refr).rgb;
					fixed3 c = lerp(reflC, refrC, _Amount) * _Color.rgb;
					return fixed4(c.rgb, _Color.a);
				}
			ENDCG
		}
	} 
	FallBack Off
}