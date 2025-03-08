// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Hero/Unlit_TilingOffset"{
	Properties{
		_Color("Color",Color) = (1,1,1,1)
		_MainTex("Main Tex",2D) = "white"{}
		//_Cutoff("Alpha cutoff", Range(0,1)) = 0.5
	}

	SubShader{
		Pass{
			Tags{"Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent"}
			Blend SrcAlpha OneMinusSrcAlpha
			//Cull[_Cull] Lighting Off ZWrite Off

			CGPROGRAM
			#include "Lighting.cginc"								
			#pragma vertex vert										
			#pragma fragment frag
			fixed4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;	//名字固定_MainTex+_ST
			//fixed _Cutoff;

			struct a2v {
				float4 vertex:POSITION;
				float3 normal:NORMAL;
				float4 textcoord:TEXCOORD0;
			};

			struct v2f {
				float4 svPos:SV_POSITION;
				float3 worldNormal:TEXCOORD0;
				float4 worldVertex:TEXCOORD1;
				float2 uv:TEXCOORD2;
			};

			v2f vert(a2v v) {
				v2f f;
				f.svPos = UnityObjectToClipPos(v.vertex);
				f.worldNormal = UnityObjectToWorldNormal(v.normal);
				f.worldVertex = mul(v.vertex, unity_WorldToObject);
				f.uv = v.textcoord.xy *_MainTex_ST.xy + _MainTex_ST.zw;					//zw为偏移，+-设置旋转方向,xy为缩放
				return f;
			}

			fixed4 frag(v2f f) :SV_Target {
				fixed4 texColor = tex2D(_MainTex,f.uv.xy);
				fixed3 diffuse = texColor.rgb * _Color.rgb;
				return fixed4(diffuse, texColor.a);
			}
			ENDCG
		}
	}
	//FallBack "Specular"
}
