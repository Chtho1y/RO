// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "WTGame/Scene/AtomSphere_A" {
	Properties {
		_Color("Main Color",Color) = (1,1,1,1)
		_XSpeed("XSpeed",float) = 0
		_MainTex ("Particle Texture", 2D) = "white" {}
		_MaskTex ("Mask Texture", 2D) = "white" {}
	}

	SubShader {
		Tags { "Queue"="Transparent-10" "IgnoreProjector"="True" } 
		Fog { Mode Off }
		Blend SrcAlpha One
		Cull Off
		ZWrite Off
		
		pass
		{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
	      	#include "UnityCG.cginc"
		
			half _XSpeed;
			fixed4 _Color;
			sampler2D _MainTex;
			sampler2D _MaskTex;
			float4 _MaskTex_ST;
			float4 _MainTex_ST;
			
			struct appdata 
			{
			    float4 vertex : POSITION;
			    half2 texcoord : TEXCOORD0;
				half2 maskcoord : TEXCOORD1;
			};
			
			struct v2f {
			    half4 vertex:SV_POSITION;
			    half2 texcoord:TEXCOORD0;
				half2 maskCoord:TEXCOORD1;
			};
			
			v2f vert (appdata v)
			{
			    v2f o;
			    
			    o.vertex = UnityObjectToClipPos (v.vertex);
				o.maskCoord = TRANSFORM_TEX(v.maskcoord, _MaskTex);
			    o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
             
			    return o;
			}
			
			fixed4 frag(v2f i):COLOR
			{
				fixed4 msk = tex2D(_MaskTex, i.maskCoord);
				fixed4 tex = tex2D(_MainTex, i.texcoord + float2(_Time.x * _XSpeed,0));
				fixed4 c = fixed4(_Color.rgb * tex.rgb * tex.a,1) * msk * 2.5;
				c.a = saturate(c.a);
				return c;

			}
			ENDCG
		}
	} 
}