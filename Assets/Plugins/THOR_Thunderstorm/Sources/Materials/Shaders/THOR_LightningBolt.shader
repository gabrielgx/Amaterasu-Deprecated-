Shader "THOR_Thunderstorm/THOR_LightningBolt" 
{
    Properties 
    {
        [NoScaleOffset]_Alpha ("Alpha", 2D) = "white" {}
        _ColorCore ("Color Core", Color) = (1,0.8413793,0.5,1)
        _ColorGlow ("Color Glow", Color) = (0.0172,0.086,0.172,1)
        _Evolution ("Evolution", Range(0, 1)) = 0
        _Multi ("Multi", Float ) = 0
        [Toggle]_EnableDepthBlend ("EnableDepthBlend", Float) = 0
        _DepthBlend ("DepthBlend", Float ) = 1
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
			#include "UnityCG.cginc"

			CBUFFER_START(UnityPerMaterial)
				uniform sampler2D _CameraDepthTexture;
				uniform float4 _ColorGlow;
				uniform sampler2D _Alpha;
				uniform float _Evolution;
				uniform float4 _ColorCore;
				uniform float _Multi;
				uniform float _EnableDepthBlend;
				uniform float _DepthBlend;
			CBUFFER_END

            struct appdata
            {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 projPos : TEXCOORD1;
            };

			v2f vert(appdata v)
            {
				v2f o = (v2f)0;
                o.uv0 = v.texcoord0;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.projPos = ComputeScreenPos(o.pos);
                COMPUTE_EYEDEPTH(o.projPos.z);
                return o;
            }

            float4 frag(v2f i) : COLOR
            {
				float depthBlend = 1;
                if (_EnableDepthBlend >= 0.5)
                {
                    float sceneZ = max(0,LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)))) - _ProjectionParams.g);
                    float partZ = max(0,i.projPos.z - _ProjectionParams.g);
                    depthBlend = saturate((sceneZ - partZ) / _DepthBlend);
					depthBlend *= depthBlend;
                }
                float alpha = tex2D(_Alpha,i.uv0).a;
				alpha *= alpha;
                float  alphaPow = alpha * alpha;

                float3 color = _ColorCore.rgb * depthBlend * alphaPow + (1 - alphaPow) * _ColorGlow.rgb;

                float  evolution = saturate(_Evolution * -1.633333 + 1.653333);
				evolution = evolution * evolution * evolution;

                float evolution2 = 1.0 - saturate(_Evolution * 4.0);

                float uvAnimation = saturate(1 + -(i.uv0.g - evolution2) / ((evolution2 - 0.1) - evolution2));
                uvAnimation *= uvAnimation;

                float3 finalColor = color * clamp(_Evolution * 7.5 + 3.0, 3.0, 10.0) * evolution * alpha * uvAnimation;
                return half4(finalColor * _Multi * depthBlend,1);
            }
            ENDCG
        }
    }
    FallBack Off
}
