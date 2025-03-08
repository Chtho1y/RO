// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "RO/RO_Effect_FangShe_01"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
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
		_UVSpeed1("UVSpeed", Vector) = (0,0,0,0)

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend [_Src] [_Dst]
		AlphaToMask Off
		Cull [_CullMode]
		ColorMask RGBA
		ZWrite Off
		ZTest [_ZTest]
		
		
		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"
			#pragma shader_feature _KEYWORD0_ON
			#pragma shader_feature _KEYWORD01_R _KEYWORD01_G _KEYWORD01_B _KEYWORD01_A


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

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
			uniform sampler2D _MainTex;
			uniform float4 _2;
			uniform float4 _UVSpeed1;
			uniform float4 _1;
			uniform float _FSGQXWB;
			uniform float _FSGQXNB;
			uniform float _FSGWB;
			uniform float _FSGNB;
			uniform float _Str;
			uniform float _AlPha;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				o.ase_color = v.color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float Src265 = _Src;
				float Dst266 = _Dst;
				float temp_output_298_0 = saturate( _NBQTGLWZ );
				float2 texCoord168 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult173 = smoothstep( temp_output_298_0 , saturate( ( temp_output_298_0 + _NBQTXSWZ ) ) , ( 1.0 - distance( float2( 0.5,0.5 ) , texCoord168 ) ));
				float temp_output_200_0 = ( smoothstepResult173 * _NBQQD );
				float temp_output_299_0 = saturate( _FSGWB2 );
				float2 appendResult157 = (float2(_2.z , _2.w));
				float2 texCoord213 = i.ase_texcoord1.xy * float2( 2,2 ) + float2( 0,0 );
				float2 temp_output_228_0 = ( texCoord213 - float2( 1,1 ) );
				float2 appendResult233 = (float2(frac( ( atan2( (temp_output_228_0).x , (temp_output_228_0).y ) / 6.28318548202515 ) ) , length( temp_output_228_0 )));
				float2 UV251 = appendResult233;
				float2 panner241 = ( ( (appendResult157).x * _Time.y ) * float2( 1,0 ) + UV251);
				float2 panner242 = ( ( _Time.y * (appendResult157).y ) * float2( 0,1 ) + UV251);
				float2 appendResult240 = (float2((panner241).x , (panner242).y));
				float2 appendResult285 = (float2(_UVSpeed1.x , _UVSpeed1.y));
				float2 appendResult156 = (float2(floor( _2.x ) , _2.y));
				float4 tex2DNode152 = tex2D( _MainTex, ( ( appendResult240 + appendResult285 ) * appendResult156 ) );
				float2 appendResult21 = (float2(floor( _1.x ) , _1.y));
				float2 appendResult22 = (float2(_1.z , _1.w));
				float2 panner208 = ( ( (appendResult22).x * _Time.y ) * float2( 1,0 ) + UV251);
				float2 panner209 = ( ( _Time.y * (appendResult22).y ) * float2( 0,1 ) + UV251);
				float2 appendResult231 = (float2((panner208).x , (panner209).y));
				float2 appendResult286 = (float2(_UVSpeed1.z , _UVSpeed1.w));
				float2 UVSpedd287 = appendResult286;
				float4 tex2DNode106 = tex2D( _MainTex, ( appendResult21 * ( appendResult231 + UVSpedd287 ) ) );
				float2 appendResult281 = (float2(tex2DNode152.r , tex2DNode106.r));
				float2 appendResult280 = (float2(tex2DNode152.g , tex2DNode106.g));
				float2 appendResult279 = (float2(tex2DNode152.b , tex2DNode106.b));
				float2 appendResult278 = (float2(tex2DNode152.a , tex2DNode106.a));
				#if defined(_KEYWORD01_R)
				float2 staticSwitch282 = appendResult281;
				#elif defined(_KEYWORD01_G)
				float2 staticSwitch282 = appendResult280;
				#elif defined(_KEYWORD01_B)
				float2 staticSwitch282 = appendResult279;
				#elif defined(_KEYWORD01_A)
				float2 staticSwitch282 = appendResult278;
				#else
				float2 staticSwitch282 = appendResult281;
				#endif
				float2 break283 = staticSwitch282;
				float smoothstepResult180 = smoothstep( temp_output_299_0 , saturate( ( temp_output_299_0 + _FSGNB2 ) ) , break283.x);
				float temp_output_301_0 = saturate( _FSGQXWB );
				float2 texCoord29 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult34 = smoothstep( temp_output_301_0 , ( temp_output_301_0 + _FSGQXNB ) , ( 1.0 - distance( float2( 0.5,0.5 ) , texCoord29 ) ));
				float temp_output_300_0 = saturate( _FSGWB );
				float smoothstepResult179 = smoothstep( temp_output_300_0 , saturate( ( temp_output_300_0 + _FSGNB ) ) , break283.y);
				float temp_output_166_0 = saturate( ( ( smoothstepResult180 * smoothstepResult34 ) * ( smoothstepResult179 * smoothstepResult34 ) ) );
				#ifdef _KEYWORD0_ON
				float staticSwitch203 = ( ( 1.0 - temp_output_200_0 ) * temp_output_166_0 );
				#else
				float staticSwitch203 = max( temp_output_200_0 , temp_output_166_0 );
				#endif
				float4 lerpResult191 = lerp( _ABYS , _LBYS , staticSwitch203);
				float4 break269 = ( lerpResult191 * staticSwitch203 * i.ase_color );
				float3 appendResult270 = (float3(break269.r , break269.g , break269.b));
				float3 temp_output_276_0 = ( appendResult270 * _Str );
				float4 appendResult274 = (float4(( temp_output_276_0 * break269.a ) , 1.0));
				float4 appendResult272 = (float4(temp_output_276_0 , ( break269.a * _AlPha )));
				
				
				finalColor = ( Src265 == Dst266 ? appendResult274 : appendResult272 );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18500
