// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "RO/RO_Effect_Water_12"
{
	Properties
	{
		_LightDir("LightDir", Vector) = (0,5,0,0)
		_TO("TO", Vector) = (5,5,0,0)
		_Depth("Depth", Float) = 0
		_NormalStr("NormalStr", Range( 0 , 2)) = 0
		_Float2("Float 2", Range( 0.99 , 1)) = 0
		[HDR]_Color0("Color 0", Color) = (1,1,1,0)
		_Normal2Str("Normal2Str", Range( 0 , 1)) = 0
		_TO2("TO2", Vector) = (10,10,0,0)
		_LERP("LERP", Range( 0 , 1)) = 0
		_Alpha("Alpha", Range( 0 , 1)) = 0
		_Float1("Float 1", Range( 0 , 1)) = 0
		_Alpha1("Alpha", Range( 0 , 2)) = 0
		_Float4("Float 4", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "0"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		GrabPass{ }
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		#pragma surface surf Unlit keepalpha noshadow vertex:vertexDataFunc 
		struct Input
		{
			float3 worldNormal;
			INTERNAL_DATA
			float3 worldPos;
			float2 uv_texcoord;
			float4 screenPosition414;
			float4 screenPos;
		};

		uniform float4 _Color0;
		uniform float _Float2;
		uniform float _Float4;
		uniform float3 _LightDir;
		uniform float4 _TO;
		uniform float4 _TO2;
		uniform float _LERP;
		uniform float _NormalStr;
		uniform float _Float1;
		uniform float _Alpha;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _Depth;
		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform float _Normal2Str;
		uniform float _Alpha1;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


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


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 vertexPos414 = ase_vertex3Pos;
			float4 ase_screenPos414 = ComputeScreenPos( UnityObjectToClipPos( vertexPos414 ) );
			o.screenPosition414 = ase_screenPos414;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			o.Normal = float3(0,0,1);
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float dotResult371 = dot( ase_worldNormal , ase_worldViewDir );
			float temp_output_475_0 = pow( ( 1.0 - saturate( dotResult371 ) ) , _Float4 );
			float3 normalizeResult460 = normalize( ( ase_worldViewDir + _LightDir ) );
			float2 appendResult7 = (float2(_TO.x , _TO.y));
			float2 appendResult215 = (float2(_TO.z , _TO.w));
			float2 UV2120 = ( ( i.uv_texcoord * appendResult7 ) + ( _Time.y * appendResult215 ) );
			float2 break343 = UV2120;
			float temp_output_339_0 = ( pow( 0.5 , 3.0 ) * 0.1 );
			float2 appendResult344 = (float2(( break343.x + temp_output_339_0 ) , break343.y));
			float simplePerlin2D303 = snoise( appendResult344 );
			simplePerlin2D303 = simplePerlin2D303*0.5 + 0.5;
			float2 appendResult391 = (float2(_TO2.x , _TO2.y));
			float2 appendResult392 = (float2(_TO2.z , _TO2.w));
			float2 UV22396 = ( ( i.uv_texcoord * appendResult391 ) + ( _Time.y * appendResult392 ) );
			float2 break400 = UV22396;
			float2 appendResult403 = (float2(( break400.x + temp_output_339_0 ) , break400.y));
			float simplePerlin2D405 = snoise( appendResult403 );
			simplePerlin2D405 = simplePerlin2D405*0.5 + 0.5;
			float lerpResult437 = lerp( simplePerlin2D303 , simplePerlin2D405 , _LERP);
			float simplePerlin2D298 = snoise( UV2120 );
			simplePerlin2D298 = simplePerlin2D298*0.5 + 0.5;
			float simplePerlin2D397 = snoise( UV22396 );
			simplePerlin2D397 = simplePerlin2D397*0.5 + 0.5;
			float lerpResult436 = lerp( simplePerlin2D298 , simplePerlin2D397 , _LERP);
			float temp_output_348_0 = ( lerpResult437 - lerpResult436 );
			float3 appendResult346 = (float3(1.0 , 0.0 , ( temp_output_348_0 * _NormalStr )));
			float2 appendResult340 = (float2(break343.x , ( break343.y + temp_output_339_0 )));
			float simplePerlin2D353 = snoise( appendResult340 );
			simplePerlin2D353 = simplePerlin2D353*0.5 + 0.5;
			float2 appendResult404 = (float2(break400.x , ( break400.y + temp_output_339_0 )));
			float simplePerlin2D407 = snoise( appendResult404 );
			simplePerlin2D407 = simplePerlin2D407*0.5 + 0.5;
			float lerpResult438 = lerp( simplePerlin2D353 , simplePerlin2D407 , _LERP);
			float temp_output_347_0 = ( lerpResult438 - lerpResult436 );
			float3 appendResult345 = (float3(0.0 , 1.0 , ( _NormalStr * temp_output_347_0 )));
			float3 normalizeResult351 = normalize( cross( appendResult346 , appendResult345 ) );
			float3 Normal357 = normalizeResult351;
			float3 normalizeResult324 = normalize( (WorldNormalVector( i , Normal357 )) );
			float dotResult320 = dot( normalizeResult460 , normalizeResult324 );
			float smoothstepResult363 = smoothstep( ( _Float2 + ( _Float2 * temp_output_475_0 * 0.01 ) ) , _Float2 , max( dotResult320 , 0.0 ));
			float4 ase_screenPos414 = i.screenPosition414;
			float4 ase_screenPosNorm414 = ase_screenPos414 / ase_screenPos414.w;
			ase_screenPosNorm414.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm414.z : ase_screenPosNorm414.z * 0.5 + 0.5;
			float screenDepth414 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm414.xy ));
			float distanceDepth414 = saturate( abs( ( screenDepth414 - LinearEyeDepth( ase_screenPosNorm414.z ) ) / ( _Depth ) ) );
			float DeprhFade416 = distanceDepth414;
			float smoothstepResult467 = smoothstep( _Float1 , saturate( ( _Float1 + _Alpha ) ) , DeprhFade416);
			float temp_output_500_0 = ( 1.0 - DeprhFade416 );
			float temp_output_503_0 = ( temp_output_500_0 * step( 0.01 , temp_output_500_0 ) );
			float3 appendResult385 = (float3(1.0 , 0.0 , ( temp_output_348_0 * _Normal2Str * temp_output_503_0 )));
			float3 appendResult384 = (float3(0.0 , 1.0 , ( _Normal2Str * temp_output_347_0 * temp_output_503_0 )));
			float3 normalizeResult387 = normalize( cross( appendResult385 , appendResult384 ) );
			float3 Normal2389 = normalizeResult387;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float2 appendResult486 = (float2(( ase_grabScreenPosNorm.r * 1.0 ) , ( ase_grabScreenPosNorm.g * 1.0 )));
			float4 screenColor375 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,( Normal2389 + float3( appendResult486 ,  0.0 ) ).xy);
			o.Emission = ( ( _Color0 * ( smoothstepResult363 * temp_output_475_0 ) * smoothstepResult467 * UNITY_LIGHTMODEL_AMBIENT ) + screenColor375 ).rgb;
			o.Alpha = pow( DeprhFade416 , ( ( 1.0 - DeprhFade416 ) * _Alpha1 ) );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18500
