Shader "Custom/SurfaceKaleidoscope" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		[PerRendererData]_reflectX("Reflect X",Int) = 1
		[PerRendererData]_reflectY("Reflect Y",Int) = 1
		[PerRendererData] _swapXY("Swap", Int) = 0
		_Centre("Centre", Vector) = (0,0,0)
		_InverseRotation("Inverse Rotation", Vector) = (0,0,0)
		_Rotation("Rotation", Vector) = (0,0,0)
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		Cull Off
		
		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows vertex:vert

		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
			float3 texcoord1;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;
		float4 _Centre;
		float4 _Rotation;
		float4 _InverseRotation;

		UNITY_INSTANCING_CBUFFER_START(InstanceProperties)
		UNITY_DEFINE_INSTANCED_PROP(int, _reflectX)
		UNITY_DEFINE_INSTANCED_PROP(int, _reflectY)
		UNITY_DEFINE_INSTANCED_PROP(int, _swapXY)
		UNITY_INSTANCING_CBUFFER_END

		float4 applyRotation(float4 sourcePos, float4 rotation) {
			float3 rotatedVert = sourcePos.xyz + 2.0 * cross(rotation.xyz, cross(rotation.xyz, sourcePos) + rotation.w * sourcePos.xyz);
			return float4(rotatedVert, 1);
		}

		void surf (Input IN, inout SurfaceOutputStandard o) {
			//clip(IN.texcoord1.x);
			//clip(IN.texcoord1.y - IN.texcoord1.x);
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}

		void vert(inout appdata_full v)
		{
			UNITY_SETUP_INSTANCE_ID(v);
			float4 reflectedVertex = applyRotation(mul(unity_ObjectToWorld, v.vertex) - _Centre, _InverseRotation);
			v.texcoord1 = reflectedVertex;
			//o.worldPos = reflectedVertex;
			//reflect around axis, 
			reflectedVertex.x = reflectedVertex.x *UNITY_ACCESS_INSTANCED_PROP(_reflectX);
			reflectedVertex.y = reflectedVertex.y *UNITY_ACCESS_INSTANCED_PROP(_reflectY);
			if (UNITY_ACCESS_INSTANCED_PROP(_swapXY))
			{
				float tempX = reflectedVertex.x;
				reflectedVertex.x = reflectedVertex.y;
				reflectedVertex.y = tempX;
				//v.normal = v.normal * -1;
			}
			//v.normal = v.normal * UNITY_ACCESS_INSTANCED_PROP(_reflectX);
			//v.normal = v.normal * UNITY_ACCESS_INSTANCED_PROP(_reflectY);
			v.vertex = mul(unity_WorldToObject, applyRotation(reflectedVertex, _Rotation) + _Centre);
		}
		ENDCG
	}
	FallBack "Diffuse"
}
