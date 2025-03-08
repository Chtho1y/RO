// Upgrade NOTE: commented out 'float4 unity_LightmapST', a built-in variable
// Upgrade NOTE: commented out 'sampler2D unity_Lightmap', a built-in variable
// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'
// Upgrade NOTE: replaced tex2D unity_Lightmap with UNITY_SAMPLE_TEX2D

Shader "Scene/Light_VertexLit/AlphaTest_Diffuse" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
	_AlphaTex ("千万不要填，系统用的", 2D) = "white" {}
	_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
}

SubShader {
	Tags {"Queue"="Geometry" "IgnoreProjector"="True" "RenderType"="Opaque"} 
	LOD 200
	AlphaTest Off
	
	Pass{
		Tags { LightMode = Vertex } 
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma multi_compile _DUMMY _FOG_OF_WAR_ON _FOG_OF_WAR_ON_LOW
		#pragma multi_compile _DUMMY _SEPERATE_ALPHA_TEX_ON


		#include "UnityCG.cginc"
		struct v2f {
			float4 pos : SV_POSITION;
			float2 uv0 : TEXCOORD0;
			float2 uvLM : TEXCOORD1;
			};
			
		struct appdata_lightmap {
			float4 vertex : POSITION;
			float2 texcoord : TEXCOORD0; 
			float2 texcoord1 : TEXCOORD1;
		};
		
		sampler2D _MainTex;
		float4 _MainTex_ST;
		fixed4 _Color;
		fixed _Cutoff;
		v2f vert(appdata_lightmap i) {
			v2f o;
			o.pos = UnityObjectToClipPos(i.vertex);
			o.uv0 = TRANSFORM_TEX(i.texcoord, _MainTex);
			o.uvLM = i.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
			return o;
		}

		fixed4 frag(v2f i) : COLOR {
			fixed4 color = tex2D(_MainTex, i.uv0) * _Color;
			clip(color.a - _Cutoff);
			color.rgb *= DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, i.uvLM));
			return color;
		}
		ENDCG
	}
	
	
	Pass{
		Tags { LightMode = VertexLM } 
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma multi_compile _DUMMY _FOG_OF_WAR_ON _FOG_OF_WAR_ON_LOW
		#pragma multi_compile _DUMMY _SEPERATE_ALPHA_TEX_ON


		#include "UnityCG.cginc"
		struct v2f {
			float4 pos : SV_POSITION;
			float2 uv0 : TEXCOORD0;
			float2 uvLM : TEXCOORD1;
			};
			
		struct appdata_lightmap {
			float4 vertex : POSITION;
			float2 texcoord : TEXCOORD0; 
			float2 texcoord1 : TEXCOORD1;
		};
		
		sampler2D _MainTex;
		float4 _MainTex_ST;
		fixed4 _Color;
		fixed _Cutoff;
		v2f vert(appdata_lightmap i) {
			v2f o;
			o.pos = UnityObjectToClipPos(i.vertex);
			o.uv0 = TRANSFORM_TEX(i.texcoord, _MainTex);
			o.uvLM = i.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
			return o;
		}

		fixed4 frag(v2f i) : COLOR {
			fixed4 color = tex2D(_MainTex, i.uv0) * _Color;
			clip(color.a - _Cutoff);
			color.rgb *= DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, i.uvLM));
			return color;
		}
		ENDCG
	}

	Pass{
		Tags { LightMode = VertexLMRGBM } 
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#pragma multi_compile _DUMMY _FOG_OF_WAR_ON _FOG_OF_WAR_ON_LOW
		#pragma multi_compile _DUMMY _SEPERATE_ALPHA_TEX_ON


		#include "UnityCG.cginc"
		struct v2f {
			float4 pos : SV_POSITION;
			float2 uv0 : TEXCOORD0;
			float2 uvLM : TEXCOORD1;
			};
			
		struct appdata_lightmap {
			float4 vertex : POSITION;
			float2 texcoord : TEXCOORD0; 
			float2 texcoord1 : TEXCOORD1;
		};
		
		sampler2D _MainTex;
		float4 _MainTex_ST;
		fixed4 _Color;
		fixed _Cutoff;
		v2f vert(appdata_lightmap i) {
			v2f o;
			o.pos = UnityObjectToClipPos(i.vertex);
			o.uv0 = TRANSFORM_TEX(i.texcoord, _MainTex);
			o.uvLM = i.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
			return o;
		}

		fixed4 frag(v2f i) : COLOR {
			fixed4 color = tex2D(_MainTex, i.uv0) * _Color;
			clip(color.a - _Cutoff);
			color.rgb *= DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, i.uvLM));
			return color;
		}
		ENDCG
	}
}

////FallBack "Transparent/Cutout/VertexLit"
}
