Shader "Aubergine/Objects/Surf/TriProj-BumpedDiffuseSpec" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_BumpMap ("Normalmap", 2D) = "bump" {}
		_SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 1)
		_Shininess ("Shininess", Range (0.03, 1)) = 0.078125
	}
	SubShader {
		Tags { "Queue" = "Geometry" "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
			#include "../../Includes/Aubergine_Lights.cginc"
			#pragma exclude_renderers flash
			#pragma surface surf Aub_Blinn vertex:vert
			#pragma target 3.0

			sampler2D _MainTex, _BumpMap;
			float4 _MainTex_ST;
			half _Shininess;

			struct Input {
				float3 worldPos;
				float3 wNormal;
			};

			void vert (inout appdata_full v, out Input o) {
				o.wNormal = mul((float3x3)_Object2World, v.normal * unity_Scale.w);
			}

			void surf (Input IN, inout SurfaceOutput o) {
				//fixed3 bw = ((abs(IN.wNormal)) - 0.2) * 7;
				fixed3 bw = abs(IN.wNormal);
				bw = max(bw, 0);
				bw /= (bw.x + bw.y + bw.z).xxx;

				float2 uvx = (IN.worldPos.yz - _MainTex_ST.zw) * _MainTex_ST.xy;
				float2 uvy = (IN.worldPos.xz - _MainTex_ST.zw) * _MainTex_ST.xy;
				float2 uvz = (IN.worldPos.xy - _MainTex_ST.zw) * _MainTex_ST.xy;

				fixed4 c1 = tex2D(_MainTex, uvx);
				fixed4 c2 = tex2D(_MainTex, uvy);
				fixed4 c3 = tex2D(_MainTex, uvz);
				fixed4 col = (c1 * bw.xxxx) + (c2 * bw.yyyy) + (c3 * bw.zzzz);

				//IF TARGETING MOBILE USE BELOW
				//AND
				//REMOVE #PRAGMA TARGET 3.0
				//BEWARE IT WILL BE SLOW
				/*
				fixed3 b1 = tex2D(_BumpMap, uvx).xyz * 2 - 1;
				fixed3 b2 = tex2D(_BumpMap, uvy).xyz * 2 - 1;
				fixed3 b3 = tex2D(_BumpMap, uvz).xyz * 2 - 1;
				fixed3 bump = (b1 * bw.xxx) + (b2 * bw.yyy) + (b3 * bw.zzz);
				*/

				//IF TARGETING MOBILE, REMOVE BELOW
				fixed3 b1 = UnpackNormal(tex2D(_BumpMap, uvx));
				fixed3 b2 = UnpackNormal(tex2D(_BumpMap, uvy));
				fixed3 b3 = UnpackNormal(tex2D(_BumpMap, uvz));
				fixed3 bump = (b1 * bw.xxx) + (b2 * bw.yyy) + (b3 * bw.zzz);
				//UNTIL HERE

				o.Albedo = col.rgb;
				o.Gloss = col.a;
				o.Alpha = col.a;
				o.Specular = _Shininess;
				o.Normal = bump;
			}
		ENDCG
	} 
	FallBack "Diffuse"
}