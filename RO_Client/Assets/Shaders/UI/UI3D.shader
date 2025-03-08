// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "UI/UI3D" {
	Properties {
		_MainTex ("Font Texture", 2D) = "white" {}
		_Color ("Color", Color) = (1,1,1,1)
	}

	SubShader {

		Tags 
		{
			"Queue"="Transparent+1500"     //为了跟TextMesh一致
			"IgnoreProjector"="True"
			"RenderType"="Transparent"
		}

		Lighting Off 
		ZTest Off
		ZWrite Off 
		Fog { Mode Off }
		Blend SrcAlpha OneMinusSrcAlpha

		Pass 
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile _DUMMY _SEPERATE_ALPHA_TEX_ON

			#include "UnityCG.cginc"

			struct appdata_t {
				float4 vertex : POSITION;
				fixed4 color : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				fixed4 color : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			sampler2D _MainTex;
            fixed4 _Color;
			uniform float4 _MainTex_ST;
#if _SEPERATE_ALPHA_TEX_ON
			sampler2D _AlphaTex;
#endif

			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.color = v.color;
				o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
#ifdef UNITY_HALF_TEXEL_OFFSET
				o.vertex.xy += (_ScreenParams.zw-1.0)*float2(-1,1);
#endif
				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
#if _SEPERATE_ALPHA_TEX_ON
				fixed4 col = fixed4(tex2D(_MainTex, i.texcoord).rgb, tex2D(_AlphaTex, i.texcoord).r);
#else
				fixed4 col = tex2D(_MainTex, i.texcoord);
#endif
				return col * i.color * _Color;
			}
			ENDCG 
		}
	}
}

