Shader "iPhone/SimpleTransparent"
{
	Properties
	{
		_MainTex ("MainTex", 2D) = "" {}
		_clrBase ("Color", COLOR) = (1, 1, 1, 1)
	}

	SubShader
	{
		Tags { "Queue" = "Transparent" }

		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha
			
			Color [_clrBase]
			
			Cull Off
			Lighting Off
			SetTexture [_MainTex] { combine texture * primary }
		}
	}
}

