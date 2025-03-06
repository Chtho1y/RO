Shader "RO/RO_Unlit_nofog" {
	Properties{
		_node_7185("node_7185", 2D) = "white" {}
	_Cutoff("Alpha cutoff", Range(0,1)) = 0.5

	}

		SubShader{
		Tags{ "Queue" = "AlphaTest" "IgnoreProjector" = "True" "RenderType" = "TransparentCutout" }
		LOD 200
		Cull Off
		CGPROGRAM
#pragma surface surf NoLighting nofog

		sampler2D _node_7185;
	fixed _Cutoff;


	struct Input {
		float2 uv_node_7185;
	};



	void surf(Input IN, inout SurfaceOutput o) {
		fixed4 c = tex2D(_node_7185,IN.uv_node_7185);
		clip(c.a - _Cutoff);
		o.Albedo = c.rgb;
		o.Alpha = 1;
	}

	fixed4 LightingNoLighting(SurfaceOutput s, fixed3 lightDir, fixed atten)
	{
		fixed4 c;
		c.rgb = s.Albedo;
		c.a = 1;
		return c;
	}
	ENDCG
	}

		//FallBack "Legacy Shaders/Transparent/Cutout/VertexLit"
}


//// Shader created with Shader Forge v1.38 
//// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
//// Note: Manually altering this data may prevent you from opening it in Shader Forge
///*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:False,aust:True,igpj:False,qofs:0,qpre:2,rntp:3,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:3138,x:32719,y:32712,varname:node_3138,prsc:2|emission-7185-RGB,clip-7185-A;n:type:ShaderForge.SFN_Tex2d,id:7185,x:32417,y:32977,ptovrint:False,ptlb:node_7185,ptin:_node_7185,varname:node_7185,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;proporder:7185;pass:END;sub:END;*/
//
//Shader "RO/RO_Unlit_nofog" {
//    Properties {
//        _node_7185 ("node_7185", 2D) = "white" {}
//        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
//    }
//    SubShader {
//        Tags {
//            "Queue"="AlphaTest"
//            "RenderType"="TransparentCutout"
//        }
//        Pass {
//            Name "FORWARD"
//            Tags {
//                "LightMode"="ForwardBase"
//            }
//            
//            
//            CGPROGRAM
//            #pragma vertex vert
//            #pragma fragment frag
//            #define UNITY_PASS_FORWARDBASE
//            #include "UnityCG.cginc"
//            #pragma multi_compile_fwdbase_fullshadows
//            #pragma only_renderers d3d9 d3d11 glcore gles metal 
//            #pragma target 3.0
//            uniform sampler2D _node_7185; uniform float4 _node_7185_ST;
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
//                float4 _node_7185_var = tex2D(_node_7185,TRANSFORM_TEX(i.uv0, _node_7185));
//                clip(_node_7185_var.a - 0.5);
//////// Lighting:
//////// Emissive:
//                float3 emissive = _node_7185_var.rgb;
//                float3 finalColor = emissive;
//                return fixed4(finalColor,1);
//            }
//            ENDCG
//        }
//        Pass {
//            Name "ShadowCaster"
//            Tags {
//                "LightMode"="ShadowCaster"
//            }
//            Offset 1, 1
//            Cull Back
//            
//            CGPROGRAM
//            #pragma vertex vert
//            #pragma fragment frag
//            #define UNITY_PASS_SHADOWCASTER
//            #include "UnityCG.cginc"
//            #include "Lighting.cginc"
//            #pragma fragmentoption ARB_precision_hint_fastest
//            #pragma multi_compile_shadowcaster
//            #pragma only_renderers d3d9 d3d11 glcore gles metal 
//            #pragma target 3.0
//            uniform sampler2D _node_7185; uniform float4 _node_7185_ST;
//            struct VertexInput {
//                float4 vertex : POSITION;
//                float2 texcoord0 : TEXCOORD0;
//            };
//            struct VertexOutput {
//                V2F_SHADOW_CASTER;
//                float2 uv0 : TEXCOORD1;
//            };
//            VertexOutput vert (VertexInput v) {
//                VertexOutput o = (VertexOutput)0;
//                o.uv0 = v.texcoord0;
//                o.pos = UnityObjectToClipPos( v.vertex );
//                TRANSFER_SHADOW_CASTER(o)
//                return o;
//            }
//            float4 frag(VertexOutput i) : COLOR {
//                float4 _node_7185_var = tex2D(_node_7185,TRANSFORM_TEX(i.uv0, _node_7185));
//                clip(_node_7185_var.a - 0.5);
//                SHADOW_CASTER_FRAGMENT(i)
//            }
//            ENDCG
//        }
//    }
//    //FallBack "Diffuse"
//    CustomEditor "ShaderForgeMaterialInspector"
//}
