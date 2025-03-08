Shader "RO/RO_Effect_Vertex_02"
{
	Properties
	{
		[HDR]_MainTexColor("MainTexColor", Color) = (1,1,1,1)
		_MainTex("MainTex", 2D) = "white" {}
		_Vector0("UV_Speed", Vector) = (0,0,0,0)
		_VertexStr("VertexStr", Float) = 0
		_FresnelColor("FresnelColor", Color) = (0,0,0,0)
		_Fresnel("Fresnel(X_Bias,Y_Scale,Z_Power)", Vector) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  "PreviewType" = "Plane"}
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit alpha:fade keepalpha noshadow vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float4 _Vector0;
		uniform float _VertexStr;
		uniform float4 _FresnelColor;
		uniform float4 _Fresnel;
		uniform float4 _MainTexColor;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 uv0_MainTex = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 appendResult25 = (float2(( uv0_MainTex.x + ( _Time.y * _Vector0.x ) ) , ( uv0_MainTex.y + ( _Time.y * _Vector0.y ) )));
			float4 tex2DNode2 = tex2Dlod( _MainTex, float4( appendResult25, 0, 0.0) );
			float2 appendResult34 = (float2(( uv0_MainTex.x + ( _Time.y * _Vector0.z ) ) , ( uv0_MainTex.y + ( _Time.y * _Vector0.w ) )));
			float4 tex2DNode36 = tex2Dlod( _MainTex, float4( appendResult34, 0, 0.0) );
			float temp_output_65_0 = ( tex2DNode2.r * tex2DNode36.r );
			float3 ase_vertexNormal = v.normal.xyz;
			v.vertex.xyz += ( temp_output_65_0 * _VertexStr * ase_vertexNormal * v.texcoord.z );
		}

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
			float fresnelNode43 = ( _Fresnel.x + _Fresnel.y * pow( 1.0 - fresnelNdotV43, _Fresnel.z ) );
			float2 uv0_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 appendResult25 = (float2(( uv0_MainTex.x + ( _Time.y * _Vector0.x ) ) , ( uv0_MainTex.y + ( _Time.y * _Vector0.y ) )));
			float4 tex2DNode2 = tex2D( _MainTex, appendResult25 );
			float2 appendResult34 = (float2(( uv0_MainTex.x + ( _Time.y * _Vector0.z ) ) , ( uv0_MainTex.y + ( _Time.y * _Vector0.w ) )));
			float4 tex2DNode36 = tex2D( _MainTex, appendResult34 );
			float temp_output_65_0 = ( tex2DNode2.r * tex2DNode36.r );
			float4 temp_output_49_0 = saturate( ( ( _FresnelColor * saturate( fresnelNode43 ) ) + ( _MainTexColor * temp_output_65_0 * i.vertexColor ) ) );
			o.Emission = temp_output_49_0.rgb;
			o.Alpha = saturate( ( ( _MainTexColor.a + temp_output_65_0 ) * _MainTexColor.a * i.vertexColor.a ) );
		}

		ENDCG
	}
}
