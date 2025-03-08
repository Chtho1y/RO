// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "RO/RO_Effect_JZB_01"
{
	Properties
	{
		[HDR]_Color1("Color 1", Color) = (1,1,1,0)
		[HDR]_Color0("Color 0", Color) = (1,1,1,0)
		_MainTex("MainTex", 2D) = "white" {}
		_MainTexUVLerp("MainTexUVLerp", Range( 0 , 1)) = 1
		_MainTexOffest("MainTexOffest", Vector) = (1,1,0,1)
		_Min("Min", Range( 0 , 4)) = 0
		_Max("Max", Range( 0 , 0.9999)) = 0.9999
		_XiaoSan("XiaoSan", Range( 0 , 1)) = 0
		[Enum(UnityEngine.Rendering.BlendMode)]_Src1("Src", Float) = 5
		[Enum(UnityEngine.Rendering.BlendMode)]_Dst1("Dst", Float) = 10
		[Enum(UnityEngine.Rendering.CullMode)]_CullMode1("CullMode", Float) = 0
		[Enum(Off,0,On,1)]_ZWrite1("ZWrite", Float) = 0
		[Enum(UnityEngine.Rendering.CompareFunction)]_ZTest1("ZTest", Float) = 4
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _tex4coord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IsEmissive" = "true"  }
		Cull [_CullMode1]
		ZWrite [_ZWrite1]
		ZTest [_ZTest1]
		Blend [_Src1] [_Dst1]
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nometa noforwardadd 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float2 uv_texcoord;
			float2 uv2_texcoord2;
			float4 uv_tex4coord;
			float4 vertexColor : COLOR;
		};

		uniform float _ZTest1;
		uniform float _CullMode1;
		uniform float _ZWrite1;
		uniform float _Src1;
		uniform float _Dst1;
		uniform float4 _Color0;
		uniform float4 _Color1;
		uniform sampler2D _MainTex;
		uniform float4 _MainTexOffest;
		uniform float _MainTexUVLerp;
		uniform float _Max;
		uniform float _Min;
		uniform float _XiaoSan;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float Src136 = _Src1;
			float Dst135 = _Dst1;
			float2 appendResult53 = (float2(_MainTexOffest.x , _MainTexOffest.y));
			float2 appendResult54 = (float2(_MainTexOffest.z , 0.0));
			float2 uv_TexCoord22 = i.uv_texcoord * float2( 2,2 );
			float2 temp_output_28_0 = ( uv_TexCoord22 - float2( 1,1 ) );
			float temp_output_25_0 = length( temp_output_28_0 );
			float2 appendResult24 = (float2(frac( ( atan2( (temp_output_28_0).x , (temp_output_28_0).y ) / 6.28318548202515 ) ) , temp_output_25_0));
			float2 panner12 = ( 1.0 * _Time.y * appendResult54 + appendResult24);
			float2 appendResult55 = (float2(0.0 , _MainTexOffest.w));
			float2 panner36 = ( 1.0 * _Time.y * appendResult55 + appendResult24);
			float2 appendResult43 = (float2((panner12).x , (panner36).y));
			float2 appendResult130 = (float2(ceil( i.uv2_texcoord2.x ) , i.uv2_texcoord2.y));
			float2 appendResult64 = (float2(( (appendResult24).x + i.uv_tex4coord.z ) , ( (appendResult24).y + i.uv_tex4coord.w )));
			float2 lerpResult66 = lerp( ( appendResult53 * appendResult43 ) , ( appendResult130 * appendResult64 ) , _MainTexUVLerp);
			float4 tex2DNode1 = tex2D( _MainTex, lerpResult66 );
			float4 lerpResult111 = lerp( _Color0 , _Color1 , tex2DNode1.r);
			float smoothstepResult95 = smoothstep( ( _Max - _Min ) , 1.0 , temp_output_25_0);
			float smoothstepResult97 = smoothstep( 1.0 , _Max , temp_output_25_0);
			float Alpha107 = ( smoothstepResult95 * smoothstepResult97 );
			float temp_output_85_0 = ( i.vertexColor.a * Alpha107 * tex2DNode1.a );
			float temp_output_116_0 = ( temp_output_85_0 * step( _XiaoSan , temp_output_85_0 ) );
			o.Emission = (( Src136 == Dst135 ) ? ( lerpResult111 * i.vertexColor * temp_output_116_0 ) :  ( lerpResult111 * i.vertexColor ) ).rgb;
			o.Alpha = temp_output_116_0;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17500
2221;7;1319;1004;-536.6857;927.0402;1.055423;True;False
Node;AmplifyShaderEditor.Vector2Node;32;-3038.967,78.51233;Float;False;Constant;_Vector1;Vector 1;0;0;Create;True;0;0;False;0;2,2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;23;-2759.278,228.0442;Float;False;Constant;_Vector0;Vector 0;0;0;Create;True;0;0;False;0;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;22;-2838.769,68.17223;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;28;-2533.985,72.31327;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;30;-2324.477,-7.435158;Inherit;False;True;False;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;29;-2324.477,72.56486;Inherit;False;False;True;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TauNode;31;-2075.126,106.0599;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.ATan2OpNode;27;-2079.938,-8.456642;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;26;-1916.307,-5.278969;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;21;-1732.477,72.56486;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;25;-2317.436,254.5432;Inherit;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;52;-1595.901,38.60398;Inherit;False;Property;_MainTexOffest;MainTexOffest;5;0;Create;True;0;0;False;0;1,1,0,1;4,1,0,1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;24;-1601.472,233.8569;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;55;-1123.199,573.1296;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;54;-1123.199,326.7373;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;59;-1156.847,798.2754;Inherit;False;True;False;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;128;-1174.499,1330.44;Inherit;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;65;-1235.73,1044.181;Inherit;False;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;12;-901.0848,306.7202;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;96;-2609.166,744.0491;Inherit;False;Property;_Max;Max;7;0;Create;True;0;0;False;0;0.9999;0.325;0;0.9999;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;99;-2609.845,533.3593;Inherit;False;Property;_Min;Min;6;0;Create;True;0;0;False;0;0;0.31;0;4;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;36;-915.5862,573.8969;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;60;-1159.784,937.3984;Inherit;False;False;True;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CeilOpNode;131;-867.731,1298.378;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;57;-817.0884,801.1854;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;42;-606.1307,555.7703;Inherit;False;False;True;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;41;-600.7129,325.3807;Inherit;False;True;False;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;98;-2264.307,518.0921;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;63;-821.0045,938.3747;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;95;-2027.755,469.1792;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;97;-2030.664,714.0768;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;43;-354.822,368.7235;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;64;-332.2115,762.6263;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;53;-358.5862,246.4722;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;130;-605.8524,1249.84;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;100;-1750.251,474.8065;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;82;-166.7821,523.6427;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;81;-253.0485,890.5829;Inherit;False;Property;_MainTexUVLerp;MainTexUVLerp;3;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-174.6576,255.9015;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;107;-1502.402,672.0391;Inherit;False;Alpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;66;106.9961,393.0761;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;1;385.6782,373.644;Inherit;True;Property;_MainTex;MainTex;2;0;Create;True;0;0;False;0;-1;None;8bad385f773025940a64eb048227e266;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;84;1030.366,282.5245;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;108;377.9737,608.5002;Inherit;False;107;Alpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;115;1227.431,374.8283;Inherit;False;Property;_XiaoSan;XiaoSan;8;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;1266.979,453.9044;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;114;1614.283,434.4233;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;109;326.3995,22.41542;Inherit;False;Property;_Color0;Color 0;1;1;[HDR];Create;True;0;0;False;0;1,1,1,0;0,0.6588235,2.996078,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;110;330.4636,202.0758;Inherit;False;Property;_Color1;Color 1;0;1;[HDR];Create;True;0;0;False;0;1,1,1,0;1.126175,1.513579,1.720795,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;133;1516.366,-551.8785;Inherit;False;Property;_Dst1;Dst;10;1;[Enum];Create;True;0;1;UnityEngine.Rendering.BlendMode;True;0;10;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;134;1516.366,-711.8786;Inherit;False;Property;_Src1;Src;9;1;[Enum];Create;True;0;1;UnityEngine.Rendering.BlendMode;True;0;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;111;1043.893,135.8541;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;116;1831.498,312.4701;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;136;1772.365,-695.8786;Inherit;False;Src;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;135;1788.365,-535.8785;Inherit;False;Dst;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;143;2066.078,57.42452;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;83;2041.271,200.7716;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;140;1958.053,-155.2471;Inherit;False;136;Src;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;141;1981.521,-39.08705;Inherit;False;135;Dst;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;138;1308.366,-711.8786;Inherit;False;Property;_CullMode1;CullMode;11;1;[Enum];Create;True;0;1;UnityEngine.Rendering.CullMode;True;0;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;137;1148.366,-711.8786;Inherit;False;Property;_ZTest1;ZTest;13;1;[Enum];Create;True;0;1;UnityEngine.Rendering.CompareFunction;True;0;4;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCCompareEqual;142;2253.488,11.44466;Inherit;False;4;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;139;972.3655,-711.8786;Inherit;False;Property;_ZWrite1;ZWrite;12;1;[Enum];Create;True;2;Off;0;On;1;0;True;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2593.044,90.92058;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;RO/RO_Effect_JZB_01;False;False;False;False;True;True;True;True;True;False;True;True;False;False;False;False;False;False;False;False;False;Back;2;True;139;0;True;137;False;0;False;-1;0;False;-1;False;0;Custom;0.12;True;False;0;True;Custom;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;True;134;10;True;133;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;4;-1;-1;-1;0;False;0;0;True;138;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;22;0;32;0
WireConnection;28;0;22;0
WireConnection;28;1;23;0
WireConnection;30;0;28;0
WireConnection;29;0;28;0
WireConnection;27;0;30;0
WireConnection;27;1;29;0
WireConnection;26;0;27;0
WireConnection;26;1;31;0
WireConnection;21;0;26;0
WireConnection;25;0;28;0
WireConnection;24;0;21;0
WireConnection;24;1;25;0
WireConnection;55;1;52;4
WireConnection;54;0;52;3
WireConnection;59;0;24;0
WireConnection;12;0;24;0
WireConnection;12;2;54;0
WireConnection;36;0;24;0
WireConnection;36;2;55;0
WireConnection;60;0;24;0
WireConnection;131;0;128;1
WireConnection;57;0;59;0
WireConnection;57;1;65;3
WireConnection;42;0;36;0
WireConnection;41;0;12;0
WireConnection;98;0;96;0
WireConnection;98;1;99;0
WireConnection;63;0;60;0
WireConnection;63;1;65;4
WireConnection;95;0;25;0
WireConnection;95;1;98;0
WireConnection;97;0;25;0
WireConnection;97;2;96;0
WireConnection;43;0;41;0
WireConnection;43;1;42;0
WireConnection;64;0;57;0
WireConnection;64;1;63;0
WireConnection;53;0;52;1
WireConnection;53;1;52;2
WireConnection;130;0;131;0
WireConnection;130;1;128;2
WireConnection;100;0;95;0
WireConnection;100;1;97;0
WireConnection;82;0;130;0
WireConnection;82;1;64;0
WireConnection;49;0;53;0
WireConnection;49;1;43;0
WireConnection;107;0;100;0
WireConnection;66;0;49;0
WireConnection;66;1;82;0
WireConnection;66;2;81;0
WireConnection;1;1;66;0
WireConnection;85;0;84;4
WireConnection;85;1;108;0
WireConnection;85;2;1;4
WireConnection;114;0;115;0
WireConnection;114;1;85;0
WireConnection;111;0;109;0
WireConnection;111;1;110;0
WireConnection;111;2;1;1
WireConnection;116;0;85;0
WireConnection;116;1;114;0
WireConnection;136;0;134;0
WireConnection;135;0;133;0
WireConnection;143;0;111;0
WireConnection;143;1;84;0
WireConnection;143;2;116;0
WireConnection;83;0;111;0
WireConnection;83;1;84;0
WireConnection;142;0;140;0
WireConnection;142;1;141;0
WireConnection;142;2;143;0
WireConnection;142;3;83;0
WireConnection;0;2;142;0
WireConnection;0;9;116;0
ASEEND*/
//CHKSM=AD90E7B32B5136DA80103D617B7CCAA59001AFE1