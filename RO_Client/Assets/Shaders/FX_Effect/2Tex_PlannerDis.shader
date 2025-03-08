// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Shader created with Shader Forge v1.06 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.06;sub:START;pass:START;ps:flbk:,lico:1,lgpr:1,nrmq:1,limd:1,uamb:True,mssp:True,lmpd:False,lprd:False,rprd:False,enco:False,frtr:True,vitr:True,dbil:False,rmgx:True,rpth:0,hqsc:True,hqlp:False,tesm:0,blpr:5,bsrc:2,bdst:0,culm:2,dpts:2,wrdp:False,dith:0,ufog:False,aust:False,igpj:False,qofs:1,qpre:3,rntp:2,fgom:True,fgoc:True,fgod:False,fgor:False,fgmd:0,fgcr:0.5882353,fgcg:0.8977687,fgcb:1,fgca:1,fgde:0.01,fgrn:20,fgrf:30,ofsf:0,ofsu:0,f2p0:False;n:type:ShaderForge.SFN_Final,id:5720,x:32725,y:32718,varname:node_5720,prsc:2|emission-6136-OUT,alpha-1191-A;n:type:ShaderForge.SFN_Tex2d,id:4431,x:31573,y:32710,ptovrint:False,ptlb:Tex01,ptin:_Tex01,varname:node_4431,prsc:2,ntxv:2,isnm:False|UVIN-2921-UVOUT;n:type:ShaderForge.SFN_Add,id:6224,x:29866,y:32808,varname:node_6224,prsc:2|A-4573-OUT,B-5483-UVOUT;n:type:ShaderForge.SFN_Panner,id:9819,x:30272,y:32782,varname:node_9819,prsc:2,spu:0,spv:1|UVIN-6224-OUT,DIST-4562-OUT;n:type:ShaderForge.SFN_TexCoord,id:5483,x:29437,y:32929,varname:node_5483,prsc:2,uv:0;n:type:ShaderForge.SFN_Tex2d,id:7300,x:29238,y:32549,ptovrint:False,ptlb:DisTex01,ptin:_DisTex01,varname:_node_4431_copy,prsc:2,ntxv:0,isnm:False|UVIN-197-UVOUT;n:type:ShaderForge.SFN_Multiply,id:4573,x:29482,y:32737,varname:node_4573,prsc:2|A-7300-RGB,B-2430-OUT;n:type:ShaderForge.SFN_ValueProperty,id:2430,x:29259,y:32881,ptovrint:False,ptlb:Power_DisTex01,ptin:_Power_DisTex01,varname:node_2430,prsc:2,glob:False,v1:0;n:type:ShaderForge.SFN_TexCoord,id:7901,x:28852,y:32549,varname:node_7901,prsc:2,uv:0;n:type:ShaderForge.SFN_Panner,id:197,x:29028,y:32549,varname:node_197,prsc:2,spu:0,spv:1|UVIN-7901-UVOUT,DIST-77-OUT;n:type:ShaderForge.SFN_Time,id:1988,x:29627,y:33142,varname:node_1988,prsc:2;n:type:ShaderForge.SFN_Multiply,id:4562,x:29840,y:33060,varname:node_4562,prsc:2|A-1988-T,B-8376-OUT;n:type:ShaderForge.SFN_ValueProperty,id:8376,x:29644,y:33290,ptovrint:False,ptlb:PanV_Tex01,ptin:_PanV_Tex01,varname:node_8376,prsc:2,glob:False,v1:0;n:type:ShaderForge.SFN_Time,id:4964,x:28639,y:32785,varname:node_4964,prsc:2;n:type:ShaderForge.SFN_Multiply,id:77,x:28852,y:32785,varname:node_77,prsc:2|A-4964-T,B-733-OUT;n:type:ShaderForge.SFN_ValueProperty,id:733,x:28639,y:32957,ptovrint:False,ptlb:PanV_DisTex01,ptin:_PanV_DisTex01,varname:_PanV_Tex02,prsc:2,glob:False,v1:0;n:type:ShaderForge.SFN_TexCoord,id:5507,x:29972,y:33860,varname:node_5507,prsc:2,uv:0;n:type:ShaderForge.SFN_Tex2d,id:5732,x:31562,y:33366,ptovrint:False,ptlb:Tex02,ptin:_Tex02,varname:_Tex02,prsc:2,ntxv:0,isnm:False|UVIN-1670-UVOUT;n:type:ShaderForge.SFN_Add,id:1968,x:30557,y:33808,varname:node_1968,prsc:2|A-4790-OUT,B-5507-UVOUT;n:type:ShaderForge.SFN_Panner,id:5310,x:30762,y:33921,varname:node_5310,prsc:2,spu:0,spv:1|UVIN-1968-OUT,DIST-2522-OUT;n:type:ShaderForge.SFN_Tex2d,id:1705,x:29714,y:33534,ptovrint:False,ptlb:DisTex02,ptin:_DisTex02,varname:_DisTex02,prsc:2,ntxv:0,isnm:False|UVIN-6181-UVOUT;n:type:ShaderForge.SFN_Multiply,id:4790,x:29947,y:33618,varname:node_4790,prsc:2|A-1705-RGB,B-9026-OUT;n:type:ShaderForge.SFN_ValueProperty,id:9026,x:29714,y:33767,ptovrint:False,ptlb:Power_DisTex02,ptin:_Power_DisTex02,varname:_Power_DisTex02,prsc:2,glob:False,v1:0;n:type:ShaderForge.SFN_TexCoord,id:6296,x:29352,y:33570,varname:node_6296,prsc:2,uv:0;n:type:ShaderForge.SFN_Panner,id:6181,x:29528,y:33570,varname:node_6181,prsc:2,spu:0,spv:1|UVIN-6296-UVOUT,DIST-560-OUT;n:type:ShaderForge.SFN_Time,id:1802,x:29729,y:34223,varname:node_1802,prsc:2;n:type:ShaderForge.SFN_Multiply,id:2522,x:29942,y:34141,varname:node_2522,prsc:2|A-1802-T,B-6092-OUT;n:type:ShaderForge.SFN_Time,id:9992,x:29139,y:33806,varname:node_9992,prsc:2;n:type:ShaderForge.SFN_Multiply,id:560,x:29352,y:33806,varname:node_560,prsc:2|A-9992-T,B-2300-OUT;n:type:ShaderForge.SFN_ValueProperty,id:2300,x:29139,y:33978,ptovrint:False,ptlb:PanV_DisTex02,ptin:_PanV_DisTex02,varname:_PanV_DisTex03,prsc:2,glob:False,v1:0;n:type:ShaderForge.SFN_Add,id:2414,x:31704,y:33066,varname:node_2414,prsc:2|A-5599-OUT,B-1303-OUT;n:type:ShaderForge.SFN_Multiply,id:1794,x:32288,y:32805,varname:node_1794,prsc:2|A-7909-OUT,B-5803-OUT;n:type:ShaderForge.SFN_ValueProperty,id:7909,x:32135,y:32729,ptovrint:False,ptlb:InstensityA,ptin:_InstensityA,varname:node_7909,prsc:2,glob:False,v1:1;n:type:ShaderForge.SFN_VertexColor,id:1191,x:32359,y:33003,varname:node_1191,prsc:2;n:type:ShaderForge.SFN_Multiply,id:6136,x:32477,y:32805,varname:node_6136,prsc:2|A-1794-OUT,B-1191-RGB;n:type:ShaderForge.SFN_Multiply,id:5599,x:31805,y:32605,varname:node_5599,prsc:2|A-8196-RGB,B-4431-RGB;n:type:ShaderForge.SFN_Multiply,id:1303,x:31765,y:33412,varname:node_1303,prsc:2|A-5732-RGB,B-6233-RGB;n:type:ShaderForge.SFN_ValueProperty,id:6092,x:29729,y:34402,ptovrint:False,ptlb:Panv_Tex02,ptin:_Panv_Tex02,varname:node_6092,prsc:2,glob:False,v1:0;n:type:ShaderForge.SFN_Color,id:8196,x:31559,y:32507,ptovrint:False,ptlb:Color_Tex01,ptin:_Color_Tex01,varname:node_8196,prsc:2,glob:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Color,id:6233,x:31821,y:33710,ptovrint:False,ptlb:Color_Tex02,ptin:_Color_Tex02,varname:node_6233,prsc:2,glob:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_Tex2d,id:4833,x:32013,y:33108,ptovrint:False,ptlb:Mask_Tex,ptin:_Mask_Tex,varname:node_4833,prsc:2,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Multiply,id:5803,x:32183,y:33057,varname:node_5803,prsc:2|A-2414-OUT,B-4833-R;n:type:ShaderForge.SFN_Rotator,id:1670,x:31441,y:33967,varname:node_1670,prsc:2|UVIN-8546-OUT,ANG-35-OUT;n:type:ShaderForge.SFN_Pi,id:9929,x:30951,y:34101,varname:node_9929,prsc:2;n:type:ShaderForge.SFN_Multiply,id:35,x:31100,y:34116,varname:node_35,prsc:2|A-9929-OUT,B-1751-OUT;n:type:ShaderForge.SFN_ValueProperty,id:1751,x:30951,y:34224,ptovrint:False,ptlb:Tex02_UVAngle,ptin:_Tex02_UVAngle,varname:node_1751,prsc:2,glob:False,v1:0;n:type:ShaderForge.SFN_Rotator,id:2921,x:31290,y:32655,varname:node_2921,prsc:2|UVIN-317-OUT,ANG-8874-OUT;n:type:ShaderForge.SFN_Pi,id:8926,x:30993,y:32816,varname:node_8926,prsc:2;n:type:ShaderForge.SFN_Multiply,id:8874,x:31155,y:32831,varname:node_8874,prsc:2|A-8926-OUT,B-7045-OUT;n:type:ShaderForge.SFN_ValueProperty,id:7045,x:30993,y:32936,ptovrint:False,ptlb:Tex01_UVAngle,ptin:_Tex01_UVAngle,varname:_Tex02_UVAngle_copy,prsc:2,glob:False,v1:0;n:type:ShaderForge.SFN_Panner,id:1080,x:30267,y:32450,varname:node_1080,prsc:2,spu:1,spv:0|UVIN-484-OUT,DIST-4562-OUT;n:type:ShaderForge.SFN_Add,id:484,x:30010,y:32385,varname:node_484,prsc:2|A-5483-UVOUT,B-4573-OUT;n:type:ShaderForge.SFN_TexCoord,id:4483,x:29886,y:33353,varname:node_4483,prsc:2,uv:0;n:type:ShaderForge.SFN_SwitchProperty,id:317,x:30591,y:32602,ptovrint:False,ptlb:Tex01_U/Vpan,ptin:_Tex01_UVpan,varname:node_317,prsc:2,on:False|A-1080-UVOUT,B-9819-UVOUT;n:type:ShaderForge.SFN_Panner,id:4519,x:30775,y:33723,varname:node_4519,prsc:2,spu:1,spv:0|UVIN-9372-OUT,DIST-2522-OUT;n:type:ShaderForge.SFN_Add,id:9372,x:30557,y:33596,varname:node_9372,prsc:2|A-4790-OUT,B-5507-UVOUT;n:type:ShaderForge.SFN_SwitchProperty,id:8546,x:31098,y:33617,ptovrint:False,ptlb:Tex02_U/Vpan,ptin:_Tex02_UVpan,varname:node_8546,prsc:2,on:False|A-4519-UVOUT,B-5310-UVOUT;proporder:7909-4431-7045-317-8376-7300-733-2430-5732-1751-8546-6092-1705-9026-2300-4833-8196-6233;pass:END;sub:END;*/

