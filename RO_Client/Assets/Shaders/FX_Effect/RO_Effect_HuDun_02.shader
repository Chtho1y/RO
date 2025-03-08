// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "RO/RO_Effect_HuDun_02"
{
	Properties
	{
		_Min("Min", Range( 0 , 1)) = 0
		_MinAdd("MinAdd", Range( 0 , 1)) = 0
		_MainTex("MainTex", 2D) = "white" {}
		_Min2("Min2", Range( 0 , 1)) = 0
		_MinAdd2("MinAdd2", Range( 0 , 1)) = 0
		_UVAdd("UVAdd", Range( 0 , 1)) = 0
		_UVspeed("UVspeed", Vector) = (0,0,0,0)
		[HDR]_Color0("Color 0", Color) = (0,0,0,0)
		[HDR]_Color1("Color 1", Color) = (0,0,0,0)
		_ColorRemap("ColorRemap", Vector) = (0,1,0,1)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IsEmissive" = "true"  }
		Cull Back
		ZWrite Off
		ZTest LEqual
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float4 _Color0;
		uniform float4 _Color1;
		uniform float _Min;
		uniform float _MinAdd;
		uniform float _Min2;
		uniform float _MinAdd2;
		uniform sampler2D _MainTex;
		uniform float4 _UVspeed;
		uniform float4 _MainTex_ST;
		uniform float _UVAdd;
		uniform float4 _ColorRemap;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertexNormal = v.normal.xyz;
			v.vertex.xyz += ( ( v.texcoord.z * 0.1 ) * ase_vertexNormal );
			v.vertex.w = 1;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV2 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode2 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV2, 1.0 ) );
			float smoothstepResult6 = smoothstep( _Min , saturate( ( _Min + _MinAdd ) ) , fresnelNode2);
			float smoothstepResult23 = smoothstep( _Min2 , saturate( ( _Min2 + _MinAdd2 ) ) , fresnelNode2);
			float2 appendResult29 = (float2(_UVspeed.x , _UVspeed.y));
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float2 panner16 = ( 1.0 * _Time.y * appendResult29 + uv_MainTex);
			float2 appendResult30 = (float2(_UVspeed.z , _UVspeed.w));
			float2 panner31 = ( 1.0 * _Time.y * appendResult30 + uv_MainTex);
			float temp_output_14_0 = ( smoothstepResult23 * tex2D( _MainTex, ( float4( panner16, 0.0 , 0.0 ) + ( tex2D( _MainTex, panner31 ) * _UVAdd ) ).rg ).r );
			float clampResult44 = clamp( ( smoothstepResult6 + temp_output_14_0 ) , _ColorRemap.x , _ColorRemap.y );
			float4 lerpResult36 = lerp( _Color0 , _Color1 , (_ColorRemap.z + (clampResult44 - _ColorRemap.x) * (_ColorRemap.w - _ColorRemap.z) / (_ColorRemap.y - _ColorRemap.x)));
			o.Emission = ( lerpResult36 * i.vertexColor ).rgb;
			float lerpResult22 = lerp( temp_output_14_0 , smoothstepResult6 , smoothstepResult6);
			o.Alpha = saturate( ( lerpResult22 * i.vertexColor.a ) );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
