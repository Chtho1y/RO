Shader "MoleGame/Particles/Additive_UVAnim_Distortion_Mask"
{
    Properties {
        _MainTex ("MainTex", 2D) = "white" {}
        _TintColor ("Color", Color) = (0,0,0,1)
        _Fresnel ("Fresnel", Float ) = 2
		_FresnelAdd ("FresnelAdd", Range (0,1) ) = 0
		_FresnelColor ("FresnelColor", Color) = (0,0,0,1)
        _U_Speed ("U_Speed", Float ) = 0
        _V_Speed ("V_Speed", Float ) = -1
        _Add ("Add", Float ) = 4
        _Mask ("Mask", 2D) = "white" {}
        _DistortionTex ("DistortionTex", 2D) = "white" {}
        _Distortion ("Distortion", Float ) = 0.1
		_U_Dis ("U_Dis", Float ) = 0.1
        _V_Dis ("V_Dis", Float ) = 0.05
		_Vertex_01 ("Vertex_01", Float ) = 0
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
            Blend SrcAlpha One
            Cull Off
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #pragma target 3.0
            uniform sampler2D _MainTex; 
			uniform half4 _MainTex_ST;
            uniform fixed4 _TintColor;
            uniform half _Fresnel;
			uniform half _FresnelAdd;
			uniform fixed4 _FresnelColor;
            uniform half _U_Speed;
            uniform half _V_Speed;
            uniform half _Add;
            uniform sampler2D _Mask; 
			uniform half4 _Mask_ST;
            uniform sampler2D _DistortionTex; 
			uniform half4 _DistortionTex_ST;
            uniform half _Distortion;
			uniform half _U_Dis;
            uniform half _V_Dis;
			uniform half _Vertex_01;

            struct VertexInput {
                half4 vertex : POSITION;
                half3 normal : NORMAL;
                half2 texcoord0 : TEXCOORD0;
                fixed4 vertexColor : COLOR;
            };
            struct VertexOutput {
                half4 pos : SV_POSITION;
                half2 uv0 : TEXCOORD0;
                half4 posWorld : TEXCOORD1;
                half3 normalDir : TEXCOORD2;
                fixed4 vertexColor : COLOR;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.vertexColor = v.vertexColor;
                o.normalDir = UnityObjectToWorldNormal(v.normal);
				fixed2 uv_t = (o.uv0+(fmod(_Time.y,10)*half2(_U_Dis,_V_Dis)));
				fixed4 _Distortion_var = tex2Dlod(_DistortionTex,half4(TRANSFORM_TEX(uv_t, _DistortionTex),0.0,0));
				v.vertex.xyz += (_Distortion_var.r*_Vertex_01*v.normal);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos( v.vertex );
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                half faceSign = sign(facing);//( facing >= 0 ? 1 : -1 );
                i.normalDir = normalize(i.normalDir);
                i.normalDir *= faceSign;
                half3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
                half3 normalDirection = i.normalDir;
////// Emissive:
                fixed4 _Distortion_var = tex2D(_DistortionTex,TRANSFORM_TEX(i.uv0, _DistortionTex));
                half dist = (_Distortion_var.r*_Distortion);
                half2 uv_dist = (i.uv0+(fmod(_Time.y,10)*half2(_U_Speed,_V_Speed))+dist);
                fixed4 _MainTex_var = tex2D(_MainTex,TRANSFORM_TEX(uv_dist, _MainTex));
                fixed4 _Mask_var = tex2D(_Mask,TRANSFORM_TEX(i.uv0, _Mask));
				half fresnel = pow(1.0-max(0,dot(normalDirection, viewDirection)),_Fresnel);
                fixed3 col = _MainTex_var.rgb * _TintColor.rgb * _Add * fresnel * _Mask_var.r;
				fixed3 col2 = _MainTex_var.r * _TintColor.rgb * _Add + _TintColor.a * fresnel * _FresnelColor.rgb * _Mask_var.r;
				col = lerp(col,col2,_FresnelAdd);
                return fixed4(col,i.vertexColor.a);
            }
            ENDCG
		}
	}
}
