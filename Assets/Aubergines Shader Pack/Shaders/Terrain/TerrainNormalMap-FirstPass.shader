Shader "Hidden/TerrainEngine/Splatmap/Lightmap-FirstPass" {
	Properties {
		_Control ("Control (RGBA)", 2D) = "red" {}
		_Splat3 ("Layer 3 (A)", 2D) = "white" {}
		_Splat2 ("Layer 2 (B)", 2D) = "white" {}
		_Splat1 ("Layer 1 (G)", 2D) = "white" {}
		_Splat0 ("Layer 0 (R)", 2D) = "white" {}
		// used in fallback on old cards
		_MainTex ("BaseMap (RGB)", 2D) = "white" {}
		_Color ("Main Color", Color) = (1,1,1,1)
		
		_SpecColor ("Specular Color", Color) = (1.0, 0.5, 0.5, 1)
	}

	SubShader {
		Tags { "SplatCount" = "4" "Queue" = "Geometry-100" "RenderType" = "Opaque" }
		CGPROGRAM
			#pragma surface surf BlinnPhong vertex:vert
			#pragma target 3.0
			#include "UnityCG.cginc"

			struct Input {
				float2 uv_Control : TEXCOORD0;
				float2 uv_Splat0 : TEXCOORD1;
				float2 uv_Splat1 : TEXCOORD2;
				float2 uv_Splat2 : TEXCOORD3;
				float2 uv_Splat3 : TEXCOORD4;
				float3 worldPos;
				float3 wNormal;
			};

			void vert (inout appdata_full v, out Input o) {
				float3 B = cross(float3(1, 0, 1), v.normal);
				float3 T = normalize(cross(v.normal, B));
				v.tangent.xyz = T.xyz;
				if (dot(cross(v.normal, T), B) < 0) v.tangent.w = -1.0f;
				else v.tangent.w = 1.0f;
				o.wNormal = mul((float3x3)_Object2World, v.normal * unity_Scale.w);
			}

			sampler2D _Control;
			sampler2D _Splat0,_Splat1,_Splat2,_Splat3;
			sampler2D _Bump0, _Bump1, _Bump2, _Bump3;
			half4 _SpecColTerrain;
			float _SpecPow0, _SpecPow1, _SpecPow2, _SpecPow3;
			float _TileScaleX0, _TileScaleZ0;
			float _TileScaleX1,  _TileScaleZ1;
			float _TileScaleX2, _TileScaleZ2;
			float _TileScaleX3, _TileScaleZ3;

			void surf (Input IN, inout SurfaceOutput o) {
				fixed3 bw = max(abs(IN.wNormal), 0);
				bw /= (bw.x + bw.y + bw.z).xxx;

				half4 splat_control = tex2D (_Control, IN.uv_Control);
				half3 col, norm;
				half glosandspec;
				_SpecColor = _SpecColTerrain;

				float2 uvx = IN.worldPos.yz;
				float2 uvy = IN.worldPos.xz;
				float2 uvz = IN.worldPos.xy;

				float2 uvScale = float2(_TileScaleX0, _TileScaleZ0);
				fixed3 c1 = splat_control.r * tex2D(_Splat0, uvx / uvScale).rgb;
				fixed3 c2 = splat_control.r * tex2D(_Splat0, uvy / uvScale).rgb;
				fixed3 c3 = splat_control.r * tex2D(_Splat0, uvz / uvScale).rgb;
				col = (c1 * bw.xxx) + (c2 * bw.yyy) + (c3 * bw.zzz);
				fixed3 b1 = splat_control.r * UnpackNormal(tex2D(_Bump0, uvx / uvScale));
				fixed3 b2 = splat_control.r * UnpackNormal(tex2D(_Bump0, uvy / uvScale));
				fixed3 b3 = splat_control.r * UnpackNormal(tex2D(_Bump0, uvz / uvScale));
				norm = (b1 * bw.xxx) + (b2 * bw.yyy) + (b3 * bw.zzz);
				
				uvScale = float2(_TileScaleX1, _TileScaleZ1);
				c1 = splat_control.g * tex2D(_Splat1, uvx / uvScale).rgb;
				c2 = splat_control.g * tex2D(_Splat1, uvy / uvScale).rgb;
				c3 = splat_control.g * tex2D(_Splat1, uvz / uvScale).rgb;
				col += (c1 * bw.xxx) + (c2 * bw.yyy) + (c3 * bw.zzz);
				b1 = splat_control.g * UnpackNormal(tex2D(_Bump1, uvx / uvScale));
				b2 = splat_control.g * UnpackNormal(tex2D(_Bump1, uvy / uvScale));
				b3 = splat_control.g * UnpackNormal(tex2D(_Bump1, uvz / uvScale));
				norm += (b1 * bw.xxx) + (b2 * bw.yyy) + (b3 * bw.zzz);
				
				uvScale = float2(_TileScaleX2, _TileScaleZ2);
				c1 = splat_control.b * tex2D(_Splat2, uvx / uvScale).rgb;
				c2 = splat_control.b * tex2D(_Splat2, uvy / uvScale).rgb;
				c3 = splat_control.b * tex2D(_Splat2, uvz / uvScale).rgb;
				col += (c1 * bw.xxx) + (c2 * bw.yyy) + (c3 * bw.zzz);
				b1 = splat_control.b * UnpackNormal(tex2D(_Bump2, uvx / uvScale));
				b2 = splat_control.b * UnpackNormal(tex2D(_Bump2, uvy / uvScale));
				b3 = splat_control.b * UnpackNormal(tex2D(_Bump2, uvz / uvScale));
				norm += (b1 * bw.xxx) + (b2 * bw.yyy) + (b3 * bw.zzz);

				uvScale = float2(_TileScaleX3, _TileScaleZ3);
				c1 = splat_control.a * tex2D(_Splat3, uvx / uvScale).rgb;
				c2 = splat_control.a * tex2D(_Splat3, uvy / uvScale).rgb;
				c3 = splat_control.a * tex2D(_Splat3, uvz / uvScale).rgb;
				col += (c1 * bw.xxx) + (c2 * bw.yyy) + (c3 * bw.zzz);
				b1 = splat_control.a * UnpackNormal(tex2D(_Bump3, uvx / uvScale));
				b2 = splat_control.a * UnpackNormal(tex2D(_Bump3, uvy / uvScale));
				b3 = splat_control.a * UnpackNormal(tex2D(_Bump3, uvz / uvScale));
				norm += (b1 * bw.xxx) + (b2 * bw.yyy) + (b3 * bw.zzz);
				glosandspec = (_SpecPow0 * splat_control.r) + (_SpecPow1 * splat_control.g);
				glosandspec += (_SpecPow2 * splat_control.b) + (_SpecPow3 * splat_control.a);

				o.Albedo = col;
				o.Normal = norm;
				o.Gloss = glosandspec;
				o.Specular = glosandspec;
				o.Alpha = 0.0;
			}
		ENDCG  
	}
	Fallback "Diffuse"
}