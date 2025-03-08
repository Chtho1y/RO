Shader "RO/RO_Effect_RJ_01"
{
	Properties
	{
		_ColorStr("ColorStr", Float) = 1
		_AlphaSTR("AlphaSTR", Float) = 1
		_MainTex("MainTex", 2D) = "white" {}
		[KeywordEnum(R,G,B,A)] _Keyword2("主贴图使用通道", Float) = 3
		_OpacityTex("MaskTex", 2D) = "white" {}
		_MaskStr("MaskStr", Range( 0 , 1.01)) = 1.01
		_UVspeed("UVspeed", Vector) = (0,0,0,0)
		[KeywordEnum(R,G,B,A)] _Keyword3("遮罩贴图使用通道", Float) = 0
		[Toggle(_KEYWORD0_ON)] _Keyword0("粒子颜色透明度是否影响贴图透明度", Float) = 0
		[Toggle(_KEYWORD1_ON)] _Keyword1("是否使用原图颜色", Float) = 1
		_Color0("Color 0", Color) = (1,1,1,1)
		_Color2("Color2", Color) = (1,1,1,0)
		_ColorMask("渐变颜色控制", Vector) = (0,1,0,1)
		[Enum(UnityEngine.Rendering.BlendMode)]_Src("Src", Float) = 5
		[Enum(UnityEngine.Rendering.BlendMode)]_Dst("Dst", Float) = 10
		[Enum(UnityEngine.Rendering.CullMode)]_CullMode("CullMode", Float) = 0
		[Enum(Off,0,On,1)]_ZWrite("ZWrite", Float) = 1
		[Enum(UnityEngine.Rendering.CompareFunction)]_ZTest("ZTest", Float) = 4
		_Float1("消散边缘软硬度", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IsEmissive" = "true"  "PreviewType"="Plane" }
		Cull [_CullMode]
		ZWrite [_ZWrite]
		ZTest [_ZTest]
		Blend [_Src] [_Dst]
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma shader_feature _KEYWORD1_ON
		#pragma shader_feature _KEYWORD2_R _KEYWORD2_G _KEYWORD2_B _KEYWORD2_A
		#pragma shader_feature _KEYWORD3_R _KEYWORD3_G _KEYWORD3_B _KEYWORD3_A
		#pragma shader_feature _KEYWORD0_ON
		#pragma surface surf Unlit keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float _ZWrite;
		uniform float _ZTest;
		uniform float _CullMode;
		uniform float4 _Color2;
		uniform float4 _Color0;
		uniform sampler2D _MainTex;
		uniform float4 _UVspeed;
		uniform float4 _MainTex_ST;
		uniform sampler2D _OpacityTex;
		uniform float4 _OpacityTex_ST;
		uniform float _MaskStr;
		uniform float _Float1;
		uniform float4 _ColorMask;
		uniform float _Src;
		uniform float _Dst;
		uniform float _ColorStr;
		uniform float _AlphaSTR;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 appendResult65 = (float2(_UVspeed.x , _UVspeed.y));
			float2 uv0_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 panner63 = ( 1.0 * _Time.y * appendResult65 + uv0_MainTex);
			float4 tex2DNode1 = tex2D( _MainTex, panner63 );
			#if defined(_KEYWORD2_R)
				float staticSwitch60 = tex2DNode1.r;
			#elif defined(_KEYWORD2_G)
				float staticSwitch60 = tex2DNode1.g;
			#elif defined(_KEYWORD2_B)
				float staticSwitch60 = tex2DNode1.b;
			#elif defined(_KEYWORD2_A)
				float staticSwitch60 = tex2DNode1.a;
			#else
				float staticSwitch60 = tex2DNode1.a;
			#endif
			float2 appendResult67 = (float2(_UVspeed.z , _UVspeed.w));
			float2 uv0_OpacityTex = i.uv_texcoord * _OpacityTex_ST.xy + _OpacityTex_ST.zw;
			float2 panner68 = ( 1.0 * _Time.y * appendResult67 + uv0_OpacityTex);
			float4 tex2DNode2 = tex2D( _OpacityTex, panner68 );
			#if defined(_KEYWORD3_R)
				float staticSwitch61 = tex2DNode2.r;
			#elif defined(_KEYWORD3_G)
				float staticSwitch61 = tex2DNode2.g;
			#elif defined(_KEYWORD3_B)
				float staticSwitch61 = tex2DNode2.b;
			#elif defined(_KEYWORD3_A)
				float staticSwitch61 = tex2DNode2.a;
			#else
				float staticSwitch61 = tex2DNode2.r;
			#endif
			float4 VertexColor69 = i.vertexColor;
			float temp_output_44_0 = ( 1.0 - ( _MaskStr * (VertexColor69).a ) );
			float clampResult117 = clamp( staticSwitch61 , temp_output_44_0 , 1.0 );
			float lerpResult114 = lerp( (0.0 + (clampResult117 - temp_output_44_0) * (1.0 - 0.0) / (1.0 - temp_output_44_0)) , step( temp_output_44_0 , staticSwitch61 ) , _Float1);
			float temp_output_3_0 = ( staticSwitch60 * lerpResult114 );
			float temp_output_82_0 = max( _ColorMask.x , _ColorMask.y );
			float clampResult79 = clamp( temp_output_3_0 , _ColorMask.x , temp_output_82_0 );
			float4 lerpResult40 = lerp( _Color2 , _Color0 , saturate( (_ColorMask.z + (clampResult79 - _ColorMask.x) * (_ColorMask.w - _ColorMask.z) / (temp_output_82_0 - _ColorMask.x)) ));
			#ifdef _KEYWORD1_ON
				float4 staticSwitch45 = float4( (tex2DNode1).rgb , 0.0 );
			#else
				float4 staticSwitch45 = lerpResult40;
			#endif
			float Src28 = _Src;
			float Dst29 = _Dst;
			#ifdef _KEYWORD0_ON
				float staticSwitch13 = (VertexColor69).a;
			#else
				float staticSwitch13 = 1.0;
			#endif
			o.Emission = ( staticSwitch45 * (( Src28 == Dst29 ) ? temp_output_3_0 :  1.0 ) * _ColorStr * float4( (VertexColor69).rgb , 0.0 ) * (( Src28 == Dst29 ) ? staticSwitch13 :  1.0 ) ).rgb;
			o.Alpha = saturate( ( temp_output_3_0 * _AlphaSTR * staticSwitch13 ) );
		}

		ENDCG
	}
}
