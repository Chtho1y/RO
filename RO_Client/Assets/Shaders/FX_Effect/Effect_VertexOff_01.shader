// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "RO/RO_Effect_Vertex_01"
{
	Properties
	{
		_MainTexColor("主帖图颜色", Color) = (0,0,0,0)
		_MainTex("主帖图", 2D) = "white" {}
		_VertexMainTex("幅度控制贴图", 2D) = "white" {}
		_FD("幅度", Float) = 0
		_PL("频率", Float) = 0
		_Vector0("Vector 0", Vector) = (0,1,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  "PreviewType" = "Plane"}
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow exclude_path:deferred noambient novertexlights nolightmap  nodynlightmap nodirlightmap nometa noforwardadd vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _VertexMainTex;
		uniform float4 _VertexMainTex_ST;
		uniform float4 _Vector0;
		uniform float _FD;
		uniform float _PL;
		uniform float4 _MainTexColor;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float2 uv_VertexMainTex = v.texcoord * _VertexMainTex_ST.xy + _VertexMainTex_ST.zw;
			float mulTime12 = _Time.y * _PL;
			float3 appendResult8 = (float3(0.0 , ( (_Vector0.x + (tex2Dlod( _VertexMainTex, float4( uv_VertexMainTex, 0, 0.0) ).r - 0.0) * (_Vector0.y - _Vector0.x) / (1.0 - 0.0)) * _FD * sin( mulTime12 ) ) , 0.0));
			v.vertex.xyz += appendResult8;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode17 = tex2D( _MainTex, uv_MainTex );
			o.Emission = ( _MainTexColor * tex2DNode17 * i.vertexColor ).rgb;
			o.Alpha = ( i.vertexColor.a * _MainTexColor.a * tex2DNode17.a );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17500
2203;1;1628;1010;1571.995;240.9939;1.492662;True;True
Node;AmplifyShaderEditor.RangedFloatNode;15;-1207.435,522.6208;Inherit;False;Property;_PL;频率;5;0;Create;False;0;0;False;0;0;27;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-971.5643,-17.13583;Inherit;True;Property;_VertexMainTex;幅度控制贴图;3;0;Create;False;0;0;False;0;-1;None;4b5c42055e924ea419865a3deca5f028;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;21;-911.4462,207.5711;Inherit;False;Property;_Vector0;Vector 0;6;0;Create;True;0;0;False;0;0,1,0,0;-0.1,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;12;-948.9666,521.8551;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;13;-700.3643,527.0642;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-684.3643,437.0642;Inherit;False;Property;_FD;幅度;4;0;Create;False;0;0;False;0;0;3.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;20;-656.1483,109.5366;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;22;-291.9344,-190.6001;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;3;-355.5643,-3.535791;Inherit;False;Property;_MainTexColor;主帖图颜色;0;0;Create;False;0;0;False;0;0,0,0,0;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;17;-380.9262,181.0639;Inherit;True;Property;_MainTex;主帖图;2;0;Create;False;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-426.3579,423.2108;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;18.01712,230.2439;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;1.973792,100.3639;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;8;-201.3906,405.1122;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;254.075,142.5;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;RO/RO_Effect_Vertex_01;False;False;False;False;True;True;True;True;True;False;True;True;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Transparent;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;12;0;15;0
WireConnection;13;0;12;0
WireConnection;20;0;1;1
WireConnection;20;3;21;1
WireConnection;20;4;21;2
WireConnection;9;0;20;0
WireConnection;9;1;6;0
WireConnection;9;2;13;0
WireConnection;23;0;22;4
WireConnection;23;1;3;4
WireConnection;23;2;17;4
WireConnection;18;0;3;0
WireConnection;18;1;17;0
WireConnection;18;2;22;0
WireConnection;8;1;9;0
WireConnection;0;2;18;0
WireConnection;0;9;23;0
WireConnection;0;11;8;0
ASEEND*/
//CHKSM=F4AE0739AF25E6247BC092C17674BD4076220FFF