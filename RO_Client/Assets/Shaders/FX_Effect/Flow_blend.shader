// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Shader created with Shader Forge v1.06 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.06;sub:START;pass:START;ps:flbk:,lico:1,lgpr:1,nrmq:1,limd:1,uamb:True,mssp:True,lmpd:False,lprd:False,rprd:False,enco:False,frtr:True,vitr:True,dbil:False,rmgx:True,rpth:0,hqsc:True,hqlp:False,tesm:0,blpr:1,bsrc:3,bdst:7,culm:2,dpts:2,wrdp:False,dith:0,ufog:True,aust:False,igpj:True,qofs:1,qpre:3,rntp:2,fgom:True,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0,fgcg:0,fgcb:0,fgca:1,fgde:0.01,fgrn:45,fgrf:100,ofsf:0,ofsu:0,f2p0:False;n:type:ShaderForge.SFN_Final,id:1,x:34900,y:32712,varname:node_1,prsc:2|emission-654-OUT,alpha-3636-OUT;n:type:ShaderForge.SFN_Tex2d,id:2,x:33753,y:32830,ptovrint:False,ptlb:E01,ptin:_E01,varname:node_2759,prsc:2,ntxv:0,isnm:False|UVIN-5228-OUT;n:type:ShaderForge.SFN_Tex2d,id:7,x:33176,y:32673,ptovrint:False,ptlb:DisE01,ptin:_DisE01,varname:node_67,prsc:2,tex:28c7aad1372ff114b90d330f8a2dd938,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Panner,id:15,x:32716,y:32770,varname:node_15,prsc:2,spu:1,spv:0|DIST-631-OUT;n:type:ShaderForge.SFN_Multiply,id:217,x:33415,y:32645,varname:node_217,prsc:2|A-589-OUT,B-7-R;n:type:ShaderForge.SFN_ValueProperty,id:589,x:33209,y:32564,ptovrint:False,ptlb:DisE01_value,ptin:_DisE01_value,varname:node_9185,prsc:2,glob:False,v1:0;n:type:ShaderForge.SFN_Time,id:630,x:32108,y:32778,varname:node_630,prsc:2;n:type:ShaderForge.SFN_Multiply,id:631,x:32499,y:32861,varname:node_631,prsc:2|A-4998-OUT,B-633-OUT;n:type:ShaderForge.SFN_ValueProperty,id:633,x:32346,y:33056,ptovrint:False,ptlb:E01_UVpan_Speed,ptin:_E01_UVpan_Speed,varname:node_6415,prsc:2,glob:False,v1:0;n:type:ShaderForge.SFN_Multiply,id:643,x:34150,y:33118,varname:node_643,prsc:2|A-647-R,B-1363-OUT;n:type:ShaderForge.SFN_Tex2d,id:647,x:33946,y:33101,ptovrint:False,ptlb:Alpha01,ptin:_Alpha01,varname:node_4168,prsc:2,tex:3a5a96df060a5cf4a9cc0c59e13486b7,ntxv:0,isnm:False;n:type:ShaderForge.SFN_VertexColor,id:653,x:34520,y:32850,varname:node_653,prsc:2;n:type:ShaderForge.SFN_Multiply,id:654,x:34704,y:32812,varname:node_654,prsc:2|A-669-OUT,B-653-RGB,C-653-A;n:type:ShaderForge.SFN_Multiply,id:659,x:34188,y:32810,varname:node_659,prsc:2|A-664-RGB,B-2-RGB;n:type:ShaderForge.SFN_Color,id:664,x:33982,y:32640,ptovrint:False,ptlb:E01_Color,ptin:_E01_Color,varname:node_5790,prsc:2,glob:False,c1:1,c2:1,c3:1,c4:1;n:type:ShaderForge.SFN_Multiply,id:669,x:34375,y:32810,varname:node_669,prsc:2|A-675-OUT,B-659-OUT;n:type:ShaderForge.SFN_ValueProperty,id:675,x:34243,y:32707,ptovrint:False,ptlb:E01_Bright,ptin:_E01_Bright,varname:node_9969,prsc:2,glob:False,v1:1;n:type:ShaderForge.SFN_Panner,id:4833,x:32716,y:32936,varname:node_4833,prsc:2,spu:0,spv:1|DIST-631-OUT;n:type:ShaderForge.SFN_SwitchProperty,id:7443,x:32906,y:32852,ptovrint:False,ptlb:E01_U/Vpan,ptin:_E01_UVpan,varname:node_7443,prsc:2,on:False|A-15-UVOUT,B-4833-UVOUT;n:type:ShaderForge.SFN_Rotator,id:2473,x:33364,y:32830,varname:node_2473,prsc:2|UVIN-7443-OUT,ANG-6805-OUT;n:type:ShaderForge.SFN_ValueProperty,id:5289,x:33061,y:33123,ptovrint:False,ptlb:E01_UVangle,ptin:_E01_UVangle,varname:node_5289,prsc:2,glob:False,v1:0;n:type:ShaderForge.SFN_Multiply,id:6805,x:33212,y:32943,varname:node_6805,prsc:2|A-6997-OUT,B-5289-OUT;n:type:ShaderForge.SFN_Pi,id:6997,x:33078,y:32943,varname:node_6997,prsc:2;n:type:ShaderForge.SFN_Add,id:5228,x:33577,y:32830,varname:node_5228,prsc:2|A-217-OUT,B-2473-UVOUT;n:type:ShaderForge.SFN_SwitchProperty,id:4998,x:32284,y:32798,ptovrint:False,ptlb:E01_UVpan_Time/VertexAlpha,ptin:_E01_UVpan_TimeVertexAlpha,varname:_E01_UVpan_copy,prsc:2,on:False|A-630-T,B-653-A;n:type:ShaderForge.SFN_ValueProperty,id:1363,x:33946,y:33295,ptovrint:False,ptlb:Alpha01_Bright,ptin:_Alpha01_Bright,varname:node_1363,prsc:2,glob:False,v1:1;n:type:ShaderForge.SFN_Multiply,id:3636,x:34704,y:32973,varname:node_3636,prsc:2|A-653-A,B-9767-OUT;n:type:ShaderForge.SFN_Multiply,id:9767,x:34320,y:33097,varname:node_9767,prsc:2|A-2-R,B-643-OUT;proporder:2-675-664-7443-5289-4998-633-7-589-647-1363;pass:END;sub:END;*/

