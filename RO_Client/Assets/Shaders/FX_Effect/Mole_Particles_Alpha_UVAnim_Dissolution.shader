Shader "MoleGame/Particles/Alpha_UVAnim_Dissolution"
{
Properties {
        _MainTex ("MainTex", 2D) = "white" {}
        _TintColor ("Color", Color) = (0,0,0,1)
        _U_Speed ("U_Speed", Float ) = 0
        _V_Speed ("V_Speed", Float ) = -1
        _Add ("Add", Float ) = 1
        _Dissolution_T ("Dissolution_T", 2D) = "white" {}
        _Dissolution_01 ("Dissolution_01", Float ) = 0
        _U_Speed_02 ("U_Speed_02", Float ) = 0
        _V_Speed_02 ("V_Speed_02", Float ) = -1
        _Fresnel ("Fresnel", Float ) = 1
        _DissolutionAdd ("DissolutionAdd", Float ) = 0  // 溶解系数，0表示关闭
        //[HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend SrcAlpha OneMinusSrcAlpha
            Cull Off
            
            
            //AlphaToMask On
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            //#define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            //#pragma multi_compile_fwdbase
            #pragma target 3.0
            uniform sampler2D _MainTex; 
			uniform half4 _MainTex_ST;
            uniform half4 _TintColor;
            uniform half _U_Speed;
            uniform half _V_Speed;
            uniform half _Add;
            uniform sampler2D _Dissolution_T; 
			uniform half4 _Dissolution_T_ST;
            uniform half _Dissolution_01;
            uniform half _U_Speed_02;
            uniform half _V_Speed_02;
            uniform half _Fresnel;
            uniform float _DissolutionAdd;
            struct VertexInput {
                half4 vertex : POSITION;
                half3 normal : NORMAL;
                half4 texcoord0 : TEXCOORD0;
                fixed4 vertexColor : COLOR;
            };
            struct VertexOutput {
                half4 pos : SV_POSITION;
                half4 uv : TEXCOORD0;
                half4 posWorld : TEXCOORD1;
                half3 normalDir : TEXCOORD2;
                fixed4 vertexColor : COLOR;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv = v.texcoord0;
                o.vertexColor = v.vertexColor;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
                // 计算顶点动画，_DissolutionAdd = 0 时表示关闭
                half2 uv_t = (o.uv + (fmod(_Time.y, 10) * half2(_U_Speed_02, _V_Speed_02)));
                float4 _Dissolution_T_var = tex2Dlod(_Dissolution_T,float4(TRANSFORM_TEX(uv_t, _Dissolution_T),0.0,0));
                v.vertex.xyz += (_Dissolution_T_var.r * v.normal * _DissolutionAdd);

                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos( v.vertex );
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                //float isFrontFace = ( facing >= 0 ? 1 : 0 );
                fixed faceSign = sign(facing);//( facing >= 0 ? 1 : -1 );
                i.normalDir = normalize(i.normalDir);
                i.normalDir *= faceSign;
                fixed3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                fixed3 normalDirection = i.normalDir;
                half2 uv_t = (i.uv+(fmod(_Time.y,10)*half2(_U_Speed,_V_Speed)));
                fixed4 _Dissolution_T_var = tex2D(_Dissolution_T,TRANSFORM_TEX(uv_t, _Dissolution_T));
				_Dissolution_01 = max(_Dissolution_01, 0.0001);
				fixed z = max(i.uv.z, 0.0001);
                clip(((_Dissolution_T_var.r/_Dissolution_01)*z + _DissolutionAdd) - 0.5);
////// Emissive:
                fixed4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(uv_t, _MainTex));
                fixed fresnel = pow(1.0-max(0,dot(normalDirection, viewDirection)),_Fresnel);
				fixed3 col = fresnel * (_MainTex_var.rgb*i.vertexColor.rgb*_TintColor.rgb*_Add);
				fixed alpha = _MainTex_var.a*i.vertexColor.a*_TintColor.a;
                return fixed4(col,alpha);
            }
            ENDCG
        }
    }
}
