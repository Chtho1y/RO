// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Hero/Cel Shader" {
	Properties
	{
		_Color("Main Color", Color) = (1,1,1,1)
		_MainTex("Main Texture", 2D) = "white" {}
		_MaskTex("Mask (RGB)", 2D) = "white" {}
		_Strength("Strength", Range(0, 2)) = 2
		_Muti_Color("Muti Color", Color) = (1,1,1,1)
		_Add_Color("Add Color", Color) = (0,0,0,1)
		_Rim_Color("Rim Color", Color) = (1,1,1,1)
		_Rim_Strength("Rim Strength", Range(0, 1)) = 0
		_OutlineColor ("Outline Color", Color) = (0,0,0,1) 
    	_Outline ("Outline width", Range (0, 0.1)) = .01
		_OutlineStrength("OutlineStrength", Range (0, 1)) = .75
		_ClrStrength("ClrStrength", Range(0, 1.7)) = 1.7
		_StatueDegree("StatueDegree", Range(0, 1)) = 0
	}

	SubShader 
	{
		Tags {
			"RenderType" = "Opaque"
		}
		// note that a vertex shader is specified here but its using the one above
		Pass
		{
			Name "OUTLINE"
			Tags{ "LightMode" = "Always" }
			Cull Front
			ZWrite On
			/*ColorMask RGB*/
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			uniform fixed4 _OutlineColor;
			uniform half _Outline;
			half _OutlineStrength;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _MaskTex;

			struct appdata {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 texCoord : TEXCOORD0;
			};

			struct v2f {
				float4 pos : POSITION;
				float4 tex : TEXCOORD0;
			};

			v2f vert(appdata v) {
				// just make a copy of incoming vertex data but scaled according to normal direction
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				float3 norm = mul((float3x3)UNITY_MATRIX_IT_MV, v.normal);
				float2 offset = TransformViewToProjection(norm.xy);
				float4 tex = tex2Dlod(_MaskTex, float4(v.texCoord.xy, 0, 0));
				o.pos.xy += offset * _Outline * 0.5 * tex.g;
				o.tex.xy = TRANSFORM_TEX(v.texCoord, _MainTex);
				return o;
			}

			fixed4 frag(v2f i) :COLOR
			{
				fixed4 cDark = tex2D(_MainTex, i.tex.xy);
				cDark = cDark * _OutlineStrength;// *cDark * cDark;
				cDark.a = 1; // weapon had alpha?
				cDark.rgb = cDark.rgb + _OutlineColor.rgb;
				return cDark;
			}
			ENDCG
		} // outline Pass

		Pass 
		{
			Name "FORWARD"
			Tags {
				"LightMode" = "ForwardBase"
			}

			CGPROGRAM
			#pragma fragmentoption ARB_precision_hint_fastest  
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			#include "UnityCG.cginc"
			#include "AutoLight.cginc"
			
			uniform fixed3 _LightColor0;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed4 _Color;
			fixed _Strength;
			half _ClrStrength;
			fixed4 _Rim_Color;
			fixed4 _Muti_Color;
			fixed4 _Add_Color;
			fixed _Rim_Strength;
			fixed _StatueDegree;

			struct V2f {
				fixed4 pos : SV_POSITION;
				fixed2 uv0 : TEXCOORD0;
				fixed4 posWorld : TEXCOORD1;
				fixed3 normalDir : TEXCOORD2;
				fixed3 fres : TEXCOORD3;
				fixed3 col : COLOR; 
				UNITY_FOG_COORDS(4)
			};
			
			V2f vert(appdata_full v) {
				V2f  o;
				o.uv0 = TRANSFORM_TEX(v.texcoord, _MainTex);
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				o.normalDir = worldNormal;
				o.posWorld = mul(unity_ObjectToWorld, v.vertex);
				o.pos = UnityObjectToClipPos(v.vertex);
				UNITY_TRANSFER_FOG(o,o.pos);
				fixed3 lightDirection = _WorldSpaceLightPos0.xyz;
				fixed3 viewDirection = normalize(_WorldSpaceCameraPos.xyz - o.posWorld.xyz);
				float sqrRim = sqrt (_Rim_Strength);
				float rsqrRim = (1- sqrt(sqrRim));
				float ff = saturate(1 - max(0, dot(o.normalDir, viewDirection)));
				o.fres = pow(ff, rsqrRim *20)* _Rim_Color.rgb;
				o.col =  lerp(max(0,dot(lightDirection, o.normalDir))*_LightColor0,UNITY_LIGHTMODEL_AMBIENT.rgb,0.2 );
				return o;
			}

			fixed4 frag(V2f i) : SV_Target{
				fixed4 diff = tex2D(_MainTex, i.uv0) * _Color * _ClrStrength;

				fixed4 col = fixed4((diff.rgb * _Muti_Color + diff.rgb * i.col + _Add_Color.rgb  + i.fres),1);
				fixed3 lpCol = col.rgb;
				col.rgb = lpCol * _Strength;

				fixed grey = dot(col.rgb, fixed3(0.299, 0.587, 0.114));
				col.rgb = lerp(col.rgb, fixed3(grey, grey, grey), _StatueDegree);

				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		} //normal pass
	}

	////FallBack "Diffuse"
}
