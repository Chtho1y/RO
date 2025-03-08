// Shader created with Shader Forge v1.37 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.37;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:3,bdst:7,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:9361,x:33209,y:32712,varname:node_9361,prsc:2|alpha-3832-OUT,refract-2733-OUT;n:type:ShaderForge.SFN_Tex2d,id:6915,x:32220,y:32817,ptovrint:False,ptlb:Tex,ptin:_Tex,varname:node_6915,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-5877-OUT;n:type:ShaderForge.SFN_Append,id:1254,x:32503,y:32793,varname:node_1254,prsc:2|A-6915-R,B-6915-G;n:type:ShaderForge.SFN_Multiply,id:2733,x:32779,y:32862,varname:node_2733,prsc:2|A-1254-OUT,B-6915-A,C-7735-OUT,D-2111-A;n:type:ShaderForge.SFN_Vector1,id:3832,x:32938,y:32800,varname:node_3832,prsc:2,v1:0;n:type:ShaderForge.SFN_Slider,id:7735,x:32295,y:33128,ptovrint:False,ptlb:Intensity,ptin:_Intensity,varname:node_7735,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_VertexColor,id:2111,x:32503,y:32607,varname:node_2111,prsc:2;n:type:ShaderForge.SFN_TexCoord,id:8308,x:31327,y:32622,varname:node_8308,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Add,id:2801,x:31774,y:32724,varname:node_2801,prsc:2|A-8308-UVOUT,B-8541-OUT;n:type:ShaderForge.SFN_Time,id:2748,x:31272,y:32854,varname:node_2748,prsc:2;n:type:ShaderForge.SFN_Multiply,id:8541,x:31728,y:32928,varname:node_8541,prsc:2|A-2748-T,B-8256-OUT;n:type:ShaderForge.SFN_Append,id:8256,x:31532,y:33055,varname:node_8256,prsc:2|A-6188-OUT,B-2639-OUT;n:type:ShaderForge.SFN_ValueProperty,id:6188,x:31286,y:33085,ptovrint:False,ptlb:U_speed,ptin:_U_speed,varname:node_6188,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_ValueProperty,id:2639,x:31286,y:33174,ptovrint:False,ptlb:V_speed,ptin:_V_speed,varname:_U_speed_copy,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_SwitchProperty,id:5877,x:32009,y:32703,ptovrint:False,ptlb:ani_TorF,ptin:_ani_TorF,varname:node_5877,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,on:False|A-8308-UVOUT,B-2801-OUT;proporder:6915-7735-6188-2639-5877;pass:END;sub:END;*/

Shader "Shader Forge/Eff_Distortion" {
    Properties {
        _Tex ("Tex", 2D) = "white" {}
        _Intensity ("Intensity", Range(0, 1)) = 0
        _U_speed ("U_speed", Float ) = 0
        _V_speed ("V_speed", Float ) = 0
        [MaterialToggle] _ani_TorF ("ani_TorF", Float ) = 0
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        GrabPass{ }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend SrcAlpha OneMinusSrcAlpha
            Cull Off
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            //#pragma only_renderers d3d9 d3d11 glcore gles gles3 metal 
            #pragma target 3.0
            uniform sampler2D _GrabTexture;
            uniform float4 _TimeEditor;
            uniform sampler2D _Tex; uniform float4 _Tex_ST;
            uniform float _Intensity;
            uniform float _U_speed;
            uniform float _V_speed;
            uniform fixed _ani_TorF;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 screenPos : TEXCOORD1;
                float4 vertexColor : COLOR;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.vertexColor = v.vertexColor;
                o.pos = UnityObjectToClipPos( v.vertex );
                o.screenPos = o.pos;
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                #if UNITY_UV_STARTS_AT_TOP
                    float grabSign = -_ProjectionParams.x;
                #else
                    float grabSign = _ProjectionParams.x;
                #endif
                i.screenPos = float4( i.screenPos.xy / i.screenPos.w, 0, 0 );
                i.screenPos.y *= _ProjectionParams.x;
                float4 node_2748 = _Time + _TimeEditor;
                float2 _ani_TorF_var = lerp( i.uv0, (i.uv0+(node_2748.g*float2(_U_speed,_V_speed))), _ani_TorF );
                float4 _Tex_var = tex2D(_Tex,TRANSFORM_TEX(_ani_TorF_var, _Tex));
                float2 sceneUVs = float2(1,grabSign)*i.screenPos.xy*0.5+0.5 + (float2(_Tex_var.r,_Tex_var.g)*_Tex_var.a*_Intensity*i.vertexColor.a);
                float4 sceneColor = tex2D(_GrabTexture, sceneUVs);
////// Lighting:
                float3 finalColor = 0;
                fixed4 finalRGBA = fixed4(lerp(sceneColor.rgb, finalColor,0.0),1);
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
            Cull Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_SHADOWCASTER
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma multi_compile_fog
            //#pragma only_renderers d3d9 d3d11 glcore gles gles3 metal 
            #pragma target 3.0
            struct VertexInput {
                float4 vertex : POSITION;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.pos = UnityObjectToClipPos( v.vertex );
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    //FallBack "Diffuse"
}
