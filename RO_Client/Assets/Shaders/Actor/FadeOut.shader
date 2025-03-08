Shader "Hero/FadeOut" {
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
		_ClrStrength("ClrStrength", Range(0, 1.7)) = 1.7
		_Alpha("Alpha",Range(0, 1)) = 1
		_StatueDegree("StatueDegree", Range(0, 1)) = 0
	}

		SubShader
		{
			Tags {
				"IgnoreProjector" = "True"
				"Queue" = "Transparent"
				"RenderType" = "Transparent"
			}
			Pass
			{
				Name "FORWARD"
				Tags {
					"LightMode" = "ForwardBase"
				}

				Blend SrcAlpha OneMinusSrcAlpha

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
				float _Alpha;
				fixed _StatueDegree;

				struct V2f {
					fixed4 pos : SV_POSITION;
					fixed2 uv0 : TEXCOORD0;
					fixed4 posWorld : TEXCOORD1;
					fixed3 normalDir : TEXCOORD2;
					fixed3 fres : TEXCOORD3;
					fixed3 col : COLOR;
					fixed3  lightProbe : TEXCOORD5;
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
					float sqrRim = sqrt(_Rim_Strength);
					float rsqrRim = (1 - sqrt(sqrRim));
					float ff = saturate(1 - max(0, dot(o.normalDir, viewDirection)));
					o.fres = pow(ff, rsqrRim * 20)* _Rim_Color.rgb;
					o.col = lerp(max(0,dot(lightDirection, o.normalDir))*_LightColor0,UNITY_LIGHTMODEL_AMBIENT.rgb,0.2);
					fixed3 shCol = ShadeSH9(float4(worldNormal,1));
					float f = step(0.001,shCol.r*shCol.g*shCol.b);
					o.lightProbe = fixed3(1, 1, 1);// *(1 - f) + shCol * f;
					return o;
				}

				fixed4 frag(V2f i) : SV_Target
				{
					fixed4 diff = tex2D(_MainTex, i.uv0) * _Color * _ClrStrength;
					fixed4 col = fixed4((diff.rgb * _Muti_Color + diff.rgb * i.col + _Add_Color.rgb + i.fres), _Alpha);
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
		//FallBack "Diffuse"
}
