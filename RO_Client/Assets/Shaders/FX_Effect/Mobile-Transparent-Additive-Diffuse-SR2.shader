//������ڻᱻmask�е���UI�ϣ���Stencil Comparison�ĳ�4��Stencil ID�ĳ�2

Shader "MoleGame/Efxadd/Additive/Diffuse-SR2" {
Properties {
	_MainTex ("Base layer (RGB)", 2D) = "white" {}
	_ScrollX ("Base layer scroll speed X", Float) = 1.0
	_ScrollY ("Base layer scroll speed Y", Float) = 0.0
	_RotationStart("Rotation Start", Float) = 0	
	_RotationX("Base layer rotation center Y", Float) = 0.5	
	_RotationY("Base layer rotation center X", Float) = 0.5
	_Rotation ("Base layer rotation speed", Float) = 1.0
	
	_DetailTex ("2nd layer (RGB)", 2D) = "white" {}
	_ScrollX2 ("2nd layer scroll speed X", Float) = 1.0
	_ScrollY2 ("2nd layer scroll speed Y", Float) = 0.0
	_RotationStart2("Rotation Start", Float) = 0	
	_RotationX2("2nd layer rotation center Y", Float) = 0.5	
	_RotationY2("2nd layer rotation center X", Float) = 0.5
	_Rotation2 ("2nd layer rotation speed", Float) = 1.0	
	
	_Color("Color", Color) = (1,1,1,1)
	_MMultiplier ("Multiplier", Float) = 2.0	
	//4 equal
	//[HideInInspector] _StencilComp("Stencil Comparison", Float) = 8
	//2 ui mask
	//[HideInInspector] _Stencil("Stencil ID", Float) = 0

	_StencilComp("Stencil Comparison", Float) = 8
	_Stencil("Stencil ID", Float) = 0
	_StencilOp("Stencil Operation", Float) = 0
	_StencilWriteMask("Stencil Write Mask", Float) = 255
	_StencilReadMask("Stencil Read Mask", Float) = 255

	_ColorMask("Color Mask", Float) = 15
	[Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip("Use Alpha Clip", Float) = 0
}
	
SubShader {
	Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }

	Stencil
	{
		Ref[_Stencil]
		Comp[_StencilComp]
		Pass[_StencilOp]
		ReadMask[_StencilReadMask]
		WriteMask[_StencilWriteMask]
	}

	ZTest[unity_GUIZTestMode]
	ColorMask[_ColorMask]

	Blend SrcAlpha One
	Cull Off Lighting Off ZWrite Off Fog { Color (0,0,0,0) }
	LOD 100
	
	CGINCLUDE
	#include "UnityCG.cginc"
	#include "UnityUI.cginc"

	#pragma multi_compile __ UNITY_UI_CLIP_RECT
	#pragma multi_compile __ UNITY_UI_ALPHACLIP

	sampler2D _MainTex;
	float4 _MainTex_ST;
	float _ScrollX;
	float _ScrollY;
	float _RotationStart;
	float _RotationX;
	float _RotationY;
	float _Rotation;
	
	sampler2D _DetailTex;
	float4 _DetailTex_ST;
	float _ScrollX2;
	float _ScrollY2;
	float _RotationStart2;
	float _RotationX2;
	float _RotationY2;
	float _Rotation2;
		
	float4 _ClipRect;
	float4 _Color;
	float _MMultiplier;
	
	struct v2f {
		float4 pos : SV_POSITION;
		float4 uv : TEXCOORD0;
		fixed4 color : TEXCOORD1;
		float4 worldPosition : TEXCOORD2;
		UNITY_VERTEX_OUTPUT_STEREO
	};
	
	float2 CalcUV(float2 uv, float tx, float ty, float rstart, float rx, float ry, float r)
	{
		float s = sin(r*_Time+rstart);
		float c = cos(r*_Time+rstart);
		
		float2x2 m = {c, -s, s, c};
		
		uv -= float2(rx, ry);
		uv = mul(uv, m);
		uv += float2(rx, ry);
		
		uv += frac(float2(tx, ty) * _Time);
		
		return uv;
	}
	
	v2f vert (appdata_full v)
	{
		v2f o;
		UNITY_SETUP_INSTANCE_ID(v);
		UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
		o.worldPosition = v.vertex;
		o.pos = UnityObjectToClipPos(v.vertex);
		// base layer
		o.uv.xy = TRANSFORM_TEX(v.texcoord.xy,_MainTex);
		o.uv.xy = CalcUV(o.uv.xy, _ScrollX, _ScrollY, _RotationStart, _RotationX, _RotationY, _Rotation);
		
		// 2nd layer
		o.uv.zw = TRANSFORM_TEX(v.texcoord.xy,_DetailTex);
		o.uv.zw = CalcUV(o.uv.zw, _ScrollX2, _ScrollY2, _RotationStart2, _RotationX2, _RotationY2, _Rotation2);
		
		o.color = _MMultiplier * _Color * v.color;
		
		return o;
	}
	ENDCG


	Pass {
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
//		#pragma fragmentoption ARB_precision_hint_fastest		
		fixed4 frag (v2f i) : COLOR
		{
			half4 color = tex2D(_MainTex, i.uv.xy) * tex2D(_DetailTex, i.uv.zw) * i.color;

			#ifdef UNITY_UI_CLIP_RECT
				color.a *= UnityGet2DClipping(i.worldPosition.xy, _ClipRect);
			#endif
			#ifdef UNITY_UI_ALPHACLIP
				clip(color.a - 0.001);
			#endif
			return color;
		}
		ENDCG 
	}	
}
}

