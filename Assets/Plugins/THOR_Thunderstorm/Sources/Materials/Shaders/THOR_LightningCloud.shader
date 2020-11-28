Shader "THOR_Thunderstorm/THOR_LightningCloud"
{
    Properties 
    {
        [NoScaleOffset]_Alpha ("Alpha", 2D) = "white" {}
        _ColorCore ("Color Core", Color) = (0.07843138,0.3921569,0.7843137,1)
        _ColorGlow ("Color Glow", Color) = (0.5,0.5,0.5,1)
        _Evolution ("Evolution", Range(0, 1)) = 0
        _Multi ("Multi", Float ) = 1
        _Angle ("Angle", Float ) = 0
    }

    SubShader 
    {
        Tags { "IgnoreProjector"="True" "Queue"="Transparent" "RenderType"="Transparent" }
		Blend One One
		ZWrite Off

        Pass 
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

			CBUFFER_START(UnityPerMaterial)
				uniform float4 _ColorCore;
				uniform sampler2D _Alpha;
				uniform float _Evolution;
				uniform float4 _ColorGlow;
				uniform float _Multi;
				uniform float _Angle;
			CBUFFER_END

            struct v2f 
            {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
            };

			v2f vert (float4 vertex : POSITION, float2 texcoord0 : TEXCOORD0)
            {
				v2f o = (v2f)0;
                o.uv0 = texcoord0;
                o.pos = UnityObjectToClipPos(vertex);
                return o;
            }

            float4 frag(v2f i) : COLOR
            {
				float2 sc;
				sincos(_Angle, sc.x, sc.y);
				float2 uv = i.uv0 - 0.5f;
				uv = float2(uv.x * sc.y - uv.y * sc.x, uv.x * sc.x + uv.y * sc.y) + 0.5;
                float alpha = tex2D(_Alpha, uv).a;
				float3 color = (_ColorCore.rgb * alpha + _ColorGlow.rgb * (1.0 - alpha)) * alpha;
                float3 evolution = saturate(_Evolution * 3.333333) * saturate(_Evolution * -2.5 + 2.5);
                return half4(color * evolution * _Multi, 1);
            }
            ENDCG
        }
    }
    FallBack Off
}
