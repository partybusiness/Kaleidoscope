Shader "Unlit/KaleidoscopeInstanced"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		[PerRendererData]_reflectX("Reflect X",Int) = 1
		[PerRendererData]_reflectY("Reflect Y",Int) = 1
		[PerRendererData] _swapXY("Swap", Int) = 0
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100
		Cull Off

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD0;
				float3 worldPos : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
		
			sampler2D _MainTex;
			float4 _MainTex_ST;			

			UNITY_INSTANCING_CBUFFER_START(InstanceProperties)
			UNITY_DEFINE_INSTANCED_PROP(int, _reflectX)
			UNITY_DEFINE_INSTANCED_PROP(int, _reflectY)
			UNITY_DEFINE_INSTANCED_PROP(int, _swapXY)
			UNITY_INSTANCING_CBUFFER_END

			v2f vert (appdata v)
			{
				UNITY_SETUP_INSTANCE_ID(v);
				v2f o;
				float4 reflectedVertex = mul(unity_ObjectToWorld, v.vertex);
				reflectedVertex.x = reflectedVertex.x *UNITY_ACCESS_INSTANCED_PROP(_reflectX);
				reflectedVertex.y = reflectedVertex.y *UNITY_ACCESS_INSTANCED_PROP(_reflectY);
				if (UNITY_ACCESS_INSTANCED_PROP(_swapXY))
				{
					float tempX = reflectedVertex.x;
					reflectedVertex.x = reflectedVertex.y;
					reflectedVertex.y = tempX;
				}
				o.vertex = UnityObjectToClipPos(mul (unity_WorldToObject, reflectedVertex));
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
				//UNITY_TRANSFER_INSTANCE_ID(v, o);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				//UNITY_SETUP_INSTANCE_ID(i);
				//fixed4 col = UNITY_ACCESS_INSTANCED_PROP(_Color);
				clip(i.worldPos.x);
				clip(i.worldPos.y - i.worldPos.x);
				fixed4 col = tex2D(_MainTex, i.uv);
				return col;
			}
			ENDCG
		}
	}
}