Shader "Aubergine/Objects/NoLights/ForceField" {
	Properties {
		_Color ("Main Color", Color) = (1, 1, 1, 1)
	}
	SubShader {
		Tags { "Queue" = "Transparent" "RenderType"="Transparent" "IgnoreProjector"="True" }
		LOD 100
		Pass {
			Blend SrcAlpha OneMinusSrcAlpha
			ZWrite Off Lighting Off Fog { Mode Off }
			Cull Off

			CGPROGRAM
				#pragma exclude_renderers flash
				#pragma fragmentoption ARB_precision_hint_fastest
				#pragma vertex vert
				#pragma fragment frag
				#include "UnityCG.cginc"

				fixed4 _Color;
				uniform float3 _CollisionPos0, _CollisionPos1, _CollisionPos2, _CollisionPos3;
				uniform float _CollisionTime0, _CollisionTime1, _CollisionTime2, _CollisionTime3;

				struct a2f {
					float4 vertex : POSITION;
					float4 texcoord : TEXCOORD0;
				};

				struct v2f {
					float4 Pos : SV_POSITION;
					float4 Dist : TEXCOORD1;
				};

				v2f vert (a2f v) {
					v2f o;
					o.Pos = mul(UNITY_MATRIX_MVP, v.vertex);
					o.Dist.x = distance(v.vertex.xyz, _CollisionPos0);
					o.Dist.y = distance(v.vertex.xyz, _CollisionPos1);
					o.Dist.z = distance(v.vertex.xyz, _CollisionPos2);
					o.Dist.w = distance(v.vertex.xyz, _CollisionPos3);
					return o;
				}

				fixed4 frag( v2f i ) : COLOR {
					//First Collision
					float x = i.Dist.x/0.5;
					float y = 1.0 - _CollisionTime0;
					float alpha = pow(2.71828183, (-1.0 * ((x-y) * (x-y))*100.0)) * (1.0-y);
					//Second Collision
					x = i.Dist.y/0.5;
					y = 1.0 - _CollisionTime1;
					alpha += pow(2.71828183, (-1.0 * ((x-y) * (x-y))*100.0)) * (1.0-y);
					//Third Collision
					x = i.Dist.z/0.5;
					y = 1.0 - _CollisionTime2;
					alpha += pow(2.71828183, (-1.0 * ((x-y) * (x-y))*100.0)) * (1.0-y);
					//Fourth Collision
					x = i.Dist.z/0.5;
					y = 1.0 - _CollisionTime3;
					alpha += pow(2.71828183, (-1.0 * ((x-y) * (x-y))*100.0)) * (1.0-y);

					fixed4 col = fixed4(_Color.rgb, alpha);
					return col;
				}
			ENDCG
		}
	} 
	FallBack Off
}