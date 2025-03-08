// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "RO/RO_Effect_XuanZhuan_01"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_speed("speed", Float) = 0
		_Vector2("Vector 2", Vector) = (0,1,0,1)
		_Color0("Color 0", Color) = (0,0,0,0)
		_Color1("Color 1", Color) = (1,1,1,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		ZWrite Off
		ZTest LEqual
		Blend SrcAlpha OneMinusSrcAlpha
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _Color0;
		uniform float4 _Color1;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float _speed;
		uniform float4 _Vector2;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 uv_TexCoord34 = i.uv_texcoord * float2( 2,2 );
			float mulTime44 = _Time.y * _speed;
			float cos43 = cos( mulTime44 );
			float sin43 = sin( mulTime44 );
			float2 rotator43 = mul( uv_TexCoord34 - float2( 1,1 ) , float2x2( cos43 , -sin43 , sin43 , cos43 )) + float2( 1,1 );
			float2 temp_output_35_0 = ( rotator43 - float2( 1,1 ) );
			float clampResult49 = clamp( ( 1.0 - frac( ( atan2( (temp_output_35_0).x , (temp_output_35_0).y ) / 6.28318548202515 ) ) ) , _Vector2.x , _Vector2.y );
			float temp_output_45_0 = ( tex2D( _MainTex, uv_MainTex ).a * (_Vector2.z + (clampResult49 - _Vector2.x) * (_Vector2.w - _Vector2.z) / (_Vector2.y - _Vector2.x)) );
			float4 lerpResult52 = lerp( _Color0 , _Color1 , temp_output_45_0);
			o.Emission = lerpResult52.rgb;
			o.Alpha = temp_output_45_0;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18100
2389;1;1442;1010;1070.112;593.4561;2.103875;True;True
Node;AmplifyShaderEditor.Vector2Node;32;-1582.008,517.919;Float;False;Constant;_Vector0;Vector 0;0;0;Create;True;0;0;False;0;False;2,2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;48;-1663.735,804.7974;Inherit;False;Property;_speed;speed;2;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;34;-1381.811,507.5789;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;44;-1477.5,747.7374;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;43;-1087.199,482.2705;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;1,1;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;33;-983.1868,720.0203;Float;False;Constant;_Vector1;Vector 1;0;0;Create;True;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleSubtractOpNode;35;-753.8574,501.066;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;26;-556.4374,494.8748;Inherit;False;True;False;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;27;-556.4374,574.8749;Inherit;False;False;True;True;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ATan2OpNode;29;-311.8983,493.8535;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TauNode;28;-307.0863,608.37;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;30;-148.2673,497.0312;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;31;43.56262,504.8749;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;46;228.9457,506.8062;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;51;206.1354,651.4993;Inherit;False;Property;_Vector2;Vector 2;3;0;Create;True;0;0;False;0;False;0,1,0,1;0,1,0,1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;49;479.8444,516.4495;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-33.96769,70.79605;Inherit;True;Property;_MainTex;MainTex;1;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;50;774.6309,519.0333;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;468.0966,171.2104;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;53;520.6302,-240.5165;Inherit;False;Property;_Color0;Color 0;4;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;54;579.1302,-0.01654053;Inherit;False;Property;_Color1;Color 1;5;0;Create;True;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;52;837.8301,63.6835;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1178.53,35.04303;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;RO/RO_Effect_XuanZhuan_01;False;False;False;False;True;True;True;True;True;True;True;True;False;False;False;False;False;False;False;False;False;Back;2;False;-1;3;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;False;Custom;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;34;0;32;0
WireConnection;44;0;48;0
WireConnection;43;0;34;0
WireConnection;43;2;44;0
WireConnection;35;0;43;0
WireConnection;35;1;33;0
WireConnection;26;0;35;0
WireConnection;27;0;35;0
WireConnection;29;0;26;0
WireConnection;29;1;27;0
WireConnection;30;0;29;0
WireConnection;30;1;28;0
WireConnection;31;0;30;0
WireConnection;46;0;31;0
WireConnection;49;0;46;0
WireConnection;49;1;51;1
WireConnection;49;2;51;2
WireConnection;50;0;49;0
WireConnection;50;1;51;1
WireConnection;50;2;51;2
WireConnection;50;3;51;3
WireConnection;50;4;51;4
WireConnection;45;0;1;4
WireConnection;45;1;50;0
WireConnection;52;0;53;0
WireConnection;52;1;54;0
WireConnection;52;2;45;0
WireConnection;0;2;52;0
WireConnection;0;9;45;0
ASEEND*/
//CHKSM=50825E46855C4DF03CBDEE7A13DF7F5B058903E3