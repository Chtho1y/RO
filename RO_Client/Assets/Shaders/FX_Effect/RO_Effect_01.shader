// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "RO/RO_Effect_01"
{
	Properties
	{
		_ColorStr("ColorStr", Float) = 1
		_AlphaStr("AlphaStr", Float) = 1
		_MainTex("主帖图", 2D) = "white" {}
		[KeywordEnum(R,G,B,A)] _RGBA1("透明通道选择", Float) = 3
		_UVspeed("UVspeed", Vector) = (0,0,1,1)
		[Toggle(_WT_ON)] _WT("WT", Float) = 0
		[Toggle(_KEYWORD1_ON)] _Keyword1("是否使用原始图片颜色", Float) = 1
		[KeywordEnum(R,G,B,A)] _RGBA("混合颜色通道选择", Float) = 3
		_Color_A("混合色A", Color) = (1,1,1,1)
		_Color_B("混合色B", Color) = (1,1,1,1)
		_Vector0("颜色控制", Vector) = (0,1,0,1)
		[Enum(UnityEngine.Rendering.BlendMode)]_Src("Src", Float) = 5
		[Enum(UnityEngine.Rendering.BlendMode)]_Dst("Dst", Float) = 10
		[Enum(UnityEngine.Rendering.CullMode)]_CullMode("CullMode", Float) = 0
		[Enum(Off,0,On,1)]_ZWrite("ZWrite", Float) = 1
		[Enum(UnityEngine.Rendering.CompareFunction)]_ZTest("ZTest", Float) = 4

	}
	
	SubShader
	{
		
		
		Tags { "RenderType" = "Custom"  "Queue" = "Transparent+0" "IsEmissive" = "true"  "PreviewType"="Plane" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend [_Src] [_Dst]
		Cull [_CullMode]
		ColorMask RGBA
		ZWrite [_ZWrite]
		ZTest [_ZTest]
		Offset 0 , 0
		
		
		
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
			#pragma shader_feature _KEYWORD1_ON
			#pragma shader_feature _RGBA_R _RGBA_G _RGBA_B _RGBA_A
			#pragma shader_feature _WT_ON
			#pragma shader_feature _RGBA1_R _RGBA1_G _RGBA1_B _RGBA1_A


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 ase_texcoord : TEXCOORD0;
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_color : COLOR;
			};

			uniform float _Src;
			uniform float _Dst;
			uniform float _CullMode;
			uniform float _ZTest;
			uniform float _ZWrite;
			uniform float4 _Color_B;
			uniform float4 _Color_A;
			uniform sampler2D _MainTex;
			uniform float4 _UVspeed;
			uniform float4 _MainTex_ST;
			uniform float4 _Vector0;
			uniform float _ColorStr;
			uniform float _AlphaStr;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord = v.ase_texcoord;
				o.ase_color = v.color;
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
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				float Src35 = _Src;
				float Dst36 = _Dst;
				float2 appendResult31 = (float2(_UVspeed.x , _UVspeed.y));
				float2 uv0_MainTex = i.ase_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
				float2 panner27 = ( 1.0 * _Time.y * appendResult31 + uv0_MainTex);
				float2 appendResult51 = (float2(_UVspeed.z , _UVspeed.w));
				float4 uv047 = i.ase_texcoord;
				uv047.xy = i.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult48 = (float2(uv047.z , uv047.w));
				float2 uv050 = i.ase_texcoord.xy * appendResult51 + appendResult48;
				#ifdef _WT_ON
				float2 staticSwitch49 = uv050;
				#else
				float2 staticSwitch49 = panner27;
				#endif
				float4 tex2DNode2 = tex2D( _MainTex, staticSwitch49 );
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
				float4 lerpResult10 = lerp( _Color_B , _Color_A , (_Vector0.z + (clampResult44 - _Vector0.x) * (_Vector0.w - _Vector0.z) / (_Vector0.y - _Vector0.x)));
				#ifdef _KEYWORD1_ON
				float4 staticSwitch25 = tex2DNode2;
				#else
				float4 staticSwitch25 = lerpResult10;
				#endif
				float4 temp_output_6_0 = ( staticSwitch25 * i.ase_color * _ColorStr );
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
				float temp_output_21_0 = saturate( ( staticSwitch41 * i.ase_color.a * _AlphaStr ) );
				float4 appendResult55 = (float4(( (( Src35 == Dst36 ) ? ( temp_output_6_0 * temp_output_21_0 ) :  temp_output_6_0 ) ).rgb , temp_output_21_0));
				
				
				finalColor = appendResult55;
				return finalColor;
			}
			ENDCG
		}
	}
