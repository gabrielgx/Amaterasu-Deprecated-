﻿Shader "NatureManufacture/URP/Layered/Full Triplanar"
{
    Properties
    {
        _AlphaCutoff("Alpha Cutoff", Range(0, 1)) = 0
        _BaseColor("Base Color", Color) = (1, 1, 1, 0)
        [NoScaleOffset]_BaseColorMap("Base Map(RGB) Alpha(A)", 2D) = "white" {}
        _BaseTilingOffset("Base Tiling and Offset", Vector) = (1, 1, 0, 0)
        _BaseTriplanarThreshold("Base Triplanar Threshold", Range(1, 8)) = 5
        [NoScaleOffset]_BaseNormalMap("Base Normal Map", 2D) = "bump" {}
        _BaseNormalScale("Base Normal Scale", Range(0, 8)) = 1
        [NoScaleOffset]_BaseMaskMap("Base Mask Map MT(R) AO(G) H(B) SM(A)", 2D) = "white" {}
        _BaseMetallic("Base Metallic", Range(0, 1)) = 1
        _BaseAORemapMin("Base AO Remap Min", Range(0, 1)) = 0
        _BaseAORemapMax("Base AO Remap Max", Range(0, 1)) = 1
        _BaseSmoothnessRemapMin("Base Smoothness Remap Min", Range(0, 1)) = 0
        _BaseSmoothnessRemapMax("Base Smoothness Remap Max", Range(0, 1)) = 1
        [NoScaleOffset]_LayerMask("Layer Mask (R)", 2D) = "black" {}
        [ToggleUI]_Invert_Layer_Mask("Invert Layer Mask", Float) = 0
        _Height_Transition("Height Blend Transition", Range(0.001, 1)) = 1
        _HeightMin("Height Min", Float) = 0
        _HeightMax("Height Max", Float) = 1
        _HeightOffset("Height Offset", Float) = 0
        _HeightMin2("Height 2 Min", Float) = 0
        _HeightMax2("Height 2 Max", Float) = 1
        _HeightOffset2("Height 2 Offset", Float) = 0
        _Base2Color("Base 2 Color", Color) = (1, 1, 1, 0)
        [NoScaleOffset]_Base2ColorMap("Base 2 Map", 2D) = "white" {}
        _Base2TilingOffset("Base 2 Tiling and Offset", Vector) = (1, 1, 0, 0)
        _Base2TriplanarThreshold("Base 2 Triplanar Threshold", Range(1, 8)) = 5
        [NoScaleOffset]_Base2NormalMap("Base 2 Normal Map", 2D) = "bump" {}
        _Base2NormalScale("Base 2 Normal Scale", Range(0, 8)) = 1
        [NoScaleOffset]_Base2MaskMap("Base 2 Mask Map MT(R) AO(G) H(B) SM(A)", 2D) = "white" {}
        _Base2Metallic("Base 2 Metallic", Range(0, 1)) = 1
        _Base2SmoothnessRemapMin("Base 2 Smoothness Remap Min", Range(0, 1)) = 0
        _Base2SmoothnessRemapMax("Base 2 Smoothness Remap Max", Range(0, 1)) = 1
        _Base2AORemapMin("Base 2 AO Remap Min", Range(0, 1)) = 0
        _Base2AORemapMax("Base 2 AO Remap Max", Range(0, 1)) = 1
        _WetColor("Wet Color Vertex(R)", Color) = (0.7735849, 0.7735849, 0.7735849, 0)
        _WetSmoothness("Wet Smoothness Vertex(R)", Range(0, 1)) = 1
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Opaque"
            "Queue"="Geometry+0"
        }
        
        Pass
        {
            Name "Universal Forward"
            Tags 
            { 
                "LightMode" = "UniversalForward"
            }
           
            // Render State
            Blend One Zero, One Zero
            Cull Back
            ZTest LEqual
            ZWrite On
            // ColorMask: <None>
            
        
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            // Pragmas
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            #pragma target 2.0
            #pragma multi_compile_fog
            #pragma multi_compile_instancing
        
            // Keywords
            #pragma multi_compile _ LIGHTMAP_ON
            #pragma multi_compile _ DIRLIGHTMAP_COMBINED
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
            #pragma multi_compile _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS _ADDITIONAL_OFF
            #pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
            #pragma multi_compile _ _SHADOWS_SOFT
            #pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
            // GraphKeywords: <None>
            
            // Defines
            #define _AlphaClip 1
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define ATTRIBUTES_NEED_COLOR
            #define VARYINGS_NEED_POSITION_WS 
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_TANGENT_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_COLOR
            #define VARYINGS_NEED_VIEWDIRECTION_WS
            #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
            #define FEATURES_GRAPH_VERTEX
            #pragma multi_compile_instancing
            #define UNITY_DOTS_SHADER
            #pragma instancing_options nolightprobe
            #pragma instancing_options nolodfade
            #define SHADERPASS_FORWARD
            
        
            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariablesFunctions.hlsl"
        
            // --------------------------------------------------
            // Graph
        
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
            float _AlphaCutoff;
            float4 _BaseColor;
            float4 _BaseTilingOffset;
            float _BaseTriplanarThreshold;
            float _BaseNormalScale;
            float _BaseMetallic;
            float _BaseAORemapMin;
            float _BaseAORemapMax;
            float _BaseSmoothnessRemapMin;
            float _BaseSmoothnessRemapMax;
            float _Invert_Layer_Mask;
            float _Height_Transition;
            float _HeightMin;
            float _HeightMax;
            float _HeightOffset;
            float _HeightMin2;
            float _HeightMax2;
            float _HeightOffset2;
            float4 _Base2Color;
            float4 _Base2TilingOffset;
            float _Base2TriplanarThreshold;
            float _Base2NormalScale;
            float _Base2Metallic;
            float _Base2SmoothnessRemapMin;
            float _Base2SmoothnessRemapMax;
            float _Base2AORemapMin;
            float _Base2AORemapMax;
            float4 _WetColor;
            float _WetSmoothness;
            CBUFFER_END
            TEXTURE2D(_BaseColorMap); SAMPLER(sampler_BaseColorMap); float4 _BaseColorMap_TexelSize;
            TEXTURE2D(_BaseNormalMap); SAMPLER(sampler_BaseNormalMap); float4 _BaseNormalMap_TexelSize;
            TEXTURE2D(_BaseMaskMap); SAMPLER(sampler_BaseMaskMap); float4 _BaseMaskMap_TexelSize;
            TEXTURE2D(_LayerMask); SAMPLER(sampler_LayerMask); float4 _LayerMask_TexelSize;
            TEXTURE2D(_Base2ColorMap); SAMPLER(sampler_Base2ColorMap); float4 _Base2ColorMap_TexelSize;
            TEXTURE2D(_Base2NormalMap); SAMPLER(sampler_Base2NormalMap); float4 _Base2NormalMap_TexelSize;
            TEXTURE2D(_Base2MaskMap); SAMPLER(sampler_Base2MaskMap); float4 _Base2MaskMap_TexelSize;
            SAMPLER(_SampleTexture2D_AF934D9A_Sampler_3_Linear_Repeat);
            SAMPLER(_SampleTexture2D_66E4959F_Sampler_3_Linear_Repeat);
            SAMPLER(_SampleTexture2D_96366F41_Sampler_3_Linear_Repeat);
            SAMPLER(_SampleTexture2D_6C16A06F_Sampler_3_Linear_Repeat);
        
            // Graph Functions
            
            // 0ff7b9db8f55df06fc08dc990cfb397e
            #include "Assets/NatureManufacture Assets/Object Shaders/NM_Object_VSPro_Indirect.cginc"
            
            void AddPragma_float(float3 A, out float3 Out)
            {
                #pragma instancing_options renderinglayer procedural:setupVSPro
                Out = A;
            }
            
            struct Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b
            {
            };
            
            void SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b(float3 Vector3_314C8600, Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b IN, out float3 ObjectSpacePosition_1)
            {
                float3 _Property_AF5E8C93_Out_0 = Vector3_314C8600;
                float3 _CustomFunction_E07FEE57_Out_1;
                InjectSetup_float(_Property_AF5E8C93_Out_0, _CustomFunction_E07FEE57_Out_1);
                float3 _CustomFunction_18EFD858_Out_1;
                AddPragma_float(_CustomFunction_E07FEE57_Out_1, _CustomFunction_18EFD858_Out_1);
                ObjectSpacePosition_1 = _CustomFunction_18EFD858_Out_1;
            }
            
            void Unity_Divide_float4(float4 A, float4 B, out float4 Out)
            {
                Out = A / B;
            }
            
            void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
            {
                RGBA = float4(R, G, B, A);
                RGB = float3(R, G, B);
                RG = float2(R, G);
            }
            
            void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
            {
                Out = A * B;
            }
            
            void Unity_Sign_float3(float3 In, out float3 Out)
            {
                Out = sign(In);
            }
            
            void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
            {
                Out = A * B;
            }
            
            void Unity_Absolute_float3(float3 In, out float3 Out)
            {
                Out = abs(In);
            }
            
            void Unity_Power_float3(float3 A, float3 B, out float3 Out)
            {
                Out = pow(A, B);
            }
            
            void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
            {
                Out = A * B;
            }
            
            void Unity_Multiply_float(float A, float B, out float Out)
            {
                Out = A * B;
            }
            
            void Unity_Add_float4(float4 A, float4 B, out float4 Out)
            {
                Out = A + B;
            }
            
            void Unity_Add_float(float A, float B, out float Out)
            {
                Out = A + B;
            }
            
            struct Bindings_TriplanarNM_bc609ed95f52591469ab35dbfe0efcea
            {
                float3 WorldSpaceNormal;
                float3 AbsoluteWorldSpacePosition;
            };
            
            void SG_TriplanarNM_bc609ed95f52591469ab35dbfe0efcea(TEXTURE2D_PARAM(Texture2D_80A3D28F, samplerTexture2D_80A3D28F), float4 Texture2D_80A3D28F_TexelSize, float Vector1_41461AC9, float Vector1_E4D1C13A, Bindings_TriplanarNM_bc609ed95f52591469ab35dbfe0efcea IN, out float4 XYZ_1, out float4 XZ_2, out float4 YZ_3, out float4 XY_4)
            {
                float _Split_34F118DC_R_1 = IN.AbsoluteWorldSpacePosition[0];
                float _Split_34F118DC_G_2 = IN.AbsoluteWorldSpacePosition[1];
                float _Split_34F118DC_B_3 = IN.AbsoluteWorldSpacePosition[2];
                float _Split_34F118DC_A_4 = 0;
                float4 _Combine_FDBD63CA_RGBA_4;
                float3 _Combine_FDBD63CA_RGB_5;
                float2 _Combine_FDBD63CA_RG_6;
                Unity_Combine_float(_Split_34F118DC_R_1, _Split_34F118DC_B_3, 0, 0, _Combine_FDBD63CA_RGBA_4, _Combine_FDBD63CA_RGB_5, _Combine_FDBD63CA_RG_6);
                float _Property_7A4DC59B_Out_0 = Vector1_41461AC9;
                float4 _Multiply_D99671F1_Out_2;
                Unity_Multiply_float(_Combine_FDBD63CA_RGBA_4, (_Property_7A4DC59B_Out_0.xxxx), _Multiply_D99671F1_Out_2);
                float3 _Sign_C0850857_Out_1;
                Unity_Sign_float3(IN.WorldSpaceNormal, _Sign_C0850857_Out_1);
                float _Split_EEBC69B5_R_1 = _Sign_C0850857_Out_1[0];
                float _Split_EEBC69B5_G_2 = _Sign_C0850857_Out_1[1];
                float _Split_EEBC69B5_B_3 = _Sign_C0850857_Out_1[2];
                float _Split_EEBC69B5_A_4 = 0;
                float2 _Vector2_7598EA98_Out_0 = float2(_Split_EEBC69B5_G_2, 1);
                float2 _Multiply_F82F3FE2_Out_2;
                Unity_Multiply_float((_Multiply_D99671F1_Out_2.xy), _Vector2_7598EA98_Out_0, _Multiply_F82F3FE2_Out_2);
                float4 _SampleTexture2D_AF934D9A_RGBA_0 = SAMPLE_TEXTURE2D(Texture2D_80A3D28F, samplerTexture2D_80A3D28F, _Multiply_F82F3FE2_Out_2);
                float _SampleTexture2D_AF934D9A_R_4 = _SampleTexture2D_AF934D9A_RGBA_0.r;
                float _SampleTexture2D_AF934D9A_G_5 = _SampleTexture2D_AF934D9A_RGBA_0.g;
                float _SampleTexture2D_AF934D9A_B_6 = _SampleTexture2D_AF934D9A_RGBA_0.b;
                float _SampleTexture2D_AF934D9A_A_7 = _SampleTexture2D_AF934D9A_RGBA_0.a;
                float3 _Absolute_FF95EDEB_Out_1;
                Unity_Absolute_float3(IN.WorldSpaceNormal, _Absolute_FF95EDEB_Out_1);
                float _Property_F8688E0_Out_0 = Vector1_E4D1C13A;
                float3 _Power_C741CD3A_Out_2;
                Unity_Power_float3(_Absolute_FF95EDEB_Out_1, (_Property_F8688E0_Out_0.xxx), _Power_C741CD3A_Out_2);
                float3 _Multiply_3FB4A346_Out_2;
                Unity_Multiply_float(_Power_C741CD3A_Out_2, _Power_C741CD3A_Out_2, _Multiply_3FB4A346_Out_2);
                float _Split_98088E33_R_1 = _Multiply_3FB4A346_Out_2[0];
                float _Split_98088E33_G_2 = _Multiply_3FB4A346_Out_2[1];
                float _Split_98088E33_B_3 = _Multiply_3FB4A346_Out_2[2];
                float _Split_98088E33_A_4 = 0;
                float4 _Multiply_B99FFB12_Out_2;
                Unity_Multiply_float(_SampleTexture2D_AF934D9A_RGBA_0, (_Split_98088E33_G_2.xxxx), _Multiply_B99FFB12_Out_2);
                float4 _Combine_EAF808EA_RGBA_4;
                float3 _Combine_EAF808EA_RGB_5;
                float2 _Combine_EAF808EA_RG_6;
                Unity_Combine_float(_Split_34F118DC_R_1, _Split_34F118DC_G_2, 0, 0, _Combine_EAF808EA_RGBA_4, _Combine_EAF808EA_RGB_5, _Combine_EAF808EA_RG_6);
                float4 _Multiply_9B855117_Out_2;
                Unity_Multiply_float(_Combine_EAF808EA_RGBA_4, (_Property_7A4DC59B_Out_0.xxxx), _Multiply_9B855117_Out_2);
                float _Multiply_B8AC16FB_Out_2;
                Unity_Multiply_float(_Split_EEBC69B5_B_3, -1, _Multiply_B8AC16FB_Out_2);
                float2 _Vector2_F031282A_Out_0 = float2(_Multiply_B8AC16FB_Out_2, 1);
                float2 _Multiply_89A39D70_Out_2;
                Unity_Multiply_float((_Multiply_9B855117_Out_2.xy), _Vector2_F031282A_Out_0, _Multiply_89A39D70_Out_2);
                float4 _SampleTexture2D_66E4959F_RGBA_0 = SAMPLE_TEXTURE2D(Texture2D_80A3D28F, samplerTexture2D_80A3D28F, _Multiply_89A39D70_Out_2);
                float _SampleTexture2D_66E4959F_R_4 = _SampleTexture2D_66E4959F_RGBA_0.r;
                float _SampleTexture2D_66E4959F_G_5 = _SampleTexture2D_66E4959F_RGBA_0.g;
                float _SampleTexture2D_66E4959F_B_6 = _SampleTexture2D_66E4959F_RGBA_0.b;
                float _SampleTexture2D_66E4959F_A_7 = _SampleTexture2D_66E4959F_RGBA_0.a;
                float4 _Multiply_9E620CB9_Out_2;
                Unity_Multiply_float(_SampleTexture2D_66E4959F_RGBA_0, (_Split_98088E33_B_3.xxxx), _Multiply_9E620CB9_Out_2);
                float4 _Combine_D494A8E_RGBA_4;
                float3 _Combine_D494A8E_RGB_5;
                float2 _Combine_D494A8E_RG_6;
                Unity_Combine_float(_Split_34F118DC_B_3, _Split_34F118DC_G_2, 0, 0, _Combine_D494A8E_RGBA_4, _Combine_D494A8E_RGB_5, _Combine_D494A8E_RG_6);
                float4 _Multiply_1B29A9F1_Out_2;
                Unity_Multiply_float(_Combine_D494A8E_RGBA_4, (_Property_7A4DC59B_Out_0.xxxx), _Multiply_1B29A9F1_Out_2);
                float2 _Vector2_1F147BEC_Out_0 = float2(_Split_EEBC69B5_R_1, 1);
                float2 _Multiply_5B8B54E9_Out_2;
                Unity_Multiply_float((_Multiply_1B29A9F1_Out_2.xy), _Vector2_1F147BEC_Out_0, _Multiply_5B8B54E9_Out_2);
                float4 _SampleTexture2D_96366F41_RGBA_0 = SAMPLE_TEXTURE2D(Texture2D_80A3D28F, samplerTexture2D_80A3D28F, _Multiply_5B8B54E9_Out_2);
                float _SampleTexture2D_96366F41_R_4 = _SampleTexture2D_96366F41_RGBA_0.r;
                float _SampleTexture2D_96366F41_G_5 = _SampleTexture2D_96366F41_RGBA_0.g;
                float _SampleTexture2D_96366F41_B_6 = _SampleTexture2D_96366F41_RGBA_0.b;
                float _SampleTexture2D_96366F41_A_7 = _SampleTexture2D_96366F41_RGBA_0.a;
                float4 _Multiply_1C5CFCC5_Out_2;
                Unity_Multiply_float(_SampleTexture2D_96366F41_RGBA_0, (_Split_98088E33_R_1.xxxx), _Multiply_1C5CFCC5_Out_2);
                float4 _Add_D483B2FD_Out_2;
                Unity_Add_float4(_Multiply_9E620CB9_Out_2, _Multiply_1C5CFCC5_Out_2, _Add_D483B2FD_Out_2);
                float4 _Add_166B5BED_Out_2;
                Unity_Add_float4(_Multiply_B99FFB12_Out_2, _Add_D483B2FD_Out_2, _Add_166B5BED_Out_2);
                float _Add_B73B64F6_Out_2;
                Unity_Add_float(_Split_98088E33_R_1, _Split_98088E33_G_2, _Add_B73B64F6_Out_2);
                float _Add_523B36E8_Out_2;
                Unity_Add_float(_Add_B73B64F6_Out_2, _Split_98088E33_B_3, _Add_523B36E8_Out_2);
                float4 _Divide_86C67C72_Out_2;
                Unity_Divide_float4(_Add_166B5BED_Out_2, (_Add_523B36E8_Out_2.xxxx), _Divide_86C67C72_Out_2);
                XYZ_1 = _Divide_86C67C72_Out_2;
                XZ_2 = _SampleTexture2D_AF934D9A_RGBA_0;
                YZ_3 = _SampleTexture2D_66E4959F_RGBA_0;
                XY_4 = _SampleTexture2D_96366F41_RGBA_0;
            }
            
            void Unity_Add_float2(float2 A, float2 B, out float2 Out)
            {
                Out = A + B;
            }
            
            void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
            {
                Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
            }
            
            void Unity_OneMinus_float(float In, out float Out)
            {
                Out = 1 - In;
            }
            
            void Unity_Branch_float(float Predicate, float True, float False, out float Out)
            {
                Out = Predicate ? True : False;
            }
            
            void Unity_Maximum_float(float A, float B, out float Out)
            {
                Out = max(A, B);
            }
            
            void Unity_Subtract_float(float A, float B, out float Out)
            {
                Out = A - B;
            }
            
            void Unity_Add_float3(float3 A, float3 B, out float3 Out)
            {
                Out = A + B;
            }
            
            void Unity_Divide_float3(float3 A, float3 B, out float3 Out)
            {
                Out = A / B;
            }
            
            struct Bindings_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135
            {
            };
            
            void SG_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135(float3 Vector3_88EEBB5E, float Vector1_DA0A37FA, float3 Vector3_79AA92F, float Vector1_F7E83F1E, float Vector1_1C9222A6, Bindings_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135 IN, out float3 OutVector4_1)
            {
                float3 _Property_CE7501EE_Out_0 = Vector3_88EEBB5E;
                float _Property_21A77CD2_Out_0 = Vector1_DA0A37FA;
                float _Property_B0F6C734_Out_0 = Vector1_DA0A37FA;
                float _Property_F32C0509_Out_0 = Vector1_F7E83F1E;
                float _Maximum_2C42CE33_Out_2;
                Unity_Maximum_float(_Property_B0F6C734_Out_0, _Property_F32C0509_Out_0, _Maximum_2C42CE33_Out_2);
                float _Property_FBC3A76E_Out_0 = Vector1_1C9222A6;
                float _Subtract_5E32B1F2_Out_2;
                Unity_Subtract_float(_Maximum_2C42CE33_Out_2, _Property_FBC3A76E_Out_0, _Subtract_5E32B1F2_Out_2);
                float _Subtract_AE0D0FB3_Out_2;
                Unity_Subtract_float(_Property_21A77CD2_Out_0, _Subtract_5E32B1F2_Out_2, _Subtract_AE0D0FB3_Out_2);
                float _Maximum_B94A8EBA_Out_2;
                Unity_Maximum_float(_Subtract_AE0D0FB3_Out_2, 0, _Maximum_B94A8EBA_Out_2);
                float3 _Multiply_6D1F195B_Out_2;
                Unity_Multiply_float(_Property_CE7501EE_Out_0, (_Maximum_B94A8EBA_Out_2.xxx), _Multiply_6D1F195B_Out_2);
                float3 _Property_94C053EA_Out_0 = Vector3_79AA92F;
                float _Property_B5C791CC_Out_0 = Vector1_F7E83F1E;
                float _Subtract_5DDA2278_Out_2;
                Unity_Subtract_float(_Property_B5C791CC_Out_0, _Subtract_5E32B1F2_Out_2, _Subtract_5DDA2278_Out_2);
                float _Maximum_3087B5D0_Out_2;
                Unity_Maximum_float(_Subtract_5DDA2278_Out_2, 0, _Maximum_3087B5D0_Out_2);
                float3 _Multiply_61466A85_Out_2;
                Unity_Multiply_float(_Property_94C053EA_Out_0, (_Maximum_3087B5D0_Out_2.xxx), _Multiply_61466A85_Out_2);
                float3 _Add_87880A51_Out_2;
                Unity_Add_float3(_Multiply_6D1F195B_Out_2, _Multiply_61466A85_Out_2, _Add_87880A51_Out_2);
                float _Add_43856DBF_Out_2;
                Unity_Add_float(_Maximum_B94A8EBA_Out_2, _Maximum_3087B5D0_Out_2, _Add_43856DBF_Out_2);
                float _Maximum_47B2BE36_Out_2;
                Unity_Maximum_float(_Add_43856DBF_Out_2, 1E-05, _Maximum_47B2BE36_Out_2);
                float3 _Divide_593AB2EB_Out_2;
                Unity_Divide_float3(_Add_87880A51_Out_2, (_Maximum_47B2BE36_Out_2.xxx), _Divide_593AB2EB_Out_2);
                OutVector4_1 = _Divide_593AB2EB_Out_2;
            }
            
            void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
            {
                Out = lerp(A, B, T);
            }
            
            void Unity_Normalize_float3(float3 In, out float3 Out)
            {
                Out = normalize(In);
            }
            
            struct Bindings_TriplanarNMn_059da9746584140498cd018db3c76047
            {
                float3 WorldSpaceNormal;
                float3 WorldSpaceTangent;
                float3 WorldSpaceBiTangent;
                float3 WorldSpacePosition;
            };
            
            void SG_TriplanarNMn_059da9746584140498cd018db3c76047(TEXTURE2D_PARAM(Texture2D_80A3D28F, samplerTexture2D_80A3D28F), float4 Texture2D_80A3D28F_TexelSize, float Vector1_41461AC9, float Vector1_E4D1C13A, Bindings_TriplanarNMn_059da9746584140498cd018db3c76047 IN, out float4 XYZ_1, out float4 XZ_2, out float4 YZ_3, out float4 XY_4)
            {
                float _Split_34F118DC_R_1 = IN.WorldSpacePosition[0];
                float _Split_34F118DC_G_2 = IN.WorldSpacePosition[1];
                float _Split_34F118DC_B_3 = IN.WorldSpacePosition[2];
                float _Split_34F118DC_A_4 = 0;
                float4 _Combine_FDBD63CA_RGBA_4;
                float3 _Combine_FDBD63CA_RGB_5;
                float2 _Combine_FDBD63CA_RG_6;
                Unity_Combine_float(_Split_34F118DC_R_1, _Split_34F118DC_B_3, 0, 0, _Combine_FDBD63CA_RGBA_4, _Combine_FDBD63CA_RGB_5, _Combine_FDBD63CA_RG_6);
                float _Property_7A4DC59B_Out_0 = Vector1_41461AC9;
                float4 _Multiply_D99671F1_Out_2;
                Unity_Multiply_float(_Combine_FDBD63CA_RGBA_4, (_Property_7A4DC59B_Out_0.xxxx), _Multiply_D99671F1_Out_2);
                float3 _Sign_937BD7C4_Out_1;
                Unity_Sign_float3(IN.WorldSpaceNormal, _Sign_937BD7C4_Out_1);
                float _Split_A88C5CBA_R_1 = _Sign_937BD7C4_Out_1[0];
                float _Split_A88C5CBA_G_2 = _Sign_937BD7C4_Out_1[1];
                float _Split_A88C5CBA_B_3 = _Sign_937BD7C4_Out_1[2];
                float _Split_A88C5CBA_A_4 = 0;
                float2 _Vector2_DC7A07A_Out_0 = float2(_Split_A88C5CBA_G_2, 1);
                float2 _Multiply_6E58BF97_Out_2;
                Unity_Multiply_float((_Multiply_D99671F1_Out_2.xy), _Vector2_DC7A07A_Out_0, _Multiply_6E58BF97_Out_2);
                float4 _SampleTexture2D_AF934D9A_RGBA_0 = SAMPLE_TEXTURE2D(Texture2D_80A3D28F, samplerTexture2D_80A3D28F, _Multiply_6E58BF97_Out_2);
                _SampleTexture2D_AF934D9A_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_AF934D9A_RGBA_0);
                float _SampleTexture2D_AF934D9A_R_4 = _SampleTexture2D_AF934D9A_RGBA_0.r;
                float _SampleTexture2D_AF934D9A_G_5 = _SampleTexture2D_AF934D9A_RGBA_0.g;
                float _SampleTexture2D_AF934D9A_B_6 = _SampleTexture2D_AF934D9A_RGBA_0.b;
                float _SampleTexture2D_AF934D9A_A_7 = _SampleTexture2D_AF934D9A_RGBA_0.a;
                float2 _Vector2_699A5DA1_Out_0 = float2(_SampleTexture2D_AF934D9A_R_4, _SampleTexture2D_AF934D9A_G_5);
                float2 _Multiply_5A3A785C_Out_2;
                Unity_Multiply_float(_Vector2_699A5DA1_Out_0, _Vector2_DC7A07A_Out_0, _Multiply_5A3A785C_Out_2);
                float _Split_CE0AB7C6_R_1 = IN.WorldSpaceNormal[0];
                float _Split_CE0AB7C6_G_2 = IN.WorldSpaceNormal[1];
                float _Split_CE0AB7C6_B_3 = IN.WorldSpaceNormal[2];
                float _Split_CE0AB7C6_A_4 = 0;
                float2 _Vector2_D40FA1D3_Out_0 = float2(_Split_CE0AB7C6_R_1, _Split_CE0AB7C6_B_3);
                float2 _Add_E4BBD98D_Out_2;
                Unity_Add_float2(_Multiply_5A3A785C_Out_2, _Vector2_D40FA1D3_Out_0, _Add_E4BBD98D_Out_2);
                float _Split_1D7F6EE9_R_1 = _Add_E4BBD98D_Out_2[0];
                float _Split_1D7F6EE9_G_2 = _Add_E4BBD98D_Out_2[1];
                float _Split_1D7F6EE9_B_3 = 0;
                float _Split_1D7F6EE9_A_4 = 0;
                float _Multiply_97283B7E_Out_2;
                Unity_Multiply_float(_SampleTexture2D_AF934D9A_B_6, _Split_CE0AB7C6_G_2, _Multiply_97283B7E_Out_2);
                float3 _Vector3_A5ECB01F_Out_0 = float3(_Split_1D7F6EE9_R_1, _Multiply_97283B7E_Out_2, _Split_1D7F6EE9_G_2);
                float3 _Absolute_FF95EDEB_Out_1;
                Unity_Absolute_float3(IN.WorldSpaceNormal, _Absolute_FF95EDEB_Out_1);
                float _Property_F8688E0_Out_0 = Vector1_E4D1C13A;
                float3 _Power_C741CD3A_Out_2;
                Unity_Power_float3(_Absolute_FF95EDEB_Out_1, (_Property_F8688E0_Out_0.xxx), _Power_C741CD3A_Out_2);
                float3 _Multiply_3FB4A346_Out_2;
                Unity_Multiply_float(_Power_C741CD3A_Out_2, _Power_C741CD3A_Out_2, _Multiply_3FB4A346_Out_2);
                float _Split_98088E33_R_1 = _Multiply_3FB4A346_Out_2[0];
                float _Split_98088E33_G_2 = _Multiply_3FB4A346_Out_2[1];
                float _Split_98088E33_B_3 = _Multiply_3FB4A346_Out_2[2];
                float _Split_98088E33_A_4 = 0;
                float3 _Multiply_B99FFB12_Out_2;
                Unity_Multiply_float(_Vector3_A5ECB01F_Out_0, (_Split_98088E33_G_2.xxx), _Multiply_B99FFB12_Out_2);
                float4 _Combine_EAF808EA_RGBA_4;
                float3 _Combine_EAF808EA_RGB_5;
                float2 _Combine_EAF808EA_RG_6;
                Unity_Combine_float(_Split_34F118DC_R_1, _Split_34F118DC_G_2, 0, 0, _Combine_EAF808EA_RGBA_4, _Combine_EAF808EA_RGB_5, _Combine_EAF808EA_RG_6);
                float4 _Multiply_9B855117_Out_2;
                Unity_Multiply_float(_Combine_EAF808EA_RGBA_4, (_Property_7A4DC59B_Out_0.xxxx), _Multiply_9B855117_Out_2);
                float _Multiply_9028821C_Out_2;
                Unity_Multiply_float(_Split_A88C5CBA_B_3, -1, _Multiply_9028821C_Out_2);
                float2 _Vector2_34183E31_Out_0 = float2(_Multiply_9028821C_Out_2, 1);
                float2 _Multiply_25D3DEE7_Out_2;
                Unity_Multiply_float((_Multiply_9B855117_Out_2.xy), _Vector2_34183E31_Out_0, _Multiply_25D3DEE7_Out_2);
                float4 _SampleTexture2D_66E4959F_RGBA_0 = SAMPLE_TEXTURE2D(Texture2D_80A3D28F, samplerTexture2D_80A3D28F, _Multiply_25D3DEE7_Out_2);
                _SampleTexture2D_66E4959F_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_66E4959F_RGBA_0);
                float _SampleTexture2D_66E4959F_R_4 = _SampleTexture2D_66E4959F_RGBA_0.r;
                float _SampleTexture2D_66E4959F_G_5 = _SampleTexture2D_66E4959F_RGBA_0.g;
                float _SampleTexture2D_66E4959F_B_6 = _SampleTexture2D_66E4959F_RGBA_0.b;
                float _SampleTexture2D_66E4959F_A_7 = _SampleTexture2D_66E4959F_RGBA_0.a;
                float2 _Vector2_6CC92971_Out_0 = float2(_SampleTexture2D_66E4959F_R_4, _SampleTexture2D_66E4959F_G_5);
                float2 _Multiply_EDE2F02C_Out_2;
                Unity_Multiply_float(_Vector2_6CC92971_Out_0, _Vector2_34183E31_Out_0, _Multiply_EDE2F02C_Out_2);
                float2 _Vector2_6D428360_Out_0 = float2(_Split_CE0AB7C6_R_1, _Split_CE0AB7C6_G_2);
                float2 _Add_6D3412BD_Out_2;
                Unity_Add_float2(_Multiply_EDE2F02C_Out_2, _Vector2_6D428360_Out_0, _Add_6D3412BD_Out_2);
                float _Split_79C8538A_R_1 = _Add_6D3412BD_Out_2[0];
                float _Split_79C8538A_G_2 = _Add_6D3412BD_Out_2[1];
                float _Split_79C8538A_B_3 = 0;
                float _Split_79C8538A_A_4 = 0;
                float _Multiply_576DD59F_Out_2;
                Unity_Multiply_float(_SampleTexture2D_66E4959F_B_6, _Split_CE0AB7C6_B_3, _Multiply_576DD59F_Out_2);
                float3 _Vector3_77AAFCD8_Out_0 = float3(_Split_79C8538A_R_1, _Split_79C8538A_G_2, _Multiply_576DD59F_Out_2);
                float3 _Multiply_9E620CB9_Out_2;
                Unity_Multiply_float(_Vector3_77AAFCD8_Out_0, (_Split_98088E33_B_3.xxx), _Multiply_9E620CB9_Out_2);
                float4 _Combine_D494A8E_RGBA_4;
                float3 _Combine_D494A8E_RGB_5;
                float2 _Combine_D494A8E_RG_6;
                Unity_Combine_float(_Split_34F118DC_B_3, _Split_34F118DC_G_2, 0, 0, _Combine_D494A8E_RGBA_4, _Combine_D494A8E_RGB_5, _Combine_D494A8E_RG_6);
                float4 _Multiply_1B29A9F1_Out_2;
                Unity_Multiply_float(_Combine_D494A8E_RGBA_4, (_Property_7A4DC59B_Out_0.xxxx), _Multiply_1B29A9F1_Out_2);
                float2 _Vector2_2EDA3EA2_Out_0 = float2(_Split_A88C5CBA_R_1, 1);
                float2 _Multiply_4083C468_Out_2;
                Unity_Multiply_float((_Multiply_1B29A9F1_Out_2.xy), _Vector2_2EDA3EA2_Out_0, _Multiply_4083C468_Out_2);
                float4 _SampleTexture2D_96366F41_RGBA_0 = SAMPLE_TEXTURE2D(Texture2D_80A3D28F, samplerTexture2D_80A3D28F, _Multiply_4083C468_Out_2);
                _SampleTexture2D_96366F41_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_96366F41_RGBA_0);
                float _SampleTexture2D_96366F41_R_4 = _SampleTexture2D_96366F41_RGBA_0.r;
                float _SampleTexture2D_96366F41_G_5 = _SampleTexture2D_96366F41_RGBA_0.g;
                float _SampleTexture2D_96366F41_B_6 = _SampleTexture2D_96366F41_RGBA_0.b;
                float _SampleTexture2D_96366F41_A_7 = _SampleTexture2D_96366F41_RGBA_0.a;
                float _Multiply_D70B5F94_Out_2;
                Unity_Multiply_float(_SampleTexture2D_96366F41_B_6, _Split_CE0AB7C6_R_1, _Multiply_D70B5F94_Out_2);
                float2 _Vector2_D6F48DBF_Out_0 = float2(_SampleTexture2D_96366F41_R_4, _SampleTexture2D_96366F41_G_5);
                float2 _Multiply_32364D17_Out_2;
                Unity_Multiply_float(_Vector2_D6F48DBF_Out_0, _Vector2_2EDA3EA2_Out_0, _Multiply_32364D17_Out_2);
                float2 _Vector2_5861421E_Out_0 = float2(_Split_CE0AB7C6_B_3, _Split_CE0AB7C6_G_2);
                float2 _Add_15B5B6DC_Out_2;
                Unity_Add_float2(_Multiply_32364D17_Out_2, _Vector2_5861421E_Out_0, _Add_15B5B6DC_Out_2);
                float _Split_68B7323B_R_1 = _Add_15B5B6DC_Out_2[0];
                float _Split_68B7323B_G_2 = _Add_15B5B6DC_Out_2[1];
                float _Split_68B7323B_B_3 = 0;
                float _Split_68B7323B_A_4 = 0;
                float3 _Vector3_1ACBBFC4_Out_0 = float3(_Multiply_D70B5F94_Out_2, _Split_68B7323B_G_2, _Split_68B7323B_R_1);
                float3 _Multiply_1C5CFCC5_Out_2;
                Unity_Multiply_float(_Vector3_1ACBBFC4_Out_0, (_Split_98088E33_R_1.xxx), _Multiply_1C5CFCC5_Out_2);
                float3 _Add_D483B2FD_Out_2;
                Unity_Add_float3(_Multiply_9E620CB9_Out_2, _Multiply_1C5CFCC5_Out_2, _Add_D483B2FD_Out_2);
                float3 _Add_166B5BED_Out_2;
                Unity_Add_float3(_Multiply_B99FFB12_Out_2, _Add_D483B2FD_Out_2, _Add_166B5BED_Out_2);
                float _Add_B73B64F6_Out_2;
                Unity_Add_float(_Split_98088E33_R_1, _Split_98088E33_G_2, _Add_B73B64F6_Out_2);
                float _Add_523B36E8_Out_2;
                Unity_Add_float(_Add_B73B64F6_Out_2, _Split_98088E33_B_3, _Add_523B36E8_Out_2);
                float3 _Divide_86C67C72_Out_2;
                Unity_Divide_float3(_Add_166B5BED_Out_2, (_Add_523B36E8_Out_2.xxx), _Divide_86C67C72_Out_2);
                float3x3 Transform_F679F94B_tangentTransform_World = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
                float3 _Transform_F679F94B_Out_1 = TransformWorldToTangent(_Divide_86C67C72_Out_2.xyz, Transform_F679F94B_tangentTransform_World);
                float3 _Normalize_E5F34A45_Out_1;
                Unity_Normalize_float3(_Transform_F679F94B_Out_1, _Normalize_E5F34A45_Out_1);
                XYZ_1 = (float4(_Normalize_E5F34A45_Out_1, 1.0));
                XZ_2 = (float4(_Vector3_A5ECB01F_Out_0, 1.0));
                YZ_3 = (float4(_Vector3_77AAFCD8_Out_0, 1.0));
                XY_4 = (float4(_Vector3_1ACBBFC4_Out_0, 1.0));
            }
            
            void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
            {
                Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
            }
            
            void Unity_Lerp_float(float A, float B, float T, out float Out)
            {
                Out = lerp(A, B, T);
            }
        
            // Graph Vertex
            struct VertexDescriptionInputs
            {
                float3 ObjectSpaceNormal;
                float3 ObjectSpaceTangent;
                float3 ObjectSpacePosition;
            };
            
            struct VertexDescription
            {
                float3 VertexPosition;
                float3 VertexNormal;
                float3 VertexTangent;
            };
            
            VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
            {
                VertexDescription description = (VertexDescription)0;
                Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b _NMObjectVSProIndirect_6D18728A;
                float3 _NMObjectVSProIndirect_6D18728A_ObjectSpacePosition_1;
                SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b(IN.ObjectSpacePosition, _NMObjectVSProIndirect_6D18728A, _NMObjectVSProIndirect_6D18728A_ObjectSpacePosition_1);
                description.VertexPosition = _NMObjectVSProIndirect_6D18728A_ObjectSpacePosition_1;
                description.VertexNormal = IN.ObjectSpaceNormal;
                description.VertexTangent = IN.ObjectSpaceTangent;
                return description;
            }
            
            // Graph Pixel
            struct SurfaceDescriptionInputs
            {
                float3 WorldSpaceNormal;
                float3 WorldSpaceTangent;
                float3 WorldSpaceBiTangent;
                float3 WorldSpacePosition;
                float3 AbsoluteWorldSpacePosition;
                float4 uv0;
                float4 VertexColor;
            };
            
            struct SurfaceDescription
            {
                float3 Albedo;
                float3 Normal;
                float3 Emission;
                float Metallic;
                float Smoothness;
                float Occlusion;
                float Alpha;
                float AlphaClipThreshold;
            };
            
            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
            {
                SurfaceDescription surface = (SurfaceDescription)0;
                float4 _Property_B8B9BCEA_Out_0 = _BaseTilingOffset;
                float4 _Divide_4D76B006_Out_2;
                Unity_Divide_float4(float4(1, 1, 0, 0), _Property_B8B9BCEA_Out_0, _Divide_4D76B006_Out_2);
                float _Property_7D01357A_Out_0 = _BaseTriplanarThreshold;
                Bindings_TriplanarNM_bc609ed95f52591469ab35dbfe0efcea _TriplanarNM_E18E8AC;
                _TriplanarNM_E18E8AC.WorldSpaceNormal = IN.WorldSpaceNormal;
                _TriplanarNM_E18E8AC.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
                float4 _TriplanarNM_E18E8AC_XYZ_1;
                float4 _TriplanarNM_E18E8AC_XZ_2;
                float4 _TriplanarNM_E18E8AC_YZ_3;
                float4 _TriplanarNM_E18E8AC_XY_4;
                SG_TriplanarNM_bc609ed95f52591469ab35dbfe0efcea(TEXTURE2D_ARGS(_BaseColorMap, sampler_BaseColorMap), _BaseColorMap_TexelSize, (_Divide_4D76B006_Out_2).x, _Property_7D01357A_Out_0, _TriplanarNM_E18E8AC, _TriplanarNM_E18E8AC_XYZ_1, _TriplanarNM_E18E8AC_XZ_2, _TriplanarNM_E18E8AC_YZ_3, _TriplanarNM_E18E8AC_XY_4);
                float4 _Property_8A523D6E_Out_0 = _BaseColor;
                float4 _Multiply_947B49CF_Out_2;
                Unity_Multiply_float(_TriplanarNM_E18E8AC_XYZ_1, _Property_8A523D6E_Out_0, _Multiply_947B49CF_Out_2);
                Bindings_TriplanarNM_bc609ed95f52591469ab35dbfe0efcea _TriplanarNM_259285D2;
                _TriplanarNM_259285D2.WorldSpaceNormal = IN.WorldSpaceNormal;
                _TriplanarNM_259285D2.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
                float4 _TriplanarNM_259285D2_XYZ_1;
                float4 _TriplanarNM_259285D2_XZ_2;
                float4 _TriplanarNM_259285D2_YZ_3;
                float4 _TriplanarNM_259285D2_XY_4;
                SG_TriplanarNM_bc609ed95f52591469ab35dbfe0efcea(TEXTURE2D_ARGS(_BaseMaskMap, sampler_BaseMaskMap), _BaseMaskMap_TexelSize, (_Divide_4D76B006_Out_2).x, _Property_7D01357A_Out_0, _TriplanarNM_259285D2, _TriplanarNM_259285D2_XYZ_1, _TriplanarNM_259285D2_XZ_2, _TriplanarNM_259285D2_YZ_3, _TriplanarNM_259285D2_XY_4);
                float _Split_D7F77369_R_1 = _TriplanarNM_259285D2_XYZ_1[0];
                float _Split_D7F77369_G_2 = _TriplanarNM_259285D2_XYZ_1[1];
                float _Split_D7F77369_B_3 = _TriplanarNM_259285D2_XYZ_1[2];
                float _Split_D7F77369_A_4 = _TriplanarNM_259285D2_XYZ_1[3];
                float _Property_5B1C3843_Out_0 = _HeightMin;
                float _Property_8DFF57BF_Out_0 = _HeightMax;
                float2 _Vector2_ADFF96C5_Out_0 = float2(_Property_5B1C3843_Out_0, _Property_8DFF57BF_Out_0);
                float _Property_4828C904_Out_0 = _HeightOffset;
                float2 _Add_467FE662_Out_2;
                Unity_Add_float2(_Vector2_ADFF96C5_Out_0, (_Property_4828C904_Out_0.xx), _Add_467FE662_Out_2);
                float _Remap_70CCBE12_Out_3;
                Unity_Remap_float(_Split_D7F77369_B_3, float2 (0, 1), _Add_467FE662_Out_2, _Remap_70CCBE12_Out_3);
                float4 _Property_46D734F3_Out_0 = _Base2TilingOffset;
                float4 _Divide_FE689998_Out_2;
                Unity_Divide_float4(float4(1, 1, 0, 0), _Property_46D734F3_Out_0, _Divide_FE689998_Out_2);
                float _Property_A196647F_Out_0 = _Base2TriplanarThreshold;
                Bindings_TriplanarNM_bc609ed95f52591469ab35dbfe0efcea _TriplanarNM_63DC6E31;
                _TriplanarNM_63DC6E31.WorldSpaceNormal = IN.WorldSpaceNormal;
                _TriplanarNM_63DC6E31.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
                float4 _TriplanarNM_63DC6E31_XYZ_1;
                float4 _TriplanarNM_63DC6E31_XZ_2;
                float4 _TriplanarNM_63DC6E31_YZ_3;
                float4 _TriplanarNM_63DC6E31_XY_4;
                SG_TriplanarNM_bc609ed95f52591469ab35dbfe0efcea(TEXTURE2D_ARGS(_Base2ColorMap, sampler_Base2ColorMap), _Base2ColorMap_TexelSize, (_Divide_FE689998_Out_2).x, _Property_A196647F_Out_0, _TriplanarNM_63DC6E31, _TriplanarNM_63DC6E31_XYZ_1, _TriplanarNM_63DC6E31_XZ_2, _TriplanarNM_63DC6E31_YZ_3, _TriplanarNM_63DC6E31_XY_4);
                float4 _Property_A9F4D16F_Out_0 = _Base2Color;
                float4 _Multiply_1B422358_Out_2;
                Unity_Multiply_float(_TriplanarNM_63DC6E31_XYZ_1, _Property_A9F4D16F_Out_0, _Multiply_1B422358_Out_2);
                float _Property_42D2FDFE_Out_0 = _Invert_Layer_Mask;
                float4 _SampleTexture2D_6C16A06F_RGBA_0 = SAMPLE_TEXTURE2D(_LayerMask, sampler_LayerMask, IN.uv0.xy);
                float _SampleTexture2D_6C16A06F_R_4 = _SampleTexture2D_6C16A06F_RGBA_0.r;
                float _SampleTexture2D_6C16A06F_G_5 = _SampleTexture2D_6C16A06F_RGBA_0.g;
                float _SampleTexture2D_6C16A06F_B_6 = _SampleTexture2D_6C16A06F_RGBA_0.b;
                float _SampleTexture2D_6C16A06F_A_7 = _SampleTexture2D_6C16A06F_RGBA_0.a;
                float _OneMinus_713B6303_Out_1;
                Unity_OneMinus_float(_SampleTexture2D_6C16A06F_R_4, _OneMinus_713B6303_Out_1);
                float _Branch_1D7AD048_Out_3;
                Unity_Branch_float(_Property_42D2FDFE_Out_0, _OneMinus_713B6303_Out_1, _SampleTexture2D_6C16A06F_R_4, _Branch_1D7AD048_Out_3);
                Bindings_TriplanarNM_bc609ed95f52591469ab35dbfe0efcea _TriplanarNM_F9354D5A;
                _TriplanarNM_F9354D5A.WorldSpaceNormal = IN.WorldSpaceNormal;
                _TriplanarNM_F9354D5A.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
                float4 _TriplanarNM_F9354D5A_XYZ_1;
                float4 _TriplanarNM_F9354D5A_XZ_2;
                float4 _TriplanarNM_F9354D5A_YZ_3;
                float4 _TriplanarNM_F9354D5A_XY_4;
                SG_TriplanarNM_bc609ed95f52591469ab35dbfe0efcea(TEXTURE2D_ARGS(_Base2MaskMap, sampler_Base2MaskMap), _Base2MaskMap_TexelSize, (_Divide_FE689998_Out_2).x, _Property_A196647F_Out_0, _TriplanarNM_F9354D5A, _TriplanarNM_F9354D5A_XYZ_1, _TriplanarNM_F9354D5A_XZ_2, _TriplanarNM_F9354D5A_YZ_3, _TriplanarNM_F9354D5A_XY_4);
                float _Split_DFCC504E_R_1 = _TriplanarNM_F9354D5A_XYZ_1[0];
                float _Split_DFCC504E_G_2 = _TriplanarNM_F9354D5A_XYZ_1[1];
                float _Split_DFCC504E_B_3 = _TriplanarNM_F9354D5A_XYZ_1[2];
                float _Split_DFCC504E_A_4 = _TriplanarNM_F9354D5A_XYZ_1[3];
                float _Property_6ADBE904_Out_0 = _HeightMin2;
                float _Property_B5DAC869_Out_0 = _HeightMax2;
                float2 _Vector2_9AD51603_Out_0 = float2(_Property_6ADBE904_Out_0, _Property_B5DAC869_Out_0);
                float _Property_998773C1_Out_0 = _HeightOffset2;
                float2 _Add_AD0B7F0B_Out_2;
                Unity_Add_float2(_Vector2_9AD51603_Out_0, (_Property_998773C1_Out_0.xx), _Add_AD0B7F0B_Out_2);
                float _Remap_8A5A7412_Out_3;
                Unity_Remap_float(_Split_DFCC504E_B_3, float2 (0, 1), _Add_AD0B7F0B_Out_2, _Remap_8A5A7412_Out_3);
                float _Multiply_D301D5D0_Out_2;
                Unity_Multiply_float(_Branch_1D7AD048_Out_3, _Remap_8A5A7412_Out_3, _Multiply_D301D5D0_Out_2);
                float _Split_D4434FA2_R_1 = IN.VertexColor[0];
                float _Split_D4434FA2_G_2 = IN.VertexColor[1];
                float _Split_D4434FA2_B_3 = IN.VertexColor[2];
                float _Split_D4434FA2_A_4 = IN.VertexColor[3];
                float _Multiply_3A02260E_Out_2;
                Unity_Multiply_float(_Multiply_D301D5D0_Out_2, _Split_D4434FA2_B_3, _Multiply_3A02260E_Out_2);
                float _Property_830CBD9E_Out_0 = _Height_Transition;
                Bindings_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135 _HeightBlend_B5DE67BD;
                float3 _HeightBlend_B5DE67BD_OutVector4_1;
                SG_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135((_Multiply_947B49CF_Out_2.xyz), _Remap_70CCBE12_Out_3, (_Multiply_1B422358_Out_2.xyz), _Multiply_3A02260E_Out_2, _Property_830CBD9E_Out_0, _HeightBlend_B5DE67BD, _HeightBlend_B5DE67BD_OutVector4_1);
                float4 _Property_81D4E0A_Out_0 = _WetColor;
                float3 _Multiply_E136BC52_Out_2;
                Unity_Multiply_float((_Property_81D4E0A_Out_0.xyz), _HeightBlend_B5DE67BD_OutVector4_1, _Multiply_E136BC52_Out_2);
                float _OneMinus_43105B03_Out_1;
                Unity_OneMinus_float(_Split_D4434FA2_R_1, _OneMinus_43105B03_Out_1);
                float3 _Lerp_9376B2BE_Out_3;
                Unity_Lerp_float3(_HeightBlend_B5DE67BD_OutVector4_1, _Multiply_E136BC52_Out_2, (_OneMinus_43105B03_Out_1.xxx), _Lerp_9376B2BE_Out_3);
                Bindings_TriplanarNMn_059da9746584140498cd018db3c76047 _TriplanarNMn_6A3639BB;
                _TriplanarNMn_6A3639BB.WorldSpaceNormal = IN.WorldSpaceNormal;
                _TriplanarNMn_6A3639BB.WorldSpaceTangent = IN.WorldSpaceTangent;
                _TriplanarNMn_6A3639BB.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
                _TriplanarNMn_6A3639BB.WorldSpacePosition = IN.WorldSpacePosition;
                float4 _TriplanarNMn_6A3639BB_XYZ_1;
                float4 _TriplanarNMn_6A3639BB_XZ_2;
                float4 _TriplanarNMn_6A3639BB_YZ_3;
                float4 _TriplanarNMn_6A3639BB_XY_4;
                SG_TriplanarNMn_059da9746584140498cd018db3c76047(TEXTURE2D_ARGS(_BaseNormalMap, sampler_BaseNormalMap), _BaseNormalMap_TexelSize, (_Divide_4D76B006_Out_2).x, _Property_7D01357A_Out_0, _TriplanarNMn_6A3639BB, _TriplanarNMn_6A3639BB_XYZ_1, _TriplanarNMn_6A3639BB_XZ_2, _TriplanarNMn_6A3639BB_YZ_3, _TriplanarNMn_6A3639BB_XY_4);
                float _Property_C43D3DBF_Out_0 = _BaseNormalScale;
                float3 _NormalStrength_9AC9CB1E_Out_2;
                Unity_NormalStrength_float((_TriplanarNMn_6A3639BB_XYZ_1.xyz), _Property_C43D3DBF_Out_0, _NormalStrength_9AC9CB1E_Out_2);
                Bindings_TriplanarNMn_059da9746584140498cd018db3c76047 _TriplanarNMn_E06525FF;
                _TriplanarNMn_E06525FF.WorldSpaceNormal = IN.WorldSpaceNormal;
                _TriplanarNMn_E06525FF.WorldSpaceTangent = IN.WorldSpaceTangent;
                _TriplanarNMn_E06525FF.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
                _TriplanarNMn_E06525FF.WorldSpacePosition = IN.WorldSpacePosition;
                float4 _TriplanarNMn_E06525FF_XYZ_1;
                float4 _TriplanarNMn_E06525FF_XZ_2;
                float4 _TriplanarNMn_E06525FF_YZ_3;
                float4 _TriplanarNMn_E06525FF_XY_4;
                SG_TriplanarNMn_059da9746584140498cd018db3c76047(TEXTURE2D_ARGS(_Base2NormalMap, sampler_Base2NormalMap), _Base2NormalMap_TexelSize, (_Divide_FE689998_Out_2).x, _Property_A196647F_Out_0, _TriplanarNMn_E06525FF, _TriplanarNMn_E06525FF_XYZ_1, _TriplanarNMn_E06525FF_XZ_2, _TriplanarNMn_E06525FF_YZ_3, _TriplanarNMn_E06525FF_XY_4);
                float _Property_210A8C6C_Out_0 = _Base2NormalScale;
                float3 _NormalStrength_D4D54951_Out_2;
                Unity_NormalStrength_float((_TriplanarNMn_E06525FF_XYZ_1.xyz), _Property_210A8C6C_Out_0, _NormalStrength_D4D54951_Out_2);
                Bindings_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135 _HeightBlend_98472682;
                float3 _HeightBlend_98472682_OutVector4_1;
                SG_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135(_NormalStrength_9AC9CB1E_Out_2, _Remap_70CCBE12_Out_3, _NormalStrength_D4D54951_Out_2, _Multiply_3A02260E_Out_2, _Property_830CBD9E_Out_0, _HeightBlend_98472682, _HeightBlend_98472682_OutVector4_1);
                float _Property_2612600D_Out_0 = _BaseMetallic;
                float _Multiply_404C3551_Out_2;
                Unity_Multiply_float(_Split_D7F77369_R_1, _Property_2612600D_Out_0, _Multiply_404C3551_Out_2);
                float _Property_2D6A33E8_Out_0 = _BaseAORemapMin;
                float _Property_A73EA028_Out_0 = _BaseAORemapMax;
                float2 _Vector2_60FE3632_Out_0 = float2(_Property_2D6A33E8_Out_0, _Property_A73EA028_Out_0);
                float _Remap_E88E5DF_Out_3;
                Unity_Remap_float(_Split_D7F77369_G_2, float2 (0, 1), _Vector2_60FE3632_Out_0, _Remap_E88E5DF_Out_3);
                float _Property_6A76AF06_Out_0 = _BaseSmoothnessRemapMin;
                float _Property_CF975707_Out_0 = _BaseSmoothnessRemapMax;
                float2 _Vector2_44BB1DAC_Out_0 = float2(_Property_6A76AF06_Out_0, _Property_CF975707_Out_0);
                float _Remap_2B6869A6_Out_3;
                Unity_Remap_float(_Split_D7F77369_A_4, float2 (0, 1), _Vector2_44BB1DAC_Out_0, _Remap_2B6869A6_Out_3);
                float3 _Vector3_3417D3B9_Out_0 = float3(_Multiply_404C3551_Out_2, _Remap_E88E5DF_Out_3, _Remap_2B6869A6_Out_3);
                float _Property_CDFCB39_Out_0 = _Base2Metallic;
                float _Multiply_FA96B87E_Out_2;
                Unity_Multiply_float(_Split_DFCC504E_R_1, _Property_CDFCB39_Out_0, _Multiply_FA96B87E_Out_2);
                float _Property_A2F128AC_Out_0 = _Base2AORemapMin;
                float _Property_3CAAD3E8_Out_0 = _Base2AORemapMax;
                float2 _Vector2_32DABB99_Out_0 = float2(_Property_A2F128AC_Out_0, _Property_3CAAD3E8_Out_0);
                float _Remap_7B6093C5_Out_3;
                Unity_Remap_float(_Split_DFCC504E_G_2, float2 (0, 1), _Vector2_32DABB99_Out_0, _Remap_7B6093C5_Out_3);
                float _Property_2CC5BE3B_Out_0 = _Base2SmoothnessRemapMin;
                float _Property_AC8892A5_Out_0 = _Base2SmoothnessRemapMax;
                float2 _Vector2_31378DA_Out_0 = float2(_Property_2CC5BE3B_Out_0, _Property_AC8892A5_Out_0);
                float _Remap_F484D02E_Out_3;
                Unity_Remap_float(_Split_DFCC504E_A_4, float2 (0, 1), _Vector2_31378DA_Out_0, _Remap_F484D02E_Out_3);
                float3 _Vector3_7509F9CC_Out_0 = float3(_Multiply_FA96B87E_Out_2, _Remap_7B6093C5_Out_3, _Remap_F484D02E_Out_3);
                Bindings_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135 _HeightBlend_10CA2742;
                float3 _HeightBlend_10CA2742_OutVector4_1;
                SG_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135(_Vector3_3417D3B9_Out_0, _Remap_70CCBE12_Out_3, _Vector3_7509F9CC_Out_0, _Multiply_3A02260E_Out_2, _Property_830CBD9E_Out_0, _HeightBlend_10CA2742, _HeightBlend_10CA2742_OutVector4_1);
                float _Split_5E4E3019_R_1 = _HeightBlend_10CA2742_OutVector4_1[0];
                float _Split_5E4E3019_G_2 = _HeightBlend_10CA2742_OutVector4_1[1];
                float _Split_5E4E3019_B_3 = _HeightBlend_10CA2742_OutVector4_1[2];
                float _Split_5E4E3019_A_4 = 0;
                float _Property_D9390872_Out_0 = _WetSmoothness;
                float _Lerp_BC7089D3_Out_3;
                Unity_Lerp_float(_Split_5E4E3019_B_3, _Property_D9390872_Out_0, _OneMinus_43105B03_Out_1, _Lerp_BC7089D3_Out_3);
                float _Split_F7C504B3_R_1 = _TriplanarNM_E18E8AC_XYZ_1[0];
                float _Split_F7C504B3_G_2 = _TriplanarNM_E18E8AC_XYZ_1[1];
                float _Split_F7C504B3_B_3 = _TriplanarNM_E18E8AC_XYZ_1[2];
                float _Split_F7C504B3_A_4 = _TriplanarNM_E18E8AC_XYZ_1[3];
                float _Property_5761B808_Out_0 = _AlphaCutoff;
                surface.Albedo = _Lerp_9376B2BE_Out_3;
                surface.Normal = _HeightBlend_98472682_OutVector4_1;
                surface.Emission = IsGammaSpace() ? float3(0, 0, 0) : SRGBToLinear(float3(0, 0, 0));
                surface.Metallic = _Split_5E4E3019_R_1;
                surface.Smoothness = _Lerp_BC7089D3_Out_3;
                surface.Occlusion = _Split_5E4E3019_G_2;
                surface.Alpha = _Split_F7C504B3_A_4;
                surface.AlphaClipThreshold = _Property_5761B808_Out_0;
                return surface;
            }
        
            // --------------------------------------------------
            // Structs and Packing
        
            // Generated Type: Attributes
            struct Attributes
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                float4 uv0 : TEXCOORD0;
                float4 uv1 : TEXCOORD1;
                float4 color : COLOR;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif
            };
        
            // Generated Type: Varyings
            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float3 positionWS;
                float3 normalWS;
                float4 tangentWS;
                float4 texCoord0;
                float4 color;
                float3 viewDirectionWS;
                #if defined(LIGHTMAP_ON)
                float2 lightmapUV;
                #endif
                #if !defined(LIGHTMAP_ON)
                float3 sh;
                #endif
                float4 fogFactorAndVertexLight;
                float4 shadowCoord;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Generated Type: PackedVaryings
            struct PackedVaryings
            {
                float4 positionCS : SV_POSITION;
                #if defined(LIGHTMAP_ON)
                #endif
                #if !defined(LIGHTMAP_ON)
                #endif
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                float3 interp00 : TEXCOORD0;
                float3 interp01 : TEXCOORD1;
                float4 interp02 : TEXCOORD2;
                float4 interp03 : TEXCOORD3;
                float4 interp04 : TEXCOORD4;
                float3 interp05 : TEXCOORD5;
                float2 interp06 : TEXCOORD6;
                float3 interp07 : TEXCOORD7;
                float4 interp08 : TEXCOORD8;
                float4 interp09 : TEXCOORD9;
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Packed Type: Varyings
            PackedVaryings PackVaryings(Varyings input)
            {
                PackedVaryings output = (PackedVaryings)0;
                output.positionCS = input.positionCS;
                output.interp00.xyz = input.positionWS;
                output.interp01.xyz = input.normalWS;
                output.interp02.xyzw = input.tangentWS;
                output.interp03.xyzw = input.texCoord0;
                output.interp04.xyzw = input.color;
                output.interp05.xyz = input.viewDirectionWS;
                #if defined(LIGHTMAP_ON)
                output.interp06.xy = input.lightmapUV;
                #endif
                #if !defined(LIGHTMAP_ON)
                output.interp07.xyz = input.sh;
                #endif
                output.interp08.xyzw = input.fogFactorAndVertexLight;
                output.interp09.xyzw = input.shadowCoord;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }
            
            // Unpacked Type: Varyings
            Varyings UnpackVaryings(PackedVaryings input)
            {
                Varyings output = (Varyings)0;
                output.positionCS = input.positionCS;
                output.positionWS = input.interp00.xyz;
                output.normalWS = input.interp01.xyz;
                output.tangentWS = input.interp02.xyzw;
                output.texCoord0 = input.interp03.xyzw;
                output.color = input.interp04.xyzw;
                output.viewDirectionWS = input.interp05.xyz;
                #if defined(LIGHTMAP_ON)
                output.lightmapUV = input.interp06.xy;
                #endif
                #if !defined(LIGHTMAP_ON)
                output.sh = input.interp07.xyz;
                #endif
                output.fogFactorAndVertexLight = input.interp08.xyzw;
                output.shadowCoord = input.interp09.xyzw;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
            {
                VertexDescriptionInputs output;
                ZERO_INITIALIZE(VertexDescriptionInputs, output);
            
                output.ObjectSpaceNormal =           input.normalOS;
                output.ObjectSpaceTangent =          input.tangentOS;
                output.ObjectSpacePosition =         input.positionOS;
            
                return output;
            }
            
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
            	// must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            	float3 unnormalizedNormalWS = input.normalWS;
                const float renormFactor = 1.0 / length(unnormalizedNormalWS);
            
            	// use bitangent on the fly like in hdrp
            	// IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
                float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0) * GetOddNegativeScale();
            	float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
            
                output.WorldSpaceNormal =            renormFactor*input.normalWS.xyz;		// we want a unit length Normal Vector node in shader graph
            
            	// to preserve mikktspace compliance we use same scale renormFactor as was used on the normal.
            	// This is explained in section 2.2 in "surface gradient based bump mapping framework"
                output.WorldSpaceTangent =           renormFactor*input.tangentWS.xyz;
            	output.WorldSpaceBiTangent =         renormFactor*bitang;
            
                output.WorldSpacePosition =          input.positionWS;
                output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(input.positionWS);
                output.uv0 =                         input.texCoord0;
                output.VertexColor =                 input.color;
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
            #else
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            #endif
            #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            
                return output;
            }
            
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"
        
            ENDHLSL
        }
        
        Pass
        {
            Name "ShadowCaster"
            Tags 
            { 
                "LightMode" = "ShadowCaster"
            }
           
            // Render State
            Blend One Zero, One Zero
            Cull Back
            ZTest LEqual
            ZWrite On
            // ColorMask: <None>
            
        
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            // Pragmas
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            #pragma target 2.0
            #pragma multi_compile_instancing
        
            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>
            
            // Defines
            #define _AlphaClip 1
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define VARYINGS_NEED_POSITION_WS 
            #define VARYINGS_NEED_NORMAL_WS
            #define FEATURES_GRAPH_VERTEX
            #pragma multi_compile_instancing
            #define UNITY_DOTS_SHADER
            #pragma instancing_options nolightprobe
            #pragma instancing_options nolodfade
            #define SHADERPASS_SHADOWCASTER
            
        
            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariablesFunctions.hlsl"
        
            // --------------------------------------------------
            // Graph
        
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
            float _AlphaCutoff;
            float4 _BaseColor;
            float4 _BaseTilingOffset;
            float _BaseTriplanarThreshold;
            float _BaseNormalScale;
            float _BaseMetallic;
            float _BaseAORemapMin;
            float _BaseAORemapMax;
            float _BaseSmoothnessRemapMin;
            float _BaseSmoothnessRemapMax;
            float _Invert_Layer_Mask;
            float _Height_Transition;
            float _HeightMin;
            float _HeightMax;
            float _HeightOffset;
            float _HeightMin2;
            float _HeightMax2;
            float _HeightOffset2;
            float4 _Base2Color;
            float4 _Base2TilingOffset;
            float _Base2TriplanarThreshold;
            float _Base2NormalScale;
            float _Base2Metallic;
            float _Base2SmoothnessRemapMin;
            float _Base2SmoothnessRemapMax;
            float _Base2AORemapMin;
            float _Base2AORemapMax;
            float4 _WetColor;
            float _WetSmoothness;
            CBUFFER_END
            TEXTURE2D(_BaseColorMap); SAMPLER(sampler_BaseColorMap); float4 _BaseColorMap_TexelSize;
            TEXTURE2D(_BaseNormalMap); SAMPLER(sampler_BaseNormalMap); float4 _BaseNormalMap_TexelSize;
            TEXTURE2D(_BaseMaskMap); SAMPLER(sampler_BaseMaskMap); float4 _BaseMaskMap_TexelSize;
            TEXTURE2D(_LayerMask); SAMPLER(sampler_LayerMask); float4 _LayerMask_TexelSize;
            TEXTURE2D(_Base2ColorMap); SAMPLER(sampler_Base2ColorMap); float4 _Base2ColorMap_TexelSize;
            TEXTURE2D(_Base2NormalMap); SAMPLER(sampler_Base2NormalMap); float4 _Base2NormalMap_TexelSize;
            TEXTURE2D(_Base2MaskMap); SAMPLER(sampler_Base2MaskMap); float4 _Base2MaskMap_TexelSize;
            SAMPLER(_SampleTexture2D_AF934D9A_Sampler_3_Linear_Repeat);
            SAMPLER(_SampleTexture2D_66E4959F_Sampler_3_Linear_Repeat);
            SAMPLER(_SampleTexture2D_96366F41_Sampler_3_Linear_Repeat);
        
            // Graph Functions
            
            // 0ff7b9db8f55df06fc08dc990cfb397e
            #include "Assets/NatureManufacture Assets/Object Shaders/NM_Object_VSPro_Indirect.cginc"
            
            void AddPragma_float(float3 A, out float3 Out)
            {
                #pragma instancing_options renderinglayer procedural:setupVSPro
                Out = A;
            }
            
            struct Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b
            {
            };
            
            void SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b(float3 Vector3_314C8600, Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b IN, out float3 ObjectSpacePosition_1)
            {
                float3 _Property_AF5E8C93_Out_0 = Vector3_314C8600;
                float3 _CustomFunction_E07FEE57_Out_1;
                InjectSetup_float(_Property_AF5E8C93_Out_0, _CustomFunction_E07FEE57_Out_1);
                float3 _CustomFunction_18EFD858_Out_1;
                AddPragma_float(_CustomFunction_E07FEE57_Out_1, _CustomFunction_18EFD858_Out_1);
                ObjectSpacePosition_1 = _CustomFunction_18EFD858_Out_1;
            }
            
            void Unity_Divide_float4(float4 A, float4 B, out float4 Out)
            {
                Out = A / B;
            }
            
            void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
            {
                RGBA = float4(R, G, B, A);
                RGB = float3(R, G, B);
                RG = float2(R, G);
            }
            
            void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
            {
                Out = A * B;
            }
            
            void Unity_Sign_float3(float3 In, out float3 Out)
            {
                Out = sign(In);
            }
            
            void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
            {
                Out = A * B;
            }
            
            void Unity_Absolute_float3(float3 In, out float3 Out)
            {
                Out = abs(In);
            }
            
            void Unity_Power_float3(float3 A, float3 B, out float3 Out)
            {
                Out = pow(A, B);
            }
            
            void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
            {
                Out = A * B;
            }
            
            void Unity_Multiply_float(float A, float B, out float Out)
            {
                Out = A * B;
            }
            
            void Unity_Add_float4(float4 A, float4 B, out float4 Out)
            {
                Out = A + B;
            }
            
            void Unity_Add_float(float A, float B, out float Out)
            {
                Out = A + B;
            }
            
            struct Bindings_TriplanarNM_bc609ed95f52591469ab35dbfe0efcea
            {
                float3 WorldSpaceNormal;
                float3 AbsoluteWorldSpacePosition;
            };
            
            void SG_TriplanarNM_bc609ed95f52591469ab35dbfe0efcea(TEXTURE2D_PARAM(Texture2D_80A3D28F, samplerTexture2D_80A3D28F), float4 Texture2D_80A3D28F_TexelSize, float Vector1_41461AC9, float Vector1_E4D1C13A, Bindings_TriplanarNM_bc609ed95f52591469ab35dbfe0efcea IN, out float4 XYZ_1, out float4 XZ_2, out float4 YZ_3, out float4 XY_4)
            {
                float _Split_34F118DC_R_1 = IN.AbsoluteWorldSpacePosition[0];
                float _Split_34F118DC_G_2 = IN.AbsoluteWorldSpacePosition[1];
                float _Split_34F118DC_B_3 = IN.AbsoluteWorldSpacePosition[2];
                float _Split_34F118DC_A_4 = 0;
                float4 _Combine_FDBD63CA_RGBA_4;
                float3 _Combine_FDBD63CA_RGB_5;
                float2 _Combine_FDBD63CA_RG_6;
                Unity_Combine_float(_Split_34F118DC_R_1, _Split_34F118DC_B_3, 0, 0, _Combine_FDBD63CA_RGBA_4, _Combine_FDBD63CA_RGB_5, _Combine_FDBD63CA_RG_6);
                float _Property_7A4DC59B_Out_0 = Vector1_41461AC9;
                float4 _Multiply_D99671F1_Out_2;
                Unity_Multiply_float(_Combine_FDBD63CA_RGBA_4, (_Property_7A4DC59B_Out_0.xxxx), _Multiply_D99671F1_Out_2);
                float3 _Sign_C0850857_Out_1;
                Unity_Sign_float3(IN.WorldSpaceNormal, _Sign_C0850857_Out_1);
                float _Split_EEBC69B5_R_1 = _Sign_C0850857_Out_1[0];
                float _Split_EEBC69B5_G_2 = _Sign_C0850857_Out_1[1];
                float _Split_EEBC69B5_B_3 = _Sign_C0850857_Out_1[2];
                float _Split_EEBC69B5_A_4 = 0;
                float2 _Vector2_7598EA98_Out_0 = float2(_Split_EEBC69B5_G_2, 1);
                float2 _Multiply_F82F3FE2_Out_2;
                Unity_Multiply_float((_Multiply_D99671F1_Out_2.xy), _Vector2_7598EA98_Out_0, _Multiply_F82F3FE2_Out_2);
                float4 _SampleTexture2D_AF934D9A_RGBA_0 = SAMPLE_TEXTURE2D(Texture2D_80A3D28F, samplerTexture2D_80A3D28F, _Multiply_F82F3FE2_Out_2);
                float _SampleTexture2D_AF934D9A_R_4 = _SampleTexture2D_AF934D9A_RGBA_0.r;
                float _SampleTexture2D_AF934D9A_G_5 = _SampleTexture2D_AF934D9A_RGBA_0.g;
                float _SampleTexture2D_AF934D9A_B_6 = _SampleTexture2D_AF934D9A_RGBA_0.b;
                float _SampleTexture2D_AF934D9A_A_7 = _SampleTexture2D_AF934D9A_RGBA_0.a;
                float3 _Absolute_FF95EDEB_Out_1;
                Unity_Absolute_float3(IN.WorldSpaceNormal, _Absolute_FF95EDEB_Out_1);
                float _Property_F8688E0_Out_0 = Vector1_E4D1C13A;
                float3 _Power_C741CD3A_Out_2;
                Unity_Power_float3(_Absolute_FF95EDEB_Out_1, (_Property_F8688E0_Out_0.xxx), _Power_C741CD3A_Out_2);
                float3 _Multiply_3FB4A346_Out_2;
                Unity_Multiply_float(_Power_C741CD3A_Out_2, _Power_C741CD3A_Out_2, _Multiply_3FB4A346_Out_2);
                float _Split_98088E33_R_1 = _Multiply_3FB4A346_Out_2[0];
                float _Split_98088E33_G_2 = _Multiply_3FB4A346_Out_2[1];
                float _Split_98088E33_B_3 = _Multiply_3FB4A346_Out_2[2];
                float _Split_98088E33_A_4 = 0;
                float4 _Multiply_B99FFB12_Out_2;
                Unity_Multiply_float(_SampleTexture2D_AF934D9A_RGBA_0, (_Split_98088E33_G_2.xxxx), _Multiply_B99FFB12_Out_2);
                float4 _Combine_EAF808EA_RGBA_4;
                float3 _Combine_EAF808EA_RGB_5;
                float2 _Combine_EAF808EA_RG_6;
                Unity_Combine_float(_Split_34F118DC_R_1, _Split_34F118DC_G_2, 0, 0, _Combine_EAF808EA_RGBA_4, _Combine_EAF808EA_RGB_5, _Combine_EAF808EA_RG_6);
                float4 _Multiply_9B855117_Out_2;
                Unity_Multiply_float(_Combine_EAF808EA_RGBA_4, (_Property_7A4DC59B_Out_0.xxxx), _Multiply_9B855117_Out_2);
                float _Multiply_B8AC16FB_Out_2;
                Unity_Multiply_float(_Split_EEBC69B5_B_3, -1, _Multiply_B8AC16FB_Out_2);
                float2 _Vector2_F031282A_Out_0 = float2(_Multiply_B8AC16FB_Out_2, 1);
                float2 _Multiply_89A39D70_Out_2;
                Unity_Multiply_float((_Multiply_9B855117_Out_2.xy), _Vector2_F031282A_Out_0, _Multiply_89A39D70_Out_2);
                float4 _SampleTexture2D_66E4959F_RGBA_0 = SAMPLE_TEXTURE2D(Texture2D_80A3D28F, samplerTexture2D_80A3D28F, _Multiply_89A39D70_Out_2);
                float _SampleTexture2D_66E4959F_R_4 = _SampleTexture2D_66E4959F_RGBA_0.r;
                float _SampleTexture2D_66E4959F_G_5 = _SampleTexture2D_66E4959F_RGBA_0.g;
                float _SampleTexture2D_66E4959F_B_6 = _SampleTexture2D_66E4959F_RGBA_0.b;
                float _SampleTexture2D_66E4959F_A_7 = _SampleTexture2D_66E4959F_RGBA_0.a;
                float4 _Multiply_9E620CB9_Out_2;
                Unity_Multiply_float(_SampleTexture2D_66E4959F_RGBA_0, (_Split_98088E33_B_3.xxxx), _Multiply_9E620CB9_Out_2);
                float4 _Combine_D494A8E_RGBA_4;
                float3 _Combine_D494A8E_RGB_5;
                float2 _Combine_D494A8E_RG_6;
                Unity_Combine_float(_Split_34F118DC_B_3, _Split_34F118DC_G_2, 0, 0, _Combine_D494A8E_RGBA_4, _Combine_D494A8E_RGB_5, _Combine_D494A8E_RG_6);
                float4 _Multiply_1B29A9F1_Out_2;
                Unity_Multiply_float(_Combine_D494A8E_RGBA_4, (_Property_7A4DC59B_Out_0.xxxx), _Multiply_1B29A9F1_Out_2);
                float2 _Vector2_1F147BEC_Out_0 = float2(_Split_EEBC69B5_R_1, 1);
                float2 _Multiply_5B8B54E9_Out_2;
                Unity_Multiply_float((_Multiply_1B29A9F1_Out_2.xy), _Vector2_1F147BEC_Out_0, _Multiply_5B8B54E9_Out_2);
                float4 _SampleTexture2D_96366F41_RGBA_0 = SAMPLE_TEXTURE2D(Texture2D_80A3D28F, samplerTexture2D_80A3D28F, _Multiply_5B8B54E9_Out_2);
                float _SampleTexture2D_96366F41_R_4 = _SampleTexture2D_96366F41_RGBA_0.r;
                float _SampleTexture2D_96366F41_G_5 = _SampleTexture2D_96366F41_RGBA_0.g;
                float _SampleTexture2D_96366F41_B_6 = _SampleTexture2D_96366F41_RGBA_0.b;
                float _SampleTexture2D_96366F41_A_7 = _SampleTexture2D_96366F41_RGBA_0.a;
                float4 _Multiply_1C5CFCC5_Out_2;
                Unity_Multiply_float(_SampleTexture2D_96366F41_RGBA_0, (_Split_98088E33_R_1.xxxx), _Multiply_1C5CFCC5_Out_2);
                float4 _Add_D483B2FD_Out_2;
                Unity_Add_float4(_Multiply_9E620CB9_Out_2, _Multiply_1C5CFCC5_Out_2, _Add_D483B2FD_Out_2);
                float4 _Add_166B5BED_Out_2;
                Unity_Add_float4(_Multiply_B99FFB12_Out_2, _Add_D483B2FD_Out_2, _Add_166B5BED_Out_2);
                float _Add_B73B64F6_Out_2;
                Unity_Add_float(_Split_98088E33_R_1, _Split_98088E33_G_2, _Add_B73B64F6_Out_2);
                float _Add_523B36E8_Out_2;
                Unity_Add_float(_Add_B73B64F6_Out_2, _Split_98088E33_B_3, _Add_523B36E8_Out_2);
                float4 _Divide_86C67C72_Out_2;
                Unity_Divide_float4(_Add_166B5BED_Out_2, (_Add_523B36E8_Out_2.xxxx), _Divide_86C67C72_Out_2);
                XYZ_1 = _Divide_86C67C72_Out_2;
                XZ_2 = _SampleTexture2D_AF934D9A_RGBA_0;
                YZ_3 = _SampleTexture2D_66E4959F_RGBA_0;
                XY_4 = _SampleTexture2D_96366F41_RGBA_0;
            }
        
            // Graph Vertex
            struct VertexDescriptionInputs
            {
                float3 ObjectSpaceNormal;
                float3 ObjectSpaceTangent;
                float3 ObjectSpacePosition;
            };
            
            struct VertexDescription
            {
                float3 VertexPosition;
                float3 VertexNormal;
                float3 VertexTangent;
            };
            
            VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
            {
                VertexDescription description = (VertexDescription)0;
                Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b _NMObjectVSProIndirect_6D18728A;
                float3 _NMObjectVSProIndirect_6D18728A_ObjectSpacePosition_1;
                SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b(IN.ObjectSpacePosition, _NMObjectVSProIndirect_6D18728A, _NMObjectVSProIndirect_6D18728A_ObjectSpacePosition_1);
                description.VertexPosition = _NMObjectVSProIndirect_6D18728A_ObjectSpacePosition_1;
                description.VertexNormal = IN.ObjectSpaceNormal;
                description.VertexTangent = IN.ObjectSpaceTangent;
                return description;
            }
            
            // Graph Pixel
            struct SurfaceDescriptionInputs
            {
                float3 WorldSpaceNormal;
                float3 AbsoluteWorldSpacePosition;
            };
            
            struct SurfaceDescription
            {
                float Alpha;
                float AlphaClipThreshold;
            };
            
            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
            {
                SurfaceDescription surface = (SurfaceDescription)0;
                float4 _Property_B8B9BCEA_Out_0 = _BaseTilingOffset;
                float4 _Divide_4D76B006_Out_2;
                Unity_Divide_float4(float4(1, 1, 0, 0), _Property_B8B9BCEA_Out_0, _Divide_4D76B006_Out_2);
                float _Property_7D01357A_Out_0 = _BaseTriplanarThreshold;
                Bindings_TriplanarNM_bc609ed95f52591469ab35dbfe0efcea _TriplanarNM_E18E8AC;
                _TriplanarNM_E18E8AC.WorldSpaceNormal = IN.WorldSpaceNormal;
                _TriplanarNM_E18E8AC.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
                float4 _TriplanarNM_E18E8AC_XYZ_1;
                float4 _TriplanarNM_E18E8AC_XZ_2;
                float4 _TriplanarNM_E18E8AC_YZ_3;
                float4 _TriplanarNM_E18E8AC_XY_4;
                SG_TriplanarNM_bc609ed95f52591469ab35dbfe0efcea(TEXTURE2D_ARGS(_BaseColorMap, sampler_BaseColorMap), _BaseColorMap_TexelSize, (_Divide_4D76B006_Out_2).x, _Property_7D01357A_Out_0, _TriplanarNM_E18E8AC, _TriplanarNM_E18E8AC_XYZ_1, _TriplanarNM_E18E8AC_XZ_2, _TriplanarNM_E18E8AC_YZ_3, _TriplanarNM_E18E8AC_XY_4);
                float _Split_F7C504B3_R_1 = _TriplanarNM_E18E8AC_XYZ_1[0];
                float _Split_F7C504B3_G_2 = _TriplanarNM_E18E8AC_XYZ_1[1];
                float _Split_F7C504B3_B_3 = _TriplanarNM_E18E8AC_XYZ_1[2];
                float _Split_F7C504B3_A_4 = _TriplanarNM_E18E8AC_XYZ_1[3];
                float _Property_5761B808_Out_0 = _AlphaCutoff;
                surface.Alpha = _Split_F7C504B3_A_4;
                surface.AlphaClipThreshold = _Property_5761B808_Out_0;
                return surface;
            }
        
            // --------------------------------------------------
            // Structs and Packing
        
            // Generated Type: Attributes
            struct Attributes
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif
            };
        
            // Generated Type: Varyings
            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float3 positionWS;
                float3 normalWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Generated Type: PackedVaryings
            struct PackedVaryings
            {
                float4 positionCS : SV_POSITION;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                float3 interp00 : TEXCOORD0;
                float3 interp01 : TEXCOORD1;
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Packed Type: Varyings
            PackedVaryings PackVaryings(Varyings input)
            {
                PackedVaryings output = (PackedVaryings)0;
                output.positionCS = input.positionCS;
                output.interp00.xyz = input.positionWS;
                output.interp01.xyz = input.normalWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }
            
            // Unpacked Type: Varyings
            Varyings UnpackVaryings(PackedVaryings input)
            {
                Varyings output = (Varyings)0;
                output.positionCS = input.positionCS;
                output.positionWS = input.interp00.xyz;
                output.normalWS = input.interp01.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
            {
                VertexDescriptionInputs output;
                ZERO_INITIALIZE(VertexDescriptionInputs, output);
            
                output.ObjectSpaceNormal =           input.normalOS;
                output.ObjectSpaceTangent =          input.tangentOS;
                output.ObjectSpacePosition =         input.positionOS;
            
                return output;
            }
            
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
            	// must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            	float3 unnormalizedNormalWS = input.normalWS;
                const float renormFactor = 1.0 / length(unnormalizedNormalWS);
            
            
                output.WorldSpaceNormal =            renormFactor*input.normalWS.xyz;		// we want a unit length Normal Vector node in shader graph
            
            
                output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(input.positionWS);
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
            #else
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            #endif
            #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            
                return output;
            }
            
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"
        
            ENDHLSL
        }
        
        Pass
        {
            Name "DepthOnly"
            Tags 
            { 
                "LightMode" = "DepthOnly"
            }
           
            // Render State
            Blend One Zero, One Zero
            Cull Back
            ZTest LEqual
            ZWrite On
            ColorMask 0
            
        
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            // Pragmas
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            #pragma target 2.0
            #pragma multi_compile_instancing
        
            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>
            
            // Defines
            #define _AlphaClip 1
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define VARYINGS_NEED_POSITION_WS 
            #define VARYINGS_NEED_NORMAL_WS
            #define FEATURES_GRAPH_VERTEX
            #pragma multi_compile_instancing
            #define UNITY_DOTS_SHADER
            #pragma instancing_options nolightprobe
            #pragma instancing_options nolodfade
            #define SHADERPASS_DEPTHONLY
            
        
            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariablesFunctions.hlsl"
        
            // --------------------------------------------------
            // Graph
        
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
            float _AlphaCutoff;
            float4 _BaseColor;
            float4 _BaseTilingOffset;
            float _BaseTriplanarThreshold;
            float _BaseNormalScale;
            float _BaseMetallic;
            float _BaseAORemapMin;
            float _BaseAORemapMax;
            float _BaseSmoothnessRemapMin;
            float _BaseSmoothnessRemapMax;
            float _Invert_Layer_Mask;
            float _Height_Transition;
            float _HeightMin;
            float _HeightMax;
            float _HeightOffset;
            float _HeightMin2;
            float _HeightMax2;
            float _HeightOffset2;
            float4 _Base2Color;
            float4 _Base2TilingOffset;
            float _Base2TriplanarThreshold;
            float _Base2NormalScale;
            float _Base2Metallic;
            float _Base2SmoothnessRemapMin;
            float _Base2SmoothnessRemapMax;
            float _Base2AORemapMin;
            float _Base2AORemapMax;
            float4 _WetColor;
            float _WetSmoothness;
            CBUFFER_END
            TEXTURE2D(_BaseColorMap); SAMPLER(sampler_BaseColorMap); float4 _BaseColorMap_TexelSize;
            TEXTURE2D(_BaseNormalMap); SAMPLER(sampler_BaseNormalMap); float4 _BaseNormalMap_TexelSize;
            TEXTURE2D(_BaseMaskMap); SAMPLER(sampler_BaseMaskMap); float4 _BaseMaskMap_TexelSize;
            TEXTURE2D(_LayerMask); SAMPLER(sampler_LayerMask); float4 _LayerMask_TexelSize;
            TEXTURE2D(_Base2ColorMap); SAMPLER(sampler_Base2ColorMap); float4 _Base2ColorMap_TexelSize;
            TEXTURE2D(_Base2NormalMap); SAMPLER(sampler_Base2NormalMap); float4 _Base2NormalMap_TexelSize;
            TEXTURE2D(_Base2MaskMap); SAMPLER(sampler_Base2MaskMap); float4 _Base2MaskMap_TexelSize;
            SAMPLER(_SampleTexture2D_AF934D9A_Sampler_3_Linear_Repeat);
            SAMPLER(_SampleTexture2D_66E4959F_Sampler_3_Linear_Repeat);
            SAMPLER(_SampleTexture2D_96366F41_Sampler_3_Linear_Repeat);
        
            // Graph Functions
            
            // 0ff7b9db8f55df06fc08dc990cfb397e
            #include "Assets/NatureManufacture Assets/Object Shaders/NM_Object_VSPro_Indirect.cginc"
            
            void AddPragma_float(float3 A, out float3 Out)
            {
                #pragma instancing_options renderinglayer procedural:setupVSPro
                Out = A;
            }
            
            struct Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b
            {
            };
            
            void SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b(float3 Vector3_314C8600, Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b IN, out float3 ObjectSpacePosition_1)
            {
                float3 _Property_AF5E8C93_Out_0 = Vector3_314C8600;
                float3 _CustomFunction_E07FEE57_Out_1;
                InjectSetup_float(_Property_AF5E8C93_Out_0, _CustomFunction_E07FEE57_Out_1);
                float3 _CustomFunction_18EFD858_Out_1;
                AddPragma_float(_CustomFunction_E07FEE57_Out_1, _CustomFunction_18EFD858_Out_1);
                ObjectSpacePosition_1 = _CustomFunction_18EFD858_Out_1;
            }
            
            void Unity_Divide_float4(float4 A, float4 B, out float4 Out)
            {
                Out = A / B;
            }
            
            void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
            {
                RGBA = float4(R, G, B, A);
                RGB = float3(R, G, B);
                RG = float2(R, G);
            }
            
            void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
            {
                Out = A * B;
            }
            
            void Unity_Sign_float3(float3 In, out float3 Out)
            {
                Out = sign(In);
            }
            
            void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
            {
                Out = A * B;
            }
            
            void Unity_Absolute_float3(float3 In, out float3 Out)
            {
                Out = abs(In);
            }
            
            void Unity_Power_float3(float3 A, float3 B, out float3 Out)
            {
                Out = pow(A, B);
            }
            
            void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
            {
                Out = A * B;
            }
            
            void Unity_Multiply_float(float A, float B, out float Out)
            {
                Out = A * B;
            }
            
            void Unity_Add_float4(float4 A, float4 B, out float4 Out)
            {
                Out = A + B;
            }
            
            void Unity_Add_float(float A, float B, out float Out)
            {
                Out = A + B;
            }
            
            struct Bindings_TriplanarNM_bc609ed95f52591469ab35dbfe0efcea
            {
                float3 WorldSpaceNormal;
                float3 AbsoluteWorldSpacePosition;
            };
            
            void SG_TriplanarNM_bc609ed95f52591469ab35dbfe0efcea(TEXTURE2D_PARAM(Texture2D_80A3D28F, samplerTexture2D_80A3D28F), float4 Texture2D_80A3D28F_TexelSize, float Vector1_41461AC9, float Vector1_E4D1C13A, Bindings_TriplanarNM_bc609ed95f52591469ab35dbfe0efcea IN, out float4 XYZ_1, out float4 XZ_2, out float4 YZ_3, out float4 XY_4)
            {
                float _Split_34F118DC_R_1 = IN.AbsoluteWorldSpacePosition[0];
                float _Split_34F118DC_G_2 = IN.AbsoluteWorldSpacePosition[1];
                float _Split_34F118DC_B_3 = IN.AbsoluteWorldSpacePosition[2];
                float _Split_34F118DC_A_4 = 0;
                float4 _Combine_FDBD63CA_RGBA_4;
                float3 _Combine_FDBD63CA_RGB_5;
                float2 _Combine_FDBD63CA_RG_6;
                Unity_Combine_float(_Split_34F118DC_R_1, _Split_34F118DC_B_3, 0, 0, _Combine_FDBD63CA_RGBA_4, _Combine_FDBD63CA_RGB_5, _Combine_FDBD63CA_RG_6);
                float _Property_7A4DC59B_Out_0 = Vector1_41461AC9;
                float4 _Multiply_D99671F1_Out_2;
                Unity_Multiply_float(_Combine_FDBD63CA_RGBA_4, (_Property_7A4DC59B_Out_0.xxxx), _Multiply_D99671F1_Out_2);
                float3 _Sign_C0850857_Out_1;
                Unity_Sign_float3(IN.WorldSpaceNormal, _Sign_C0850857_Out_1);
                float _Split_EEBC69B5_R_1 = _Sign_C0850857_Out_1[0];
                float _Split_EEBC69B5_G_2 = _Sign_C0850857_Out_1[1];
                float _Split_EEBC69B5_B_3 = _Sign_C0850857_Out_1[2];
                float _Split_EEBC69B5_A_4 = 0;
                float2 _Vector2_7598EA98_Out_0 = float2(_Split_EEBC69B5_G_2, 1);
                float2 _Multiply_F82F3FE2_Out_2;
                Unity_Multiply_float((_Multiply_D99671F1_Out_2.xy), _Vector2_7598EA98_Out_0, _Multiply_F82F3FE2_Out_2);
                float4 _SampleTexture2D_AF934D9A_RGBA_0 = SAMPLE_TEXTURE2D(Texture2D_80A3D28F, samplerTexture2D_80A3D28F, _Multiply_F82F3FE2_Out_2);
                float _SampleTexture2D_AF934D9A_R_4 = _SampleTexture2D_AF934D9A_RGBA_0.r;
                float _SampleTexture2D_AF934D9A_G_5 = _SampleTexture2D_AF934D9A_RGBA_0.g;
                float _SampleTexture2D_AF934D9A_B_6 = _SampleTexture2D_AF934D9A_RGBA_0.b;
                float _SampleTexture2D_AF934D9A_A_7 = _SampleTexture2D_AF934D9A_RGBA_0.a;
                float3 _Absolute_FF95EDEB_Out_1;
                Unity_Absolute_float3(IN.WorldSpaceNormal, _Absolute_FF95EDEB_Out_1);
                float _Property_F8688E0_Out_0 = Vector1_E4D1C13A;
                float3 _Power_C741CD3A_Out_2;
                Unity_Power_float3(_Absolute_FF95EDEB_Out_1, (_Property_F8688E0_Out_0.xxx), _Power_C741CD3A_Out_2);
                float3 _Multiply_3FB4A346_Out_2;
                Unity_Multiply_float(_Power_C741CD3A_Out_2, _Power_C741CD3A_Out_2, _Multiply_3FB4A346_Out_2);
                float _Split_98088E33_R_1 = _Multiply_3FB4A346_Out_2[0];
                float _Split_98088E33_G_2 = _Multiply_3FB4A346_Out_2[1];
                float _Split_98088E33_B_3 = _Multiply_3FB4A346_Out_2[2];
                float _Split_98088E33_A_4 = 0;
                float4 _Multiply_B99FFB12_Out_2;
                Unity_Multiply_float(_SampleTexture2D_AF934D9A_RGBA_0, (_Split_98088E33_G_2.xxxx), _Multiply_B99FFB12_Out_2);
                float4 _Combine_EAF808EA_RGBA_4;
                float3 _Combine_EAF808EA_RGB_5;
                float2 _Combine_EAF808EA_RG_6;
                Unity_Combine_float(_Split_34F118DC_R_1, _Split_34F118DC_G_2, 0, 0, _Combine_EAF808EA_RGBA_4, _Combine_EAF808EA_RGB_5, _Combine_EAF808EA_RG_6);
                float4 _Multiply_9B855117_Out_2;
                Unity_Multiply_float(_Combine_EAF808EA_RGBA_4, (_Property_7A4DC59B_Out_0.xxxx), _Multiply_9B855117_Out_2);
                float _Multiply_B8AC16FB_Out_2;
                Unity_Multiply_float(_Split_EEBC69B5_B_3, -1, _Multiply_B8AC16FB_Out_2);
                float2 _Vector2_F031282A_Out_0 = float2(_Multiply_B8AC16FB_Out_2, 1);
                float2 _Multiply_89A39D70_Out_2;
                Unity_Multiply_float((_Multiply_9B855117_Out_2.xy), _Vector2_F031282A_Out_0, _Multiply_89A39D70_Out_2);
                float4 _SampleTexture2D_66E4959F_RGBA_0 = SAMPLE_TEXTURE2D(Texture2D_80A3D28F, samplerTexture2D_80A3D28F, _Multiply_89A39D70_Out_2);
                float _SampleTexture2D_66E4959F_R_4 = _SampleTexture2D_66E4959F_RGBA_0.r;
                float _SampleTexture2D_66E4959F_G_5 = _SampleTexture2D_66E4959F_RGBA_0.g;
                float _SampleTexture2D_66E4959F_B_6 = _SampleTexture2D_66E4959F_RGBA_0.b;
                float _SampleTexture2D_66E4959F_A_7 = _SampleTexture2D_66E4959F_RGBA_0.a;
                float4 _Multiply_9E620CB9_Out_2;
                Unity_Multiply_float(_SampleTexture2D_66E4959F_RGBA_0, (_Split_98088E33_B_3.xxxx), _Multiply_9E620CB9_Out_2);
                float4 _Combine_D494A8E_RGBA_4;
                float3 _Combine_D494A8E_RGB_5;
                float2 _Combine_D494A8E_RG_6;
                Unity_Combine_float(_Split_34F118DC_B_3, _Split_34F118DC_G_2, 0, 0, _Combine_D494A8E_RGBA_4, _Combine_D494A8E_RGB_5, _Combine_D494A8E_RG_6);
                float4 _Multiply_1B29A9F1_Out_2;
                Unity_Multiply_float(_Combine_D494A8E_RGBA_4, (_Property_7A4DC59B_Out_0.xxxx), _Multiply_1B29A9F1_Out_2);
                float2 _Vector2_1F147BEC_Out_0 = float2(_Split_EEBC69B5_R_1, 1);
                float2 _Multiply_5B8B54E9_Out_2;
                Unity_Multiply_float((_Multiply_1B29A9F1_Out_2.xy), _Vector2_1F147BEC_Out_0, _Multiply_5B8B54E9_Out_2);
                float4 _SampleTexture2D_96366F41_RGBA_0 = SAMPLE_TEXTURE2D(Texture2D_80A3D28F, samplerTexture2D_80A3D28F, _Multiply_5B8B54E9_Out_2);
                float _SampleTexture2D_96366F41_R_4 = _SampleTexture2D_96366F41_RGBA_0.r;
                float _SampleTexture2D_96366F41_G_5 = _SampleTexture2D_96366F41_RGBA_0.g;
                float _SampleTexture2D_96366F41_B_6 = _SampleTexture2D_96366F41_RGBA_0.b;
                float _SampleTexture2D_96366F41_A_7 = _SampleTexture2D_96366F41_RGBA_0.a;
                float4 _Multiply_1C5CFCC5_Out_2;
                Unity_Multiply_float(_SampleTexture2D_96366F41_RGBA_0, (_Split_98088E33_R_1.xxxx), _Multiply_1C5CFCC5_Out_2);
                float4 _Add_D483B2FD_Out_2;
                Unity_Add_float4(_Multiply_9E620CB9_Out_2, _Multiply_1C5CFCC5_Out_2, _Add_D483B2FD_Out_2);
                float4 _Add_166B5BED_Out_2;
                Unity_Add_float4(_Multiply_B99FFB12_Out_2, _Add_D483B2FD_Out_2, _Add_166B5BED_Out_2);
                float _Add_B73B64F6_Out_2;
                Unity_Add_float(_Split_98088E33_R_1, _Split_98088E33_G_2, _Add_B73B64F6_Out_2);
                float _Add_523B36E8_Out_2;
                Unity_Add_float(_Add_B73B64F6_Out_2, _Split_98088E33_B_3, _Add_523B36E8_Out_2);
                float4 _Divide_86C67C72_Out_2;
                Unity_Divide_float4(_Add_166B5BED_Out_2, (_Add_523B36E8_Out_2.xxxx), _Divide_86C67C72_Out_2);
                XYZ_1 = _Divide_86C67C72_Out_2;
                XZ_2 = _SampleTexture2D_AF934D9A_RGBA_0;
                YZ_3 = _SampleTexture2D_66E4959F_RGBA_0;
                XY_4 = _SampleTexture2D_96366F41_RGBA_0;
            }
        
            // Graph Vertex
            struct VertexDescriptionInputs
            {
                float3 ObjectSpaceNormal;
                float3 ObjectSpaceTangent;
                float3 ObjectSpacePosition;
            };
            
            struct VertexDescription
            {
                float3 VertexPosition;
                float3 VertexNormal;
                float3 VertexTangent;
            };
            
            VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
            {
                VertexDescription description = (VertexDescription)0;
                Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b _NMObjectVSProIndirect_6D18728A;
                float3 _NMObjectVSProIndirect_6D18728A_ObjectSpacePosition_1;
                SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b(IN.ObjectSpacePosition, _NMObjectVSProIndirect_6D18728A, _NMObjectVSProIndirect_6D18728A_ObjectSpacePosition_1);
                description.VertexPosition = _NMObjectVSProIndirect_6D18728A_ObjectSpacePosition_1;
                description.VertexNormal = IN.ObjectSpaceNormal;
                description.VertexTangent = IN.ObjectSpaceTangent;
                return description;
            }
            
            // Graph Pixel
            struct SurfaceDescriptionInputs
            {
                float3 WorldSpaceNormal;
                float3 AbsoluteWorldSpacePosition;
            };
            
            struct SurfaceDescription
            {
                float Alpha;
                float AlphaClipThreshold;
            };
            
            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
            {
                SurfaceDescription surface = (SurfaceDescription)0;
                float4 _Property_B8B9BCEA_Out_0 = _BaseTilingOffset;
                float4 _Divide_4D76B006_Out_2;
                Unity_Divide_float4(float4(1, 1, 0, 0), _Property_B8B9BCEA_Out_0, _Divide_4D76B006_Out_2);
                float _Property_7D01357A_Out_0 = _BaseTriplanarThreshold;
                Bindings_TriplanarNM_bc609ed95f52591469ab35dbfe0efcea _TriplanarNM_E18E8AC;
                _TriplanarNM_E18E8AC.WorldSpaceNormal = IN.WorldSpaceNormal;
                _TriplanarNM_E18E8AC.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
                float4 _TriplanarNM_E18E8AC_XYZ_1;
                float4 _TriplanarNM_E18E8AC_XZ_2;
                float4 _TriplanarNM_E18E8AC_YZ_3;
                float4 _TriplanarNM_E18E8AC_XY_4;
                SG_TriplanarNM_bc609ed95f52591469ab35dbfe0efcea(TEXTURE2D_ARGS(_BaseColorMap, sampler_BaseColorMap), _BaseColorMap_TexelSize, (_Divide_4D76B006_Out_2).x, _Property_7D01357A_Out_0, _TriplanarNM_E18E8AC, _TriplanarNM_E18E8AC_XYZ_1, _TriplanarNM_E18E8AC_XZ_2, _TriplanarNM_E18E8AC_YZ_3, _TriplanarNM_E18E8AC_XY_4);
                float _Split_F7C504B3_R_1 = _TriplanarNM_E18E8AC_XYZ_1[0];
                float _Split_F7C504B3_G_2 = _TriplanarNM_E18E8AC_XYZ_1[1];
                float _Split_F7C504B3_B_3 = _TriplanarNM_E18E8AC_XYZ_1[2];
                float _Split_F7C504B3_A_4 = _TriplanarNM_E18E8AC_XYZ_1[3];
                float _Property_5761B808_Out_0 = _AlphaCutoff;
                surface.Alpha = _Split_F7C504B3_A_4;
                surface.AlphaClipThreshold = _Property_5761B808_Out_0;
                return surface;
            }
        
            // --------------------------------------------------
            // Structs and Packing
        
            // Generated Type: Attributes
            struct Attributes
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif
            };
        
            // Generated Type: Varyings
            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float3 positionWS;
                float3 normalWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Generated Type: PackedVaryings
            struct PackedVaryings
            {
                float4 positionCS : SV_POSITION;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                float3 interp00 : TEXCOORD0;
                float3 interp01 : TEXCOORD1;
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Packed Type: Varyings
            PackedVaryings PackVaryings(Varyings input)
            {
                PackedVaryings output = (PackedVaryings)0;
                output.positionCS = input.positionCS;
                output.interp00.xyz = input.positionWS;
                output.interp01.xyz = input.normalWS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }
            
            // Unpacked Type: Varyings
            Varyings UnpackVaryings(PackedVaryings input)
            {
                Varyings output = (Varyings)0;
                output.positionCS = input.positionCS;
                output.positionWS = input.interp00.xyz;
                output.normalWS = input.interp01.xyz;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
            {
                VertexDescriptionInputs output;
                ZERO_INITIALIZE(VertexDescriptionInputs, output);
            
                output.ObjectSpaceNormal =           input.normalOS;
                output.ObjectSpaceTangent =          input.tangentOS;
                output.ObjectSpacePosition =         input.positionOS;
            
                return output;
            }
            
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
            	// must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            	float3 unnormalizedNormalWS = input.normalWS;
                const float renormFactor = 1.0 / length(unnormalizedNormalWS);
            
            
                output.WorldSpaceNormal =            renormFactor*input.normalWS.xyz;		// we want a unit length Normal Vector node in shader graph
            
            
                output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(input.positionWS);
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
            #else
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            #endif
            #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            
                return output;
            }
            
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"
        
            ENDHLSL
        }
        
        Pass
        {
            Name "Meta"
            Tags 
            { 
                "LightMode" = "Meta"
            }
           
            // Render State
            Blend One Zero, One Zero
            Cull Back
            ZTest LEqual
            ZWrite On
            // ColorMask: <None>
            
        
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            // Pragmas
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            #pragma target 2.0
        
            // Keywords
            #pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
            // GraphKeywords: <None>
            
            // Defines
            #define _AlphaClip 1
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define ATTRIBUTES_NEED_TEXCOORD2
            #define ATTRIBUTES_NEED_COLOR
            #define VARYINGS_NEED_POSITION_WS 
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_COLOR
            #define FEATURES_GRAPH_VERTEX
            #pragma multi_compile_instancing
            #define UNITY_DOTS_SHADER
            #pragma instancing_options nolightprobe
            #pragma instancing_options nolodfade
            #define SHADERPASS_META
            
        
            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
            #include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariablesFunctions.hlsl"
        
            // --------------------------------------------------
            // Graph
        
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
            float _AlphaCutoff;
            float4 _BaseColor;
            float4 _BaseTilingOffset;
            float _BaseTriplanarThreshold;
            float _BaseNormalScale;
            float _BaseMetallic;
            float _BaseAORemapMin;
            float _BaseAORemapMax;
            float _BaseSmoothnessRemapMin;
            float _BaseSmoothnessRemapMax;
            float _Invert_Layer_Mask;
            float _Height_Transition;
            float _HeightMin;
            float _HeightMax;
            float _HeightOffset;
            float _HeightMin2;
            float _HeightMax2;
            float _HeightOffset2;
            float4 _Base2Color;
            float4 _Base2TilingOffset;
            float _Base2TriplanarThreshold;
            float _Base2NormalScale;
            float _Base2Metallic;
            float _Base2SmoothnessRemapMin;
            float _Base2SmoothnessRemapMax;
            float _Base2AORemapMin;
            float _Base2AORemapMax;
            float4 _WetColor;
            float _WetSmoothness;
            CBUFFER_END
            TEXTURE2D(_BaseColorMap); SAMPLER(sampler_BaseColorMap); float4 _BaseColorMap_TexelSize;
            TEXTURE2D(_BaseNormalMap); SAMPLER(sampler_BaseNormalMap); float4 _BaseNormalMap_TexelSize;
            TEXTURE2D(_BaseMaskMap); SAMPLER(sampler_BaseMaskMap); float4 _BaseMaskMap_TexelSize;
            TEXTURE2D(_LayerMask); SAMPLER(sampler_LayerMask); float4 _LayerMask_TexelSize;
            TEXTURE2D(_Base2ColorMap); SAMPLER(sampler_Base2ColorMap); float4 _Base2ColorMap_TexelSize;
            TEXTURE2D(_Base2NormalMap); SAMPLER(sampler_Base2NormalMap); float4 _Base2NormalMap_TexelSize;
            TEXTURE2D(_Base2MaskMap); SAMPLER(sampler_Base2MaskMap); float4 _Base2MaskMap_TexelSize;
            SAMPLER(_SampleTexture2D_AF934D9A_Sampler_3_Linear_Repeat);
            SAMPLER(_SampleTexture2D_66E4959F_Sampler_3_Linear_Repeat);
            SAMPLER(_SampleTexture2D_96366F41_Sampler_3_Linear_Repeat);
            SAMPLER(_SampleTexture2D_6C16A06F_Sampler_3_Linear_Repeat);
        
            // Graph Functions
            
            // 0ff7b9db8f55df06fc08dc990cfb397e
            #include "Assets/NatureManufacture Assets/Object Shaders/NM_Object_VSPro_Indirect.cginc"
            
            void AddPragma_float(float3 A, out float3 Out)
            {
                #pragma instancing_options renderinglayer procedural:setupVSPro
                Out = A;
            }
            
            struct Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b
            {
            };
            
            void SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b(float3 Vector3_314C8600, Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b IN, out float3 ObjectSpacePosition_1)
            {
                float3 _Property_AF5E8C93_Out_0 = Vector3_314C8600;
                float3 _CustomFunction_E07FEE57_Out_1;
                InjectSetup_float(_Property_AF5E8C93_Out_0, _CustomFunction_E07FEE57_Out_1);
                float3 _CustomFunction_18EFD858_Out_1;
                AddPragma_float(_CustomFunction_E07FEE57_Out_1, _CustomFunction_18EFD858_Out_1);
                ObjectSpacePosition_1 = _CustomFunction_18EFD858_Out_1;
            }
            
            void Unity_Divide_float4(float4 A, float4 B, out float4 Out)
            {
                Out = A / B;
            }
            
            void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
            {
                RGBA = float4(R, G, B, A);
                RGB = float3(R, G, B);
                RG = float2(R, G);
            }
            
            void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
            {
                Out = A * B;
            }
            
            void Unity_Sign_float3(float3 In, out float3 Out)
            {
                Out = sign(In);
            }
            
            void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
            {
                Out = A * B;
            }
            
            void Unity_Absolute_float3(float3 In, out float3 Out)
            {
                Out = abs(In);
            }
            
            void Unity_Power_float3(float3 A, float3 B, out float3 Out)
            {
                Out = pow(A, B);
            }
            
            void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
            {
                Out = A * B;
            }
            
            void Unity_Multiply_float(float A, float B, out float Out)
            {
                Out = A * B;
            }
            
            void Unity_Add_float4(float4 A, float4 B, out float4 Out)
            {
                Out = A + B;
            }
            
            void Unity_Add_float(float A, float B, out float Out)
            {
                Out = A + B;
            }
            
            struct Bindings_TriplanarNM_bc609ed95f52591469ab35dbfe0efcea
            {
                float3 WorldSpaceNormal;
                float3 AbsoluteWorldSpacePosition;
            };
            
            void SG_TriplanarNM_bc609ed95f52591469ab35dbfe0efcea(TEXTURE2D_PARAM(Texture2D_80A3D28F, samplerTexture2D_80A3D28F), float4 Texture2D_80A3D28F_TexelSize, float Vector1_41461AC9, float Vector1_E4D1C13A, Bindings_TriplanarNM_bc609ed95f52591469ab35dbfe0efcea IN, out float4 XYZ_1, out float4 XZ_2, out float4 YZ_3, out float4 XY_4)
            {
                float _Split_34F118DC_R_1 = IN.AbsoluteWorldSpacePosition[0];
                float _Split_34F118DC_G_2 = IN.AbsoluteWorldSpacePosition[1];
                float _Split_34F118DC_B_3 = IN.AbsoluteWorldSpacePosition[2];
                float _Split_34F118DC_A_4 = 0;
                float4 _Combine_FDBD63CA_RGBA_4;
                float3 _Combine_FDBD63CA_RGB_5;
                float2 _Combine_FDBD63CA_RG_6;
                Unity_Combine_float(_Split_34F118DC_R_1, _Split_34F118DC_B_3, 0, 0, _Combine_FDBD63CA_RGBA_4, _Combine_FDBD63CA_RGB_5, _Combine_FDBD63CA_RG_6);
                float _Property_7A4DC59B_Out_0 = Vector1_41461AC9;
                float4 _Multiply_D99671F1_Out_2;
                Unity_Multiply_float(_Combine_FDBD63CA_RGBA_4, (_Property_7A4DC59B_Out_0.xxxx), _Multiply_D99671F1_Out_2);
                float3 _Sign_C0850857_Out_1;
                Unity_Sign_float3(IN.WorldSpaceNormal, _Sign_C0850857_Out_1);
                float _Split_EEBC69B5_R_1 = _Sign_C0850857_Out_1[0];
                float _Split_EEBC69B5_G_2 = _Sign_C0850857_Out_1[1];
                float _Split_EEBC69B5_B_3 = _Sign_C0850857_Out_1[2];
                float _Split_EEBC69B5_A_4 = 0;
                float2 _Vector2_7598EA98_Out_0 = float2(_Split_EEBC69B5_G_2, 1);
                float2 _Multiply_F82F3FE2_Out_2;
                Unity_Multiply_float((_Multiply_D99671F1_Out_2.xy), _Vector2_7598EA98_Out_0, _Multiply_F82F3FE2_Out_2);
                float4 _SampleTexture2D_AF934D9A_RGBA_0 = SAMPLE_TEXTURE2D(Texture2D_80A3D28F, samplerTexture2D_80A3D28F, _Multiply_F82F3FE2_Out_2);
                float _SampleTexture2D_AF934D9A_R_4 = _SampleTexture2D_AF934D9A_RGBA_0.r;
                float _SampleTexture2D_AF934D9A_G_5 = _SampleTexture2D_AF934D9A_RGBA_0.g;
                float _SampleTexture2D_AF934D9A_B_6 = _SampleTexture2D_AF934D9A_RGBA_0.b;
                float _SampleTexture2D_AF934D9A_A_7 = _SampleTexture2D_AF934D9A_RGBA_0.a;
                float3 _Absolute_FF95EDEB_Out_1;
                Unity_Absolute_float3(IN.WorldSpaceNormal, _Absolute_FF95EDEB_Out_1);
                float _Property_F8688E0_Out_0 = Vector1_E4D1C13A;
                float3 _Power_C741CD3A_Out_2;
                Unity_Power_float3(_Absolute_FF95EDEB_Out_1, (_Property_F8688E0_Out_0.xxx), _Power_C741CD3A_Out_2);
                float3 _Multiply_3FB4A346_Out_2;
                Unity_Multiply_float(_Power_C741CD3A_Out_2, _Power_C741CD3A_Out_2, _Multiply_3FB4A346_Out_2);
                float _Split_98088E33_R_1 = _Multiply_3FB4A346_Out_2[0];
                float _Split_98088E33_G_2 = _Multiply_3FB4A346_Out_2[1];
                float _Split_98088E33_B_3 = _Multiply_3FB4A346_Out_2[2];
                float _Split_98088E33_A_4 = 0;
                float4 _Multiply_B99FFB12_Out_2;
                Unity_Multiply_float(_SampleTexture2D_AF934D9A_RGBA_0, (_Split_98088E33_G_2.xxxx), _Multiply_B99FFB12_Out_2);
                float4 _Combine_EAF808EA_RGBA_4;
                float3 _Combine_EAF808EA_RGB_5;
                float2 _Combine_EAF808EA_RG_6;
                Unity_Combine_float(_Split_34F118DC_R_1, _Split_34F118DC_G_2, 0, 0, _Combine_EAF808EA_RGBA_4, _Combine_EAF808EA_RGB_5, _Combine_EAF808EA_RG_6);
                float4 _Multiply_9B855117_Out_2;
                Unity_Multiply_float(_Combine_EAF808EA_RGBA_4, (_Property_7A4DC59B_Out_0.xxxx), _Multiply_9B855117_Out_2);
                float _Multiply_B8AC16FB_Out_2;
                Unity_Multiply_float(_Split_EEBC69B5_B_3, -1, _Multiply_B8AC16FB_Out_2);
                float2 _Vector2_F031282A_Out_0 = float2(_Multiply_B8AC16FB_Out_2, 1);
                float2 _Multiply_89A39D70_Out_2;
                Unity_Multiply_float((_Multiply_9B855117_Out_2.xy), _Vector2_F031282A_Out_0, _Multiply_89A39D70_Out_2);
                float4 _SampleTexture2D_66E4959F_RGBA_0 = SAMPLE_TEXTURE2D(Texture2D_80A3D28F, samplerTexture2D_80A3D28F, _Multiply_89A39D70_Out_2);
                float _SampleTexture2D_66E4959F_R_4 = _SampleTexture2D_66E4959F_RGBA_0.r;
                float _SampleTexture2D_66E4959F_G_5 = _SampleTexture2D_66E4959F_RGBA_0.g;
                float _SampleTexture2D_66E4959F_B_6 = _SampleTexture2D_66E4959F_RGBA_0.b;
                float _SampleTexture2D_66E4959F_A_7 = _SampleTexture2D_66E4959F_RGBA_0.a;
                float4 _Multiply_9E620CB9_Out_2;
                Unity_Multiply_float(_SampleTexture2D_66E4959F_RGBA_0, (_Split_98088E33_B_3.xxxx), _Multiply_9E620CB9_Out_2);
                float4 _Combine_D494A8E_RGBA_4;
                float3 _Combine_D494A8E_RGB_5;
                float2 _Combine_D494A8E_RG_6;
                Unity_Combine_float(_Split_34F118DC_B_3, _Split_34F118DC_G_2, 0, 0, _Combine_D494A8E_RGBA_4, _Combine_D494A8E_RGB_5, _Combine_D494A8E_RG_6);
                float4 _Multiply_1B29A9F1_Out_2;
                Unity_Multiply_float(_Combine_D494A8E_RGBA_4, (_Property_7A4DC59B_Out_0.xxxx), _Multiply_1B29A9F1_Out_2);
                float2 _Vector2_1F147BEC_Out_0 = float2(_Split_EEBC69B5_R_1, 1);
                float2 _Multiply_5B8B54E9_Out_2;
                Unity_Multiply_float((_Multiply_1B29A9F1_Out_2.xy), _Vector2_1F147BEC_Out_0, _Multiply_5B8B54E9_Out_2);
                float4 _SampleTexture2D_96366F41_RGBA_0 = SAMPLE_TEXTURE2D(Texture2D_80A3D28F, samplerTexture2D_80A3D28F, _Multiply_5B8B54E9_Out_2);
                float _SampleTexture2D_96366F41_R_4 = _SampleTexture2D_96366F41_RGBA_0.r;
                float _SampleTexture2D_96366F41_G_5 = _SampleTexture2D_96366F41_RGBA_0.g;
                float _SampleTexture2D_96366F41_B_6 = _SampleTexture2D_96366F41_RGBA_0.b;
                float _SampleTexture2D_96366F41_A_7 = _SampleTexture2D_96366F41_RGBA_0.a;
                float4 _Multiply_1C5CFCC5_Out_2;
                Unity_Multiply_float(_SampleTexture2D_96366F41_RGBA_0, (_Split_98088E33_R_1.xxxx), _Multiply_1C5CFCC5_Out_2);
                float4 _Add_D483B2FD_Out_2;
                Unity_Add_float4(_Multiply_9E620CB9_Out_2, _Multiply_1C5CFCC5_Out_2, _Add_D483B2FD_Out_2);
                float4 _Add_166B5BED_Out_2;
                Unity_Add_float4(_Multiply_B99FFB12_Out_2, _Add_D483B2FD_Out_2, _Add_166B5BED_Out_2);
                float _Add_B73B64F6_Out_2;
                Unity_Add_float(_Split_98088E33_R_1, _Split_98088E33_G_2, _Add_B73B64F6_Out_2);
                float _Add_523B36E8_Out_2;
                Unity_Add_float(_Add_B73B64F6_Out_2, _Split_98088E33_B_3, _Add_523B36E8_Out_2);
                float4 _Divide_86C67C72_Out_2;
                Unity_Divide_float4(_Add_166B5BED_Out_2, (_Add_523B36E8_Out_2.xxxx), _Divide_86C67C72_Out_2);
                XYZ_1 = _Divide_86C67C72_Out_2;
                XZ_2 = _SampleTexture2D_AF934D9A_RGBA_0;
                YZ_3 = _SampleTexture2D_66E4959F_RGBA_0;
                XY_4 = _SampleTexture2D_96366F41_RGBA_0;
            }
            
            void Unity_Add_float2(float2 A, float2 B, out float2 Out)
            {
                Out = A + B;
            }
            
            void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
            {
                Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
            }
            
            void Unity_OneMinus_float(float In, out float Out)
            {
                Out = 1 - In;
            }
            
            void Unity_Branch_float(float Predicate, float True, float False, out float Out)
            {
                Out = Predicate ? True : False;
            }
            
            void Unity_Maximum_float(float A, float B, out float Out)
            {
                Out = max(A, B);
            }
            
            void Unity_Subtract_float(float A, float B, out float Out)
            {
                Out = A - B;
            }
            
            void Unity_Add_float3(float3 A, float3 B, out float3 Out)
            {
                Out = A + B;
            }
            
            void Unity_Divide_float3(float3 A, float3 B, out float3 Out)
            {
                Out = A / B;
            }
            
            struct Bindings_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135
            {
            };
            
            void SG_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135(float3 Vector3_88EEBB5E, float Vector1_DA0A37FA, float3 Vector3_79AA92F, float Vector1_F7E83F1E, float Vector1_1C9222A6, Bindings_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135 IN, out float3 OutVector4_1)
            {
                float3 _Property_CE7501EE_Out_0 = Vector3_88EEBB5E;
                float _Property_21A77CD2_Out_0 = Vector1_DA0A37FA;
                float _Property_B0F6C734_Out_0 = Vector1_DA0A37FA;
                float _Property_F32C0509_Out_0 = Vector1_F7E83F1E;
                float _Maximum_2C42CE33_Out_2;
                Unity_Maximum_float(_Property_B0F6C734_Out_0, _Property_F32C0509_Out_0, _Maximum_2C42CE33_Out_2);
                float _Property_FBC3A76E_Out_0 = Vector1_1C9222A6;
                float _Subtract_5E32B1F2_Out_2;
                Unity_Subtract_float(_Maximum_2C42CE33_Out_2, _Property_FBC3A76E_Out_0, _Subtract_5E32B1F2_Out_2);
                float _Subtract_AE0D0FB3_Out_2;
                Unity_Subtract_float(_Property_21A77CD2_Out_0, _Subtract_5E32B1F2_Out_2, _Subtract_AE0D0FB3_Out_2);
                float _Maximum_B94A8EBA_Out_2;
                Unity_Maximum_float(_Subtract_AE0D0FB3_Out_2, 0, _Maximum_B94A8EBA_Out_2);
                float3 _Multiply_6D1F195B_Out_2;
                Unity_Multiply_float(_Property_CE7501EE_Out_0, (_Maximum_B94A8EBA_Out_2.xxx), _Multiply_6D1F195B_Out_2);
                float3 _Property_94C053EA_Out_0 = Vector3_79AA92F;
                float _Property_B5C791CC_Out_0 = Vector1_F7E83F1E;
                float _Subtract_5DDA2278_Out_2;
                Unity_Subtract_float(_Property_B5C791CC_Out_0, _Subtract_5E32B1F2_Out_2, _Subtract_5DDA2278_Out_2);
                float _Maximum_3087B5D0_Out_2;
                Unity_Maximum_float(_Subtract_5DDA2278_Out_2, 0, _Maximum_3087B5D0_Out_2);
                float3 _Multiply_61466A85_Out_2;
                Unity_Multiply_float(_Property_94C053EA_Out_0, (_Maximum_3087B5D0_Out_2.xxx), _Multiply_61466A85_Out_2);
                float3 _Add_87880A51_Out_2;
                Unity_Add_float3(_Multiply_6D1F195B_Out_2, _Multiply_61466A85_Out_2, _Add_87880A51_Out_2);
                float _Add_43856DBF_Out_2;
                Unity_Add_float(_Maximum_B94A8EBA_Out_2, _Maximum_3087B5D0_Out_2, _Add_43856DBF_Out_2);
                float _Maximum_47B2BE36_Out_2;
                Unity_Maximum_float(_Add_43856DBF_Out_2, 1E-05, _Maximum_47B2BE36_Out_2);
                float3 _Divide_593AB2EB_Out_2;
                Unity_Divide_float3(_Add_87880A51_Out_2, (_Maximum_47B2BE36_Out_2.xxx), _Divide_593AB2EB_Out_2);
                OutVector4_1 = _Divide_593AB2EB_Out_2;
            }
            
            void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
            {
                Out = lerp(A, B, T);
            }
        
            // Graph Vertex
            struct VertexDescriptionInputs
            {
                float3 ObjectSpaceNormal;
                float3 ObjectSpaceTangent;
                float3 ObjectSpacePosition;
            };
            
            struct VertexDescription
            {
                float3 VertexPosition;
                float3 VertexNormal;
                float3 VertexTangent;
            };
            
            VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
            {
                VertexDescription description = (VertexDescription)0;
                Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b _NMObjectVSProIndirect_6D18728A;
                float3 _NMObjectVSProIndirect_6D18728A_ObjectSpacePosition_1;
                SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b(IN.ObjectSpacePosition, _NMObjectVSProIndirect_6D18728A, _NMObjectVSProIndirect_6D18728A_ObjectSpacePosition_1);
                description.VertexPosition = _NMObjectVSProIndirect_6D18728A_ObjectSpacePosition_1;
                description.VertexNormal = IN.ObjectSpaceNormal;
                description.VertexTangent = IN.ObjectSpaceTangent;
                return description;
            }
            
            // Graph Pixel
            struct SurfaceDescriptionInputs
            {
                float3 WorldSpaceNormal;
                float3 AbsoluteWorldSpacePosition;
                float4 uv0;
                float4 VertexColor;
            };
            
            struct SurfaceDescription
            {
                float3 Albedo;
                float3 Emission;
                float Alpha;
                float AlphaClipThreshold;
            };
            
            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
            {
                SurfaceDescription surface = (SurfaceDescription)0;
                float4 _Property_B8B9BCEA_Out_0 = _BaseTilingOffset;
                float4 _Divide_4D76B006_Out_2;
                Unity_Divide_float4(float4(1, 1, 0, 0), _Property_B8B9BCEA_Out_0, _Divide_4D76B006_Out_2);
                float _Property_7D01357A_Out_0 = _BaseTriplanarThreshold;
                Bindings_TriplanarNM_bc609ed95f52591469ab35dbfe0efcea _TriplanarNM_E18E8AC;
                _TriplanarNM_E18E8AC.WorldSpaceNormal = IN.WorldSpaceNormal;
                _TriplanarNM_E18E8AC.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
                float4 _TriplanarNM_E18E8AC_XYZ_1;
                float4 _TriplanarNM_E18E8AC_XZ_2;
                float4 _TriplanarNM_E18E8AC_YZ_3;
                float4 _TriplanarNM_E18E8AC_XY_4;
                SG_TriplanarNM_bc609ed95f52591469ab35dbfe0efcea(TEXTURE2D_ARGS(_BaseColorMap, sampler_BaseColorMap), _BaseColorMap_TexelSize, (_Divide_4D76B006_Out_2).x, _Property_7D01357A_Out_0, _TriplanarNM_E18E8AC, _TriplanarNM_E18E8AC_XYZ_1, _TriplanarNM_E18E8AC_XZ_2, _TriplanarNM_E18E8AC_YZ_3, _TriplanarNM_E18E8AC_XY_4);
                float4 _Property_8A523D6E_Out_0 = _BaseColor;
                float4 _Multiply_947B49CF_Out_2;
                Unity_Multiply_float(_TriplanarNM_E18E8AC_XYZ_1, _Property_8A523D6E_Out_0, _Multiply_947B49CF_Out_2);
                Bindings_TriplanarNM_bc609ed95f52591469ab35dbfe0efcea _TriplanarNM_259285D2;
                _TriplanarNM_259285D2.WorldSpaceNormal = IN.WorldSpaceNormal;
                _TriplanarNM_259285D2.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
                float4 _TriplanarNM_259285D2_XYZ_1;
                float4 _TriplanarNM_259285D2_XZ_2;
                float4 _TriplanarNM_259285D2_YZ_3;
                float4 _TriplanarNM_259285D2_XY_4;
                SG_TriplanarNM_bc609ed95f52591469ab35dbfe0efcea(TEXTURE2D_ARGS(_BaseMaskMap, sampler_BaseMaskMap), _BaseMaskMap_TexelSize, (_Divide_4D76B006_Out_2).x, _Property_7D01357A_Out_0, _TriplanarNM_259285D2, _TriplanarNM_259285D2_XYZ_1, _TriplanarNM_259285D2_XZ_2, _TriplanarNM_259285D2_YZ_3, _TriplanarNM_259285D2_XY_4);
                float _Split_D7F77369_R_1 = _TriplanarNM_259285D2_XYZ_1[0];
                float _Split_D7F77369_G_2 = _TriplanarNM_259285D2_XYZ_1[1];
                float _Split_D7F77369_B_3 = _TriplanarNM_259285D2_XYZ_1[2];
                float _Split_D7F77369_A_4 = _TriplanarNM_259285D2_XYZ_1[3];
                float _Property_5B1C3843_Out_0 = _HeightMin;
                float _Property_8DFF57BF_Out_0 = _HeightMax;
                float2 _Vector2_ADFF96C5_Out_0 = float2(_Property_5B1C3843_Out_0, _Property_8DFF57BF_Out_0);
                float _Property_4828C904_Out_0 = _HeightOffset;
                float2 _Add_467FE662_Out_2;
                Unity_Add_float2(_Vector2_ADFF96C5_Out_0, (_Property_4828C904_Out_0.xx), _Add_467FE662_Out_2);
                float _Remap_70CCBE12_Out_3;
                Unity_Remap_float(_Split_D7F77369_B_3, float2 (0, 1), _Add_467FE662_Out_2, _Remap_70CCBE12_Out_3);
                float4 _Property_46D734F3_Out_0 = _Base2TilingOffset;
                float4 _Divide_FE689998_Out_2;
                Unity_Divide_float4(float4(1, 1, 0, 0), _Property_46D734F3_Out_0, _Divide_FE689998_Out_2);
                float _Property_A196647F_Out_0 = _Base2TriplanarThreshold;
                Bindings_TriplanarNM_bc609ed95f52591469ab35dbfe0efcea _TriplanarNM_63DC6E31;
                _TriplanarNM_63DC6E31.WorldSpaceNormal = IN.WorldSpaceNormal;
                _TriplanarNM_63DC6E31.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
                float4 _TriplanarNM_63DC6E31_XYZ_1;
                float4 _TriplanarNM_63DC6E31_XZ_2;
                float4 _TriplanarNM_63DC6E31_YZ_3;
                float4 _TriplanarNM_63DC6E31_XY_4;
                SG_TriplanarNM_bc609ed95f52591469ab35dbfe0efcea(TEXTURE2D_ARGS(_Base2ColorMap, sampler_Base2ColorMap), _Base2ColorMap_TexelSize, (_Divide_FE689998_Out_2).x, _Property_A196647F_Out_0, _TriplanarNM_63DC6E31, _TriplanarNM_63DC6E31_XYZ_1, _TriplanarNM_63DC6E31_XZ_2, _TriplanarNM_63DC6E31_YZ_3, _TriplanarNM_63DC6E31_XY_4);
                float4 _Property_A9F4D16F_Out_0 = _Base2Color;
                float4 _Multiply_1B422358_Out_2;
                Unity_Multiply_float(_TriplanarNM_63DC6E31_XYZ_1, _Property_A9F4D16F_Out_0, _Multiply_1B422358_Out_2);
                float _Property_42D2FDFE_Out_0 = _Invert_Layer_Mask;
                float4 _SampleTexture2D_6C16A06F_RGBA_0 = SAMPLE_TEXTURE2D(_LayerMask, sampler_LayerMask, IN.uv0.xy);
                float _SampleTexture2D_6C16A06F_R_4 = _SampleTexture2D_6C16A06F_RGBA_0.r;
                float _SampleTexture2D_6C16A06F_G_5 = _SampleTexture2D_6C16A06F_RGBA_0.g;
                float _SampleTexture2D_6C16A06F_B_6 = _SampleTexture2D_6C16A06F_RGBA_0.b;
                float _SampleTexture2D_6C16A06F_A_7 = _SampleTexture2D_6C16A06F_RGBA_0.a;
                float _OneMinus_713B6303_Out_1;
                Unity_OneMinus_float(_SampleTexture2D_6C16A06F_R_4, _OneMinus_713B6303_Out_1);
                float _Branch_1D7AD048_Out_3;
                Unity_Branch_float(_Property_42D2FDFE_Out_0, _OneMinus_713B6303_Out_1, _SampleTexture2D_6C16A06F_R_4, _Branch_1D7AD048_Out_3);
                Bindings_TriplanarNM_bc609ed95f52591469ab35dbfe0efcea _TriplanarNM_F9354D5A;
                _TriplanarNM_F9354D5A.WorldSpaceNormal = IN.WorldSpaceNormal;
                _TriplanarNM_F9354D5A.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
                float4 _TriplanarNM_F9354D5A_XYZ_1;
                float4 _TriplanarNM_F9354D5A_XZ_2;
                float4 _TriplanarNM_F9354D5A_YZ_3;
                float4 _TriplanarNM_F9354D5A_XY_4;
                SG_TriplanarNM_bc609ed95f52591469ab35dbfe0efcea(TEXTURE2D_ARGS(_Base2MaskMap, sampler_Base2MaskMap), _Base2MaskMap_TexelSize, (_Divide_FE689998_Out_2).x, _Property_A196647F_Out_0, _TriplanarNM_F9354D5A, _TriplanarNM_F9354D5A_XYZ_1, _TriplanarNM_F9354D5A_XZ_2, _TriplanarNM_F9354D5A_YZ_3, _TriplanarNM_F9354D5A_XY_4);
                float _Split_DFCC504E_R_1 = _TriplanarNM_F9354D5A_XYZ_1[0];
                float _Split_DFCC504E_G_2 = _TriplanarNM_F9354D5A_XYZ_1[1];
                float _Split_DFCC504E_B_3 = _TriplanarNM_F9354D5A_XYZ_1[2];
                float _Split_DFCC504E_A_4 = _TriplanarNM_F9354D5A_XYZ_1[3];
                float _Property_6ADBE904_Out_0 = _HeightMin2;
                float _Property_B5DAC869_Out_0 = _HeightMax2;
                float2 _Vector2_9AD51603_Out_0 = float2(_Property_6ADBE904_Out_0, _Property_B5DAC869_Out_0);
                float _Property_998773C1_Out_0 = _HeightOffset2;
                float2 _Add_AD0B7F0B_Out_2;
                Unity_Add_float2(_Vector2_9AD51603_Out_0, (_Property_998773C1_Out_0.xx), _Add_AD0B7F0B_Out_2);
                float _Remap_8A5A7412_Out_3;
                Unity_Remap_float(_Split_DFCC504E_B_3, float2 (0, 1), _Add_AD0B7F0B_Out_2, _Remap_8A5A7412_Out_3);
                float _Multiply_D301D5D0_Out_2;
                Unity_Multiply_float(_Branch_1D7AD048_Out_3, _Remap_8A5A7412_Out_3, _Multiply_D301D5D0_Out_2);
                float _Split_D4434FA2_R_1 = IN.VertexColor[0];
                float _Split_D4434FA2_G_2 = IN.VertexColor[1];
                float _Split_D4434FA2_B_3 = IN.VertexColor[2];
                float _Split_D4434FA2_A_4 = IN.VertexColor[3];
                float _Multiply_3A02260E_Out_2;
                Unity_Multiply_float(_Multiply_D301D5D0_Out_2, _Split_D4434FA2_B_3, _Multiply_3A02260E_Out_2);
                float _Property_830CBD9E_Out_0 = _Height_Transition;
                Bindings_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135 _HeightBlend_B5DE67BD;
                float3 _HeightBlend_B5DE67BD_OutVector4_1;
                SG_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135((_Multiply_947B49CF_Out_2.xyz), _Remap_70CCBE12_Out_3, (_Multiply_1B422358_Out_2.xyz), _Multiply_3A02260E_Out_2, _Property_830CBD9E_Out_0, _HeightBlend_B5DE67BD, _HeightBlend_B5DE67BD_OutVector4_1);
                float4 _Property_81D4E0A_Out_0 = _WetColor;
                float3 _Multiply_E136BC52_Out_2;
                Unity_Multiply_float((_Property_81D4E0A_Out_0.xyz), _HeightBlend_B5DE67BD_OutVector4_1, _Multiply_E136BC52_Out_2);
                float _OneMinus_43105B03_Out_1;
                Unity_OneMinus_float(_Split_D4434FA2_R_1, _OneMinus_43105B03_Out_1);
                float3 _Lerp_9376B2BE_Out_3;
                Unity_Lerp_float3(_HeightBlend_B5DE67BD_OutVector4_1, _Multiply_E136BC52_Out_2, (_OneMinus_43105B03_Out_1.xxx), _Lerp_9376B2BE_Out_3);
                float _Split_F7C504B3_R_1 = _TriplanarNM_E18E8AC_XYZ_1[0];
                float _Split_F7C504B3_G_2 = _TriplanarNM_E18E8AC_XYZ_1[1];
                float _Split_F7C504B3_B_3 = _TriplanarNM_E18E8AC_XYZ_1[2];
                float _Split_F7C504B3_A_4 = _TriplanarNM_E18E8AC_XYZ_1[3];
                float _Property_5761B808_Out_0 = _AlphaCutoff;
                surface.Albedo = _Lerp_9376B2BE_Out_3;
                surface.Emission = IsGammaSpace() ? float3(0, 0, 0) : SRGBToLinear(float3(0, 0, 0));
                surface.Alpha = _Split_F7C504B3_A_4;
                surface.AlphaClipThreshold = _Property_5761B808_Out_0;
                return surface;
            }
        
            // --------------------------------------------------
            // Structs and Packing
        
            // Generated Type: Attributes
            struct Attributes
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                float4 uv0 : TEXCOORD0;
                float4 uv1 : TEXCOORD1;
                float4 uv2 : TEXCOORD2;
                float4 color : COLOR;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif
            };
        
            // Generated Type: Varyings
            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float3 positionWS;
                float3 normalWS;
                float4 texCoord0;
                float4 color;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Generated Type: PackedVaryings
            struct PackedVaryings
            {
                float4 positionCS : SV_POSITION;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                float3 interp00 : TEXCOORD0;
                float3 interp01 : TEXCOORD1;
                float4 interp02 : TEXCOORD2;
                float4 interp03 : TEXCOORD3;
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Packed Type: Varyings
            PackedVaryings PackVaryings(Varyings input)
            {
                PackedVaryings output = (PackedVaryings)0;
                output.positionCS = input.positionCS;
                output.interp00.xyz = input.positionWS;
                output.interp01.xyz = input.normalWS;
                output.interp02.xyzw = input.texCoord0;
                output.interp03.xyzw = input.color;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }
            
            // Unpacked Type: Varyings
            Varyings UnpackVaryings(PackedVaryings input)
            {
                Varyings output = (Varyings)0;
                output.positionCS = input.positionCS;
                output.positionWS = input.interp00.xyz;
                output.normalWS = input.interp01.xyz;
                output.texCoord0 = input.interp02.xyzw;
                output.color = input.interp03.xyzw;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
            {
                VertexDescriptionInputs output;
                ZERO_INITIALIZE(VertexDescriptionInputs, output);
            
                output.ObjectSpaceNormal =           input.normalOS;
                output.ObjectSpaceTangent =          input.tangentOS;
                output.ObjectSpacePosition =         input.positionOS;
            
                return output;
            }
            
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
            	// must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            	float3 unnormalizedNormalWS = input.normalWS;
                const float renormFactor = 1.0 / length(unnormalizedNormalWS);
            
            
                output.WorldSpaceNormal =            renormFactor*input.normalWS.xyz;		// we want a unit length Normal Vector node in shader graph
            
            
                output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(input.positionWS);
                output.uv0 =                         input.texCoord0;
                output.VertexColor =                 input.color;
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
            #else
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            #endif
            #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            
                return output;
            }
            
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"
        
            ENDHLSL
        }
        
        Pass
        {
            // Name: <None>
            Tags 
            { 
                "LightMode" = "Universal2D"
            }
           
            // Render State
            Blend One Zero, One Zero
            Cull Back
            ZTest LEqual
            ZWrite On
            // ColorMask: <None>
            
        
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
        
            // Debug
            // <None>
        
            // --------------------------------------------------
            // Pass
        
            // Pragmas
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            #pragma target 2.0
            #pragma multi_compile_instancing
        
            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>
            
            // Defines
            #define _AlphaClip 1
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_COLOR
            #define VARYINGS_NEED_POSITION_WS 
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_COLOR
            #define FEATURES_GRAPH_VERTEX
            #pragma multi_compile_instancing
            #define UNITY_DOTS_SHADER
            #pragma instancing_options nolightprobe
            #pragma instancing_options nolodfade
            #define SHADERPASS_2D
            
        
            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariablesFunctions.hlsl"
        
            // --------------------------------------------------
            // Graph
        
            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
            float _AlphaCutoff;
            float4 _BaseColor;
            float4 _BaseTilingOffset;
            float _BaseTriplanarThreshold;
            float _BaseNormalScale;
            float _BaseMetallic;
            float _BaseAORemapMin;
            float _BaseAORemapMax;
            float _BaseSmoothnessRemapMin;
            float _BaseSmoothnessRemapMax;
            float _Invert_Layer_Mask;
            float _Height_Transition;
            float _HeightMin;
            float _HeightMax;
            float _HeightOffset;
            float _HeightMin2;
            float _HeightMax2;
            float _HeightOffset2;
            float4 _Base2Color;
            float4 _Base2TilingOffset;
            float _Base2TriplanarThreshold;
            float _Base2NormalScale;
            float _Base2Metallic;
            float _Base2SmoothnessRemapMin;
            float _Base2SmoothnessRemapMax;
            float _Base2AORemapMin;
            float _Base2AORemapMax;
            float4 _WetColor;
            float _WetSmoothness;
            CBUFFER_END
            TEXTURE2D(_BaseColorMap); SAMPLER(sampler_BaseColorMap); float4 _BaseColorMap_TexelSize;
            TEXTURE2D(_BaseNormalMap); SAMPLER(sampler_BaseNormalMap); float4 _BaseNormalMap_TexelSize;
            TEXTURE2D(_BaseMaskMap); SAMPLER(sampler_BaseMaskMap); float4 _BaseMaskMap_TexelSize;
            TEXTURE2D(_LayerMask); SAMPLER(sampler_LayerMask); float4 _LayerMask_TexelSize;
            TEXTURE2D(_Base2ColorMap); SAMPLER(sampler_Base2ColorMap); float4 _Base2ColorMap_TexelSize;
            TEXTURE2D(_Base2NormalMap); SAMPLER(sampler_Base2NormalMap); float4 _Base2NormalMap_TexelSize;
            TEXTURE2D(_Base2MaskMap); SAMPLER(sampler_Base2MaskMap); float4 _Base2MaskMap_TexelSize;
            SAMPLER(_SampleTexture2D_AF934D9A_Sampler_3_Linear_Repeat);
            SAMPLER(_SampleTexture2D_66E4959F_Sampler_3_Linear_Repeat);
            SAMPLER(_SampleTexture2D_96366F41_Sampler_3_Linear_Repeat);
            SAMPLER(_SampleTexture2D_6C16A06F_Sampler_3_Linear_Repeat);
        
            // Graph Functions
            
            // 0ff7b9db8f55df06fc08dc990cfb397e
            #include "Assets/NatureManufacture Assets/Object Shaders/NM_Object_VSPro_Indirect.cginc"
            
            void AddPragma_float(float3 A, out float3 Out)
            {
                #pragma instancing_options renderinglayer procedural:setupVSPro
                Out = A;
            }
            
            struct Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b
            {
            };
            
            void SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b(float3 Vector3_314C8600, Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b IN, out float3 ObjectSpacePosition_1)
            {
                float3 _Property_AF5E8C93_Out_0 = Vector3_314C8600;
                float3 _CustomFunction_E07FEE57_Out_1;
                InjectSetup_float(_Property_AF5E8C93_Out_0, _CustomFunction_E07FEE57_Out_1);
                float3 _CustomFunction_18EFD858_Out_1;
                AddPragma_float(_CustomFunction_E07FEE57_Out_1, _CustomFunction_18EFD858_Out_1);
                ObjectSpacePosition_1 = _CustomFunction_18EFD858_Out_1;
            }
            
            void Unity_Divide_float4(float4 A, float4 B, out float4 Out)
            {
                Out = A / B;
            }
            
            void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
            {
                RGBA = float4(R, G, B, A);
                RGB = float3(R, G, B);
                RG = float2(R, G);
            }
            
            void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
            {
                Out = A * B;
            }
            
            void Unity_Sign_float3(float3 In, out float3 Out)
            {
                Out = sign(In);
            }
            
            void Unity_Multiply_float(float2 A, float2 B, out float2 Out)
            {
                Out = A * B;
            }
            
            void Unity_Absolute_float3(float3 In, out float3 Out)
            {
                Out = abs(In);
            }
            
            void Unity_Power_float3(float3 A, float3 B, out float3 Out)
            {
                Out = pow(A, B);
            }
            
            void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
            {
                Out = A * B;
            }
            
            void Unity_Multiply_float(float A, float B, out float Out)
            {
                Out = A * B;
            }
            
            void Unity_Add_float4(float4 A, float4 B, out float4 Out)
            {
                Out = A + B;
            }
            
            void Unity_Add_float(float A, float B, out float Out)
            {
                Out = A + B;
            }
            
            struct Bindings_TriplanarNM_bc609ed95f52591469ab35dbfe0efcea
            {
                float3 WorldSpaceNormal;
                float3 AbsoluteWorldSpacePosition;
            };
            
            void SG_TriplanarNM_bc609ed95f52591469ab35dbfe0efcea(TEXTURE2D_PARAM(Texture2D_80A3D28F, samplerTexture2D_80A3D28F), float4 Texture2D_80A3D28F_TexelSize, float Vector1_41461AC9, float Vector1_E4D1C13A, Bindings_TriplanarNM_bc609ed95f52591469ab35dbfe0efcea IN, out float4 XYZ_1, out float4 XZ_2, out float4 YZ_3, out float4 XY_4)
            {
                float _Split_34F118DC_R_1 = IN.AbsoluteWorldSpacePosition[0];
                float _Split_34F118DC_G_2 = IN.AbsoluteWorldSpacePosition[1];
                float _Split_34F118DC_B_3 = IN.AbsoluteWorldSpacePosition[2];
                float _Split_34F118DC_A_4 = 0;
                float4 _Combine_FDBD63CA_RGBA_4;
                float3 _Combine_FDBD63CA_RGB_5;
                float2 _Combine_FDBD63CA_RG_6;
                Unity_Combine_float(_Split_34F118DC_R_1, _Split_34F118DC_B_3, 0, 0, _Combine_FDBD63CA_RGBA_4, _Combine_FDBD63CA_RGB_5, _Combine_FDBD63CA_RG_6);
                float _Property_7A4DC59B_Out_0 = Vector1_41461AC9;
                float4 _Multiply_D99671F1_Out_2;
                Unity_Multiply_float(_Combine_FDBD63CA_RGBA_4, (_Property_7A4DC59B_Out_0.xxxx), _Multiply_D99671F1_Out_2);
                float3 _Sign_C0850857_Out_1;
                Unity_Sign_float3(IN.WorldSpaceNormal, _Sign_C0850857_Out_1);
                float _Split_EEBC69B5_R_1 = _Sign_C0850857_Out_1[0];
                float _Split_EEBC69B5_G_2 = _Sign_C0850857_Out_1[1];
                float _Split_EEBC69B5_B_3 = _Sign_C0850857_Out_1[2];
                float _Split_EEBC69B5_A_4 = 0;
                float2 _Vector2_7598EA98_Out_0 = float2(_Split_EEBC69B5_G_2, 1);
                float2 _Multiply_F82F3FE2_Out_2;
                Unity_Multiply_float((_Multiply_D99671F1_Out_2.xy), _Vector2_7598EA98_Out_0, _Multiply_F82F3FE2_Out_2);
                float4 _SampleTexture2D_AF934D9A_RGBA_0 = SAMPLE_TEXTURE2D(Texture2D_80A3D28F, samplerTexture2D_80A3D28F, _Multiply_F82F3FE2_Out_2);
                float _SampleTexture2D_AF934D9A_R_4 = _SampleTexture2D_AF934D9A_RGBA_0.r;
                float _SampleTexture2D_AF934D9A_G_5 = _SampleTexture2D_AF934D9A_RGBA_0.g;
                float _SampleTexture2D_AF934D9A_B_6 = _SampleTexture2D_AF934D9A_RGBA_0.b;
                float _SampleTexture2D_AF934D9A_A_7 = _SampleTexture2D_AF934D9A_RGBA_0.a;
                float3 _Absolute_FF95EDEB_Out_1;
                Unity_Absolute_float3(IN.WorldSpaceNormal, _Absolute_FF95EDEB_Out_1);
                float _Property_F8688E0_Out_0 = Vector1_E4D1C13A;
                float3 _Power_C741CD3A_Out_2;
                Unity_Power_float3(_Absolute_FF95EDEB_Out_1, (_Property_F8688E0_Out_0.xxx), _Power_C741CD3A_Out_2);
                float3 _Multiply_3FB4A346_Out_2;
                Unity_Multiply_float(_Power_C741CD3A_Out_2, _Power_C741CD3A_Out_2, _Multiply_3FB4A346_Out_2);
                float _Split_98088E33_R_1 = _Multiply_3FB4A346_Out_2[0];
                float _Split_98088E33_G_2 = _Multiply_3FB4A346_Out_2[1];
                float _Split_98088E33_B_3 = _Multiply_3FB4A346_Out_2[2];
                float _Split_98088E33_A_4 = 0;
                float4 _Multiply_B99FFB12_Out_2;
                Unity_Multiply_float(_SampleTexture2D_AF934D9A_RGBA_0, (_Split_98088E33_G_2.xxxx), _Multiply_B99FFB12_Out_2);
                float4 _Combine_EAF808EA_RGBA_4;
                float3 _Combine_EAF808EA_RGB_5;
                float2 _Combine_EAF808EA_RG_6;
                Unity_Combine_float(_Split_34F118DC_R_1, _Split_34F118DC_G_2, 0, 0, _Combine_EAF808EA_RGBA_4, _Combine_EAF808EA_RGB_5, _Combine_EAF808EA_RG_6);
                float4 _Multiply_9B855117_Out_2;
                Unity_Multiply_float(_Combine_EAF808EA_RGBA_4, (_Property_7A4DC59B_Out_0.xxxx), _Multiply_9B855117_Out_2);
                float _Multiply_B8AC16FB_Out_2;
                Unity_Multiply_float(_Split_EEBC69B5_B_3, -1, _Multiply_B8AC16FB_Out_2);
                float2 _Vector2_F031282A_Out_0 = float2(_Multiply_B8AC16FB_Out_2, 1);
                float2 _Multiply_89A39D70_Out_2;
                Unity_Multiply_float((_Multiply_9B855117_Out_2.xy), _Vector2_F031282A_Out_0, _Multiply_89A39D70_Out_2);
                float4 _SampleTexture2D_66E4959F_RGBA_0 = SAMPLE_TEXTURE2D(Texture2D_80A3D28F, samplerTexture2D_80A3D28F, _Multiply_89A39D70_Out_2);
                float _SampleTexture2D_66E4959F_R_4 = _SampleTexture2D_66E4959F_RGBA_0.r;
                float _SampleTexture2D_66E4959F_G_5 = _SampleTexture2D_66E4959F_RGBA_0.g;
                float _SampleTexture2D_66E4959F_B_6 = _SampleTexture2D_66E4959F_RGBA_0.b;
                float _SampleTexture2D_66E4959F_A_7 = _SampleTexture2D_66E4959F_RGBA_0.a;
                float4 _Multiply_9E620CB9_Out_2;
                Unity_Multiply_float(_SampleTexture2D_66E4959F_RGBA_0, (_Split_98088E33_B_3.xxxx), _Multiply_9E620CB9_Out_2);
                float4 _Combine_D494A8E_RGBA_4;
                float3 _Combine_D494A8E_RGB_5;
                float2 _Combine_D494A8E_RG_6;
                Unity_Combine_float(_Split_34F118DC_B_3, _Split_34F118DC_G_2, 0, 0, _Combine_D494A8E_RGBA_4, _Combine_D494A8E_RGB_5, _Combine_D494A8E_RG_6);
                float4 _Multiply_1B29A9F1_Out_2;
                Unity_Multiply_float(_Combine_D494A8E_RGBA_4, (_Property_7A4DC59B_Out_0.xxxx), _Multiply_1B29A9F1_Out_2);
                float2 _Vector2_1F147BEC_Out_0 = float2(_Split_EEBC69B5_R_1, 1);
                float2 _Multiply_5B8B54E9_Out_2;
                Unity_Multiply_float((_Multiply_1B29A9F1_Out_2.xy), _Vector2_1F147BEC_Out_0, _Multiply_5B8B54E9_Out_2);
                float4 _SampleTexture2D_96366F41_RGBA_0 = SAMPLE_TEXTURE2D(Texture2D_80A3D28F, samplerTexture2D_80A3D28F, _Multiply_5B8B54E9_Out_2);
                float _SampleTexture2D_96366F41_R_4 = _SampleTexture2D_96366F41_RGBA_0.r;
                float _SampleTexture2D_96366F41_G_5 = _SampleTexture2D_96366F41_RGBA_0.g;
                float _SampleTexture2D_96366F41_B_6 = _SampleTexture2D_96366F41_RGBA_0.b;
                float _SampleTexture2D_96366F41_A_7 = _SampleTexture2D_96366F41_RGBA_0.a;
                float4 _Multiply_1C5CFCC5_Out_2;
                Unity_Multiply_float(_SampleTexture2D_96366F41_RGBA_0, (_Split_98088E33_R_1.xxxx), _Multiply_1C5CFCC5_Out_2);
                float4 _Add_D483B2FD_Out_2;
                Unity_Add_float4(_Multiply_9E620CB9_Out_2, _Multiply_1C5CFCC5_Out_2, _Add_D483B2FD_Out_2);
                float4 _Add_166B5BED_Out_2;
                Unity_Add_float4(_Multiply_B99FFB12_Out_2, _Add_D483B2FD_Out_2, _Add_166B5BED_Out_2);
                float _Add_B73B64F6_Out_2;
                Unity_Add_float(_Split_98088E33_R_1, _Split_98088E33_G_2, _Add_B73B64F6_Out_2);
                float _Add_523B36E8_Out_2;
                Unity_Add_float(_Add_B73B64F6_Out_2, _Split_98088E33_B_3, _Add_523B36E8_Out_2);
                float4 _Divide_86C67C72_Out_2;
                Unity_Divide_float4(_Add_166B5BED_Out_2, (_Add_523B36E8_Out_2.xxxx), _Divide_86C67C72_Out_2);
                XYZ_1 = _Divide_86C67C72_Out_2;
                XZ_2 = _SampleTexture2D_AF934D9A_RGBA_0;
                YZ_3 = _SampleTexture2D_66E4959F_RGBA_0;
                XY_4 = _SampleTexture2D_96366F41_RGBA_0;
            }
            
            void Unity_Add_float2(float2 A, float2 B, out float2 Out)
            {
                Out = A + B;
            }
            
            void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
            {
                Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
            }
            
            void Unity_OneMinus_float(float In, out float Out)
            {
                Out = 1 - In;
            }
            
            void Unity_Branch_float(float Predicate, float True, float False, out float Out)
            {
                Out = Predicate ? True : False;
            }
            
            void Unity_Maximum_float(float A, float B, out float Out)
            {
                Out = max(A, B);
            }
            
            void Unity_Subtract_float(float A, float B, out float Out)
            {
                Out = A - B;
            }
            
            void Unity_Add_float3(float3 A, float3 B, out float3 Out)
            {
                Out = A + B;
            }
            
            void Unity_Divide_float3(float3 A, float3 B, out float3 Out)
            {
                Out = A / B;
            }
            
            struct Bindings_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135
            {
            };
            
            void SG_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135(float3 Vector3_88EEBB5E, float Vector1_DA0A37FA, float3 Vector3_79AA92F, float Vector1_F7E83F1E, float Vector1_1C9222A6, Bindings_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135 IN, out float3 OutVector4_1)
            {
                float3 _Property_CE7501EE_Out_0 = Vector3_88EEBB5E;
                float _Property_21A77CD2_Out_0 = Vector1_DA0A37FA;
                float _Property_B0F6C734_Out_0 = Vector1_DA0A37FA;
                float _Property_F32C0509_Out_0 = Vector1_F7E83F1E;
                float _Maximum_2C42CE33_Out_2;
                Unity_Maximum_float(_Property_B0F6C734_Out_0, _Property_F32C0509_Out_0, _Maximum_2C42CE33_Out_2);
                float _Property_FBC3A76E_Out_0 = Vector1_1C9222A6;
                float _Subtract_5E32B1F2_Out_2;
                Unity_Subtract_float(_Maximum_2C42CE33_Out_2, _Property_FBC3A76E_Out_0, _Subtract_5E32B1F2_Out_2);
                float _Subtract_AE0D0FB3_Out_2;
                Unity_Subtract_float(_Property_21A77CD2_Out_0, _Subtract_5E32B1F2_Out_2, _Subtract_AE0D0FB3_Out_2);
                float _Maximum_B94A8EBA_Out_2;
                Unity_Maximum_float(_Subtract_AE0D0FB3_Out_2, 0, _Maximum_B94A8EBA_Out_2);
                float3 _Multiply_6D1F195B_Out_2;
                Unity_Multiply_float(_Property_CE7501EE_Out_0, (_Maximum_B94A8EBA_Out_2.xxx), _Multiply_6D1F195B_Out_2);
                float3 _Property_94C053EA_Out_0 = Vector3_79AA92F;
                float _Property_B5C791CC_Out_0 = Vector1_F7E83F1E;
                float _Subtract_5DDA2278_Out_2;
                Unity_Subtract_float(_Property_B5C791CC_Out_0, _Subtract_5E32B1F2_Out_2, _Subtract_5DDA2278_Out_2);
                float _Maximum_3087B5D0_Out_2;
                Unity_Maximum_float(_Subtract_5DDA2278_Out_2, 0, _Maximum_3087B5D0_Out_2);
                float3 _Multiply_61466A85_Out_2;
                Unity_Multiply_float(_Property_94C053EA_Out_0, (_Maximum_3087B5D0_Out_2.xxx), _Multiply_61466A85_Out_2);
                float3 _Add_87880A51_Out_2;
                Unity_Add_float3(_Multiply_6D1F195B_Out_2, _Multiply_61466A85_Out_2, _Add_87880A51_Out_2);
                float _Add_43856DBF_Out_2;
                Unity_Add_float(_Maximum_B94A8EBA_Out_2, _Maximum_3087B5D0_Out_2, _Add_43856DBF_Out_2);
                float _Maximum_47B2BE36_Out_2;
                Unity_Maximum_float(_Add_43856DBF_Out_2, 1E-05, _Maximum_47B2BE36_Out_2);
                float3 _Divide_593AB2EB_Out_2;
                Unity_Divide_float3(_Add_87880A51_Out_2, (_Maximum_47B2BE36_Out_2.xxx), _Divide_593AB2EB_Out_2);
                OutVector4_1 = _Divide_593AB2EB_Out_2;
            }
            
            void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
            {
                Out = lerp(A, B, T);
            }
        
            // Graph Vertex
            struct VertexDescriptionInputs
            {
                float3 ObjectSpaceNormal;
                float3 ObjectSpaceTangent;
                float3 ObjectSpacePosition;
            };
            
            struct VertexDescription
            {
                float3 VertexPosition;
                float3 VertexNormal;
                float3 VertexTangent;
            };
            
            VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
            {
                VertexDescription description = (VertexDescription)0;
                Bindings_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b _NMObjectVSProIndirect_6D18728A;
                float3 _NMObjectVSProIndirect_6D18728A_ObjectSpacePosition_1;
                SG_NMObjectVSProIndirect_0cfe1e4f145944241ab304331e53c93b(IN.ObjectSpacePosition, _NMObjectVSProIndirect_6D18728A, _NMObjectVSProIndirect_6D18728A_ObjectSpacePosition_1);
                description.VertexPosition = _NMObjectVSProIndirect_6D18728A_ObjectSpacePosition_1;
                description.VertexNormal = IN.ObjectSpaceNormal;
                description.VertexTangent = IN.ObjectSpaceTangent;
                return description;
            }
            
            // Graph Pixel
            struct SurfaceDescriptionInputs
            {
                float3 WorldSpaceNormal;
                float3 AbsoluteWorldSpacePosition;
                float4 uv0;
                float4 VertexColor;
            };
            
            struct SurfaceDescription
            {
                float3 Albedo;
                float Alpha;
                float AlphaClipThreshold;
            };
            
            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
            {
                SurfaceDescription surface = (SurfaceDescription)0;
                float4 _Property_B8B9BCEA_Out_0 = _BaseTilingOffset;
                float4 _Divide_4D76B006_Out_2;
                Unity_Divide_float4(float4(1, 1, 0, 0), _Property_B8B9BCEA_Out_0, _Divide_4D76B006_Out_2);
                float _Property_7D01357A_Out_0 = _BaseTriplanarThreshold;
                Bindings_TriplanarNM_bc609ed95f52591469ab35dbfe0efcea _TriplanarNM_E18E8AC;
                _TriplanarNM_E18E8AC.WorldSpaceNormal = IN.WorldSpaceNormal;
                _TriplanarNM_E18E8AC.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
                float4 _TriplanarNM_E18E8AC_XYZ_1;
                float4 _TriplanarNM_E18E8AC_XZ_2;
                float4 _TriplanarNM_E18E8AC_YZ_3;
                float4 _TriplanarNM_E18E8AC_XY_4;
                SG_TriplanarNM_bc609ed95f52591469ab35dbfe0efcea(TEXTURE2D_ARGS(_BaseColorMap, sampler_BaseColorMap), _BaseColorMap_TexelSize, (_Divide_4D76B006_Out_2).x, _Property_7D01357A_Out_0, _TriplanarNM_E18E8AC, _TriplanarNM_E18E8AC_XYZ_1, _TriplanarNM_E18E8AC_XZ_2, _TriplanarNM_E18E8AC_YZ_3, _TriplanarNM_E18E8AC_XY_4);
                float4 _Property_8A523D6E_Out_0 = _BaseColor;
                float4 _Multiply_947B49CF_Out_2;
                Unity_Multiply_float(_TriplanarNM_E18E8AC_XYZ_1, _Property_8A523D6E_Out_0, _Multiply_947B49CF_Out_2);
                Bindings_TriplanarNM_bc609ed95f52591469ab35dbfe0efcea _TriplanarNM_259285D2;
                _TriplanarNM_259285D2.WorldSpaceNormal = IN.WorldSpaceNormal;
                _TriplanarNM_259285D2.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
                float4 _TriplanarNM_259285D2_XYZ_1;
                float4 _TriplanarNM_259285D2_XZ_2;
                float4 _TriplanarNM_259285D2_YZ_3;
                float4 _TriplanarNM_259285D2_XY_4;
                SG_TriplanarNM_bc609ed95f52591469ab35dbfe0efcea(TEXTURE2D_ARGS(_BaseMaskMap, sampler_BaseMaskMap), _BaseMaskMap_TexelSize, (_Divide_4D76B006_Out_2).x, _Property_7D01357A_Out_0, _TriplanarNM_259285D2, _TriplanarNM_259285D2_XYZ_1, _TriplanarNM_259285D2_XZ_2, _TriplanarNM_259285D2_YZ_3, _TriplanarNM_259285D2_XY_4);
                float _Split_D7F77369_R_1 = _TriplanarNM_259285D2_XYZ_1[0];
                float _Split_D7F77369_G_2 = _TriplanarNM_259285D2_XYZ_1[1];
                float _Split_D7F77369_B_3 = _TriplanarNM_259285D2_XYZ_1[2];
                float _Split_D7F77369_A_4 = _TriplanarNM_259285D2_XYZ_1[3];
                float _Property_5B1C3843_Out_0 = _HeightMin;
                float _Property_8DFF57BF_Out_0 = _HeightMax;
                float2 _Vector2_ADFF96C5_Out_0 = float2(_Property_5B1C3843_Out_0, _Property_8DFF57BF_Out_0);
                float _Property_4828C904_Out_0 = _HeightOffset;
                float2 _Add_467FE662_Out_2;
                Unity_Add_float2(_Vector2_ADFF96C5_Out_0, (_Property_4828C904_Out_0.xx), _Add_467FE662_Out_2);
                float _Remap_70CCBE12_Out_3;
                Unity_Remap_float(_Split_D7F77369_B_3, float2 (0, 1), _Add_467FE662_Out_2, _Remap_70CCBE12_Out_3);
                float4 _Property_46D734F3_Out_0 = _Base2TilingOffset;
                float4 _Divide_FE689998_Out_2;
                Unity_Divide_float4(float4(1, 1, 0, 0), _Property_46D734F3_Out_0, _Divide_FE689998_Out_2);
                float _Property_A196647F_Out_0 = _Base2TriplanarThreshold;
                Bindings_TriplanarNM_bc609ed95f52591469ab35dbfe0efcea _TriplanarNM_63DC6E31;
                _TriplanarNM_63DC6E31.WorldSpaceNormal = IN.WorldSpaceNormal;
                _TriplanarNM_63DC6E31.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
                float4 _TriplanarNM_63DC6E31_XYZ_1;
                float4 _TriplanarNM_63DC6E31_XZ_2;
                float4 _TriplanarNM_63DC6E31_YZ_3;
                float4 _TriplanarNM_63DC6E31_XY_4;
                SG_TriplanarNM_bc609ed95f52591469ab35dbfe0efcea(TEXTURE2D_ARGS(_Base2ColorMap, sampler_Base2ColorMap), _Base2ColorMap_TexelSize, (_Divide_FE689998_Out_2).x, _Property_A196647F_Out_0, _TriplanarNM_63DC6E31, _TriplanarNM_63DC6E31_XYZ_1, _TriplanarNM_63DC6E31_XZ_2, _TriplanarNM_63DC6E31_YZ_3, _TriplanarNM_63DC6E31_XY_4);
                float4 _Property_A9F4D16F_Out_0 = _Base2Color;
                float4 _Multiply_1B422358_Out_2;
                Unity_Multiply_float(_TriplanarNM_63DC6E31_XYZ_1, _Property_A9F4D16F_Out_0, _Multiply_1B422358_Out_2);
                float _Property_42D2FDFE_Out_0 = _Invert_Layer_Mask;
                float4 _SampleTexture2D_6C16A06F_RGBA_0 = SAMPLE_TEXTURE2D(_LayerMask, sampler_LayerMask, IN.uv0.xy);
                float _SampleTexture2D_6C16A06F_R_4 = _SampleTexture2D_6C16A06F_RGBA_0.r;
                float _SampleTexture2D_6C16A06F_G_5 = _SampleTexture2D_6C16A06F_RGBA_0.g;
                float _SampleTexture2D_6C16A06F_B_6 = _SampleTexture2D_6C16A06F_RGBA_0.b;
                float _SampleTexture2D_6C16A06F_A_7 = _SampleTexture2D_6C16A06F_RGBA_0.a;
                float _OneMinus_713B6303_Out_1;
                Unity_OneMinus_float(_SampleTexture2D_6C16A06F_R_4, _OneMinus_713B6303_Out_1);
                float _Branch_1D7AD048_Out_3;
                Unity_Branch_float(_Property_42D2FDFE_Out_0, _OneMinus_713B6303_Out_1, _SampleTexture2D_6C16A06F_R_4, _Branch_1D7AD048_Out_3);
                Bindings_TriplanarNM_bc609ed95f52591469ab35dbfe0efcea _TriplanarNM_F9354D5A;
                _TriplanarNM_F9354D5A.WorldSpaceNormal = IN.WorldSpaceNormal;
                _TriplanarNM_F9354D5A.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
                float4 _TriplanarNM_F9354D5A_XYZ_1;
                float4 _TriplanarNM_F9354D5A_XZ_2;
                float4 _TriplanarNM_F9354D5A_YZ_3;
                float4 _TriplanarNM_F9354D5A_XY_4;
                SG_TriplanarNM_bc609ed95f52591469ab35dbfe0efcea(TEXTURE2D_ARGS(_Base2MaskMap, sampler_Base2MaskMap), _Base2MaskMap_TexelSize, (_Divide_FE689998_Out_2).x, _Property_A196647F_Out_0, _TriplanarNM_F9354D5A, _TriplanarNM_F9354D5A_XYZ_1, _TriplanarNM_F9354D5A_XZ_2, _TriplanarNM_F9354D5A_YZ_3, _TriplanarNM_F9354D5A_XY_4);
                float _Split_DFCC504E_R_1 = _TriplanarNM_F9354D5A_XYZ_1[0];
                float _Split_DFCC504E_G_2 = _TriplanarNM_F9354D5A_XYZ_1[1];
                float _Split_DFCC504E_B_3 = _TriplanarNM_F9354D5A_XYZ_1[2];
                float _Split_DFCC504E_A_4 = _TriplanarNM_F9354D5A_XYZ_1[3];
                float _Property_6ADBE904_Out_0 = _HeightMin2;
                float _Property_B5DAC869_Out_0 = _HeightMax2;
                float2 _Vector2_9AD51603_Out_0 = float2(_Property_6ADBE904_Out_0, _Property_B5DAC869_Out_0);
                float _Property_998773C1_Out_0 = _HeightOffset2;
                float2 _Add_AD0B7F0B_Out_2;
                Unity_Add_float2(_Vector2_9AD51603_Out_0, (_Property_998773C1_Out_0.xx), _Add_AD0B7F0B_Out_2);
                float _Remap_8A5A7412_Out_3;
                Unity_Remap_float(_Split_DFCC504E_B_3, float2 (0, 1), _Add_AD0B7F0B_Out_2, _Remap_8A5A7412_Out_3);
                float _Multiply_D301D5D0_Out_2;
                Unity_Multiply_float(_Branch_1D7AD048_Out_3, _Remap_8A5A7412_Out_3, _Multiply_D301D5D0_Out_2);
                float _Split_D4434FA2_R_1 = IN.VertexColor[0];
                float _Split_D4434FA2_G_2 = IN.VertexColor[1];
                float _Split_D4434FA2_B_3 = IN.VertexColor[2];
                float _Split_D4434FA2_A_4 = IN.VertexColor[3];
                float _Multiply_3A02260E_Out_2;
                Unity_Multiply_float(_Multiply_D301D5D0_Out_2, _Split_D4434FA2_B_3, _Multiply_3A02260E_Out_2);
                float _Property_830CBD9E_Out_0 = _Height_Transition;
                Bindings_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135 _HeightBlend_B5DE67BD;
                float3 _HeightBlend_B5DE67BD_OutVector4_1;
                SG_HeightBlend_d15b6fb865d3b6d4ebc1fd476c3ad135((_Multiply_947B49CF_Out_2.xyz), _Remap_70CCBE12_Out_3, (_Multiply_1B422358_Out_2.xyz), _Multiply_3A02260E_Out_2, _Property_830CBD9E_Out_0, _HeightBlend_B5DE67BD, _HeightBlend_B5DE67BD_OutVector4_1);
                float4 _Property_81D4E0A_Out_0 = _WetColor;
                float3 _Multiply_E136BC52_Out_2;
                Unity_Multiply_float((_Property_81D4E0A_Out_0.xyz), _HeightBlend_B5DE67BD_OutVector4_1, _Multiply_E136BC52_Out_2);
                float _OneMinus_43105B03_Out_1;
                Unity_OneMinus_float(_Split_D4434FA2_R_1, _OneMinus_43105B03_Out_1);
                float3 _Lerp_9376B2BE_Out_3;
                Unity_Lerp_float3(_HeightBlend_B5DE67BD_OutVector4_1, _Multiply_E136BC52_Out_2, (_OneMinus_43105B03_Out_1.xxx), _Lerp_9376B2BE_Out_3);
                float _Split_F7C504B3_R_1 = _TriplanarNM_E18E8AC_XYZ_1[0];
                float _Split_F7C504B3_G_2 = _TriplanarNM_E18E8AC_XYZ_1[1];
                float _Split_F7C504B3_B_3 = _TriplanarNM_E18E8AC_XYZ_1[2];
                float _Split_F7C504B3_A_4 = _TriplanarNM_E18E8AC_XYZ_1[3];
                float _Property_5761B808_Out_0 = _AlphaCutoff;
                surface.Albedo = _Lerp_9376B2BE_Out_3;
                surface.Alpha = _Split_F7C504B3_A_4;
                surface.AlphaClipThreshold = _Property_5761B808_Out_0;
                return surface;
            }
        
            // --------------------------------------------------
            // Structs and Packing
        
            // Generated Type: Attributes
            struct Attributes
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                float4 uv0 : TEXCOORD0;
                float4 color : COLOR;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif
            };
        
            // Generated Type: Varyings
            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float3 positionWS;
                float3 normalWS;
                float4 texCoord0;
                float4 color;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Generated Type: PackedVaryings
            struct PackedVaryings
            {
                float4 positionCS : SV_POSITION;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                float3 interp00 : TEXCOORD0;
                float3 interp01 : TEXCOORD1;
                float4 interp02 : TEXCOORD2;
                float4 interp03 : TEXCOORD3;
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            
            // Packed Type: Varyings
            PackedVaryings PackVaryings(Varyings input)
            {
                PackedVaryings output = (PackedVaryings)0;
                output.positionCS = input.positionCS;
                output.interp00.xyz = input.positionWS;
                output.interp01.xyz = input.normalWS;
                output.interp02.xyzw = input.texCoord0;
                output.interp03.xyzw = input.color;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }
            
            // Unpacked Type: Varyings
            Varyings UnpackVaryings(PackedVaryings input)
            {
                Varyings output = (Varyings)0;
                output.positionCS = input.positionCS;
                output.positionWS = input.interp00.xyz;
                output.normalWS = input.interp01.xyz;
                output.texCoord0 = input.interp02.xyzw;
                output.color = input.interp03.xyzw;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }
        
            // --------------------------------------------------
            // Build Graph Inputs
        
            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
            {
                VertexDescriptionInputs output;
                ZERO_INITIALIZE(VertexDescriptionInputs, output);
            
                output.ObjectSpaceNormal =           input.normalOS;
                output.ObjectSpaceTangent =          input.tangentOS;
                output.ObjectSpacePosition =         input.positionOS;
            
                return output;
            }
            
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
            	// must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
            	float3 unnormalizedNormalWS = input.normalWS;
                const float renormFactor = 1.0 / length(unnormalizedNormalWS);
            
            
                output.WorldSpaceNormal =            renormFactor*input.normalWS.xyz;		// we want a unit length Normal Vector node in shader graph
            
            
                output.AbsoluteWorldSpacePosition =  GetAbsolutePositionWS(input.positionWS);
                output.uv0 =                         input.texCoord0;
                output.VertexColor =                 input.color;
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
            #else
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            #endif
            #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            
                return output;
            }
            
        
            // --------------------------------------------------
            // Main
        
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"
        
            ENDHLSL
        }
        
    }
    CustomEditor "UnityEditor.ShaderGraph.PBRMasterGUI"
    FallBack "Hidden/Shader Graph/FallbackError"
}
