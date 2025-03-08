// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "RO/RO_Effect_Water_01"
{
	Properties
	{
		_Float2("边缘透明度", Range( 0 , 10)) = 0
		_ShuiMianShengDu("水深度", Range( 0 , 50)) = 3.609172
		_ShuiBianShengDu("接触面宽度", Range( 0 , 10)) = 2
		_MainTex("水纹贴图", 2D) = "white" {}
		_Tiling("水纹贴图Tling", Vector) = (1,1,1,1)
		_UvSpeed("水纹贴图UV流动速度", Vector) = (0,0,0,0)
		_MainTexStr("水纹贴图强度", Range( 0 , 10)) = 1
		_SuiGaoDi("高低贴图", 2D) = "white" {}
		_Color1("Color1", Color) = (1,1,1,0)
		_Color2("Color2", Color) = (0.9575472,0.996938,1,0)
		_Tiling2("Tiling2", Vector) = (1,1,1,1)
		_UvSpeed2("高低贴图UV流动速度", Vector) = (0,0,0,0)
		_BianYuan("边缘颜色", Vector) = (0,1,0,1)
		_Lerp2("水面Lerp", Range( 0 , 1)) = 0
		_BianYuanLerp("边缘Lerp", Range( 0 , 1)) = 0
		_Float0("Float 0", Range( -1 , 1)) = -0.8
		_Min("高低纹理MIN", Range( 0 , 1)) = 0
		_Max("高低纹理MAx", Range( 0 , 1)) = 0
		_DingDianStr("顶点动画强度", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IsEmissive" = "true"  }
		Cull Off
		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nometa noforwardadd vertex:vertexDataFunc 
		struct Input
		{
			float4 screenPos;
			float2 uv_texcoord;
		};

		uniform sampler2D _SuiGaoDi;
		uniform float4 _UvSpeed2;
		uniform float4 _Tiling2;
		uniform float _Lerp2;
		uniform float _DingDianStr;
		uniform float4 _Color2;
		uniform float4 _Color1;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _ShuiMianShengDu;
		uniform float _Float0;
		uniform sampler2D _MainTex;
		uniform float4 _UvSpeed;
		uniform float4 _Tiling;
		uniform float _MainTexStr;
		uniform float4 _BianYuan;
		uniform float _ShuiBianShengDu;
		uniform float _BianYuanLerp;
		uniform float _Min;
		uniform float _Max;
		uniform float _Float2;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 appendResult138 = (float2(_UvSpeed2.x , _UvSpeed2.y));
			float2 panner140 = ( 1.0 * _Time.y * appendResult138 + v.texcoord.xy);
			float2 appendResult234 = (float2(_Tiling2.x , _Tiling2.y));
			float4 tex2DNode132 = tex2Dlod( _SuiGaoDi, float4( ( panner140 * appendResult234 ), 0, 0.0) );
			float2 appendResult235 = (float2(_Tiling2.z , _Tiling2.w));
			float2 appendResult146 = (float2(_UvSpeed2.z , _UvSpeed2.w));
			float2 panner143 = ( 1.0 * _Time.y * appendResult146 + v.texcoord.xy);
			float4 tex2DNode144 = tex2Dlod( _SuiGaoDi, float4( ( appendResult235 * panner143 ), 0, 0.0) );
			float lerpResult184 = lerp( tex2DNode132.r , tex2DNode144.r , _Lerp2);
			float3 temp_cast_0 = (lerpResult184).xxx;
			float3 ase_worldNormal = UnityObjectToWorldNormal( v.normal );
			float3 ase_worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
			float3x3 tangentToWorld = CreateTangentToWorldPerVertex( ase_worldNormal, ase_worldTangent, v.tangent.w );
			float3 tangentNormal170 = temp_cast_0;
			float3 modWorldNormal170 = (tangentToWorld[0] * tangentNormal170.x + tangentToWorld[1] * tangentNormal170.y + tangentToWorld[2] * tangentNormal170.z);
			float3 ase_vertexNormal = v.normal.xyz;
			v.vertex.xyz += ( modWorldNormal170 * ase_vertexNormal * float3(0,1,0) * _DingDianStr );
			v.vertex.w = 1;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float2 appendResult138 = (float2(_UvSpeed2.x , _UvSpeed2.y));
			float2 panner140 = ( 1.0 * _Time.y * appendResult138 + i.uv_texcoord);
			float2 appendResult234 = (float2(_Tiling2.x , _Tiling2.y));
			float4 tex2DNode132 = tex2D( _SuiGaoDi, ( panner140 * appendResult234 ) );
			float2 appendResult235 = (float2(_Tiling2.z , _Tiling2.w));
			float2 appendResult146 = (float2(_UvSpeed2.z , _UvSpeed2.w));
			float2 panner143 = ( 1.0 * _Time.y * appendResult146 + i.uv_texcoord);
			float4 tex2DNode144 = tex2D( _SuiGaoDi, ( appendResult235 * panner143 ) );
			float lerpResult184 = lerp( tex2DNode132.r , tex2DNode144.r , _Lerp2);
			float GaoDu190 = lerpResult184;
			float screenDepth89 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth89 = abs( ( screenDepth89 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( ( _ShuiMianShengDu * GaoDu190 ) ) );
			float2 appendResult102 = (float2(_UvSpeed.x , _UvSpeed.y));
			float2 panner101 = ( 1.0 * _Time.y * appendResult102 + i.uv_texcoord);
			float2 appendResult230 = (float2(_Tiling.x , _Tiling.y));
			float2 appendResult108 = (float2(_UvSpeed.z , _UvSpeed.w));
			float2 panner105 = ( 1.0 * _Time.y * appendResult108 + i.uv_texcoord);
			float2 appendResult227 = (float2(_Tiling.z , _Tiling.w));
			float lerpResult203 = lerp( tex2DNode132.r , tex2DNode144.r , _BianYuanLerp);
			float BianYuan2205 = lerpResult203;
			float screenDepth84 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth84 = abs( ( screenDepth84 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( ( _ShuiBianShengDu * BianYuan2205 ) ) );
			float smoothstepResult201 = smoothstep( _BianYuan.x , _BianYuan.y , saturate( distanceDepth84 ));
			float smoothstepResult212 = smoothstep( _Min , _Max , lerpResult184);
			float4 lerpResult92 = lerp( _Color2 , _Color1 , saturate( ( saturate( ( max( saturate( distanceDepth89 ) , ( 1.0 - GaoDu190 ) ) + _Float0 ) ) + saturate( ( ( tex2D( _MainTex, ( panner101 * appendResult230 ) ).a * tex2D( _MainTex, ( panner105 * appendResult227 ) ).a ) * _MainTexStr ) ) + saturate( ( ( ( 1.0 - smoothstepResult201 ) * _BianYuan.z ) + smoothstepResult212 ) ) ) ));
			o.Emission = lerpResult92.rgb;
			float screenDepth269 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth269 = abs( ( screenDepth269 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _Float2 ) );
			o.Alpha = saturate( distanceDepth269 );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18500
2005;7;1650;1004;-5627.785;-2066.214;1;True;True
Node;AmplifyShaderEditor.Vector4Node;139;5252.854,3212.23;Inherit;False;Property;_UvSpeed2;高低贴图UV流动速度;12;0;Create;False;0;0;False;0;False;0,0,0,0;0.01,0.1,-0.01,0.05;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;138;5595.054,3147.986;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;146;5557.341,3439.988;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;137;5490.351,2955.228;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;233;5821.241,3203.588;Inherit;False;Property;_Tiling2;Tiling2;11;0;Create;True;0;0;False;0;False;1,1,1,1;7,5,2,1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;145;5537.622,3274.468;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;143;5847.346,3375.664;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;235;6039.241,3313.588;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;140;5802.325,3011.179;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;234;6018.241,3199.588;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;236;6201.241,3366.588;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;232;6179.07,3009.869;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;241;6167.812,3171.528;Inherit;True;Property;_SuiGaoDi;高低贴图;8;0;Create;False;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;204;6319.866,2810.516;Inherit;False;Property;_BianYuanLerp;边缘Lerp;15;0;Create;False;0;0;False;0;False;0;0.185;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;144;6425.704,3350.247;Inherit;True;Property;_TextureSample1;Texture Sample 1;11;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;132;6431.217,2967.52;Inherit;True;Property;_TextureSample0;Texture Sample 0;10;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;203;6769.866,2866.516;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;185;6431.606,3561.589;Inherit;False;Property;_Lerp2;水面Lerp;14;0;Create;False;0;0;False;0;False;0;0.743;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;205;6995.759,2799.074;Inherit;False;BianYuan2;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;85;4376.93,1628.342;Inherit;False;Property;_ShuiBianShengDu;接触面宽度;3;0;Create;False;0;0;False;0;False;2;5.3;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;193;4447.006,1764.872;Inherit;False;205;BianYuan2;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;184;6787.956,3276.209;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;186;4727.542,1661.974;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;103;4116.161,2738.898;Inherit;False;Property;_UvSpeed;水纹贴图UV流动速度;6;0;Create;False;0;0;False;0;False;0,0,0,0;0.01,0.05,-0.01,0.2;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;190;7038.848,3094.962;Inherit;False;GaoDu;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;100;4473.156,2454.49;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;102;4603.101,2598.27;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;108;4572.329,3120.26;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;192;4515.871,2352.286;Inherit;False;190;GaoDu;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;107;4525.594,2954.676;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DepthFade;84;4951.979,1572.385;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;226;4756,3155.209;Inherit;False;Property;_Tiling;水纹贴图Tling;5;0;Create;False;0;0;False;0;False;1,1,1,1;1,2,1,5;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;90;4445.716,2231.283;Inherit;False;Property;_ShuiMianShengDu;水深度;2;0;Create;False;0;0;False;0;False;3.609172;14.4;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;194;5580.1,1613.71;Inherit;False;Property;_BianYuan;边缘颜色;13;0;Create;False;0;0;False;0;False;0,1,0,1;0.42,1,0.7,1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;101;4816.215,2422.703;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;86;5251.397,1482.654;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;227;5064.157,3037.661;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;189;4761.333,2256.311;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;230;4993.63,2504.891;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;105;4769.23,2974.233;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;229;5166.747,2823.97;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DepthFade;89;4939.284,2205.777;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;201;5903.81,1440.927;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;228;5133.729,2454.171;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;157;5464.82,2347.841;Inherit;False;190;GaoDu;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;225;4562.834,2734.936;Inherit;True;Property;_MainTex;水纹贴图;4;0;Create;False;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;99;5316.842,2450.762;Inherit;True;Property;_222;222;7;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;242;6619.547,3785.963;Inherit;False;Property;_Max;高低纹理MAx;18;0;Create;False;0;0;False;0;False;0;0.84;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;237;6601.285,3670.496;Inherit;False;Property;_Min;高低纹理MIN;17;0;Create;False;0;0;False;0;False;0;0.739;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;91;5275.008,2214.774;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;88;6306.366,1638.054;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;159;5717.258,2355.984;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;104;5313.059,2730.395;Inherit;True;Property;_33;33;10;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;161;6007.042,2371.051;Inherit;False;Property;_Float0;Float 0;16;0;Create;True;0;0;False;0;False;-0.8;-0.8;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;217;5667.173,2838.086;Inherit;False;Property;_MainTexStr;水纹贴图强度;7;0;Create;False;0;0;False;0;False;1;0.5;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;158;5926.724,2212.734;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;210;5624.842,2607.829;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;202;6488.073,1706.388;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;212;7036.665,3429.187;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;266;6397.369,2321.324;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;243;7208.42,2609.674;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;216;6014.231,2705.647;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;219;6378.703,2661.89;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;246;7324.607,2599.058;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;218;6644.059,2217.561;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;270;7759.023,3086.156;Inherit;False;Property;_Float2;边缘透明度;1;0;Create;False;0;0;False;0;False;0;1.46;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;97;7550.711,2300.034;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;269;8138.956,3081.762;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;98;7697.892,2289.915;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;239;7192.787,3886.297;Inherit;False;Property;_DingDianStr;顶点动画强度;19;0;Create;False;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;170;7045.335,3195.858;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalVertexDataNode;174;7146.245,3571.817;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;93;7462.839,2093.067;Inherit;False;Property;_Color1;Color1;9;0;Create;True;0;0;False;0;False;1,1,1,0;0.6367924,0.9100227,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;94;7491.23,1913.27;Inherit;False;Property;_Color2;Color2;10;0;Create;True;0;0;False;0;False;0.9575472,0.996938,1,0;0,0.3873908,0.7735849,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;240;7178.485,3738.097;Inherit;False;Constant;_Vector0;Vector 0;16;0;Create;True;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.LerpOp;92;7876.476,1995.006;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;271;8442.003,3107.076;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;181;7600.865,3445.029;Inherit;False;4;4;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;257;8953.669,2861.395;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;RO/RO_Effect_Water_01;False;False;False;False;True;True;True;True;True;False;True;True;False;False;False;False;False;False;False;False;False;Off;2;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Custom;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;138;0;139;1
WireConnection;138;1;139;2
WireConnection;146;0;139;3
WireConnection;146;1;139;4
WireConnection;143;0;145;0
WireConnection;143;2;146;0
WireConnection;235;0;233;3
WireConnection;235;1;233;4
WireConnection;140;0;137;0
WireConnection;140;2;138;0
WireConnection;234;0;233;1
WireConnection;234;1;233;2
WireConnection;236;0;235;0
WireConnection;236;1;143;0
WireConnection;232;0;140;0
WireConnection;232;1;234;0
WireConnection;144;0;241;0
WireConnection;144;1;236;0
WireConnection;132;0;241;0
WireConnection;132;1;232;0
WireConnection;203;0;132;1
WireConnection;203;1;144;1
WireConnection;203;2;204;0
WireConnection;205;0;203;0
WireConnection;184;0;132;1
WireConnection;184;1;144;1
WireConnection;184;2;185;0
WireConnection;186;0;85;0
WireConnection;186;1;193;0
WireConnection;190;0;184;0
WireConnection;102;0;103;1
WireConnection;102;1;103;2
WireConnection;108;0;103;3
WireConnection;108;1;103;4
WireConnection;84;0;186;0
WireConnection;101;0;100;0
WireConnection;101;2;102;0
WireConnection;86;0;84;0
WireConnection;227;0;226;3
WireConnection;227;1;226;4
WireConnection;189;0;90;0
WireConnection;189;1;192;0
WireConnection;230;0;226;1
WireConnection;230;1;226;2
WireConnection;105;0;107;0
WireConnection;105;2;108;0
WireConnection;229;0;105;0
WireConnection;229;1;227;0
WireConnection;89;0;189;0
WireConnection;201;0;86;0
WireConnection;201;1;194;1
WireConnection;201;2;194;2
WireConnection;228;0;101;0
WireConnection;228;1;230;0
WireConnection;99;0;225;0
WireConnection;99;1;228;0
WireConnection;91;0;89;0
WireConnection;88;0;201;0
WireConnection;159;0;157;0
WireConnection;104;0;225;0
WireConnection;104;1;229;0
WireConnection;158;0;91;0
WireConnection;158;1;159;0
WireConnection;210;0;99;4
WireConnection;210;1;104;4
WireConnection;202;0;88;0
WireConnection;202;1;194;3
WireConnection;212;0;184;0
WireConnection;212;1;237;0
WireConnection;212;2;242;0
WireConnection;266;0;158;0
WireConnection;266;1;161;0
WireConnection;243;0;202;0
WireConnection;243;1;212;0
WireConnection;216;0;210;0
WireConnection;216;1;217;0
WireConnection;219;0;216;0
WireConnection;246;0;243;0
WireConnection;218;0;266;0
WireConnection;97;0;218;0
WireConnection;97;1;219;0
WireConnection;97;2;246;0
WireConnection;269;0;270;0
WireConnection;98;0;97;0
WireConnection;170;0;184;0
WireConnection;92;0;94;0
WireConnection;92;1;93;0
WireConnection;92;2;98;0
WireConnection;271;0;269;0
WireConnection;181;0;170;0
WireConnection;181;1;174;0
WireConnection;181;2;240;0
WireConnection;181;3;239;0
WireConnection;257;2;92;0
WireConnection;257;9;271;0
WireConnection;257;11;181;0
ASEEND*/
//CHKSM=E05AC43E41C86702EA26AE36552479E850F9326D