Shader "RO/RO_Blend_nofog" {
	Properties{
		_MainTex("Base (RGB) Trans (A)", 2D) = "white" {}
		_TintColor("Color", Color) = (0.5,0.5,0.5,1)
	}

		SubShader{
		Tags{ "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
		LOD 100

		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha

		Pass{
		CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 2.0
		//#pragma multi_compile_fog

#include "UnityCG.cginc"

		struct appdata_t {
		float4 vertex : POSITION;
		float2 texcoord : TEXCOORD0;
		//UNITY_VERTEX_INPUT_INSTANCE_ID
	};

	struct v2f {
		float4 vertex : SV_POSITION;
		float2 texcoord : TEXCOORD0;
		//UNITY_FOG_COORDS(1)
		//UNITY_VERTEX_OUTPUT_STEREO
	};

	sampler2D _MainTex;
	float4 _MainTex_ST;
	uniform float4 _TintColor;
	v2f vert(appdata_t v)
	{
		v2f o;
		//UNITY_SETUP_INSTANCE_ID(v);
		//UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
		o.vertex = UnityObjectToClipPos(v.vertex);
		o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
		//UNITY_TRANSFER_FOG(o,o.vertex);
		return o;
	}

	fixed4 frag(v2f i) : SV_Target
	{
		fixed4 col = tex2D(_MainTex, i.texcoord)*_TintColor;
	//UNITY_APPLY_FOG(i.fogCoord, col);
	return col;
	}
		ENDCG
	}
	}

}

//    Properties {
//        _MainTex ("MainTex", 2D) = "white" {}
//        _TintColor ("Color", Color) = (0.5,0.5,0.5,1)
//        _Alpha ("Alpha", Range(0, 1)) = 0
//        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
//    }
//    SubShader {
//        Tags {
//            "IgnoreProjector"="True"
//            "Queue"="Transparent"
//            "RenderType"="Transparent"
//        }
//        Pass {
//            Name "FORWARD"
//            Tags {
//                "LightMode"="ForwardBase"
//            }
//            Blend SrcAlpha OneMinusSrcAlpha
//            ZWrite Off
//            
//            CGPROGRAM
//            #pragma vertex vert
//            #pragma fragment frag
//            #define UNITY_PASS_FORWARDBASE
//            #include "UnityCG.cginc"
//            #pragma multi_compile_fwdbase
//            #pragma only_renderers d3d9 d3d11 glcore gles 
//            #pragma target 3.0
//            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
//            uniform float4 _TintColor;
//            uniform float _Alpha;
//            struct VertexInput {
//                float4 vertex : POSITION;
//                float2 texcoord0 : TEXCOORD0;
//            };
//            struct VertexOutput {
//                float4 pos : SV_POSITION;
//                float2 uv0 : TEXCOORD0;
//            };
//            VertexOutput vert (VertexInput v) {
//                VertexOutput o = (VertexOutput)0;
//                o.uv0 = v.texcoord0;
//                o.pos = UnityObjectToClipPos( v.vertex );
//                return o;
//            }
//            float4 frag(VertexOutput i) : COLOR {
//////// Lighting:
//////// Emissive:
//                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(i.uv0, _MainTex));
//                float3 emissive = (_MainTex_var.rgb*_TintColor.rgb);
//                float3 finalColor = emissive;
//				return fixed4(finalColor,  (_MainTex_var.a*_Alpha));
//            }
//            ENDCG
//        }
//    }
//    CustomEditor "ShaderForgeMaterialInspector"
//}
