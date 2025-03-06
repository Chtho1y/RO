Shader "RO/RO_Particle Alpha Blend_dissolve" {
	Properties {
		_TintColor ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
		_MainTex ("Texture", 2D) = "white" {}
		[Enum(UnityEngine.Rendering.CullMode)] _Cull("Cull Mode", Float) = 0
		[Space]
		[Toggle(MASK)] _MaskOn ("Enable Mask?", float) = 0
		_MaskTex ("Mask (A)", 2D) = "white" {}
		_CutOff ("Alpha CutOff", Range(0,1.0)) = 0.5
		[Space]
		[Toggle(SCROLL)] _ScrollOn ("Enable Scroll?", float) = 0
		[Enum(Manual, 0, AutoMain, 1, AutoMask, 2)] _ScrollType ("Scroll Type", float) = 0
		[Space]
		_UV ("UV Main", vector) = (1,1,0,0)
		_UV2 ("UV Mask", vector) = (1,1,0,0)
		_SpeedU ("Scroll Speed U", float) = 1
		_SpeedV ("Scroll Speed V", float) = 0
	}

Category {
	Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
	Blend SrcAlpha OneMinusSrcAlpha
	ColorMask RGBA
	Cull [_Cull] Lighting Off ZWrite Off
	
	SubShader {
		Pass {
		
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			#pragma shader_feature MASK
			#pragma shader_feature SCROLL

			#include "UnityCG.cginc"

			sampler2D _MainTex;
			fixed4 _TintColor;					
			float4 _MainTex_ST;

			#if MASK

				sampler2D _MaskTex;
				float4 _MaskTex_ST;
				float _CutOff;

				struct appdata_t {
					float4 vertex : POSITION;
					fixed4 color : COLOR;
					float2 texcoord : TEXCOORD0;
					float2 texcoordm : TEXCOORD1;
				};

				struct v2f {
					float4 vertex : SV_POSITION;
					fixed4 color : COLOR;
					float2 texcoord : TEXCOORD0;
					float2 texcoordm : TEXCOORD1;
					UNITY_FOG_COORDS(2)
				};

			#else

				struct appdata_t {
					float4 vertex : POSITION;
					fixed4 color : COLOR;
					float2 texcoord : TEXCOORD0;
				};

				struct v2f {
					float4 vertex : SV_POSITION;
					fixed4 color : COLOR;
					float2 texcoord : TEXCOORD0;
					UNITY_FOG_COORDS(1)
				};

			#endif

			#if SCROLL

				float _ScrollType;
				float4 _UV;
				float4 _UV2;
				float _SpeedU;
				float _SpeedV;

			#endif

			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.color = v.color;
				o.texcoord = TRANSFORM_TEX(v.texcoord,_MainTex);

				#if SCROLL
					float2 tc0 = float2(o.texcoord.x * _UV.x + _UV.z, o.texcoord.y * _UV.y + _UV.w);//: use step : lihouran
					float2 tc1 = o.texcoord + _Time.x * float2(_SpeedU, _SpeedV);
					float f = step(_ScrollType, 0.5);
					o.texcoord = f * tc0 + (1 - f) * tc1;
					/*if (_ScrollType == 0){
						o.texcoord = float2(o.texcoord.x * _UV.x + _UV.z, o.texcoord.y * _UV.y + _UV.w);
					}
					else if (_ScrollType == 1){
						o.texcoord += _Time.x * float2(_SpeedU, _SpeedV);
					}*/

				#endif

				#if MASK

					o.texcoordm = TRANSFORM_TEX(v.texcoordm, _MaskTex);

					#if SCROLL
						float2 tcm0 = float2(o.texcoordm.x * _UV2.x + _UV2.z, o.texcoordm.y * _UV2.y + _UV2.w);//: use step : lihouran
						float2 tcm1 = o.texcoordm + _Time.x * float2(_SpeedU, _SpeedV);
						float fm = step(_ScrollType, 1);
						o.texcoordm = fm * tcm0 + (1 - fm) * tcm1;
						/*if (_ScrollType == 0){
							o.texcoordm = float2(o.texcoordm.x * _UV2.x + _UV2.z, o.texcoordm.y * _UV2.y + _UV2.w);
						}
						else if (_ScrollType == 2){
							o.texcoordm += _Time.x * float2(_SpeedU, _SpeedV);
						}*/

					#endif

				#endif

				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.texcoord) * i.color;

				#if MASK

					col.a *= UNITY_SAMPLE_1CHANNEL(_MaskTex, i.texcoordm);
					clip(col.a - _CutOff);

				#endif

				col *= _TintColor * 1.5;

				UNITY_APPLY_FOG(i.fogCoord, col); // fog towards black due to our blend mode
				return col;
			}
			ENDCG 
		}
	}	
}
}