Shader "lg/2Tex_PlannerDis" {
    Properties {
        _InstensityA ("InstensityA", Float ) = 1
        _Tex01 ("Tex01", 2D) = "black" {}
        _Tex01_UVAngle ("Tex01_UVAngle", Float ) = 0
        [MaterialToggle] _Tex01_UVpan ("Tex01_U/Vpan", Float ) = 0
        _PanV_Tex01 ("PanV_Tex01", Float ) = 0
        _DisTex01 ("DisTex01", 2D) = "white" {}
        _PanV_DisTex01 ("PanV_DisTex01", Float ) = 0
        _Power_DisTex01 ("Power_DisTex01", Float ) = 0
        _Tex02 ("Tex02", 2D) = "white" {}
        _Tex02_UVAngle ("Tex02_UVAngle", Float ) = 0
        [MaterialToggle] _Tex02_UVpan ("Tex02_U/Vpan", Float ) = 0
        _Panv_Tex02 ("Panv_Tex02", Float ) = 0
        _DisTex02 ("DisTex02", 2D) = "white" {}
        _Power_DisTex02 ("Power_DisTex02", Float ) = 0
        _PanV_DisTex02 ("PanV_DisTex02", Float ) = 0
        _Mask_Tex ("Mask_Tex", 2D) = "white" {}
        _Color_Tex01 ("Color_Tex01", Color) = (0.5,0.5,0.5,1)
        _Color_Tex02 ("Color_Tex02", Color) = (0.5,0.5,0.5,1)
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "Queue"="Transparent+1"
            "RenderType"="Transparent"
        }
        Pass {
            Name "ForwardBase"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend SrcColor One
            Cull Off
            ZWrite Off
            
            Fog {Mode Off}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase_fullshadows
            #pragma exclude_renderers xbox360 ps3 flash d3d11_9x 
            #pragma target 3.0
            uniform float4 _TimeEditor;
            uniform sampler2D _Tex01; uniform float4 _Tex01_ST;
            uniform sampler2D _DisTex01; uniform float4 _DisTex01_ST;
            uniform float _Power_DisTex01;
            uniform float _PanV_Tex01;
            uniform float _PanV_DisTex01;
            uniform sampler2D _Tex02; uniform float4 _Tex02_ST;
            uniform sampler2D _DisTex02; uniform float4 _DisTex02_ST;
            uniform float _Power_DisTex02;
            uniform float _PanV_DisTex02;
            uniform float _InstensityA;
            uniform float _Panv_Tex02;
            uniform float4 _Color_Tex01;
            uniform float4 _Color_Tex02;
            uniform sampler2D _Mask_Tex; uniform float4 _Mask_Tex_ST;
            uniform float _Tex02_UVAngle;
            uniform float _Tex01_UVAngle;
            uniform fixed _Tex01_UVpan;
            uniform fixed _Tex02_UVpan;
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
                float node_2921_ang = (3.141592654*_Tex01_UVAngle);
                float node_2921_spd = 1.0;
                float node_2921_cos = cos(node_2921_spd*node_2921_ang);
                float node_2921_sin = sin(node_2921_spd*node_2921_ang);
                float2 node_2921_piv = float2(0.5,0.5);
                float4 node_1988 = _Time + _TimeEditor;
                float node_4562 = (node_1988.g*_PanV_Tex01);
                float4 node_4964 = _Time + _TimeEditor;
                float2 node_197 = (i.uv0+(node_4964.g*_PanV_DisTex01)*float2(0,1));
                float4 _DisTex01_var = tex2D(_DisTex01,TRANSFORM_TEX(node_197, _DisTex01));
                float3 node_4573 = (_DisTex01_var.rgb*_Power_DisTex01);
                float2 node_2921 = (mul(lerp( ((float3(i.uv0,0.0)+node_4573)+node_4562*float2(1,0)), ((node_4573+float3(i.uv0,0.0))+node_4562*float2(0,1)), _Tex01_UVpan )-node_2921_piv,float2x2( node_2921_cos, -node_2921_sin, node_2921_sin, node_2921_cos))+node_2921_piv);
                float4 _Tex01_var = tex2D(_Tex01,TRANSFORM_TEX(node_2921, _Tex01));
                float node_1670_ang = (3.141592654*_Tex02_UVAngle);
                float node_1670_spd = 1.0;
                float node_1670_cos = cos(node_1670_spd*node_1670_ang);
                float node_1670_sin = sin(node_1670_spd*node_1670_ang);
                float2 node_1670_piv = float2(0.5,0.5);
                float4 node_1802 = _Time + _TimeEditor;
                float node_2522 = (node_1802.g*_Panv_Tex02);
                float4 node_9992 = _Time + _TimeEditor;
                float2 node_6181 = (i.uv0+(node_9992.g*_PanV_DisTex02)*float2(0,1));
                float4 _DisTex02_var = tex2D(_DisTex02,TRANSFORM_TEX(node_6181, _DisTex02));
                float3 node_4790 = (_DisTex02_var.rgb*_Power_DisTex02);
                float2 node_1670 = (mul(lerp( ((node_4790+float3(i.uv0,0.0))+node_2522*float2(1,0)), ((node_4790+float3(i.uv0,0.0))+node_2522*float2(0,1)), _Tex02_UVpan )-node_1670_piv,float2x2( node_1670_cos, -node_1670_sin, node_1670_sin, node_1670_cos))+node_1670_piv);
                float4 _Tex02_var = tex2D(_Tex02,TRANSFORM_TEX(node_1670, _Tex02));
                float4 _Mask_Tex_var = tex2D(_Mask_Tex,TRANSFORM_TEX(i.uv0, _Mask_Tex));
                float3 emissive = ((_InstensityA*(((_Color_Tex01.rgb*_Tex01_var.rgb)+(_Tex02_var.rgb*_Color_Tex02.rgb))*_Mask_Tex_var.r))*i.vertexColor.rgb);
                float3 finalColor = emissive;
				i.vertexColor.a = saturate(i.vertexColor.a);
                return fixed4(finalColor,i.vertexColor.a);
            }
            ENDCG
        }
    }
    ////FallBack "Diffuse"
}
