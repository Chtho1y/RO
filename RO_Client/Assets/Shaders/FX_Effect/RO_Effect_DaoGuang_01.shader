// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "RO/RO_Effect_DaoGuang_01"
{
	Properties
	{
		_UMax("UMax", Range( 0 , 1)) = 1
		_UMin("UMin", Range( 0 , 1)) = 0
		_Min("尾", Range( -1 , 1)) = 0
		_Float4("头", Range( 0 , 2)) = 1
		_to("to", Vector) = (3.73,0.2,0,0)
		[HDR]_Color3("Color 3", Color) = (1,1,1,0)
		[HDR]_Color2("Color 2", Color) = (0,0,0,0)
		_ColorSmoothStepMin("ColorSmoothStepMin", Range( 0 , 1)) = 0
		_ColorSmoothStepMax("ColorSmoothStepMax", Range( 0 , 1)) = 1
		_AlphaSmoothStepMin("AlphaSmoothStepMin", Range( 0 , 1)) = 0
		_AlphaSmoonthStepMax("AlphaSmoonthStepMax", Range( 0 , 1)) = 1
		[Enum(UnityEngine.Rendering.BlendMode)]_Src("Src", Float) = 5
		[Enum(UnityEngine.Rendering.BlendMode)]_Dst("Dst", Float) = 10
		[Enum(UnityEngine.Rendering.CullMode)]_CullMode3("CullMode", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord2( "", 2D ) = "white" {}
		[HideInInspector] _tex4coord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IsEmissive" = "true"  }
		Cull [_CullMode3]
		ZWrite Off
		Blend [_Src] [_Dst]
		
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha noshadow 
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
			float4 uv_tex4coord;
			float2 uv2_texcoord2;
		};

		uniform float _CullMode3;
		uniform float _Src;
		uniform float _Dst;
		uniform float4 _Color2;
		uniform float4 _Color3;
		uniform float _ColorSmoothStepMin;
		uniform float _ColorSmoothStepMax;
		uniform float _UMin;
		uniform float _UMax;
		uniform float _Min;
		uniform float _AlphaSmoothStepMin;
		uniform float _AlphaSmoonthStepMax;
		uniform float4 _to;
		uniform float _Float4;


		float2 voronoihash16( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi16( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash16( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			 		}
			 	}
			}
			return F1;
		}


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float Src255 = _Src;
			float Dst256 = _Dst;
			float4 appendResult266 = (float4(_Color2.r , _Color2.g , _Color2.b , 0.0));
			float smoothstepResult45 = smoothstep( _UMin , ( _UMin + _UMax ) , i.uv_texcoord.x);
			float smoothstepResult9 = smoothstep( _Min , 1.0 , i.uv_texcoord.y);
			float Alpha286 = ( smoothstepResult45 * smoothstepResult9 );
			float temp_output_308_0 = saturate( Alpha286 );
			float smoothstepResult313 = smoothstep( _ColorSmoothStepMin , _ColorSmoothStepMax , temp_output_308_0);
			float ColorSmoothstep314 = smoothstepResult313;
			float4 lerpResult65 = lerp( appendResult266 , _Color3 , ColorSmoothstep314);
			float4 break168 = lerpResult65;
			float3 appendResult181 = (float3(break168.r , break168.g , break168.b));
			float3 appendResult176 = (float3(i.vertexColor.r , i.vertexColor.g , i.vertexColor.b));
			float3 temp_output_182_0 = ( appendResult181 * appendResult176 );
			float smoothstepResult310 = smoothstep( _AlphaSmoothStepMin , _AlphaSmoonthStepMax , temp_output_308_0);
			float AlphaSmoothstep315 = smoothstepResult310;
			float lerpResult306 = lerp( _Color2.a , _Color3.a , AlphaSmoothstep315);
			float W279 = i.uv_tex4coord.z;
			float time16 = 0.0;
			float2 appendResult31 = (float2(_to.x , _to.y));
			float2 appendResult189 = (float2(( ( ( _to.z / 100.0 ) * _Time.y ) + i.uv2_texcoord2.x ) , ( ( _Time.y * ( _to.w / 100.0 ) ) + i.uv2_texcoord2.y )));
			float2 appendResult232 = (float2(smoothstepResult45 , i.uv_texcoord.y));
			float2 UV231 = appendResult232;
			float2 coords16 = ( appendResult31 * ( appendResult189 + ( 1.0 - min( UV231 , i.uv_texcoord ) ) ) ) * 1.0;
			float2 id16 = 0;
			float2 uv16 = 0;
			float voroi16 = voronoi16( coords16, time16, id16, uv16, 0 );
			float smoothstepResult219 = smoothstep( saturate( ( _Float4 - 1.0 ) ) , saturate( _Float4 ) , distance( i.uv_texcoord.y , 1.0 ));
			float lerpResult288 = lerp( ( voroi16 * saturate( ( smoothstepResult45 * ( smoothstepResult45 * smoothstepResult219 * smoothstepResult9 ) ) ) * 4.0 ) , ( smoothstepResult45 * ( smoothstepResult45 * smoothstepResult219 * smoothstepResult9 ) ) , ( smoothstepResult45 * ( smoothstepResult45 * smoothstepResult219 * smoothstepResult9 ) ));
			float A194 = i.vertexColor.a;
			float temp_output_174_0 = ( lerpResult306 * step( ( 1.0 - W279 ) , saturate( lerpResult288 ) ) * A194 );
			float3 ifLocalVar259 = 0;
			if( Src255 == Dst256 )
				ifLocalVar259 = ( temp_output_182_0 * temp_output_174_0 );
			else
				ifLocalVar259 = temp_output_182_0;
			o.Emission = ifLocalVar259;
			o.Alpha = temp_output_174_0;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18500
2319;7;1512;1004;-3208.797;1339.39;2.05524;True;True
Node;AmplifyShaderEditor.RangedFloatNode;46;-284.401,-502.7425;Inherit;False;Property;_UMin;UMin;2;0;Create;True;0;0;False;0;False;0;0.396;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;47;-289.4337,-322.3913;Inherit;False;Property;_UMax;UMax;1;0;Create;True;0;0;False;0;False;1;0.621;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-854.0798,-629.3102;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;274;82.4494,-326.6314;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;15;-451.2207,-409.3493;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;45;248.9251,-608.2075;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;244;611.5007,-500.8649;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;245;521.4115,-379.9427;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;30;-1167.493,1078.087;Inherit;False;Property;_to;to;5;0;Create;True;0;0;False;0;False;3.73,0.2,0,0;11,7,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;232;929.007,-460.9109;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;303;-812.8684,1317.321;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;100;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;221;-872.4377,161.3069;Inherit;False;Property;_Float4;头;4;0;Create;False;0;0;False;0;False;1;0.47;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;297;-819.8684,1244.321;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;302;-801.8684,1153.321;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;100;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;231;1132.672,-469.0911;Inherit;False;UV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;234;-868.0883,1773.147;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;293;-1007.291,1386.278;Inherit;False;1;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;299;-565.8684,1273.321;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;239;-344.6961,-9.379337;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;233;-715.5815,1586.47;Inherit;False;231;UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;298;-560.8684,1169.321;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;105.5229,174.0992;Inherit;False;Property;_Min;尾;3;0;Create;False;0;0;False;0;False;0;0.187;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;77;-304.7214,-220.7876;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMinOpNode;237;-392.7217,1631.658;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;301;-360.8684,1365.321;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;238;-58.97867,83.48351;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;300;-355.8684,1268.321;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;240;-94.02355,-49.34134;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;9;560.2898,143.1169;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;189;-147.5758,1238.746;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;83;-179.3208,1419.139;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;285;862.0826,42.75162;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;219;315.9877,-261.9556;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;853.2915,-198.8015;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;31;-513.7269,1008.896;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;184;122.4293,1318.355;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;286;1345.237,-38.75024;Inherit;False;Alpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;287;2285.82,-1058.38;Inherit;False;286;Alpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;223;1134.57,-216.2754;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;210;378.2055,1133.49;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;318;2451.418,-1325.57;Inherit;False;Property;_ColorSmoothStepMin;ColorSmoothStepMin;8;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;16;655.1978,1133.224;Inherit;True;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.RelayNode;142;1449.958,-251.5046;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;308;2531.776,-1045.726;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;319;2504.183,-1184.178;Inherit;False;Property;_ColorSmoothStepMax;ColorSmoothStepMax;9;0;Create;True;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;226;1739.785,245.5874;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;313;2879.152,-1189.689;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;110;1750.791,-16.86349;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;137;1634.044,100.823;Inherit;False;Constant;_Float0;Float 0;13;0;Create;True;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;252;1377.014,-733.4142;Inherit;False;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;314;3158.318,-1166.902;Inherit;False;ColorSmoothstep;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;312;2542.021,-806.2986;Inherit;False;Property;_AlphaSmoonthStepMax;AlphaSmoonthStepMax;11;0;Create;True;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;135;1959.068,-0.4237928;Inherit;True;3;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;311;2533.021,-903.2986;Inherit;False;Property;_AlphaSmoothStepMin;AlphaSmoothStepMin;10;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;66;2611.645,-659.0076;Inherit;False;Property;_Color2;Color 2;7;1;[HDR];Create;True;0;0;False;0;False;0,0,0,0;0.972549,0.04710289,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;266;2962.953,-628.0229;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;288;2218.917,-366.3501;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;67;2678.226,-441.8311;Inherit;False;Property;_Color3;Color 3;6;1;[HDR];Create;True;0;0;False;0;False;1,1,1,0;3.947275,1.452256,0.912342,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;316;3040.624,-426.3923;Inherit;False;314;ColorSmoothstep;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;310;2897.853,-961.4648;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;279;1699.879,-673.5099;Inherit;False;W;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;65;3165.434,-573.2641;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;315;3233.441,-935.0675;Inherit;False;AlphaSmoothstep;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;132;2436.547,-36.99094;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;283;2955.906,40.29465;Inherit;False;279;W;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;317;3223.624,-246.3923;Inherit;False;315;AlphaSmoothstep;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;178;3267.119,10.07368;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;168;3398.542,-592.4922;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RelayNode;241;3000.948,142.8637;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;175;2463.137,283.4294;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;181;3798.88,-528.1111;Inherit;True;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;257;3753.343,-817.716;Inherit;False;Property;_Src;Src;12;1;[Enum];Create;True;0;1;UnityEngine.Rendering.BlendMode;True;0;False;5;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;176;3743.457,141.2161;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;306;3510.37,-322.9135;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;258;3753.343,-657.7159;Inherit;False;Property;_Dst;Dst;13;1;[Enum];Create;True;0;1;UnityEngine.Rendering.BlendMode;True;0;False;10;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;194;3674.88,266.9806;Inherit;False;A;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;170;3684.299,-72.64247;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;255;4009.342,-801.716;Inherit;False;Src;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;256;4025.342,-641.7159;Inherit;False;Dst;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;174;4132.407,-145.399;Inherit;False;3;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;182;4142.138,-412.1609;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;261;4323.045,-519.1841;Inherit;False;255;Src;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;263;4436.127,-218.625;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;262;4326.045,-454.1841;Inherit;False;256;Dst;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;259;4647.045,-485.1841;Inherit;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;320;3673.838,-988.8634;Inherit;False;Property;_CullMode3;CullMode;14;1;[Enum];Create;True;0;1;UnityEngine.Rendering.CullMode;True;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;246;5397.845,-327.478;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;RO/RO_Effect_DaoGuang_01;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;2;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;True;Custom;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;True;257;10;True;258;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;True;320;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;274;0;46;0
WireConnection;274;1;47;0
WireConnection;15;0;2;2
WireConnection;45;0;2;1
WireConnection;45;1;46;0
WireConnection;45;2;274;0
WireConnection;244;0;45;0
WireConnection;245;0;15;0
WireConnection;232;0;244;0
WireConnection;232;1;245;0
WireConnection;303;0;30;4
WireConnection;302;0;30;3
WireConnection;231;0;232;0
WireConnection;299;0;297;0
WireConnection;299;1;303;0
WireConnection;239;0;221;0
WireConnection;298;0;302;0
WireConnection;298;1;297;0
WireConnection;77;0;15;0
WireConnection;237;0;233;0
WireConnection;237;1;234;0
WireConnection;301;0;299;0
WireConnection;301;1;293;2
WireConnection;238;0;221;0
WireConnection;300;0;298;0
WireConnection;300;1;293;1
WireConnection;240;0;239;0
WireConnection;9;0;15;0
WireConnection;9;1;10;0
WireConnection;189;0;300;0
WireConnection;189;1;301;0
WireConnection;83;0;237;0
WireConnection;285;0;244;0
WireConnection;285;1;9;0
WireConnection;219;0;77;0
WireConnection;219;1;240;0
WireConnection;219;2;238;0
WireConnection;12;0;244;0
WireConnection;12;1;219;0
WireConnection;12;2;9;0
WireConnection;31;0;30;1
WireConnection;31;1;30;2
WireConnection;184;0;189;0
WireConnection;184;1;83;0
WireConnection;286;0;285;0
WireConnection;223;0;244;0
WireConnection;223;1;12;0
WireConnection;210;0;31;0
WireConnection;210;1;184;0
WireConnection;16;0;210;0
WireConnection;142;0;223;0
WireConnection;308;0;287;0
WireConnection;226;0;16;0
WireConnection;313;0;308;0
WireConnection;313;1;318;0
WireConnection;313;2;319;0
WireConnection;110;0;142;0
WireConnection;314;0;313;0
WireConnection;135;0;226;0
WireConnection;135;1;110;0
WireConnection;135;2;137;0
WireConnection;266;0;66;1
WireConnection;266;1;66;2
WireConnection;266;2;66;3
WireConnection;288;0;135;0
WireConnection;288;1;142;0
WireConnection;288;2;142;0
WireConnection;310;0;308;0
WireConnection;310;1;311;0
WireConnection;310;2;312;0
WireConnection;279;0;252;3
WireConnection;65;0;266;0
WireConnection;65;1;67;0
WireConnection;65;2;316;0
WireConnection;315;0;310;0
WireConnection;132;0;288;0
WireConnection;178;0;283;0
WireConnection;168;0;65;0
WireConnection;241;0;132;0
WireConnection;181;0;168;0
WireConnection;181;1;168;1
WireConnection;181;2;168;2
WireConnection;176;0;175;1
WireConnection;176;1;175;2
WireConnection;176;2;175;3
WireConnection;306;0;66;4
WireConnection;306;1;67;4
WireConnection;306;2;317;0
WireConnection;194;0;175;4
WireConnection;170;0;178;0
WireConnection;170;1;241;0
WireConnection;255;0;257;0
WireConnection;256;0;258;0
WireConnection;174;0;306;0
WireConnection;174;1;170;0
WireConnection;174;2;194;0
WireConnection;182;0;181;0
WireConnection;182;1;176;0
WireConnection;263;0;182;0
WireConnection;263;1;174;0
WireConnection;259;0;261;0
WireConnection;259;1;262;0
WireConnection;259;2;182;0
WireConnection;259;3;263;0
WireConnection;259;4;182;0
WireConnection;246;2;259;0
WireConnection;246;9;174;0
ASEEND*/
//CHKSM=87CDA87E9D30098776A808FDD2D0B2FFEED7EC72