//	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=17500
2389;1;1442;1010;-662.5281;530.0574;1;True;False
Node;AmplifyShaderEditor.Vector4Node;30;-2828.148,78.1478;Inherit;False;Property;_UVspeed;UVspeed;4;0;Create;True;0;0;False;0;0,0,1,1;0,-1,1,1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;47;-2787.007,304.2948;Inherit;False;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;26;-2821.264,-76.31065;Inherit;False;0;2;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;31;-2574.654,83.10573;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;48;-2556.007,326.2948;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;51;-2527.396,219.504;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;27;-2382.644,-81.93423;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;50;-2345.396,184.504;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;49;-2175.007,-53.7052;Inherit;False;Property;_WT;WT;5;0;Create;True;0;0;False;0;0;0;1;True;;Toggle;2;Key0;Key1;Create;False;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;2;-1914.491,-77.23545;Inherit;True;Property;_MainTex;主帖图;2;0;Create;False;0;0;False;0;-1;None;f8e6eedf6efa01d40b49e8713be98f55;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;42;-1328.682,-141.9242;Inherit;False;Property;_Vector0;颜色控制;10;0;Create;False;0;0;False;0;0,1,0,1;0.62,0.67,0,1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;24;-1338.613,-293.065;Inherit;False;Property;_RGBA;混合颜色通道选择;7;0;Create;False;0;0;False;0;0;3;3;True;;KeywordEnum;4;R;G;B;A;Create;False;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;44;-1061.682,-280.9242;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;12;-1348.25,-487.1304;Inherit;False;Property;_Color_A;混合色A;8;0;Create;False;0;0;False;0;1,1,1,1;1,0.6265823,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;13;-1353.482,-677.6719;Inherit;False;Property;_Color_B;混合色B;9;0;Create;False;0;0;False;0;1,1,1,1;1,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;43;-782.682,-290.9242;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;41;-1335.224,110.0692;Inherit;False;Property;_RGBA1;透明通道选择;3;0;Create;False;0;0;False;0;0;3;3;True;;KeywordEnum;4;R;G;B;A;Create;False;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-906.5184,476.4466;Inherit;False;Property;_AlphaStr;AlphaStr;1;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;8;-1325.058,318.8527;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;10;-569.0887,-362.3988;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;17;118.2787,-768.6063;Inherit;False;Property;_Src;Src;11;1;[Enum];Create;True;0;1;UnityEngine.Rendering.BlendMode;True;0;5;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-298.4626,122.5226;Inherit;False;Property;_ColorStr;ColorStr;0;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;25;-368.6535,-216.3698;Inherit;False;Property;_Keyword1;是否使用原始图片颜色;6;0;Create;False;0;0;False;0;0;1;0;True;;Toggle;2;Key0;Key1;Create;False;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-426.2298,239.7148;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;116.1798,-609.2338;Inherit;False;Property;_Dst;Dst;12;1;[Enum];Create;True;0;1;UnityEngine.Rendering.BlendMode;True;0;10;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;35;377.29,-761.6071;Inherit;False;Src;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-76.81242,-23.39552;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;36;386.8782,-599.9767;Inherit;False;Dst;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;21;-240.831,244.8913;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;38;208.8111,-247.9514;Inherit;False;35;Src;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;37;208.8111,-116.4555;Inherit;False;36;Dst;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;182.2611,45.04154;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCCompareEqual;19;499.1458,-88.19511;Inherit;False;4;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;45;759.5353,-20.968;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;54;992.6457,-1.555559;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-97.98126,-774.0619;Inherit;False;Property;_CullMode;CullMode;13;1;[Enum];Create;True;0;1;UnityEngine.Rendering.CullMode;True;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-249.9812,-777.0619;Inherit;False;Property;_ZTest;ZTest;15;1;[Enum];Create;True;0;1;UnityEngine.Rendering.CompareFunction;True;0;4;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-425.9813,-777.0619;Inherit;False;Property;_ZWrite;ZWrite;14;1;[Enum];Create;True;2;On;0;Off;1;0;True;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;55;1284.803,-6.507372;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;52;1435.796,-11.03671;Float;False;True;-1;2;ASEMaterialInspector;100;1;RO/RO_Effect_03;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;1;0;True;17;0;True;18;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;True;False;True;0;True;15;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;True;16;True;3;True;14;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;0
WireConnection;31;0;30;1
WireConnection;31;1;30;2
WireConnection;48;0;47;3
WireConnection;48;1;47;4
WireConnection;51;0;30;3
WireConnection;51;1;30;4
WireConnection;27;0;26;0
WireConnection;27;2;31;0
WireConnection;50;0;51;0
WireConnection;50;1;48;0
WireConnection;49;1;27;0
WireConnection;49;0;50;0
WireConnection;2;1;49;0
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
WireConnection;41;1;2;1
WireConnection;41;0;2;2
WireConnection;41;2;2;3
WireConnection;41;3;2;4
WireConnection;10;0;13;0
WireConnection;10;1;12;0
WireConnection;10;2;43;0
WireConnection;25;1;10;0
WireConnection;25;0;2;0
WireConnection;7;0;41;0
WireConnection;7;1;8;4
WireConnection;7;2;22;0
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
WireConnection;45;0;19;0
WireConnection;54;0;45;0
WireConnection;55;0;54;0
WireConnection;55;3;21;0
WireConnection;52;0;55;0
ASEEND*/
//CHKSM=334F3AA430E6CCB5061D22D58F1157CE87398A92