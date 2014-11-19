Shader "Aubergine/Objects/Surf/TriProjLocal-BumpedDiffuse" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_BumpMap ("Normalmap", 2D) = "bump" {}
	}
	SubShader {
		Tags { "Queue" = "Geometry" "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
			#include "../../Includes/Aubergine_Lights.cginc"
			#pragma exclude_renderers flash
			#pragma surface surf Aub_Lambert vertex:vert
			#pragma target 3.0

			sampler2D _MainTex, _BumpMap;
			float4 _MainTex_ST;

			struct Input {
				float3 PosL;
				float3 NorL;
			};

			void vert (inout appdata_full v, out Input o) {
				o.PosL = v.vertex.xyz;
				o.NorL = v.normal;
			}

			void surf (Input IN, inout SurfaceOutput o) {
				//fixed3 bw = ((abs(IN.NorL)) - 0.2) * 7;
				fixed3 bw = abs(IN.NorL);
				bw = max(bw, 0);
				bw /= (bw.x + bw.y + bw.z).xxx;

				float2 uvx = (IN.PosL.yz - _MainTex_ST.zw) * _MainTex_ST.xy;
				float2 uvy = (IN.PosL.xz - _MainTex_ST.zw) * _MainTex_ST.xy;
				float2 uvz = (IN.PosL.xy - _MainTex_ST.zw) * _MainTex_ST.xy;

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
				o.Alpha = col.a;
				o.Normal = bump;
			}
		ENDCG
	} 
	FallBack "Diffuse"
}