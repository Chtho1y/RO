// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "effect/distortadd" {
Properties {
	_TintColor ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
	_NoiseTex ("Distort Texture (RG)", 2D) = "white" {}
	_MainTex ("Alpha (A)", 2D) = "white" {}
	_TintTex ("Tint Texture", 2D) = "white" {}
	_BlendFactor("Blend Factor", range(1,2)) = 1.5
	_HeatTime  ("Heat Time", range (-1,1)) = 0
	_ForceX  ("Strength X", range (0,1)) = 0.1
	_ForceY  ("Strength Y", range (0,1)) = 0.1
}

Category {
	Tags { "Queue"="Transparent" "RenderType"="Transparent" }
	Blend SrcAlpha OneMinusSrcAlpha
	Cull Off Lighting Off ZWrite Off
    Fog{ Mode Linear Color(0.87,0.87,0.87,1) Density 10.1  Range 0,10 }
	BindChannels {
		Bind "Color", color
		Bind "Vertex", vertex
		Bind "TexCoord", texcoord
	}

	SubShader {
		Pass {
CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma fragmentoption ARB_precision_hint_fastest
#pragma multi_compile_particles
#pragma multi_compile_fog
#include "UnityCG.cginc"

struct appdata_t {
	float4 vertex : POSITION;
	fixed4 color : COLOR;
	float2 texcoord: TEXCOORD0;
};

struct v2f {
	float4 vertex : POSITION;
	fixed4 color : COLOR;
	float2 uvmain : TEXCOORD1;
	float2 uvtint : TEXCOORD2;
	UNITY_FOG_COORDS(3)
};

fixed4 _TintColor;
fixed _ForceX;
fixed _ForceY;
fixed _HeatTime;
fixed _BlendFactor;
float4 _MainTex_ST;
float4 _TintTex_ST;
float4 _NoiseTex_ST;
sampler2D _NoiseTex;
sampler2D _MainTex;
sampler2D _TintTex;

v2f vert (appdata_t v)
{
	v2f o;
	o.vertex = UnityObjectToClipPos(v.vertex);
	o.color = v.color;
	o.uvmain = TRANSFORM_TEX( v.texcoord, _MainTex );
	o.uvtint = TRANSFORM_TEX( v.texcoord, _TintTex );
	UNITY_TRANSFER_FOG(o, o.vertex);
	return o;
}

fixed4 frag( v2f i ) : COLOR
{
	//noise effect
	fixed4 offsetColor1 = tex2D(_NoiseTex, i.uvmain + _Time.xz*_HeatTime);
    fixed4 offsetColor2 = tex2D(_NoiseTex, i.uvmain + _Time.yx*_HeatTime);
	fixed4 tintTexColor = tex2D(_TintTex,i.uvtint);
	i.uvmain.x += ((offsetColor1.r + offsetColor2.r) - 1) * _ForceX;
	i.uvmain.y += ((offsetColor1.r + offsetColor2.r) - 1) * _ForceY;
	fixed4 mainTexColor = tex2D(_MainTex, i.uvmain);
	fixed3 fcolor = 2.0f * _TintColor.rgb * i.color.rgb * mainTexColor.rgb;
	fixed4 rcolor = fixed4(fcolor, _BlendFactor*tintTexColor.r*_TintColor.a);
	UNITY_APPLY_FOG(i.fogCoord, rcolor);
	return rcolor;
}
ENDCG
		}
}
	// ------------------------------------------------------------------
	// Fallback for older cards and Unity non-Pro
	
	SubShader {
		Blend DstColor Zero
		Pass {
			Name "BASE"
			SetTexture [_MainTex] {	combine texture }
		}
	}
}
}
