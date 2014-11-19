Shader "Aubergine/Objects/NoLights/InteriorV2" {
	Properties {
		_WallTex ("Walls Texture", 2D) = "white" {}
		_InteriorTex ("Cubemap", CUBE) = "" {}
		_InteriorTex2 ("Cubemap", CUBE) = "" {}
		_WallTiles ("Amount of windows", Float) = 2
		_WallDarkness ("Outer wall darkness", Range (0,1)) = 0.2
		_LightenedRooms ("Lightened room amount", Range (0,1)) = 0.5
		//Below should be same value as _WallDarkness in general
		_LightAmount ("Dark Rooms Light Amount", Range (0,1)) = 0.14
		_WindowAlpha ("Outer window alpha", Range (0,1)) = 0.4
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		Pass {
			//Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM
			#include "UnityCG.cginc"
			#pragma vertex vert
			#pragma fragment frag
			
			sampler2D _WallTex;
			samplerCUBE _InteriorTex, _InteriorTex2;
			float _WallTiles, _WallDarkness, _LightenedRooms, _LightAmount, _WindowAlpha;

			struct a2v {
				float4 vertex : POSITION;
				float3 tangent : TANGENT;
			};

			struct v2f {
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				float3 dir : TEXCOORD1;
			};
			v2f vert (a2v v) {
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				
				//Everything in World Space
				float3 tan0 = mul(float3x3(_Object2World), float3(v.tangent.x, 0, -v.tangent.z));
				float3 tan1 = mul(float3x3(_Object2World), float3(-v.tangent.z, 0, v.tangent.x));
				
				float4 position = mul(_Object2World, v.vertex);
				position.xyz *= _WallTiles;
				
				//World space UVs
				o.uv.x = dot(position.xyz, tan0);
				o.uv.y = -position.y;

				float3 d = position.xyz / _WallTiles - _WorldSpaceCameraPos;
				o.dir.x = dot(d, tan0);
				o.dir.y = d.y;
				o.dir.z = dot(d, tan1);
				return o;
			}
			
			half4 frag( v2f i ) : COLOR {
				float2 f = frac(i.uv);
				//Simple random for turning lights on and off
				float2 r = floor(i.uv) * float2(0.6789, 0.7834) + float2(0.4156, 0.7342);
				float index = frac(r.x + r.y + r.x * r.y) * 8.0;
				//Enter pos
				float4 p = float4(f * float2(2.0, -2.0) - float2(1.0, -1.0), -1.0, index);
				//Ray intersection
				float3 id = 1.0 / i.dir;
				float3 k = abs(id) - p * id;
				float kMin = min(min(k.x, k.y), k.z);
				p.xyz += kMin * i.dir;
				//Sampler
				float4 interior1 = texCUBE(_InteriorTex, p);
				float4 interior2 = texCUBE(_InteriorTex2, p);
				float4 interior = (frac(index/2.0) < 0.5) ? interior1 : interior2;
				//Light variation, Incase your cubemap has alpha as well
				float light = interior.a * (1.0 + frac(5.29 * index));
				//Turn some lights off
				interior.rgb *= (frac(index) < _LightenedRooms) ? light : _LightAmount;
				//Outer Walls
				float4 wall = tex2D(_WallTex, i.uv);
				wall.rgb *= _WallDarkness;
				wall.a = saturate(wall.a + _WindowAlpha);
				return lerp(interior, wall, wall.a);
			}
			ENDCG
		}
	}
}