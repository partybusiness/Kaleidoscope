Shader "Unlit/Kaleidoscope"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100
		

		CGINCLUDE
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
				float3 worldPos : TEXCOORD1;
			};

			fixed4 frag(v2f i) : SV_Target
			{
				clip(i.worldPos.x);
				clip(i.worldPos.y - i.worldPos.x);
				fixed4 col = tex2D(_MainTex, i.uv);
				return col;
			}

			v2f vertGeneral(appdata v, int _reflectX, int _reflectY, bool _swapXY)
			{
				v2f o;
				float4 reflectedVertex = mul(unity_ObjectToWorld, v.vertex);
				reflectedVertex.x = reflectedVertex.x *_reflectX;
				reflectedVertex.y = reflectedVertex.y *_reflectY;
				if (_swapXY)
				{
					float tempX = reflectedVertex.x;
					reflectedVertex.x = reflectedVertex.y;
					reflectedVertex.y = tempX;
				}
				o.vertex = UnityObjectToClipPos(mul(unity_WorldToObject, reflectedVertex));
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
				return o;
			}
		// Shared code goes here
		ENDCG
			Cull Back
			Pass
			{
				CGPROGRAM
				v2f vert (appdata v)
				{
					return vertGeneral(v, 1, 1, false);
				}
				ENDCG
			}
			Pass
			{
				CGPROGRAM
					v2f vert(appdata v)
				{
					return vertGeneral(v, -1, -1, false);
				}
				ENDCG
			}
				Pass
			{
				CGPROGRAM
					v2f vert(appdata v)
				{
					return vertGeneral(v, -1, 1, true);
				}
				ENDCG
			}
				Pass
			{
				CGPROGRAM
					v2f vert(appdata v)
				{
					return vertGeneral(v, 1, -1, true);
				}
				ENDCG
			}
			Cull Front
			Pass
			{
				CGPROGRAM
					v2f vert(appdata v)
				{
					return vertGeneral(v, 1, 1, true);
				}
				ENDCG
			}
			Pass
			{
				CGPROGRAM
					v2f vert(appdata v)
				{
					return vertGeneral(v, -1, -1, true);
				}
				ENDCG
			}
			Pass
			{
				CGPROGRAM
					v2f vert(appdata v)
				{
					return vertGeneral(v, -1, 1, false);
				}
				ENDCG
			}
			Pass
			{
				CGPROGRAM
					v2f vert(appdata v)
				{
					return vertGeneral(v, 1, -1, false);
				}
				ENDCG
			}
			
			
			
			
	}
}