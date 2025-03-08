Shader "RO/RO_Effect_UVRJ_01"
{
	Properties
	{
		[HDR]_MainTexColor("MainTexColor", Color) = (1,1,1,1)
		_MainTex("MainTex", 2D) = "white" {}
		_Vector0("UV_Speed", Vector) = (0,0,0,0)
		_FresnelColor("FresnelColor", Color) = (0,0,0,0)
		_Fresnel("Fresnel(X_Bias,Y_Scale,Z_Power)", Vector) = (0,0,0,0)
		[Enum(UnityEngine.Rendering.BlendMode)]_Src1("Src", Float) = 1
		[Enum(UnityEngine.Rendering.BlendMode)]_Dst1("Dst", Float) = 1
		[Enum(UnityEngine.Rendering.CullMode)]_CullMode1("CullMode", Float) = 0
		[Enum(On,0,Off,1)]_ZWrite1("ZWrite", Float) = 0
		[Enum(UnityEngine.Rendering.CompareFunction)]_ZTest1("ZTest", Float) = 5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull [_CullMode1]
		ZWrite [_ZWrite1]
		ZTest [_ZTest1]
		Blend [_Src1] [_Dst1]
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nometa noforwardadd 
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float _Dst1;
		uniform float _Src1;
		uniform float _CullMode1;
		uniform float _ZTest1;
		uniform float _ZWrite1;
		uniform float4 _FresnelColor;
		uniform float4 _Fresnel;
		uniform float4 _MainTexColor;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float4 _Vector0;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV43 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode43 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV43, _Fresnel.y ) );
			float2 uv0_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 appendResult25 = (float2(( uv0_MainTex.x + ( _Time.y * _Vector0.x ) ) , ( uv0_MainTex.y + ( _Time.y * _Vector0.y ) )));
			float4 tex2DNode2 = tex2D( _MainTex, appendResult25 );
			float2 appendResult34 = (float2(( uv0_MainTex.x + ( _Time.y * _Vector0.z ) ) , ( uv0_MainTex.y + ( _Time.y * _Vector0.w ) )));
			float4 tex2DNode36 = tex2D( _MainTex, appendResult34 );
			float temp_output_65_0 = ( tex2DNode2.r * tex2DNode36.r );
			o.Emission = saturate( ( ( _FresnelColor * saturate( ( fresnelNode43 * _Fresnel.x ) ) ) + ( _MainTexColor * temp_output_65_0 * i.vertexColor ) ) ).rgb;
			o.Alpha = step( saturate( ( temp_output_65_0 * _MainTexColor.a ) ) , ( _FresnelColor.a * i.vertexColor.a ) );
		}

		ENDCG
	}
}
