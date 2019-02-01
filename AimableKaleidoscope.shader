Shader "Unlit/AimableKaleidoscope"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_Centre("Centre", Vector) = (0,0,0)
		_InverseRotation("Inverse Rotation", Vector) = (0,0,0)
		_Rotation("Rotation", Vector) = (0,0,0)
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
			float4 _Centre;
			float4 _Rotation;
			float4 _InverseRotation;

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

			float4 applyRotation(float4 sourcePos, float4 rotation) {
				float3 rotatedVert = sourcePos.xyz + 2.0 * cross(rotation.xyz, cross(rotation.xyz, sourcePos) + rotation.w * sourcePos.xyz);
				return float4(rotatedVert,1);
			}

			v2f vertGeneral(appdata v, int _reflectX, int _reflectY, bool _swapXY)
			{
				v2f o;
				float4 reflectedVertex = applyRotation(mul(unity_ObjectToWorld, v.vertex)- _Centre, _InverseRotation);
				o.worldPos = reflectedVertex;
				//reflect around axis, 
				reflectedVertex.x = reflectedVertex.x *_reflectX;
				reflectedVertex.y = reflectedVertex.y *_reflectY;
				if (_swapXY)
				{
					float tempX = reflectedVertex.x;
					reflectedVertex.x = reflectedVertex.y;
					reflectedVertex.y = tempX;
				}
				o.vertex = UnityObjectToClipPos(mul(unity_WorldToObject, applyRotation(reflectedVertex,_Rotation)+ _Centre));
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
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