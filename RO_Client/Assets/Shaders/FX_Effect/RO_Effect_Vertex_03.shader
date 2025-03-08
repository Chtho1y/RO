Shader "RO/RO_Effect_Vertex_03"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_KuanDu("KuanDu", Float) = 0.1
		_GaoDU("GaoDU", Float) = 0
		_XuanZhuanFuDu("XuanZhuanFuDu", Float) = 0
		_ZhengDongPingLv("ZhengDongPingLv", Float) = 0
		_ZhengDongFuDu("ZhengDongFuDu", Float) = 0
		_kz("kz", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows noshadow vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _kz;
		uniform float _KuanDu;
		uniform float _GaoDU;
		uniform float _ZhengDongPingLv;
		uniform float _ZhengDongFuDu;
		uniform float _XuanZhuanFuDu;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;


		float3 RotateAroundAxis( float3 center, float3 original, float3 u, float angle )
		{
			original -= center;
			float C = cos( angle );
			float S = sin( angle );
			float t = 1 - C;
			float m00 = t * u.x * u.x + C;
			float m01 = t * u.x * u.y - S * u.z;
			float m02 = t * u.x * u.z + S * u.y;
			float m10 = t * u.x * u.y + S * u.z;
			float m11 = t * u.y * u.y + C;
			float m12 = t * u.y * u.z - S * u.x;
			float m20 = t * u.x * u.z - S * u.y;
			float m21 = t * u.y * u.z + S * u.x;
			float m22 = t * u.z * u.z + C;
			float3x3 finalMatrix = float3x3( m00, m01, m02, m10, m11, m12, m20, m21, m22 );
			return mul( finalMatrix, original ) + center;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 appendResult37 = (float3(( ( 1.0 - v.color.r ) - 0.5 ) , ( v.color.g - 0.5 ) , ( v.color.b - 0.5 )));
			float temp_output_73_0 = distance( appendResult37 , float3( 0,0,0 ) );
			float temp_output_244_0 = ( step( temp_output_73_0 , _kz ) * step( ( 1.0 - temp_output_73_0 ) , ( 1.0 - saturate( ( _kz - _KuanDu ) ) ) ) );
			float temp_output_238_0 = sin( ( _kz * 10.0 ) );
			float mulTime232 = _Time.y * _ZhengDongPingLv;
			float3 appendResult142 = (float3(0.0 , 0.0 , ( temp_output_244_0 * ( ( temp_output_244_0 * abs( temp_output_238_0 ) * _GaoDU ) + ( sin( mulTime232 ) * _ZhengDongFuDu ) ) )));
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 rotatedValue150 = RotateAroundAxis( appendResult37, ase_vertex3Pos, normalize( appendResult37 ), ( ( _XuanZhuanFuDu * temp_output_73_0 ) * UNITY_PI ) );
			v.vertex.xyz += ( appendResult142 + ( rotatedValue150 - ase_vertex3Pos ) );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 color3 = IsGammaSpace() ? float4(1,1,1,1) : float4(1,1,1,1);
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			o.Albedo = ( color3 * tex2D( _MainTex, uv_MainTex ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	//FallBack "Diffuse"
}
