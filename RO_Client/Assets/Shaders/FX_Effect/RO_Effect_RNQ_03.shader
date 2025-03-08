// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "RO/RO_Effect_RNQ_03"
{
	Properties
	{
		_Speed("Speed", Range( 0 , 100)) = 3.2
		_Offset("Offset", Range( 0 , 1)) = 0.5781077
		_Str("Str", Float) = 0
		_1("1", Float) = 0.01
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		GrabPass{ }
		CGPROGRAM
		#pragma target 3.0
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		#pragma surface surf Unlit keepalpha noshadow 
		struct Input
		{
			float4 screenPos;
			float2 uv_texcoord;
		};

		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform float _Offset;
		uniform float _Speed;
		uniform float _Str;
		uniform float _1;


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float2 temp_cast_0 = (_Speed).xx;
			float2 appendResult65 = (float2(-0.5 , -0.5));
			float2 uv_TexCoord1 = i.uv_texcoord * temp_cast_0 + ( _Speed * appendResult65 );
			float smoothstepResult67 = smoothstep( _Offset , 1.0 , distance( uv_TexCoord1 , float2( 0,0 ) ));
			float temp_output_69_0 = ( smoothstepResult67 * ( 1.0 - smoothstepResult67 ) * _Str );
			float2 temp_cast_1 = (_Speed).xx;
			float fffff79 = ( 1.0 - _Offset );
			float temp_output_51_0 = ( -0.5 + ( ( 1.0 / _Speed ) * _1 * fffff79 ) );
			float2 appendResult48 = (float2(temp_output_51_0 , -0.5));
			float2 uv_TexCoord73 = i.uv_texcoord * temp_cast_1 + ( _Speed * appendResult48 );
			float smoothstepResult20 = smoothstep( _Offset , 1.0 , distance( uv_TexCoord73 , float2( 0,0 ) ));
			float3 appendResult58 = (float3(1.0 , 0.0 , ( temp_output_69_0 - ( smoothstepResult20 * ( 1.0 - smoothstepResult20 ) * _Str ) )));
			float2 temp_cast_2 = (_Speed).xx;
			float2 appendResult49 = (float2(-0.5 , temp_output_51_0));
			float2 uv_TexCoord74 = i.uv_texcoord * temp_cast_2 + ( _Speed * appendResult49 );
			float smoothstepResult43 = smoothstep( _Offset , 1.0 , distance( uv_TexCoord74 , float2( 0,0 ) ));
			float3 appendResult59 = (float3(0.0 , 1.0 , ( temp_output_69_0 - ( smoothstepResult43 * ( 1.0 - smoothstepResult43 ) * _Str ) )));
			float4 screenColor34 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( ase_grabScreenPosNorm + float4( cross( appendResult58 , appendResult59 ) , 0.0 ) ).xy);
			o.Emission = screenColor34.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18500
2005;7;1650;1004;2328.322;411.4687;1;True;True
Node;AmplifyShaderEditor.RangedFloatNode;21;-589.6324,255.1956;Inherit;False;Property;_Offset;Offset;2;0;Create;True;0;0;False;0;False;0.5781077;0.373;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;81;-245.7189,258.3738;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-1795.578,-236.9289;Inherit;False;Property;_Speed;Speed;1;0;Create;True;0;0;False;0;False;3.2;5.4;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;79;-109.9094,227.5732;Inherit;False;fffff;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;75;-1461.239,-64.45374;Inherit;False;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-1737.266,324.2023;Inherit;False;Property;_1;1;4;0;Create;True;0;0;False;0;False;0.01;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;80;-1635.909,475.5732;Inherit;False;79;fffff;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;-1434.239,287.5463;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;47;-1560.878,173.6387;Inherit;False;Constant;_Float1;Float 1;3;0;Create;True;0;0;False;0;False;-0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;51;-1296.063,248.7188;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;49;-1113.331,345.8481;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;65;-1176.494,-37.92136;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;48;-1138.793,175.8938;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-951.1259,139.9887;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;-998.4551,-53.33087;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-916.9218,370.2143;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;74;-741.2618,375.3125;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-859.7894,-208.0433;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;73;-738.2618,54.3125;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DistanceOpNode;62;-452.5575,-237.8243;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;3;-458.2534,0.2597046;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;42;-441.0262,400.0504;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;20;-142.4214,40.26277;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;67;-160.466,-228.1805;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;43;-142.8154,414.501;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;44;164.5911,594.4781;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;68;85.99695,-89.54529;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;82;97.00881,354.9985;Inherit;False;Property;_Str;Str;3;0;Create;True;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;18;134.7259,123.7019;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;406.8985,47.48315;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;435.9018,393.048;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;407.2787,-224.8798;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;53;754.7963,-57.30751;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;55;720.3118,308.0491;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;58;1071.317,128.7187;Inherit;True;FLOAT3;4;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;59;1093.024,361.9198;Inherit;True;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GrabScreenPosition;35;1701.423,-318.494;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CrossProductOpNode;71;1471.249,187.7253;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;36;2026.028,-103.9768;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ScreenColorNode;34;2275.532,-102.2507;Inherit;False;Global;_GrabScreen0;Grab Screen 0;1;0;Create;True;0;0;False;0;False;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2502.307,-147.8704;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;RO/RO_Effect_RNQ_03;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Custom;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;1;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;81;0;21;0
WireConnection;79;0;81;0
WireConnection;75;1;13;0
WireConnection;76;0;75;0
WireConnection;76;1;50;0
WireConnection;76;2;80;0
WireConnection;51;0;47;0
WireConnection;51;1;76;0
WireConnection;49;0;47;0
WireConnection;49;1;51;0
WireConnection;65;0;47;0
WireConnection;65;1;47;0
WireConnection;48;0;51;0
WireConnection;48;1;47;0
WireConnection;15;0;13;0
WireConnection;15;1;48;0
WireConnection;66;0;13;0
WireConnection;66;1;65;0
WireConnection;39;0;13;0
WireConnection;39;1;49;0
WireConnection;74;0;13;0
WireConnection;74;1;39;0
WireConnection;1;0;13;0
WireConnection;1;1;66;0
WireConnection;73;0;13;0
WireConnection;73;1;15;0
WireConnection;62;0;1;0
WireConnection;3;0;73;0
WireConnection;42;0;74;0
WireConnection;20;0;3;0
WireConnection;20;1;21;0
WireConnection;67;0;62;0
WireConnection;67;1;21;0
WireConnection;43;0;42;0
WireConnection;43;1;21;0
WireConnection;44;0;43;0
WireConnection;68;0;67;0
WireConnection;18;0;20;0
WireConnection;19;0;20;0
WireConnection;19;1;18;0
WireConnection;19;2;82;0
WireConnection;45;0;43;0
WireConnection;45;1;44;0
WireConnection;45;2;82;0
WireConnection;69;0;67;0
WireConnection;69;1;68;0
WireConnection;69;2;82;0
WireConnection;53;0;69;0
WireConnection;53;1;19;0
WireConnection;55;0;69;0
WireConnection;55;1;45;0
WireConnection;58;2;53;0
WireConnection;59;2;55;0
WireConnection;71;0;58;0
WireConnection;71;1;59;0
WireConnection;36;0;35;0
WireConnection;36;1;71;0
WireConnection;34;0;36;0
WireConnection;0;2;34;0
ASEEND*/
//CHKSM=ADF862E9A73359D6A17CE883FCAC13B677DF36D4