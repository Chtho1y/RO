// Simplified Diffuse shader. Differences from regular Diffuse one:
// - no Main Color
// - fully supports only 1 directional light. Other lights can affect it, but it will be per-vertex/SH.

Shader "RO/RO_Diffuse_DmShadow" {
Properties {
	_MainTex ("Base (RGB)", 2D) = "white" {}
}
SubShader {
	Tags { "RenderType"="Opaque" }
	LOD 150

CGPROGRAM
#pragma surface surf Lambert noforwardadd
//#pragma surface surf myLightModel noforwardadd

sampler2D _MainTex;

struct Input {
	float2 uv_MainTex;
};

// 自定义光照模型
float4 LightingmyLightModel(SurfaceOutput s, float3 lightDir, half3 viewDir, half atten)
{
	float4 c;
	c.rgb = s.Albedo;
	c.a = s.Alpha;
	return c;
}

void surf (Input IN, inout SurfaceOutput o) {
	fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
	o.Albedo = c.rgb;
	o.Alpha = c.a;
}
ENDCG
}

//FallBack "Mobile/VertexLit"
}