2665;1;1166;1010;-813.8017;-176.4035;1;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;15;-1049.308,533.6208;Inherit;False;0;18;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;28;-1409.45,816.7043;Inherit;False;Property;_UVspeed;UVspeed;7;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;30;-1170.105,1203.958;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;32;-970.9639,767.0887;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;18;-897.5455,777.4403;Inherit;True;Property;_MainTex;MainTex;3;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.PannerNode;31;-885.0436,1117.901;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-866.2786,13.75;Inherit;False;Property;_MinAdd2;MinAdd2;5;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-656.7553,1230.194;Inherit;False;Property;_UVAdd;UVAdd;6;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;29;-1178.173,736.0265;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;19;-679.9765,1001.729;Inherit;True;Property;_TextureSample0;Texture Sample 0;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;24;-832.2786,-97.25;Inherit;False;Property;_Min2;Min2;4;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;26;-511.2786,14.75;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-332.7955,994.684;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-927.2366,-223.947;Inherit;False;Property;_MinAdd;MinAdd;2;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;16;-589.3989,557.824;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-898.2366,-369.9471;Inherit;False;Property;_Min;Min;1;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;8;-584.2366,-312.9471;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;2;-907.6882,-567.0955;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;27;-376.2786,7.75;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;33;-375.2263,707.7148;Inherit;False;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;13;-329.399,435.8239;Inherit;True;Property;_111;111;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;23;-237.6759,-121.7176;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;9;-433.2367,-318.9471;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;6;-262.2367,-462.9472;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-31.39899,333.8239;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;42;385.2234,356.6494;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;45;353.9167,548.9703;Inherit;False;Property;_ColorRemap;ColorRemap;10;0;Create;True;0;0;0;False;0;False;0,1,0,1;0,1,0,1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;44;558.0167,487.8704;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;43;751.7168,421.5705;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;39;406.9187,-3.756531;Inherit;False;Property;_Color1;Color 1;9;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;46;915.5388,754.4971;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;38;407.9187,-183.7565;Inherit;False;Property;_Color0;Color 0;8;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;22;398.703,177.846;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;54;1255.038,580.1575;Inherit;False;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalVertexDataNode;52;1444.08,857.993;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScaleNode;55;1538.802,663.4035;Inherit;False;0.1;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;36;699.9187,123.2435;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;1186.708,428.8138;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;1178.322,209.3619;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;49;1518.547,392.586;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;1790.843,664.4725;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2062.436,139.187;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;RO/RO_Effect_HuDun_02;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;2;False;-1;3;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Custom;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;30;0;28;3
WireConnection;30;1;28;4
WireConnection;32;0;15;0
WireConnection;31;0;32;0
WireConnection;31;2;30;0
WireConnection;29;0;28;1
WireConnection;29;1;28;2
WireConnection;19;0;18;0
WireConnection;19;1;31;0
WireConnection;26;0;24;0
WireConnection;26;1;25;0
WireConnection;34;0;19;0
WireConnection;34;1;35;0
WireConnection;16;0;15;0
WireConnection;16;2;29;0
WireConnection;8;0;7;0
WireConnection;8;1;10;0
WireConnection;27;0;26;0
WireConnection;33;0;16;0
WireConnection;33;1;34;0
WireConnection;13;0;18;0
WireConnection;13;1;33;0
WireConnection;23;0;2;0
WireConnection;23;1;24;0
WireConnection;23;2;27;0
WireConnection;9;0;8;0
WireConnection;6;0;2;0
WireConnection;6;1;7;0
WireConnection;6;2;9;0
WireConnection;14;0;23;0
WireConnection;14;1;13;1
WireConnection;42;0;6;0
WireConnection;42;1;14;0
WireConnection;44;0;42;0
WireConnection;44;1;45;1
WireConnection;44;2;45;2
WireConnection;43;0;44;0
WireConnection;43;1;45;1
WireConnection;43;2;45;2
WireConnection;43;3;45;3
WireConnection;43;4;45;4
WireConnection;22;0;14;0
WireConnection;22;1;6;0
WireConnection;22;2;6;0
WireConnection;55;0;54;3
WireConnection;36;0;38;0
WireConnection;36;1;39;0
WireConnection;36;2;43;0
WireConnection;47;0;22;0
WireConnection;47;1;46;4
WireConnection;48;0;36;0
WireConnection;48;1;46;0
WireConnection;49;0;47;0
WireConnection;53;0;55;0
WireConnection;53;1;52;0
WireConnection;0;2;48;0
WireConnection;0;9;49;0
WireConnection;0;11;53;0
ASEEND*/
//CHKSM=5BDB873EBD26A7AED6A4DADFF0238E7C044DBA16