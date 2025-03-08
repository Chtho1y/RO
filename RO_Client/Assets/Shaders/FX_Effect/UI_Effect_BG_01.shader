// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "RO/UI_Effect_BG_01"
{
	Properties
	{
		_Float0("Float 0", Range( 0 , 1)) = 0
		_Color0("Color 0", Color) = (0,0,0,0)
		_Vector0("Vector 0", Vector) = (0,0,0,0)
		_2("2", Vector) = (0,0,0,0)
		_STR("STR", Vector) = (0,0,0,0)
		_Float1("Float 1", Range( 0 , 2)) = 0
		_Float2("Float 2", Range( 0 , 0.2)) = 0
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow 
		struct Input
		{
			float4 screenPos;
		};

		uniform float4 _Color0;
		uniform float4 _Vector0;
		uniform float4 _2;
		uniform float4 _STR;
		uniform float _Float0;
		uniform float _Float2;
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


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 hsvTorgb13 = RGBToHSV( _Color0.rgb );
			float2 appendResult18 = (float2(_Vector0.x , _Vector0.y));
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float2 appendResult27 = (float2(ase_screenPosNorm.x , ase_screenPosNorm.y));
			float2 panner16 = ( 1.0 * _Time.y * appendResult18 + appendResult27);
			float simplePerlin2D6 = snoise( panner16*_2.x );
			simplePerlin2D6 = simplePerlin2D6*0.5 + 0.5;
			float2 appendResult19 = (float2(_Vector0.z , _Vector0.w));
			float2 panner20 = ( 1.0 * _Time.y * appendResult19 + appendResult27);
			float simplePerlin2D21 = snoise( panner20*_2.y );
			simplePerlin2D21 = simplePerlin2D21*0.5 + 0.5;
			float temp_output_24_0 = ( ( ( simplePerlin2D6 * _STR.x ) + 0.0 ) * ( ( simplePerlin2D21 * _STR.y ) + 0.0 ) );
			float mulTime51 = _Time.y * _Float2;
			float3 hsvTorgb14 = HSVToRGB( float3(( hsvTorgb13.x + ( temp_output_24_0 * _Float0 ) + frac( mulTime51 ) ),hsvTorgb13.y,( hsvTorgb13.z + ( temp_output_24_0 * _Float1 ) )) );
			o.Emission = hsvTorgb14;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18100
1927;1;1650;1010;476.6791;857.8419;1;True;False
Node;AmplifyShaderEditor.Vector4Node;17;-989.0122,252.3467;Inherit;False;Property;_Vector0;Vector 0;2;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,-0.1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenPosInputsNode;26;-1494.573,-130.4663;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;19;-784.0122,362.3467;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;18;-779.0122,245.3467;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;27;-1032.84,-120.1266;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;20;-593.0122,366.3467;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;16;-616.0122,180.3467;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;23;-885.0122,496.3467;Inherit;False;Property;_2;2;3;0;Create;True;0;0;False;0;False;0,0,0,0;0.5,1,10,20;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;21;-373.0122,353.3467;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;43;-350.5284,571.4367;Inherit;False;Property;_STR;STR;4;0;Create;True;0;0;False;0;False;0,0,0,0;1,1,0.05,0.05;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NoiseGeneratorNode;6;-405,72;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;121.8035,152.845;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;58.33425,322.1002;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;52;264.9883,-419.2838;Inherit;False;Property;_Float2;Float 2;6;0;Create;True;0;0;False;0;False;0;0.06;0;0.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;36;446.2409,298.956;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;35;452.441,124.5914;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;11;251.2444,-199.3386;Inherit;False;Property;_Color0;Color 0;1;0;Create;True;0;0;False;0;False;0,0,0,0;0.4156863,0.1764706,0.2880932,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;10;386.4239,556.773;Inherit;False;Property;_Float0;Float 0;0;0;Create;True;0;0;False;0;False;0;0.114;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;620.6855,115.1325;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;429.5372,666.8645;Inherit;False;Property;_Float1;Float 1;5;0;Create;True;0;0;False;0;False;0;0.766;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;51;519.6976,-428.9158;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RGBToHSVNode;13;567.0062,-161.9242;Inherit;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;779.5372,90.86447;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;778.5372,218.8645;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;54;761.3209,-362.8419;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;49;911.5372,-54.13553;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;15;877.7402,-182.0301;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.HSVToRGBNode;14;1044.657,-155.0645;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;2;1471.939,-199.1886;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;RO/UI_Effect_BG_01;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;19;0;17;3
WireConnection;19;1;17;4
WireConnection;18;0;17;1
WireConnection;18;1;17;2
WireConnection;27;0;26;1
WireConnection;27;1;26;2
WireConnection;20;0;27;0
WireConnection;20;2;19;0
WireConnection;16;0;27;0
WireConnection;16;2;18;0
WireConnection;21;0;20;0
WireConnection;21;1;23;2
WireConnection;6;0;16;0
WireConnection;6;1;23;1
WireConnection;44;0;6;0
WireConnection;44;1;43;1
WireConnection;45;0;21;0
WireConnection;45;1;43;2
WireConnection;36;0;45;0
WireConnection;35;0;44;0
WireConnection;24;0;35;0
WireConnection;24;1;36;0
WireConnection;51;0;52;0
WireConnection;13;0;11;0
WireConnection;47;0;24;0
WireConnection;47;1;10;0
WireConnection;48;0;24;0
WireConnection;48;1;50;0
WireConnection;54;0;51;0
WireConnection;49;0;13;3
WireConnection;49;1;48;0
WireConnection;15;0;13;1
WireConnection;15;1;47;0
WireConnection;15;2;54;0
WireConnection;14;0;15;0
WireConnection;14;1;13;2
WireConnection;14;2;49;0
WireConnection;2;2;14;0
ASEEND*/
//CHKSM=7F9219A26D38EB8AC6CAD6DD99AFCE51371D05F6