2319;1;1512;1010;3030.926;-312.7761;1.64663;True;True
Node;AmplifyShaderEditor.Vector4Node;390;-4193.752,-75.79065;Inherit;False;Property;_TO2;TO2;8;0;Create;True;0;0;False;0;False;10,10,0,0;5,7,0,-0.2;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;6;-4240.875,-355.5782;Inherit;False;Property;_TO;TO;2;0;Create;True;0;0;False;0;False;5,5,0,0;30,30,0,0.5;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;392;-3829.189,71.16528;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;391;-3824.95,-71.55152;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;297;-3872.406,-487.629;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;7;-3827.415,-350.0931;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;27;-3737.092,-254.2707;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;215;-3819.974,-170.8405;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-3381.016,-225.0571;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;252;-3373.144,-408.1015;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;393;-3372.775,-94.16002;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;394;-3350.167,61.27417;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;395;-2989.844,-78.61664;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;25;-2984.34,-387.5732;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;120;-2793.059,-391.8563;Inherit;False;UV2;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;396;-2808.066,-66.23947;Inherit;False;UV22;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;355;-3496.49,622.8423;Inherit;False;Constant;_Float0;Float 0;6;0;Create;True;0;0;False;0;False;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;338;-3202.612,607.1156;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;302;-3488.681,225.5391;Inherit;False;120;UV2;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;399;-3491.156,340.9802;Inherit;False;396;UV22;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;343;-3205.961,212.5834;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.ScaleNode;339;-3026.612,607.1156;Inherit;False;0.1;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;400;-3256.156,356.9802;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleAddOpNode;402;-2790.156,486.9802;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;337;-2818.613,639.1156;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;342;-2799.613,160.1157;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;401;-2799.156,325.9802;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;344;-2640.909,237.0688;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;404;-2635.156,472.9802;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;340;-2674.613,623.1156;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;403;-2609.156,351.9802;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;407;-2467.156,593.9802;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;405;-2471.156,364.9802;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;298;-2499.173,-402.296;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;439;-2724.615,61.85588;Inherit;False;Property;_LERP;LERP;9;0;Create;True;0;0;False;0;False;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;397;-2490.476,-115.6758;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;303;-2481.01,127.0236;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;353;-2464.475,835.9201;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;488;-3368.246,-994.8477;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;436;-2200.546,-334.9258;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;417;-3333.945,-815.547;Inherit;False;Property;_Depth;Depth;3;0;Create;True;0;0;False;0;False;0;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;438;-2194.601,582.4162;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;437;-2194.34,122.9353;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;347;-2010.167,400.9842;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;356;-2074.383,270.2472;Inherit;False;Property;_NormalStr;NormalStr;4;0;Create;True;0;0;False;0;False;0;2;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;414;-2885.888,-855.2897;Inherit;False;True;True;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;348;-2016.103,9.916363;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;416;-2483.567,-867.9776;Inherit;False;DeprhFade;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;350;-1781.496,355.7056;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;349;-1771.716,195.7307;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;346;-1595.015,139.0957;Inherit;False;FLOAT3;4;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;345;-1596.493,378.6391;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;499;-2340.021,996.6516;Inherit;False;416;DeprhFade;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;500;-2132.021,994.6516;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CrossProductOpNode;352;-1412.761,254.6969;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StepOpNode;501;-1932.626,1007.177;Inherit;False;2;0;FLOAT;0.01;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;370;-3776,2048;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;471;-3808,1856;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode;351;-1240.879,254.9507;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;388;-2197.836,730.1736;Inherit;False;Property;_Normal2Str;Normal2Str;7;0;Create;True;0;0;False;0;False;0;0.786;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;503;-1892.442,908.1091;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;357;-1028.853,264.1454;Inherit;False;Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;371;-3472,1872;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;472;-3579.213,1616.091;Inherit;False;357;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;382;-1747.092,594.3514;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;383;-1710.733,808.8543;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;456;-3659.635,1361.024;Inherit;False;Property;_LightDir;LightDir;1;0;Create;True;0;0;False;0;False;0,5,0;0,7,0.71;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SaturateNode;411;-3328,1888;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;458;-3597.193,1177.181;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;476;-2546.124,2047.257;Inherit;False;Property;_Float4;Float 4;13;0;Create;True;0;0;False;0;False;1;5.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;459;-3341.193,1241.181;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;384;-1525.73,831.7878;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;385;-1524.252,592.2444;Inherit;False;FLOAT3;4;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldNormalVector;321;-3363.476,1588.757;Inherit;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.OneMinusNode;373;-3184,1888;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;480;-2312.787,1728.3;Inherit;False;Constant;_Float5;Float 5;14;0;Create;True;0;0;False;0;False;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;364;-2451.897,1593.823;Inherit;False;Property;_Float2;Float 2;5;0;Create;True;0;0;False;0;False;0;0.99176;0.99;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;475;-2398.124,1963.257;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CrossProductOpNode;386;-1341.998,707.8456;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;460;-3181.193,1241.181;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;324;-3017.208,1582.612;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;462;-2339.531,1288.996;Inherit;False;Property;_Alpha;Alpha;10;0;Create;True;0;0;False;0;False;0;0.725;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GrabScreenPosition;376;-2449.005,2265.938;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;478;-2069.644,1550.44;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalizeNode;387;-1170.116,708.0994;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;320;-2800.088,1440.642;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;468;-2346.305,1190.939;Inherit;False;Property;_Float1;Float 1;11;0;Create;True;0;0;False;0;False;0;0.489;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;481;-1881.678,1624.492;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;484;-2139.963,2400.195;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;389;-950.2695,698.8534;Inherit;False;Normal2;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;483;-2146.963,2294.195;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;309;-2562.446,1384.581;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;469;-1988.306,1268.939;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;378;-2136.511,2133.271;Inherit;False;389;Normal2;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;504;-967.3314,1973.359;Inherit;False;416;DeprhFade;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;461;-2322.106,1113.515;Inherit;False;416;DeprhFade;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;486;-2000.963,2318.195;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;470;-1819.856,1309.792;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;363;-1718.029,1598.75;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;409;-1414.749,1644.926;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;467;-1670.483,1213.502;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FogAndAmbientColorsNode;455;-1564.2,1909.69;Inherit;False;UNITY_LIGHTMODEL_AMBIENT;0;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;381;-1686.141,1376.547;Inherit;False;Property;_Color0;Color 0;6;1;[HDR];Create;True;0;0;False;0;False;1,1,1,0;4.594794,4.594794,4.594794,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;505;-1059.478,2255.347;Inherit;False;Property;_Alpha1;Alpha;12;0;Create;True;0;0;False;0;False;0;0.81;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;377;-1857.685,2150.439;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;506;-852.5823,2132.271;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;507;-680.5823,2247.271;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;380;-1106.732,1638.423;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScreenColorNode;375;-1539.151,2132.346;Inherit;False;Global;_GrabScreen0;Grab Screen 0;5;0;Create;True;0;0;False;0;False;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;379;-879.2755,1728.527;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;508;-534.109,2140.222;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;509;-623.3865,1978.826;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;422;-2120.838,824.0354;Inherit;False;416;DeprhFade;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-238.177,1483.524;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;RO/RO_Effect_Water_12;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Custom;0;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;392;0;390;3
WireConnection;392;1;390;4
WireConnection;391;0;390;1
WireConnection;391;1;390;2
WireConnection;7;0;6;1
WireConnection;7;1;6;2
WireConnection;215;0;6;3
WireConnection;215;1;6;4
WireConnection;28;0;27;0
WireConnection;28;1;215;0
WireConnection;252;0;297;0
WireConnection;252;1;7;0
WireConnection;393;0;297;0
WireConnection;393;1;391;0
WireConnection;394;0;27;0
WireConnection;394;1;392;0
WireConnection;395;0;393;0
WireConnection;395;1;394;0
WireConnection;25;0;252;0
WireConnection;25;1;28;0
WireConnection;120;0;25;0
WireConnection;396;0;395;0
WireConnection;338;0;355;0
WireConnection;343;0;302;0
WireConnection;339;0;338;0
WireConnection;400;0;399;0
WireConnection;402;0;400;1
WireConnection;402;1;339;0
WireConnection;337;0;343;1
WireConnection;337;1;339;0
WireConnection;342;0;343;0
WireConnection;342;1;339;0
WireConnection;401;0;400;0
WireConnection;401;1;339;0
WireConnection;344;0;342;0
WireConnection;344;1;343;1
WireConnection;404;0;400;0
WireConnection;404;1;402;0
WireConnection;340;0;343;0
WireConnection;340;1;337;0
WireConnection;403;0;401;0
WireConnection;403;1;400;1
WireConnection;407;0;404;0
WireConnection;405;0;403;0
WireConnection;298;0;120;0
WireConnection;397;0;396;0
WireConnection;303;0;344;0
WireConnection;353;0;340;0
WireConnection;436;0;298;0
WireConnection;436;1;397;0
WireConnection;436;2;439;0
WireConnection;438;0;353;0
WireConnection;438;1;407;0
WireConnection;438;2;439;0
WireConnection;437;0;303;0
WireConnection;437;1;405;0
WireConnection;437;2;439;0
WireConnection;347;0;438;0
WireConnection;347;1;436;0
WireConnection;414;1;488;0
WireConnection;414;0;417;0
WireConnection;348;0;437;0
WireConnection;348;1;436;0
WireConnection;416;0;414;0
WireConnection;350;0;356;0
WireConnection;350;1;347;0
WireConnection;349;0;348;0
WireConnection;349;1;356;0
WireConnection;346;2;349;0
WireConnection;345;2;350;0
WireConnection;500;0;499;0
WireConnection;352;0;346;0
WireConnection;352;1;345;0
WireConnection;501;1;500;0
WireConnection;351;0;352;0
WireConnection;503;0;500;0
WireConnection;503;1;501;0
WireConnection;357;0;351;0
WireConnection;371;0;471;0
WireConnection;371;1;370;0
WireConnection;382;0;348;0
WireConnection;382;1;388;0
WireConnection;382;2;503;0
WireConnection;383;0;388;0
WireConnection;383;1;347;0
WireConnection;383;2;503;0
WireConnection;411;0;371;0
WireConnection;459;0;458;0
WireConnection;459;1;456;0
WireConnection;384;2;383;0
WireConnection;385;2;382;0
WireConnection;321;0;472;0
WireConnection;373;0;411;0
WireConnection;475;0;373;0
WireConnection;475;1;476;0
WireConnection;386;0;385;0
WireConnection;386;1;384;0
WireConnection;460;0;459;0
WireConnection;324;0;321;0
WireConnection;478;0;364;0
WireConnection;478;1;475;0
WireConnection;478;2;480;0
WireConnection;387;0;386;0
WireConnection;320;0;460;0
WireConnection;320;1;324;0
WireConnection;481;0;364;0
WireConnection;481;1;478;0
WireConnection;484;0;376;2
WireConnection;389;0;387;0
WireConnection;483;0;376;1
WireConnection;309;0;320;0
WireConnection;469;0;468;0
WireConnection;469;1;462;0
WireConnection;486;0;483;0
WireConnection;486;1;484;0
WireConnection;470;0;469;0
WireConnection;363;0;309;0
WireConnection;363;1;481;0
WireConnection;363;2;364;0
WireConnection;409;0;363;0
WireConnection;409;1;475;0
WireConnection;467;0;461;0
WireConnection;467;1;468;0
WireConnection;467;2;470;0
WireConnection;377;0;378;0
WireConnection;377;1;486;0
WireConnection;506;0;504;0
WireConnection;507;0;506;0
WireConnection;507;1;505;0
WireConnection;380;0;381;0
WireConnection;380;1;409;0
WireConnection;380;2;467;0
WireConnection;380;3;455;0
WireConnection;375;0;377;0
WireConnection;379;0;380;0
WireConnection;379;1;375;0
WireConnection;508;0;504;0
WireConnection;508;1;507;0
WireConnection;509;0;504;0
WireConnection;0;2;379;0
WireConnection;0;9;508;0
ASEEND*/
//CHKSM=5288F47A8723C6039828D1260056A7D242F25357