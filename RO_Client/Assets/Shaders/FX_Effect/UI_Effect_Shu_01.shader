// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "RO/UI_Effect_Shu_01"
{
	Properties
	{
		_ASEOutlineWidth( "Outline Width", Float ) = 0.003
		_ASEOutlineColor( "Outline Color", Color ) = (0.1698113,0.1698113,0.1698113,0)
		_Normal("Normal", 2D) = "bump" {}
		_RG("RG", 2D) = "black" {}
		_HLS("HLS", Range( 0 , 1)) = 0.7437451
		_Exp("Exp", Float) = 100
		_HightlightIntensity("HightlightIntensity", Range( 0 , 1)) = 0
		_NormalStr("NormalStr", Range( 0 , 1)) = 0
		_MainTex("MainTex", 2D) = "white" {}
		_Min("Min", Range( 0 , 1)) = 0
		_Max("Max", Range( 0 , 1)) = 1
		_Float3("Float 3", Range( 0 , 1)) = 0
		_AnMianMin("暗面Min", Range( 0 , 1)) = 0
		_AnMianMAx("暗面Max", Range( 0 , 1)) = 1
		_GaoGuangMin("高光Min", Range( 0 , 1)) = 1
		_GaoGuangMax("高光Max", Range( 0 , 1)) = 1
		[HDR]_Color0("Color 0", Color) = (0,0,0,0)
		_Blend("Blend", Range( 0 , 1)) = 0
		_Float2("Float 2", Range( -1 , 1)) = 0
		_Float4("Float 4", Range( -1 , 1)) = 0
		_Normal2("Normal2", 2D) = "bump" {}
		_Float5("Float 5", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ }
		Cull Front
		CGPROGRAM
		#pragma target 3.0
		#pragma surface outlineSurf Outline nofog  keepalpha noshadow noambient novertexlights nolightmap nodynlightmap nodirlightmap nometa noforwardadd vertex:outlineVertexDataFunc 
		
		float4 _ASEOutlineColor;
		float _ASEOutlineWidth;
		void outlineVertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			v.vertex.xyz += ( v.normal * _ASEOutlineWidth );
		}
		inline half4 LightingOutline( SurfaceOutput s, half3 lightDir, half atten ) { return half4 ( 0,0,0, s.Alpha); }
		void outlineSurf( Input i, inout SurfaceOutput o )
		{
			o.Emission = _ASEOutlineColor.rgb;
			o.Alpha = 1;
		}
		ENDCG
		

		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "UnityStandardUtils.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform sampler2D _RG;
		SamplerState sampler_RG;
		uniform float4 _RG_ST;
		uniform float4 _Color0;
		uniform float _Min;
		uniform sampler2D _Normal;
		uniform float4 _Normal_ST;
		uniform float _NormalStr;
		uniform sampler2D _Normal2;
		SamplerState sampler_Normal2;
		uniform float4 _Normal2_ST;
		uniform float _Float5;
		uniform float _HLS;
		uniform float _Exp;
		uniform float _HightlightIntensity;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float _Blend;
		uniform float _GaoGuangMin;
		uniform float _GaoGuangMax;
		uniform float _Float3;
		uniform float _AnMianMin;
		uniform float _AnMianMAx;
		uniform float _Max;
		uniform float _Float2;
		uniform float _Float4;


		float3 HSVToRGB( float3 c )
		{
			float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
			float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
			return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
		}


		float3 RGBToHSV(float3 c)
		{
			float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
			float4 p = lerp( float4( c.bg, K.wz ), float4( c.gb, K.xy ), step( c.b, c.g ) );
			float4 q = lerp( float4( p.xyw, c.r ), float4( c.r, p.yzx ), step( p.x, c.r ) );
			float d = q.x - min( q.w, q.y );
			float e = 1.0e-10;
			return float3( abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float2 uv_RG = i.uv_texcoord * _RG_ST.xy + _RG_ST.zw;
			float4 tex2DNode26 = tex2D( _RG, uv_RG );
			float B145 = tex2DNode26.b;
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float3 hsvTorgb625 = RGBToHSV( ase_lightColor.rgb );
			float Min718 = _Min;
			float3 hsvTorgb626 = HSVToRGB( float3(frac( ( 0.5 + hsvTorgb625.x ) ),hsvTorgb625.y,( hsvTorgb625.z * Min718 )) );
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = Unity_SafeNormalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float2 uv_Normal = i.uv_texcoord * _Normal_ST.xy + _Normal_ST.zw;
			float2 uv_Normal2 = i.uv_texcoord * _Normal2_ST.xy + _Normal2_ST.zw;
			float3 tex2DNode687 = UnpackScaleNormal( tex2D( _Normal2, uv_Normal2 ), _Float5 );
			float2 appendResult693 = (float2(tex2DNode687.r , tex2DNode687.g));
			float R143 = tex2DNode26.r;
			float3 appendResult695 = (float3(( appendResult693 * R143 ) , tex2DNode687.b));
			float3 newWorldNormal5 = normalize( (WorldNormalVector( i , BlendNormals( UnpackScaleNormal( tex2D( _Normal, uv_Normal ), _NormalStr ) , appendResult695 ) )) );
			float dotResult54 = dot( ase_worldlightDir , newWorldNormal5 );
			float temp_output_401_0 = saturate( dotResult54 );
			float WorldLightDotNomals71 = temp_output_401_0;
			float A617 = tex2DNode26.a;
			float3 ase_worldViewDir = Unity_SafeNormalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float dotResult336 = dot( ( ( dotResult54 * newWorldNormal5 * 2.0 ) - ase_worldlightDir ) , ase_worldViewDir );
			float temp_output_338_0 = saturate( dotResult336 );
			float3 normalizeResult699 = normalize( ( ase_worldViewDir + ase_worldlightDir ) );
			float3 Normal100 = newWorldNormal5;
			float3 ase_worldTangent = WorldNormalVector( i, float3( 1, 0, 0 ) );
			float3 normalizeResult676 = normalize( cross( Normal100 , ( ase_worldTangent + sin( _HLS ) ) ) );
			float3 Binormal678 = normalizeResult676;
			float dotResult663 = dot( normalizeResult699 , Binormal678 );
			float Highlight671 = pow( sqrt( ( 1.0 - ( dotResult663 * dotResult663 ) ) ) , _Exp );
			float lerpResult681 = lerp( temp_output_338_0 , Highlight671 , R143);
			float G144 = tex2DNode26.g;
			float temp_output_358_0 = ( ( temp_output_338_0 + lerpResult681 ) * _HightlightIntensity * G144 );
			float GaoGuang362 = saturate( temp_output_358_0 );
			float temp_output_633_0 = ( ( WorldLightDotNomals71 * A617 ) + ( A617 * GaoGuang362 ) );
			float3 lerpResult624 = lerp( hsvTorgb626 , ase_lightColor.rgb , saturate( temp_output_633_0 ));
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 blendOpSrc643 = float4( lerpResult624 , 0.0 );
			float4 blendOpDest643 = tex2D( _MainTex, uv_MainTex );
			float4 lerpBlendMode643 = lerp(blendOpDest643,2.0f*blendOpDest643*blendOpSrc643 + blendOpDest643*blendOpDest643*(1.0f - 2.0f*blendOpSrc643),_Blend);
			float smoothstepResult613 = smoothstep( _GaoGuangMin , _GaoGuangMax , GaoGuang362);
			float smoothstepResult610 = smoothstep( _AnMianMin , _AnMianMAx , WorldLightDotNomals71);
			float temp_output_599_0 = ( A617 * smoothstepResult610 );
			float GY641 = ( ( smoothstepResult613 * G144 * _Float3 * A617 * temp_output_599_0 ) + (_Min + (temp_output_599_0 - 0.0) * (_Max - _Min) / (1.0 - 0.0)) );
			float GY2649 = temp_output_633_0;
			float3 desaturateInitialColor647 = ( lerpBlendMode643 * GY641 ).rgb;
			float desaturateDot647 = dot( desaturateInitialColor647, float3( 0.299, 0.587, 0.114 ));
			float3 desaturateVar647 = lerp( desaturateInitialColor647, desaturateDot647.xxx, (_Float2 + (saturate( GY2649 ) - 0.0) * (_Float4 - _Float2) / (1.0 - 0.0)) );
			c.rgb = ( step( 0.6 , ( 1.0 - B145 ) ) * desaturateVar647 );
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Normal = float3(0,0,1);
			float2 uv_RG = i.uv_texcoord * _RG_ST.xy + _RG_ST.zw;
			float4 tex2DNode26 = tex2D( _RG, uv_RG );
			float B145 = tex2DNode26.b;
			o.Emission = ( B145 * _Color0 ).rgb;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows exclude_path:deferred 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18500
2183;1;1650;1010;2476.564;-94.4476;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;127;-6453.76,-1360.775;Inherit;False;4408.696;1620.152;光照方向;37;687;7;686;703;707;527;528;692;529;71;547;358;401;562;685;669;681;684;680;338;336;337;342;343;339;54;340;341;32;100;5;695;556;694;690;693;688;;1,0.495283,0.495283,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;153;-1948.615,-1341.995;Inherit;False;662.7804;675.0627;材质分成;5;144;26;143;145;617;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;26;-1879.085,-1225.114;Inherit;True;Property;_RG;RG;1;0;Create;True;0;0;False;0;False;-1;None;935f3778a084a06429fb0e120f040c23;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;688;-5883.849,-732.8069;Inherit;False;Property;_Float5;Float 5;22;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;687;-5471.261,-860.4617;Inherit;True;Property;_Normal2;Normal2;21;0;Create;True;0;0;False;0;False;-1;None;bd734c29baceb63499732f24fbaea45f;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;143;-1574.849,-1238.263;Inherit;False;R;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;690;-5297.309,-539.1959;Inherit;False;143;R;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;693;-5112.922,-825.454;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;556;-5045.862,-943.7347;Inherit;False;Property;_NormalStr;NormalStr;7;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;694;-4961.922,-826.454;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;695;-4798.923,-803.454;Inherit;False;FLOAT3;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;7;-4750.647,-1049.55;Inherit;True;Property;_Normal;Normal;0;0;Create;True;0;0;False;0;False;-1;None;3c586023fc286a8419ba0392d5e96dec;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendNormalsNode;686;-4450.15,-867.7986;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldNormalVector;5;-4213.263,-996.7001;Inherit;True;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;672;-4025.077,-2002.401;Inherit;False;Property;_HLS;HLS;2;0;Create;True;0;0;False;0;False;0.7437451;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;100;-3992.529,-598.1229;Inherit;False;Normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.VertexTangentNode;677;-3849.078,-2242.401;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SinOpNode;673;-3689.078,-2018.401;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;683;-3724.4,-2322.829;Inherit;False;100;Normal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;674;-3497.078,-2130.401;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CrossProductOpNode;675;-3225.078,-2210.401;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;696;-4750.55,-1799.604;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.NormalizeNode;676;-3017.078,-2226.401;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;697;-4746.298,-1974.805;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;678;-2809.078,-2226.401;Inherit;False;Binormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;698;-4446.55,-1895.604;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;661;-4186.774,-1699.675;Inherit;False;678;Binormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;699;-4286.55,-1895.604;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;663;-3932.767,-1786.028;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;664;-3781.767,-1789.028;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;32;-4212.575,-1253.693;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.OneMinusNode;665;-3624.768,-1788.028;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;340;-3906.694,-851.0664;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;341;-3913.686,-768.0602;Inherit;False;Constant;_Float1;Float 1;14;0;Create;True;0;0;False;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;54;-3933.441,-1100.642;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;667;-3475.489,-1682.384;Inherit;False;Property;_Exp;Exp;3;0;Create;True;0;0;False;0;False;100;144;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;343;-3626.506,-1124.514;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;339;-3693.53,-904.3245;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SqrtOpNode;666;-3440.768,-1790.028;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;342;-3521.576,-951.9705;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;337;-3699.536,-569.6345;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.PowerNode;668;-3242.768,-1772.028;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;336;-3369.8,-757.9276;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;671;-2770.888,-1677.184;Inherit;False;Highlight;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;680;-3142.215,-599.999;Inherit;False;671;Highlight;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;338;-3119.096,-721.8685;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;684;-3140.362,-502.0925;Inherit;False;143;R;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;144;-1516.644,-1146.181;Inherit;False;G;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;681;-2899.766,-705.0891;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;685;-2816.914,-839.5575;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;562;-2915.826,-272.9383;Inherit;False;144;G;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;669;-3000.01,-393.5682;Inherit;False;Property;_HightlightIntensity;HightlightIntensity;6;0;Create;True;0;0;False;0;False;0;0.557;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;401;-3529.702,-1139.231;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;358;-2633.465,-626.3501;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;71;-3144.872,-1098.204;Inherit;False;WorldLightDotNomals;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;547;-2372.776,-562.5665;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;586;-2161.191,553.1473;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.RegisterLocalVarNode;617;-1482.369,-923.7062;Inherit;False;A;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;612;-4099.987,1287.981;Inherit;False;Property;_AnMianMin;暗面Min;12;0;Create;False;0;0;False;0;False;0;0.52;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;611;-4078.078,1378.994;Inherit;False;Property;_AnMianMAx;暗面Max;13;0;Create;False;0;0;False;0;False;1;0.892;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;362;-2200.085,-650.8628;Inherit;False;GaoGuang;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;581;-4077.528,1199.29;Inherit;False;71;WorldLightDotNomals;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;598;-3893.298,1465.934;Inherit;False;Property;_Min;Min;9;0;Create;True;0;0;False;0;False;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;588;-4181.145,596.1504;Inherit;False;Property;_GaoGuangMin;高光Min;14;0;Create;False;0;0;False;0;False;1;0.833;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;634;-1865.59,853.1276;Inherit;False;362;GaoGuang;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;619;-3761.085,1045.423;Inherit;False;617;A;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;610;-3729.894,1263.652;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;639;-1855.18,754.5089;Inherit;False;617;A;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;585;-3937.198,438.7396;Inherit;False;362;GaoGuang;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RGBToHSVNode;625;-1858.661,360.0194;Inherit;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;718;-3423.736,1491.645;Inherit;False;Min;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;632;-1929.786,676.3573;Inherit;False;71;WorldLightDotNomals;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;614;-4017.172,712.5967;Inherit;False;Property;_GaoGuangMax;高光Max;15;0;Create;False;0;0;False;0;False;1;0.845;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;591;-3910.062,864.3676;Inherit;False;144;G;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;600;-3870.478,1551.151;Inherit;False;Property;_Max;Max;10;0;Create;True;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;605;-3660.71,968.5439;Inherit;False;Property;_Float3;Float 3;11;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;640;-1556.18,840.3087;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;628;-1638.153,299.1102;Inherit;False;2;2;0;FLOAT;0.5;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;613;-3577.689,572.5367;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;599;-3507.698,1171.512;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;638;-1591.28,711.6087;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;719;-1816.564,507.4476;Inherit;False;718;Min;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;633;-1373.92,749.5386;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;717;-1505.004,471.3531;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;592;-3280.755,830.3754;Inherit;False;5;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;597;-3354.598,1197.135;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;627;-1482.153,323.1102;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.HSVToRGBNode;626;-1321.244,329.5247;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;601;-3018.707,1016.04;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;635;-1252.235,697.9902;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;649;-1081.357,743.7885;Inherit;False;GY2;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;641;-2611.424,1026.604;Inherit;False;GY;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;145;-1508.302,-1061.644;Inherit;False;B;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;580;-1281.424,869.0188;Inherit;True;Property;_MainTex;MainTex;8;0;Create;True;0;0;False;0;False;-1;None;7097f97c7ae6a734da7e7f977f24c784;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;624;-1061.979,576.7983;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;644;-1261.66,1052.449;Inherit;False;Property;_Blend;Blend;18;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;650;-970.3607,1165.558;Inherit;False;649;GY2;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;646;-809.0112,987.8487;Inherit;False;641;GY;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;653;-813.0372,1350.408;Inherit;False;Property;_Float4;Float 4;20;0;Create;True;0;0;False;0;False;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;603;-438.9613,546.1279;Inherit;False;145;B;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;643;-804.809,765.9975;Inherit;False;SoftLight;False;3;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;652;-803.3676,1263.854;Inherit;False;Property;_Float2;Float 2;19;0;Create;True;0;0;False;0;False;0;-1;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;648;-786.8584,1167.7;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;602;-472.523,921.3463;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;651;-426.8863,1067.691;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;715;-99.81679,747.6027;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;132;-1924.773,-560.113;Inherit;False;1132.612;471.9731;边缘光;2;134;492;;1,1,1,1;0;0
Node;AmplifyShaderEditor.StepOpNode;716;75.47533,774.0657;Inherit;True;2;0;FLOAT;0.99;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;616;-543.3432,649.822;Inherit;False;Property;_Color0;Color 0;16;1;[HDR];Create;True;0;0;False;0;False;0,0,0,0;6.632862,0.6570287,5.079822,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DesaturateOpNode;647;-187.4892,963.522;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalizeNode;707;-3425.77,-400.0696;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;529;-2313.037,-916.0228;Inherit;False;DuiBiDu;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;412;-1843.426,-267.2845;Inherit;False;Property;_Fresnel;Fresnel;4;0;Create;True;0;0;False;0;False;0.53;0.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TangentVertexDataNode;711;-4035.022,-2533.617;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;692;-5256.447,-458.4984;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;97;-1263.507,-441.4207;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;491;-1085.055,-336.1008;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;134;-993.9182,-438.7154;Inherit;False;Fresnel;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;714;381.7997,1001.235;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;703;-3741.417,-380.6482;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FresnelNode;92;-1636.084,-447.876;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;629;-1948.153,228.1102;Inherit;False;Property;_Float0;Float 0;17;0;Create;True;0;0;False;0;False;0;0.5;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;604;-64.09579,615.5345;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;528;-2488.037,-911.6692;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;492;-1315.055,-291.1007;Inherit;False;Property;_FresnelColor;FresnelColor;5;0;Create;True;0;0;False;0;False;1,1,1,1;0.504717,0.5459248,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;527;-2617.816,-922.1541;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;712;554.1199,777.368;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;RO/UI_Effect_Shu_01;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;True;0.003;0.1698113,0.1698113,0.1698113,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;687;5;688;0
WireConnection;143;0;26;1
WireConnection;693;0;687;1
WireConnection;693;1;687;2
WireConnection;694;0;693;0
WireConnection;694;1;690;0
WireConnection;695;0;694;0
WireConnection;695;2;687;3
WireConnection;7;5;556;0
WireConnection;686;0;7;0
WireConnection;686;1;695;0
WireConnection;5;0;686;0
WireConnection;100;0;5;0
WireConnection;673;0;672;0
WireConnection;674;0;677;0
WireConnection;674;1;673;0
WireConnection;675;0;683;0
WireConnection;675;1;674;0
WireConnection;676;0;675;0
WireConnection;678;0;676;0
WireConnection;698;0;697;0
WireConnection;698;1;696;0
WireConnection;699;0;698;0
WireConnection;663;0;699;0
WireConnection;663;1;661;0
WireConnection;664;0;663;0
WireConnection;664;1;663;0
WireConnection;665;0;664;0
WireConnection;340;0;5;0
WireConnection;54;0;32;0
WireConnection;54;1;5;0
WireConnection;343;0;32;0
WireConnection;339;0;54;0
WireConnection;339;1;340;0
WireConnection;339;2;341;0
WireConnection;666;0;665;0
WireConnection;342;0;339;0
WireConnection;342;1;343;0
WireConnection;668;0;666;0
WireConnection;668;1;667;0
WireConnection;336;0;342;0
WireConnection;336;1;337;0
WireConnection;671;0;668;0
WireConnection;338;0;336;0
WireConnection;144;0;26;2
WireConnection;681;0;338;0
WireConnection;681;1;680;0
WireConnection;681;2;684;0
WireConnection;685;0;338;0
WireConnection;685;1;681;0
WireConnection;401;0;54;0
WireConnection;358;0;685;0
WireConnection;358;1;669;0
WireConnection;358;2;562;0
WireConnection;71;0;401;0
WireConnection;547;0;358;0
WireConnection;617;0;26;4
WireConnection;362;0;547;0
WireConnection;610;0;581;0
WireConnection;610;1;612;0
WireConnection;610;2;611;0
WireConnection;625;0;586;1
WireConnection;718;0;598;0
WireConnection;640;0;639;0
WireConnection;640;1;634;0
WireConnection;628;1;625;1
WireConnection;613;0;585;0
WireConnection;613;1;588;0
WireConnection;613;2;614;0
WireConnection;599;0;619;0
WireConnection;599;1;610;0
WireConnection;638;0;632;0
WireConnection;638;1;639;0
WireConnection;633;0;638;0
WireConnection;633;1;640;0
WireConnection;717;0;625;3
WireConnection;717;1;719;0
WireConnection;592;0;613;0
WireConnection;592;1;591;0
WireConnection;592;2;605;0
WireConnection;592;3;619;0
WireConnection;592;4;599;0
WireConnection;597;0;599;0
WireConnection;597;3;598;0
WireConnection;597;4;600;0
WireConnection;627;0;628;0
WireConnection;626;0;627;0
WireConnection;626;1;625;2
WireConnection;626;2;717;0
WireConnection;601;0;592;0
WireConnection;601;1;597;0
WireConnection;635;0;633;0
WireConnection;649;0;633;0
WireConnection;641;0;601;0
WireConnection;145;0;26;3
WireConnection;624;0;626;0
WireConnection;624;1;586;1
WireConnection;624;2;635;0
WireConnection;643;0;624;0
WireConnection;643;1;580;0
WireConnection;643;2;644;0
WireConnection;648;0;650;0
WireConnection;602;0;643;0
WireConnection;602;1;646;0
WireConnection;651;0;648;0
WireConnection;651;3;652;0
WireConnection;651;4;653;0
WireConnection;715;0;603;0
WireConnection;716;1;715;0
WireConnection;647;0;602;0
WireConnection;647;1;651;0
WireConnection;707;0;703;0
WireConnection;529;0;528;0
WireConnection;97;0;92;0
WireConnection;491;0;97;0
WireConnection;491;1;492;0
WireConnection;134;0;491;0
WireConnection;714;0;716;0
WireConnection;714;1;647;0
WireConnection;92;2;412;0
WireConnection;604;0;603;0
WireConnection;604;1;616;0
WireConnection;528;0;527;0
WireConnection;527;0;401;0
WireConnection;527;1;358;0
WireConnection;712;2;604;0
WireConnection;712;13;714;0
ASEEND*/
//CHKSM=B3E66606C2CFBD75F6C88C93E9B0C82C274E228D