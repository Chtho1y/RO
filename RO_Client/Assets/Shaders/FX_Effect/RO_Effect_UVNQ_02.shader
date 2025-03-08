// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "RO/RO_Effect_UVNQ_02"
{
	Properties
	{
		_ColorStr("ColorStr", Float) = 1
		_AlphaStr("AlphaStr", Float) = 1
		_MainTex("主帖图", 2D) = "white" {}
		[KeywordEnum(R,G,B,A)] _RGBA1("透明通道选择", Float) = 3
		_UVspeed("UVspeed", Vector) = (0,0,0,0)
		[Toggle(_KEYWORD1_ON)] _Keyword1("是否使用原始图片颜色", Float) = 1
		[KeywordEnum(R,G,B,A)] _RGBA("混合颜色通道选择", Float) = 3
		[KeywordEnum(R,G,B,A)] _RGBA2("扭曲通道选择", Float) = 3
		[HDR]_Color_A("混合色A", Color) = (1,1,1,1)
		[HDR]_Color_B("混合色B", Color) = (1,1,1,1)
		_Vector0("颜色控制", Vector) = (0,1,0,1)
		[Enum(UnityEngine.Rendering.BlendMode)]_Src("Src", Float) = 5
		[Enum(UnityEngine.Rendering.BlendMode)]_Dst("Dst", Float) = 10
		[Enum(UnityEngine.Rendering.CullMode)]_CullMode("CullMode", Float) = 0
		[Enum(Off,0,On,1)]_ZWrite("ZWrite", Float) = 0
		[Enum(UnityEngine.Rendering.CompareFunction)]_ZTest("ZTest", Float) = 4
		_NQTex("NQTex", 2D) = "white" {}
		_Float0("扭曲强度", Range( 0 , 1)) = 0
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
		#pragma shader_feature _RGBA_R _RGBA_G _RGBA_B _RGBA_A
		#pragma shader_feature _RGBA2_R _RGBA2_G _RGBA2_B _RGBA2_A
		#pragma shader_feature _RGBA1_R _RGBA1_G _RGBA1_B _RGBA1_A
		#pragma surface surf Unlit keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nometa noforwardadd 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float _ZTest;
		uniform float _CullMode;
		uniform float _ZWrite;
		uniform float _Src;
		uniform float _Dst;
		uniform float4 _Color_B;
		uniform float4 _Color_A;
		uniform sampler2D _MainTex;
		uniform float4 _UVspeed;
		uniform float4 _MainTex_ST;
		uniform sampler2D _NQTex;
		uniform float4 _NQTex_ST;
		uniform float _Float0;
		uniform float4 _Vector0;
		uniform float _ColorStr;
		uniform float _AlphaStr;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float Src35 = _Src;
			float Dst36 = _Dst;
			float2 appendResult31 = (float2(_UVspeed.x , _UVspeed.y));
			float2 uv0_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 panner27 = ( 1.0 * _Time.y * appendResult31 + uv0_MainTex);
			float2 appendResult52 = (float2(_UVspeed.z , _UVspeed.w));
			float2 uv0_NQTex = i.uv_texcoord * _NQTex_ST.xy + _NQTex_ST.zw;
			float2 panner53 = ( 1.0 * _Time.y * appendResult52 + uv0_NQTex);
			float4 tex2DNode46 = tex2D( _NQTex, panner53 );
			#if defined(_RGBA2_R)
				float staticSwitch48 = tex2DNode46.r;
			#elif defined(_RGBA2_G)
				float staticSwitch48 = tex2DNode46.g;
			#elif defined(_RGBA2_B)
				float staticSwitch48 = tex2DNode46.b;
			#elif defined(_RGBA2_A)
				float staticSwitch48 = tex2DNode46.a;
			#else
				float staticSwitch48 = tex2DNode46.a;
			#endif
			float4 tex2DNode2 = tex2D( _MainTex, ( panner27 + ( staticSwitch48 * _Float0 ) ) );
			#if defined(_RGBA_R)
				float staticSwitch24 = tex2DNode2.r;
			#elif defined(_RGBA_G)
				float staticSwitch24 = tex2DNode2.g;
			#elif defined(_RGBA_B)
				float staticSwitch24 = tex2DNode2.b;
			#elif defined(_RGBA_A)
				float staticSwitch24 = tex2DNode2.a;
			#else
				float staticSwitch24 = tex2DNode2.a;
			#endif
			float clampResult44 = clamp( staticSwitch24 , _Vector0.x , _Vector0.y );
			float4 lerpResult10 = lerp( _Color_B , _Color_A , saturate( (_Vector0.z + (clampResult44 - _Vector0.x) * (_Vector0.w - _Vector0.z) / (_Vector0.y - _Vector0.x)) ));
			#ifdef _KEYWORD1_ON
				float4 staticSwitch25 = tex2DNode2;
			#else
				float4 staticSwitch25 = lerpResult10;
			#endif
			float4 temp_output_6_0 = ( staticSwitch25 * i.vertexColor * _ColorStr );
			#if defined(_RGBA1_R)
				float staticSwitch41 = tex2DNode2.r;
			#elif defined(_RGBA1_G)
				float staticSwitch41 = tex2DNode2.g;
			#elif defined(_RGBA1_B)
				float staticSwitch41 = tex2DNode2.b;
			#elif defined(_RGBA1_A)
				float staticSwitch41 = tex2DNode2.a;
			#else
				float staticSwitch41 = tex2DNode2.a;
			#endif
			float temp_output_21_0 = saturate( ( staticSwitch41 * i.vertexColor.a * _AlphaStr ) );
			o.Emission = ( Src35 == Dst36 ? ( temp_output_6_0 * temp_output_21_0 ) : temp_output_6_0 ).rgb;
			o.Alpha = temp_output_21_0;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18100
1927;1;1650;1010;422.9674;341.1942;1.42839;True;False
Node;AmplifyShaderEditor.Vector4Node;30;-3679.695,-97.36927;Inherit;False;Property;_UVspeed;UVspeed;4;0;Create;True;0;0;False;0;False;0,0,0,0;0,2,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;52;-3456.902,231.8947;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;51;-3458.448,88.07587;Inherit;False;0;46;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;53;-3187.822,170.0372;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;46;-2988.027,144.5536;Inherit;True;Property;_NQTex;NQTex;17;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;31;-2843.578,-87.74313;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;26;-3090.188,-247.1595;Inherit;False;0;2;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;49;-2858.321,386.1903;Inherit;False;Property;_Float0;扭曲强度;18;0;Create;False;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;48;-2674.901,159.4806;Inherit;False;Property;_RGBA2;扭曲通道选择;7;0;Create;False;0;0;False;0;False;0;3;3;True;;KeywordEnum;4;R;G;B;A;Create;False;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;-2457.497,182.7711;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;27;-2670.568,-239.7831;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;50;-2176.593,-7.998428;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;2;-1914.491,-77.23545;Inherit;True;Property;_MainTex;主帖图;2;0;Create;False;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;24;-1338.613,-293.065;Inherit;False;Property;_RGBA;混合颜色通道选择;6;0;Create;False;0;0;False;0;False;0;3;3;True;;KeywordEnum;4;R;G;B;A;Create;False;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;42;-1328.682,-141.9242;Inherit;False;Property;_Vector0;颜色控制;10;0;Create;False;0;0;False;0;False;0,1,0,1;0,0.5,0,1.74;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;44;-1061.682,-280.9242;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;43;-901.4377,-289.3616;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;45;-728.5446,-277.5253;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;12;-1348.25,-487.1304;Inherit;False;Property;_Color_A;混合色A;8;1;[HDR];Create;False;0;0;False;0;False;1,1,1,1;0.6382346,0.2235294,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;13;-1353.482,-677.6719;Inherit;False;Property;_Color_B;混合色B;9;1;[HDR];Create;False;0;0;False;0;False;1,1,1,1;0.05166671,0,0.6784314,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;22;-906.5184,476.4466;Inherit;False;Property;_AlphaStr;AlphaStr;1;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;41;-1335.224,110.0692;Inherit;False;Property;_RGBA1;透明通道选择;3;0;Create;False;0;0;False;0;False;0;3;3;True;;KeywordEnum;4;R;G;B;A;Create;False;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;10;-569.0887,-362.3988;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;8;-1325.058,318.8527;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;23;-298.4626,122.5226;Inherit;False;Property;_ColorStr;ColorStr;0;0;Create;True;0;0;False;0;False;1;4.86;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;118.2787,-768.6063;Inherit;False;Property;_Src;Src;11;1;[Enum];Create;True;0;1;UnityEngine.Rendering.BlendMode;True;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;116.1798,-609.2338;Inherit;False;Property;_Dst;Dst;12;1;[Enum];Create;True;0;1;UnityEngine.Rendering.BlendMode;True;0;False;10;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-426.2298,239.7148;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;25;-368.6535,-216.3698;Inherit;False;Property;_Keyword1;是否使用原始图片颜色;5;0;Create;False;0;0;False;0;False;0;1;1;True;;Toggle;2;Key0;Key1;Create;False;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;35;377.29,-761.6071;Inherit;False;Src;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-76.81242,-23.39552;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;36;386.8782,-599.9767;Inherit;False;Dst;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;21;-240.831,244.8913;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;37;208.8111,-116.4555;Inherit;False;36;Dst;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;182.2611,45.04154;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;38;208.8111,-247.9514;Inherit;False;35;Src;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-97.98126,-774.0619;Inherit;False;Property;_CullMode;CullMode;13;1;[Enum];Create;True;0;1;UnityEngine.Rendering.CullMode;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-425.9813,-777.0619;Inherit;False;Property;_ZWrite;ZWrite;14;1;[Enum];Create;True;2;On;0;Off;1;0;True;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Compare;19;499.1458,-88.19511;Inherit;False;0;4;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-249.9812,-777.0619;Inherit;False;Property;_ZTest;ZTest;15;1;[Enum];Create;True;0;1;UnityEngine.Rendering.CompareFunction;True;0;False;4;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1401.203,-55.67346;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;RO/RO_Effect_UVNQ_02;False;False;False;False;True;True;True;True;True;False;True;True;False;False;False;False;False;False;False;False;False;Off;2;True;16;0;True;14;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Custom;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;4;1;True;17;1;True;18;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;16;-1;-1;-1;1;PreviewType=Plane;False;0;0;True;15;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;52;0;30;3
WireConnection;52;1;30;4
WireConnection;53;0;51;0
WireConnection;53;2;52;0
WireConnection;46;1;53;0
WireConnection;31;0;30;1
WireConnection;31;1;30;2
WireConnection;48;1;46;1
WireConnection;48;0;46;2
WireConnection;48;2;46;3
WireConnection;48;3;46;4
WireConnection;47;0;48;0
WireConnection;47;1;49;0
WireConnection;27;0;26;0
WireConnection;27;2;31;0
WireConnection;50;0;27;0
WireConnection;50;1;47;0
WireConnection;2;1;50;0
WireConnection;24;1;2;1
WireConnection;24;0;2;2
WireConnection;24;2;2;3
WireConnection;24;3;2;4
WireConnection;44;0;24;0
WireConnection;44;1;42;1
WireConnection;44;2;42;2
WireConnection;43;0;44;0
WireConnection;43;1;42;1
WireConnection;43;2;42;2
WireConnection;43;3;42;3
WireConnection;43;4;42;4
WireConnection;45;0;43;0
WireConnection;41;1;2;1
WireConnection;41;0;2;2
WireConnection;41;2;2;3
WireConnection;41;3;2;4
WireConnection;10;0;13;0
WireConnection;10;1;12;0
WireConnection;10;2;45;0
WireConnection;7;0;41;0
WireConnection;7;1;8;4
WireConnection;7;2;22;0
WireConnection;25;1;10;0
WireConnection;25;0;2;0
WireConnection;35;0;17;0
WireConnection;6;0;25;0
WireConnection;6;1;8;0
WireConnection;6;2;23;0
WireConnection;36;0;18;0
WireConnection;21;0;7;0
WireConnection;9;0;6;0
WireConnection;9;1;21;0
WireConnection;19;0;38;0
WireConnection;19;1;37;0
WireConnection;19;2;9;0
WireConnection;19;3;6;0
WireConnection;0;2;19;0
WireConnection;0;9;21;0
ASEEND*/
//CHKSM=D6229A45BE3B5B82453730D17FA8F7B02DABFF90