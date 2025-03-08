// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "RO/UI_Effect_LiuGuang_01"
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
		_JD("角度", Range( 0 , 3.14)) = 0
		_H("H", Range( -1 , 1)) = 0
		_S("S", Range( -1 , 1)) = 0
		_V("V", Range( -1 , 1)) = 0
		_Vector0("Vector 0", Vector) = (0,0,0,0)
		_Float3("边缘", Range( 0 , 1)) = 1
		_Vector1("Vector 1", Vector) = (0,1,0,1)
		_Texture0("Texture 0", 2D) = "white" {}
		_TO("TO", Vector) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

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


		Cull Off
		Lighting Off
		ZWrite Off
		ZTest [unity_GUIZTestMode]
		Blend SrcAlpha OneMinusSrcAlpha
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
				float4 ase_texcoord2 : TEXCOORD2;
			};
			
			uniform fixed4 _Color;
			uniform fixed4 _TextureSampleAdd;
			uniform float4 _ClipRect;
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform float _H;
			uniform float _Float3;
			uniform float4 _Vector1;
			uniform sampler2D _Texture0;
			uniform float4 _TO;
			uniform float4 _Vector0;
			uniform float _JD;
			uniform float _S;
			uniform float _V;
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

			
			v2f vert( appdata_t IN  )
			{
				v2f OUT;
				UNITY_SETUP_INSTANCE_ID( IN );
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
				UNITY_TRANSFER_INSTANCE_ID(IN, OUT);
				OUT.worldPosition = IN.vertex;
				float4 ase_clipPos = UnityObjectToClipPos(IN.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				OUT.ase_texcoord2 = screenPos;
				
				
				OUT.worldPosition.xyz +=  float3( 0, 0, 0 ) ;
				OUT.vertex = UnityObjectToClipPos(OUT.worldPosition);

				OUT.texcoord = IN.texcoord;
				
				OUT.color = IN.color * _Color;
				return OUT;
			}

			fixed4 frag(v2f IN  ) : SV_Target
			{
				float2 uv_MainTex = IN.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 tex2DNode16 = tex2D( _MainTex, uv_MainTex );
				float3 hsvTorgb114 = RGBToHSV( (( IN.color * tex2DNode16 )).rgb );
				float4 temp_cast_0 = (_Vector1.x).xxxx;
				float4 temp_cast_1 = (_Vector1.y).xxxx;
				float4 screenPos = IN.ase_texcoord2;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float2 appendResult196 = (float2(ase_screenPosNorm.x , ase_screenPosNorm.y));
				float2 appendResult198 = (float2(_TO.x , _TO.y));
				float2 appendResult199 = (float2(_TO.z , _TO.w));
				float2 temp_output_201_0 = ( ( appendResult196 * appendResult198 ) + appendResult199 );
				float2 appendResult189 = (float2(_Vector0.x , _Vector0.y));
				float2 temp_output_170_0 = ( appendResult189 * _Time.y );
				float cos93 = cos( _JD );
				float sin93 = sin( _JD );
				float2 rotator93 = mul( temp_output_201_0 - temp_output_170_0 , float2x2( cos93 , -sin93 , sin93 , cos93 )) + temp_output_170_0;
				float4 smoothstepResult157 = smoothstep( temp_cast_0 , temp_cast_1 , tex2D( _Texture0, rotator93 ));
				float4 temp_cast_2 = (_Vector1.z).xxxx;
				float4 temp_cast_3 = (_Vector1.w).xxxx;
				float cos175 = cos( _JD );
				float sin175 = sin( _JD );
				float2 rotator175 = mul( temp_output_201_0 - temp_output_170_0 , float2x2( cos175 , -sin175 , sin175 , cos175 )) + temp_output_170_0;
				float4 smoothstepResult186 = smoothstep( temp_cast_2 , temp_cast_3 , tex2D( _Texture0, rotator175 ));
				float temp_output_163_0 = ( step( _Float3 , tex2DNode16.a ) * (( ( ( smoothstepResult157 * _Vector0.z ) + ( _Vector0.w * smoothstepResult186 ) ) * 0.5 )).a );
				float3 hsvTorgb115 = HSVToRGB( float3(( hsvTorgb114.x + ( _H * temp_output_163_0 ) ),( hsvTorgb114.y + ( _S * temp_output_163_0 ) ),( hsvTorgb114.z + ( _V * temp_output_163_0 ) )) );
				float4 appendResult112 = (float4(hsvTorgb115 , tex2DNode16.a));
				
				half4 color = appendResult112;
				
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
2005;1;1650;1010;270.3462;681.6509;2.111593;True;True
Node;AmplifyShaderEditor.ScreenPosInputsNode;195;237.2157,52.22845;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;197;320.0798,238.2144;Inherit;False;Property;_TO;TO;8;0;Create;True;0;0;False;0;False;0,0,0,0;10,10,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;198;546.8065,235.8731;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;196;522.2157,64.22845;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;166;-39.12943,597.6422;Inherit;False;Property;_Vector0;Vector 0;4;0;Create;True;0;0;False;0;False;0,0,0,0;0.1,0,1,2.22;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;169;198.2544,794.0878;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;189;244.9054,610.01;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;200;711.9427,198.7578;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;199;537.9427,320.7578;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;99;407.5632,467.541;Inherit;False;Property;_JD;角度;0;0;Create;False;0;0;False;0;False;0;2.31;0;3.14;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;201;830.9427,304.7578;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;170;466.0072,653.1061;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RotatorNode;93;972.6051,324.7429;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;173;999.3979,588.3363;Inherit;True;Property;_Texture0;Texture 0;7;0;Create;True;0;0;False;0;False;None;2721b10c711d5d64ebf001d71c7c56bd;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RotatorNode;175;959.0834,824.3834;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;174;1332.251,770.9761;Inherit;True;Property;_TextureSample2;Texture Sample 2;0;0;Create;True;0;0;False;0;False;-1;None;2721b10c711d5d64ebf001d71c7c56bd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;95;1325.494,329.8017;Inherit;True;Property;_TextureSample1;Texture Sample 1;0;0;Create;True;0;0;False;0;False;-1;None;2721b10c711d5d64ebf001d71c7c56bd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;187;1365.854,584.6862;Inherit;False;Property;_Vector1;Vector 1;6;0;Create;True;0;0;False;0;False;0,1,0,1;0.68,0.82,0.19,0.5;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;186;1695.355,695.7891;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;157;1701.239,397.1291;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;190;1959.219,561.4568;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;191;1983.501,689.1656;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;180;2148.567,729.7425;Inherit;False;Constant;_Float0;Float 0;10;0;Create;True;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;69;656.0678,-57.82619;Inherit;False;0;0;_MainTex;Shader;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;178;2159.06,574.2421;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;161;1367.272,-36.6865;Inherit;False;Property;_Float3;边缘;5;0;Create;False;0;0;False;0;False;1;0.411;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;179;2319.419,580.0385;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0.5566038;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;16;874.3687,-56.69046;Inherit;True;Property;_TextureSample0;Texture Sample 0;2;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;70;1001.362,-232.6591;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;1251.362,-72.65912;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;192;2545.494,540.5786;Inherit;False;False;False;False;True;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;160;1752.232,106.1513;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;142;2052.494,-64.89515;Inherit;False;Property;_S;S;2;0;Create;True;0;0;False;0;False;0;-0.02;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;143;2052.864,9.735229;Inherit;False;Property;_V;V;3;0;Create;True;0;0;False;0;False;0;0.24;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;141;2054.494,-137.2648;Inherit;False;Property;_H;H;1;0;Create;True;0;0;False;0;False;0;-0.05;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;116;1589.174,-288.826;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;163;2741.327,109.9191;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;138;3003.932,-2.697068;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RGBToHSVNode;114;1960.637,-287.4027;Inherit;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;136;2989.396,-239.8933;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;137;3014.322,-130.3972;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;139;3215.62,-186.527;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;127;3214.822,-302.3824;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;140;3197.049,-48.25924;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.HSVToRGBNode;115;3504.553,-253.0183;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;112;3920.696,29.4936;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;4169.982,5.269682;Float;False;True;-1;2;ASEMaterialInspector;0;4;RO/UI_Effect_LiuGuang_01;5056123faa0c79b47ab6ad7e8bf059a4;True;Default;0;0;Default;2;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;True;2;False;-1;True;True;True;True;True;0;True;-9;False;False;False;True;True;0;True;-5;255;True;-8;255;True;-7;0;True;-4;0;True;-6;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;0;True;-11;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;198;0;197;1
WireConnection;198;1;197;2
WireConnection;196;0;195;1
WireConnection;196;1;195;2
WireConnection;189;0;166;1
WireConnection;189;1;166;2
WireConnection;200;0;196;0
WireConnection;200;1;198;0
WireConnection;199;0;197;3
WireConnection;199;1;197;4
WireConnection;201;0;200;0
WireConnection;201;1;199;0
WireConnection;170;0;189;0
WireConnection;170;1;169;0
WireConnection;93;0;201;0
WireConnection;93;1;170;0
WireConnection;93;2;99;0
WireConnection;175;0;201;0
WireConnection;175;1;170;0
WireConnection;175;2;99;0
WireConnection;174;0;173;0
WireConnection;174;1;175;0
WireConnection;95;0;173;0
WireConnection;95;1;93;0
WireConnection;186;0;174;0
WireConnection;186;1;187;3
WireConnection;186;2;187;4
WireConnection;157;0;95;0
WireConnection;157;1;187;1
WireConnection;157;2;187;2
WireConnection;190;0;157;0
WireConnection;190;1;166;3
WireConnection;191;0;166;4
WireConnection;191;1;186;0
WireConnection;178;0;190;0
WireConnection;178;1;191;0
WireConnection;179;0;178;0
WireConnection;179;1;180;0
WireConnection;16;0;69;0
WireConnection;71;0;70;0
WireConnection;71;1;16;0
WireConnection;192;0;179;0
WireConnection;160;0;161;0
WireConnection;160;1;16;4
WireConnection;116;0;71;0
WireConnection;163;0;160;0
WireConnection;163;1;192;0
WireConnection;138;0;143;0
WireConnection;138;1;163;0
WireConnection;114;0;116;0
WireConnection;136;0;141;0
WireConnection;136;1;163;0
WireConnection;137;0;142;0
WireConnection;137;1;163;0
WireConnection;139;0;114;2
WireConnection;139;1;137;0
WireConnection;127;0;114;1
WireConnection;127;1;136;0
WireConnection;140;0;114;3
WireConnection;140;1;138;0
WireConnection;115;0;127;0
WireConnection;115;1;139;0
WireConnection;115;2;140;0
WireConnection;112;0;115;0
WireConnection;112;3;16;4
WireConnection;1;0;112;0
ASEEND*/
//CHKSM=4C0D31F9ADF1940460C55E119D79729584D2443A