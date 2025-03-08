// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "MoleGame/Efx/Archer_Reclaim"
{
Properties
{
	_MainTex ("MainTex", 2D) = "white" {}
	_MaskTex ("MaskTex", 2D) = "white" {}
	_Color("Main Color",Color) = (1,1,1,1)
}

Category
{
	Tags {"Queue"="Transparent" "IgnoreProjector"="True"}
	Blend OneMinusDstColor One
	Cull Off ZWrite Off
	Fog { Mode Off } 

	SubShader
	{
		Pass
		{
		
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma multi_compile_particles
			
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			sampler2D _MaskTex;
			float4 _Color;
			
			struct appdata_t
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float2 texcoord : TEXCOORD0;
			};
			
			struct v2f
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float2 texcoord : TEXCOORD0;
			};
			
			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.color = v.color;
				o.texcoord = v.texcoord;
				return o;
			}
			
			float4 frag (v2f i) : COLOR
			{
				float msk = tex2D(_MaskTex, i.texcoord).r;
				float col = tex2D(_MainTex, i.texcoord + float2(-0.5 + i.color.r * 1.5,0)).r;
					  col = pow(col * 5,1.25);
					  _Color = _Color * col * msk;
				return float4(_Color.rgb * i.color.a,1);
			}
			ENDCG 
		}
	} 	
}
}
