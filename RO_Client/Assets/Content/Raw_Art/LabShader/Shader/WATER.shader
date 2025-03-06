// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Shader created with Shader Forge v1.36 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.36;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:1,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:0,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:0,bsrc:3,bdst:7,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:True,aust:False,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:4013,x:35075,y:32860,varname:node_4013,prsc:2|diff-4747-OUT,spec-8257-OUT,gloss-7570-OUT,emission-1332-OUT,alpha-1921-OUT,refract-9646-OUT;n:type:ShaderForge.SFN_Tex2d,id:828,x:32470,y:32123,ptovrint:False,ptlb:base_1,ptin:_base_1,varname:_base_1,prsc:0,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-1405-UVOUT;n:type:ShaderForge.SFN_Tex2d,id:3453,x:30909,y:32875,ptovrint:False,ptlb:Normal_1,ptin:_Normal_1,varname:_Normal_1,prsc:1,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:2,isnm:False|UVIN-1405-UVOUT;n:type:ShaderForge.SFN_Multiply,id:3812,x:32748,y:32215,varname:node_3812,prsc:2|A-828-RGB,B-2423-RGB;n:type:ShaderForge.SFN_Tex2d,id:2423,x:32470,y:32363,ptovrint:False,ptlb:base_2,ptin:_base_2,varname:_base_2,prsc:0,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:0,isnm:False|UVIN-6402-UVOUT;n:type:ShaderForge.SFN_Panner,id:1405,x:30299,y:32686,varname:node_1405,prsc:1,spu:1,spv:1|UVIN-5798-UVOUT,DIST-8538-OUT;n:type:ShaderForge.SFN_Panner,id:6402,x:30290,y:33341,varname:node_6402,prsc:1,spu:1,spv:1|UVIN-2661-UVOUT,DIST-4142-OUT;n:type:ShaderForge.SFN_TexCoord,id:5798,x:30009,y:32541,varname:node_5798,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Multiply,id:3902,x:31177,y:33003,varname:node_3902,prsc:1|A-3453-RGB,B-7633-RGB;n:type:ShaderForge.SFN_Tex2d,id:7633,x:30909,y:33128,ptovrint:False,ptlb:Normal_2,ptin:_Normal_2,varname:_Normal_2,prsc:1,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,ntxv:2,isnm:False|UVIN-6402-UVOUT;n:type:ShaderForge.SFN_Multiply,id:504,x:32499,y:33827,varname:node_504,prsc:2|A-6953-OUT,B-8249-OUT;n:type:ShaderForge.SFN_ComponentMask,id:6953,x:31840,y:33616,varname:node_6953,prsc:2,cc1:0,cc2:1,cc3:-1,cc4:-1|IN-3902-OUT;n:type:ShaderForge.SFN_Multiply,id:8249,x:31965,y:33872,varname:node_8249,prsc:2|A-9562-OUT,B-3347-OUT;n:type:ShaderForge.SFN_Multiply,id:1332,x:33031,y:32299,varname:node_1332,prsc:2|A-3812-OUT,B-4448-OUT;n:type:ShaderForge.SFN_Multiply,id:8257,x:34496,y:31974,varname:node_8257,prsc:2|A-6870-OUT,B-1120-RGB,C-9646-OUT;n:type:ShaderForge.SFN_Tex2d,id:6630,x:32356,y:33375,ptovrint:False,ptlb:Aplha,ptin:_Aplha,cmnt:uv2,varname:_Aplha,prsc:1,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:5eda1afd02b1bc34a885be98fe98cc8f,ntxv:0,isnm:False|UVIN-3206-UVOUT;n:type:ShaderForge.SFN_Multiply,id:877,x:32553,y:33392,varname:node_877,prsc:1|A-6630-R,B-6630-B;n:type:ShaderForge.SFN_Multiply,id:6656,x:32877,y:33159,varname:node_6656,prsc:2|A-2011-OUT,B-877-OUT;n:type:ShaderForge.SFN_TexCoord,id:3206,x:32127,y:33375,varname:node_3206,prsc:2,uv:2,uaff:False;n:type:ShaderForge.SFN_Time,id:3801,x:29806,y:32773,varname:time_1,prsc:1;n:type:ShaderForge.SFN_ComponentMask,id:825,x:29806,y:32589,varname:node_825,prsc:2,cc1:0,cc2:1,cc3:-1,cc4:-1|IN-9924-XYZ;n:type:ShaderForge.SFN_Multiply,id:8538,x:30009,y:32752,varname:node_8538,prsc:2|A-825-OUT,B-3801-TSL;n:type:ShaderForge.SFN_Vector4Property,id:9924,x:29602,y:32589,ptovrint:False,ptlb:Panner_01,ptin:_Panner_01,varname:_Panner_01,prsc:1,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1,v2:1,v3:0,v4:0;n:type:ShaderForge.SFN_Multiply,id:4142,x:30049,y:33444,varname:node_4142,prsc:2|A-1078-OUT,B-4164-TSL;n:type:ShaderForge.SFN_ComponentMask,id:1078,x:29854,y:33245,varname:node_1078,prsc:2,cc1:0,cc2:1,cc3:-1,cc4:-1|IN-8471-XYZ;n:type:ShaderForge.SFN_Vector4Property,id:8471,x:29654,y:33245,ptovrint:False,ptlb:Panner_02,ptin:_Panner_02,varname:_Panner_02,prsc:1,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1,v2:1,v3:0,v4:0;n:type:ShaderForge.SFN_Time,id:4164,x:29854,y:33469,varname:time,prsc:1;n:type:ShaderForge.SFN_TexCoord,id:2661,x:30049,y:33245,varname:node_2661,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_ValueProperty,id:4448,x:32774,y:32524,ptovrint:False,ptlb:Emission,ptin:_Emission,varname:_Emission,prsc:1,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0;n:type:ShaderForge.SFN_Color,id:4182,x:33537,y:32482,ptovrint:False,ptlb:Color_02,ptin:_Color_02,varname:_Color_02,prsc:1,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_ValueProperty,id:6870,x:34283,y:31907,ptovrint:False,ptlb:Specular,ptin:_Specular,varname:_Specular,prsc:1,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_Color,id:1120,x:34075,y:32002,ptovrint:False,ptlb:Specular_Color,ptin:_Specular_Color,varname:_Specular_Color,prsc:1,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,c1:0.5,c2:0.5,c3:0.5,c4:1;n:type:ShaderForge.SFN_ValueProperty,id:2011,x:32484,y:33207,ptovrint:False,ptlb:Opacity,ptin:_Opacity,varname:_Opacity,prsc:1,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0.5;n:type:ShaderForge.SFN_Slider,id:3347,x:31536,y:34040,ptovrint:False,ptlb:Refraction Intensity,ptin:_RefractionIntensity,varname:_RefractionIntensity,prsc:1,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;n:type:ShaderForge.SFN_Vector1,id:9562,x:31665,y:33886,varname:node_9562,prsc:2,v1:0.2;n:type:ShaderForge.SFN_Lerp,id:5234,x:33115,y:33807,varname:node_5234,prsc:2|A-4198-OUT,B-504-OUT,T-877-OUT;n:type:ShaderForge.SFN_ComponentMask,id:4198,x:32584,y:33669,varname:node_4198,prsc:2,cc1:0,cc2:-1,cc3:-1,cc4:-1|IN-4884-OUT;n:type:ShaderForge.SFN_Vector3,id:4884,x:32356,y:33638,varname:node_4884,prsc:1,v1:0,v2:0,v3:1;n:type:ShaderForge.SFN_VertexColor,id:5849,x:32772,y:32990,varname:node_5849,prsc:2;n:type:ShaderForge.SFN_Multiply,id:1921,x:33258,y:32920,varname:node_1921,prsc:2|A-5849-R,B-6656-OUT;n:type:ShaderForge.SFN_Multiply,id:9646,x:33448,y:33547,varname:node_9646,prsc:1|A-5849-R,B-5234-OUT;n:type:ShaderForge.SFN_Add,id:5264,x:34236,y:32466,varname:node_5264,prsc:2|A-1332-OUT,B-4747-OUT;n:type:ShaderForge.SFN_Multiply,id:4747,x:33866,y:32721,varname:node_4747,prsc:2|A-4182-RGB,B-5848-OUT;n:type:ShaderForge.SFN_ValueProperty,id:5848,x:33549,y:32787,ptovrint:False,ptlb:Color_Power,ptin:_Color_Power,varname:_Color_Power,prsc:1,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;n:type:ShaderForge.SFN_ValueProperty,id:7570,x:34606,y:32886,ptovrint:False,ptlb:Gloss,ptin:_Gloss,varname:_Gloss,prsc:1,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:1;proporder:828-2423-3453-7633-6630-9924-8471-4448-4182-6870-1120-2011-3347-5848-7570;pass:END;sub:END;*/

