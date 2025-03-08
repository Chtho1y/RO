// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "RO/UI_Effect_XingXing_01"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Float0("Float 0", Range( 0 , 1)) = 0
		[HDR]_Color0("Color 0", Color) = (1,1,1,1)
		_Vector0("Vector 0", Vector) = (0,0,0,0)
		[HDR]_Color1("Color 1", Color) = (1,0.1745283,0.1745283,0)
		_2("2", Vector) = (0,0,0,0)
		_Float3("Float 2", Range( 0 , 0.2)) = 0
		[Enum(UnityEngine.Rendering.BlendMode)]_Src("Src", Float) = 0
		[Enum(UnityEngine.Rendering.BlendMode)]_Dst("Dst", Float) = 0
		_Float1("Float 1", Range( 0 , 2)) = 0

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend One One
		Cull Back
		ColorMask RGBA
		ZWrite Off
		ZTest LEqual
		
		
		
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
			#define ASE_NEEDS_FRAG_COLOR


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
#endif
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_color : COLOR;
				float4 ase_texcoord3 : TEXCOORD3;
			};

			uniform float _Dst;
			uniform float _Src;
			uniform float4 _Color0;
			uniform float4 _Color1;
			uniform sampler2D _TextureSample0;
			uniform float4 _Vector0;
			uniform float4 _2;
			uniform float _Float0;
			uniform float _Float3;
			uniform float _Float1;
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
			float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }
			float snoise( float2 v )
			{
				const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
				float2 i = floor( v + dot( v, C.yy ) );
				float2 x0 = v - i + dot( i, C.xx );
				float2 i1;
				i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
				float4 x12 = x0.xyxy + C.xxzz;
				x12.xy -= i1;
				i = mod2D289( i );
				float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
				float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
				m = m * m;
				m = m * m;
				float3 x = 2.0 * frac( p * C.www ) - 1.0;
				float3 h = abs( x ) - 0.5;
				float3 ox = floor( x + 0.5 );
				float3 a0 = x - ox;
				m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
				float3 g;
				g.x = a0.x * x0.x + h.x * x0.y;
				g.yz = a0.yz * x12.xz + h.yz * x12.yw;
				return 130.0 * dot( m, g );
			}
			

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord3 = screenPos;
				
				o.ase_texcoord1 = v.ase_texcoord;
				o.ase_texcoord2 = v.ase_texcoord1;
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
				float2 uv02 = i.ase_texcoord1 * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult8 = smoothstep( 0.5 , 1.0 , ( 1.0 - distance( uv02 , float2( 0.5,0.5 ) ) ));
				float4 uv017 = i.ase_texcoord1;
				uv017.xy = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float4 uv127 = i.ase_texcoord2;
				uv127.xy = i.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float4 tex2DNode10 = tex2D( _TextureSample0, ( uv02 + ( ( uv02 - float2( 0.5,0.5 ) ) * smoothstepResult8 * (uv017.w + (uv017.z - 0.0) * (uv127.x - uv017.w) / (1.0 - 0.0)) ) ) );
				float4 lerpResult28 = lerp( _Color0 , _Color1 , tex2DNode10.a);
				float temp_output_48_0 = ( tex2DNode10.a * i.ase_color.a );
				float3 hsvTorgb42 = RGBToHSV( ( lerpResult28 * i.ase_color * temp_output_48_0 ).rgb );
				float2 appendResult34 = (float2(_Vector0.x , _Vector0.y));
				float4 screenPos = i.ase_texcoord3;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float2 appendResult32 = (float2(ase_screenPosNorm.x , ase_screenPosNorm.y));
				float2 panner36 = ( 1.0 * _Time.y * appendResult34 + appendResult32);
				float simplePerlin2D40 = snoise( panner36*_2.x );
				simplePerlin2D40 = simplePerlin2D40*0.5 + 0.5;
				float2 appendResult33 = (float2(_Vector0.z , _Vector0.w));
				float2 panner35 = ( 1.0 * _Time.y * appendResult33 + appendResult32);
				float simplePerlin2D39 = snoise( panner35*_2.y );
				simplePerlin2D39 = simplePerlin2D39*0.5 + 0.5;
				float temp_output_43_0 = ( simplePerlin2D40 * simplePerlin2D39 );
				float mulTime56 = _Time.y * _Float3;
				float3 hsvTorgb45 = HSVToRGB( float3(( hsvTorgb42.x + ( temp_output_43_0 * _Float0 ) + mulTime56 ),hsvTorgb42.y,( hsvTorgb42.z + ( temp_output_43_0 * _Float1 * tex2DNode10.a ) )) );
				
				
				finalColor = float4( hsvTorgb45 , 0.0 );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18100
