Shader "Scene/DefaultShader(MultiLight)" {
	Properties
	{
		_Color("Main Color", Color) = (1,1,1,1)
		_MainTex("Main Texture", 2D) = "white" {}
		_Strength("Strength", Range(0, 2)) = 2
		_ClrStrength("ClrStrength", Range(0, 1.7)) = 1.7
		_ShadowStrength("ShadowStrength", Range(0, 1)) = 0
	}

	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 150

		CGPROGRAM
		#pragma surface surf CustomLight noforwardadd

		sampler2D _MainTex;
		fixed4 _Color;
		fixed _Strength;
		fixed _ClrStrength;
		fixed _ShadowStrength;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color * _ClrStrength;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}

		// 自定义光照模型
		fixed4 LightingCustomLight(SurfaceOutput s, UnityGI gi)
		{
			fixed4 c;
    		c = UnityLambertLight (s, gi.light);
			#ifdef UNITY_LIGHT_FUNCTION_APPLY_INDIRECT
				// 为了让阴影表现明显一些, 使用HSV值的v值来判断阴影部分
				fixed3 col = s.Albedo * gi.indirect.diffuse;
				fixed3 mixCol = s.Albedo + col;
				fixed v = max(max(col.r, col.g), col.b);
				fixed3 shadowCol = lerp(col, mixCol, v);
				c.rgb = lerp(mixCol, shadowCol, _ShadowStrength) + c.rgb;
			#endif
			c.rgb *= _Strength;
			return c;
		}

		half4 LightingCustomLight_Deferred (SurfaceOutput s, UnityGI gi, out half4 outGBuffer0, out half4 outGBuffer1, out half4 outGBuffer2)
		{
    		UnityStandardData data;
			data.diffuseColor   = s.Albedo;
			data.occlusion      = 1;
			data.specularColor  = 0;
			data.smoothness     = 0;
			data.normalWorld    = s.Normal;

			UnityStandardDataToGbuffer(data, outGBuffer0, outGBuffer1, outGBuffer2);

			half4 emission = half4(s.Emission, 1);
			#ifdef UNITY_LIGHT_FUNCTION_APPLY_INDIRECT
				// 为了让阴影表现明显一些, 使用HSV值的v值来判断阴影部分
				fixed3 col = s.Albedo * gi.indirect.diffuse;
				fixed3 mixCol = s.Albedo + col;
				fixed v = max(max(col.r, col.g), col.b);
				fixed3 shadowCol = lerp(col, mixCol, v);
				emission.rgb = lerp(mixCol, shadowCol, _ShadowStrength) + emission.rgb;
				emission.rgb += s.Albedo * gi.indirect.diffuse;
			#endif

			return emission;
		}

		fixed4 LightingCustomLight_PrePass (SurfaceOutput s, half4 light)
		{
			fixed4 c;
			c.rgb = s.Albedo * light.rgb;
			c.a = s.Alpha;
			return c;
		}

		void LightingCustomLight_GI (
			SurfaceOutput s,
			UnityGIInput data,
			inout UnityGI gi)
		{
			gi = UnityGlobalIllumination (data, 1.0, s.Normal);
		}
		ENDCG
	}

	FallBack "Mobile/Diffuse"
}
