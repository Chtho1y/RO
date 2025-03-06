// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Shader created with Shader Forge v1.26 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.26;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,lico:0,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:False,mssp:False,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:0,bdst:1,dpts:2,wrdp:True,dith:0,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:False,qofs:0,qpre:2,rntp:3,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False;n:type:ShaderForge.SFN_Final,id:1642,x:33830,y:32949,varname:node_1642,prsc:2|emission-7868-OUT,clip-9110-OUT;n:type:ShaderForge.SFN_Tex2d,id:9734,x:33214,y:32617,ptovrint:False,ptlb:MainTex,ptin:_MainTex,varname:node_9734,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Tex2d,id:2835,x:32822,y:33460,ptovrint:False,ptlb:Mask,ptin:_Mask,varname:node_2835,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Color,id:605,x:33032,y:32813,ptovrint:False,ptlb:Color,ptin:_Color,varname:node_605,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_ValueProperty,id:3984,x:33032,y:33020,ptovrint:False,ptlb:Value,ptin:_Value,varname:node_3984,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_FragmentPosition,id:5280,x:32378,y:33389,varname:node_5280,prsc:2;n:type:ShaderForge.SFN_ValueProperty,id:1678,x:32390,y:33116,ptovrint:False,ptlb:Hight,ptin:_Hight,varname:node_1678,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Subtract,id:1183,x:32726,y:33263,varname:node_1183,prsc:2|A-1862-OUT,B-5280-Y;n:type:ShaderForge.SFN_Add,id:1862,x:32615,y:33116,varname:node_1862,prsc:2|A-1678-OUT,B-8126-Y;n:type:ShaderForge.SFN_ObjectPosition,id:8126,x:32378,y:33202,varname:node_8126,prsc:2;n:type:ShaderForge.SFN_Clamp01,id:9110,x:33234,y:33277,varname:node_9110,prsc:2|IN-9206-OUT;n:type:ShaderForge.SFN_Subtract,id:9206,x:33017,y:33277,varname:node_9206,prsc:2|A-1183-OUT,B-2835-R;n:type:ShaderForge.SFN_ChannelBlend,id:7868,x:33639,y:32712,varname:node_7868,prsc:2,chbt:1|M-7380-OUT,R-9734-RGB,BTM-3669-OUT;n:type:ShaderForge.SFN_Power,id:7380,x:33476,y:32996,varname:node_7380,prsc:2|VAL-9110-OUT,EXP-4710-OUT;n:type:ShaderForge.SFN_Multiply,id:3669,x:33394,y:32813,varname:node_3669,prsc:2|A-9734-RGB,B-2926-OUT;n:type:ShaderForge.SFN_OneMinus,id:2926,x:33214,y:32813,varname:node_2926,prsc:2|IN-605-RGB;n:type:ShaderForge.SFN_OneMinus,id:4710,x:33214,y:33020,varname:node_4710,prsc:2|IN-3984-OUT;proporder:9734-2835-605-3984-1678;pass:END;sub:END;*/

Shader "HZEffect/WYTest" {
    Properties {
        _MainTex ("MainTex", 2D) = "white" {}
        _Mask ("Mask", 2D) = "white" {}
        _Color ("Color", Color) = (0.5,0.5,0.5,1)
        _Value ("Value", Float ) = 1
        _Hight ("Hight", Float ) = 1
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "Queue"="AlphaTest"
            "RenderType"="TransparentCutout"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Cull Off
            
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma multi_compile_fog
            #pragma exclude_renderers xbox360 xboxone ps3 ps4 psp2 
            #pragma target 3.0
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
            uniform sampler2D _Mask; uniform float4 _Mask_ST;
            uniform float4 _Color;
            uniform float _Value;
            uniform float _Hight;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                UNITY_FOG_COORDS(2)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                float4 objPos = mul ( unity_ObjectToWorld, float4(0,0,0,1) );
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos(v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                float4 objPos = mul ( unity_ObjectToWorld, float4(0,0,0,1) );
                float4 _Mask_var = tex2D(_Mask,TRANSFORM_TEX(i.uv0, _Mask));
                float node_9110 = saturate((((_Hight+objPos.g)-i.posWorld.g)-_Mask_var.r));
                clip(node_9110 - 0.5);
////// Lighting:
////// Emissive:
                float node_7380 = pow(node_9110,(1.0 - _Value));
                float4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(i.uv0, _MainTex));
                float3 emissive = (lerp( (_MainTex_var.rgb*(1.0 - _Color.rgb)), _MainTex_var.rgb, node_7380.r ));
                float3 finalColor = emissive;
                fixed4 finalRGBA = fixed4(finalColor,1);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
        Pass {
            Name "ShadowCaster"
            Tags {
                "LightMode"="ShadowCaster"
            }
            Offset 1, 1
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_SHADOWCASTER
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma multi_compile_fog
            #pragma exclude_renderers xbox360 xboxone ps3 ps4 psp2 
            #pragma target 3.0
            uniform sampler2D _Mask; uniform float4 _Mask_ST;
            uniform float _Hight;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
                float2 uv0 : TEXCOORD1;
                float4 posWorld : TEXCOORD2;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                float4 objPos = mul ( unity_ObjectToWorld, float4(0,0,0,1) );
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos(v.vertex );
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                float4 objPos = mul ( unity_ObjectToWorld, float4(0,0,0,1) );
                float4 _Mask_var = tex2D(_Mask,TRANSFORM_TEX(i.uv0, _Mask));
                float node_9110 = saturate((((_Hight+objPos.g)-i.posWorld.g)-_Mask_var.r));
                clip(node_9110 - 0.5);
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    //FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
