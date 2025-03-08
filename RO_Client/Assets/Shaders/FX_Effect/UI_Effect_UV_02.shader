Shader "RO/UI_Effect_UV_02"
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
		_Color1("Color1", Color) = (0,0.2255201,1,1)
		_Color2("Color2", Color) = (1,0,0,1)
		_LerpStr("LerpStr", Float) = 1
		_Texture0("Texture 0", 2D) = "white" {}
		_Tling("Tling", Vector) = (1,1,1,1)
		_UVSpeed("UVSpeed", Vector) = (0,0,0,0)

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
			Comp [_StencilComp]
			Pass [_StencilOp]
			Fail Keep
			ZFail Keep
		}


		Cull Back
		Lighting Off
		ZWrite Off
		ZTest [unity_GUIZTestMode]
		Blend One One
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
				
			};
			
			uniform fixed4 _Color;
			uniform fixed4 _TextureSampleAdd;
			uniform float4 _ClipRect;
			uniform sampler2D _MainTex;
			uniform float4 _Color1;
			uniform float4 _Color2;
			uniform sampler2D _Texture0;
			uniform float4 _UVSpeed;
			uniform float4 _Tling;
			uniform float _LerpStr;

			
			v2f vert( appdata_t IN  )
			{
				v2f OUT;
				UNITY_SETUP_INSTANCE_ID( IN );
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
				UNITY_TRANSFER_INSTANCE_ID(IN, OUT);
				OUT.worldPosition = IN.vertex;
				
				
				OUT.worldPosition.xyz +=  float3( 0, 0, 0 ) ;
				OUT.vertex = UnityObjectToClipPos(OUT.worldPosition);

				OUT.texcoord = IN.texcoord;
				
				OUT.color = IN.color * _Color;
				return OUT;
			}

			fixed4 frag(v2f IN  ) : SV_Target
			{
				float2 appendResult14 = (float2(_UVSpeed.x , _UVSpeed.y));
				float2 appendResult38 = (float2(_Tling.x , _Tling.y));
				float2 uv04 = IN.texcoord.xy * appendResult38 + float2( 0,0 );
				float2 panner3 = ( 1.0 * _Time.y * appendResult14 + uv04);
				float4 break59 = tex2D( _Texture0, panner3 );
				float4 appendResult63 = (float4(break59.r , break59.g , break59.b , ( _Color1.a * break59.a )));
				float2 appendResult15 = (float2(_UVSpeed.z , _UVSpeed.w));
				float2 appendResult39 = (float2(_Tling.z , _Tling.w));
				float2 uv023 = IN.texcoord.xy * appendResult39 + float2( 0,0 );
				float2 panner12 = ( 1.0 * _Time.y * appendResult15 + uv023);
				float4 break60 = tex2D( _Texture0, panner12 );
				float4 appendResult64 = (float4(break60.r , break60.g , break60.b , ( break60.a * _Color2.a )));
				float4 lerpResult41 = lerp( _Color1 , _Color2 , saturate( ( ( appendResult63 * appendResult64 ).w * _LerpStr ) ));
				float4 temp_output_73_0 = saturate( lerpResult41 );
				float temp_output_33_0 = saturate( ( appendResult63 * appendResult64 ).w );
				
				half4 color = ( temp_output_73_0 * temp_output_33_0 );
				
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
}