Shader "yh/Flow_blend" {
    Properties {
        _E01 ("E01", 2D) = "white" {}
        _E01_Bright ("E01_Bright", Float ) = 1
        _E01_Color ("E01_Color", Color) = (1,1,1,1)
        [MaterialToggle] _E01_UVpan ("E01_U/Vpan", Float ) = 0
        _E01_UVangle ("E01_UVangle", Float ) = 0
        [MaterialToggle] _E01_UVpan_TimeVertexAlpha ("E01_UVpan_Time/VertexAlpha", Float ) = 0
        _E01_UVpan_Speed ("E01_UVpan_Speed", Float ) = 0
        _DisE01 ("DisE01", 2D) = "white" {}
        _DisE01_value ("DisE01_value", Float ) = 0
        _Alpha01 ("Alpha01", 2D) = "white" {}
        _Alpha01_Bright ("Alpha01_Bright", Float ) = 1
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent+1"
            "RenderType"="Transparent"
        }
        Pass {
            Name "ForwardBase"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend SrcAlpha OneMinusSrcAlpha
            Cull Off
            ZWrite Off
            
            Fog {Mode Global}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma exclude_renderers xbox360 ps3 flash d3d11_9x 
            #pragma target 3.0
            uniform float4 _TimeEditor;
            uniform sampler2D _E01; uniform float4 _E01_ST;
            uniform sampler2D _DisE01; uniform float4 _DisE01_ST;
            uniform float _DisE01_value;
            uniform float _E01_UVpan_Speed;
            uniform sampler2D _Alpha01; uniform float4 _Alpha01_ST;
            uniform float4 _E01_Color;
            uniform float _E01_Bright;
            uniform fixed _E01_UVpan;
            uniform float _E01_UVangle;
            uniform fixed _E01_UVpan_TimeVertexAlpha;
            uniform float _Alpha01_Bright;
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
////// Lighting:
////// Emissive:
                float4 _DisE01_var = tex2D(_DisE01,TRANSFORM_TEX(i.uv0, _DisE01));
                float node_2473_ang = (3.141592654*_E01_UVangle);
                float node_2473_spd = 1.0;
                float node_2473_cos = cos(node_2473_spd*node_2473_ang);
                float node_2473_sin = sin(node_2473_spd*node_2473_ang);
                float2 node_2473_piv = float2(0.5,0.5);
                float4 node_630 = _Time + _TimeEditor;
                float node_631 = (lerp( node_630.g, i.vertexColor.a, _E01_UVpan_TimeVertexAlpha )*_E01_UVpan_Speed);
                float2 node_2473 = (mul(lerp( (i.uv0+node_631*float2(1,0)), (i.uv0+node_631*float2(0,1)), _E01_UVpan )-node_2473_piv,float2x2( node_2473_cos, -node_2473_sin, node_2473_sin, node_2473_cos))+node_2473_piv);
                float2 node_5228 = ((_DisE01_value*_DisE01_var.r)+node_2473);
                float4 _E01_var = tex2D(_E01,TRANSFORM_TEX(node_5228, _E01));
                float3 emissive = ((_E01_Bright*(_E01_Color.rgb*_E01_var.rgb))*i.vertexColor.rgb*i.vertexColor.a);
                float3 finalColor = emissive;
                float4 _Alpha01_var = tex2D(_Alpha01,TRANSFORM_TEX(i.uv0, _Alpha01));
                return fixed4(finalColor,saturate(i.vertexColor.a*(_E01_var.r*(_Alpha01_var.r*_Alpha01_Bright))));
            }
            ENDCG
        }
    }
    //FallBack "Diffuse"
}
