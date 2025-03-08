// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "RO/RO_Effect_Water_11"
{
	Properties
	{
		_Depth("Depth", Float) = 2
		[HDR]_Color1("Color1", Color) = (1,1,1,0)
		_Color2("Color2", Color) = (0,0,0,0)
		_TO("TO", Vector) = (5,5,0,0)
		_TO2("TO2", Vector) = (0,0,0,0)
		_TimeSpeed("TimeSpeed", Float) = 0
		_Min("Min", Range( 0 , 1)) = 0
		_Max("Max", Range( 0 , 1)) = 0
		_DepthStr("DepthStr", Float) = 1
		_Float3("Float 3", Range( 0 , 1)) = 1
		_Alpha("Alpha", Range( 0 , 2)) = 0
		_Color0("Color 0", Color) = (0.2830189,0.2830189,0.2830189,0)
		_4444("4444", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow 
		struct Input
		{
			float4 screenPos;
			float2 uv_texcoord;
			float3 viewDir;
			INTERNAL_DATA
			float3 worldNormal;
			float3 worldPos;
		};

		uniform float4 _Color2;
		uniform float4 _Color1;
		uniform float _Min;
		uniform float _Max;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _Depth;
		uniform float _Float3;
		uniform float _TimeSpeed;
		uniform float4 _TO;
		uniform float _DepthStr;
		uniform float4 _TO2;
		uniform float4 _Color0;
		uniform float _4444;
		uniform float _Alpha;


		float2 voronoihash112( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi112( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash112( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			 		}
			 	}
			}
			return (F2 + F1) * 0.5;
		}


		float2 voronoihash304( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi304( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash304( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			 		}
			 	}
			}
			return (F2 + F1) * 0.5;
		}


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			o.Normal = float3(0,0,1);
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth1 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth1 = saturate( abs( ( screenDepth1 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _Depth ) ) );
			float DeprhFade170 = distanceDepth1;
			float temp_output_262_0 = ( 1.0 - DeprhFade170 );
			float temp_output_282_0 = pow( temp_output_262_0 , ( 128.0 * _Float3 ) );
			float Angle136 = ( _Time.y * _TimeSpeed );
			float time112 = Angle136;
			float2 appendResult7 = (float2(_TO.x , _TO.y));
			float2 appendResult215 = (float2(_TO.z , _TO.w));
			float2 UV2120 = ( ( i.uv_texcoord * appendResult7 ) + ( _Time.y * appendResult215 ) );
			float3 ViewDir162 = i.viewDir;
			float2 Offset53 = ( ( distanceDepth1 - 1 ) * ViewDir162.xy * ( distanceDepth1 * _Depth ) ) + UV2120;
			float2 coords112 = Offset53 * 1.0;
			float2 id112 = 0;
			float2 uv112 = 0;
			float voroi112 = voronoi112( coords112, time112, id112, uv112, 0 );
			float temp_output_29_0 = ( temp_output_262_0 * pow( voroi112 , _DepthStr ) );
			float smoothstepResult33 = smoothstep( _Min , saturate( ( _Min + _Max ) ) , saturate( ( temp_output_282_0 + temp_output_29_0 ) ));
			float4 lerpResult30 = lerp( _Color2 , _Color1 , smoothstepResult33);
			float time304 = Angle136;
			float2 appendResult329 = (float2(_TO2.x , _TO2.y));
			float2 appendResult328 = (float2(_TO2.z , _TO2.w));
			float2 coords304 = ( ( i.uv_texcoord * appendResult329 ) + ( _Time.y * appendResult328 ) ) * 1.0;
			float2 id304 = 0;
			float2 uv304 = 0;
			float voroi304 = voronoi304( coords304, time304, id304, uv304, 0 );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_normWorldNormal = normalize( ase_worldNormal );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float dotResult318 = dot( ase_normWorldNormal , ase_worldViewDir );
			o.Emission = saturate( ( lerpResult30 + ( pow( voroi304 , _DepthStr ) * _Color0 * pow( saturate( dotResult318 ) , _4444 ) ) ) ).rgb;
			o.Alpha = pow( DeprhFade170 , ( ( 1.0 - DeprhFade170 ) * _Alpha ) );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18500
2319;1;1512;1010;1903.572;157.4673;2.98427;True;True
Node;AmplifyShaderEditor.Vector4Node;6;-2174.325,165.9686;Inherit;False;Property;_TO;TO;4;0;Create;True;0;0;False;0;False;5,5,0,0;100,100,0,0.1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;27;-1414.811,238.087;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;7;-1843.821,194.573;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-1984.761,533.1036;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;215;-1799.685,359.9863;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;252;-1306.592,113.4453;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;68;-1412.681,591.7976;Inherit;False;Property;_TimeSpeed;TimeSpeed;6;0;Create;True;0;0;False;0;False;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-1574.27,-167.171;Inherit;False;Property;_Depth;Depth;1;0;Create;True;0;0;False;0;False;2;3.11;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-1125.117,317.6851;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DepthFade;1;-1286.775,-266.0275;Inherit;False;True;True;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;25;-917.789,133.9737;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-1118.714,420.9258;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;54;-759.3995,239.8244;Inherit;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-633.143,-183.6471;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;162;-571.0844,224.2159;Inherit;False;ViewDir;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;120;-812.6857,124.5955;Inherit;False;UV2;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;136;-958.1631,461.8387;Inherit;False;Angle;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;137;-223.163,289.8387;Inherit;False;136;Angle;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;170;-725.8384,-340.6396;Inherit;False;DeprhFade;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ParallaxMappingNode;53;-250.4293,131.705;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.VoronoiNode;112;60.76223,108.0758;Inherit;True;0;0;1;3;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.Vector4Node;327;-1896.051,851.8214;Inherit;False;Property;_TO2;TO2;5;0;Create;True;0;0;False;0;False;0,0,0,0;10,10,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;283;353.0322,-141.3674;Inherit;False;Property;_Float3;Float 3;10;0;Create;True;0;0;False;0;False;1;0.099;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;235;109.4002,374.2378;Inherit;False;Property;_DepthStr;DepthStr;9;0;Create;True;0;0;False;0;False;1;0.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;261;361.9065,-44.71252;Inherit;False;170;DeprhFade;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;288;448.5885,127.5096;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;329;-1629.705,789.8792;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;328;-1585.569,955.2924;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;284;708.0322,-189.3674;Inherit;False;2;2;0;FLOAT;128;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;262;630.8096,-31.91286;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;34;1020.269,199.5773;Inherit;False;Property;_Min;Min;7;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;331;-1118.407,963.6809;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;319;-371.6223,965.0457;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PowerNode;282;906.0322,-106.3674;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;950.5592,74.86894;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;330;-1325.96,798.3134;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldNormalVector;320;-403.6223,773.0455;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;36;1017.669,290.5773;Inherit;False;Property;_Max;Max;8;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;318;-67.62235,789.0456;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;35;1321.869,276.2774;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;298;1171.876,73.1655;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;332;-873.7301,805.0631;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;48;1377.57,63.4221;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;323;334.2541,954.3024;Inherit;False;Property;_4444;4444;13;0;Create;True;0;0;False;0;False;1;1.35;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;304;73.18375,468.9397;Inherit;True;0;0;1;3;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SaturateNode;321;76.37765,805.0456;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;37;1481.304,233.9033;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;31;1635.607,-413.575;Inherit;False;Property;_Color2;Color2;3;0;Create;True;0;0;False;0;False;0,0,0,0;0.01568628,0.2737098,0.4431373,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;232;2146.559,530.5147;Inherit;False;170;DeprhFade;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;32;1651.751,-187.5483;Inherit;False;Property;_Color1;Color1;2;1;[HDR];Create;True;0;0;False;0;False;1,1,1,0;0.7608303,4.541205,4.018135,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;324;732.2538,838.3024;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;305;484.7402,466.52;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;33;1705.436,49.94337;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;308;922.444,635.7302;Inherit;False;Property;_Color0;Color 0;12;0;Create;True;0;0;False;0;False;0.2830189,0.2830189,0.2830189,0;0.1886792,0.1886792,0.1886792,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;290;2054.412,812.5035;Inherit;False;Property;_Alpha;Alpha;11;0;Create;True;0;0;False;0;False;0;0.81;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;302;2261.308,689.4267;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;307;1292.014,519.0239;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;30;1955.641,-15.60873;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;309;2123.785,84.97992;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;303;2433.308,804.4267;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;260;1155.426,-68.03223;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;189;2301.253,64.76113;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;285;2548.401,725.7708;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;222;2490.504,535.9821;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2763.662,-33.1013;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;RO/RO_Effect_Water_11;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Custom;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;7;0;6;1
WireConnection;7;1;6;2
WireConnection;215;0;6;3
WireConnection;215;1;6;4
WireConnection;252;0;4;0
WireConnection;252;1;7;0
WireConnection;28;0;27;0
WireConnection;28;1;215;0
WireConnection;1;0;2;0
WireConnection;25;0;252;0
WireConnection;25;1;28;0
WireConnection;69;0;27;0
WireConnection;69;1;68;0
WireConnection;59;0;1;0
WireConnection;59;1;2;0
WireConnection;162;0;54;0
WireConnection;120;0;25;0
WireConnection;136;0;69;0
WireConnection;170;0;1;0
WireConnection;53;0;120;0
WireConnection;53;1;1;0
WireConnection;53;2;59;0
WireConnection;53;3;162;0
WireConnection;112;0;53;0
WireConnection;112;1;137;0
WireConnection;288;0;112;0
WireConnection;288;1;235;0
WireConnection;329;0;327;1
WireConnection;329;1;327;2
WireConnection;328;0;327;3
WireConnection;328;1;327;4
WireConnection;284;1;283;0
WireConnection;262;0;261;0
WireConnection;331;0;27;0
WireConnection;331;1;328;0
WireConnection;282;0;262;0
WireConnection;282;1;284;0
WireConnection;29;0;262;0
WireConnection;29;1;288;0
WireConnection;330;0;4;0
WireConnection;330;1;329;0
WireConnection;318;0;320;0
WireConnection;318;1;319;0
WireConnection;35;0;34;0
WireConnection;35;1;36;0
WireConnection;298;0;282;0
WireConnection;298;1;29;0
WireConnection;332;0;330;0
WireConnection;332;1;331;0
WireConnection;48;0;298;0
WireConnection;304;0;332;0
WireConnection;304;1;137;0
WireConnection;321;0;318;0
WireConnection;37;0;35;0
WireConnection;324;0;321;0
WireConnection;324;1;323;0
WireConnection;305;0;304;0
WireConnection;305;1;235;0
WireConnection;33;0;48;0
WireConnection;33;1;34;0
WireConnection;33;2;37;0
WireConnection;302;0;232;0
WireConnection;307;0;305;0
WireConnection;307;1;308;0
WireConnection;307;2;324;0
WireConnection;30;0;31;0
WireConnection;30;1;32;0
WireConnection;30;2;33;0
WireConnection;309;0;30;0
WireConnection;309;1;307;0
WireConnection;303;0;302;0
WireConnection;303;1;290;0
WireConnection;260;0;29;0
WireConnection;260;1;282;0
WireConnection;260;2;262;0
WireConnection;189;0;309;0
WireConnection;285;0;232;0
WireConnection;285;1;303;0
WireConnection;222;0;232;0
WireConnection;0;2;189;0
WireConnection;0;9;285;0
ASEEND*/
//CHKSM=7416096BC19594B3172AEEC31E3226F7621822FF