Shader "Shader Forge/water" {
    Properties {
        _base_1 ("base_1", 2D) = "white" {}
        _base_2 ("base_2", 2D) = "white" {}
        _Normal_1 ("Normal_1", 2D) = "black" {}
        _Normal_2 ("Normal_2", 2D) = "black" {}
        _Aplha ("Aplha", 2D) = "white" {}
        _Panner_01 ("Panner_01", Vector) = (1,1,0,0)
        _Panner_02 ("Panner_02", Vector) = (1,1,0,0)
        _Emission ("Emission", Float ) = 0
        _Color_02 ("Color_02", Color) = (0.5,0.5,0.5,1)
        _Specular ("Specular", Float ) = 1
        _Specular_Color ("Specular_Color", Color) = (0.5,0.5,0.5,1)
        _Opacity ("Opacity", Float ) = 0.5
        _RefractionIntensity ("Refraction Intensity", Range(0, 1)) = 0
        _Color_Power ("Color_Power", Float ) = 1
        _Gloss ("Gloss", Float ) = 1
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
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles gles3 metal d3d11_9x 
            #pragma target 3.0
            uniform float4 _LightColor0;
            uniform sampler2D _GrabTexture;
            uniform float4 _TimeEditor;
            uniform sampler2D _base_1; uniform float4 _base_1_ST;
            uniform sampler2D _Normal_1; uniform float4 _Normal_1_ST;
            uniform sampler2D _base_2; uniform float4 _base_2_ST;
            uniform sampler2D _Normal_2; uniform float4 _Normal_2_ST;
            uniform sampler2D _Aplha; uniform float4 _Aplha_ST;
            uniform half4 _Panner_01;
            uniform half4 _Panner_02;
            uniform half _Emission;
            uniform half4 _Color_02;
            uniform half _Specular;
            uniform half4 _Specular_Color;
            uniform half _Opacity;
            uniform half _RefractionIntensity;
            uniform half _Color_Power;
            uniform half _Gloss;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord2 : TEXCOORD2;
                float4 vertexColor : COLOR;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float2 uv2 : TEXCOORD1;
                float4 posWorld : TEXCOORD2;
                float3 normalDir : TEXCOORD3;
                float4 screenPos : TEXCOORD4;
                float4 vertexColor : COLOR;
                UNITY_FOG_COORDS(5)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.uv2 = v.texcoord2;
                o.vertexColor = v.vertexColor;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos(v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                o.screenPos = o.pos;
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                #if UNITY_UV_STARTS_AT_TOP
                    float grabSign = -_ProjectionParams.x;
                #else
                    float grabSign = _ProjectionParams.x;
                #endif
                i.screenPos = float4( i.screenPos.xy / i.screenPos.w, 0, 0 );
                i.screenPos.y *= _ProjectionParams.x;
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                float node_4198 = half3(0,0,1).r;
                half4 time_1 = _Time + _TimeEditor;
                half2 node_1405 = (i.uv0+(_Panner_01.rgb.rg*time_1.r)*float2(1,1));
                half4 _Normal_1_var = tex2D(_Normal_1,TRANSFORM_TEX(node_1405, _Normal_1));
                half4 time = _Time + _TimeEditor;
                half2 node_6402 = (i.uv0+(_Panner_02.rgb.rg*time.r)*float2(1,1));
                half4 _Normal_2_var = tex2D(_Normal_2,TRANSFORM_TEX(node_6402, _Normal_2));
                half4 _Aplha_var = tex2D(_Aplha,TRANSFORM_TEX(i.uv2, _Aplha)); // uv2
                half node_877 = (_Aplha_var.r*_Aplha_var.b);
                half2 node_9646 = (i.vertexColor.r*lerp(float2(node_4198,node_4198),((_Normal_1_var.rgb*_Normal_2_var.rgb).rg*(0.2*_RefractionIntensity)),node_877));
                float2 sceneUVs = float2(1,grabSign)*i.screenPos.xy*0.5+0.5 + node_9646;
                float4 sceneColor = tex2D(_GrabTexture, sceneUVs);
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 lightColor = _LightColor0.rgb;
                float3 halfDirection = normalize(viewDirection+lightDirection);
////// Lighting:
                float attenuation = 1;
                float3 attenColor = attenuation * _LightColor0.xyz;
///////// Gloss:
                float gloss = _Gloss;
                float specPow = exp2( gloss * 10.0 + 1.0 );
////// Specular:
                float NdotL = saturate(dot( normalDirection, lightDirection ));
                float3 specularColor = (_Specular*_Specular_Color.rgb*float3(node_9646,0.0));
                float3 directSpecular = attenColor * pow(max(0,dot(halfDirection,normalDirection)),specPow)*specularColor;
                float3 specular = directSpecular;
/////// Diffuse:
                NdotL = max(0.0,dot( normalDirection, lightDirection ));
                float3 directDiffuse = max( 0.0, NdotL) * attenColor;
                float3 indirectDiffuse = float3(0,0,0);
                indirectDiffuse += UNITY_LIGHTMODEL_AMBIENT.rgb; // Ambient Light
                float3 node_4747 = (_Color_02.rgb*_Color_Power);
                float3 diffuseColor = node_4747;
                float3 diffuse = (directDiffuse + indirectDiffuse) * diffuseColor;
////// Emissive:
                fixed4 _base_1_var = tex2D(_base_1,TRANSFORM_TEX(node_1405, _base_1));
                fixed4 _base_2_var = tex2D(_base_2,TRANSFORM_TEX(node_6402, _base_2));
                float3 node_1332 = ((_base_1_var.rgb*_base_2_var.rgb)*_Emission);
                float3 emissive = node_1332;
/// Final Color:
                float3 finalColor = diffuse + specular + emissive;
                fixed4 finalRGBA = fixed4(lerp(sceneColor.rgb, finalColor,(i.vertexColor.r*(_Opacity*node_877))),1);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
        Pass {
            Name "FORWARD_DELTA"
            Tags {
                "LightMode"="ForwardAdd"
            }
            Blend One One
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDADD
            #include "UnityCG.cginc"
            #include "AutoLight.cginc"
            #pragma multi_compile_fwdadd
            #pragma multi_compile_fog
            #pragma only_renderers d3d9 d3d11 glcore gles gles3 metal d3d11_9x 
            #pragma target 3.0
            uniform float4 _LightColor0;
            uniform sampler2D _GrabTexture;
            uniform float4 _TimeEditor;
            uniform sampler2D _base_1; uniform float4 _base_1_ST;
            uniform sampler2D _Normal_1; uniform float4 _Normal_1_ST;
            uniform sampler2D _base_2; uniform float4 _base_2_ST;
            uniform sampler2D _Normal_2; uniform float4 _Normal_2_ST;
            uniform sampler2D _Aplha; uniform float4 _Aplha_ST;
            uniform half4 _Panner_01;
            uniform half4 _Panner_02;
            uniform half _Emission;
            uniform half4 _Color_02;
            uniform half _Specular;
            uniform half4 _Specular_Color;
            uniform half _Opacity;
            uniform half _RefractionIntensity;
            uniform half _Color_Power;
            uniform half _Gloss;
            struct VertexInput {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 texcoord0 : TEXCOORD0;
                float2 texcoord2 : TEXCOORD2;
                float4 vertexColor : COLOR;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float2 uv2 : TEXCOORD1;
                float4 posWorld : TEXCOORD2;
                float3 normalDir : TEXCOORD3;
                float4 screenPos : TEXCOORD4;
                float4 vertexColor : COLOR;
                LIGHTING_COORDS(5,6)
                UNITY_FOG_COORDS(7)
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.uv2 = v.texcoord2;
                o.vertexColor = v.vertexColor;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                float3 lightColor = _LightColor0.rgb;
                o.pos = UnityObjectToClipPos(v.vertex );
                UNITY_TRANSFER_FOG(o,o.pos);
                o.screenPos = o.pos;
                TRANSFER_VERTEX_TO_FRAGMENT(o)
                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
                #if UNITY_UV_STARTS_AT_TOP
                    float grabSign = -_ProjectionParams.x;
                #else
                    float grabSign = _ProjectionParams.x;
                #endif
                i.screenPos = float4( i.screenPos.xy / i.screenPos.w, 0, 0 );
                i.screenPos.y *= _ProjectionParams.x;
                float3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                float3 normalDirection = i.normalDir;
                float node_4198 = half3(0,0,1).r;
                half4 time_1 = _Time + _TimeEditor;
                half2 node_1405 = (i.uv0+(_Panner_01.rgb.rg*time_1.r)*float2(1,1));
                half4 _Normal_1_var = tex2D(_Normal_1,TRANSFORM_TEX(node_1405, _Normal_1));
                half4 time = _Time + _TimeEditor;
                half2 node_6402 = (i.uv0+(_Panner_02.rgb.rg*time.r)*float2(1,1));
                half4 _Normal_2_var = tex2D(_Normal_2,TRANSFORM_TEX(node_6402, _Normal_2));
                half4 _Aplha_var = tex2D(_Aplha,TRANSFORM_TEX(i.uv2, _Aplha)); // uv2
                half node_877 = (_Aplha_var.r*_Aplha_var.b);
                half2 node_9646 = (i.vertexColor.r*lerp(float2(node_4198,node_4198),((_Normal_1_var.rgb*_Normal_2_var.rgb).rg*(0.2*_RefractionIntensity)),node_877));
                float2 sceneUVs = float2(1,grabSign)*i.screenPos.xy*0.5+0.5 + node_9646;
                float4 sceneColor = tex2D(_GrabTexture, sceneUVs);
                float3 lightDirection = normalize(lerp(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz - i.posWorld.xyz,_WorldSpaceLightPos0.w));
                float3 lightColor = _LightColor0.rgb;
                float3 halfDirection = normalize(viewDirection+lightDirection);
////// Lighting:
                float attenuation = LIGHT_ATTENUATION(i);
                float3 attenColor = attenuation * _LightColor0.xyz;
///////// Gloss:
                float gloss = _Gloss;
                float specPow = exp2( gloss * 10.0 + 1.0 );
////// Specular:
                float NdotL = saturate(dot( normalDirection, lightDirection ));
                float3 specularColor = (_Specular*_Specular_Color.rgb*float3(node_9646,0.0));
                float3 directSpecular = attenColor * pow(max(0,dot(halfDirection,normalDirection)),specPow)*specularColor;
                float3 specular = directSpecular;
/////// Diffuse:
                NdotL = max(0.0,dot( normalDirection, lightDirection ));
                float3 directDiffuse = max( 0.0, NdotL) * attenColor;
                float3 node_4747 = (_Color_02.rgb*_Color_Power);
                float3 diffuseColor = node_4747;
                float3 diffuse = directDiffuse * diffuseColor;
/// Final Color:
                float3 finalColor = diffuse + specular;
                fixed4 finalRGBA = fixed4(finalColor * (i.vertexColor.r*(_Opacity*node_877)),0);
                UNITY_APPLY_FOG(i.fogCoord, finalRGBA);
                return finalRGBA;
            }
            ENDCG
        }
    }
    //FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
