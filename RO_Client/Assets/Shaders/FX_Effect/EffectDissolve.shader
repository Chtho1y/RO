// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "WPYS/Effect/Special/EffectDissolve"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
        _TintColor("Tint Color", Color) = (1, 1, 1, 1)
        _DissolveTex("DissolveTex", 2D) = "white" {}
        _Dissolve("Dissolve", Range(0, 1)) = 0
	}
	Category{
			Tags{ "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
			Blend SrcAlpha OneMinusSrcAlpha
			Cull Off Lighting Off ZWrite Off
	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_particles

			#include "UnityCG.cginc"

			struct appdata
			{
				half4 vertex : POSITION;
				fixed4 color : COLOR;
				half2 uv : TEXCOORD0;
			};

			struct v2f
			{
				half4 vertex : SV_POSITION;
				fixed4 color : COLOR;
				half2 uv : TEXCOORD0;
				half2 uv2 : TEXCOORD1;
			};

			sampler2D _MainTex;
			sampler2D _DissolveTex;
			fixed4 _MainTex_ST;
			fixed4 _DissolveTex_ST;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.uv2 = TRANSFORM_TEX(v.uv, _DissolveTex);
				o.color = v.color;
				return o;
			}

			fixed4 _TintColor;
			fixed _Dissolve;

			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 disov = tex2D(_DissolveTex, i.uv2);
				disov.r += i.color.a - 1;
				clip(disov.r - _Dissolve);
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv) * _TintColor;
				col.rgb *= i.color.rgb;
				return col;
			}
			ENDCG
		}
	}
	SubShader {
		Lighting Off
		ZWrite off
		Blend SrcAlpha OneMinusSrcAlpha
		Pass {
			Name "BASE"
			SetTexture[_MainTex] {
				constantColor[_TintColor]
				combine texture * constant
				}
			SetTexture[_MainTex] {
				combine previous * Primary
			}
		}
	}
		}
}
