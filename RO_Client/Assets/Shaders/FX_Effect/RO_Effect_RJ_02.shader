// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "RO/RO_Effect_RJ_02"
{
	Properties
	{
		_STR("STR", Float) = 1
		_UV1("UV1", Vector) = (1,1,0.04,-0.26)
		_MainTex1("MainTex1", 2D) = "white" {}
		_UV2("UV2", Vector) = (1,1,0.04,-0.26)
		_MainTex2("MainTex2", 2D) = "white" {}
		_Color1("Color 1", Color) = (0,0,0,0)
		_Color0("Color 0", Color) = (0,0,0,0)
		_WQ("外圈范围", Vector) = (0.56,1,0,1)
		[Enum(UnityEngine.Rendering.CullMode)]_CullMode("CullMode", Float) = 0
		[Enum(UnityEngine.Rendering.BlendMode)]_Src("Src", Float) = 5
		[Enum(UnityEngine.Rendering.BlendMode)]_Dst("Dst", Float) = 10
		[Enum(On,0,Off,1)]_ZWrite("ZWrite", Float) = 0
		[Enum(UnityEngine.Rendering.CompareFunction)]_ZTest("ZTest", Float) = 4
		_MaskStr("MaskStr", Range( 0 , 1)) = 0
		_LerpStr("颜色分割", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IsEmissive" = "true"  }
		Cull [_CullMode]
		ZWrite [_ZWrite]
		ZTest [_ZTest]
		Blend [_Src] [_Dst]
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float _MaskStr;
		uniform float _ZTest;
		uniform float _CullMode;
		uniform float _ZWrite;
		uniform float _STR;
		uniform float4 _Color0;
		uniform float4 _Color1;
		uniform float _LerpStr;
		uniform sampler2D _MainTex1;
		uniform sampler2D _Sampler603;
		uniform float4 _UV1;
		uniform sampler2D _MainTex2;
		uniform sampler2D _Sampler6017;
		uniform float4 _UV2;
		uniform float4 _WQ;
		uniform float _Src;
		uniform float _Dst;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 temp_output_1_0_g5 = float2( 1,1 );
			float2 appendResult10_g5 = (float2(( (temp_output_1_0_g5).x * i.uv_texcoord.x ) , ( i.uv_texcoord.y * (temp_output_1_0_g5).y )));
			float2 temp_output_11_0_g5 = float2( 0,0 );
			float2 panner18_g5 = ( ( (temp_output_11_0_g5).x * _Time.y ) * float2( 1,0 ) + i.uv_texcoord);
			float2 panner19_g5 = ( ( _Time.y * (temp_output_11_0_g5).y ) * float2( 0,1 ) + i.uv_texcoord);
			float2 appendResult24_g5 = (float2((panner18_g5).x , (panner19_g5).y));
			float2 appendResult6 = (float2(_UV1.x , _UV1.y));
			float2 appendResult7 = (float2(_UV1.z , _UV1.w));
			float2 temp_output_47_0_g5 = appendResult7;
			float2 uv_TexCoord78_g5 = i.uv_texcoord * float2( 2,2 );
			float2 temp_output_31_0_g5 = ( uv_TexCoord78_g5 - float2( 1,1 ) );
			float2 appendResult39_g5 = (float2(frac( ( atan2( (temp_output_31_0_g5).x , (temp_output_31_0_g5).y ) / 6.28318548202515 ) ) , length( temp_output_31_0_g5 )));
			float2 panner54_g5 = ( ( (temp_output_47_0_g5).x * _Time.y ) * float2( 1,0 ) + appendResult39_g5);
			float2 panner55_g5 = ( ( _Time.y * (temp_output_47_0_g5).y ) * float2( 0,1 ) + appendResult39_g5);
			float2 appendResult58_g5 = (float2((panner54_g5).x , (panner55_g5).y));
			float4 tex2DNode4 = tex2D( _MainTex1, ( ( (tex2D( _Sampler603, ( appendResult10_g5 + appendResult24_g5 ) )).rg * 1.0 ) + ( appendResult6 * appendResult58_g5 ) ) );
			float2 temp_output_1_0_g4 = float2( 1,1 );
			float2 appendResult10_g4 = (float2(( (temp_output_1_0_g4).x * i.uv_texcoord.x ) , ( i.uv_texcoord.y * (temp_output_1_0_g4).y )));
			float2 temp_output_11_0_g4 = float2( 0,0 );
			float2 panner18_g4 = ( ( (temp_output_11_0_g4).x * _Time.y ) * float2( 1,0 ) + i.uv_texcoord);
			float2 panner19_g4 = ( ( _Time.y * (temp_output_11_0_g4).y ) * float2( 0,1 ) + i.uv_texcoord);
			float2 appendResult24_g4 = (float2((panner18_g4).x , (panner19_g4).y));
			float2 appendResult15 = (float2(_UV2.x , _UV2.y));
			float2 appendResult16 = (float2(_UV2.z , _UV2.w));
			float2 temp_output_47_0_g4 = appendResult16;
			float2 uv_TexCoord78_g4 = i.uv_texcoord * float2( 2,2 );
			float2 temp_output_31_0_g4 = ( uv_TexCoord78_g4 - float2( 1,1 ) );
			float2 appendResult39_g4 = (float2(frac( ( atan2( (temp_output_31_0_g4).x , (temp_output_31_0_g4).y ) / 6.28318548202515 ) ) , length( temp_output_31_0_g4 )));
			float2 panner54_g4 = ( ( (temp_output_47_0_g4).x * _Time.y ) * float2( 1,0 ) + appendResult39_g4);
			float2 panner55_g4 = ( ( _Time.y * (temp_output_47_0_g4).y ) * float2( 0,1 ) + appendResult39_g4);
			float2 appendResult58_g4 = (float2((panner54_g4).x , (panner55_g4).y));
			float4 tex2DNode18 = tex2D( _MainTex2, ( ( (tex2D( _Sampler6017, ( appendResult10_g4 + appendResult24_g4 ) )).rg * 1.0 ) + ( appendResult15 * appendResult58_g4 ) ) );
			float temp_output_23_0 = distance( i.uv_texcoord , float2( 0.5,0.5 ) );
			float smoothstepResult71 = smoothstep( _WQ.x , _WQ.y , ( 1.0 - temp_output_23_0 ));
			float smoothstepResult73 = smoothstep( _WQ.z , _WQ.w , temp_output_23_0);
			float temp_output_58_0 = saturate( ( ( min( min( min( tex2DNode4.r , tex2DNode4.g ) , tex2DNode4.b ) , tex2DNode4.a ) * min( min( min( tex2DNode18.r , tex2DNode18.g ) , tex2DNode18.b ) , tex2DNode18.a ) ) * saturate( min( smoothstepResult71 , smoothstepResult73 ) ) ) );
			float4 lerpResult31 = lerp( _Color0 , _Color1 , saturate( ( _LerpStr * temp_output_58_0 ) ));
			float Src110 = _Src;
			float Dst111 = _Dst;
			float temp_output_64_0 = ( i.vertexColor.a * temp_output_58_0 );
			o.Emission = ( _STR * lerpResult31 * i.vertexColor * (( Src110 == Dst111 ) ? temp_output_64_0 :  1.0 ) ).rgb;
			o.Alpha = temp_output_64_0;
			clip( temp_output_64_0 - _MaskStr );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17500
2295;0;1535;1010;-179.4911;996.7488;2.287895;True;False
Node;AmplifyShaderEditor.Vector4Node;5;-1153.83,316.7682;Inherit;False;Property;_UV1;UV1;1;0;Create;True;0;0;False;0;1,1,0.04,-0.26;1,0.39,-0.15,0.16;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;14;-1111.458,794.7524;Inherit;False;Property;_UV2;UV2;3;0;Create;True;0;0;False;0;1,1,0.04,-0.26;2,0.66,-0.1,-0.31;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;16;-778.1451,901.5529;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;15;-775.1451,747.5532;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;6;-790.5001,289.8319;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;7;-793.5001,443.8317;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;21;-1465.889,1085.106;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;17;-598.2081,727.3867;Inherit;True;RadialUVDistortion;-1;;4;051d65e7699b41a4c800363fd0e822b2;0;7;60;SAMPLER2D;_Sampler6017;False;1;FLOAT2;1,1;False;11;FLOAT2;0,0;False;65;FLOAT;1;False;68;FLOAT2;1,1;False;47;FLOAT2;1,1;False;29;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;3;-613.5632,269.6653;Inherit;True;RadialUVDistortion;-1;;5;051d65e7699b41a4c800363fd0e822b2;0;7;60;SAMPLER2D;_Sampler603;False;1;FLOAT2;1,1;False;11;FLOAT2;0,0;False;65;FLOAT;1;False;68;FLOAT2;1,1;False;47;FLOAT2;1,1;False;29;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;4;-77.40006,276.032;Inherit;True;Property;_MainTex1;MainTex1;2;0;Create;True;0;0;False;0;-1;919b5398786543842b264a03cf979db4;cd460ee4ac5c1e746b7a734cc7cc64dd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;18;-67.91396,715.031;Inherit;True;Property;_MainTex2;MainTex2;4;0;Create;True;0;0;False;0;-1;None;0bbb4e90183d6164daf133a2392fbd95;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DistanceOpNode;23;-1141.952,1076.785;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;45;-1121.155,1366.848;Inherit;False;Property;_WQ;外圈范围;7;0;Create;False;0;0;False;0;0.56,1,0,1;0.53,1,0,0.15;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMinOpNode;120;228.9917,278.2388;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;24;-851.8445,1062.609;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMinOpNode;123;249.399,727.6429;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMinOpNode;121;350.2137,311.4512;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;73;-559.4363,1365.618;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;71;-576.9506,1086.962;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMinOpNode;124;370.621,760.8553;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMinOpNode;122;527.2137,361.4512;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMinOpNode;55;-206.978,1177.327;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMinOpNode;125;547.621,810.8553;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;115;706.9133,435.067;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;60;77.0567,1090.7;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;62;901.3251,480.0853;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;126;959.2203,350.6269;Inherit;False;Property;_LerpStr;颜色分割;14;0;Create;False;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;58;1116.432,468.3717;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;67;1328,-160;Inherit;False;Property;_Dst;Dst;10;1;[Enum];Create;True;0;1;UnityEngine.Rendering.BlendMode;True;0;10;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;68;1328,-288;Inherit;False;Property;_Src;Src;9;1;[Enum];Create;True;0;1;UnityEngine.Rendering.BlendMode;True;0;5;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;127;1222.751,191.5069;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;63;1381.41,261.8916;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;111;1568,-160;Inherit;False;Dst;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;110;1568,-272;Inherit;False;Src;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;32;896.9216,-83.60907;Inherit;False;Property;_Color0;Color 0;6;0;Create;True;0;0;False;0;0,0,0,0;0.2311321,0.4693727,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;128;1434.861,152.0647;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;33;908.5346,136.8107;Inherit;False;Property;_Color1;Color 1;5;0;Create;True;0;0;False;0;0,0,0,0;0.9764151,0.9910285,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;113;1583.155,375.0856;Inherit;False;110;Src;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;114;1583.155,453.0856;Inherit;False;111;Dst;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;1619.385,559.3456;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCCompareEqual;76;1824,448;Inherit;False;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;31;1640.901,14.20487;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;57;1980.829,99.23615;Inherit;False;Property;_STR;STR;0;0;Create;True;0;0;False;0;1;8.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;109;2200.069,596.3041;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;103;1920,-448;Inherit;False;Property;_MaskStr;MaskStr;13;0;Create;True;0;0;True;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;66;1696,-432;Inherit;False;Property;_CullMode;CullMode;8;1;[Enum];Create;True;0;1;UnityEngine.Rendering.CullMode;True;0;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;70;1312,-432;Inherit;False;Property;_ZWrite;ZWrite;11;1;[Enum];Create;True;2;On;0;Off;1;0;True;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;69;1504,-432;Inherit;False;Property;_ZTest;ZTest;12;1;[Enum];Create;True;0;1;UnityEngine.Rendering.CompareFunction;True;0;4;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;78;2152.869,560.4601;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;2194.29,158.9914;Inherit;False;4;4;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2540.445,138.211;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;RO/RO_Effect_RJ_02;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;Back;2;True;70;3;True;69;False;0;False;-1;0;False;-1;False;0;Custom;0;True;False;0;True;Custom;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;True;68;10;True;67;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;True;66;-1;0;True;103;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;16;0;14;3
WireConnection;16;1;14;4
WireConnection;15;0;14;1
WireConnection;15;1;14;2
WireConnection;6;0;5;1
WireConnection;6;1;5;2
WireConnection;7;0;5;3
WireConnection;7;1;5;4
WireConnection;17;68;15;0
WireConnection;17;47;16;0
WireConnection;3;68;6;0
WireConnection;3;47;7;0
WireConnection;4;1;3;0
WireConnection;18;1;17;0
WireConnection;23;0;21;0
WireConnection;120;0;4;1
WireConnection;120;1;4;2
WireConnection;24;0;23;0
WireConnection;123;0;18;1
WireConnection;123;1;18;2
WireConnection;121;0;120;0
WireConnection;121;1;4;3
WireConnection;73;0;23;0
WireConnection;73;1;45;3
WireConnection;73;2;45;4
WireConnection;71;0;24;0
WireConnection;71;1;45;1
WireConnection;71;2;45;2
WireConnection;124;0;123;0
WireConnection;124;1;18;3
WireConnection;122;0;121;0
WireConnection;122;1;4;4
WireConnection;55;0;71;0
WireConnection;55;1;73;0
WireConnection;125;0;124;0
WireConnection;125;1;18;4
WireConnection;115;0;122;0
WireConnection;115;1;125;0
WireConnection;60;0;55;0
WireConnection;62;0;115;0
WireConnection;62;1;60;0
WireConnection;58;0;62;0
WireConnection;127;0;126;0
WireConnection;127;1;58;0
WireConnection;111;0;67;0
WireConnection;110;0;68;0
WireConnection;128;0;127;0
WireConnection;64;0;63;4
WireConnection;64;1;58;0
WireConnection;76;0;113;0
WireConnection;76;1;114;0
WireConnection;76;2;64;0
WireConnection;31;0;32;0
WireConnection;31;1;33;0
WireConnection;31;2;128;0
WireConnection;109;0;64;0
WireConnection;78;0;64;0
WireConnection;56;0;57;0
WireConnection;56;1;31;0
WireConnection;56;2;63;0
WireConnection;56;3;76;0
WireConnection;0;2;56;0
WireConnection;0;9;78;0
WireConnection;0;10;109;0
ASEEND*/
//CHKSM=E7A4AD094D0E80C7A97E29F39390683E9910C257