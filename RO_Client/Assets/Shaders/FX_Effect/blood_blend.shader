// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Shader created with Shader Forge v1.05 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.05;sub:START;pass:START;ps:flbk:,lico:1,lgpr:1,nrmq:1,limd:0,uamb:True,mssp:True,lmpd:False,lprd:False,rprd:False,enco:False,frtr:True,vitr:True,dbil:False,rmgx:True,rpth:0,hqsc:True,hqlp:False,tesm:0,blpr:0,bsrc:0,bdst:1,culm:2,dpts:2,wrdp:True,dith:0,ufog:True,aust:False,igpj:False,qofs:1,qpre:2,rntp:3,fgom:True,fgoc:False,fgod:False,fgor:True,fgmd:0,fgcr:0,fgcg:0,fgcb:0,fgca:1,fgde:0.01,fgrn:45,fgrf:100,ofsf:0,ofsu:0,f2p0:False;n:type:ShaderForge.SFN_Final,id:1,x:34814,y:32535,varname:node_1,prsc:2|emission-654-OUT,clip-700-OUT;n:type:ShaderForge.SFN_Tex2d,id:2,x:33740,y:32516,ptovrint:False,ptlb:T01,ptin:_T01,varname:_Tex01,prsc:2,tex:b66bceaf0cc0ace4e9bdc92f14bba709,ntxv:0,isnm:False|UVIN-6291-UVOUT;n:type:ShaderForge.SFN_Tex2d,id:7,x:33013,y:32474,ptovrint:False,ptlb:DisT01,ptin:_DisT01,varname:_DisTex01,prsc:2,tex:28c7aad1372ff114b90d330f8a2dd938,ntxv:0,isnm:False|UVIN-7564-OUT;n:type:ShaderForge.SFN_Panner,id:15,x:32643,y:32419,varname:node_15,prsc:2,spu:1,spv:0|DIST-631-OUT;n:type:ShaderForge.SFN_Multiply,id:217,x:33221,y:32411,varname:node_217,prsc:2|A-589-OUT,B-7-R;n:type:ShaderForge.SFN_TexCoord,id:496,x:33221,y:32536,varname:node_496,prsc:2,uv:0;n:type:ShaderForge.SFN_Add,id:554,x:33383,y:32516,varname:node_554,prsc:2|A-217-OUT,B-496-UVOUT;n:type:ShaderForge.SFN_ValueProperty,id:589,x:33013,y:32389,ptovrint:False,ptlb:Value_DisT01,ptin:_Value_DisT01,varname:_Power_DisTex01,prsc:2,glob:False,v1:0.2;n:type:ShaderForge.SFN_Time,id:630,x:32325,y:32400,varname:node_630,prsc:2;n:type:ShaderForge.SFN_Multiply,id:631,x:32482,y:32478,varname:node_631,prsc:2|A-630-T,B-633-OUT;n:type:ShaderForge.SFN_ValueProperty,id:633,x:32302,y:32603,ptovrint:False,ptlb:Speed_DisT01,ptin:_Speed_DisT01,varname:_PanV_DisTex01,prsc:2,glob:False,v1:1;n:type:ShaderForge.SFN_Multiply,id:643,x:33993,y:32990,varname:node_643,prsc:2|A-2-R,B-647-R;n:type:ShaderForge.SFN_Tex2d,id:647,x:33753,y:32990,ptovrint:False,ptlb:Mask,ptin:_Mask,varname:_mask,prsc:2,tex:3a5a96df060a5cf4a9cc0c59e13486b7,ntxv:0,isnm:False;n:type:ShaderForge.SFN_VertexColor,id:653,x:34384,y:32673,varname:node_653,prsc:2;n:type:ShaderForge.SFN_Multiply,id:654,x:34588,y:32635,varname:node_654,prsc:2|A-808-OUT,B-653-RGB;n:type:ShaderForge.SFN_Multiply,id:669,x:34384,y:32894,varname:node_669,prsc:2|A-6901-OUT,B-643-OUT;n:type:ShaderForge.SFN_ValueProperty,id:675,x:33968,y:32815,ptovrint:False,ptlb:Value_Mask,ptin:_Value_Mask,varname:_Intensity_alpha,prsc:2,glob:False,v1:1;n:type:ShaderForge.SFN_Multiply,id:700,x:34556,y:32842,varname:node_700,prsc:2|A-653-A,B-669-OUT;n:type:ShaderForge.SFN_Add,id:808,x:34221,y:32500,varname:node_808,prsc:2|A-6959-OUT,B-4165-OUT;n:type:ShaderForge.SFN_Panner,id:2098,x:32643,y:32582,varname:node_2098,prsc:2,spu:0,spv:1|DIST-631-OUT;n:type:ShaderForge.SFN_SwitchProperty,id:7564,x:32823,y:32491,ptovrint:False,ptlb:U/V_Pan,ptin:_UV_Pan,varname:node_7564,prsc:2,on:False|A-15-UVOUT,B-2098-UVOUT;n:type:ShaderForge.SFN_Rotator,id:6291,x:33564,y:32516,varname:node_6291,prsc:2|UVIN-554-OUT,ANG-5125-OUT;n:type:ShaderForge.SFN_ValueProperty,id:1375,x:33316,y:32893,ptovrint:False,ptlb:UVangle_T01,ptin:_UVangle_T01,varname:node_1375,prsc:2,glob:False,v1:0;n:type:ShaderForge.SFN_Multiply,id:4165,x:33981,y:32521,varname:node_4165,prsc:2|A-9284-RGB,B-2-RGB;n:type:ShaderForge.SFN_Color,id:9284,x:33830,y:32349,ptovrint:False,ptlb:Color_T01,ptin:_Color_T01,varname:node_9284,prsc:2,glob:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Vector1,id:4845,x:33968,y:32733,varname:node_4845,prsc:2,v1:1;n:type:ShaderForge.SFN_Add,id:6901,x:34178,y:32733,varname:node_6901,prsc:2|A-4845-OUT,B-675-OUT;n:type:ShaderForge.SFN_Slider,id:6959,x:34022,y:32420,ptovrint:False,ptlb:Value_T01,ptin:_Value_T01,varname:node_6959,prsc:2,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Pi,id:8487,x:33332,y:32722,varname:node_8487,prsc:2;n:type:ShaderForge.SFN_Multiply,id:5125,x:33462,y:32761,varname:node_5125,prsc:2|A-8487-OUT,B-1375-OUT;proporder:6959-2-9284-1375-7-589-633-7564-647-675;pass:END;sub:END;*/