2005;1;1650;1010;620.4385;1587.606;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;207;-3475,1235.081;Inherit;False;1966.816;591.2493;;13;251;233;235;211;212;216;214;234;230;228;213;221;215;Radial Math;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;215;-3459,1475.081;Float;False;Constant;_Vector2;Vector 2;0;0;Create;True;0;0;False;0;False;2,2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;221;-3073.994,1570.249;Float;False;Constant;_Vector5;Vector 5;0;0;Create;True;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;213;-3196.001,1393.081;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;228;-2916.508,1378.829;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;230;-2707,1379.081;Inherit;False;False;True;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;234;-2707,1299.081;Inherit;False;True;False;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TauNode;214;-2457.649,1412.576;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.ATan2OpNode;216;-2462.461,1298.059;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;212;-2298.83,1301.237;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;237;-3272.145,-1024.602;Inherit;False;2566.564;579.7446;;23;249;284;285;288;240;287;286;248;250;238;239;242;241;156;243;252;246;155;244;247;245;157;154;Ring Panner;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;206;-4025.251,-184.3964;Inherit;False;3027.956;568.8607;;18;253;231;225;223;208;209;210;229;220;226;232;21;43;22;20;236;289;290;Ring Panner;1,1,1,1;0;0
Node;AmplifyShaderEditor.LengthOpNode;235;-2469.187,1639.875;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;20;-3871.482,52.02656;Inherit;False;Property;_1;X(边数)Y(长短)Z(旋转)W(放射);6;0;Create;False;0;0;False;0;False;0,0,0,0;2,0.001,-0.01,-10;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;154;-3188.195,-888.8937;Inherit;False;Property;_2;X(边数)Y(长短)Z(旋转)W(放射);7;0;Create;False;0;0;False;0;False;0,0,0,0;7,0.001,-0.01,-5.03;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FractNode;211;-2115,1379.081;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;22;-3331.245,68.88666;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;157;-2675.66,-757.0037;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;233;-1983.996,1540.373;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;245;-2228.231,-958.5626;Inherit;False;True;False;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;247;-2132.231,-846.5627;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;232;-2457.715,70.24079;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;220;-2537.715,150.2408;Inherit;False;False;True;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;244;-2212.231,-766.5626;Inherit;False;False;True;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;226;-2553.715,-41.75909;Inherit;False;True;False;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;251;-1733.8,1530.848;Inherit;False;UV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;210;-2190.717,139.2408;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;252;-1873.362,-985.7511;Inherit;False;251;UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;243;-1865.232,-777.5626;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;229;-2180.917,18.04285;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;253;-2187.488,-92.61967;Inherit;False;251;UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;246;-1855.432,-898.7604;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;284;-1691.693,-660.9457;Inherit;False;Property;_UVSpeed1;UVSpeed;22;0;Create;True;0;0;False;0;False;0,0,0,0;0,81.2,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;286;-1354.268,-583.9956;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;208;-1953.891,-57.79816;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;242;-1633.406,-785.6027;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;241;-1628.406,-974.6017;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;209;-1958.891,131.2007;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FloorOpNode;155;-2838.398,-948.9376;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;225;-1714.892,-53.79815;Inherit;False;True;False;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;239;-1389.406,-970.6017;Inherit;False;True;False;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;238;-1388.406,-792.6027;Inherit;False;False;True;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;156;-2676.35,-949.0776;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;223;-1713.892,124.2008;Inherit;False;False;True;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;287;-1199.292,-610.687;Inherit;False;UVSpedd;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FloorOpNode;43;-3581.103,-37.53429;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;285;-1344.598,-691.9219;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;250;-2046.489,-572.8737;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;240;-1130.569,-810.5149;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;231;-1464.891,84.20075;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;289;-1504.897,275.2592;Inherit;False;287;UVSpedd;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;290;-1292.49,168.404;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;21;-3347.499,-56.31061;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;288;-993.4769,-817.9701;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;249;-940.9783,-534.6306;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;151;-822.8345,-435.4769;Inherit;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;False;0;False;None;4eb6cae89f612284aa61878000ae82ef;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;236;-1204.515,27.46704;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;248;-870.2395,-817.2346;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;152;-599.5576,-701.1498;Inherit;True;Property;_TextureSample2;Texture Sample 2;3;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;106;-586.9059,-330.0655;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;False;0;False;-1;None;969ecbc14f60cc64b90793e218e934ab;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;149;-254.0918,-96.35229;Inherit;False;Property;_FSGWB;放射光外边;10;0;Create;False;0;0;False;0;False;0;0.494;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;159;-73.9393,-847.983;Inherit;False;Property;_FSGWB2;放射光外边2;12;0;Create;False;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;29;-458.7421,519.2194;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;281;-266.6738,-665.1862;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;182;-108.9059,98.3027;Inherit;False;Property;_FSGNB;放射光内边;11;0;Create;False;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;280;-256.4693,-530.1428;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;181;6.701401,-713.3945;Inherit;False;Property;_FSGNB2;放射光内边2;13;0;Create;False;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;278;-249.5006,-317.098;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;300;76.15704,-16.98709;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;299;233.4809,-852.115;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;279;-246.8889,-427.1971;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;172;-95.9936,-1149.676;Inherit;False;Property;_NBQTGLWZ;内部球体高亮位置;14;0;Create;False;0;0;False;0;False;0.5;0.5;0.5;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;28;-414.1953,390.1567;Inherit;False;Constant;_Vector3;Vector 3;2;0;Create;True;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;35;-81.79948,694.059;Inherit;False;Property;_FSGQXWB;放射光球型外边;8;0;Create;False;0;0;False;0;False;0.5;0.5;0.5;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;25;-129.9919,418.0317;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;167;-415.0457,-1408.828;Inherit;False;Constant;_Vector4;Vector 4;2;0;Create;True;0;0;False;0;False;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.StaticSwitch;282;-64.0182,-538.8505;Inherit;False;Property;_Keyword01;Keyword01;1;0;Create;True;0;0;False;0;False;0;0;0;True;;KeywordEnum;4;R;G;B;A;Create;False;True;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;293;204.6475,57.10889;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;170;37.00639,-1036.675;Inherit;False;Property;_NBQTXSWZ;内部球体消失位置;15;0;Create;False;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;168;-476.0454,-1203.828;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;298;229.4809,-1141.115;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;291;375.3021,-771.7703;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;301;199.6581,697.699;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-56.79946,807.4027;Inherit;False;Property;_FSGQXNB;放射光球型内边;9;0;Create;False;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;30;100.4459,419.0149;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;296;397.4809,-1084.115;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;295;346.7913,762.1285;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;294;325.6475,59.10889;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;292;491.3021,-772.7703;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;169;-127.0456,-1370.828;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;283;152.0659,-515.4022;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SmoothstepOpNode;179;497.7599,-66.5592;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;171;122.3767,-1358.454;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;180;638.142,-844.6782;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;34;571.9556,265.2896;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;297;532.4809,-1101.115;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;161;848.2967,-811.4003;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;173;696.3721,-1317.787;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;165;1069.384,-1.844897;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;197;914.3596,-263.4768;Inherit;False;Property;_NBQQD;内部球强度;16;0;Create;False;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;200;1261.047,-314.4956;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;190;1220.709,-133.1929;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;166;1407.347,-79.23215;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;205;1403.998,-474.7574;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;204;1666.968,-10.87138;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;196;1673.977,-118.6686;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;175;1604.664,-355.4239;Inherit;False;Property;_LBYS;亮部颜色;2;1;[HDR];Create;False;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;203;1872.677,-48.45058;Inherit;False;Property;_Keyword0;内球反色;17;0;Create;False;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;False;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;174;1595.036,-514.1945;Inherit;False;Property;_ABYS;暗部颜色;3;1;[HDR];Create;False;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;191;1916.461,-369.5859;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;42;1834.18,197.5683;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;2372.978,-110.6555;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;269;2547.941,-80.74792;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.DynamicAppendNode;270;2797.941,-95.7479;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;277;2573.624,102.1424;Inherit;False;Property;_Str;强度;4;0;Create;False;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;276;2965.624,-50.8576;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;261;1346.699,-1421.56;Inherit;False;Property;_Src;Src;18;1;[Enum];Create;True;0;1;UnityEngine.Rendering.BlendMode;True;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;162;2592.834,223.288;Inherit;False;Property;_AlPha;透明度;5;0;Create;False;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;260;1346.699,-1261.56;Inherit;False;Property;_Dst;Dst;19;1;[Enum];Create;True;0;1;UnityEngine.Rendering.BlendMode;True;0;False;10;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;266;1595.543,-1264.316;Inherit;False;Dst;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;265;1577.543,-1444.316;Inherit;False;Src;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;273;3098.941,-226.7479;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;275;2924.919,82.23022;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;272;3192.941,-90.74792;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DynamicAppendNode;274;3238.941,-217.7479;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;258;3004.96,-329.6494;Inherit;False;266;Dst;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;259;3068.376,-543.9754;Inherit;False;265;Src;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.Compare;257;3440.931,-297.5026;Inherit;False;0;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT4;0,0,0,0;False;3;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;263;978.699,-1421.56;Inherit;False;Property;_ZTest;ZTest;21;1;[Enum];Create;True;0;1;UnityEngine.Rendering.CompareFunction;True;0;False;4;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;262;1122.699,-1421.56;Inherit;False;Property;_CullMode;CullMode;20;1;[Enum];Create;True;0;1;UnityEngine.Rendering.CullMode;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;254;3764.604,-269.5379;Float;False;True;-1;2;ASEMaterialInspector;100;1;RO/RO_Effect_FangShe_01;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;1;1;True;261;0;True;260;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;True;0;False;-1;True;0;True;262;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;264;True;3;True;263;True;False;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;False;0
WireConnection;213;0;215;0
WireConnection;228;0;213;0
WireConnection;228;1;221;0
WireConnection;230;0;228;0
WireConnection;234;0;228;0
WireConnection;216;0;234;0
WireConnection;216;1;230;0
WireConnection;212;0;216;0
WireConnection;212;1;214;0
WireConnection;235;0;228;0
WireConnection;211;0;212;0
WireConnection;22;0;20;3
WireConnection;22;1;20;4
WireConnection;157;0;154;3
WireConnection;157;1;154;4
WireConnection;233;0;211;0
WireConnection;233;1;235;0
WireConnection;245;0;157;0
WireConnection;220;0;22;0
WireConnection;244;0;157;0
WireConnection;226;0;22;0
WireConnection;251;0;233;0
WireConnection;210;0;232;0
WireConnection;210;1;220;0
WireConnection;243;0;247;0
WireConnection;243;1;244;0
WireConnection;229;0;226;0
WireConnection;229;1;232;0
WireConnection;246;0;245;0
WireConnection;246;1;247;0
WireConnection;286;0;284;3
WireConnection;286;1;284;4
WireConnection;208;0;253;0
WireConnection;208;1;229;0
WireConnection;242;0;252;0
WireConnection;242;1;243;0
WireConnection;241;0;252;0
WireConnection;241;1;246;0
WireConnection;209;0;253;0
WireConnection;209;1;210;0
WireConnection;155;0;154;1
WireConnection;225;0;208;0
WireConnection;239;0;241;0
WireConnection;238;0;242;0
WireConnection;156;0;155;0
WireConnection;156;1;154;2
WireConnection;223;0;209;0
WireConnection;287;0;286;0
WireConnection;43;0;20;1
WireConnection;285;0;284;1
WireConnection;285;1;284;2
WireConnection;250;0;156;0
WireConnection;240;0;239;0
WireConnection;240;1;238;0
WireConnection;231;0;225;0
WireConnection;231;1;223;0
WireConnection;290;0;231;0
WireConnection;290;1;289;0
WireConnection;21;0;43;0
WireConnection;21;1;20;2
WireConnection;288;0;240;0
WireConnection;288;1;285;0
WireConnection;249;0;250;0
WireConnection;236;0;21;0
WireConnection;236;1;290;0
WireConnection;248;0;288;0
WireConnection;248;1;249;0
WireConnection;152;0;151;0
WireConnection;152;1;248;0
WireConnection;106;0;151;0
WireConnection;106;1;236;0
WireConnection;281;0;152;1
WireConnection;281;1;106;1
WireConnection;280;0;152;2
WireConnection;280;1;106;2
WireConnection;278;0;152;4
WireConnection;278;1;106;4
WireConnection;300;0;149;0
WireConnection;299;0;159;0
WireConnection;279;0;152;3
WireConnection;279;1;106;3
WireConnection;25;0;28;0
WireConnection;25;1;29;0
WireConnection;282;1;281;0
WireConnection;282;0;280;0
WireConnection;282;2;279;0
WireConnection;282;3;278;0
WireConnection;293;0;300;0
WireConnection;293;1;182;0
WireConnection;298;0;172;0
WireConnection;291;0;299;0
WireConnection;291;1;181;0
WireConnection;301;0;35;0
WireConnection;30;0;25;0
WireConnection;296;0;298;0
WireConnection;296;1;170;0
WireConnection;295;0;301;0
WireConnection;295;1;36;0
WireConnection;294;0;293;0
WireConnection;292;0;291;0
WireConnection;169;0;167;0
WireConnection;169;1;168;0
WireConnection;283;0;282;0
WireConnection;179;0;283;1
WireConnection;179;1;300;0
WireConnection;179;2;294;0
WireConnection;171;0;169;0
WireConnection;180;0;283;0
WireConnection;180;1;299;0
WireConnection;180;2;292;0
WireConnection;34;0;30;0
WireConnection;34;1;301;0
WireConnection;34;2;295;0
WireConnection;297;0;296;0
WireConnection;161;0;180;0
WireConnection;161;1;34;0
WireConnection;173;0;171;0
WireConnection;173;1;298;0
WireConnection;173;2;297;0
WireConnection;165;0;179;0
WireConnection;165;1;34;0
WireConnection;200;0;173;0
WireConnection;200;1;197;0
WireConnection;190;0;161;0
WireConnection;190;1;165;0
WireConnection;166;0;190;0
WireConnection;205;0;200;0
WireConnection;204;0;205;0
WireConnection;204;1;166;0
WireConnection;196;0;200;0
WireConnection;196;1;166;0
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
WireConnection;254;0;257;0
ASEEND*/
//CHKSM=4796967E29BFCBA50DF6A69327F5A1BBABD1CEBC