// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "RO/UI_Effect_FangShe_01"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		
		_StencilComp ("Stencil Comparison", Float) = 8
		_Stencil ("Stencil ID", Float) = 0
		_StencilOp ("Stencil Operation", Float) = 0
		_StencilWriteMask ("Stencil Write Mask", Float) = 255
		_StencilReadMask ("Stencil Read Mask", Float) = 255

		_ColorMask ("Color Mask", Float) = 15

		[Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0
		_EffectTex("EffectTex", 2D) = "white" {}
		[KeywordEnum(R,G,B,A)] _Keyword01("Keyword01", Float) = 0
		[HDR]_LBYS("亮部颜色", Color) = (1,1,1,1)
		[HDR]_ABYS("暗部颜色", Color) = (1,1,1,1)
		_Str("强度", Float) = 1
		_AlPha("透明度", Float) = 1
		_1("X(边数)Y(长短)Z(旋转)W(放射)", Vector) = (0,0,0,0)
		_2("X(边数)Y(长短)Z(旋转)W(放射)", Vector) = (0,0,0,0)
		_FSGQXWB("放射光球型外边", Range( 0.5 , 1)) = 0.5
		_FSGQXNB("放射光球型内边", Range( 0 , 1)) = 1
		_FSGWB("放射光外边", Range( 0 , 1)) = 0
		_FSGNB("放射光内边", Range( 0 , 1)) = 0
		_FSGWB2("放射光外边2", Range( 0 , 1)) = 0
		_FSGNB2("放射光内边2", Range( 0 , 1)) = 0
		_NBQTGLWZ("内部球体高亮位置", Range( 0.5 , 1)) = 0.5
		_NBQTXSWZ("内部球体消失位置", Range( 0 , 1)) = 1
		_NBQQD("内部球强度", Range( 0 , 1)) = 1
		[Toggle(_KEYWORD0_ON)] _Keyword0("内球反色", Float) = 0
		[Enum(UnityEngine.Rendering.BlendMode)]_Src("Src", Float) = 5
		[Enum(UnityEngine.Rendering.BlendMode)]_Dst("Dst", Float) = 10
		[Enum(UnityEngine.Rendering.CullMode)]_CullMode("CullMode", Float) = 0
		[Enum(UnityEngine.Rendering.CompareFunction)]_ZTest("ZTest", Float) = 4
		_UVSpeed("UVSpeed", Vector) = (0,0,0,0)

	}

	SubShader
	{
		LOD 0

		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" "CanUseSpriteAtlas"="True" }
		
		Stencil
		{
			Ref [_Stencil]
			ReadMask [_StencilReadMask]
			WriteMask [_StencilWriteMask]
			CompFront [_StencilComp]
			PassFront [_StencilOp]
			FailFront Keep
			ZFailFront Keep
			CompBack Always
			PassBack Keep
			FailBack Keep
			ZFailBack Keep
		}


		Cull [_CullMode]
		Lighting Off
		ZWrite Off
		ZTest [_ZTest]
		Blend [_Src] [_Dst]
		ColorMask [_ColorMask]

		
		Pass
		{
			Name "Default"
		CGPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0

			#include "UnityCG.cginc"
			#include "UnityUI.cginc"

			#pragma multi_compile __ UNITY_UI_CLIP_RECT
			#pragma multi_compile __ UNITY_UI_ALPHACLIP
			
			#include "UnityShaderVariables.cginc"
			#define ASE_NEEDS_FRAG_COLOR
			#pragma shader_feature _KEYWORD0_ON
			#pragma shader_feature _KEYWORD01_R _KEYWORD01_G _KEYWORD01_B _KEYWORD01_A

			
			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				fixed4 color    : COLOR;
				half2 texcoord  : TEXCOORD0;
				float4 worldPosition : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				
			};
			
			uniform fixed4 _Color;
			uniform fixed4 _TextureSampleAdd;
			uniform float4 _ClipRect;
			uniform sampler2D _MainTex;
			uniform float _CullMode;
			uniform float _ZTest;
			uniform float _Src;
			uniform float _Dst;
			uniform float4 _ABYS;
			uniform float4 _LBYS;
			uniform float _NBQTGLWZ;
			uniform float _NBQTXSWZ;
			uniform float _NBQQD;
			uniform float _FSGWB2;
			uniform float _FSGNB2;
			uniform sampler2D _EffectTex;
			uniform float4 _2;
			uniform float4 _UVSpeed;
			uniform float4 _1;
			uniform float _FSGQXWB;
			uniform float _FSGQXNB;
			uniform float _FSGWB;
			uniform float _FSGNB;
			uniform float _Str;
			uniform float _AlPha;

			
			v2f vert( appdata_t IN  )
			{
				v2f OUT;
				UNITY_SETUP_INSTANCE_ID( IN );
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
				UNITY_TRANSFER_INSTANCE_ID(IN, OUT);
				OUT.worldPosition = IN.vertex;
				
				
				OUT.worldPosition.xyz +=  float3( 0, 0, 0 ) ;
				OUT.vertex = UnityObjectToClipPos(OUT.worldPosition);

				OUT.texcoord = IN.texcoord;
				
				OUT.color = IN.color * _Color;
				return OUT;
			}

			fixed4 frag(v2f IN  ) : SV_Target
			{
				float Src265 = _Src;
				float Dst266 = _Dst;
				float temp_output_303_0 = saturate( _NBQTGLWZ );
				float2 texCoord168 = IN.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult173 = smoothstep( temp_output_303_0 , saturate( ( temp_output_303_0 + _NBQTXSWZ ) ) , ( 1.0 - distance( float2( 0.5,0.5 ) , texCoord168 ) ));
				float temp_output_200_0 = ( smoothstepResult173 * _NBQQD );
				float temp_output_304_0 = saturate( _FSGWB2 );
				float2 appendResult157 = (float2(_2.z , _2.w));
				float2 texCoord213 = IN.texcoord.xy * float2( 2,2 ) + float2( 0,0 );
				float2 temp_output_228_0 = ( texCoord213 - float2( 1,1 ) );
				float2 appendResult233 = (float2(frac( ( atan2( (temp_output_228_0).x , (temp_output_228_0).y ) / 6.28318548202515 ) ) , length( temp_output_228_0 )));
				float2 UV251 = appendResult233;
				float2 panner241 = ( ( (appendResult157).x * _Time.y ) * float2( 1,0 ) + UV251);
				float2 panner242 = ( ( _Time.y * (appendResult157).y ) * float2( 0,1 ) + UV251);
				float2 appendResult240 = (float2((panner241).x , (panner242).y));
				float2 appendResult289 = (float2(_UVSpeed.x , _UVSpeed.y));
				float2 appendResult156 = (float2(floor( _2.x ) , _2.y));
				float4 tex2DNode152 = tex2D( _EffectTex, ( ( appendResult240 + appendResult289 ) * appendResult156 ) );
				float2 appendResult21 = (float2(floor( _1.x ) , _1.y));
				float2 appendResult22 = (float2(_1.z , _1.w));
				float2 panner208 = ( ( (appendResult22).x * _Time.y ) * float2( 1,0 ) + UV251);
				float2 panner209 = ( ( _Time.y * (appendResult22).y ) * float2( 0,1 ) + UV251);
				float2 appendResult231 = (float2((panner208).x , (panner209).y));
				float2 appendResult290 = (float2(_UVSpeed.z , _UVSpeed.w));
				float2 UVSpedd292 = appendResult290;
				float4 tex2DNode106 = tex2D( _EffectTex, ( appendResult21 * ( appendResult231 + UVSpedd292 ) ) );
				float2 appendResult279 = (float2(tex2DNode152.r , tex2DNode106.r));
				float2 appendResult280 = (float2(tex2DNode152.g , tex2DNode106.g));
				float2 appendResult281 = (float2(tex2DNode152.b , tex2DNode106.b));
				float2 appendResult283 = (float2(tex2DNode152.a , tex2DNode106.a));
				#if defined(_KEYWORD01_R)
				float2 staticSwitch284 = appendResult279;
				#elif defined(_KEYWORD01_G)
				float2 staticSwitch284 = appendResult280;
				#elif defined(_KEYWORD01_B)
				float2 staticSwitch284 = appendResult281;
				#elif defined(_KEYWORD01_A)
				float2 staticSwitch284 = appendResult283;
				#else
				float2 staticSwitch284 = appendResult279;
				#endif
				float2 break286 = staticSwitch284;
				float smoothstepResult180 = smoothstep( temp_output_304_0 , saturate( ( temp_output_304_0 + _FSGNB2 ) ) , break286.x);
				float temp_output_306_0 = saturate( _FSGQXWB );
				float2 texCoord29 = IN.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult34 = smoothstep( temp_output_306_0 , saturate( ( temp_output_306_0 + _FSGQXNB ) ) , ( 1.0 - distance( float2( 0.5,0.5 ) , texCoord29 ) ));
				float temp_output_305_0 = saturate( _FSGWB );
				float smoothstepResult179 = smoothstep( temp_output_305_0 , saturate( ( temp_output_305_0 + _FSGNB ) ) , break286.y);
				float temp_output_166_0 = saturate( ( ( smoothstepResult180 * smoothstepResult34 ) * ( smoothstepResult179 * smoothstepResult34 ) ) );
				#ifdef _KEYWORD0_ON
				float staticSwitch203 = ( ( 1.0 - temp_output_200_0 ) * temp_output_166_0 );
				#else
				float staticSwitch203 = max( temp_output_200_0 , temp_output_166_0 );
				#endif
				float4 lerpResult191 = lerp( _ABYS , _LBYS , staticSwitch203);
				float4 break269 = ( lerpResult191 * staticSwitch203 * IN.color );
				float3 appendResult270 = (float3(break269.r , break269.g , break269.b));
				float3 temp_output_276_0 = ( appendResult270 * _Str );
				float4 appendResult274 = (float4(( temp_output_276_0 * break269.a ) , 1.0));
				float4 appendResult272 = (float4(temp_output_276_0 , ( break269.a * _AlPha )));
				
				half4 color = ( Src265 == Dst266 ? appendResult274 : appendResult272 );
				
				#ifdef UNITY_UI_CLIP_RECT
                color.a *= UnityGet2DClipping(IN.worldPosition.xy, _ClipRect);
                #endif
				
				#ifdef UNITY_UI_ALPHACLIP
				clip (color.a - 0.001);
				#endif

				return color;
			}
		ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18500
1927;7;1906;1004;2282.923;1333.325;1.921866;True;True
Node;AmplifyShaderEditor.CommentaryNode;207;-3475,1235.081;Inherit;False;1966.816;591.2493;;13;251;233;235;211;212;216;214;234;230;228;213;221;215;Radial Math;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;215;-3459,1475.081;Float;False;Constant;_Vector2;Vector 2;0;0;Create;True;0;0;False;0;False;2,2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;221;-3073.994,1570.249;Float;False;Constant;_Vector5;Vector 5;0;0;Create;True;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;213;-3196.001,1393.081;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;228;-2916.508,1378.829;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;234;-2707,1299.081;Inherit;False;True;False;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;230;-2707,1379.081;Inherit;False;False;True;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TauNode;214;-2457.649,1412.576;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.ATan2OpNode;216;-2462.461,1298.059;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;212;-2298.83,1301.237;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;237;-3272.145,-1024.602;Inherit;False;2550.754;540.2195;;23;154;155;157;156;252;250;248;249;240;239;238;241;242;243;246;244;245;247;287;288;289;290;292;Ring Panner;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;206;-3824.232,-216.7986;Inherit;False;3027.956;568.8607;;18;253;231;225;223;208;209;210;229;220;226;232;21;43;22;20;236;293;294;Ring Panner;1,1,1,1;0;0
Node;AmplifyShaderEditor.LengthOpNode;235;-2469.187,1639.875;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;211;-2115,1379.081;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;154;-3188.195,-888.8937;Inherit;False;Property;_2;X(边数)Y(长短)Z(旋转)W(放射);7;0;Create;False;0;0;False;0;False;0,0,0,0;3.81,0.001,0,10;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;20;-3670.463,19.62433;Inherit;False;Property;_1;X(边数)Y(长短)Z(旋转)W(放射);6;0;Create;False;0;0;False;0;False;0,0,0,0;2.2,0.001,0,20;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;157;-2675.66,-757.0037;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;233;-1983.996,1540.373;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;22;-3130.226,36.48443;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;245;-2228.231,-958.5626;Inherit;False;True;False;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;251;-1733.8,1530.848;Inherit;False;UV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;244;-2212.231,-766.5626;Inherit;False;False;True;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;247;-2132.231,-846.5627;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;232;-2256.697,37.83855;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;220;-2336.697,117.8386;Inherit;False;False;True;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;226;-2352.697,-74.16132;Inherit;False;True;False;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;288;-1540.587,-688.5573;Inherit;False;Property;_UVSpeed;UVSpeed;22;0;Create;True;0;0;False;0;False;0,0,0,0;0,81.2,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;252;-1873.362,-985.7511;Inherit;False;251;UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;253;-1986.469,-125.0219;Inherit;False;251;UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;229;-1979.898,-14.35937;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;210;-1989.698,106.8386;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;243;-1865.232,-777.5626;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;246;-1855.432,-898.7604;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;155;-2838.398,-948.9376;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;209;-1757.872,98.79852;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;290;-1236.759,-613.5836;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;241;-1628.406,-974.6017;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;208;-1752.872,-90.20039;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;242;-1633.406,-785.6027;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;225;-1513.873,-86.20039;Inherit;False;True;False;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;238;-1388.406,-792.6027;Inherit;False;False;True;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;239;-1389.406,-970.6017;Inherit;False;True;False;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;292;-1083.759,-614.5836;Inherit;False;UVSpedd;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;156;-2676.35,-949.0776;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;223;-1512.873,91.79852;Inherit;False;False;True;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;289;-1185.587,-717.5573;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;293;-1341.934,210.0982;Inherit;False;292;UVSpedd;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;240;-1180.405,-878.6027;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;231;-1263.871,51.79852;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;250;-2046.489,-572.8737;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FloorOpNode;43;-3380.084,-69.93654;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;287;-1029.315,-825.6664;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;294;-1129.527,103.2432;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;21;-3146.48,-88.71284;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;249;-900.812,-538.5147;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;248;-876.2395,-791.2346;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;151;-982.7722,-445.5132;Inherit;True;Property;_EffectTex;EffectTex;0;0;Create;True;0;0;False;0;False;None;4eb6cae89f612284aa61878000ae82ef;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;236;-1003.495,-4.935183;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;159;-133.9393,-936.983;Inherit;False;Property;_FSGWB2;放射光外边2;12;0;Create;False;0;0;False;0;False;0;0.446;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;149;-246.0918,-56.3523;Inherit;False;Property;_FSGWB;放射光外边;10;0;Create;False;0;0;False;0;False;0;0.412;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-390.5873,696.6257;Inherit;False;Property;_FSGQXWB;放射光球型外边;8;0;Create;False;0;0;False;0;False;0.5;0.5;0.5;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;106;-582.1539,-342.9943;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;False;0;False;-1;None;969ecbc14f60cc64b90793e218e934ab;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;152;-592.9533,-585.5167;Inherit;True;Property;_TextureSample2;Texture Sample 2;3;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;172;-104.9936,-1151.676;Inherit;False;Property;_NBQTGLWZ;内部球体高亮位置;14;0;Create;False;0;0;False;0;False;0.5;1;0.5;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;304;184.3863,-880.1692;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;182;-137.9059,205.3027;Inherit;False;Property;_FSGNB;放射光内边;11;0;Create;False;0;0;False;0;False;0;0.489;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;181;25.7014,-774.3945;Inherit;False;Property;_FSGNB2;放射光内边2;13;0;Create;False;0;0;False;0;False;0;0.615;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;306;32.71088,674.1732;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;29;-458.7421,519.2194;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;279;-205.8043,-657.9871;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;281;-186.0194,-419.9977;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;305;90.83319,24.285;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;283;-188.6311,-309.8986;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;280;-195.5998,-522.9435;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;28;-414.1953,390.1567;Inherit;False;Constant;_Vector3;Vector 3;2;0;Create;True;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;36;-260.1737,844.9932;Inherit;False;Property;_FSGQXNB;放射光球型内边;9;0;Create;False;0;0;False;0;False;1;0.995;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;168;-476.0454,-1203.828;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;284;-3.148716,-531.6512;Inherit;False;Property;_Keyword01;Keyword01;1;0;Create;True;0;0;False;0;False;0;0;0;True;;KeywordEnum;4;R;G;B;A;Create;False;True;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;170;37.00639,-1036.675;Inherit;False;Property;_NBQTXSWZ;内部球体消失位置;15;0;Create;False;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;303;213.3863,-1134.169;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;299;165.6241,150.9711;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;25;-129.9919,418.0317;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;297;242.2217,781.6388;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;295;350.6533,-791.4912;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;167;-415.0457,-1408.828;Inherit;False;Constant;_Vector4;Vector 4;2;0;Create;True;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SaturateNode;300;339.6241,159.9711;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;169;-127.0456,-1370.828;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;298;381.3662,753.0153;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;301;401.2538,-1070.412;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;296;481.6533,-783.4912;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;30;100.4459,419.0149;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;286;212.9354,-508.2029;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SmoothstepOpNode;179;497.7599,-66.5592;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;34;571.9556,265.2896;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;302;546.0354,-1086.923;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;171;122.3767,-1358.454;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;180;626.142,-829.6782;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;161;848.2967,-811.4003;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;197;914.3596,-263.4768;Inherit;False;Property;_NBQQD;内部球强度;16;0;Create;False;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;165;1069.384,-1.844897;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;173;736.2147,-1315.197;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;200;1261.047,-314.4956;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;190;1220.709,-133.1929;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;205;1403.998,-474.7574;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;166;1407.347,-79.23215;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;196;1673.977,-118.6686;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;204;1666.968,-10.87138;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;175;1604.664,-355.4239;Inherit;False;Property;_LBYS;亮部颜色;2;1;[HDR];Create;False;0;0;False;0;False;1,1,1,1;1,0.3254717,0.3254717,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;203;1872.677,-48.45058;Inherit;False;Property;_Keyword0;内球反色;17;0;Create;False;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;False;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;174;1595.036,-514.1945;Inherit;False;Property;_ABYS;暗部颜色;3;1;[HDR];Create;False;0;0;False;0;False;1,1,1,1;1,0.6964086,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;42;1834.18,197.5683;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;191;1916.461,-369.5859;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;2372.978,-110.6555;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;269;2547.941,-80.74792;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;277;2633.624,98.1424;Inherit;False;Property;_Str;强度;4;0;Create;False;0;0;False;0;False;1;2.58;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;270;2797.941,-95.7479;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;162;2592.834,223.288;Inherit;False;Property;_AlPha;透明度;5;0;Create;False;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;260;1346.699,-1261.56;Inherit;False;Property;_Dst;Dst;19;1;[Enum];Create;True;0;1;UnityEngine.Rendering.BlendMode;True;0;False;10;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;276;2965.624,-50.8576;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;261;1346.699,-1421.56;Inherit;False;Property;_Src;Src;18;1;[Enum];Create;True;0;1;UnityEngine.Rendering.BlendMode;True;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;266;1595.543,-1264.316;Inherit;False;Dst;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;265;1577.543,-1444.316;Inherit;False;Src;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;273;3098.941,-226.7479;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;275;2924.919,82.23022;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;272;3192.941,-90.74792;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;274;3238.941,-217.7479;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;258;3177.241,-351.2892;Inherit;False;266;Dst;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;259;3188.302,-480.5729;Inherit;False;265;Src;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;262;1122.699,-1421.56;Inherit;False;Property;_CullMode;CullMode;20;1;[Enum];Create;True;0;1;UnityEngine.Rendering.CullMode;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;263;978.699,-1421.56;Inherit;False;Property;_ZTest;ZTest;21;1;[Enum];Create;True;0;1;UnityEngine.Rendering.CompareFunction;True;0;False;4;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Compare;257;3440.931,-297.5026;Inherit;False;0;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;278;3764.604,-269.5379;Float;False;True;-1;2;ASEMaterialInspector;0;4;RO/UI_Effect_FangShe_01;5056123faa0c79b47ab6ad7e8bf059a4;True;Default;0;0;Default;2;True;2;5;True;261;10;True;260;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;True;2;True;262;True;True;True;True;True;0;True;-9;False;False;False;True;True;0;True;-5;255;True;-8;255;True;-7;0;True;-4;0;True;-6;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;264;True;0;True;263;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;213;0;215;0
WireConnection;228;0;213;0
WireConnection;228;1;221;0
WireConnection;234;0;228;0
WireConnection;230;0;228;0
WireConnection;216;0;234;0
WireConnection;216;1;230;0
WireConnection;212;0;216;0
WireConnection;212;1;214;0
WireConnection;235;0;228;0
WireConnection;211;0;212;0
WireConnection;157;0;154;3
WireConnection;157;1;154;4
WireConnection;233;0;211;0
WireConnection;233;1;235;0
WireConnection;22;0;20;3
WireConnection;22;1;20;4
WireConnection;245;0;157;0
WireConnection;251;0;233;0
WireConnection;244;0;157;0
WireConnection;220;0;22;0
WireConnection;226;0;22;0
WireConnection;229;0;226;0
WireConnection;229;1;232;0
WireConnection;210;0;232;0
WireConnection;210;1;220;0
WireConnection;243;0;247;0
WireConnection;243;1;244;0
WireConnection;246;0;245;0
WireConnection;246;1;247;0
WireConnection;155;0;154;1
WireConnection;209;0;253;0
WireConnection;209;1;210;0
WireConnection;290;0;288;3
WireConnection;290;1;288;4
WireConnection;241;0;252;0
WireConnection;241;1;246;0
WireConnection;208;0;253;0
WireConnection;208;1;229;0
WireConnection;242;0;252;0
WireConnection;242;1;243;0
WireConnection;225;0;208;0
WireConnection;238;0;242;0
WireConnection;239;0;241;0
WireConnection;292;0;290;0
WireConnection;156;0;155;0
WireConnection;156;1;154;2
WireConnection;223;0;209;0
WireConnection;289;0;288;1
WireConnection;289;1;288;2
WireConnection;240;0;239;0
WireConnection;240;1;238;0
WireConnection;231;0;225;0
WireConnection;231;1;223;0
WireConnection;250;0;156;0
WireConnection;43;0;20;1
WireConnection;287;0;240;0
WireConnection;287;1;289;0
WireConnection;294;0;231;0
WireConnection;294;1;293;0
WireConnection;21;0;43;0
WireConnection;21;1;20;2
WireConnection;249;0;250;0
WireConnection;248;0;287;0
WireConnection;248;1;249;0
WireConnection;236;0;21;0
WireConnection;236;1;294;0
WireConnection;106;0;151;0
WireConnection;106;1;236;0
WireConnection;152;0;151;0
WireConnection;152;1;248;0
WireConnection;304;0;159;0
WireConnection;306;0;35;0
WireConnection;279;0;152;1
WireConnection;279;1;106;1
WireConnection;281;0;152;3
WireConnection;281;1;106;3
WireConnection;305;0;149;0
WireConnection;283;0;152;4
WireConnection;283;1;106;4
WireConnection;280;0;152;2
WireConnection;280;1;106;2
WireConnection;284;1;279;0
WireConnection;284;0;280;0
WireConnection;284;2;281;0
WireConnection;284;3;283;0
WireConnection;303;0;172;0
WireConnection;299;0;305;0
WireConnection;299;1;182;0
WireConnection;25;0;28;0
WireConnection;25;1;29;0
WireConnection;297;0;306;0
WireConnection;297;1;36;0
WireConnection;295;0;304;0
WireConnection;295;1;181;0
WireConnection;300;0;299;0
WireConnection;169;0;167;0
WireConnection;169;1;168;0
WireConnection;298;0;297;0
WireConnection;301;0;303;0
WireConnection;301;1;170;0
WireConnection;296;0;295;0
WireConnection;30;0;25;0
WireConnection;286;0;284;0
WireConnection;179;0;286;1
WireConnection;179;1;305;0
WireConnection;179;2;300;0
WireConnection;34;0;30;0
WireConnection;34;1;306;0
WireConnection;34;2;298;0
WireConnection;302;0;301;0
WireConnection;171;0;169;0
WireConnection;180;0;286;0
WireConnection;180;1;304;0
WireConnection;180;2;296;0
WireConnection;161;0;180;0
WireConnection;161;1;34;0
WireConnection;165;0;179;0
WireConnection;165;1;34;0
WireConnection;173;0;171;0
WireConnection;173;1;303;0
WireConnection;173;2;302;0
WireConnection;200;0;173;0
WireConnection;200;1;197;0
WireConnection;190;0;161;0
WireConnection;190;1;165;0
WireConnection;205;0;200;0
WireConnection;166;0;190;0
WireConnection;196;0;200;0
WireConnection;196;1;166;0
WireConnection;204;0;205;0
WireConnection;204;1;166;0
WireConnection;203;1;196;0
WireConnection;203;0;204;0
WireConnection;191;0;174;0
WireConnection;191;1;175;0
WireConnection;191;2;203;0
WireConnection;40;0;191;0
WireConnection;40;1;203;0
WireConnection;40;2;42;0
WireConnection;269;0;40;0
WireConnection;270;0;269;0
WireConnection;270;1;269;1
WireConnection;270;2;269;2
WireConnection;276;0;270;0
WireConnection;276;1;277;0
WireConnection;266;0;260;0
WireConnection;265;0;261;0
WireConnection;273;0;276;0
WireConnection;273;1;269;3
WireConnection;275;0;269;3
WireConnection;275;1;162;0
WireConnection;272;0;276;0
WireConnection;272;3;275;0
WireConnection;274;0;273;0
WireConnection;257;0;259;0
WireConnection;257;1;258;0
WireConnection;257;2;274;0
WireConnection;257;3;272;0
WireConnection;278;0;257;0
ASEEND*/
//CHKSM=CE8E8BD5A50F62176218A05EB031542BE3272D66