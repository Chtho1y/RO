Shader "Scene/Cutout/DefaultShader_createrole" {
	Properties
	{
		_Color("Main Color", Color) = (1,1,1,1)
		_MainTex("Main Texture", 2D) = "white" {}
		_Strength("Strength", Range(0, 2)) = 2
		_ClrStrength("ClrStrength", Range(0, 1.7)) = 1.7
		_ShadowStrength("ShadowStrength", Range(0, 1)) = 0
		_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
	}

	SubShader 
	{
		Tags {"Queue"="AlphaTest" "IgnoreProjector"="True" "RenderType"="TransparentCutout"}
		
		Pass 
		{
        	Tags { "LightMode" = "ForwardBase" }

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			#pragma multi_compile_fwdbase
			#include "HLSLSupport.cginc"
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "AutoLight.cginc"
			
			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed4 _Color;
			fixed _Strength;
			half _ClrStrength;
			half _ShadowStrength;
			fixed _Cutoff;

			struct V2f {
				fixed4 pos : SV_POSITION;
				fixed2 uv0 : TEXCOORD0;
				#ifndef LIGHTMAP_ON
				fixed3 normal : TEXCOORD1;
				#endif
				#ifdef LIGHTMAP_ON
				float2 lmap : TEXCOORD2;
				#endif
				#ifndef LIGHTMAP_ON
				fixed3 vlight : TEXCOORD2;
				#endif
				LIGHTING_COORDS(3,4)
				UNITY_FOG_COORDS(5)
				UNITY_VERTEX_OUTPUT_STEREO
			};
			
			V2f vert(appdata_full v) {
				V2f  o;
				o.uv0 = TRANSFORM_TEX(v.texcoord, _MainTex);
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				fixed3 normalDir = worldNormal;
				o.pos = UnityObjectToClipPos(v.vertex);
				#ifdef LIGHTMAP_ON
				o.lmap.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
				#endif
				#ifndef LIGHTMAP_ON
				o.normal = worldNormal;
				#endif
				#ifndef LIGHTMAP_ON
				fixed3 lightDirection = _WorldSpaceLightPos0.xyz;
				o.vlight = lerp(max(0,dot(lightDirection, normalDir))*_LightColor0,UNITY_LIGHTMODEL_AMBIENT.rgb,0.2 );
				#endif
				TRANSFER_VERTEX_TO_FRAGMENT(o);
				UNITY_TRANSFER_FOG(o,o.pos);
				return o;
			}

			fixed4 frag(V2f i) : SV_Target{
				fixed4 mainTextColor = tex2D(_MainTex, i.uv0) * _Color;
				fixed4 mainColor = mainTextColor * _ClrStrength;
				fixed atten = LIGHT_ATTENUATION(i);
				fixed4 col = 0;
				#ifdef LIGHTMAP_ON
				fixed3 lm = DecodeLightmap (UNITY_SAMPLE_TEX2D(unity_Lightmap, i.lmap.xy));
				#ifdef SHADOWS_SCREENqq
				col.rgb = mainColor.rgb * min(lm, atten*2);
				#else
				col.rgb = mainColor.rgb * lm;
				#endif
				fixed4 mixCol = mainColor + col;
				// 为了让阴影表现明显一些, 使用HSV值的v值来判断阴影部分
				half v = max(max(col.r, col.g), col.b);
				fixed4 shadowCol = lerp(col, mixCol, v);
				col.rgb = lerp(mixCol, shadowCol, _ShadowStrength).rgb;
				#else
				col.rgb = mainColor.rgb * i.vlight * atten;
				col.rgb = mainColor.rgb + col.rgb;
				#endif
				col.rgb = col.rgb * _Strength;
				col.a = mainTextColor.a;
				clip(col.a - _Cutoff);
				UNITY_APPLY_FOG(i.fogCoord, col);
				UNITY_OPAQUE_ALPHA(col.a);
				return col;
			}
			ENDCG
		} //normal pass
	}

	FallBack "Legacy Shaders/Transparent/Cutout/Diffuse"
}