Shader "yh/blood_blend" {
    Properties {
        _Value_T01 ("Value_T01", Range(0, 1)) = 0
        _T01 ("T01", 2D) = "white" {}
        _Color_T01 ("Color_T01", Color) = (1,1,1,1)
        _UVangle_T01 ("UVangle_T01", Float ) = 0
        _DisT01 ("DisT01", 2D) = "white" {}
        _Value_DisT01 ("Value_DisT01", Float ) = 0.2
        _Speed_DisT01 ("Speed_DisT01", Float ) = 1
        [MaterialToggle] _UV_Pan ("U/V_Pan", Float ) = 0
        _Mask ("Mask", 2D) = "white" {}
        _Value_Mask ("Value_Mask", Float ) = 1
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "Queue"="AlphaTest+1"
            "RenderType"="TransparentCutout"
        }
        Pass {
            Name "ForwardBase"
            Tags {
                "LightMode"="ForwardBase"
            }
            Cull Off
            
            
            Fog {Mode Global}
            Fog {Range 45,100}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma exclude_renderers xbox360 ps3 flash d3d11_9x 
            #pragma target 3.0
            uniform float4 _TimeEditor;
            uniform sampler2D _T01; uniform float4 _T01_ST;
            uniform sampler2D _DisT01; uniform float4 _DisT01_ST;
            uniform float _Value_DisT01;
            uniform float _Speed_DisT01;
            uniform sampler2D _Mask; uniform float4 _Mask_ST;
            uniform float _Value_Mask;
            uniform fixed _UV_Pan;
            uniform float _UVangle_T01;
            uniform float4 _Color_T01;
            uniform float _Value_T01;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.vertexColor = v.vertexColor;
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
/////// Vectors:
                float node_6291_ang = (3.141592654*_UVangle_T01);
                float node_6291_spd = 1.0;
                float node_6291_cos = cos(node_6291_spd*node_6291_ang);
                float node_6291_sin = sin(node_6291_spd*node_6291_ang);
                float2 node_6291_piv = float2(0.5,0.5);
                float4 node_630 = _Time + _TimeEditor;
                float node_631 = (node_630.g*_Speed_DisT01);
                float2 _UV_Pan_var = lerp( (i.uv0+node_631*float2(1,0)), (i.uv0+node_631*float2(0,1)), _UV_Pan );
                float4 _DisT01_var = tex2D(_DisT01,TRANSFORM_TEX(_UV_Pan_var, _DisT01));
                float2 node_6291 = (mul(((_Value_DisT01*_DisT01_var.r)+i.uv0)-node_6291_piv,float2x2( node_6291_cos, -node_6291_sin, node_6291_sin, node_6291_cos))+node_6291_piv);
                float4 _T01_var = tex2D(_T01,TRANSFORM_TEX(node_6291, _T01));
                float4 _Mask_var = tex2D(_Mask,TRANSFORM_TEX(i.uv0, _Mask));
                clip((i.vertexColor.a*((1.0+_Value_Mask)*(_T01_var.r*_Mask_var.r))) - 0.5);
////// Lighting:
////// Emissive:
                float3 emissive = ((_Value_T01+(_Color_T01.rgb*_T01_var.rgb))*i.vertexColor.rgb);
                float3 finalColor = emissive;
                return fixed4(finalColor,1);
            }
            ENDCG
        }
        Pass {
            Name "ShadowCollector"
            Tags {
                "LightMode"="ShadowCollector"
            }
            Cull Off
            
            Fog {Mode Off}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_SHADOWCOLLECTOR
            #define SHADOW_COLLECTOR_PASS
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcollector
            #pragma exclude_renderers xbox360 ps3 flash d3d11_9x 
            #pragma target 3.0
            uniform float4 _TimeEditor;
            uniform sampler2D _T01; uniform float4 _T01_ST;
            uniform sampler2D _DisT01; uniform float4 _DisT01_ST;
            uniform float _Value_DisT01;
            uniform float _Speed_DisT01;
            uniform sampler2D _Mask; uniform float4 _Mask_ST;
            uniform float _Value_Mask;
            uniform fixed _UV_Pan;
            uniform float _UVangle_T01;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };
            struct VertexOutput {
                V2F_SHADOW_COLLECTOR;
                float2 uv0 : TEXCOORD5;
                float4 vertexColor : COLOR;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.vertexColor = v.vertexColor;
                o.pos = UnityObjectToClipPos(v.vertex);
                TRANSFER_SHADOW_COLLECTOR(o)
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
/////// Vectors:
                float node_6291_ang = (3.141592654*_UVangle_T01);
                float node_6291_spd = 1.0;
                float node_6291_cos = cos(node_6291_spd*node_6291_ang);
                float node_6291_sin = sin(node_6291_spd*node_6291_ang);
                float2 node_6291_piv = float2(0.5,0.5);
                float4 node_630 = _Time + _TimeEditor;
                float node_631 = (node_630.g*_Speed_DisT01);
                float2 _UV_Pan_var = lerp( (i.uv0+node_631*float2(1,0)), (i.uv0+node_631*float2(0,1)), _UV_Pan );
                float4 _DisT01_var = tex2D(_DisT01,TRANSFORM_TEX(_UV_Pan_var, _DisT01));
                float2 node_6291 = (mul(((_Value_DisT01*_DisT01_var.r)+i.uv0)-node_6291_piv,float2x2( node_6291_cos, -node_6291_sin, node_6291_sin, node_6291_cos))+node_6291_piv);
                float4 _T01_var = tex2D(_T01,TRANSFORM_TEX(node_6291, _T01));
                float4 _Mask_var = tex2D(_Mask,TRANSFORM_TEX(i.uv0, _Mask));
                clip((i.vertexColor.a*((1.0+_Value_Mask)*(_T01_var.r*_Mask_var.r))) - 0.5);
                SHADOW_COLLECTOR_FRAGMENT(i)
            }
            ENDCG
        }
        Pass {
            Name "ShadowCaster"
            Tags {
                "LightMode"="ShadowCaster"
            }
            Cull Off
            Offset 1, 1
            
            Fog {Mode Off}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_SHADOWCASTER
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma exclude_renderers xbox360 ps3 flash d3d11_9x 
            #pragma target 3.0
            uniform float4 _TimeEditor;
            uniform sampler2D _T01; uniform float4 _T01_ST;
            uniform sampler2D _DisT01; uniform float4 _DisT01_ST;
            uniform float _Value_DisT01;
            uniform float _Speed_DisT01;
            uniform sampler2D _Mask; uniform float4 _Mask_ST;
            uniform float _Value_Mask;
            uniform fixed _UV_Pan;
            uniform float _UVangle_T01;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
                float2 uv0 : TEXCOORD1;
                float4 vertexColor : COLOR;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.vertexColor = v.vertexColor;
                o.pos = UnityObjectToClipPos(v.vertex);
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
/////// Vectors:
                float node_6291_ang = (3.141592654*_UVangle_T01);
                float node_6291_spd = 1.0;
                float node_6291_cos = cos(node_6291_spd*node_6291_ang);
                float node_6291_sin = sin(node_6291_spd*node_6291_ang);
                float2 node_6291_piv = float2(0.5,0.5);
                float4 node_630 = _Time + _TimeEditor;
                float node_631 = (node_630.g*_Speed_DisT01);
                float2 _UV_Pan_var = lerp( (i.uv0+node_631*float2(1,0)), (i.uv0+node_631*float2(0,1)), _UV_Pan );
                float4 _DisT01_var = tex2D(_DisT01,TRANSFORM_TEX(_UV_Pan_var, _DisT01));
                float2 node_6291 = (mul(((_Value_DisT01*_DisT01_var.r)+i.uv0)-node_6291_piv,float2x2( node_6291_cos, -node_6291_sin, node_6291_sin, node_6291_cos))+node_6291_piv);
                float4 _T01_var = tex2D(_T01,TRANSFORM_TEX(node_6291, _T01));
                float4 _Mask_var = tex2D(_Mask,TRANSFORM_TEX(i.uv0, _Mask));
                clip((i.vertexColor.a*((1.0+_Value_Mask)*(_T01_var.r*_Mask_var.r))) - 0.5);
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    //FallBack "Diffuse"
}
