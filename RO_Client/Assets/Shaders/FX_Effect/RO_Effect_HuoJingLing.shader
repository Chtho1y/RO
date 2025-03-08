// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "RO/Effect_HuoJingLing_01"
{
	Properties
	{
		_ASEOutlineColor( "Outline Color", Color ) = (0.8113208,0.2625765,0.1033286,0)
		_ASEOutlineWidth( "Outline Width", Float ) = 0.01
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_Float0("Float 0", Range( 0 , 1)) = 0
		[HDR]_Color1("Color 1", Color) = (0,0,0,0)
		_Color0("Color 0", Color) = (0,0,0,0)
		_Vector0("Vector 0", Vector) = (0,0,0,0)
		_Fresnel1("Fresnel", Float) = 1
		_MaksTex("MaksTex", 2D) = "white" {}
		_FresnelColor1("FresnelColor", Color) = (1,1,1,0)
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
		
		
		
		struct Input {
			half filler;
		};
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
		

		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow exclude_path:deferred 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
		};

		uniform float4 _Color0;
		uniform float4 _Color1;
		uniform sampler2D _TextureSample0;
		uniform sampler2D _TextureSample1;
		uniform float4 _Vector0;
		uniform float _Float0;
		uniform float4 _TextureSample0_ST;
		uniform sampler2D _MaksTex;
		uniform float4 _MaksTex_ST;
		uniform float _Fresnel1;
		uniform float4 _FresnelColor1;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 appendResult29 = (float2(_Vector0.x , _Vector0.y));
			float2 panner27 = ( 1.0 * _Time.y * appendResult29 + i.uv_texcoord);
			float2 appendResult30 = (float2(_Vector0.z , _Vector0.w));
			float2 uv0_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float2 panner7 = ( 1.0 * _Time.y * appendResult30 + uv0_TextureSample0);
			float2 uv_MaksTex = i.uv_texcoord * _MaksTex_ST.xy + _MaksTex_ST.zw;
			float4 tex2DNode34 = tex2D( _MaksTex, uv_MaksTex );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV13 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode13 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV13, _Fresnel1 ) );
			float4 lerpResult20 = lerp( _Color0 , _Color1 , saturate( ( ( tex2D( _TextureSample0, ( ( tex2D( _TextureSample1, panner27 ).r * _Float0 ) + panner7 ) ).r * tex2DNode34.r ) + ( saturate( fresnelNode13 ) * _FresnelColor1 ) + tex2DNode34.g ) ));
			o.Emission = lerpResult20.rgb;
			o.Alpha = ( 1.0 - tex2DNode34.b );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18100
2183;7;1650;1004;469.5417;589.7338;1.690511;True;True
Node;AmplifyShaderEditor.Vector4Node;28;-1162.641,-6.279582;Inherit;False;Property;_Vector0;Vector 0;6;0;Create;True;0;0;False;0;False;0,0,0,0;0,-0.08,0,-0.1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;29;-962.5262,-161.5929;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;25;-1218.427,-369.0796;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;27;-878.6031,-348.6585;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-689.5131,-30.54654;Inherit;False;0;1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;30;-863.9619,93.77814;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;15;-650.2321,-358.5314;Inherit;True;Property;_TextureSample1;Texture Sample 1;2;0;Create;True;0;0;False;0;False;-1;None;89f4708ab9537404697944ddb4c3800a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;18;-638.2321,-140.5314;Inherit;False;Property;_Float0;Float 0;3;0;Create;True;0;0;False;0;False;0;0.076;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;213.7338,608.4106;Inherit;False;Property;_Fresnel1;Fresnel;7;0;Create;True;0;0;False;0;False;1;4.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-257.2321,-234.5314;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;7;-349.6899,-10.12549;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;16;-126.2321,-70.53137;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FresnelNode;13;325.9412,341.0587;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-5.339203,-24.85684;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;False;-1;None;7a66b630737e2e440817bfef923dab8e;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;34;-174.8355,192.4385;Inherit;True;Property;_MaksTex;MaksTex;8;0;Create;True;0;0;False;0;False;-1;None;574799c105139c64bb67c773bbfea0c1;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;38;719.4242,487.071;Inherit;False;Property;_FresnelColor1;FresnelColor;9;0;Create;True;0;0;False;0;False;1,1,1,0;0.6132076,0.3268512,0.3268512,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;32;628.9274,352.6992;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;349.9031,22.56243;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;898.4442,333.4112;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;10;753.562,78.14714;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;22;605.5317,-203.626;Inherit;False;Property;_Color1;Color 1;4;1;[HDR];Create;True;0;0;False;0;False;0,0,0,0;1.720795,1.081128,0.6576862,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;21;623.5317,-417.626;Inherit;False;Property;_Color0;Color 0;5;0;Create;True;0;0;False;0;False;0,0,0,0;0.9058824,0.4,0.2313726,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;33;924.3109,76.16864;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;35;925.3273,213.9661;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;36;178.184,226.173;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;20;1203.274,-67.97476;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1469.673,-122.9503;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;RO/Effect_HuoJingLing_01;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Transparent;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;True;0.01;0.8113208,0.2625765,0.1033286,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;29;0;28;1
WireConnection;29;1;28;2
WireConnection;27;0;25;0
WireConnection;27;2;29;0
WireConnection;30;0;28;3
WireConnection;30;1;28;4
WireConnection;15;1;27;0
WireConnection;17;0;15;1
WireConnection;17;1;18;0
WireConnection;7;0;2;0
WireConnection;7;2;30;0
WireConnection;16;0;17;0
WireConnection;16;1;7;0
WireConnection;13;3;37;0
WireConnection;1;1;16;0
WireConnection;32;0;13;0
WireConnection;12;0;1;1
WireConnection;12;1;34;1
WireConnection;39;0;32;0
WireConnection;39;1;38;0
WireConnection;10;0;12;0
WireConnection;10;1;39;0
WireConnection;10;2;34;2
WireConnection;33;0;10;0
WireConnection;35;0;34;3
WireConnection;36;0;34;2
WireConnection;20;0;21;0
WireConnection;20;1;22;0
WireConnection;20;2;33;0
WireConnection;0;2;20;0
WireConnection;0;9;35;0
ASEEND*/
//CHKSM=4426EC27F87838A2EBEE4512C3E425C8F5E43B61