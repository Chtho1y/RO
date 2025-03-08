// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "RO/RimEdgeGlow" 
{
		Properties{
			_MainTex("Base (RGB)", 2D) = "white" {}
			_RimColor("Rim Color",COLOR) = (1,1,1,1)
			_Scale("Scale",range(1,8)) = 2
			_Outer("Outer",range(0,1)) = 0.2
		}

		SubShader
		{
			Tags { "RenderType" = "Opaque" "queue" = "Transparent"}
			LOD 300

			//=================卡通渲染PASS======================
			Pass {
				blend srcalpha one
				zwrite off

				CGPROGRAM

				#pragma vertex vert  
				#pragma fragment frag  

				#include "UnityCG.cginc"  
				float4 _RimColor;
				float _Scale;
				float _Outer;

			   struct a2v {
				   float4 vertex : POSITION;
				   float3 normal : NORMAL;
				   float4 texcoord : TEXCOORD0;
			   };

			   struct v2f {
				   float4 pos : POSITION;
				   float3 normal:TEXCOORD0;
				   float4 vertex:TEXCOORD1;
			   };

			   v2f vert(a2v v) {

				   v.vertex.xyz += v.normal*_Outer;

				   v2f o;
				   o.pos = UnityObjectToClipPos(v.vertex);

				   o.vertex = v.vertex;
				   o.normal = v.normal;
				   return o;
			   }

			   fixed4 frag(v2f i) : COLOR {
				   float3 N = UnityObjectToWorldNormal(i.normal);
				   float3 V = normalize(WorldSpaceViewDir(i.vertex));
				   float bright = pow(saturate(dot(N,V)),_Scale);

				   _RimColor.a *= bright;
				   return _RimColor;
			   }

			   ENDCG
			}

			//========================================
			Pass  {
				Tags { "LightMode" = "ForwardBase" }
				//blend one one // 当前都不渲染
				//zwrite off

				CGPROGRAM

				#pragma vertex vert  
				#pragma fragment frag  

				#include "UnityCG.cginc"  
			   //只有点乘在frag做

			   float4 _RimColor;
			   float _Scale;
			   sampler2D _MainTex;

			  struct a2v {
				  float4 vertex : POSITION;
				  float3 normal : NORMAL;
				  float4 texcoord : TEXCOORD0;
			  };

			  struct v2f {
				  float4 pos : POSITION;
				  float2 uv0 : TEXCOORD0;
			  };

			  v2f vert(a2v v) {
				  v2f o;
				  o.pos = UnityObjectToClipPos(v.vertex);
				  o.uv0 = v.texcoord;
				  return o;
			  }

			  fixed4 frag(v2f i) : COLOR {	
				  fixed4 clr = tex2D(_MainTex, i.uv0.xy);
				  return clr;
			  }

			ENDCG
		}
	}
	//FallBack "Diffuse"
}