1927;7;1650;1004;-1811.771;255.194;1.235329;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-1004.084,-69.90973;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DistanceOpNode;5;-585.4692,352.3177;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;17;126.1707,258.1432;Inherit;False;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;27;96.41583,674.4251;Inherit;False;1;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;7;-338.4693,347.3177;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;8;-113.4695,350.3177;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.5;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;3;-124.8932,17.53511;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCRemapNode;20;402.2481,334.5064;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;31;667.9064,411.3241;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;30;1173.466,794.1367;Inherit;False;Property;_Vector0;Vector 0;4;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0.01,-0.1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;424.0483,23.81427;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;11;548.3466,-57.6273;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;34;1383.467,787.1367;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;32;1129.639,421.6637;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;33;1378.467,904.1364;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.VertexColorNode;19;999.2515,84.26766;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;26;1065.161,-576.1695;Inherit;False;Property;_Color0;Color 0;3;1;[HDR];Create;True;0;0;False;0;False;1,1,1,1;1,0.1254902,0.3505661,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;10;923.213,-155.613;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;False;-1;None;ad103d9266802494e8d3107723965ee3;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;29;1106.187,-359.2216;Inherit;False;Property;_Color1;Color 1;5;1;[HDR];Create;True;0;0;False;0;False;1,0.1745283,0.1745283,0;1.498039,0.3607843,0.4784314,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector4Node;37;1462.467,1055.136;Inherit;False;Property;_2;2;6;0;Create;True;0;0;False;0;False;0,0,0,0;0.5,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;35;1569.467,908.1365;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;36;1546.467,722.1365;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;1728.185,300.717;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;28;1400.153,-95.39499;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;40;1757.479,613.7899;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;39;1789.466,895.1365;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;2319.39,1019.981;Inherit;False;Property;_Float1;Float 1;10;0;Create;True;0;0;False;0;False;0;2;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;2209.743,872.2114;Inherit;False;Property;_Float0;Float 0;1;0;Create;True;0;0;False;0;False;0;0.47;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;2101.371,77.66222;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;55;2366.039,147.6899;Inherit;False;Property;_Float3;Float 2;7;0;Create;True;0;0;False;0;False;0;0.0575;0;0.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;2424.861,689.4515;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;56;2657.809,147.9407;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;2637.39,909.9813;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RGBToHSVNode;42;2729.486,379.8661;Inherit;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;2602.86,716.8203;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;52;3024.39,519.9813;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;44;3043.846,370.1835;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.HSVToRGBNode;45;3310.905,392.9025;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;24;595.6111,183.7539;Inherit;False;Property;_Float2;Float 2;2;0;Create;True;0;0;False;0;False;0.7480443;0.036;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;1128.095,-1075.674;Inherit;False;Property;_Dst;Dst;9;1;[Enum];Create;True;0;1;UnityEngine.Rendering.BlendMode;True;0;False;0;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;49;872.0947,-1087.674;Inherit;False;Property;_Src;Src;8;1;[Enum];Create;True;0;1;UnityEngine.Rendering.BlendMode;True;0;False;0;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;46;3595.245,401.7956;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;13;3994.425,274.3948;Float;False;True;-1;2;ASEMaterialInspector;100;1;RO/UI_Effect_XingXing_01;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;4;1;False;-1;1;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;True;False;True;0;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;3;False;-1;True;False;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;0
WireConnection;5;0;2;0
WireConnection;7;0;5;0
WireConnection;8;0;7;0
WireConnection;3;0;2;0
WireConnection;20;0;17;3
WireConnection;20;3;17;4
WireConnection;20;4;27;1
WireConnection;9;0;3;0
WireConnection;9;1;8;0
WireConnection;9;2;20;0
WireConnection;11;0;2;0
WireConnection;11;1;9;0
WireConnection;34;0;30;1
WireConnection;34;1;30;2
WireConnection;32;0;31;1
WireConnection;32;1;31;2
WireConnection;33;0;30;3
WireConnection;33;1;30;4
WireConnection;10;1;11;0
WireConnection;35;0;32;0
WireConnection;35;2;33;0
WireConnection;36;0;32;0
WireConnection;36;2;34;0
WireConnection;48;0;10;4
WireConnection;48;1;19;4
WireConnection;28;0;26;0
WireConnection;28;1;29;0
WireConnection;28;2;10;4
WireConnection;40;0;36;0
WireConnection;40;1;37;1
WireConnection;39;0;35;0
WireConnection;39;1;37;2
WireConnection;18;0;28;0
WireConnection;18;1;19;0
WireConnection;18;2;48;0
WireConnection;43;0;40;0
WireConnection;43;1;39;0
WireConnection;56;0;55;0
WireConnection;53;0;43;0
WireConnection;53;1;54;0
WireConnection;53;2;10;4
WireConnection;42;0;18;0
WireConnection;51;0;43;0
WireConnection;51;1;38;0
WireConnection;52;0;42;3
WireConnection;52;1;53;0
WireConnection;44;0;42;1
WireConnection;44;1;51;0
WireConnection;44;2;56;0
WireConnection;45;0;44;0
WireConnection;45;1;42;2
WireConnection;45;2;52;0
WireConnection;46;0;45;0
WireConnection;46;3;48;0
WireConnection;13;0;45;0
ASEEND*/
//CHKSM=99F0F36D7DD8A32F6B5F8D26EAC8FBC81FE883EB