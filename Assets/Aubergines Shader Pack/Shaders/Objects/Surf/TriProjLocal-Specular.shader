Shader "Aubergine/Objects/Surf/TriProjLocal-Specular" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 1)
		_Shininess ("Shininess", Range (0.01, 1)) = 0.078125
	}
	SubShader {
		Tags { "Queue" = "Geometry" "RenderType"="Opaque" }
		LOD 300

		CGPROGRAM
			#include "../../Includes/Aubergine_Lights.cginc"
			#pragma exclude_renderers flash
			#pragma surface surf Aub_Blinn vertex:vert

			sampler2D _MainTex;
			float4 _MainTex_ST;
			half _Shininess;

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

				o.Albedo = col.rgb;
				o.Gloss = col.a;
				o.Alpha = col.a;
				o.Specular = _Shininess;
			}
		ENDCG
	} 
	FallBack "Specular"
}