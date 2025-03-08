// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "RO/RO_Effect_JZB_02"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_Max("Max", Range( 0 , 0.9999)) = 0.9999
		_MainTexOffest("MainTexOffest", Vector) = (1,1,0,1)
		[Enum(UnityEngine.Rendering.BlendMode)]_Src2("Src", Float) = 5
		[Enum(UnityEngine.Rendering.BlendMode)]_Dst2("Dst", Float) = 10
		[Enum(UnityEngine.Rendering.CullMode)]_CullMode2("CullMode", Float) = 0
		[Enum(Off,0,On,1)]_ZWrite2("ZWrite", Float) = 0
		[Enum(UnityEngine.Rendering.CompareFunction)]_ZTest2("ZTest", Float) = 4
		_Hue("Hue", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IsEmissive" = "true"  }
		Cull [_CullMode2]
		ZWrite [_ZWrite2]
		ZTest [_ZTest2]
		Blend [_Src2] [_Dst2]
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nometa noforwardadd 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float _Dst2;
		uniform float _Src2;
		uniform float _CullMode2;
		uniform float _ZTest2;
		uniform float _ZWrite2;
		uniform float _Hue;
		uniform sampler2D _MainTex;
		uniform float4 _MainTexOffest;
		uniform float _Max;


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

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 appendResult128 = (float2(_MainTexOffest.x , _MainTexOffest.y));
			float2 appendResult121 = (float2(_MainTexOffest.z , 0.0));
			float2 uv_TexCoord12 = i.uv_texcoord * float2( 2,2 );
			float2 UV130 = ( uv_TexCoord12 - float2( 1,1 ) );
			float2 appendResult103 = (float2(frac( ( atan2( (UV130).x , (UV130).y ) / 6.28318548202515 ) ) , length( UV130 )));
			float2 panner123 = ( 1.0 * _Time.y * appendResult121 + appendResult103);
			float2 appendResult122 = (float2(0.0 , _MainTexOffest.w));
			float2 panner124 = ( 1.0 * _Time.y * appendResult122 + appendResult103);
			float2 appendResult129 = (float2((panner123).x , (panner124).y));
			float temp_output_13_0 = length( UV130 );
			float3 hsvTorgb147 = RGBToHSV( ( tex2D( _MainTex, ( ( appendResult128 * appendResult129 ) + temp_output_13_0 ) ) * i.vertexColor ).rgb );
			float3 hsvTorgb148 = HSVToRGB( float3(( _Hue + hsvTorgb147.x ),hsvTorgb147.y,hsvTorgb147.z) );
			o.Emission = hsvTorgb148;
			float smoothstepResult14 = smoothstep( 1.0 , _Max , temp_output_13_0);
			o.Alpha = ( i.vertexColor.a * smoothstepResult14 );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18500
2319;1;1512;1010;-1706.7;557.585;1;True;True
Node;AmplifyShaderEditor.Vector2Node;9;-1374.277,467.0343;Float;False;Constant;_Vector0;Vector 0;0;0;Create;True;0;0;False;0;False;2,2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;10;-1094.589,616.5663;Float;False;Constant;_Vector1;Vector 1;0;0;Create;True;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;12;-1174.08,456.6942;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;11;-869.2953,460.8353;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;130;-672.6439,483.9986;Inherit;False;UV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;131;-2359.23,-302.2035;Inherit;False;130;UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;95;-2024.212,-406.5013;Inherit;False;True;False;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;96;-2024.212,-326.5013;Inherit;False;False;True;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ATan2OpNode;97;-1779.673,-407.5227;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TauNode;98;-1774.861,-293.0062;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;99;-1616.042,-404.345;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;102;-1432.212,-326.5013;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;100;-2017.171,-144.5228;Inherit;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;101;-1295.636,-360.462;Inherit;False;Property;_MainTexOffest;MainTexOffest;3;0;Create;True;0;0;False;0;False;1,1,0,1;4,1,0,1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;103;-1301.207,-165.2091;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;121;-822.934,-72.32878;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;122;-822.934,174.0634;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;123;-600.8199,-92.34578;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;124;-615.3212,174.8307;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;125;-305.8657,156.704;Inherit;False;False;True;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;126;-300.448,-73.68534;Inherit;False;True;False;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;128;-58.32109,-152.5939;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;129;-54.55693,-30.34258;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;127;125.6076,-143.1645;Inherit;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LengthOpNode;13;-406.6232,448.4684;Inherit;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;40;695.8636,79.48013;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;7;1596.884,74.84749;Inherit;True;Property;_MainTex;MainTex;1;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;34;1452.378,410.8171;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;2014.712,140.1688;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RGBToHSVNode;147;2308.7,89.41498;Inherit;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;150;2234.7,-78.58502;Inherit;False;Property;_Hue;Hue;9;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-511.9467,696.1497;Inherit;False;Property;_Max;Max;2;0;Create;True;0;0;False;0;False;0.9999;0.598;0;0.9999;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;149;2578.7,-5.585022;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;14;21.10172,575.38;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;140;1335.161,-682.9677;Inherit;False;Property;_ZTest2;ZTest;8;1;[Enum];Create;True;0;1;UnityEngine.Rendering.CompareFunction;True;0;False;4;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;139;1495.161,-682.9677;Inherit;False;Property;_CullMode2;CullMode;6;1;[Enum];Create;True;0;1;UnityEngine.Rendering.CullMode;True;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.HSVToRGBNode;148;2727.7,98.41498;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;141;1159.16,-682.9677;Inherit;False;Property;_ZWrite2;ZWrite;7;1;[Enum];Create;True;2;Off;0;On;1;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;135;1703.161,-522.9676;Inherit;False;Property;_Dst2;Dst;5;1;[Enum];Create;True;0;1;UnityEngine.Rendering.BlendMode;True;0;False;10;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;137;1959.16,-666.9677;Inherit;False;Src;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;138;1975.16,-506.9676;Inherit;False;Dst;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;136;1703.161,-682.9677;Inherit;False;Property;_Src2;Src;4;1;[Enum];Create;True;0;1;UnityEngine.Rendering.BlendMode;True;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;1846.466,542.716;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;20;3096.786,-7.961101;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;RO/RO_Effect_JZB_02;False;False;False;False;True;True;True;True;True;False;True;True;False;False;False;False;False;False;False;False;False;Back;2;True;141;0;True;140;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Custom;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;True;136;10;True;135;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;True;139;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;12;0;9;0
WireConnection;11;0;12;0
WireConnection;11;1;10;0
WireConnection;130;0;11;0
WireConnection;95;0;131;0
WireConnection;96;0;131;0
WireConnection;97;0;95;0
WireConnection;97;1;96;0
WireConnection;99;0;97;0
WireConnection;99;1;98;0
WireConnection;102;0;99;0
WireConnection;100;0;131;0
WireConnection;103;0;102;0
WireConnection;103;1;100;0
WireConnection;121;0;101;3
WireConnection;122;1;101;4
WireConnection;123;0;103;0
WireConnection;123;2;121;0
WireConnection;124;0;103;0
WireConnection;124;2;122;0
WireConnection;125;0;124;0
WireConnection;126;0;123;0
WireConnection;128;0;101;1
WireConnection;128;1;101;2
WireConnection;129;0;126;0
WireConnection;129;1;125;0
WireConnection;127;0;128;0
WireConnection;127;1;129;0
WireConnection;13;0;130;0
WireConnection;40;0;127;0
WireConnection;40;1;13;0
WireConnection;7;1;40;0
WireConnection;36;0;7;0
WireConnection;36;1;34;0
WireConnection;147;0;36;0
WireConnection;149;0;150;0
WireConnection;149;1;147;1
WireConnection;14;0;13;0
WireConnection;14;2;15;0
WireConnection;148;0;149;0
WireConnection;148;1;147;2
WireConnection;148;2;147;3
WireConnection;137;0;136;0
WireConnection;138;0;135;0
WireConnection;35;0;34;4
WireConnection;35;1;14;0
WireConnection;20;2;148;0
WireConnection;20;9;35;0
ASEEND*/
//CHKSM=0395431A83E82EA364783B965273104649B44141