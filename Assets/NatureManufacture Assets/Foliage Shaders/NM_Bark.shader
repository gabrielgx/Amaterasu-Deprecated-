Shader "NatureManufacture/URP/Foliage/Bark"
{
    Properties
    {
        _TrunkBaseColor("Trunk Base Color", Color) = (1, 1, 1, 0)
        [NoScaleOffset]_TrunkBaseColorMap("Trunk Base Map", 2D) = "white" {}
        _TrunkTilingOffset("Trunk Tiling and Offset", Vector) = (1, 1, 0, 0)
        [NoScaleOffset]_TrunkNormalMap("Trunk Normal Map", 2D) = "bump" {}
        _TrunkNormalScale("Trunk Normal Scale", Range(0, 8)) = 1
        [NoScaleOffset]_TrunkMaskMap("Trunk Mask Map MT(R) AO(G) SM(A)", 2D) = "white" {}
        _TrunkMetallic("Trunk Metallic", Range(0, 1)) = 1
        _TrunkAORemapMin("Trunk AO Remap Min", Range(0, 1)) = 0
        _TrunkAORemapMax("Trunk AO Remap Max", Range(0, 1)) = 1
        _TrunkSmoothnessRemapMin("Trunk Smoothness Remap Min", Range(0, 1)) = 0
        _TrunkSmoothnessRemapMax("Trunk Smoothness Remap Max", Range(0, 1)) = 1
        [NoScaleOffset]_LayerMask("Bark Blend Mask(A)", 2D) = "black" {}
        _BarkBlendMaskTilingOffset("Bark Blend Mask Tiling Offset", Vector) = (1, 1, 0, 0)
        _BarkBaseColor("Bark Base Color", Color) = (1, 1, 1, 0)
        [NoScaleOffset]_BarkBaseColorMap("Bark Base Map", 2D) = "white" {}
        [ToggleUI]_BarkUseUV3("Bark Use UV3", Float) = 1
        _BarkTilingOffset("Bark Tiling and Offset", Vector) = (1, 1, 0, 0)
        [NoScaleOffset]_BarkNormalMap("Bark Normal Map", 2D) = "bump" {}
        _BarkNormalScale("Bark Normal Scale", Range(0, 8)) = 1
        [NoScaleOffset]_BarkMaskMap("Bark Mask Map MT(R) AO(G) SM(A)", 2D) = "white" {}
        _BarkMetallic("Bark Metallic", Range(0, 1)) = 1
        _BarkSmoothnessRemapMin("Bark Smoothness Remap Min", Range(0, 1)) = 0
        _BarkSmoothnessRemapMax("Bark Smoothness Remap Max", Range(0, 1)) = 1
        _BarkAORemapMin("Bark AO Remap Min", Range(0, 1)) = 0
        _BarkAORemapMax("Bark AO Remap Max", Range(0, 1)) = 1
        _Stiffness("Wind Stiffness", Float) = 0
        _InitialBend("Wind Initial Bend", Float) = 0
        _Drag("Wind Drag", Float) = 0
        _HeightDrag("Wind Drag Height Offset", Float) = 0
        _NewNormal("Mesh Normal Multiply", Vector) = (0, 0, 0, 0)
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
            #define ATTRIBUTES_NEED_TEXCOORD3
            #define ATTRIBUTES_NEED_COLOR
            #define VARYINGS_NEED_POSITION_WS 
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_TANGENT_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_TEXCOORD3
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
            float4 _TrunkBaseColor;
            float4 _TrunkTilingOffset;
            float _TrunkNormalScale;
            float _TrunkMetallic;
            float _TrunkAORemapMin;
            float _TrunkAORemapMax;
            float _TrunkSmoothnessRemapMin;
            float _TrunkSmoothnessRemapMax;
            float4 _BarkBlendMaskTilingOffset;
            float4 _BarkBaseColor;
            float _BarkUseUV3;
            float4 _BarkTilingOffset;
            float _BarkNormalScale;
            float _BarkMetallic;
            float _BarkSmoothnessRemapMin;
            float _BarkSmoothnessRemapMax;
            float _BarkAORemapMin;
            float _BarkAORemapMax;
            float _Stiffness;
            float _InitialBend;
            float _Drag;
            float _HeightDrag;
            float4 _NewNormal;
            CBUFFER_END
            TEXTURE2D(_TrunkBaseColorMap); SAMPLER(sampler_TrunkBaseColorMap); float4 _TrunkBaseColorMap_TexelSize;
            TEXTURE2D(_TrunkNormalMap); SAMPLER(sampler_TrunkNormalMap); float4 _TrunkNormalMap_TexelSize;
            TEXTURE2D(_TrunkMaskMap); SAMPLER(sampler_TrunkMaskMap); float4 _TrunkMaskMap_TexelSize;
            TEXTURE2D(_LayerMask); SAMPLER(sampler_LayerMask); float4 _LayerMask_TexelSize;
            TEXTURE2D(_BarkBaseColorMap); SAMPLER(sampler_BarkBaseColorMap); float4 _BarkBaseColorMap_TexelSize;
            TEXTURE2D(_BarkNormalMap); SAMPLER(sampler_BarkNormalMap); float4 _BarkNormalMap_TexelSize;
            TEXTURE2D(_BarkMaskMap); SAMPLER(sampler_BarkMaskMap); float4 _BarkMaskMap_TexelSize;
            float WIND_SETTINGS_GustWorldScale;
            float WIND_SETTINGS_GustScale;
            float WIND_SETTINGS_GustSpeed;
            float WIND_SETTINGS_Turbulence;
            float WIND_SETTINGS_ShiverNoiseScale;
            float WIND_SETTINGS_FlexNoiseScale;
            float4 WIND_SETTINGS_WorldDirectionAndSpeed;
            TEXTURE2D(WIND_SETTINGS_TexGust); SAMPLER(samplerWIND_SETTINGS_TexGust); float4 WIND_SETTINGS_TexGust_TexelSize;
            TEXTURE2D(WIND_SETTINGS_TexNoise); SAMPLER(samplerWIND_SETTINGS_TexNoise); float4 WIND_SETTINGS_TexNoise_TexelSize;
            SAMPLER(_SampleTexture2DLOD_15CFA945_Sampler_3_Linear_Repeat);
            SAMPLER(_SampleTexture2DLOD_E609D4E_Sampler_3_Linear_Repeat);
            SAMPLER(_SampleTexture2D_B919BA28_Sampler_3_Linear_Repeat);
            SAMPLER(_SampleTexture2D_7E4BB55F_Sampler_3_Linear_Repeat);
            SAMPLER(_SampleTexture2D_BCB513F9_Sampler_3_Linear_Repeat);
            SAMPLER(_SampleTexture2D_AEF8D028_Sampler_3_Linear_Repeat);
            SAMPLER(_SampleTexture2D_D27E02B1_Sampler_3_Linear_Repeat);
            SAMPLER(_SampleTexture2D_709ACF8B_Sampler_3_Linear_Repeat);
            SAMPLER(_SampleTexture2D_B8D305B2_Sampler_3_Linear_Repeat);
        
            // Graph Functions
            
            // c21cb3b956f4ef1fbcd1fae12d599429
            #include "Assets/NatureManufacture Assets/Foliage Shaders/NM_Foliage_VSPro_Indirect.cginc"
            
            void AddPragma_float(float3 A, out float3 Out)
            {
                #pragma instancing_options renderinglayer procedural:setupVSPro
                Out = A;
            }
            
            struct Bindings_NMFoliageVSProIndirect_5daaeae117458b94ca071c13e7a67c32
            {
            };
            
            void SG_NMFoliageVSProIndirect_5daaeae117458b94ca071c13e7a67c32(float3 Vector3_314C8600, Bindings_NMFoliageVSProIndirect_5daaeae117458b94ca071c13e7a67c32 IN, out float3 ObjectSpacePosition_1)
            {
                float3 _Property_AF5E8C93_Out_0 = Vector3_314C8600;
                float3 _CustomFunction_E07FEE57_Out_1;
                InjectSetup_float(_Property_AF5E8C93_Out_0, _CustomFunction_E07FEE57_Out_1);
                float3 _CustomFunction_18EFD858_Out_1;
                AddPragma_float(_CustomFunction_E07FEE57_Out_1, _CustomFunction_18EFD858_Out_1);
                ObjectSpacePosition_1 = _CustomFunction_18EFD858_Out_1;
            }
            
            void Unity_Comparison_Greater_float(float A, float B, out float Out)
            {
                Out = A > B ? 1 : 0;
            }
            
            void Unity_Subtract_float(float A, float B, out float Out)
            {
                Out = A - B;
            }
            
            void Unity_Comparison_Less_float(float A, float B, out float Out)
            {
                Out = A < B ? 1 : 0;
            }
            
            void Unity_And_float(float A, float B, out float Out)
            {
                Out = A && B;
            }
            
            void Unity_Branch_float(float Predicate, float True, float False, out float Out)
            {
                Out = Predicate ? True : False;
            }
            
            void Unity_Multiply_float(float A, float B, out float Out)
            {
                Out = A * B;
            }
            
            void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
            {
                RGBA = float4(R, G, B, A);
                RGB = float3(R, G, B);
                RG = float2(R, G);
            }
            
            void Unity_Normalize_float3(float3 In, out float3 Out)
            {
                Out = normalize(In);
            }
            
            void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
            {
                Out = A * B;
            }
            
            void Unity_Subtract_float3(float3 A, float3 B, out float3 Out)
            {
                Out = A - B;
            }
            
            void Unity_Power_float(float A, float B, out float Out)
            {
                Out = pow(A, B);
            }
            
            void Unity_Add_float3(float3 A, float3 B, out float3 Out)
            {
                Out = A + B;
            }
            
            void Unity_Or_float(float A, float B, out float Out)
            {
                Out = A || B;
            }
            
            void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
            {
                Out = Predicate ? True : False;
            }
            
            void Unity_Length_float3(float3 In, out float Out)
            {
                Out = length(In);
            }
            
            void Unity_Add_float(float A, float B, out float Out)
            {
                Out = A + B;
            }
            
            struct Bindings_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10
            {
            };
            
            void SG_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10(float3 Vector3_604F121F, float3 Vector3_C30D997B, float Vector1_A2C4B4F4, float Vector1_7F78DDD2, TEXTURE2D_PARAM(Texture2D_5BAC276D, samplerTexture2D_5BAC276D), float4 Texture2D_5BAC276D_TexelSize, TEXTURE2D_PARAM(Texture2D_A3874DB9, samplerTexture2D_A3874DB9), float4 Texture2D_A3874DB9_TexelSize, float4 Vector4_EBFF8CDE, float Vector1_B4470F9B, float Vector1_2EC6D670, float Vector1_9365F438, float Vector1_F53C4B89, float Vector1_6803B355, float Vector1_5EFF6B1A, Bindings_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10 IN, out float3 direction_1, out float strength_2)
            {
                float4 _Property_70C0FA2E_Out_0 = Vector4_EBFF8CDE;
                float _Split_9EAD5A97_R_1 = _Property_70C0FA2E_Out_0[0];
                float _Split_9EAD5A97_G_2 = _Property_70C0FA2E_Out_0[1];
                float _Split_9EAD5A97_B_3 = _Property_70C0FA2E_Out_0[2];
                float _Split_9EAD5A97_A_4 = _Property_70C0FA2E_Out_0[3];
                float4 _Combine_B187C165_RGBA_4;
                float3 _Combine_B187C165_RGB_5;
                float2 _Combine_B187C165_RG_6;
                Unity_Combine_float(_Split_9EAD5A97_R_1, _Split_9EAD5A97_G_2, _Split_9EAD5A97_B_3, 0, _Combine_B187C165_RGBA_4, _Combine_B187C165_RGB_5, _Combine_B187C165_RG_6);
                float3 _Normalize_2F17E0EB_Out_1;
                Unity_Normalize_float3(_Combine_B187C165_RGB_5, _Normalize_2F17E0EB_Out_1);
                float4 _Property_5C87BB92_Out_0 = Vector4_EBFF8CDE;
                float _Split_D49FDEED_R_1 = _Property_5C87BB92_Out_0[0];
                float _Split_D49FDEED_G_2 = _Property_5C87BB92_Out_0[1];
                float _Split_D49FDEED_B_3 = _Property_5C87BB92_Out_0[2];
                float _Split_D49FDEED_A_4 = _Property_5C87BB92_Out_0[3];
                float3 _Multiply_B4A67D17_Out_2;
                Unity_Multiply_float(_Normalize_2F17E0EB_Out_1, (_Split_D49FDEED_A_4.xxx), _Multiply_B4A67D17_Out_2);
                float _Property_B93DC53_Out_0 = Vector1_9365F438;
                float _Comparison_43ADEEA_Out_2;
                Unity_Comparison_Greater_float(_Property_B93DC53_Out_0, 0, _Comparison_43ADEEA_Out_2);
                float3 _Property_F1C16A88_Out_0 = Vector3_C30D997B;
                float _Property_30FD117B_Out_0 = Vector1_9365F438;
                float3 _Multiply_201CFE4B_Out_2;
                Unity_Multiply_float(_Normalize_2F17E0EB_Out_1, (_Property_30FD117B_Out_0.xxx), _Multiply_201CFE4B_Out_2);
                float _Property_C2BB60B0_Out_0 = Vector1_5EFF6B1A;
                float3 _Multiply_3B9F632A_Out_2;
                Unity_Multiply_float(_Multiply_201CFE4B_Out_2, (_Property_C2BB60B0_Out_0.xxx), _Multiply_3B9F632A_Out_2);
                float3 _Subtract_A4C7E129_Out_2;
                Unity_Subtract_float3(_Property_F1C16A88_Out_0, _Multiply_3B9F632A_Out_2, _Subtract_A4C7E129_Out_2);
                float _Property_7A8C7E0C_Out_0 = Vector1_6803B355;
                float3 _Multiply_B5B8A5BC_Out_2;
                Unity_Multiply_float(_Subtract_A4C7E129_Out_2, (_Property_7A8C7E0C_Out_0.xxx), _Multiply_B5B8A5BC_Out_2);
                float _Split_FBE059F7_R_1 = _Multiply_B5B8A5BC_Out_2[0];
                float _Split_FBE059F7_G_2 = _Multiply_B5B8A5BC_Out_2[1];
                float _Split_FBE059F7_B_3 = _Multiply_B5B8A5BC_Out_2[2];
                float _Split_FBE059F7_A_4 = 0;
                float4 _Combine_72AAC837_RGBA_4;
                float3 _Combine_72AAC837_RGB_5;
                float2 _Combine_72AAC837_RG_6;
                Unity_Combine_float(_Split_FBE059F7_R_1, _Split_FBE059F7_B_3, 0, 0, _Combine_72AAC837_RGBA_4, _Combine_72AAC837_RGB_5, _Combine_72AAC837_RG_6);
                float4 _SampleTexture2DLOD_15CFA945_RGBA_0 = SAMPLE_TEXTURE2D_LOD(Texture2D_A3874DB9, samplerTexture2D_A3874DB9, _Combine_72AAC837_RG_6, 3);
                float _SampleTexture2DLOD_15CFA945_R_5 = _SampleTexture2DLOD_15CFA945_RGBA_0.r;
                float _SampleTexture2DLOD_15CFA945_G_6 = _SampleTexture2DLOD_15CFA945_RGBA_0.g;
                float _SampleTexture2DLOD_15CFA945_B_7 = _SampleTexture2DLOD_15CFA945_RGBA_0.b;
                float _SampleTexture2DLOD_15CFA945_A_8 = _SampleTexture2DLOD_15CFA945_RGBA_0.a;
                float _Branch_C4699449_Out_3;
                Unity_Branch_float(_Comparison_43ADEEA_Out_2, _SampleTexture2DLOD_15CFA945_R_5, 0, _Branch_C4699449_Out_3);
                float _Power_F95D44FE_Out_2;
                Unity_Power_float(_Branch_C4699449_Out_3, 2, _Power_F95D44FE_Out_2);
                float _Property_25A9D1E6_Out_0 = Vector1_F53C4B89;
                float _Multiply_48018D0E_Out_2;
                Unity_Multiply_float(_Power_F95D44FE_Out_2, _Property_25A9D1E6_Out_0, _Multiply_48018D0E_Out_2);
                float3 _Multiply_F98AFF5A_Out_2;
                Unity_Multiply_float((_Multiply_48018D0E_Out_2.xxx), _Normalize_2F17E0EB_Out_1, _Multiply_F98AFF5A_Out_2);
                float _Property_B3EBD96_Out_0 = Vector1_9365F438;
                float3 _Multiply_10232D61_Out_2;
                Unity_Multiply_float(_Multiply_F98AFF5A_Out_2, (_Property_B3EBD96_Out_0.xxx), _Multiply_10232D61_Out_2);
                float3 _Add_E4BDFE70_Out_2;
                Unity_Add_float3(_Multiply_B4A67D17_Out_2, _Multiply_10232D61_Out_2, _Add_E4BDFE70_Out_2);
                float4 _Property_DAA1D9B7_Out_0 = Vector4_EBFF8CDE;
                float _Split_A66E259B_R_1 = _Property_DAA1D9B7_Out_0[0];
                float _Split_A66E259B_G_2 = _Property_DAA1D9B7_Out_0[1];
                float _Split_A66E259B_B_3 = _Property_DAA1D9B7_Out_0[2];
                float _Split_A66E259B_A_4 = _Property_DAA1D9B7_Out_0[3];
                float _Comparison_C98EAD3C_Out_2;
                Unity_Comparison_Greater_float(_Split_A66E259B_A_4, 0, _Comparison_C98EAD3C_Out_2);
                float _Property_2EDECFEA_Out_0 = Vector1_2EC6D670;
                float _Comparison_2D5C726B_Out_2;
                Unity_Comparison_Greater_float(_Property_2EDECFEA_Out_0, 0, _Comparison_2D5C726B_Out_2);
                float _Or_104823B_Out_2;
                Unity_Or_float(_Comparison_C98EAD3C_Out_2, _Comparison_2D5C726B_Out_2, _Or_104823B_Out_2);
                float3 _Property_A717C7D9_Out_0 = Vector3_C30D997B;
                float3 _Multiply_86E49BF9_Out_2;
                Unity_Multiply_float(_Normalize_2F17E0EB_Out_1, (_Split_A66E259B_A_4.xxx), _Multiply_86E49BF9_Out_2);
                float3 _Multiply_E0B4CB76_Out_2;
                Unity_Multiply_float(_Multiply_86E49BF9_Out_2, (_Property_C2BB60B0_Out_0.xxx), _Multiply_E0B4CB76_Out_2);
                float3 _Subtract_E607F60E_Out_2;
                Unity_Subtract_float3(_Property_A717C7D9_Out_0, _Multiply_E0B4CB76_Out_2, _Subtract_E607F60E_Out_2);
                float _Property_6E24DFF0_Out_0 = Vector1_B4470F9B;
                float3 _Multiply_F1D4C2B0_Out_2;
                Unity_Multiply_float(_Subtract_E607F60E_Out_2, (_Property_6E24DFF0_Out_0.xxx), _Multiply_F1D4C2B0_Out_2);
                float _Split_C22BECE5_R_1 = _Multiply_F1D4C2B0_Out_2[0];
                float _Split_C22BECE5_G_2 = _Multiply_F1D4C2B0_Out_2[1];
                float _Split_C22BECE5_B_3 = _Multiply_F1D4C2B0_Out_2[2];
                float _Split_C22BECE5_A_4 = 0;
                float4 _Combine_AC8E2469_RGBA_4;
                float3 _Combine_AC8E2469_RGB_5;
                float2 _Combine_AC8E2469_RG_6;
                Unity_Combine_float(_Split_C22BECE5_R_1, _Split_C22BECE5_B_3, 0, 0, _Combine_AC8E2469_RGBA_4, _Combine_AC8E2469_RGB_5, _Combine_AC8E2469_RG_6);
                float4 _SampleTexture2DLOD_E609D4E_RGBA_0 = SAMPLE_TEXTURE2D_LOD(Texture2D_5BAC276D, samplerTexture2D_5BAC276D, _Combine_AC8E2469_RG_6, 3);
                float _SampleTexture2DLOD_E609D4E_R_5 = _SampleTexture2DLOD_E609D4E_RGBA_0.r;
                float _SampleTexture2DLOD_E609D4E_G_6 = _SampleTexture2DLOD_E609D4E_RGBA_0.g;
                float _SampleTexture2DLOD_E609D4E_B_7 = _SampleTexture2DLOD_E609D4E_RGBA_0.b;
                float _SampleTexture2DLOD_E609D4E_A_8 = _SampleTexture2DLOD_E609D4E_RGBA_0.a;
                float4 _Combine_7A76145C_RGBA_4;
                float3 _Combine_7A76145C_RGB_5;
                float2 _Combine_7A76145C_RG_6;
                Unity_Combine_float(_SampleTexture2DLOD_E609D4E_R_5, _SampleTexture2DLOD_E609D4E_G_6, _SampleTexture2DLOD_E609D4E_B_7, 0, _Combine_7A76145C_RGBA_4, _Combine_7A76145C_RGB_5, _Combine_7A76145C_RG_6);
                float3 _Add_761D3920_Out_2;
                Unity_Add_float3(_Combine_7A76145C_RGB_5, float3(-0.5, -0.5, -0.5), _Add_761D3920_Out_2);
                float3 _Branch_8C107061_Out_3;
                Unity_Branch_float3(_Or_104823B_Out_2, _Add_761D3920_Out_2, float3(0, 0, 0), _Branch_8C107061_Out_3);
                float _Property_CF1F92D7_Out_0 = Vector1_2EC6D670;
                float3 _Multiply_9BA2526D_Out_2;
                Unity_Multiply_float(_Branch_8C107061_Out_3, (_Property_CF1F92D7_Out_0.xxx), _Multiply_9BA2526D_Out_2);
                float3 _Add_EBF0803A_Out_2;
                Unity_Add_float3(_Add_E4BDFE70_Out_2, _Multiply_9BA2526D_Out_2, _Add_EBF0803A_Out_2);
                float _Property_F6EF5E6A_Out_0 = Vector1_A2C4B4F4;
                float3 _Multiply_E48C57DB_Out_2;
                Unity_Multiply_float(_Add_EBF0803A_Out_2, (_Property_F6EF5E6A_Out_0.xxx), _Multiply_E48C57DB_Out_2);
                float _Length_77726886_Out_1;
                Unity_Length_float3(_Multiply_E48C57DB_Out_2, _Length_77726886_Out_1);
                float _Property_E82EE598_Out_0 = Vector1_7F78DDD2;
                float _Add_D4269173_Out_2;
                Unity_Add_float(_Length_77726886_Out_1, _Property_E82EE598_Out_0, _Add_D4269173_Out_2);
                float _Multiply_C16CC36_Out_2;
                Unity_Multiply_float(_Add_D4269173_Out_2, 0.001, _Multiply_C16CC36_Out_2);
                direction_1 = _Multiply_E48C57DB_Out_2;
                strength_2 = _Multiply_C16CC36_Out_2;
            }
            
            void Unity_CrossProduct_float(float3 A, float3 B, out float3 Out)
            {
                Out = cross(A, B);
            }
            
            void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
            {
                Out = dot(A, B);
            }
            
            void Unity_Distance_float3(float3 A, float3 B, out float Out)
            {
                Out = distance(A, B);
            }
            
            void Unity_Divide_float(float A, float B, out float Out)
            {
                Out = A / B;
            }
            
            void Unity_Absolute_float(float In, out float Out)
            {
                Out = abs(In);
            }
            
            void Unity_Maximum_float(float A, float B, out float Out)
            {
                Out = max(A, B);
            }
            
            void Unity_Cosine_float(float In, out float Out)
            {
                Out = cos(In);
            }
            
            void Unity_Sine_float(float In, out float Out)
            {
                Out = sin(In);
            }
            
            void Unity_Comparison_NotEqual_float(float A, float B, out float Out)
            {
                Out = A != B ? 1 : 0;
            }
            
            struct Bindings_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf
            {
                float3 ObjectSpaceNormal;
                float3 WorldSpaceNormal;
                float3 ObjectSpaceTangent;
                float3 WorldSpaceTangent;
                float3 ObjectSpaceBiTangent;
                float3 WorldSpaceBiTangent;
                float4 VertexColor;
            };
            
            void SG_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf(float Vector1_BCB03E1A, float3 Vector3_C30D997B, float Vector1_A2C4B4F4, float Vector1_7EE0F94A, float Boolean_527CB26E, float Vector1_DE1BF63A, float Vector1_7F78DDD2, float3 Vector3_DE8CC74D, TEXTURE2D_PARAM(Texture2D_5BAC276D, samplerTexture2D_5BAC276D), float4 Texture2D_5BAC276D_TexelSize, TEXTURE2D_PARAM(Texture2D_A3874DB9, samplerTexture2D_A3874DB9), float4 Texture2D_A3874DB9_TexelSize, float4 Vector4_EBFF8CDE, float Vector1_B4470F9B, float Vector1_2EC6D670, float Vector1_9365F438, float Vector1_F53C4B89, float Vector1_6803B355, Bindings_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf IN, out float3 vertex_1, out float3 normal_2)
            {
                float4 _Vector4_96035CAB_Out_0 = float4(0, 0, 0, 1);
                float3 _Transform_56C94D33_Out_1 = TransformObjectToWorld((_Vector4_96035CAB_Out_0.xyz).xyz);
                float3 _Property_ED8BB836_Out_0 = Vector3_C30D997B;
                float3 _Transform_A839B73F_Out_1 = TransformObjectToWorld(_Property_ED8BB836_Out_0.xyz);
                float _Property_46785E9D_Out_0 = Boolean_527CB26E;
                float _Property_309A125A_Out_0 = Vector1_7EE0F94A;
                float _Comparison_FB7B17F4_Out_2;
                Unity_Comparison_Greater_float(_Property_309A125A_Out_0, 0, _Comparison_FB7B17F4_Out_2);
                float _Split_9DCBE03C_R_1 = _Transform_A839B73F_Out_1[0];
                float _Split_9DCBE03C_G_2 = _Transform_A839B73F_Out_1[1];
                float _Split_9DCBE03C_B_3 = _Transform_A839B73F_Out_1[2];
                float _Split_9DCBE03C_A_4 = 0;
                float _Split_2643B819_R_1 = _Transform_56C94D33_Out_1[0];
                float _Split_2643B819_G_2 = _Transform_56C94D33_Out_1[1];
                float _Split_2643B819_B_3 = _Transform_56C94D33_Out_1[2];
                float _Split_2643B819_A_4 = 0;
                float _Subtract_72710DB_Out_2;
                Unity_Subtract_float(_Split_9DCBE03C_G_2, _Split_2643B819_G_2, _Subtract_72710DB_Out_2);
                float _Comparison_A59CB55E_Out_2;
                Unity_Comparison_Less_float(_Subtract_72710DB_Out_2, _Property_309A125A_Out_0, _Comparison_A59CB55E_Out_2);
                float _And_75A07D3D_Out_2;
                Unity_And_float(_Comparison_FB7B17F4_Out_2, _Comparison_A59CB55E_Out_2, _And_75A07D3D_Out_2);
                float _Property_C5B18F25_Out_0 = Vector1_A2C4B4F4;
                float _Branch_71DEDA04_Out_3;
                Unity_Branch_float(_And_75A07D3D_Out_2, 1E-05, _Property_C5B18F25_Out_0, _Branch_71DEDA04_Out_3);
                float _Split_CAA3FAC4_R_1 = IN.VertexColor[0];
                float _Split_CAA3FAC4_G_2 = IN.VertexColor[1];
                float _Split_CAA3FAC4_B_3 = IN.VertexColor[2];
                float _Split_CAA3FAC4_A_4 = IN.VertexColor[3];
                float _Multiply_6282C968_Out_2;
                Unity_Multiply_float(_Branch_71DEDA04_Out_3, _Split_CAA3FAC4_A_4, _Multiply_6282C968_Out_2);
                float _Branch_FD6CEDEF_Out_3;
                Unity_Branch_float(_Property_46785E9D_Out_0, _Multiply_6282C968_Out_2, _Branch_71DEDA04_Out_3, _Branch_FD6CEDEF_Out_3);
                float _Property_8C9BC3F_Out_0 = Vector1_7F78DDD2;
                float4 _Property_DB8C20D5_Out_0 = Vector4_EBFF8CDE;
                float _Property_C83CCC0B_Out_0 = Vector1_B4470F9B;
                float _Property_9121207F_Out_0 = Vector1_2EC6D670;
                float _Property_9105DCD7_Out_0 = Vector1_9365F438;
                float _Property_6EE84426_Out_0 = Vector1_F53C4B89;
                float _Property_51392D3_Out_0 = Vector1_6803B355;
                float _Property_3C488CF_Out_0 = Vector1_BCB03E1A;
                Bindings_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10 _WindNMCalculateNoShiver_A0D948FA;
                float3 _WindNMCalculateNoShiver_A0D948FA_direction_1;
                float _WindNMCalculateNoShiver_A0D948FA_strength_2;
                SG_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10(_Transform_A839B73F_Out_1, _Transform_56C94D33_Out_1, _Branch_FD6CEDEF_Out_3, _Property_8C9BC3F_Out_0, TEXTURE2D_ARGS(Texture2D_5BAC276D, samplerTexture2D_5BAC276D), Texture2D_5BAC276D_TexelSize, TEXTURE2D_ARGS(Texture2D_A3874DB9, samplerTexture2D_A3874DB9), Texture2D_A3874DB9_TexelSize, _Property_DB8C20D5_Out_0, _Property_C83CCC0B_Out_0, _Property_9121207F_Out_0, _Property_9105DCD7_Out_0, _Property_6EE84426_Out_0, _Property_51392D3_Out_0, _Property_3C488CF_Out_0, _WindNMCalculateNoShiver_A0D948FA, _WindNMCalculateNoShiver_A0D948FA_direction_1, _WindNMCalculateNoShiver_A0D948FA_strength_2);
                float3 _CrossProduct_417F56_Out_2;
                Unity_CrossProduct_float(float3 (0, 1, 0), _WindNMCalculateNoShiver_A0D948FA_direction_1, _CrossProduct_417F56_Out_2);
                float3 _Normalize_4E99CADE_Out_1;
                Unity_Normalize_float3(_CrossProduct_417F56_Out_2, _Normalize_4E99CADE_Out_1);
                float3 _Subtract_8E413BBF_Out_2;
                Unity_Subtract_float3(_Transform_A839B73F_Out_1, _Transform_56C94D33_Out_1, _Subtract_8E413BBF_Out_2);
                float _DotProduct_111C5979_Out_2;
                Unity_DotProduct_float3(_Normalize_4E99CADE_Out_1, _Subtract_8E413BBF_Out_2, _DotProduct_111C5979_Out_2);
                float3 _Multiply_6B4F7E94_Out_2;
                Unity_Multiply_float(_Normalize_4E99CADE_Out_1, (_DotProduct_111C5979_Out_2.xxx), _Multiply_6B4F7E94_Out_2);
                float3 _Add_20CCB137_Out_2;
                Unity_Add_float3(_Transform_56C94D33_Out_1, _Multiply_6B4F7E94_Out_2, _Add_20CCB137_Out_2);
                float3 _Subtract_32DFFF4F_Out_2;
                Unity_Subtract_float3(_Transform_A839B73F_Out_1, _Add_20CCB137_Out_2, _Subtract_32DFFF4F_Out_2);
                float _Distance_77B26FEA_Out_2;
                Unity_Distance_float3(_Transform_A839B73F_Out_1, _Transform_56C94D33_Out_1, _Distance_77B26FEA_Out_2);
                float _Property_FB0C946E_Out_0 = Vector1_DE1BF63A;
                float _Divide_C2F89B8E_Out_2;
                Unity_Divide_float(_Distance_77B26FEA_Out_2, _Property_FB0C946E_Out_0, _Divide_C2F89B8E_Out_2);
                float _Absolute_F60A1055_Out_1;
                Unity_Absolute_float(_Divide_C2F89B8E_Out_2, _Absolute_F60A1055_Out_1);
                float _Vector1_776AF5AC_Out_0 = 1E-07;
                float _Maximum_4166AFF2_Out_2;
                Unity_Maximum_float(_Absolute_F60A1055_Out_1, _Vector1_776AF5AC_Out_0, _Maximum_4166AFF2_Out_2);
                float _Divide_C7B0EA9F_Out_2;
                Unity_Divide_float(1, _Property_FB0C946E_Out_0, _Divide_C7B0EA9F_Out_2);
                float _Power_A9B007BF_Out_2;
                Unity_Power_float(_Maximum_4166AFF2_Out_2, _Divide_C7B0EA9F_Out_2, _Power_A9B007BF_Out_2);
                float _Multiply_58839CDF_Out_2;
                Unity_Multiply_float(_WindNMCalculateNoShiver_A0D948FA_strength_2, _Power_A9B007BF_Out_2, _Multiply_58839CDF_Out_2);
                float _Cosine_C162178D_Out_1;
                Unity_Cosine_float(_Multiply_58839CDF_Out_2, _Cosine_C162178D_Out_1);
                float3 _Multiply_B16DE76A_Out_2;
                Unity_Multiply_float(_Subtract_32DFFF4F_Out_2, (_Cosine_C162178D_Out_1.xxx), _Multiply_B16DE76A_Out_2);
                float3 _CrossProduct_10AAB5C9_Out_2;
                Unity_CrossProduct_float(_Normalize_4E99CADE_Out_1, _Subtract_32DFFF4F_Out_2, _CrossProduct_10AAB5C9_Out_2);
                float _Sine_CD6051C7_Out_1;
                Unity_Sine_float(_Multiply_58839CDF_Out_2, _Sine_CD6051C7_Out_1);
                float3 _Multiply_E565B59B_Out_2;
                Unity_Multiply_float(_CrossProduct_10AAB5C9_Out_2, (_Sine_CD6051C7_Out_1.xxx), _Multiply_E565B59B_Out_2);
                float3 _Add_70586F80_Out_2;
                Unity_Add_float3(_Multiply_B16DE76A_Out_2, _Multiply_E565B59B_Out_2, _Add_70586F80_Out_2);
                float3 _Add_773B285F_Out_2;
                Unity_Add_float3(_Add_20CCB137_Out_2, _Add_70586F80_Out_2, _Add_773B285F_Out_2);
                float3 _Transform_3BC8B282_Out_1 = TransformWorldToObject(_Add_773B285F_Out_2.xyz);
                float3 _Property_37555482_Out_0 = Vector3_DE8CC74D;
                float _Length_2799ABFE_Out_1;
                Unity_Length_float3(_Property_37555482_Out_0, _Length_2799ABFE_Out_1);
                float _Comparison_4940F3B6_Out_2;
                Unity_Comparison_NotEqual_float(_Length_2799ABFE_Out_1, 0, _Comparison_4940F3B6_Out_2);
                float3 _Multiply_5354DD91_Out_2;
                Unity_Multiply_float(IN.WorldSpaceNormal, _Property_37555482_Out_0, _Multiply_5354DD91_Out_2);
                float3 _Branch_993A8BB_Out_3;
                Unity_Branch_float3(_Comparison_4940F3B6_Out_2, _Multiply_5354DD91_Out_2, IN.WorldSpaceNormal, _Branch_993A8BB_Out_3);
                vertex_1 = _Transform_3BC8B282_Out_1;
                normal_2 = _Branch_993A8BB_Out_3;
            }
            
            void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
            {
                Out = UV * Tiling + Offset;
            }
            
            void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
            {
                Out = A * B;
            }
            
            void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
            {
                Out = Predicate ? True : False;
            }
            
            void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
            {
                Out = lerp(A, B, T);
            }
            
            void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
            {
                Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
            }
            
            void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
            {
                Out = lerp(A, B, T);
            }
            
            void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
            {
                Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
            }
        
            // Graph Vertex
            struct VertexDescriptionInputs
            {
                float3 ObjectSpaceNormal;
                float3 WorldSpaceNormal;
                float3 ObjectSpaceTangent;
                float3 WorldSpaceTangent;
                float3 ObjectSpaceBiTangent;
                float3 WorldSpaceBiTangent;
                float3 ObjectSpacePosition;
                float4 VertexColor;
                float3 TimeParameters;
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
                Bindings_NMFoliageVSProIndirect_5daaeae117458b94ca071c13e7a67c32 _NMFoliageVSProIndirect_6AFECCFE;
                float3 _NMFoliageVSProIndirect_6AFECCFE_ObjectSpacePosition_1;
                SG_NMFoliageVSProIndirect_5daaeae117458b94ca071c13e7a67c32(IN.ObjectSpacePosition, _NMFoliageVSProIndirect_6AFECCFE, _NMFoliageVSProIndirect_6AFECCFE_ObjectSpacePosition_1);
                float _Property_3E4B4411_Out_0 = _Drag;
                float _Property_7F252CE7_Out_0 = _HeightDrag;
                float _Property_7865D519_Out_0 = _Stiffness;
                float _Property_D5195AAC_Out_0 = _InitialBend;
                float4 _Property_FFB305BA_Out_0 = _NewNormal;
                float4 _Property_46C9B1EE_Out_0 = WIND_SETTINGS_WorldDirectionAndSpeed;
                float _Property_F9C82607_Out_0 = WIND_SETTINGS_FlexNoiseScale;
                float _Property_1DC2420_Out_0 = WIND_SETTINGS_Turbulence;
                float _Property_753163F4_Out_0 = WIND_SETTINGS_GustSpeed;
                float _Property_249371F4_Out_0 = WIND_SETTINGS_GustScale;
                float _Property_6A8E929E_Out_0 = WIND_SETTINGS_GustWorldScale;
                Bindings_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf _WindNMNoShiver_A2E31333;
                _WindNMNoShiver_A2E31333.ObjectSpaceNormal = IN.ObjectSpaceNormal;
                _WindNMNoShiver_A2E31333.WorldSpaceNormal = IN.WorldSpaceNormal;
                _WindNMNoShiver_A2E31333.ObjectSpaceTangent = IN.ObjectSpaceTangent;
                _WindNMNoShiver_A2E31333.WorldSpaceTangent = IN.WorldSpaceTangent;
                _WindNMNoShiver_A2E31333.ObjectSpaceBiTangent = IN.ObjectSpaceBiTangent;
                _WindNMNoShiver_A2E31333.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
                _WindNMNoShiver_A2E31333.VertexColor = IN.VertexColor;
                float3 _WindNMNoShiver_A2E31333_vertex_1;
                float3 _WindNMNoShiver_A2E31333_normal_2;
                SG_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf(IN.TimeParameters.x, _NMFoliageVSProIndirect_6AFECCFE_ObjectSpacePosition_1, _Property_3E4B4411_Out_0, _Property_7F252CE7_Out_0, 0, _Property_7865D519_Out_0, _Property_D5195AAC_Out_0, (_Property_FFB305BA_Out_0.xyz), TEXTURE2D_ARGS(WIND_SETTINGS_TexNoise, samplerWIND_SETTINGS_TexNoise), WIND_SETTINGS_TexNoise_TexelSize, TEXTURE2D_ARGS(WIND_SETTINGS_TexGust, samplerWIND_SETTINGS_TexGust), WIND_SETTINGS_TexGust_TexelSize, _Property_46C9B1EE_Out_0, _Property_F9C82607_Out_0, _Property_1DC2420_Out_0, _Property_753163F4_Out_0, _Property_249371F4_Out_0, _Property_6A8E929E_Out_0, _WindNMNoShiver_A2E31333, _WindNMNoShiver_A2E31333_vertex_1, _WindNMNoShiver_A2E31333_normal_2);
                description.VertexPosition = _WindNMNoShiver_A2E31333_vertex_1;
                description.VertexNormal = IN.ObjectSpaceNormal;
                description.VertexTangent = IN.ObjectSpaceTangent;
                return description;
            }
            
            // Graph Pixel
            struct SurfaceDescriptionInputs
            {
                float4 uv0;
                float4 uv3;
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
                float4 _Property_EC7746F0_Out_0 = _TrunkTilingOffset;
                float _Split_B742091E_R_1 = _Property_EC7746F0_Out_0[0];
                float _Split_B742091E_G_2 = _Property_EC7746F0_Out_0[1];
                float _Split_B742091E_B_3 = _Property_EC7746F0_Out_0[2];
                float _Split_B742091E_A_4 = _Property_EC7746F0_Out_0[3];
                float2 _Vector2_C5944BDD_Out_0 = float2(_Split_B742091E_R_1, _Split_B742091E_G_2);
                float2 _Vector2_A68E28C5_Out_0 = float2(_Split_B742091E_B_3, _Split_B742091E_A_4);
                float2 _TilingAndOffset_97CBEADA_Out_3;
                Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_C5944BDD_Out_0, _Vector2_A68E28C5_Out_0, _TilingAndOffset_97CBEADA_Out_3);
                float4 _SampleTexture2D_B919BA28_RGBA_0 = SAMPLE_TEXTURE2D(_TrunkBaseColorMap, sampler_TrunkBaseColorMap, _TilingAndOffset_97CBEADA_Out_3);
                float _SampleTexture2D_B919BA28_R_4 = _SampleTexture2D_B919BA28_RGBA_0.r;
                float _SampleTexture2D_B919BA28_G_5 = _SampleTexture2D_B919BA28_RGBA_0.g;
                float _SampleTexture2D_B919BA28_B_6 = _SampleTexture2D_B919BA28_RGBA_0.b;
                float _SampleTexture2D_B919BA28_A_7 = _SampleTexture2D_B919BA28_RGBA_0.a;
                float4 _Property_7FC0454F_Out_0 = _TrunkBaseColor;
                float4 _Multiply_6F337D09_Out_2;
                Unity_Multiply_float(_SampleTexture2D_B919BA28_RGBA_0, _Property_7FC0454F_Out_0, _Multiply_6F337D09_Out_2);
                float _Property_91B33228_Out_0 = _BarkUseUV3;
                float4 _UV_D3D66B0E_Out_0 = IN.uv3;
                float4 _UV_62FB944B_Out_0 = IN.uv0;
                float4 _Branch_7E7DD05F_Out_3;
                Unity_Branch_float4(_Property_91B33228_Out_0, _UV_D3D66B0E_Out_0, _UV_62FB944B_Out_0, _Branch_7E7DD05F_Out_3);
                float4 _Property_67884C_Out_0 = _BarkTilingOffset;
                float _Split_6B4B02A_R_1 = _Property_67884C_Out_0[0];
                float _Split_6B4B02A_G_2 = _Property_67884C_Out_0[1];
                float _Split_6B4B02A_B_3 = _Property_67884C_Out_0[2];
                float _Split_6B4B02A_A_4 = _Property_67884C_Out_0[3];
                float2 _Vector2_A7F21F38_Out_0 = float2(_Split_6B4B02A_R_1, _Split_6B4B02A_G_2);
                float2 _Vector2_1DA22E74_Out_0 = float2(_Split_6B4B02A_B_3, _Split_6B4B02A_A_4);
                float2 _TilingAndOffset_3B5515F1_Out_3;
                Unity_TilingAndOffset_float((_Branch_7E7DD05F_Out_3.xy), _Vector2_A7F21F38_Out_0, _Vector2_1DA22E74_Out_0, _TilingAndOffset_3B5515F1_Out_3);
                float4 _SampleTexture2D_7E4BB55F_RGBA_0 = SAMPLE_TEXTURE2D(_BarkBaseColorMap, sampler_BarkBaseColorMap, _TilingAndOffset_3B5515F1_Out_3);
                float _SampleTexture2D_7E4BB55F_R_4 = _SampleTexture2D_7E4BB55F_RGBA_0.r;
                float _SampleTexture2D_7E4BB55F_G_5 = _SampleTexture2D_7E4BB55F_RGBA_0.g;
                float _SampleTexture2D_7E4BB55F_B_6 = _SampleTexture2D_7E4BB55F_RGBA_0.b;
                float _SampleTexture2D_7E4BB55F_A_7 = _SampleTexture2D_7E4BB55F_RGBA_0.a;
                float4 _Property_400F851C_Out_0 = _BarkBaseColor;
                float4 _Multiply_22EAC4BF_Out_2;
                Unity_Multiply_float(_SampleTexture2D_7E4BB55F_RGBA_0, _Property_400F851C_Out_0, _Multiply_22EAC4BF_Out_2);
                float4 _Property_6F963EC1_Out_0 = _BarkBlendMaskTilingOffset;
                float _Split_7EFCE35C_R_1 = _Property_6F963EC1_Out_0[0];
                float _Split_7EFCE35C_G_2 = _Property_6F963EC1_Out_0[1];
                float _Split_7EFCE35C_B_3 = _Property_6F963EC1_Out_0[2];
                float _Split_7EFCE35C_A_4 = _Property_6F963EC1_Out_0[3];
                float2 _Vector2_3757C307_Out_0 = float2(_Split_7EFCE35C_R_1, _Split_7EFCE35C_G_2);
                float2 _Vector2_1FA6DD61_Out_0 = float2(_Split_7EFCE35C_B_3, _Split_7EFCE35C_A_4);
                float2 _TilingAndOffset_E00C37C5_Out_3;
                Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_3757C307_Out_0, _Vector2_1FA6DD61_Out_0, _TilingAndOffset_E00C37C5_Out_3);
                float4 _SampleTexture2D_BCB513F9_RGBA_0 = SAMPLE_TEXTURE2D(_LayerMask, sampler_LayerMask, _TilingAndOffset_E00C37C5_Out_3);
                float _SampleTexture2D_BCB513F9_R_4 = _SampleTexture2D_BCB513F9_RGBA_0.r;
                float _SampleTexture2D_BCB513F9_G_5 = _SampleTexture2D_BCB513F9_RGBA_0.g;
                float _SampleTexture2D_BCB513F9_B_6 = _SampleTexture2D_BCB513F9_RGBA_0.b;
                float _SampleTexture2D_BCB513F9_A_7 = _SampleTexture2D_BCB513F9_RGBA_0.a;
                float4 _Lerp_FB04343D_Out_3;
                Unity_Lerp_float4(_Multiply_6F337D09_Out_2, _Multiply_22EAC4BF_Out_2, (_SampleTexture2D_BCB513F9_A_7.xxxx), _Lerp_FB04343D_Out_3);
                float4 _SampleTexture2D_AEF8D028_RGBA_0 = SAMPLE_TEXTURE2D(_TrunkNormalMap, sampler_TrunkNormalMap, _TilingAndOffset_97CBEADA_Out_3);
                _SampleTexture2D_AEF8D028_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_AEF8D028_RGBA_0);
                float _SampleTexture2D_AEF8D028_R_4 = _SampleTexture2D_AEF8D028_RGBA_0.r;
                float _SampleTexture2D_AEF8D028_G_5 = _SampleTexture2D_AEF8D028_RGBA_0.g;
                float _SampleTexture2D_AEF8D028_B_6 = _SampleTexture2D_AEF8D028_RGBA_0.b;
                float _SampleTexture2D_AEF8D028_A_7 = _SampleTexture2D_AEF8D028_RGBA_0.a;
                float _Property_D03C5CAE_Out_0 = _TrunkNormalScale;
                float3 _NormalStrength_AA883695_Out_2;
                Unity_NormalStrength_float((_SampleTexture2D_AEF8D028_RGBA_0.xyz), _Property_D03C5CAE_Out_0, _NormalStrength_AA883695_Out_2);
                float4 _SampleTexture2D_D27E02B1_RGBA_0 = SAMPLE_TEXTURE2D(_BarkNormalMap, sampler_BarkNormalMap, _TilingAndOffset_3B5515F1_Out_3);
                _SampleTexture2D_D27E02B1_RGBA_0.rgb = UnpackNormal(_SampleTexture2D_D27E02B1_RGBA_0);
                float _SampleTexture2D_D27E02B1_R_4 = _SampleTexture2D_D27E02B1_RGBA_0.r;
                float _SampleTexture2D_D27E02B1_G_5 = _SampleTexture2D_D27E02B1_RGBA_0.g;
                float _SampleTexture2D_D27E02B1_B_6 = _SampleTexture2D_D27E02B1_RGBA_0.b;
                float _SampleTexture2D_D27E02B1_A_7 = _SampleTexture2D_D27E02B1_RGBA_0.a;
                float _Property_5257C6B7_Out_0 = _BarkNormalScale;
                float3 _NormalStrength_E4C4C9DF_Out_2;
                Unity_NormalStrength_float((_SampleTexture2D_D27E02B1_RGBA_0.xyz), _Property_5257C6B7_Out_0, _NormalStrength_E4C4C9DF_Out_2);
                float3 _Lerp_2035BBC1_Out_3;
                Unity_Lerp_float3(_NormalStrength_AA883695_Out_2, _NormalStrength_E4C4C9DF_Out_2, (_SampleTexture2D_BCB513F9_A_7.xxx), _Lerp_2035BBC1_Out_3);
                float4 _SampleTexture2D_709ACF8B_RGBA_0 = SAMPLE_TEXTURE2D(_TrunkMaskMap, sampler_TrunkMaskMap, _TilingAndOffset_97CBEADA_Out_3);
                float _SampleTexture2D_709ACF8B_R_4 = _SampleTexture2D_709ACF8B_RGBA_0.r;
                float _SampleTexture2D_709ACF8B_G_5 = _SampleTexture2D_709ACF8B_RGBA_0.g;
                float _SampleTexture2D_709ACF8B_B_6 = _SampleTexture2D_709ACF8B_RGBA_0.b;
                float _SampleTexture2D_709ACF8B_A_7 = _SampleTexture2D_709ACF8B_RGBA_0.a;
                float _Property_88426352_Out_0 = _TrunkMetallic;
                float _Multiply_A9C7D801_Out_2;
                Unity_Multiply_float(_SampleTexture2D_709ACF8B_R_4, _Property_88426352_Out_0, _Multiply_A9C7D801_Out_2);
                float _Property_1255D061_Out_0 = _TrunkAORemapMin;
                float _Property_236DCA57_Out_0 = _TrunkAORemapMax;
                float2 _Vector2_BB8919_Out_0 = float2(_Property_1255D061_Out_0, _Property_236DCA57_Out_0);
                float _Remap_D81BE456_Out_3;
                Unity_Remap_float(_SampleTexture2D_709ACF8B_G_5, float2 (0, 1), _Vector2_BB8919_Out_0, _Remap_D81BE456_Out_3);
                float _Property_274EC17C_Out_0 = _TrunkSmoothnessRemapMin;
                float _Property_7A587A8B_Out_0 = _TrunkSmoothnessRemapMax;
                float2 _Vector2_5EC527FF_Out_0 = float2(_Property_274EC17C_Out_0, _Property_7A587A8B_Out_0);
                float _Remap_C92083DF_Out_3;
                Unity_Remap_float(_SampleTexture2D_709ACF8B_A_7, float2 (0, 1), _Vector2_5EC527FF_Out_0, _Remap_C92083DF_Out_3);
                float3 _Vector3_21EB658C_Out_0 = float3(_Multiply_A9C7D801_Out_2, _Remap_D81BE456_Out_3, _Remap_C92083DF_Out_3);
                float4 _SampleTexture2D_B8D305B2_RGBA_0 = SAMPLE_TEXTURE2D(_BarkMaskMap, sampler_BarkMaskMap, _TilingAndOffset_3B5515F1_Out_3);
                float _SampleTexture2D_B8D305B2_R_4 = _SampleTexture2D_B8D305B2_RGBA_0.r;
                float _SampleTexture2D_B8D305B2_G_5 = _SampleTexture2D_B8D305B2_RGBA_0.g;
                float _SampleTexture2D_B8D305B2_B_6 = _SampleTexture2D_B8D305B2_RGBA_0.b;
                float _SampleTexture2D_B8D305B2_A_7 = _SampleTexture2D_B8D305B2_RGBA_0.a;
                float _Property_ECE22503_Out_0 = _BarkMetallic;
                float _Multiply_4DD710E0_Out_2;
                Unity_Multiply_float(_SampleTexture2D_B8D305B2_R_4, _Property_ECE22503_Out_0, _Multiply_4DD710E0_Out_2);
                float _Property_E96C40EA_Out_0 = _BarkAORemapMin;
                float _Property_1B25B9C5_Out_0 = _BarkAORemapMax;
                float2 _Vector2_AF92BA2E_Out_0 = float2(_Property_E96C40EA_Out_0, _Property_1B25B9C5_Out_0);
                float _Remap_ABEE7F21_Out_3;
                Unity_Remap_float(_SampleTexture2D_B8D305B2_G_5, float2 (0, 1), _Vector2_AF92BA2E_Out_0, _Remap_ABEE7F21_Out_3);
                float _Property_8567B506_Out_0 = _BarkSmoothnessRemapMin;
                float _Property_73D88953_Out_0 = _BarkSmoothnessRemapMax;
                float2 _Vector2_CFA63B7C_Out_0 = float2(_Property_8567B506_Out_0, _Property_73D88953_Out_0);
                float _Remap_4448EBF2_Out_3;
                Unity_Remap_float(_SampleTexture2D_B8D305B2_A_7, float2 (0, 1), _Vector2_CFA63B7C_Out_0, _Remap_4448EBF2_Out_3);
                float3 _Vector3_D9E0914_Out_0 = float3(_Multiply_4DD710E0_Out_2, _Remap_ABEE7F21_Out_3, _Remap_4448EBF2_Out_3);
                float3 _Lerp_F1CF1610_Out_3;
                Unity_Lerp_float3(_Vector3_21EB658C_Out_0, _Vector3_D9E0914_Out_0, (_SampleTexture2D_BCB513F9_A_7.xxx), _Lerp_F1CF1610_Out_3);
                float _Split_D1329F45_R_1 = _Lerp_F1CF1610_Out_3[0];
                float _Split_D1329F45_G_2 = _Lerp_F1CF1610_Out_3[1];
                float _Split_D1329F45_B_3 = _Lerp_F1CF1610_Out_3[2];
                float _Split_D1329F45_A_4 = 0;
                surface.Albedo = (_Lerp_FB04343D_Out_3.xyz);
                surface.Normal = _Lerp_2035BBC1_Out_3;
                surface.Emission = IsGammaSpace() ? float3(0, 0, 0) : SRGBToLinear(float3(0, 0, 0));
                surface.Metallic = _Split_D1329F45_R_1;
                surface.Smoothness = _Split_D1329F45_B_3;
                surface.Occlusion = _Split_D1329F45_G_2;
                surface.Alpha = 1;
                surface.AlphaClipThreshold = 0.5;
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
                float4 uv3 : TEXCOORD3;
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
                float4 texCoord3;
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
                output.interp04.xyzw = input.texCoord3;
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
                output.texCoord3 = input.interp04.xyzw;
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
                output.WorldSpaceNormal =            TransformObjectToWorldNormal(input.normalOS);
                output.ObjectSpaceTangent =          input.tangentOS;
                output.WorldSpaceTangent =           TransformObjectToWorldDir(input.tangentOS.xyz);
                output.ObjectSpaceBiTangent =        normalize(cross(input.normalOS, input.tangentOS) * (input.tangentOS.w > 0.0f ? 1.0f : -1.0f) * GetOddNegativeScale());
                output.WorldSpaceBiTangent =         TransformObjectToWorldDir(output.ObjectSpaceBiTangent);
                output.ObjectSpacePosition =         input.positionOS;
                output.VertexColor =                 input.color;
                output.TimeParameters =              _TimeParameters.xyz;
            
                return output;
            }
            
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
            
            
            
            
                output.uv0 =                         input.texCoord0;
                output.uv3 =                         input.texCoord3;
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
            #define ATTRIBUTES_NEED_COLOR
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
            float4 _TrunkBaseColor;
            float4 _TrunkTilingOffset;
            float _TrunkNormalScale;
            float _TrunkMetallic;
            float _TrunkAORemapMin;
            float _TrunkAORemapMax;
            float _TrunkSmoothnessRemapMin;
            float _TrunkSmoothnessRemapMax;
            float4 _BarkBlendMaskTilingOffset;
            float4 _BarkBaseColor;
            float _BarkUseUV3;
            float4 _BarkTilingOffset;
            float _BarkNormalScale;
            float _BarkMetallic;
            float _BarkSmoothnessRemapMin;
            float _BarkSmoothnessRemapMax;
            float _BarkAORemapMin;
            float _BarkAORemapMax;
            float _Stiffness;
            float _InitialBend;
            float _Drag;
            float _HeightDrag;
            float4 _NewNormal;
            CBUFFER_END
            TEXTURE2D(_TrunkBaseColorMap); SAMPLER(sampler_TrunkBaseColorMap); float4 _TrunkBaseColorMap_TexelSize;
            TEXTURE2D(_TrunkNormalMap); SAMPLER(sampler_TrunkNormalMap); float4 _TrunkNormalMap_TexelSize;
            TEXTURE2D(_TrunkMaskMap); SAMPLER(sampler_TrunkMaskMap); float4 _TrunkMaskMap_TexelSize;
            TEXTURE2D(_LayerMask); SAMPLER(sampler_LayerMask); float4 _LayerMask_TexelSize;
            TEXTURE2D(_BarkBaseColorMap); SAMPLER(sampler_BarkBaseColorMap); float4 _BarkBaseColorMap_TexelSize;
            TEXTURE2D(_BarkNormalMap); SAMPLER(sampler_BarkNormalMap); float4 _BarkNormalMap_TexelSize;
            TEXTURE2D(_BarkMaskMap); SAMPLER(sampler_BarkMaskMap); float4 _BarkMaskMap_TexelSize;
            float WIND_SETTINGS_GustWorldScale;
            float WIND_SETTINGS_GustScale;
            float WIND_SETTINGS_GustSpeed;
            float WIND_SETTINGS_Turbulence;
            float WIND_SETTINGS_ShiverNoiseScale;
            float WIND_SETTINGS_FlexNoiseScale;
            float4 WIND_SETTINGS_WorldDirectionAndSpeed;
            TEXTURE2D(WIND_SETTINGS_TexGust); SAMPLER(samplerWIND_SETTINGS_TexGust); float4 WIND_SETTINGS_TexGust_TexelSize;
            TEXTURE2D(WIND_SETTINGS_TexNoise); SAMPLER(samplerWIND_SETTINGS_TexNoise); float4 WIND_SETTINGS_TexNoise_TexelSize;
            SAMPLER(_SampleTexture2DLOD_15CFA945_Sampler_3_Linear_Repeat);
            SAMPLER(_SampleTexture2DLOD_E609D4E_Sampler_3_Linear_Repeat);
        
            // Graph Functions
            
            // c21cb3b956f4ef1fbcd1fae12d599429
            #include "Assets/NatureManufacture Assets/Foliage Shaders/NM_Foliage_VSPro_Indirect.cginc"
            
            void AddPragma_float(float3 A, out float3 Out)
            {
                #pragma instancing_options renderinglayer procedural:setupVSPro
                Out = A;
            }
            
            struct Bindings_NMFoliageVSProIndirect_5daaeae117458b94ca071c13e7a67c32
            {
            };
            
            void SG_NMFoliageVSProIndirect_5daaeae117458b94ca071c13e7a67c32(float3 Vector3_314C8600, Bindings_NMFoliageVSProIndirect_5daaeae117458b94ca071c13e7a67c32 IN, out float3 ObjectSpacePosition_1)
            {
                float3 _Property_AF5E8C93_Out_0 = Vector3_314C8600;
                float3 _CustomFunction_E07FEE57_Out_1;
                InjectSetup_float(_Property_AF5E8C93_Out_0, _CustomFunction_E07FEE57_Out_1);
                float3 _CustomFunction_18EFD858_Out_1;
                AddPragma_float(_CustomFunction_E07FEE57_Out_1, _CustomFunction_18EFD858_Out_1);
                ObjectSpacePosition_1 = _CustomFunction_18EFD858_Out_1;
            }
            
            void Unity_Comparison_Greater_float(float A, float B, out float Out)
            {
                Out = A > B ? 1 : 0;
            }
            
            void Unity_Subtract_float(float A, float B, out float Out)
            {
                Out = A - B;
            }
            
            void Unity_Comparison_Less_float(float A, float B, out float Out)
            {
                Out = A < B ? 1 : 0;
            }
            
            void Unity_And_float(float A, float B, out float Out)
            {
                Out = A && B;
            }
            
            void Unity_Branch_float(float Predicate, float True, float False, out float Out)
            {
                Out = Predicate ? True : False;
            }
            
            void Unity_Multiply_float(float A, float B, out float Out)
            {
                Out = A * B;
            }
            
            void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
            {
                RGBA = float4(R, G, B, A);
                RGB = float3(R, G, B);
                RG = float2(R, G);
            }
            
            void Unity_Normalize_float3(float3 In, out float3 Out)
            {
                Out = normalize(In);
            }
            
            void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
            {
                Out = A * B;
            }
            
            void Unity_Subtract_float3(float3 A, float3 B, out float3 Out)
            {
                Out = A - B;
            }
            
            void Unity_Power_float(float A, float B, out float Out)
            {
                Out = pow(A, B);
            }
            
            void Unity_Add_float3(float3 A, float3 B, out float3 Out)
            {
                Out = A + B;
            }
            
            void Unity_Or_float(float A, float B, out float Out)
            {
                Out = A || B;
            }
            
            void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
            {
                Out = Predicate ? True : False;
            }
            
            void Unity_Length_float3(float3 In, out float Out)
            {
                Out = length(In);
            }
            
            void Unity_Add_float(float A, float B, out float Out)
            {
                Out = A + B;
            }
            
            struct Bindings_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10
            {
            };
            
            void SG_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10(float3 Vector3_604F121F, float3 Vector3_C30D997B, float Vector1_A2C4B4F4, float Vector1_7F78DDD2, TEXTURE2D_PARAM(Texture2D_5BAC276D, samplerTexture2D_5BAC276D), float4 Texture2D_5BAC276D_TexelSize, TEXTURE2D_PARAM(Texture2D_A3874DB9, samplerTexture2D_A3874DB9), float4 Texture2D_A3874DB9_TexelSize, float4 Vector4_EBFF8CDE, float Vector1_B4470F9B, float Vector1_2EC6D670, float Vector1_9365F438, float Vector1_F53C4B89, float Vector1_6803B355, float Vector1_5EFF6B1A, Bindings_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10 IN, out float3 direction_1, out float strength_2)
            {
                float4 _Property_70C0FA2E_Out_0 = Vector4_EBFF8CDE;
                float _Split_9EAD5A97_R_1 = _Property_70C0FA2E_Out_0[0];
                float _Split_9EAD5A97_G_2 = _Property_70C0FA2E_Out_0[1];
                float _Split_9EAD5A97_B_3 = _Property_70C0FA2E_Out_0[2];
                float _Split_9EAD5A97_A_4 = _Property_70C0FA2E_Out_0[3];
                float4 _Combine_B187C165_RGBA_4;
                float3 _Combine_B187C165_RGB_5;
                float2 _Combine_B187C165_RG_6;
                Unity_Combine_float(_Split_9EAD5A97_R_1, _Split_9EAD5A97_G_2, _Split_9EAD5A97_B_3, 0, _Combine_B187C165_RGBA_4, _Combine_B187C165_RGB_5, _Combine_B187C165_RG_6);
                float3 _Normalize_2F17E0EB_Out_1;
                Unity_Normalize_float3(_Combine_B187C165_RGB_5, _Normalize_2F17E0EB_Out_1);
                float4 _Property_5C87BB92_Out_0 = Vector4_EBFF8CDE;
                float _Split_D49FDEED_R_1 = _Property_5C87BB92_Out_0[0];
                float _Split_D49FDEED_G_2 = _Property_5C87BB92_Out_0[1];
                float _Split_D49FDEED_B_3 = _Property_5C87BB92_Out_0[2];
                float _Split_D49FDEED_A_4 = _Property_5C87BB92_Out_0[3];
                float3 _Multiply_B4A67D17_Out_2;
                Unity_Multiply_float(_Normalize_2F17E0EB_Out_1, (_Split_D49FDEED_A_4.xxx), _Multiply_B4A67D17_Out_2);
                float _Property_B93DC53_Out_0 = Vector1_9365F438;
                float _Comparison_43ADEEA_Out_2;
                Unity_Comparison_Greater_float(_Property_B93DC53_Out_0, 0, _Comparison_43ADEEA_Out_2);
                float3 _Property_F1C16A88_Out_0 = Vector3_C30D997B;
                float _Property_30FD117B_Out_0 = Vector1_9365F438;
                float3 _Multiply_201CFE4B_Out_2;
                Unity_Multiply_float(_Normalize_2F17E0EB_Out_1, (_Property_30FD117B_Out_0.xxx), _Multiply_201CFE4B_Out_2);
                float _Property_C2BB60B0_Out_0 = Vector1_5EFF6B1A;
                float3 _Multiply_3B9F632A_Out_2;
                Unity_Multiply_float(_Multiply_201CFE4B_Out_2, (_Property_C2BB60B0_Out_0.xxx), _Multiply_3B9F632A_Out_2);
                float3 _Subtract_A4C7E129_Out_2;
                Unity_Subtract_float3(_Property_F1C16A88_Out_0, _Multiply_3B9F632A_Out_2, _Subtract_A4C7E129_Out_2);
                float _Property_7A8C7E0C_Out_0 = Vector1_6803B355;
                float3 _Multiply_B5B8A5BC_Out_2;
                Unity_Multiply_float(_Subtract_A4C7E129_Out_2, (_Property_7A8C7E0C_Out_0.xxx), _Multiply_B5B8A5BC_Out_2);
                float _Split_FBE059F7_R_1 = _Multiply_B5B8A5BC_Out_2[0];
                float _Split_FBE059F7_G_2 = _Multiply_B5B8A5BC_Out_2[1];
                float _Split_FBE059F7_B_3 = _Multiply_B5B8A5BC_Out_2[2];
                float _Split_FBE059F7_A_4 = 0;
                float4 _Combine_72AAC837_RGBA_4;
                float3 _Combine_72AAC837_RGB_5;
                float2 _Combine_72AAC837_RG_6;
                Unity_Combine_float(_Split_FBE059F7_R_1, _Split_FBE059F7_B_3, 0, 0, _Combine_72AAC837_RGBA_4, _Combine_72AAC837_RGB_5, _Combine_72AAC837_RG_6);
                float4 _SampleTexture2DLOD_15CFA945_RGBA_0 = SAMPLE_TEXTURE2D_LOD(Texture2D_A3874DB9, samplerTexture2D_A3874DB9, _Combine_72AAC837_RG_6, 3);
                float _SampleTexture2DLOD_15CFA945_R_5 = _SampleTexture2DLOD_15CFA945_RGBA_0.r;
                float _SampleTexture2DLOD_15CFA945_G_6 = _SampleTexture2DLOD_15CFA945_RGBA_0.g;
                float _SampleTexture2DLOD_15CFA945_B_7 = _SampleTexture2DLOD_15CFA945_RGBA_0.b;
                float _SampleTexture2DLOD_15CFA945_A_8 = _SampleTexture2DLOD_15CFA945_RGBA_0.a;
                float _Branch_C4699449_Out_3;
                Unity_Branch_float(_Comparison_43ADEEA_Out_2, _SampleTexture2DLOD_15CFA945_R_5, 0, _Branch_C4699449_Out_3);
                float _Power_F95D44FE_Out_2;
                Unity_Power_float(_Branch_C4699449_Out_3, 2, _Power_F95D44FE_Out_2);
                float _Property_25A9D1E6_Out_0 = Vector1_F53C4B89;
                float _Multiply_48018D0E_Out_2;
                Unity_Multiply_float(_Power_F95D44FE_Out_2, _Property_25A9D1E6_Out_0, _Multiply_48018D0E_Out_2);
                float3 _Multiply_F98AFF5A_Out_2;
                Unity_Multiply_float((_Multiply_48018D0E_Out_2.xxx), _Normalize_2F17E0EB_Out_1, _Multiply_F98AFF5A_Out_2);
                float _Property_B3EBD96_Out_0 = Vector1_9365F438;
                float3 _Multiply_10232D61_Out_2;
                Unity_Multiply_float(_Multiply_F98AFF5A_Out_2, (_Property_B3EBD96_Out_0.xxx), _Multiply_10232D61_Out_2);
                float3 _Add_E4BDFE70_Out_2;
                Unity_Add_float3(_Multiply_B4A67D17_Out_2, _Multiply_10232D61_Out_2, _Add_E4BDFE70_Out_2);
                float4 _Property_DAA1D9B7_Out_0 = Vector4_EBFF8CDE;
                float _Split_A66E259B_R_1 = _Property_DAA1D9B7_Out_0[0];
                float _Split_A66E259B_G_2 = _Property_DAA1D9B7_Out_0[1];
                float _Split_A66E259B_B_3 = _Property_DAA1D9B7_Out_0[2];
                float _Split_A66E259B_A_4 = _Property_DAA1D9B7_Out_0[3];
                float _Comparison_C98EAD3C_Out_2;
                Unity_Comparison_Greater_float(_Split_A66E259B_A_4, 0, _Comparison_C98EAD3C_Out_2);
                float _Property_2EDECFEA_Out_0 = Vector1_2EC6D670;
                float _Comparison_2D5C726B_Out_2;
                Unity_Comparison_Greater_float(_Property_2EDECFEA_Out_0, 0, _Comparison_2D5C726B_Out_2);
                float _Or_104823B_Out_2;
                Unity_Or_float(_Comparison_C98EAD3C_Out_2, _Comparison_2D5C726B_Out_2, _Or_104823B_Out_2);
                float3 _Property_A717C7D9_Out_0 = Vector3_C30D997B;
                float3 _Multiply_86E49BF9_Out_2;
                Unity_Multiply_float(_Normalize_2F17E0EB_Out_1, (_Split_A66E259B_A_4.xxx), _Multiply_86E49BF9_Out_2);
                float3 _Multiply_E0B4CB76_Out_2;
                Unity_Multiply_float(_Multiply_86E49BF9_Out_2, (_Property_C2BB60B0_Out_0.xxx), _Multiply_E0B4CB76_Out_2);
                float3 _Subtract_E607F60E_Out_2;
                Unity_Subtract_float3(_Property_A717C7D9_Out_0, _Multiply_E0B4CB76_Out_2, _Subtract_E607F60E_Out_2);
                float _Property_6E24DFF0_Out_0 = Vector1_B4470F9B;
                float3 _Multiply_F1D4C2B0_Out_2;
                Unity_Multiply_float(_Subtract_E607F60E_Out_2, (_Property_6E24DFF0_Out_0.xxx), _Multiply_F1D4C2B0_Out_2);
                float _Split_C22BECE5_R_1 = _Multiply_F1D4C2B0_Out_2[0];
                float _Split_C22BECE5_G_2 = _Multiply_F1D4C2B0_Out_2[1];
                float _Split_C22BECE5_B_3 = _Multiply_F1D4C2B0_Out_2[2];
                float _Split_C22BECE5_A_4 = 0;
                float4 _Combine_AC8E2469_RGBA_4;
                float3 _Combine_AC8E2469_RGB_5;
                float2 _Combine_AC8E2469_RG_6;
                Unity_Combine_float(_Split_C22BECE5_R_1, _Split_C22BECE5_B_3, 0, 0, _Combine_AC8E2469_RGBA_4, _Combine_AC8E2469_RGB_5, _Combine_AC8E2469_RG_6);
                float4 _SampleTexture2DLOD_E609D4E_RGBA_0 = SAMPLE_TEXTURE2D_LOD(Texture2D_5BAC276D, samplerTexture2D_5BAC276D, _Combine_AC8E2469_RG_6, 3);
                float _SampleTexture2DLOD_E609D4E_R_5 = _SampleTexture2DLOD_E609D4E_RGBA_0.r;
                float _SampleTexture2DLOD_E609D4E_G_6 = _SampleTexture2DLOD_E609D4E_RGBA_0.g;
                float _SampleTexture2DLOD_E609D4E_B_7 = _SampleTexture2DLOD_E609D4E_RGBA_0.b;
                float _SampleTexture2DLOD_E609D4E_A_8 = _SampleTexture2DLOD_E609D4E_RGBA_0.a;
                float4 _Combine_7A76145C_RGBA_4;
                float3 _Combine_7A76145C_RGB_5;
                float2 _Combine_7A76145C_RG_6;
                Unity_Combine_float(_SampleTexture2DLOD_E609D4E_R_5, _SampleTexture2DLOD_E609D4E_G_6, _SampleTexture2DLOD_E609D4E_B_7, 0, _Combine_7A76145C_RGBA_4, _Combine_7A76145C_RGB_5, _Combine_7A76145C_RG_6);
                float3 _Add_761D3920_Out_2;
                Unity_Add_float3(_Combine_7A76145C_RGB_5, float3(-0.5, -0.5, -0.5), _Add_761D3920_Out_2);
                float3 _Branch_8C107061_Out_3;
                Unity_Branch_float3(_Or_104823B_Out_2, _Add_761D3920_Out_2, float3(0, 0, 0), _Branch_8C107061_Out_3);
                float _Property_CF1F92D7_Out_0 = Vector1_2EC6D670;
                float3 _Multiply_9BA2526D_Out_2;
                Unity_Multiply_float(_Branch_8C107061_Out_3, (_Property_CF1F92D7_Out_0.xxx), _Multiply_9BA2526D_Out_2);
                float3 _Add_EBF0803A_Out_2;
                Unity_Add_float3(_Add_E4BDFE70_Out_2, _Multiply_9BA2526D_Out_2, _Add_EBF0803A_Out_2);
                float _Property_F6EF5E6A_Out_0 = Vector1_A2C4B4F4;
                float3 _Multiply_E48C57DB_Out_2;
                Unity_Multiply_float(_Add_EBF0803A_Out_2, (_Property_F6EF5E6A_Out_0.xxx), _Multiply_E48C57DB_Out_2);
                float _Length_77726886_Out_1;
                Unity_Length_float3(_Multiply_E48C57DB_Out_2, _Length_77726886_Out_1);
                float _Property_E82EE598_Out_0 = Vector1_7F78DDD2;
                float _Add_D4269173_Out_2;
                Unity_Add_float(_Length_77726886_Out_1, _Property_E82EE598_Out_0, _Add_D4269173_Out_2);
                float _Multiply_C16CC36_Out_2;
                Unity_Multiply_float(_Add_D4269173_Out_2, 0.001, _Multiply_C16CC36_Out_2);
                direction_1 = _Multiply_E48C57DB_Out_2;
                strength_2 = _Multiply_C16CC36_Out_2;
            }
            
            void Unity_CrossProduct_float(float3 A, float3 B, out float3 Out)
            {
                Out = cross(A, B);
            }
            
            void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
            {
                Out = dot(A, B);
            }
            
            void Unity_Distance_float3(float3 A, float3 B, out float Out)
            {
                Out = distance(A, B);
            }
            
            void Unity_Divide_float(float A, float B, out float Out)
            {
                Out = A / B;
            }
            
            void Unity_Absolute_float(float In, out float Out)
            {
                Out = abs(In);
            }
            
            void Unity_Maximum_float(float A, float B, out float Out)
            {
                Out = max(A, B);
            }
            
            void Unity_Cosine_float(float In, out float Out)
            {
                Out = cos(In);
            }
            
            void Unity_Sine_float(float In, out float Out)
            {
                Out = sin(In);
            }
            
            void Unity_Comparison_NotEqual_float(float A, float B, out float Out)
            {
                Out = A != B ? 1 : 0;
            }
            
            struct Bindings_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf
            {
                float3 ObjectSpaceNormal;
                float3 WorldSpaceNormal;
                float3 ObjectSpaceTangent;
                float3 WorldSpaceTangent;
                float3 ObjectSpaceBiTangent;
                float3 WorldSpaceBiTangent;
                float4 VertexColor;
            };
            
            void SG_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf(float Vector1_BCB03E1A, float3 Vector3_C30D997B, float Vector1_A2C4B4F4, float Vector1_7EE0F94A, float Boolean_527CB26E, float Vector1_DE1BF63A, float Vector1_7F78DDD2, float3 Vector3_DE8CC74D, TEXTURE2D_PARAM(Texture2D_5BAC276D, samplerTexture2D_5BAC276D), float4 Texture2D_5BAC276D_TexelSize, TEXTURE2D_PARAM(Texture2D_A3874DB9, samplerTexture2D_A3874DB9), float4 Texture2D_A3874DB9_TexelSize, float4 Vector4_EBFF8CDE, float Vector1_B4470F9B, float Vector1_2EC6D670, float Vector1_9365F438, float Vector1_F53C4B89, float Vector1_6803B355, Bindings_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf IN, out float3 vertex_1, out float3 normal_2)
            {
                float4 _Vector4_96035CAB_Out_0 = float4(0, 0, 0, 1);
                float3 _Transform_56C94D33_Out_1 = TransformObjectToWorld((_Vector4_96035CAB_Out_0.xyz).xyz);
                float3 _Property_ED8BB836_Out_0 = Vector3_C30D997B;
                float3 _Transform_A839B73F_Out_1 = TransformObjectToWorld(_Property_ED8BB836_Out_0.xyz);
                float _Property_46785E9D_Out_0 = Boolean_527CB26E;
                float _Property_309A125A_Out_0 = Vector1_7EE0F94A;
                float _Comparison_FB7B17F4_Out_2;
                Unity_Comparison_Greater_float(_Property_309A125A_Out_0, 0, _Comparison_FB7B17F4_Out_2);
                float _Split_9DCBE03C_R_1 = _Transform_A839B73F_Out_1[0];
                float _Split_9DCBE03C_G_2 = _Transform_A839B73F_Out_1[1];
                float _Split_9DCBE03C_B_3 = _Transform_A839B73F_Out_1[2];
                float _Split_9DCBE03C_A_4 = 0;
                float _Split_2643B819_R_1 = _Transform_56C94D33_Out_1[0];
                float _Split_2643B819_G_2 = _Transform_56C94D33_Out_1[1];
                float _Split_2643B819_B_3 = _Transform_56C94D33_Out_1[2];
                float _Split_2643B819_A_4 = 0;
                float _Subtract_72710DB_Out_2;
                Unity_Subtract_float(_Split_9DCBE03C_G_2, _Split_2643B819_G_2, _Subtract_72710DB_Out_2);
                float _Comparison_A59CB55E_Out_2;
                Unity_Comparison_Less_float(_Subtract_72710DB_Out_2, _Property_309A125A_Out_0, _Comparison_A59CB55E_Out_2);
                float _And_75A07D3D_Out_2;
                Unity_And_float(_Comparison_FB7B17F4_Out_2, _Comparison_A59CB55E_Out_2, _And_75A07D3D_Out_2);
                float _Property_C5B18F25_Out_0 = Vector1_A2C4B4F4;
                float _Branch_71DEDA04_Out_3;
                Unity_Branch_float(_And_75A07D3D_Out_2, 1E-05, _Property_C5B18F25_Out_0, _Branch_71DEDA04_Out_3);
                float _Split_CAA3FAC4_R_1 = IN.VertexColor[0];
                float _Split_CAA3FAC4_G_2 = IN.VertexColor[1];
                float _Split_CAA3FAC4_B_3 = IN.VertexColor[2];
                float _Split_CAA3FAC4_A_4 = IN.VertexColor[3];
                float _Multiply_6282C968_Out_2;
                Unity_Multiply_float(_Branch_71DEDA04_Out_3, _Split_CAA3FAC4_A_4, _Multiply_6282C968_Out_2);
                float _Branch_FD6CEDEF_Out_3;
                Unity_Branch_float(_Property_46785E9D_Out_0, _Multiply_6282C968_Out_2, _Branch_71DEDA04_Out_3, _Branch_FD6CEDEF_Out_3);
                float _Property_8C9BC3F_Out_0 = Vector1_7F78DDD2;
                float4 _Property_DB8C20D5_Out_0 = Vector4_EBFF8CDE;
                float _Property_C83CCC0B_Out_0 = Vector1_B4470F9B;
                float _Property_9121207F_Out_0 = Vector1_2EC6D670;
                float _Property_9105DCD7_Out_0 = Vector1_9365F438;
                float _Property_6EE84426_Out_0 = Vector1_F53C4B89;
                float _Property_51392D3_Out_0 = Vector1_6803B355;
                float _Property_3C488CF_Out_0 = Vector1_BCB03E1A;
                Bindings_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10 _WindNMCalculateNoShiver_A0D948FA;
                float3 _WindNMCalculateNoShiver_A0D948FA_direction_1;
                float _WindNMCalculateNoShiver_A0D948FA_strength_2;
                SG_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10(_Transform_A839B73F_Out_1, _Transform_56C94D33_Out_1, _Branch_FD6CEDEF_Out_3, _Property_8C9BC3F_Out_0, TEXTURE2D_ARGS(Texture2D_5BAC276D, samplerTexture2D_5BAC276D), Texture2D_5BAC276D_TexelSize, TEXTURE2D_ARGS(Texture2D_A3874DB9, samplerTexture2D_A3874DB9), Texture2D_A3874DB9_TexelSize, _Property_DB8C20D5_Out_0, _Property_C83CCC0B_Out_0, _Property_9121207F_Out_0, _Property_9105DCD7_Out_0, _Property_6EE84426_Out_0, _Property_51392D3_Out_0, _Property_3C488CF_Out_0, _WindNMCalculateNoShiver_A0D948FA, _WindNMCalculateNoShiver_A0D948FA_direction_1, _WindNMCalculateNoShiver_A0D948FA_strength_2);
                float3 _CrossProduct_417F56_Out_2;
                Unity_CrossProduct_float(float3 (0, 1, 0), _WindNMCalculateNoShiver_A0D948FA_direction_1, _CrossProduct_417F56_Out_2);
                float3 _Normalize_4E99CADE_Out_1;
                Unity_Normalize_float3(_CrossProduct_417F56_Out_2, _Normalize_4E99CADE_Out_1);
                float3 _Subtract_8E413BBF_Out_2;
                Unity_Subtract_float3(_Transform_A839B73F_Out_1, _Transform_56C94D33_Out_1, _Subtract_8E413BBF_Out_2);
                float _DotProduct_111C5979_Out_2;
                Unity_DotProduct_float3(_Normalize_4E99CADE_Out_1, _Subtract_8E413BBF_Out_2, _DotProduct_111C5979_Out_2);
                float3 _Multiply_6B4F7E94_Out_2;
                Unity_Multiply_float(_Normalize_4E99CADE_Out_1, (_DotProduct_111C5979_Out_2.xxx), _Multiply_6B4F7E94_Out_2);
                float3 _Add_20CCB137_Out_2;
                Unity_Add_float3(_Transform_56C94D33_Out_1, _Multiply_6B4F7E94_Out_2, _Add_20CCB137_Out_2);
                float3 _Subtract_32DFFF4F_Out_2;
                Unity_Subtract_float3(_Transform_A839B73F_Out_1, _Add_20CCB137_Out_2, _Subtract_32DFFF4F_Out_2);
                float _Distance_77B26FEA_Out_2;
                Unity_Distance_float3(_Transform_A839B73F_Out_1, _Transform_56C94D33_Out_1, _Distance_77B26FEA_Out_2);
                float _Property_FB0C946E_Out_0 = Vector1_DE1BF63A;
                float _Divide_C2F89B8E_Out_2;
                Unity_Divide_float(_Distance_77B26FEA_Out_2, _Property_FB0C946E_Out_0, _Divide_C2F89B8E_Out_2);
                float _Absolute_F60A1055_Out_1;
                Unity_Absolute_float(_Divide_C2F89B8E_Out_2, _Absolute_F60A1055_Out_1);
                float _Vector1_776AF5AC_Out_0 = 1E-07;
                float _Maximum_4166AFF2_Out_2;
                Unity_Maximum_float(_Absolute_F60A1055_Out_1, _Vector1_776AF5AC_Out_0, _Maximum_4166AFF2_Out_2);
                float _Divide_C7B0EA9F_Out_2;
                Unity_Divide_float(1, _Property_FB0C946E_Out_0, _Divide_C7B0EA9F_Out_2);
                float _Power_A9B007BF_Out_2;
                Unity_Power_float(_Maximum_4166AFF2_Out_2, _Divide_C7B0EA9F_Out_2, _Power_A9B007BF_Out_2);
                float _Multiply_58839CDF_Out_2;
                Unity_Multiply_float(_WindNMCalculateNoShiver_A0D948FA_strength_2, _Power_A9B007BF_Out_2, _Multiply_58839CDF_Out_2);
                float _Cosine_C162178D_Out_1;
                Unity_Cosine_float(_Multiply_58839CDF_Out_2, _Cosine_C162178D_Out_1);
                float3 _Multiply_B16DE76A_Out_2;
                Unity_Multiply_float(_Subtract_32DFFF4F_Out_2, (_Cosine_C162178D_Out_1.xxx), _Multiply_B16DE76A_Out_2);
                float3 _CrossProduct_10AAB5C9_Out_2;
                Unity_CrossProduct_float(_Normalize_4E99CADE_Out_1, _Subtract_32DFFF4F_Out_2, _CrossProduct_10AAB5C9_Out_2);
                float _Sine_CD6051C7_Out_1;
                Unity_Sine_float(_Multiply_58839CDF_Out_2, _Sine_CD6051C7_Out_1);
                float3 _Multiply_E565B59B_Out_2;
                Unity_Multiply_float(_CrossProduct_10AAB5C9_Out_2, (_Sine_CD6051C7_Out_1.xxx), _Multiply_E565B59B_Out_2);
                float3 _Add_70586F80_Out_2;
                Unity_Add_float3(_Multiply_B16DE76A_Out_2, _Multiply_E565B59B_Out_2, _Add_70586F80_Out_2);
                float3 _Add_773B285F_Out_2;
                Unity_Add_float3(_Add_20CCB137_Out_2, _Add_70586F80_Out_2, _Add_773B285F_Out_2);
                float3 _Transform_3BC8B282_Out_1 = TransformWorldToObject(_Add_773B285F_Out_2.xyz);
                float3 _Property_37555482_Out_0 = Vector3_DE8CC74D;
                float _Length_2799ABFE_Out_1;
                Unity_Length_float3(_Property_37555482_Out_0, _Length_2799ABFE_Out_1);
                float _Comparison_4940F3B6_Out_2;
                Unity_Comparison_NotEqual_float(_Length_2799ABFE_Out_1, 0, _Comparison_4940F3B6_Out_2);
                float3 _Multiply_5354DD91_Out_2;
                Unity_Multiply_float(IN.WorldSpaceNormal, _Property_37555482_Out_0, _Multiply_5354DD91_Out_2);
                float3 _Branch_993A8BB_Out_3;
                Unity_Branch_float3(_Comparison_4940F3B6_Out_2, _Multiply_5354DD91_Out_2, IN.WorldSpaceNormal, _Branch_993A8BB_Out_3);
                vertex_1 = _Transform_3BC8B282_Out_1;
                normal_2 = _Branch_993A8BB_Out_3;
            }
        
            // Graph Vertex
            struct VertexDescriptionInputs
            {
                float3 ObjectSpaceNormal;
                float3 WorldSpaceNormal;
                float3 ObjectSpaceTangent;
                float3 WorldSpaceTangent;
                float3 ObjectSpaceBiTangent;
                float3 WorldSpaceBiTangent;
                float3 ObjectSpacePosition;
                float4 VertexColor;
                float3 TimeParameters;
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
                Bindings_NMFoliageVSProIndirect_5daaeae117458b94ca071c13e7a67c32 _NMFoliageVSProIndirect_6AFECCFE;
                float3 _NMFoliageVSProIndirect_6AFECCFE_ObjectSpacePosition_1;
                SG_NMFoliageVSProIndirect_5daaeae117458b94ca071c13e7a67c32(IN.ObjectSpacePosition, _NMFoliageVSProIndirect_6AFECCFE, _NMFoliageVSProIndirect_6AFECCFE_ObjectSpacePosition_1);
                float _Property_3E4B4411_Out_0 = _Drag;
                float _Property_7F252CE7_Out_0 = _HeightDrag;
                float _Property_7865D519_Out_0 = _Stiffness;
                float _Property_D5195AAC_Out_0 = _InitialBend;
                float4 _Property_FFB305BA_Out_0 = _NewNormal;
                float4 _Property_46C9B1EE_Out_0 = WIND_SETTINGS_WorldDirectionAndSpeed;
                float _Property_F9C82607_Out_0 = WIND_SETTINGS_FlexNoiseScale;
                float _Property_1DC2420_Out_0 = WIND_SETTINGS_Turbulence;
                float _Property_753163F4_Out_0 = WIND_SETTINGS_GustSpeed;
                float _Property_249371F4_Out_0 = WIND_SETTINGS_GustScale;
                float _Property_6A8E929E_Out_0 = WIND_SETTINGS_GustWorldScale;
                Bindings_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf _WindNMNoShiver_A2E31333;
                _WindNMNoShiver_A2E31333.ObjectSpaceNormal = IN.ObjectSpaceNormal;
                _WindNMNoShiver_A2E31333.WorldSpaceNormal = IN.WorldSpaceNormal;
                _WindNMNoShiver_A2E31333.ObjectSpaceTangent = IN.ObjectSpaceTangent;
                _WindNMNoShiver_A2E31333.WorldSpaceTangent = IN.WorldSpaceTangent;
                _WindNMNoShiver_A2E31333.ObjectSpaceBiTangent = IN.ObjectSpaceBiTangent;
                _WindNMNoShiver_A2E31333.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
                _WindNMNoShiver_A2E31333.VertexColor = IN.VertexColor;
                float3 _WindNMNoShiver_A2E31333_vertex_1;
                float3 _WindNMNoShiver_A2E31333_normal_2;
                SG_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf(IN.TimeParameters.x, _NMFoliageVSProIndirect_6AFECCFE_ObjectSpacePosition_1, _Property_3E4B4411_Out_0, _Property_7F252CE7_Out_0, 0, _Property_7865D519_Out_0, _Property_D5195AAC_Out_0, (_Property_FFB305BA_Out_0.xyz), TEXTURE2D_ARGS(WIND_SETTINGS_TexNoise, samplerWIND_SETTINGS_TexNoise), WIND_SETTINGS_TexNoise_TexelSize, TEXTURE2D_ARGS(WIND_SETTINGS_TexGust, samplerWIND_SETTINGS_TexGust), WIND_SETTINGS_TexGust_TexelSize, _Property_46C9B1EE_Out_0, _Property_F9C82607_Out_0, _Property_1DC2420_Out_0, _Property_753163F4_Out_0, _Property_249371F4_Out_0, _Property_6A8E929E_Out_0, _WindNMNoShiver_A2E31333, _WindNMNoShiver_A2E31333_vertex_1, _WindNMNoShiver_A2E31333_normal_2);
                description.VertexPosition = _WindNMNoShiver_A2E31333_vertex_1;
                description.VertexNormal = IN.ObjectSpaceNormal;
                description.VertexTangent = IN.ObjectSpaceTangent;
                return description;
            }
            
            // Graph Pixel
            struct SurfaceDescriptionInputs
            {
            };
            
            struct SurfaceDescription
            {
                float Alpha;
                float AlphaClipThreshold;
            };
            
            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
            {
                SurfaceDescription surface = (SurfaceDescription)0;
                surface.Alpha = 1;
                surface.AlphaClipThreshold = 0.5;
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
                float4 color : COLOR;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif
            };
        
            // Generated Type: Varyings
            struct Varyings
            {
                float4 positionCS : SV_POSITION;
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
                output.WorldSpaceNormal =            TransformObjectToWorldNormal(input.normalOS);
                output.ObjectSpaceTangent =          input.tangentOS;
                output.WorldSpaceTangent =           TransformObjectToWorldDir(input.tangentOS.xyz);
                output.ObjectSpaceBiTangent =        normalize(cross(input.normalOS, input.tangentOS) * (input.tangentOS.w > 0.0f ? 1.0f : -1.0f) * GetOddNegativeScale());
                output.WorldSpaceBiTangent =         TransformObjectToWorldDir(output.ObjectSpaceBiTangent);
                output.ObjectSpacePosition =         input.positionOS;
                output.VertexColor =                 input.color;
                output.TimeParameters =              _TimeParameters.xyz;
            
                return output;
            }
            
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
            
            
            
            
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
            #define ATTRIBUTES_NEED_COLOR
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
            float4 _TrunkBaseColor;
            float4 _TrunkTilingOffset;
            float _TrunkNormalScale;
            float _TrunkMetallic;
            float _TrunkAORemapMin;
            float _TrunkAORemapMax;
            float _TrunkSmoothnessRemapMin;
            float _TrunkSmoothnessRemapMax;
            float4 _BarkBlendMaskTilingOffset;
            float4 _BarkBaseColor;
            float _BarkUseUV3;
            float4 _BarkTilingOffset;
            float _BarkNormalScale;
            float _BarkMetallic;
            float _BarkSmoothnessRemapMin;
            float _BarkSmoothnessRemapMax;
            float _BarkAORemapMin;
            float _BarkAORemapMax;
            float _Stiffness;
            float _InitialBend;
            float _Drag;
            float _HeightDrag;
            float4 _NewNormal;
            CBUFFER_END
            TEXTURE2D(_TrunkBaseColorMap); SAMPLER(sampler_TrunkBaseColorMap); float4 _TrunkBaseColorMap_TexelSize;
            TEXTURE2D(_TrunkNormalMap); SAMPLER(sampler_TrunkNormalMap); float4 _TrunkNormalMap_TexelSize;
            TEXTURE2D(_TrunkMaskMap); SAMPLER(sampler_TrunkMaskMap); float4 _TrunkMaskMap_TexelSize;
            TEXTURE2D(_LayerMask); SAMPLER(sampler_LayerMask); float4 _LayerMask_TexelSize;
            TEXTURE2D(_BarkBaseColorMap); SAMPLER(sampler_BarkBaseColorMap); float4 _BarkBaseColorMap_TexelSize;
            TEXTURE2D(_BarkNormalMap); SAMPLER(sampler_BarkNormalMap); float4 _BarkNormalMap_TexelSize;
            TEXTURE2D(_BarkMaskMap); SAMPLER(sampler_BarkMaskMap); float4 _BarkMaskMap_TexelSize;
            float WIND_SETTINGS_GustWorldScale;
            float WIND_SETTINGS_GustScale;
            float WIND_SETTINGS_GustSpeed;
            float WIND_SETTINGS_Turbulence;
            float WIND_SETTINGS_ShiverNoiseScale;
            float WIND_SETTINGS_FlexNoiseScale;
            float4 WIND_SETTINGS_WorldDirectionAndSpeed;
            TEXTURE2D(WIND_SETTINGS_TexGust); SAMPLER(samplerWIND_SETTINGS_TexGust); float4 WIND_SETTINGS_TexGust_TexelSize;
            TEXTURE2D(WIND_SETTINGS_TexNoise); SAMPLER(samplerWIND_SETTINGS_TexNoise); float4 WIND_SETTINGS_TexNoise_TexelSize;
            SAMPLER(_SampleTexture2DLOD_15CFA945_Sampler_3_Linear_Repeat);
            SAMPLER(_SampleTexture2DLOD_E609D4E_Sampler_3_Linear_Repeat);
        
            // Graph Functions
            
            // c21cb3b956f4ef1fbcd1fae12d599429
            #include "Assets/NatureManufacture Assets/Foliage Shaders/NM_Foliage_VSPro_Indirect.cginc"
            
            void AddPragma_float(float3 A, out float3 Out)
            {
                #pragma instancing_options renderinglayer procedural:setupVSPro
                Out = A;
            }
            
            struct Bindings_NMFoliageVSProIndirect_5daaeae117458b94ca071c13e7a67c32
            {
            };
            
            void SG_NMFoliageVSProIndirect_5daaeae117458b94ca071c13e7a67c32(float3 Vector3_314C8600, Bindings_NMFoliageVSProIndirect_5daaeae117458b94ca071c13e7a67c32 IN, out float3 ObjectSpacePosition_1)
            {
                float3 _Property_AF5E8C93_Out_0 = Vector3_314C8600;
                float3 _CustomFunction_E07FEE57_Out_1;
                InjectSetup_float(_Property_AF5E8C93_Out_0, _CustomFunction_E07FEE57_Out_1);
                float3 _CustomFunction_18EFD858_Out_1;
                AddPragma_float(_CustomFunction_E07FEE57_Out_1, _CustomFunction_18EFD858_Out_1);
                ObjectSpacePosition_1 = _CustomFunction_18EFD858_Out_1;
            }
            
            void Unity_Comparison_Greater_float(float A, float B, out float Out)
            {
                Out = A > B ? 1 : 0;
            }
            
            void Unity_Subtract_float(float A, float B, out float Out)
            {
                Out = A - B;
            }
            
            void Unity_Comparison_Less_float(float A, float B, out float Out)
            {
                Out = A < B ? 1 : 0;
            }
            
            void Unity_And_float(float A, float B, out float Out)
            {
                Out = A && B;
            }
            
            void Unity_Branch_float(float Predicate, float True, float False, out float Out)
            {
                Out = Predicate ? True : False;
            }
            
            void Unity_Multiply_float(float A, float B, out float Out)
            {
                Out = A * B;
            }
            
            void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
            {
                RGBA = float4(R, G, B, A);
                RGB = float3(R, G, B);
                RG = float2(R, G);
            }
            
            void Unity_Normalize_float3(float3 In, out float3 Out)
            {
                Out = normalize(In);
            }
            
            void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
            {
                Out = A * B;
            }
            
            void Unity_Subtract_float3(float3 A, float3 B, out float3 Out)
            {
                Out = A - B;
            }
            
            void Unity_Power_float(float A, float B, out float Out)
            {
                Out = pow(A, B);
            }
            
            void Unity_Add_float3(float3 A, float3 B, out float3 Out)
            {
                Out = A + B;
            }
            
            void Unity_Or_float(float A, float B, out float Out)
            {
                Out = A || B;
            }
            
            void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
            {
                Out = Predicate ? True : False;
            }
            
            void Unity_Length_float3(float3 In, out float Out)
            {
                Out = length(In);
            }
            
            void Unity_Add_float(float A, float B, out float Out)
            {
                Out = A + B;
            }
            
            struct Bindings_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10
            {
            };
            
            void SG_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10(float3 Vector3_604F121F, float3 Vector3_C30D997B, float Vector1_A2C4B4F4, float Vector1_7F78DDD2, TEXTURE2D_PARAM(Texture2D_5BAC276D, samplerTexture2D_5BAC276D), float4 Texture2D_5BAC276D_TexelSize, TEXTURE2D_PARAM(Texture2D_A3874DB9, samplerTexture2D_A3874DB9), float4 Texture2D_A3874DB9_TexelSize, float4 Vector4_EBFF8CDE, float Vector1_B4470F9B, float Vector1_2EC6D670, float Vector1_9365F438, float Vector1_F53C4B89, float Vector1_6803B355, float Vector1_5EFF6B1A, Bindings_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10 IN, out float3 direction_1, out float strength_2)
            {
                float4 _Property_70C0FA2E_Out_0 = Vector4_EBFF8CDE;
                float _Split_9EAD5A97_R_1 = _Property_70C0FA2E_Out_0[0];
                float _Split_9EAD5A97_G_2 = _Property_70C0FA2E_Out_0[1];
                float _Split_9EAD5A97_B_3 = _Property_70C0FA2E_Out_0[2];
                float _Split_9EAD5A97_A_4 = _Property_70C0FA2E_Out_0[3];
                float4 _Combine_B187C165_RGBA_4;
                float3 _Combine_B187C165_RGB_5;
                float2 _Combine_B187C165_RG_6;
                Unity_Combine_float(_Split_9EAD5A97_R_1, _Split_9EAD5A97_G_2, _Split_9EAD5A97_B_3, 0, _Combine_B187C165_RGBA_4, _Combine_B187C165_RGB_5, _Combine_B187C165_RG_6);
                float3 _Normalize_2F17E0EB_Out_1;
                Unity_Normalize_float3(_Combine_B187C165_RGB_5, _Normalize_2F17E0EB_Out_1);
                float4 _Property_5C87BB92_Out_0 = Vector4_EBFF8CDE;
                float _Split_D49FDEED_R_1 = _Property_5C87BB92_Out_0[0];
                float _Split_D49FDEED_G_2 = _Property_5C87BB92_Out_0[1];
                float _Split_D49FDEED_B_3 = _Property_5C87BB92_Out_0[2];
                float _Split_D49FDEED_A_4 = _Property_5C87BB92_Out_0[3];
                float3 _Multiply_B4A67D17_Out_2;
                Unity_Multiply_float(_Normalize_2F17E0EB_Out_1, (_Split_D49FDEED_A_4.xxx), _Multiply_B4A67D17_Out_2);
                float _Property_B93DC53_Out_0 = Vector1_9365F438;
                float _Comparison_43ADEEA_Out_2;
                Unity_Comparison_Greater_float(_Property_B93DC53_Out_0, 0, _Comparison_43ADEEA_Out_2);
                float3 _Property_F1C16A88_Out_0 = Vector3_C30D997B;
                float _Property_30FD117B_Out_0 = Vector1_9365F438;
                float3 _Multiply_201CFE4B_Out_2;
                Unity_Multiply_float(_Normalize_2F17E0EB_Out_1, (_Property_30FD117B_Out_0.xxx), _Multiply_201CFE4B_Out_2);
                float _Property_C2BB60B0_Out_0 = Vector1_5EFF6B1A;
                float3 _Multiply_3B9F632A_Out_2;
                Unity_Multiply_float(_Multiply_201CFE4B_Out_2, (_Property_C2BB60B0_Out_0.xxx), _Multiply_3B9F632A_Out_2);
                float3 _Subtract_A4C7E129_Out_2;
                Unity_Subtract_float3(_Property_F1C16A88_Out_0, _Multiply_3B9F632A_Out_2, _Subtract_A4C7E129_Out_2);
                float _Property_7A8C7E0C_Out_0 = Vector1_6803B355;
                float3 _Multiply_B5B8A5BC_Out_2;
                Unity_Multiply_float(_Subtract_A4C7E129_Out_2, (_Property_7A8C7E0C_Out_0.xxx), _Multiply_B5B8A5BC_Out_2);
                float _Split_FBE059F7_R_1 = _Multiply_B5B8A5BC_Out_2[0];
                float _Split_FBE059F7_G_2 = _Multiply_B5B8A5BC_Out_2[1];
                float _Split_FBE059F7_B_3 = _Multiply_B5B8A5BC_Out_2[2];
                float _Split_FBE059F7_A_4 = 0;
                float4 _Combine_72AAC837_RGBA_4;
                float3 _Combine_72AAC837_RGB_5;
                float2 _Combine_72AAC837_RG_6;
                Unity_Combine_float(_Split_FBE059F7_R_1, _Split_FBE059F7_B_3, 0, 0, _Combine_72AAC837_RGBA_4, _Combine_72AAC837_RGB_5, _Combine_72AAC837_RG_6);
                float4 _SampleTexture2DLOD_15CFA945_RGBA_0 = SAMPLE_TEXTURE2D_LOD(Texture2D_A3874DB9, samplerTexture2D_A3874DB9, _Combine_72AAC837_RG_6, 3);
                float _SampleTexture2DLOD_15CFA945_R_5 = _SampleTexture2DLOD_15CFA945_RGBA_0.r;
                float _SampleTexture2DLOD_15CFA945_G_6 = _SampleTexture2DLOD_15CFA945_RGBA_0.g;
                float _SampleTexture2DLOD_15CFA945_B_7 = _SampleTexture2DLOD_15CFA945_RGBA_0.b;
                float _SampleTexture2DLOD_15CFA945_A_8 = _SampleTexture2DLOD_15CFA945_RGBA_0.a;
                float _Branch_C4699449_Out_3;
                Unity_Branch_float(_Comparison_43ADEEA_Out_2, _SampleTexture2DLOD_15CFA945_R_5, 0, _Branch_C4699449_Out_3);
                float _Power_F95D44FE_Out_2;
                Unity_Power_float(_Branch_C4699449_Out_3, 2, _Power_F95D44FE_Out_2);
                float _Property_25A9D1E6_Out_0 = Vector1_F53C4B89;
                float _Multiply_48018D0E_Out_2;
                Unity_Multiply_float(_Power_F95D44FE_Out_2, _Property_25A9D1E6_Out_0, _Multiply_48018D0E_Out_2);
                float3 _Multiply_F98AFF5A_Out_2;
                Unity_Multiply_float((_Multiply_48018D0E_Out_2.xxx), _Normalize_2F17E0EB_Out_1, _Multiply_F98AFF5A_Out_2);
                float _Property_B3EBD96_Out_0 = Vector1_9365F438;
                float3 _Multiply_10232D61_Out_2;
                Unity_Multiply_float(_Multiply_F98AFF5A_Out_2, (_Property_B3EBD96_Out_0.xxx), _Multiply_10232D61_Out_2);
                float3 _Add_E4BDFE70_Out_2;
                Unity_Add_float3(_Multiply_B4A67D17_Out_2, _Multiply_10232D61_Out_2, _Add_E4BDFE70_Out_2);
                float4 _Property_DAA1D9B7_Out_0 = Vector4_EBFF8CDE;
                float _Split_A66E259B_R_1 = _Property_DAA1D9B7_Out_0[0];
                float _Split_A66E259B_G_2 = _Property_DAA1D9B7_Out_0[1];
                float _Split_A66E259B_B_3 = _Property_DAA1D9B7_Out_0[2];
                float _Split_A66E259B_A_4 = _Property_DAA1D9B7_Out_0[3];
                float _Comparison_C98EAD3C_Out_2;
                Unity_Comparison_Greater_float(_Split_A66E259B_A_4, 0, _Comparison_C98EAD3C_Out_2);
                float _Property_2EDECFEA_Out_0 = Vector1_2EC6D670;
                float _Comparison_2D5C726B_Out_2;
                Unity_Comparison_Greater_float(_Property_2EDECFEA_Out_0, 0, _Comparison_2D5C726B_Out_2);
                float _Or_104823B_Out_2;
                Unity_Or_float(_Comparison_C98EAD3C_Out_2, _Comparison_2D5C726B_Out_2, _Or_104823B_Out_2);
                float3 _Property_A717C7D9_Out_0 = Vector3_C30D997B;
                float3 _Multiply_86E49BF9_Out_2;
                Unity_Multiply_float(_Normalize_2F17E0EB_Out_1, (_Split_A66E259B_A_4.xxx), _Multiply_86E49BF9_Out_2);
                float3 _Multiply_E0B4CB76_Out_2;
                Unity_Multiply_float(_Multiply_86E49BF9_Out_2, (_Property_C2BB60B0_Out_0.xxx), _Multiply_E0B4CB76_Out_2);
                float3 _Subtract_E607F60E_Out_2;
                Unity_Subtract_float3(_Property_A717C7D9_Out_0, _Multiply_E0B4CB76_Out_2, _Subtract_E607F60E_Out_2);
                float _Property_6E24DFF0_Out_0 = Vector1_B4470F9B;
                float3 _Multiply_F1D4C2B0_Out_2;
                Unity_Multiply_float(_Subtract_E607F60E_Out_2, (_Property_6E24DFF0_Out_0.xxx), _Multiply_F1D4C2B0_Out_2);
                float _Split_C22BECE5_R_1 = _Multiply_F1D4C2B0_Out_2[0];
                float _Split_C22BECE5_G_2 = _Multiply_F1D4C2B0_Out_2[1];
                float _Split_C22BECE5_B_3 = _Multiply_F1D4C2B0_Out_2[2];
                float _Split_C22BECE5_A_4 = 0;
                float4 _Combine_AC8E2469_RGBA_4;
                float3 _Combine_AC8E2469_RGB_5;
                float2 _Combine_AC8E2469_RG_6;
                Unity_Combine_float(_Split_C22BECE5_R_1, _Split_C22BECE5_B_3, 0, 0, _Combine_AC8E2469_RGBA_4, _Combine_AC8E2469_RGB_5, _Combine_AC8E2469_RG_6);
                float4 _SampleTexture2DLOD_E609D4E_RGBA_0 = SAMPLE_TEXTURE2D_LOD(Texture2D_5BAC276D, samplerTexture2D_5BAC276D, _Combine_AC8E2469_RG_6, 3);
                float _SampleTexture2DLOD_E609D4E_R_5 = _SampleTexture2DLOD_E609D4E_RGBA_0.r;
                float _SampleTexture2DLOD_E609D4E_G_6 = _SampleTexture2DLOD_E609D4E_RGBA_0.g;
                float _SampleTexture2DLOD_E609D4E_B_7 = _SampleTexture2DLOD_E609D4E_RGBA_0.b;
                float _SampleTexture2DLOD_E609D4E_A_8 = _SampleTexture2DLOD_E609D4E_RGBA_0.a;
                float4 _Combine_7A76145C_RGBA_4;
                float3 _Combine_7A76145C_RGB_5;
                float2 _Combine_7A76145C_RG_6;
                Unity_Combine_float(_SampleTexture2DLOD_E609D4E_R_5, _SampleTexture2DLOD_E609D4E_G_6, _SampleTexture2DLOD_E609D4E_B_7, 0, _Combine_7A76145C_RGBA_4, _Combine_7A76145C_RGB_5, _Combine_7A76145C_RG_6);
                float3 _Add_761D3920_Out_2;
                Unity_Add_float3(_Combine_7A76145C_RGB_5, float3(-0.5, -0.5, -0.5), _Add_761D3920_Out_2);
                float3 _Branch_8C107061_Out_3;
                Unity_Branch_float3(_Or_104823B_Out_2, _Add_761D3920_Out_2, float3(0, 0, 0), _Branch_8C107061_Out_3);
                float _Property_CF1F92D7_Out_0 = Vector1_2EC6D670;
                float3 _Multiply_9BA2526D_Out_2;
                Unity_Multiply_float(_Branch_8C107061_Out_3, (_Property_CF1F92D7_Out_0.xxx), _Multiply_9BA2526D_Out_2);
                float3 _Add_EBF0803A_Out_2;
                Unity_Add_float3(_Add_E4BDFE70_Out_2, _Multiply_9BA2526D_Out_2, _Add_EBF0803A_Out_2);
                float _Property_F6EF5E6A_Out_0 = Vector1_A2C4B4F4;
                float3 _Multiply_E48C57DB_Out_2;
                Unity_Multiply_float(_Add_EBF0803A_Out_2, (_Property_F6EF5E6A_Out_0.xxx), _Multiply_E48C57DB_Out_2);
                float _Length_77726886_Out_1;
                Unity_Length_float3(_Multiply_E48C57DB_Out_2, _Length_77726886_Out_1);
                float _Property_E82EE598_Out_0 = Vector1_7F78DDD2;
                float _Add_D4269173_Out_2;
                Unity_Add_float(_Length_77726886_Out_1, _Property_E82EE598_Out_0, _Add_D4269173_Out_2);
                float _Multiply_C16CC36_Out_2;
                Unity_Multiply_float(_Add_D4269173_Out_2, 0.001, _Multiply_C16CC36_Out_2);
                direction_1 = _Multiply_E48C57DB_Out_2;
                strength_2 = _Multiply_C16CC36_Out_2;
            }
            
            void Unity_CrossProduct_float(float3 A, float3 B, out float3 Out)
            {
                Out = cross(A, B);
            }
            
            void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
            {
                Out = dot(A, B);
            }
            
            void Unity_Distance_float3(float3 A, float3 B, out float Out)
            {
                Out = distance(A, B);
            }
            
            void Unity_Divide_float(float A, float B, out float Out)
            {
                Out = A / B;
            }
            
            void Unity_Absolute_float(float In, out float Out)
            {
                Out = abs(In);
            }
            
            void Unity_Maximum_float(float A, float B, out float Out)
            {
                Out = max(A, B);
            }
            
            void Unity_Cosine_float(float In, out float Out)
            {
                Out = cos(In);
            }
            
            void Unity_Sine_float(float In, out float Out)
            {
                Out = sin(In);
            }
            
            void Unity_Comparison_NotEqual_float(float A, float B, out float Out)
            {
                Out = A != B ? 1 : 0;
            }
            
            struct Bindings_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf
            {
                float3 ObjectSpaceNormal;
                float3 WorldSpaceNormal;
                float3 ObjectSpaceTangent;
                float3 WorldSpaceTangent;
                float3 ObjectSpaceBiTangent;
                float3 WorldSpaceBiTangent;
                float4 VertexColor;
            };
            
            void SG_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf(float Vector1_BCB03E1A, float3 Vector3_C30D997B, float Vector1_A2C4B4F4, float Vector1_7EE0F94A, float Boolean_527CB26E, float Vector1_DE1BF63A, float Vector1_7F78DDD2, float3 Vector3_DE8CC74D, TEXTURE2D_PARAM(Texture2D_5BAC276D, samplerTexture2D_5BAC276D), float4 Texture2D_5BAC276D_TexelSize, TEXTURE2D_PARAM(Texture2D_A3874DB9, samplerTexture2D_A3874DB9), float4 Texture2D_A3874DB9_TexelSize, float4 Vector4_EBFF8CDE, float Vector1_B4470F9B, float Vector1_2EC6D670, float Vector1_9365F438, float Vector1_F53C4B89, float Vector1_6803B355, Bindings_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf IN, out float3 vertex_1, out float3 normal_2)
            {
                float4 _Vector4_96035CAB_Out_0 = float4(0, 0, 0, 1);
                float3 _Transform_56C94D33_Out_1 = TransformObjectToWorld((_Vector4_96035CAB_Out_0.xyz).xyz);
                float3 _Property_ED8BB836_Out_0 = Vector3_C30D997B;
                float3 _Transform_A839B73F_Out_1 = TransformObjectToWorld(_Property_ED8BB836_Out_0.xyz);
                float _Property_46785E9D_Out_0 = Boolean_527CB26E;
                float _Property_309A125A_Out_0 = Vector1_7EE0F94A;
                float _Comparison_FB7B17F4_Out_2;
                Unity_Comparison_Greater_float(_Property_309A125A_Out_0, 0, _Comparison_FB7B17F4_Out_2);
                float _Split_9DCBE03C_R_1 = _Transform_A839B73F_Out_1[0];
                float _Split_9DCBE03C_G_2 = _Transform_A839B73F_Out_1[1];
                float _Split_9DCBE03C_B_3 = _Transform_A839B73F_Out_1[2];
                float _Split_9DCBE03C_A_4 = 0;
                float _Split_2643B819_R_1 = _Transform_56C94D33_Out_1[0];
                float _Split_2643B819_G_2 = _Transform_56C94D33_Out_1[1];
                float _Split_2643B819_B_3 = _Transform_56C94D33_Out_1[2];
                float _Split_2643B819_A_4 = 0;
                float _Subtract_72710DB_Out_2;
                Unity_Subtract_float(_Split_9DCBE03C_G_2, _Split_2643B819_G_2, _Subtract_72710DB_Out_2);
                float _Comparison_A59CB55E_Out_2;
                Unity_Comparison_Less_float(_Subtract_72710DB_Out_2, _Property_309A125A_Out_0, _Comparison_A59CB55E_Out_2);
                float _And_75A07D3D_Out_2;
                Unity_And_float(_Comparison_FB7B17F4_Out_2, _Comparison_A59CB55E_Out_2, _And_75A07D3D_Out_2);
                float _Property_C5B18F25_Out_0 = Vector1_A2C4B4F4;
                float _Branch_71DEDA04_Out_3;
                Unity_Branch_float(_And_75A07D3D_Out_2, 1E-05, _Property_C5B18F25_Out_0, _Branch_71DEDA04_Out_3);
                float _Split_CAA3FAC4_R_1 = IN.VertexColor[0];
                float _Split_CAA3FAC4_G_2 = IN.VertexColor[1];
                float _Split_CAA3FAC4_B_3 = IN.VertexColor[2];
                float _Split_CAA3FAC4_A_4 = IN.VertexColor[3];
                float _Multiply_6282C968_Out_2;
                Unity_Multiply_float(_Branch_71DEDA04_Out_3, _Split_CAA3FAC4_A_4, _Multiply_6282C968_Out_2);
                float _Branch_FD6CEDEF_Out_3;
                Unity_Branch_float(_Property_46785E9D_Out_0, _Multiply_6282C968_Out_2, _Branch_71DEDA04_Out_3, _Branch_FD6CEDEF_Out_3);
                float _Property_8C9BC3F_Out_0 = Vector1_7F78DDD2;
                float4 _Property_DB8C20D5_Out_0 = Vector4_EBFF8CDE;
                float _Property_C83CCC0B_Out_0 = Vector1_B4470F9B;
                float _Property_9121207F_Out_0 = Vector1_2EC6D670;
                float _Property_9105DCD7_Out_0 = Vector1_9365F438;
                float _Property_6EE84426_Out_0 = Vector1_F53C4B89;
                float _Property_51392D3_Out_0 = Vector1_6803B355;
                float _Property_3C488CF_Out_0 = Vector1_BCB03E1A;
                Bindings_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10 _WindNMCalculateNoShiver_A0D948FA;
                float3 _WindNMCalculateNoShiver_A0D948FA_direction_1;
                float _WindNMCalculateNoShiver_A0D948FA_strength_2;
                SG_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10(_Transform_A839B73F_Out_1, _Transform_56C94D33_Out_1, _Branch_FD6CEDEF_Out_3, _Property_8C9BC3F_Out_0, TEXTURE2D_ARGS(Texture2D_5BAC276D, samplerTexture2D_5BAC276D), Texture2D_5BAC276D_TexelSize, TEXTURE2D_ARGS(Texture2D_A3874DB9, samplerTexture2D_A3874DB9), Texture2D_A3874DB9_TexelSize, _Property_DB8C20D5_Out_0, _Property_C83CCC0B_Out_0, _Property_9121207F_Out_0, _Property_9105DCD7_Out_0, _Property_6EE84426_Out_0, _Property_51392D3_Out_0, _Property_3C488CF_Out_0, _WindNMCalculateNoShiver_A0D948FA, _WindNMCalculateNoShiver_A0D948FA_direction_1, _WindNMCalculateNoShiver_A0D948FA_strength_2);
                float3 _CrossProduct_417F56_Out_2;
                Unity_CrossProduct_float(float3 (0, 1, 0), _WindNMCalculateNoShiver_A0D948FA_direction_1, _CrossProduct_417F56_Out_2);
                float3 _Normalize_4E99CADE_Out_1;
                Unity_Normalize_float3(_CrossProduct_417F56_Out_2, _Normalize_4E99CADE_Out_1);
                float3 _Subtract_8E413BBF_Out_2;
                Unity_Subtract_float3(_Transform_A839B73F_Out_1, _Transform_56C94D33_Out_1, _Subtract_8E413BBF_Out_2);
                float _DotProduct_111C5979_Out_2;
                Unity_DotProduct_float3(_Normalize_4E99CADE_Out_1, _Subtract_8E413BBF_Out_2, _DotProduct_111C5979_Out_2);
                float3 _Multiply_6B4F7E94_Out_2;
                Unity_Multiply_float(_Normalize_4E99CADE_Out_1, (_DotProduct_111C5979_Out_2.xxx), _Multiply_6B4F7E94_Out_2);
                float3 _Add_20CCB137_Out_2;
                Unity_Add_float3(_Transform_56C94D33_Out_1, _Multiply_6B4F7E94_Out_2, _Add_20CCB137_Out_2);
                float3 _Subtract_32DFFF4F_Out_2;
                Unity_Subtract_float3(_Transform_A839B73F_Out_1, _Add_20CCB137_Out_2, _Subtract_32DFFF4F_Out_2);
                float _Distance_77B26FEA_Out_2;
                Unity_Distance_float3(_Transform_A839B73F_Out_1, _Transform_56C94D33_Out_1, _Distance_77B26FEA_Out_2);
                float _Property_FB0C946E_Out_0 = Vector1_DE1BF63A;
                float _Divide_C2F89B8E_Out_2;
                Unity_Divide_float(_Distance_77B26FEA_Out_2, _Property_FB0C946E_Out_0, _Divide_C2F89B8E_Out_2);
                float _Absolute_F60A1055_Out_1;
                Unity_Absolute_float(_Divide_C2F89B8E_Out_2, _Absolute_F60A1055_Out_1);
                float _Vector1_776AF5AC_Out_0 = 1E-07;
                float _Maximum_4166AFF2_Out_2;
                Unity_Maximum_float(_Absolute_F60A1055_Out_1, _Vector1_776AF5AC_Out_0, _Maximum_4166AFF2_Out_2);
                float _Divide_C7B0EA9F_Out_2;
                Unity_Divide_float(1, _Property_FB0C946E_Out_0, _Divide_C7B0EA9F_Out_2);
                float _Power_A9B007BF_Out_2;
                Unity_Power_float(_Maximum_4166AFF2_Out_2, _Divide_C7B0EA9F_Out_2, _Power_A9B007BF_Out_2);
                float _Multiply_58839CDF_Out_2;
                Unity_Multiply_float(_WindNMCalculateNoShiver_A0D948FA_strength_2, _Power_A9B007BF_Out_2, _Multiply_58839CDF_Out_2);
                float _Cosine_C162178D_Out_1;
                Unity_Cosine_float(_Multiply_58839CDF_Out_2, _Cosine_C162178D_Out_1);
                float3 _Multiply_B16DE76A_Out_2;
                Unity_Multiply_float(_Subtract_32DFFF4F_Out_2, (_Cosine_C162178D_Out_1.xxx), _Multiply_B16DE76A_Out_2);
                float3 _CrossProduct_10AAB5C9_Out_2;
                Unity_CrossProduct_float(_Normalize_4E99CADE_Out_1, _Subtract_32DFFF4F_Out_2, _CrossProduct_10AAB5C9_Out_2);
                float _Sine_CD6051C7_Out_1;
                Unity_Sine_float(_Multiply_58839CDF_Out_2, _Sine_CD6051C7_Out_1);
                float3 _Multiply_E565B59B_Out_2;
                Unity_Multiply_float(_CrossProduct_10AAB5C9_Out_2, (_Sine_CD6051C7_Out_1.xxx), _Multiply_E565B59B_Out_2);
                float3 _Add_70586F80_Out_2;
                Unity_Add_float3(_Multiply_B16DE76A_Out_2, _Multiply_E565B59B_Out_2, _Add_70586F80_Out_2);
                float3 _Add_773B285F_Out_2;
                Unity_Add_float3(_Add_20CCB137_Out_2, _Add_70586F80_Out_2, _Add_773B285F_Out_2);
                float3 _Transform_3BC8B282_Out_1 = TransformWorldToObject(_Add_773B285F_Out_2.xyz);
                float3 _Property_37555482_Out_0 = Vector3_DE8CC74D;
                float _Length_2799ABFE_Out_1;
                Unity_Length_float3(_Property_37555482_Out_0, _Length_2799ABFE_Out_1);
                float _Comparison_4940F3B6_Out_2;
                Unity_Comparison_NotEqual_float(_Length_2799ABFE_Out_1, 0, _Comparison_4940F3B6_Out_2);
                float3 _Multiply_5354DD91_Out_2;
                Unity_Multiply_float(IN.WorldSpaceNormal, _Property_37555482_Out_0, _Multiply_5354DD91_Out_2);
                float3 _Branch_993A8BB_Out_3;
                Unity_Branch_float3(_Comparison_4940F3B6_Out_2, _Multiply_5354DD91_Out_2, IN.WorldSpaceNormal, _Branch_993A8BB_Out_3);
                vertex_1 = _Transform_3BC8B282_Out_1;
                normal_2 = _Branch_993A8BB_Out_3;
            }
        
            // Graph Vertex
            struct VertexDescriptionInputs
            {
                float3 ObjectSpaceNormal;
                float3 WorldSpaceNormal;
                float3 ObjectSpaceTangent;
                float3 WorldSpaceTangent;
                float3 ObjectSpaceBiTangent;
                float3 WorldSpaceBiTangent;
                float3 ObjectSpacePosition;
                float4 VertexColor;
                float3 TimeParameters;
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
                Bindings_NMFoliageVSProIndirect_5daaeae117458b94ca071c13e7a67c32 _NMFoliageVSProIndirect_6AFECCFE;
                float3 _NMFoliageVSProIndirect_6AFECCFE_ObjectSpacePosition_1;
                SG_NMFoliageVSProIndirect_5daaeae117458b94ca071c13e7a67c32(IN.ObjectSpacePosition, _NMFoliageVSProIndirect_6AFECCFE, _NMFoliageVSProIndirect_6AFECCFE_ObjectSpacePosition_1);
                float _Property_3E4B4411_Out_0 = _Drag;
                float _Property_7F252CE7_Out_0 = _HeightDrag;
                float _Property_7865D519_Out_0 = _Stiffness;
                float _Property_D5195AAC_Out_0 = _InitialBend;
                float4 _Property_FFB305BA_Out_0 = _NewNormal;
                float4 _Property_46C9B1EE_Out_0 = WIND_SETTINGS_WorldDirectionAndSpeed;
                float _Property_F9C82607_Out_0 = WIND_SETTINGS_FlexNoiseScale;
                float _Property_1DC2420_Out_0 = WIND_SETTINGS_Turbulence;
                float _Property_753163F4_Out_0 = WIND_SETTINGS_GustSpeed;
                float _Property_249371F4_Out_0 = WIND_SETTINGS_GustScale;
                float _Property_6A8E929E_Out_0 = WIND_SETTINGS_GustWorldScale;
                Bindings_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf _WindNMNoShiver_A2E31333;
                _WindNMNoShiver_A2E31333.ObjectSpaceNormal = IN.ObjectSpaceNormal;
                _WindNMNoShiver_A2E31333.WorldSpaceNormal = IN.WorldSpaceNormal;
                _WindNMNoShiver_A2E31333.ObjectSpaceTangent = IN.ObjectSpaceTangent;
                _WindNMNoShiver_A2E31333.WorldSpaceTangent = IN.WorldSpaceTangent;
                _WindNMNoShiver_A2E31333.ObjectSpaceBiTangent = IN.ObjectSpaceBiTangent;
                _WindNMNoShiver_A2E31333.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
                _WindNMNoShiver_A2E31333.VertexColor = IN.VertexColor;
                float3 _WindNMNoShiver_A2E31333_vertex_1;
                float3 _WindNMNoShiver_A2E31333_normal_2;
                SG_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf(IN.TimeParameters.x, _NMFoliageVSProIndirect_6AFECCFE_ObjectSpacePosition_1, _Property_3E4B4411_Out_0, _Property_7F252CE7_Out_0, 0, _Property_7865D519_Out_0, _Property_D5195AAC_Out_0, (_Property_FFB305BA_Out_0.xyz), TEXTURE2D_ARGS(WIND_SETTINGS_TexNoise, samplerWIND_SETTINGS_TexNoise), WIND_SETTINGS_TexNoise_TexelSize, TEXTURE2D_ARGS(WIND_SETTINGS_TexGust, samplerWIND_SETTINGS_TexGust), WIND_SETTINGS_TexGust_TexelSize, _Property_46C9B1EE_Out_0, _Property_F9C82607_Out_0, _Property_1DC2420_Out_0, _Property_753163F4_Out_0, _Property_249371F4_Out_0, _Property_6A8E929E_Out_0, _WindNMNoShiver_A2E31333, _WindNMNoShiver_A2E31333_vertex_1, _WindNMNoShiver_A2E31333_normal_2);
                description.VertexPosition = _WindNMNoShiver_A2E31333_vertex_1;
                description.VertexNormal = IN.ObjectSpaceNormal;
                description.VertexTangent = IN.ObjectSpaceTangent;
                return description;
            }
            
            // Graph Pixel
            struct SurfaceDescriptionInputs
            {
            };
            
            struct SurfaceDescription
            {
                float Alpha;
                float AlphaClipThreshold;
            };
            
            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
            {
                SurfaceDescription surface = (SurfaceDescription)0;
                surface.Alpha = 1;
                surface.AlphaClipThreshold = 0.5;
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
                float4 color : COLOR;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif
            };
        
            // Generated Type: Varyings
            struct Varyings
            {
                float4 positionCS : SV_POSITION;
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
                output.WorldSpaceNormal =            TransformObjectToWorldNormal(input.normalOS);
                output.ObjectSpaceTangent =          input.tangentOS;
                output.WorldSpaceTangent =           TransformObjectToWorldDir(input.tangentOS.xyz);
                output.ObjectSpaceBiTangent =        normalize(cross(input.normalOS, input.tangentOS) * (input.tangentOS.w > 0.0f ? 1.0f : -1.0f) * GetOddNegativeScale());
                output.WorldSpaceBiTangent =         TransformObjectToWorldDir(output.ObjectSpaceBiTangent);
                output.ObjectSpacePosition =         input.positionOS;
                output.VertexColor =                 input.color;
                output.TimeParameters =              _TimeParameters.xyz;
            
                return output;
            }
            
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
            
            
            
            
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
            #define ATTRIBUTES_NEED_TEXCOORD3
            #define ATTRIBUTES_NEED_COLOR
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_TEXCOORD3
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
            float4 _TrunkBaseColor;
            float4 _TrunkTilingOffset;
            float _TrunkNormalScale;
            float _TrunkMetallic;
            float _TrunkAORemapMin;
            float _TrunkAORemapMax;
            float _TrunkSmoothnessRemapMin;
            float _TrunkSmoothnessRemapMax;
            float4 _BarkBlendMaskTilingOffset;
            float4 _BarkBaseColor;
            float _BarkUseUV3;
            float4 _BarkTilingOffset;
            float _BarkNormalScale;
            float _BarkMetallic;
            float _BarkSmoothnessRemapMin;
            float _BarkSmoothnessRemapMax;
            float _BarkAORemapMin;
            float _BarkAORemapMax;
            float _Stiffness;
            float _InitialBend;
            float _Drag;
            float _HeightDrag;
            float4 _NewNormal;
            CBUFFER_END
            TEXTURE2D(_TrunkBaseColorMap); SAMPLER(sampler_TrunkBaseColorMap); float4 _TrunkBaseColorMap_TexelSize;
            TEXTURE2D(_TrunkNormalMap); SAMPLER(sampler_TrunkNormalMap); float4 _TrunkNormalMap_TexelSize;
            TEXTURE2D(_TrunkMaskMap); SAMPLER(sampler_TrunkMaskMap); float4 _TrunkMaskMap_TexelSize;
            TEXTURE2D(_LayerMask); SAMPLER(sampler_LayerMask); float4 _LayerMask_TexelSize;
            TEXTURE2D(_BarkBaseColorMap); SAMPLER(sampler_BarkBaseColorMap); float4 _BarkBaseColorMap_TexelSize;
            TEXTURE2D(_BarkNormalMap); SAMPLER(sampler_BarkNormalMap); float4 _BarkNormalMap_TexelSize;
            TEXTURE2D(_BarkMaskMap); SAMPLER(sampler_BarkMaskMap); float4 _BarkMaskMap_TexelSize;
            float WIND_SETTINGS_GustWorldScale;
            float WIND_SETTINGS_GustScale;
            float WIND_SETTINGS_GustSpeed;
            float WIND_SETTINGS_Turbulence;
            float WIND_SETTINGS_ShiverNoiseScale;
            float WIND_SETTINGS_FlexNoiseScale;
            float4 WIND_SETTINGS_WorldDirectionAndSpeed;
            TEXTURE2D(WIND_SETTINGS_TexGust); SAMPLER(samplerWIND_SETTINGS_TexGust); float4 WIND_SETTINGS_TexGust_TexelSize;
            TEXTURE2D(WIND_SETTINGS_TexNoise); SAMPLER(samplerWIND_SETTINGS_TexNoise); float4 WIND_SETTINGS_TexNoise_TexelSize;
            SAMPLER(_SampleTexture2DLOD_15CFA945_Sampler_3_Linear_Repeat);
            SAMPLER(_SampleTexture2DLOD_E609D4E_Sampler_3_Linear_Repeat);
            SAMPLER(_SampleTexture2D_B919BA28_Sampler_3_Linear_Repeat);
            SAMPLER(_SampleTexture2D_7E4BB55F_Sampler_3_Linear_Repeat);
            SAMPLER(_SampleTexture2D_BCB513F9_Sampler_3_Linear_Repeat);
        
            // Graph Functions
            
            // c21cb3b956f4ef1fbcd1fae12d599429
            #include "Assets/NatureManufacture Assets/Foliage Shaders/NM_Foliage_VSPro_Indirect.cginc"
            
            void AddPragma_float(float3 A, out float3 Out)
            {
                #pragma instancing_options renderinglayer procedural:setupVSPro
                Out = A;
            }
            
            struct Bindings_NMFoliageVSProIndirect_5daaeae117458b94ca071c13e7a67c32
            {
            };
            
            void SG_NMFoliageVSProIndirect_5daaeae117458b94ca071c13e7a67c32(float3 Vector3_314C8600, Bindings_NMFoliageVSProIndirect_5daaeae117458b94ca071c13e7a67c32 IN, out float3 ObjectSpacePosition_1)
            {
                float3 _Property_AF5E8C93_Out_0 = Vector3_314C8600;
                float3 _CustomFunction_E07FEE57_Out_1;
                InjectSetup_float(_Property_AF5E8C93_Out_0, _CustomFunction_E07FEE57_Out_1);
                float3 _CustomFunction_18EFD858_Out_1;
                AddPragma_float(_CustomFunction_E07FEE57_Out_1, _CustomFunction_18EFD858_Out_1);
                ObjectSpacePosition_1 = _CustomFunction_18EFD858_Out_1;
            }
            
            void Unity_Comparison_Greater_float(float A, float B, out float Out)
            {
                Out = A > B ? 1 : 0;
            }
            
            void Unity_Subtract_float(float A, float B, out float Out)
            {
                Out = A - B;
            }
            
            void Unity_Comparison_Less_float(float A, float B, out float Out)
            {
                Out = A < B ? 1 : 0;
            }
            
            void Unity_And_float(float A, float B, out float Out)
            {
                Out = A && B;
            }
            
            void Unity_Branch_float(float Predicate, float True, float False, out float Out)
            {
                Out = Predicate ? True : False;
            }
            
            void Unity_Multiply_float(float A, float B, out float Out)
            {
                Out = A * B;
            }
            
            void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
            {
                RGBA = float4(R, G, B, A);
                RGB = float3(R, G, B);
                RG = float2(R, G);
            }
            
            void Unity_Normalize_float3(float3 In, out float3 Out)
            {
                Out = normalize(In);
            }
            
            void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
            {
                Out = A * B;
            }
            
            void Unity_Subtract_float3(float3 A, float3 B, out float3 Out)
            {
                Out = A - B;
            }
            
            void Unity_Power_float(float A, float B, out float Out)
            {
                Out = pow(A, B);
            }
            
            void Unity_Add_float3(float3 A, float3 B, out float3 Out)
            {
                Out = A + B;
            }
            
            void Unity_Or_float(float A, float B, out float Out)
            {
                Out = A || B;
            }
            
            void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
            {
                Out = Predicate ? True : False;
            }
            
            void Unity_Length_float3(float3 In, out float Out)
            {
                Out = length(In);
            }
            
            void Unity_Add_float(float A, float B, out float Out)
            {
                Out = A + B;
            }
            
            struct Bindings_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10
            {
            };
            
            void SG_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10(float3 Vector3_604F121F, float3 Vector3_C30D997B, float Vector1_A2C4B4F4, float Vector1_7F78DDD2, TEXTURE2D_PARAM(Texture2D_5BAC276D, samplerTexture2D_5BAC276D), float4 Texture2D_5BAC276D_TexelSize, TEXTURE2D_PARAM(Texture2D_A3874DB9, samplerTexture2D_A3874DB9), float4 Texture2D_A3874DB9_TexelSize, float4 Vector4_EBFF8CDE, float Vector1_B4470F9B, float Vector1_2EC6D670, float Vector1_9365F438, float Vector1_F53C4B89, float Vector1_6803B355, float Vector1_5EFF6B1A, Bindings_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10 IN, out float3 direction_1, out float strength_2)
            {
                float4 _Property_70C0FA2E_Out_0 = Vector4_EBFF8CDE;
                float _Split_9EAD5A97_R_1 = _Property_70C0FA2E_Out_0[0];
                float _Split_9EAD5A97_G_2 = _Property_70C0FA2E_Out_0[1];
                float _Split_9EAD5A97_B_3 = _Property_70C0FA2E_Out_0[2];
                float _Split_9EAD5A97_A_4 = _Property_70C0FA2E_Out_0[3];
                float4 _Combine_B187C165_RGBA_4;
                float3 _Combine_B187C165_RGB_5;
                float2 _Combine_B187C165_RG_6;
                Unity_Combine_float(_Split_9EAD5A97_R_1, _Split_9EAD5A97_G_2, _Split_9EAD5A97_B_3, 0, _Combine_B187C165_RGBA_4, _Combine_B187C165_RGB_5, _Combine_B187C165_RG_6);
                float3 _Normalize_2F17E0EB_Out_1;
                Unity_Normalize_float3(_Combine_B187C165_RGB_5, _Normalize_2F17E0EB_Out_1);
                float4 _Property_5C87BB92_Out_0 = Vector4_EBFF8CDE;
                float _Split_D49FDEED_R_1 = _Property_5C87BB92_Out_0[0];
                float _Split_D49FDEED_G_2 = _Property_5C87BB92_Out_0[1];
                float _Split_D49FDEED_B_3 = _Property_5C87BB92_Out_0[2];
                float _Split_D49FDEED_A_4 = _Property_5C87BB92_Out_0[3];
                float3 _Multiply_B4A67D17_Out_2;
                Unity_Multiply_float(_Normalize_2F17E0EB_Out_1, (_Split_D49FDEED_A_4.xxx), _Multiply_B4A67D17_Out_2);
                float _Property_B93DC53_Out_0 = Vector1_9365F438;
                float _Comparison_43ADEEA_Out_2;
                Unity_Comparison_Greater_float(_Property_B93DC53_Out_0, 0, _Comparison_43ADEEA_Out_2);
                float3 _Property_F1C16A88_Out_0 = Vector3_C30D997B;
                float _Property_30FD117B_Out_0 = Vector1_9365F438;
                float3 _Multiply_201CFE4B_Out_2;
                Unity_Multiply_float(_Normalize_2F17E0EB_Out_1, (_Property_30FD117B_Out_0.xxx), _Multiply_201CFE4B_Out_2);
                float _Property_C2BB60B0_Out_0 = Vector1_5EFF6B1A;
                float3 _Multiply_3B9F632A_Out_2;
                Unity_Multiply_float(_Multiply_201CFE4B_Out_2, (_Property_C2BB60B0_Out_0.xxx), _Multiply_3B9F632A_Out_2);
                float3 _Subtract_A4C7E129_Out_2;
                Unity_Subtract_float3(_Property_F1C16A88_Out_0, _Multiply_3B9F632A_Out_2, _Subtract_A4C7E129_Out_2);
                float _Property_7A8C7E0C_Out_0 = Vector1_6803B355;
                float3 _Multiply_B5B8A5BC_Out_2;
                Unity_Multiply_float(_Subtract_A4C7E129_Out_2, (_Property_7A8C7E0C_Out_0.xxx), _Multiply_B5B8A5BC_Out_2);
                float _Split_FBE059F7_R_1 = _Multiply_B5B8A5BC_Out_2[0];
                float _Split_FBE059F7_G_2 = _Multiply_B5B8A5BC_Out_2[1];
                float _Split_FBE059F7_B_3 = _Multiply_B5B8A5BC_Out_2[2];
                float _Split_FBE059F7_A_4 = 0;
                float4 _Combine_72AAC837_RGBA_4;
                float3 _Combine_72AAC837_RGB_5;
                float2 _Combine_72AAC837_RG_6;
                Unity_Combine_float(_Split_FBE059F7_R_1, _Split_FBE059F7_B_3, 0, 0, _Combine_72AAC837_RGBA_4, _Combine_72AAC837_RGB_5, _Combine_72AAC837_RG_6);
                float4 _SampleTexture2DLOD_15CFA945_RGBA_0 = SAMPLE_TEXTURE2D_LOD(Texture2D_A3874DB9, samplerTexture2D_A3874DB9, _Combine_72AAC837_RG_6, 3);
                float _SampleTexture2DLOD_15CFA945_R_5 = _SampleTexture2DLOD_15CFA945_RGBA_0.r;
                float _SampleTexture2DLOD_15CFA945_G_6 = _SampleTexture2DLOD_15CFA945_RGBA_0.g;
                float _SampleTexture2DLOD_15CFA945_B_7 = _SampleTexture2DLOD_15CFA945_RGBA_0.b;
                float _SampleTexture2DLOD_15CFA945_A_8 = _SampleTexture2DLOD_15CFA945_RGBA_0.a;
                float _Branch_C4699449_Out_3;
                Unity_Branch_float(_Comparison_43ADEEA_Out_2, _SampleTexture2DLOD_15CFA945_R_5, 0, _Branch_C4699449_Out_3);
                float _Power_F95D44FE_Out_2;
                Unity_Power_float(_Branch_C4699449_Out_3, 2, _Power_F95D44FE_Out_2);
                float _Property_25A9D1E6_Out_0 = Vector1_F53C4B89;
                float _Multiply_48018D0E_Out_2;
                Unity_Multiply_float(_Power_F95D44FE_Out_2, _Property_25A9D1E6_Out_0, _Multiply_48018D0E_Out_2);
                float3 _Multiply_F98AFF5A_Out_2;
                Unity_Multiply_float((_Multiply_48018D0E_Out_2.xxx), _Normalize_2F17E0EB_Out_1, _Multiply_F98AFF5A_Out_2);
                float _Property_B3EBD96_Out_0 = Vector1_9365F438;
                float3 _Multiply_10232D61_Out_2;
                Unity_Multiply_float(_Multiply_F98AFF5A_Out_2, (_Property_B3EBD96_Out_0.xxx), _Multiply_10232D61_Out_2);
                float3 _Add_E4BDFE70_Out_2;
                Unity_Add_float3(_Multiply_B4A67D17_Out_2, _Multiply_10232D61_Out_2, _Add_E4BDFE70_Out_2);
                float4 _Property_DAA1D9B7_Out_0 = Vector4_EBFF8CDE;
                float _Split_A66E259B_R_1 = _Property_DAA1D9B7_Out_0[0];
                float _Split_A66E259B_G_2 = _Property_DAA1D9B7_Out_0[1];
                float _Split_A66E259B_B_3 = _Property_DAA1D9B7_Out_0[2];
                float _Split_A66E259B_A_4 = _Property_DAA1D9B7_Out_0[3];
                float _Comparison_C98EAD3C_Out_2;
                Unity_Comparison_Greater_float(_Split_A66E259B_A_4, 0, _Comparison_C98EAD3C_Out_2);
                float _Property_2EDECFEA_Out_0 = Vector1_2EC6D670;
                float _Comparison_2D5C726B_Out_2;
                Unity_Comparison_Greater_float(_Property_2EDECFEA_Out_0, 0, _Comparison_2D5C726B_Out_2);
                float _Or_104823B_Out_2;
                Unity_Or_float(_Comparison_C98EAD3C_Out_2, _Comparison_2D5C726B_Out_2, _Or_104823B_Out_2);
                float3 _Property_A717C7D9_Out_0 = Vector3_C30D997B;
                float3 _Multiply_86E49BF9_Out_2;
                Unity_Multiply_float(_Normalize_2F17E0EB_Out_1, (_Split_A66E259B_A_4.xxx), _Multiply_86E49BF9_Out_2);
                float3 _Multiply_E0B4CB76_Out_2;
                Unity_Multiply_float(_Multiply_86E49BF9_Out_2, (_Property_C2BB60B0_Out_0.xxx), _Multiply_E0B4CB76_Out_2);
                float3 _Subtract_E607F60E_Out_2;
                Unity_Subtract_float3(_Property_A717C7D9_Out_0, _Multiply_E0B4CB76_Out_2, _Subtract_E607F60E_Out_2);
                float _Property_6E24DFF0_Out_0 = Vector1_B4470F9B;
                float3 _Multiply_F1D4C2B0_Out_2;
                Unity_Multiply_float(_Subtract_E607F60E_Out_2, (_Property_6E24DFF0_Out_0.xxx), _Multiply_F1D4C2B0_Out_2);
                float _Split_C22BECE5_R_1 = _Multiply_F1D4C2B0_Out_2[0];
                float _Split_C22BECE5_G_2 = _Multiply_F1D4C2B0_Out_2[1];
                float _Split_C22BECE5_B_3 = _Multiply_F1D4C2B0_Out_2[2];
                float _Split_C22BECE5_A_4 = 0;
                float4 _Combine_AC8E2469_RGBA_4;
                float3 _Combine_AC8E2469_RGB_5;
                float2 _Combine_AC8E2469_RG_6;
                Unity_Combine_float(_Split_C22BECE5_R_1, _Split_C22BECE5_B_3, 0, 0, _Combine_AC8E2469_RGBA_4, _Combine_AC8E2469_RGB_5, _Combine_AC8E2469_RG_6);
                float4 _SampleTexture2DLOD_E609D4E_RGBA_0 = SAMPLE_TEXTURE2D_LOD(Texture2D_5BAC276D, samplerTexture2D_5BAC276D, _Combine_AC8E2469_RG_6, 3);
                float _SampleTexture2DLOD_E609D4E_R_5 = _SampleTexture2DLOD_E609D4E_RGBA_0.r;
                float _SampleTexture2DLOD_E609D4E_G_6 = _SampleTexture2DLOD_E609D4E_RGBA_0.g;
                float _SampleTexture2DLOD_E609D4E_B_7 = _SampleTexture2DLOD_E609D4E_RGBA_0.b;
                float _SampleTexture2DLOD_E609D4E_A_8 = _SampleTexture2DLOD_E609D4E_RGBA_0.a;
                float4 _Combine_7A76145C_RGBA_4;
                float3 _Combine_7A76145C_RGB_5;
                float2 _Combine_7A76145C_RG_6;
                Unity_Combine_float(_SampleTexture2DLOD_E609D4E_R_5, _SampleTexture2DLOD_E609D4E_G_6, _SampleTexture2DLOD_E609D4E_B_7, 0, _Combine_7A76145C_RGBA_4, _Combine_7A76145C_RGB_5, _Combine_7A76145C_RG_6);
                float3 _Add_761D3920_Out_2;
                Unity_Add_float3(_Combine_7A76145C_RGB_5, float3(-0.5, -0.5, -0.5), _Add_761D3920_Out_2);
                float3 _Branch_8C107061_Out_3;
                Unity_Branch_float3(_Or_104823B_Out_2, _Add_761D3920_Out_2, float3(0, 0, 0), _Branch_8C107061_Out_3);
                float _Property_CF1F92D7_Out_0 = Vector1_2EC6D670;
                float3 _Multiply_9BA2526D_Out_2;
                Unity_Multiply_float(_Branch_8C107061_Out_3, (_Property_CF1F92D7_Out_0.xxx), _Multiply_9BA2526D_Out_2);
                float3 _Add_EBF0803A_Out_2;
                Unity_Add_float3(_Add_E4BDFE70_Out_2, _Multiply_9BA2526D_Out_2, _Add_EBF0803A_Out_2);
                float _Property_F6EF5E6A_Out_0 = Vector1_A2C4B4F4;
                float3 _Multiply_E48C57DB_Out_2;
                Unity_Multiply_float(_Add_EBF0803A_Out_2, (_Property_F6EF5E6A_Out_0.xxx), _Multiply_E48C57DB_Out_2);
                float _Length_77726886_Out_1;
                Unity_Length_float3(_Multiply_E48C57DB_Out_2, _Length_77726886_Out_1);
                float _Property_E82EE598_Out_0 = Vector1_7F78DDD2;
                float _Add_D4269173_Out_2;
                Unity_Add_float(_Length_77726886_Out_1, _Property_E82EE598_Out_0, _Add_D4269173_Out_2);
                float _Multiply_C16CC36_Out_2;
                Unity_Multiply_float(_Add_D4269173_Out_2, 0.001, _Multiply_C16CC36_Out_2);
                direction_1 = _Multiply_E48C57DB_Out_2;
                strength_2 = _Multiply_C16CC36_Out_2;
            }
            
            void Unity_CrossProduct_float(float3 A, float3 B, out float3 Out)
            {
                Out = cross(A, B);
            }
            
            void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
            {
                Out = dot(A, B);
            }
            
            void Unity_Distance_float3(float3 A, float3 B, out float Out)
            {
                Out = distance(A, B);
            }
            
            void Unity_Divide_float(float A, float B, out float Out)
            {
                Out = A / B;
            }
            
            void Unity_Absolute_float(float In, out float Out)
            {
                Out = abs(In);
            }
            
            void Unity_Maximum_float(float A, float B, out float Out)
            {
                Out = max(A, B);
            }
            
            void Unity_Cosine_float(float In, out float Out)
            {
                Out = cos(In);
            }
            
            void Unity_Sine_float(float In, out float Out)
            {
                Out = sin(In);
            }
            
            void Unity_Comparison_NotEqual_float(float A, float B, out float Out)
            {
                Out = A != B ? 1 : 0;
            }
            
            struct Bindings_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf
            {
                float3 ObjectSpaceNormal;
                float3 WorldSpaceNormal;
                float3 ObjectSpaceTangent;
                float3 WorldSpaceTangent;
                float3 ObjectSpaceBiTangent;
                float3 WorldSpaceBiTangent;
                float4 VertexColor;
            };
            
            void SG_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf(float Vector1_BCB03E1A, float3 Vector3_C30D997B, float Vector1_A2C4B4F4, float Vector1_7EE0F94A, float Boolean_527CB26E, float Vector1_DE1BF63A, float Vector1_7F78DDD2, float3 Vector3_DE8CC74D, TEXTURE2D_PARAM(Texture2D_5BAC276D, samplerTexture2D_5BAC276D), float4 Texture2D_5BAC276D_TexelSize, TEXTURE2D_PARAM(Texture2D_A3874DB9, samplerTexture2D_A3874DB9), float4 Texture2D_A3874DB9_TexelSize, float4 Vector4_EBFF8CDE, float Vector1_B4470F9B, float Vector1_2EC6D670, float Vector1_9365F438, float Vector1_F53C4B89, float Vector1_6803B355, Bindings_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf IN, out float3 vertex_1, out float3 normal_2)
            {
                float4 _Vector4_96035CAB_Out_0 = float4(0, 0, 0, 1);
                float3 _Transform_56C94D33_Out_1 = TransformObjectToWorld((_Vector4_96035CAB_Out_0.xyz).xyz);
                float3 _Property_ED8BB836_Out_0 = Vector3_C30D997B;
                float3 _Transform_A839B73F_Out_1 = TransformObjectToWorld(_Property_ED8BB836_Out_0.xyz);
                float _Property_46785E9D_Out_0 = Boolean_527CB26E;
                float _Property_309A125A_Out_0 = Vector1_7EE0F94A;
                float _Comparison_FB7B17F4_Out_2;
                Unity_Comparison_Greater_float(_Property_309A125A_Out_0, 0, _Comparison_FB7B17F4_Out_2);
                float _Split_9DCBE03C_R_1 = _Transform_A839B73F_Out_1[0];
                float _Split_9DCBE03C_G_2 = _Transform_A839B73F_Out_1[1];
                float _Split_9DCBE03C_B_3 = _Transform_A839B73F_Out_1[2];
                float _Split_9DCBE03C_A_4 = 0;
                float _Split_2643B819_R_1 = _Transform_56C94D33_Out_1[0];
                float _Split_2643B819_G_2 = _Transform_56C94D33_Out_1[1];
                float _Split_2643B819_B_3 = _Transform_56C94D33_Out_1[2];
                float _Split_2643B819_A_4 = 0;
                float _Subtract_72710DB_Out_2;
                Unity_Subtract_float(_Split_9DCBE03C_G_2, _Split_2643B819_G_2, _Subtract_72710DB_Out_2);
                float _Comparison_A59CB55E_Out_2;
                Unity_Comparison_Less_float(_Subtract_72710DB_Out_2, _Property_309A125A_Out_0, _Comparison_A59CB55E_Out_2);
                float _And_75A07D3D_Out_2;
                Unity_And_float(_Comparison_FB7B17F4_Out_2, _Comparison_A59CB55E_Out_2, _And_75A07D3D_Out_2);
                float _Property_C5B18F25_Out_0 = Vector1_A2C4B4F4;
                float _Branch_71DEDA04_Out_3;
                Unity_Branch_float(_And_75A07D3D_Out_2, 1E-05, _Property_C5B18F25_Out_0, _Branch_71DEDA04_Out_3);
                float _Split_CAA3FAC4_R_1 = IN.VertexColor[0];
                float _Split_CAA3FAC4_G_2 = IN.VertexColor[1];
                float _Split_CAA3FAC4_B_3 = IN.VertexColor[2];
                float _Split_CAA3FAC4_A_4 = IN.VertexColor[3];
                float _Multiply_6282C968_Out_2;
                Unity_Multiply_float(_Branch_71DEDA04_Out_3, _Split_CAA3FAC4_A_4, _Multiply_6282C968_Out_2);
                float _Branch_FD6CEDEF_Out_3;
                Unity_Branch_float(_Property_46785E9D_Out_0, _Multiply_6282C968_Out_2, _Branch_71DEDA04_Out_3, _Branch_FD6CEDEF_Out_3);
                float _Property_8C9BC3F_Out_0 = Vector1_7F78DDD2;
                float4 _Property_DB8C20D5_Out_0 = Vector4_EBFF8CDE;
                float _Property_C83CCC0B_Out_0 = Vector1_B4470F9B;
                float _Property_9121207F_Out_0 = Vector1_2EC6D670;
                float _Property_9105DCD7_Out_0 = Vector1_9365F438;
                float _Property_6EE84426_Out_0 = Vector1_F53C4B89;
                float _Property_51392D3_Out_0 = Vector1_6803B355;
                float _Property_3C488CF_Out_0 = Vector1_BCB03E1A;
                Bindings_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10 _WindNMCalculateNoShiver_A0D948FA;
                float3 _WindNMCalculateNoShiver_A0D948FA_direction_1;
                float _WindNMCalculateNoShiver_A0D948FA_strength_2;
                SG_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10(_Transform_A839B73F_Out_1, _Transform_56C94D33_Out_1, _Branch_FD6CEDEF_Out_3, _Property_8C9BC3F_Out_0, TEXTURE2D_ARGS(Texture2D_5BAC276D, samplerTexture2D_5BAC276D), Texture2D_5BAC276D_TexelSize, TEXTURE2D_ARGS(Texture2D_A3874DB9, samplerTexture2D_A3874DB9), Texture2D_A3874DB9_TexelSize, _Property_DB8C20D5_Out_0, _Property_C83CCC0B_Out_0, _Property_9121207F_Out_0, _Property_9105DCD7_Out_0, _Property_6EE84426_Out_0, _Property_51392D3_Out_0, _Property_3C488CF_Out_0, _WindNMCalculateNoShiver_A0D948FA, _WindNMCalculateNoShiver_A0D948FA_direction_1, _WindNMCalculateNoShiver_A0D948FA_strength_2);
                float3 _CrossProduct_417F56_Out_2;
                Unity_CrossProduct_float(float3 (0, 1, 0), _WindNMCalculateNoShiver_A0D948FA_direction_1, _CrossProduct_417F56_Out_2);
                float3 _Normalize_4E99CADE_Out_1;
                Unity_Normalize_float3(_CrossProduct_417F56_Out_2, _Normalize_4E99CADE_Out_1);
                float3 _Subtract_8E413BBF_Out_2;
                Unity_Subtract_float3(_Transform_A839B73F_Out_1, _Transform_56C94D33_Out_1, _Subtract_8E413BBF_Out_2);
                float _DotProduct_111C5979_Out_2;
                Unity_DotProduct_float3(_Normalize_4E99CADE_Out_1, _Subtract_8E413BBF_Out_2, _DotProduct_111C5979_Out_2);
                float3 _Multiply_6B4F7E94_Out_2;
                Unity_Multiply_float(_Normalize_4E99CADE_Out_1, (_DotProduct_111C5979_Out_2.xxx), _Multiply_6B4F7E94_Out_2);
                float3 _Add_20CCB137_Out_2;
                Unity_Add_float3(_Transform_56C94D33_Out_1, _Multiply_6B4F7E94_Out_2, _Add_20CCB137_Out_2);
                float3 _Subtract_32DFFF4F_Out_2;
                Unity_Subtract_float3(_Transform_A839B73F_Out_1, _Add_20CCB137_Out_2, _Subtract_32DFFF4F_Out_2);
                float _Distance_77B26FEA_Out_2;
                Unity_Distance_float3(_Transform_A839B73F_Out_1, _Transform_56C94D33_Out_1, _Distance_77B26FEA_Out_2);
                float _Property_FB0C946E_Out_0 = Vector1_DE1BF63A;
                float _Divide_C2F89B8E_Out_2;
                Unity_Divide_float(_Distance_77B26FEA_Out_2, _Property_FB0C946E_Out_0, _Divide_C2F89B8E_Out_2);
                float _Absolute_F60A1055_Out_1;
                Unity_Absolute_float(_Divide_C2F89B8E_Out_2, _Absolute_F60A1055_Out_1);
                float _Vector1_776AF5AC_Out_0 = 1E-07;
                float _Maximum_4166AFF2_Out_2;
                Unity_Maximum_float(_Absolute_F60A1055_Out_1, _Vector1_776AF5AC_Out_0, _Maximum_4166AFF2_Out_2);
                float _Divide_C7B0EA9F_Out_2;
                Unity_Divide_float(1, _Property_FB0C946E_Out_0, _Divide_C7B0EA9F_Out_2);
                float _Power_A9B007BF_Out_2;
                Unity_Power_float(_Maximum_4166AFF2_Out_2, _Divide_C7B0EA9F_Out_2, _Power_A9B007BF_Out_2);
                float _Multiply_58839CDF_Out_2;
                Unity_Multiply_float(_WindNMCalculateNoShiver_A0D948FA_strength_2, _Power_A9B007BF_Out_2, _Multiply_58839CDF_Out_2);
                float _Cosine_C162178D_Out_1;
                Unity_Cosine_float(_Multiply_58839CDF_Out_2, _Cosine_C162178D_Out_1);
                float3 _Multiply_B16DE76A_Out_2;
                Unity_Multiply_float(_Subtract_32DFFF4F_Out_2, (_Cosine_C162178D_Out_1.xxx), _Multiply_B16DE76A_Out_2);
                float3 _CrossProduct_10AAB5C9_Out_2;
                Unity_CrossProduct_float(_Normalize_4E99CADE_Out_1, _Subtract_32DFFF4F_Out_2, _CrossProduct_10AAB5C9_Out_2);
                float _Sine_CD6051C7_Out_1;
                Unity_Sine_float(_Multiply_58839CDF_Out_2, _Sine_CD6051C7_Out_1);
                float3 _Multiply_E565B59B_Out_2;
                Unity_Multiply_float(_CrossProduct_10AAB5C9_Out_2, (_Sine_CD6051C7_Out_1.xxx), _Multiply_E565B59B_Out_2);
                float3 _Add_70586F80_Out_2;
                Unity_Add_float3(_Multiply_B16DE76A_Out_2, _Multiply_E565B59B_Out_2, _Add_70586F80_Out_2);
                float3 _Add_773B285F_Out_2;
                Unity_Add_float3(_Add_20CCB137_Out_2, _Add_70586F80_Out_2, _Add_773B285F_Out_2);
                float3 _Transform_3BC8B282_Out_1 = TransformWorldToObject(_Add_773B285F_Out_2.xyz);
                float3 _Property_37555482_Out_0 = Vector3_DE8CC74D;
                float _Length_2799ABFE_Out_1;
                Unity_Length_float3(_Property_37555482_Out_0, _Length_2799ABFE_Out_1);
                float _Comparison_4940F3B6_Out_2;
                Unity_Comparison_NotEqual_float(_Length_2799ABFE_Out_1, 0, _Comparison_4940F3B6_Out_2);
                float3 _Multiply_5354DD91_Out_2;
                Unity_Multiply_float(IN.WorldSpaceNormal, _Property_37555482_Out_0, _Multiply_5354DD91_Out_2);
                float3 _Branch_993A8BB_Out_3;
                Unity_Branch_float3(_Comparison_4940F3B6_Out_2, _Multiply_5354DD91_Out_2, IN.WorldSpaceNormal, _Branch_993A8BB_Out_3);
                vertex_1 = _Transform_3BC8B282_Out_1;
                normal_2 = _Branch_993A8BB_Out_3;
            }
            
            void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
            {
                Out = UV * Tiling + Offset;
            }
            
            void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
            {
                Out = A * B;
            }
            
            void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
            {
                Out = Predicate ? True : False;
            }
            
            void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
            {
                Out = lerp(A, B, T);
            }
        
            // Graph Vertex
            struct VertexDescriptionInputs
            {
                float3 ObjectSpaceNormal;
                float3 WorldSpaceNormal;
                float3 ObjectSpaceTangent;
                float3 WorldSpaceTangent;
                float3 ObjectSpaceBiTangent;
                float3 WorldSpaceBiTangent;
                float3 ObjectSpacePosition;
                float4 VertexColor;
                float3 TimeParameters;
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
                Bindings_NMFoliageVSProIndirect_5daaeae117458b94ca071c13e7a67c32 _NMFoliageVSProIndirect_6AFECCFE;
                float3 _NMFoliageVSProIndirect_6AFECCFE_ObjectSpacePosition_1;
                SG_NMFoliageVSProIndirect_5daaeae117458b94ca071c13e7a67c32(IN.ObjectSpacePosition, _NMFoliageVSProIndirect_6AFECCFE, _NMFoliageVSProIndirect_6AFECCFE_ObjectSpacePosition_1);
                float _Property_3E4B4411_Out_0 = _Drag;
                float _Property_7F252CE7_Out_0 = _HeightDrag;
                float _Property_7865D519_Out_0 = _Stiffness;
                float _Property_D5195AAC_Out_0 = _InitialBend;
                float4 _Property_FFB305BA_Out_0 = _NewNormal;
                float4 _Property_46C9B1EE_Out_0 = WIND_SETTINGS_WorldDirectionAndSpeed;
                float _Property_F9C82607_Out_0 = WIND_SETTINGS_FlexNoiseScale;
                float _Property_1DC2420_Out_0 = WIND_SETTINGS_Turbulence;
                float _Property_753163F4_Out_0 = WIND_SETTINGS_GustSpeed;
                float _Property_249371F4_Out_0 = WIND_SETTINGS_GustScale;
                float _Property_6A8E929E_Out_0 = WIND_SETTINGS_GustWorldScale;
                Bindings_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf _WindNMNoShiver_A2E31333;
                _WindNMNoShiver_A2E31333.ObjectSpaceNormal = IN.ObjectSpaceNormal;
                _WindNMNoShiver_A2E31333.WorldSpaceNormal = IN.WorldSpaceNormal;
                _WindNMNoShiver_A2E31333.ObjectSpaceTangent = IN.ObjectSpaceTangent;
                _WindNMNoShiver_A2E31333.WorldSpaceTangent = IN.WorldSpaceTangent;
                _WindNMNoShiver_A2E31333.ObjectSpaceBiTangent = IN.ObjectSpaceBiTangent;
                _WindNMNoShiver_A2E31333.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
                _WindNMNoShiver_A2E31333.VertexColor = IN.VertexColor;
                float3 _WindNMNoShiver_A2E31333_vertex_1;
                float3 _WindNMNoShiver_A2E31333_normal_2;
                SG_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf(IN.TimeParameters.x, _NMFoliageVSProIndirect_6AFECCFE_ObjectSpacePosition_1, _Property_3E4B4411_Out_0, _Property_7F252CE7_Out_0, 0, _Property_7865D519_Out_0, _Property_D5195AAC_Out_0, (_Property_FFB305BA_Out_0.xyz), TEXTURE2D_ARGS(WIND_SETTINGS_TexNoise, samplerWIND_SETTINGS_TexNoise), WIND_SETTINGS_TexNoise_TexelSize, TEXTURE2D_ARGS(WIND_SETTINGS_TexGust, samplerWIND_SETTINGS_TexGust), WIND_SETTINGS_TexGust_TexelSize, _Property_46C9B1EE_Out_0, _Property_F9C82607_Out_0, _Property_1DC2420_Out_0, _Property_753163F4_Out_0, _Property_249371F4_Out_0, _Property_6A8E929E_Out_0, _WindNMNoShiver_A2E31333, _WindNMNoShiver_A2E31333_vertex_1, _WindNMNoShiver_A2E31333_normal_2);
                description.VertexPosition = _WindNMNoShiver_A2E31333_vertex_1;
                description.VertexNormal = IN.ObjectSpaceNormal;
                description.VertexTangent = IN.ObjectSpaceTangent;
                return description;
            }
            
            // Graph Pixel
            struct SurfaceDescriptionInputs
            {
                float4 uv0;
                float4 uv3;
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
                float4 _Property_EC7746F0_Out_0 = _TrunkTilingOffset;
                float _Split_B742091E_R_1 = _Property_EC7746F0_Out_0[0];
                float _Split_B742091E_G_2 = _Property_EC7746F0_Out_0[1];
                float _Split_B742091E_B_3 = _Property_EC7746F0_Out_0[2];
                float _Split_B742091E_A_4 = _Property_EC7746F0_Out_0[3];
                float2 _Vector2_C5944BDD_Out_0 = float2(_Split_B742091E_R_1, _Split_B742091E_G_2);
                float2 _Vector2_A68E28C5_Out_0 = float2(_Split_B742091E_B_3, _Split_B742091E_A_4);
                float2 _TilingAndOffset_97CBEADA_Out_3;
                Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_C5944BDD_Out_0, _Vector2_A68E28C5_Out_0, _TilingAndOffset_97CBEADA_Out_3);
                float4 _SampleTexture2D_B919BA28_RGBA_0 = SAMPLE_TEXTURE2D(_TrunkBaseColorMap, sampler_TrunkBaseColorMap, _TilingAndOffset_97CBEADA_Out_3);
                float _SampleTexture2D_B919BA28_R_4 = _SampleTexture2D_B919BA28_RGBA_0.r;
                float _SampleTexture2D_B919BA28_G_5 = _SampleTexture2D_B919BA28_RGBA_0.g;
                float _SampleTexture2D_B919BA28_B_6 = _SampleTexture2D_B919BA28_RGBA_0.b;
                float _SampleTexture2D_B919BA28_A_7 = _SampleTexture2D_B919BA28_RGBA_0.a;
                float4 _Property_7FC0454F_Out_0 = _TrunkBaseColor;
                float4 _Multiply_6F337D09_Out_2;
                Unity_Multiply_float(_SampleTexture2D_B919BA28_RGBA_0, _Property_7FC0454F_Out_0, _Multiply_6F337D09_Out_2);
                float _Property_91B33228_Out_0 = _BarkUseUV3;
                float4 _UV_D3D66B0E_Out_0 = IN.uv3;
                float4 _UV_62FB944B_Out_0 = IN.uv0;
                float4 _Branch_7E7DD05F_Out_3;
                Unity_Branch_float4(_Property_91B33228_Out_0, _UV_D3D66B0E_Out_0, _UV_62FB944B_Out_0, _Branch_7E7DD05F_Out_3);
                float4 _Property_67884C_Out_0 = _BarkTilingOffset;
                float _Split_6B4B02A_R_1 = _Property_67884C_Out_0[0];
                float _Split_6B4B02A_G_2 = _Property_67884C_Out_0[1];
                float _Split_6B4B02A_B_3 = _Property_67884C_Out_0[2];
                float _Split_6B4B02A_A_4 = _Property_67884C_Out_0[3];
                float2 _Vector2_A7F21F38_Out_0 = float2(_Split_6B4B02A_R_1, _Split_6B4B02A_G_2);
                float2 _Vector2_1DA22E74_Out_0 = float2(_Split_6B4B02A_B_3, _Split_6B4B02A_A_4);
                float2 _TilingAndOffset_3B5515F1_Out_3;
                Unity_TilingAndOffset_float((_Branch_7E7DD05F_Out_3.xy), _Vector2_A7F21F38_Out_0, _Vector2_1DA22E74_Out_0, _TilingAndOffset_3B5515F1_Out_3);
                float4 _SampleTexture2D_7E4BB55F_RGBA_0 = SAMPLE_TEXTURE2D(_BarkBaseColorMap, sampler_BarkBaseColorMap, _TilingAndOffset_3B5515F1_Out_3);
                float _SampleTexture2D_7E4BB55F_R_4 = _SampleTexture2D_7E4BB55F_RGBA_0.r;
                float _SampleTexture2D_7E4BB55F_G_5 = _SampleTexture2D_7E4BB55F_RGBA_0.g;
                float _SampleTexture2D_7E4BB55F_B_6 = _SampleTexture2D_7E4BB55F_RGBA_0.b;
                float _SampleTexture2D_7E4BB55F_A_7 = _SampleTexture2D_7E4BB55F_RGBA_0.a;
                float4 _Property_400F851C_Out_0 = _BarkBaseColor;
                float4 _Multiply_22EAC4BF_Out_2;
                Unity_Multiply_float(_SampleTexture2D_7E4BB55F_RGBA_0, _Property_400F851C_Out_0, _Multiply_22EAC4BF_Out_2);
                float4 _Property_6F963EC1_Out_0 = _BarkBlendMaskTilingOffset;
                float _Split_7EFCE35C_R_1 = _Property_6F963EC1_Out_0[0];
                float _Split_7EFCE35C_G_2 = _Property_6F963EC1_Out_0[1];
                float _Split_7EFCE35C_B_3 = _Property_6F963EC1_Out_0[2];
                float _Split_7EFCE35C_A_4 = _Property_6F963EC1_Out_0[3];
                float2 _Vector2_3757C307_Out_0 = float2(_Split_7EFCE35C_R_1, _Split_7EFCE35C_G_2);
                float2 _Vector2_1FA6DD61_Out_0 = float2(_Split_7EFCE35C_B_3, _Split_7EFCE35C_A_4);
                float2 _TilingAndOffset_E00C37C5_Out_3;
                Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_3757C307_Out_0, _Vector2_1FA6DD61_Out_0, _TilingAndOffset_E00C37C5_Out_3);
                float4 _SampleTexture2D_BCB513F9_RGBA_0 = SAMPLE_TEXTURE2D(_LayerMask, sampler_LayerMask, _TilingAndOffset_E00C37C5_Out_3);
                float _SampleTexture2D_BCB513F9_R_4 = _SampleTexture2D_BCB513F9_RGBA_0.r;
                float _SampleTexture2D_BCB513F9_G_5 = _SampleTexture2D_BCB513F9_RGBA_0.g;
                float _SampleTexture2D_BCB513F9_B_6 = _SampleTexture2D_BCB513F9_RGBA_0.b;
                float _SampleTexture2D_BCB513F9_A_7 = _SampleTexture2D_BCB513F9_RGBA_0.a;
                float4 _Lerp_FB04343D_Out_3;
                Unity_Lerp_float4(_Multiply_6F337D09_Out_2, _Multiply_22EAC4BF_Out_2, (_SampleTexture2D_BCB513F9_A_7.xxxx), _Lerp_FB04343D_Out_3);
                surface.Albedo = (_Lerp_FB04343D_Out_3.xyz);
                surface.Emission = IsGammaSpace() ? float3(0, 0, 0) : SRGBToLinear(float3(0, 0, 0));
                surface.Alpha = 1;
                surface.AlphaClipThreshold = 0.5;
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
                float4 uv3 : TEXCOORD3;
                float4 color : COLOR;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif
            };
        
            // Generated Type: Varyings
            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float4 texCoord0;
                float4 texCoord3;
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
                float4 interp00 : TEXCOORD0;
                float4 interp01 : TEXCOORD1;
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
                output.interp00.xyzw = input.texCoord0;
                output.interp01.xyzw = input.texCoord3;
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
                output.texCoord0 = input.interp00.xyzw;
                output.texCoord3 = input.interp01.xyzw;
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
                output.WorldSpaceNormal =            TransformObjectToWorldNormal(input.normalOS);
                output.ObjectSpaceTangent =          input.tangentOS;
                output.WorldSpaceTangent =           TransformObjectToWorldDir(input.tangentOS.xyz);
                output.ObjectSpaceBiTangent =        normalize(cross(input.normalOS, input.tangentOS) * (input.tangentOS.w > 0.0f ? 1.0f : -1.0f) * GetOddNegativeScale());
                output.WorldSpaceBiTangent =         TransformObjectToWorldDir(output.ObjectSpaceBiTangent);
                output.ObjectSpacePosition =         input.positionOS;
                output.VertexColor =                 input.color;
                output.TimeParameters =              _TimeParameters.xyz;
            
                return output;
            }
            
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
            
            
            
            
                output.uv0 =                         input.texCoord0;
                output.uv3 =                         input.texCoord3;
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
            #define ATTRIBUTES_NEED_TEXCOORD3
            #define ATTRIBUTES_NEED_COLOR
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_TEXCOORD3
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
            float4 _TrunkBaseColor;
            float4 _TrunkTilingOffset;
            float _TrunkNormalScale;
            float _TrunkMetallic;
            float _TrunkAORemapMin;
            float _TrunkAORemapMax;
            float _TrunkSmoothnessRemapMin;
            float _TrunkSmoothnessRemapMax;
            float4 _BarkBlendMaskTilingOffset;
            float4 _BarkBaseColor;
            float _BarkUseUV3;
            float4 _BarkTilingOffset;
            float _BarkNormalScale;
            float _BarkMetallic;
            float _BarkSmoothnessRemapMin;
            float _BarkSmoothnessRemapMax;
            float _BarkAORemapMin;
            float _BarkAORemapMax;
            float _Stiffness;
            float _InitialBend;
            float _Drag;
            float _HeightDrag;
            float4 _NewNormal;
            CBUFFER_END
            TEXTURE2D(_TrunkBaseColorMap); SAMPLER(sampler_TrunkBaseColorMap); float4 _TrunkBaseColorMap_TexelSize;
            TEXTURE2D(_TrunkNormalMap); SAMPLER(sampler_TrunkNormalMap); float4 _TrunkNormalMap_TexelSize;
            TEXTURE2D(_TrunkMaskMap); SAMPLER(sampler_TrunkMaskMap); float4 _TrunkMaskMap_TexelSize;
            TEXTURE2D(_LayerMask); SAMPLER(sampler_LayerMask); float4 _LayerMask_TexelSize;
            TEXTURE2D(_BarkBaseColorMap); SAMPLER(sampler_BarkBaseColorMap); float4 _BarkBaseColorMap_TexelSize;
            TEXTURE2D(_BarkNormalMap); SAMPLER(sampler_BarkNormalMap); float4 _BarkNormalMap_TexelSize;
            TEXTURE2D(_BarkMaskMap); SAMPLER(sampler_BarkMaskMap); float4 _BarkMaskMap_TexelSize;
            float WIND_SETTINGS_GustWorldScale;
            float WIND_SETTINGS_GustScale;
            float WIND_SETTINGS_GustSpeed;
            float WIND_SETTINGS_Turbulence;
            float WIND_SETTINGS_ShiverNoiseScale;
            float WIND_SETTINGS_FlexNoiseScale;
            float4 WIND_SETTINGS_WorldDirectionAndSpeed;
            TEXTURE2D(WIND_SETTINGS_TexGust); SAMPLER(samplerWIND_SETTINGS_TexGust); float4 WIND_SETTINGS_TexGust_TexelSize;
            TEXTURE2D(WIND_SETTINGS_TexNoise); SAMPLER(samplerWIND_SETTINGS_TexNoise); float4 WIND_SETTINGS_TexNoise_TexelSize;
            SAMPLER(_SampleTexture2DLOD_15CFA945_Sampler_3_Linear_Repeat);
            SAMPLER(_SampleTexture2DLOD_E609D4E_Sampler_3_Linear_Repeat);
            SAMPLER(_SampleTexture2D_B919BA28_Sampler_3_Linear_Repeat);
            SAMPLER(_SampleTexture2D_7E4BB55F_Sampler_3_Linear_Repeat);
            SAMPLER(_SampleTexture2D_BCB513F9_Sampler_3_Linear_Repeat);
        
            // Graph Functions
            
            // c21cb3b956f4ef1fbcd1fae12d599429
            #include "Assets/NatureManufacture Assets/Foliage Shaders/NM_Foliage_VSPro_Indirect.cginc"
            
            void AddPragma_float(float3 A, out float3 Out)
            {
                #pragma instancing_options renderinglayer procedural:setupVSPro
                Out = A;
            }
            
            struct Bindings_NMFoliageVSProIndirect_5daaeae117458b94ca071c13e7a67c32
            {
            };
            
            void SG_NMFoliageVSProIndirect_5daaeae117458b94ca071c13e7a67c32(float3 Vector3_314C8600, Bindings_NMFoliageVSProIndirect_5daaeae117458b94ca071c13e7a67c32 IN, out float3 ObjectSpacePosition_1)
            {
                float3 _Property_AF5E8C93_Out_0 = Vector3_314C8600;
                float3 _CustomFunction_E07FEE57_Out_1;
                InjectSetup_float(_Property_AF5E8C93_Out_0, _CustomFunction_E07FEE57_Out_1);
                float3 _CustomFunction_18EFD858_Out_1;
                AddPragma_float(_CustomFunction_E07FEE57_Out_1, _CustomFunction_18EFD858_Out_1);
                ObjectSpacePosition_1 = _CustomFunction_18EFD858_Out_1;
            }
            
            void Unity_Comparison_Greater_float(float A, float B, out float Out)
            {
                Out = A > B ? 1 : 0;
            }
            
            void Unity_Subtract_float(float A, float B, out float Out)
            {
                Out = A - B;
            }
            
            void Unity_Comparison_Less_float(float A, float B, out float Out)
            {
                Out = A < B ? 1 : 0;
            }
            
            void Unity_And_float(float A, float B, out float Out)
            {
                Out = A && B;
            }
            
            void Unity_Branch_float(float Predicate, float True, float False, out float Out)
            {
                Out = Predicate ? True : False;
            }
            
            void Unity_Multiply_float(float A, float B, out float Out)
            {
                Out = A * B;
            }
            
            void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
            {
                RGBA = float4(R, G, B, A);
                RGB = float3(R, G, B);
                RG = float2(R, G);
            }
            
            void Unity_Normalize_float3(float3 In, out float3 Out)
            {
                Out = normalize(In);
            }
            
            void Unity_Multiply_float(float3 A, float3 B, out float3 Out)
            {
                Out = A * B;
            }
            
            void Unity_Subtract_float3(float3 A, float3 B, out float3 Out)
            {
                Out = A - B;
            }
            
            void Unity_Power_float(float A, float B, out float Out)
            {
                Out = pow(A, B);
            }
            
            void Unity_Add_float3(float3 A, float3 B, out float3 Out)
            {
                Out = A + B;
            }
            
            void Unity_Or_float(float A, float B, out float Out)
            {
                Out = A || B;
            }
            
            void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
            {
                Out = Predicate ? True : False;
            }
            
            void Unity_Length_float3(float3 In, out float Out)
            {
                Out = length(In);
            }
            
            void Unity_Add_float(float A, float B, out float Out)
            {
                Out = A + B;
            }
            
            struct Bindings_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10
            {
            };
            
            void SG_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10(float3 Vector3_604F121F, float3 Vector3_C30D997B, float Vector1_A2C4B4F4, float Vector1_7F78DDD2, TEXTURE2D_PARAM(Texture2D_5BAC276D, samplerTexture2D_5BAC276D), float4 Texture2D_5BAC276D_TexelSize, TEXTURE2D_PARAM(Texture2D_A3874DB9, samplerTexture2D_A3874DB9), float4 Texture2D_A3874DB9_TexelSize, float4 Vector4_EBFF8CDE, float Vector1_B4470F9B, float Vector1_2EC6D670, float Vector1_9365F438, float Vector1_F53C4B89, float Vector1_6803B355, float Vector1_5EFF6B1A, Bindings_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10 IN, out float3 direction_1, out float strength_2)
            {
                float4 _Property_70C0FA2E_Out_0 = Vector4_EBFF8CDE;
                float _Split_9EAD5A97_R_1 = _Property_70C0FA2E_Out_0[0];
                float _Split_9EAD5A97_G_2 = _Property_70C0FA2E_Out_0[1];
                float _Split_9EAD5A97_B_3 = _Property_70C0FA2E_Out_0[2];
                float _Split_9EAD5A97_A_4 = _Property_70C0FA2E_Out_0[3];
                float4 _Combine_B187C165_RGBA_4;
                float3 _Combine_B187C165_RGB_5;
                float2 _Combine_B187C165_RG_6;
                Unity_Combine_float(_Split_9EAD5A97_R_1, _Split_9EAD5A97_G_2, _Split_9EAD5A97_B_3, 0, _Combine_B187C165_RGBA_4, _Combine_B187C165_RGB_5, _Combine_B187C165_RG_6);
                float3 _Normalize_2F17E0EB_Out_1;
                Unity_Normalize_float3(_Combine_B187C165_RGB_5, _Normalize_2F17E0EB_Out_1);
                float4 _Property_5C87BB92_Out_0 = Vector4_EBFF8CDE;
                float _Split_D49FDEED_R_1 = _Property_5C87BB92_Out_0[0];
                float _Split_D49FDEED_G_2 = _Property_5C87BB92_Out_0[1];
                float _Split_D49FDEED_B_3 = _Property_5C87BB92_Out_0[2];
                float _Split_D49FDEED_A_4 = _Property_5C87BB92_Out_0[3];
                float3 _Multiply_B4A67D17_Out_2;
                Unity_Multiply_float(_Normalize_2F17E0EB_Out_1, (_Split_D49FDEED_A_4.xxx), _Multiply_B4A67D17_Out_2);
                float _Property_B93DC53_Out_0 = Vector1_9365F438;
                float _Comparison_43ADEEA_Out_2;
                Unity_Comparison_Greater_float(_Property_B93DC53_Out_0, 0, _Comparison_43ADEEA_Out_2);
                float3 _Property_F1C16A88_Out_0 = Vector3_C30D997B;
                float _Property_30FD117B_Out_0 = Vector1_9365F438;
                float3 _Multiply_201CFE4B_Out_2;
                Unity_Multiply_float(_Normalize_2F17E0EB_Out_1, (_Property_30FD117B_Out_0.xxx), _Multiply_201CFE4B_Out_2);
                float _Property_C2BB60B0_Out_0 = Vector1_5EFF6B1A;
                float3 _Multiply_3B9F632A_Out_2;
                Unity_Multiply_float(_Multiply_201CFE4B_Out_2, (_Property_C2BB60B0_Out_0.xxx), _Multiply_3B9F632A_Out_2);
                float3 _Subtract_A4C7E129_Out_2;
                Unity_Subtract_float3(_Property_F1C16A88_Out_0, _Multiply_3B9F632A_Out_2, _Subtract_A4C7E129_Out_2);
                float _Property_7A8C7E0C_Out_0 = Vector1_6803B355;
                float3 _Multiply_B5B8A5BC_Out_2;
                Unity_Multiply_float(_Subtract_A4C7E129_Out_2, (_Property_7A8C7E0C_Out_0.xxx), _Multiply_B5B8A5BC_Out_2);
                float _Split_FBE059F7_R_1 = _Multiply_B5B8A5BC_Out_2[0];
                float _Split_FBE059F7_G_2 = _Multiply_B5B8A5BC_Out_2[1];
                float _Split_FBE059F7_B_3 = _Multiply_B5B8A5BC_Out_2[2];
                float _Split_FBE059F7_A_4 = 0;
                float4 _Combine_72AAC837_RGBA_4;
                float3 _Combine_72AAC837_RGB_5;
                float2 _Combine_72AAC837_RG_6;
                Unity_Combine_float(_Split_FBE059F7_R_1, _Split_FBE059F7_B_3, 0, 0, _Combine_72AAC837_RGBA_4, _Combine_72AAC837_RGB_5, _Combine_72AAC837_RG_6);
                float4 _SampleTexture2DLOD_15CFA945_RGBA_0 = SAMPLE_TEXTURE2D_LOD(Texture2D_A3874DB9, samplerTexture2D_A3874DB9, _Combine_72AAC837_RG_6, 3);
                float _SampleTexture2DLOD_15CFA945_R_5 = _SampleTexture2DLOD_15CFA945_RGBA_0.r;
                float _SampleTexture2DLOD_15CFA945_G_6 = _SampleTexture2DLOD_15CFA945_RGBA_0.g;
                float _SampleTexture2DLOD_15CFA945_B_7 = _SampleTexture2DLOD_15CFA945_RGBA_0.b;
                float _SampleTexture2DLOD_15CFA945_A_8 = _SampleTexture2DLOD_15CFA945_RGBA_0.a;
                float _Branch_C4699449_Out_3;
                Unity_Branch_float(_Comparison_43ADEEA_Out_2, _SampleTexture2DLOD_15CFA945_R_5, 0, _Branch_C4699449_Out_3);
                float _Power_F95D44FE_Out_2;
                Unity_Power_float(_Branch_C4699449_Out_3, 2, _Power_F95D44FE_Out_2);
                float _Property_25A9D1E6_Out_0 = Vector1_F53C4B89;
                float _Multiply_48018D0E_Out_2;
                Unity_Multiply_float(_Power_F95D44FE_Out_2, _Property_25A9D1E6_Out_0, _Multiply_48018D0E_Out_2);
                float3 _Multiply_F98AFF5A_Out_2;
                Unity_Multiply_float((_Multiply_48018D0E_Out_2.xxx), _Normalize_2F17E0EB_Out_1, _Multiply_F98AFF5A_Out_2);
                float _Property_B3EBD96_Out_0 = Vector1_9365F438;
                float3 _Multiply_10232D61_Out_2;
                Unity_Multiply_float(_Multiply_F98AFF5A_Out_2, (_Property_B3EBD96_Out_0.xxx), _Multiply_10232D61_Out_2);
                float3 _Add_E4BDFE70_Out_2;
                Unity_Add_float3(_Multiply_B4A67D17_Out_2, _Multiply_10232D61_Out_2, _Add_E4BDFE70_Out_2);
                float4 _Property_DAA1D9B7_Out_0 = Vector4_EBFF8CDE;
                float _Split_A66E259B_R_1 = _Property_DAA1D9B7_Out_0[0];
                float _Split_A66E259B_G_2 = _Property_DAA1D9B7_Out_0[1];
                float _Split_A66E259B_B_3 = _Property_DAA1D9B7_Out_0[2];
                float _Split_A66E259B_A_4 = _Property_DAA1D9B7_Out_0[3];
                float _Comparison_C98EAD3C_Out_2;
                Unity_Comparison_Greater_float(_Split_A66E259B_A_4, 0, _Comparison_C98EAD3C_Out_2);
                float _Property_2EDECFEA_Out_0 = Vector1_2EC6D670;
                float _Comparison_2D5C726B_Out_2;
                Unity_Comparison_Greater_float(_Property_2EDECFEA_Out_0, 0, _Comparison_2D5C726B_Out_2);
                float _Or_104823B_Out_2;
                Unity_Or_float(_Comparison_C98EAD3C_Out_2, _Comparison_2D5C726B_Out_2, _Or_104823B_Out_2);
                float3 _Property_A717C7D9_Out_0 = Vector3_C30D997B;
                float3 _Multiply_86E49BF9_Out_2;
                Unity_Multiply_float(_Normalize_2F17E0EB_Out_1, (_Split_A66E259B_A_4.xxx), _Multiply_86E49BF9_Out_2);
                float3 _Multiply_E0B4CB76_Out_2;
                Unity_Multiply_float(_Multiply_86E49BF9_Out_2, (_Property_C2BB60B0_Out_0.xxx), _Multiply_E0B4CB76_Out_2);
                float3 _Subtract_E607F60E_Out_2;
                Unity_Subtract_float3(_Property_A717C7D9_Out_0, _Multiply_E0B4CB76_Out_2, _Subtract_E607F60E_Out_2);
                float _Property_6E24DFF0_Out_0 = Vector1_B4470F9B;
                float3 _Multiply_F1D4C2B0_Out_2;
                Unity_Multiply_float(_Subtract_E607F60E_Out_2, (_Property_6E24DFF0_Out_0.xxx), _Multiply_F1D4C2B0_Out_2);
                float _Split_C22BECE5_R_1 = _Multiply_F1D4C2B0_Out_2[0];
                float _Split_C22BECE5_G_2 = _Multiply_F1D4C2B0_Out_2[1];
                float _Split_C22BECE5_B_3 = _Multiply_F1D4C2B0_Out_2[2];
                float _Split_C22BECE5_A_4 = 0;
                float4 _Combine_AC8E2469_RGBA_4;
                float3 _Combine_AC8E2469_RGB_5;
                float2 _Combine_AC8E2469_RG_6;
                Unity_Combine_float(_Split_C22BECE5_R_1, _Split_C22BECE5_B_3, 0, 0, _Combine_AC8E2469_RGBA_4, _Combine_AC8E2469_RGB_5, _Combine_AC8E2469_RG_6);
                float4 _SampleTexture2DLOD_E609D4E_RGBA_0 = SAMPLE_TEXTURE2D_LOD(Texture2D_5BAC276D, samplerTexture2D_5BAC276D, _Combine_AC8E2469_RG_6, 3);
                float _SampleTexture2DLOD_E609D4E_R_5 = _SampleTexture2DLOD_E609D4E_RGBA_0.r;
                float _SampleTexture2DLOD_E609D4E_G_6 = _SampleTexture2DLOD_E609D4E_RGBA_0.g;
                float _SampleTexture2DLOD_E609D4E_B_7 = _SampleTexture2DLOD_E609D4E_RGBA_0.b;
                float _SampleTexture2DLOD_E609D4E_A_8 = _SampleTexture2DLOD_E609D4E_RGBA_0.a;
                float4 _Combine_7A76145C_RGBA_4;
                float3 _Combine_7A76145C_RGB_5;
                float2 _Combine_7A76145C_RG_6;
                Unity_Combine_float(_SampleTexture2DLOD_E609D4E_R_5, _SampleTexture2DLOD_E609D4E_G_6, _SampleTexture2DLOD_E609D4E_B_7, 0, _Combine_7A76145C_RGBA_4, _Combine_7A76145C_RGB_5, _Combine_7A76145C_RG_6);
                float3 _Add_761D3920_Out_2;
                Unity_Add_float3(_Combine_7A76145C_RGB_5, float3(-0.5, -0.5, -0.5), _Add_761D3920_Out_2);
                float3 _Branch_8C107061_Out_3;
                Unity_Branch_float3(_Or_104823B_Out_2, _Add_761D3920_Out_2, float3(0, 0, 0), _Branch_8C107061_Out_3);
                float _Property_CF1F92D7_Out_0 = Vector1_2EC6D670;
                float3 _Multiply_9BA2526D_Out_2;
                Unity_Multiply_float(_Branch_8C107061_Out_3, (_Property_CF1F92D7_Out_0.xxx), _Multiply_9BA2526D_Out_2);
                float3 _Add_EBF0803A_Out_2;
                Unity_Add_float3(_Add_E4BDFE70_Out_2, _Multiply_9BA2526D_Out_2, _Add_EBF0803A_Out_2);
                float _Property_F6EF5E6A_Out_0 = Vector1_A2C4B4F4;
                float3 _Multiply_E48C57DB_Out_2;
                Unity_Multiply_float(_Add_EBF0803A_Out_2, (_Property_F6EF5E6A_Out_0.xxx), _Multiply_E48C57DB_Out_2);
                float _Length_77726886_Out_1;
                Unity_Length_float3(_Multiply_E48C57DB_Out_2, _Length_77726886_Out_1);
                float _Property_E82EE598_Out_0 = Vector1_7F78DDD2;
                float _Add_D4269173_Out_2;
                Unity_Add_float(_Length_77726886_Out_1, _Property_E82EE598_Out_0, _Add_D4269173_Out_2);
                float _Multiply_C16CC36_Out_2;
                Unity_Multiply_float(_Add_D4269173_Out_2, 0.001, _Multiply_C16CC36_Out_2);
                direction_1 = _Multiply_E48C57DB_Out_2;
                strength_2 = _Multiply_C16CC36_Out_2;
            }
            
            void Unity_CrossProduct_float(float3 A, float3 B, out float3 Out)
            {
                Out = cross(A, B);
            }
            
            void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
            {
                Out = dot(A, B);
            }
            
            void Unity_Distance_float3(float3 A, float3 B, out float Out)
            {
                Out = distance(A, B);
            }
            
            void Unity_Divide_float(float A, float B, out float Out)
            {
                Out = A / B;
            }
            
            void Unity_Absolute_float(float In, out float Out)
            {
                Out = abs(In);
            }
            
            void Unity_Maximum_float(float A, float B, out float Out)
            {
                Out = max(A, B);
            }
            
            void Unity_Cosine_float(float In, out float Out)
            {
                Out = cos(In);
            }
            
            void Unity_Sine_float(float In, out float Out)
            {
                Out = sin(In);
            }
            
            void Unity_Comparison_NotEqual_float(float A, float B, out float Out)
            {
                Out = A != B ? 1 : 0;
            }
            
            struct Bindings_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf
            {
                float3 ObjectSpaceNormal;
                float3 WorldSpaceNormal;
                float3 ObjectSpaceTangent;
                float3 WorldSpaceTangent;
                float3 ObjectSpaceBiTangent;
                float3 WorldSpaceBiTangent;
                float4 VertexColor;
            };
            
            void SG_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf(float Vector1_BCB03E1A, float3 Vector3_C30D997B, float Vector1_A2C4B4F4, float Vector1_7EE0F94A, float Boolean_527CB26E, float Vector1_DE1BF63A, float Vector1_7F78DDD2, float3 Vector3_DE8CC74D, TEXTURE2D_PARAM(Texture2D_5BAC276D, samplerTexture2D_5BAC276D), float4 Texture2D_5BAC276D_TexelSize, TEXTURE2D_PARAM(Texture2D_A3874DB9, samplerTexture2D_A3874DB9), float4 Texture2D_A3874DB9_TexelSize, float4 Vector4_EBFF8CDE, float Vector1_B4470F9B, float Vector1_2EC6D670, float Vector1_9365F438, float Vector1_F53C4B89, float Vector1_6803B355, Bindings_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf IN, out float3 vertex_1, out float3 normal_2)
            {
                float4 _Vector4_96035CAB_Out_0 = float4(0, 0, 0, 1);
                float3 _Transform_56C94D33_Out_1 = TransformObjectToWorld((_Vector4_96035CAB_Out_0.xyz).xyz);
                float3 _Property_ED8BB836_Out_0 = Vector3_C30D997B;
                float3 _Transform_A839B73F_Out_1 = TransformObjectToWorld(_Property_ED8BB836_Out_0.xyz);
                float _Property_46785E9D_Out_0 = Boolean_527CB26E;
                float _Property_309A125A_Out_0 = Vector1_7EE0F94A;
                float _Comparison_FB7B17F4_Out_2;
                Unity_Comparison_Greater_float(_Property_309A125A_Out_0, 0, _Comparison_FB7B17F4_Out_2);
                float _Split_9DCBE03C_R_1 = _Transform_A839B73F_Out_1[0];
                float _Split_9DCBE03C_G_2 = _Transform_A839B73F_Out_1[1];
                float _Split_9DCBE03C_B_3 = _Transform_A839B73F_Out_1[2];
                float _Split_9DCBE03C_A_4 = 0;
                float _Split_2643B819_R_1 = _Transform_56C94D33_Out_1[0];
                float _Split_2643B819_G_2 = _Transform_56C94D33_Out_1[1];
                float _Split_2643B819_B_3 = _Transform_56C94D33_Out_1[2];
                float _Split_2643B819_A_4 = 0;
                float _Subtract_72710DB_Out_2;
                Unity_Subtract_float(_Split_9DCBE03C_G_2, _Split_2643B819_G_2, _Subtract_72710DB_Out_2);
                float _Comparison_A59CB55E_Out_2;
                Unity_Comparison_Less_float(_Subtract_72710DB_Out_2, _Property_309A125A_Out_0, _Comparison_A59CB55E_Out_2);
                float _And_75A07D3D_Out_2;
                Unity_And_float(_Comparison_FB7B17F4_Out_2, _Comparison_A59CB55E_Out_2, _And_75A07D3D_Out_2);
                float _Property_C5B18F25_Out_0 = Vector1_A2C4B4F4;
                float _Branch_71DEDA04_Out_3;
                Unity_Branch_float(_And_75A07D3D_Out_2, 1E-05, _Property_C5B18F25_Out_0, _Branch_71DEDA04_Out_3);
                float _Split_CAA3FAC4_R_1 = IN.VertexColor[0];
                float _Split_CAA3FAC4_G_2 = IN.VertexColor[1];
                float _Split_CAA3FAC4_B_3 = IN.VertexColor[2];
                float _Split_CAA3FAC4_A_4 = IN.VertexColor[3];
                float _Multiply_6282C968_Out_2;
                Unity_Multiply_float(_Branch_71DEDA04_Out_3, _Split_CAA3FAC4_A_4, _Multiply_6282C968_Out_2);
                float _Branch_FD6CEDEF_Out_3;
                Unity_Branch_float(_Property_46785E9D_Out_0, _Multiply_6282C968_Out_2, _Branch_71DEDA04_Out_3, _Branch_FD6CEDEF_Out_3);
                float _Property_8C9BC3F_Out_0 = Vector1_7F78DDD2;
                float4 _Property_DB8C20D5_Out_0 = Vector4_EBFF8CDE;
                float _Property_C83CCC0B_Out_0 = Vector1_B4470F9B;
                float _Property_9121207F_Out_0 = Vector1_2EC6D670;
                float _Property_9105DCD7_Out_0 = Vector1_9365F438;
                float _Property_6EE84426_Out_0 = Vector1_F53C4B89;
                float _Property_51392D3_Out_0 = Vector1_6803B355;
                float _Property_3C488CF_Out_0 = Vector1_BCB03E1A;
                Bindings_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10 _WindNMCalculateNoShiver_A0D948FA;
                float3 _WindNMCalculateNoShiver_A0D948FA_direction_1;
                float _WindNMCalculateNoShiver_A0D948FA_strength_2;
                SG_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10(_Transform_A839B73F_Out_1, _Transform_56C94D33_Out_1, _Branch_FD6CEDEF_Out_3, _Property_8C9BC3F_Out_0, TEXTURE2D_ARGS(Texture2D_5BAC276D, samplerTexture2D_5BAC276D), Texture2D_5BAC276D_TexelSize, TEXTURE2D_ARGS(Texture2D_A3874DB9, samplerTexture2D_A3874DB9), Texture2D_A3874DB9_TexelSize, _Property_DB8C20D5_Out_0, _Property_C83CCC0B_Out_0, _Property_9121207F_Out_0, _Property_9105DCD7_Out_0, _Property_6EE84426_Out_0, _Property_51392D3_Out_0, _Property_3C488CF_Out_0, _WindNMCalculateNoShiver_A0D948FA, _WindNMCalculateNoShiver_A0D948FA_direction_1, _WindNMCalculateNoShiver_A0D948FA_strength_2);
                float3 _CrossProduct_417F56_Out_2;
                Unity_CrossProduct_float(float3 (0, 1, 0), _WindNMCalculateNoShiver_A0D948FA_direction_1, _CrossProduct_417F56_Out_2);
                float3 _Normalize_4E99CADE_Out_1;
                Unity_Normalize_float3(_CrossProduct_417F56_Out_2, _Normalize_4E99CADE_Out_1);
                float3 _Subtract_8E413BBF_Out_2;
                Unity_Subtract_float3(_Transform_A839B73F_Out_1, _Transform_56C94D33_Out_1, _Subtract_8E413BBF_Out_2);
                float _DotProduct_111C5979_Out_2;
                Unity_DotProduct_float3(_Normalize_4E99CADE_Out_1, _Subtract_8E413BBF_Out_2, _DotProduct_111C5979_Out_2);
                float3 _Multiply_6B4F7E94_Out_2;
                Unity_Multiply_float(_Normalize_4E99CADE_Out_1, (_DotProduct_111C5979_Out_2.xxx), _Multiply_6B4F7E94_Out_2);
                float3 _Add_20CCB137_Out_2;
                Unity_Add_float3(_Transform_56C94D33_Out_1, _Multiply_6B4F7E94_Out_2, _Add_20CCB137_Out_2);
                float3 _Subtract_32DFFF4F_Out_2;
                Unity_Subtract_float3(_Transform_A839B73F_Out_1, _Add_20CCB137_Out_2, _Subtract_32DFFF4F_Out_2);
                float _Distance_77B26FEA_Out_2;
                Unity_Distance_float3(_Transform_A839B73F_Out_1, _Transform_56C94D33_Out_1, _Distance_77B26FEA_Out_2);
                float _Property_FB0C946E_Out_0 = Vector1_DE1BF63A;
                float _Divide_C2F89B8E_Out_2;
                Unity_Divide_float(_Distance_77B26FEA_Out_2, _Property_FB0C946E_Out_0, _Divide_C2F89B8E_Out_2);
                float _Absolute_F60A1055_Out_1;
                Unity_Absolute_float(_Divide_C2F89B8E_Out_2, _Absolute_F60A1055_Out_1);
                float _Vector1_776AF5AC_Out_0 = 1E-07;
                float _Maximum_4166AFF2_Out_2;
                Unity_Maximum_float(_Absolute_F60A1055_Out_1, _Vector1_776AF5AC_Out_0, _Maximum_4166AFF2_Out_2);
                float _Divide_C7B0EA9F_Out_2;
                Unity_Divide_float(1, _Property_FB0C946E_Out_0, _Divide_C7B0EA9F_Out_2);
                float _Power_A9B007BF_Out_2;
                Unity_Power_float(_Maximum_4166AFF2_Out_2, _Divide_C7B0EA9F_Out_2, _Power_A9B007BF_Out_2);
                float _Multiply_58839CDF_Out_2;
                Unity_Multiply_float(_WindNMCalculateNoShiver_A0D948FA_strength_2, _Power_A9B007BF_Out_2, _Multiply_58839CDF_Out_2);
                float _Cosine_C162178D_Out_1;
                Unity_Cosine_float(_Multiply_58839CDF_Out_2, _Cosine_C162178D_Out_1);
                float3 _Multiply_B16DE76A_Out_2;
                Unity_Multiply_float(_Subtract_32DFFF4F_Out_2, (_Cosine_C162178D_Out_1.xxx), _Multiply_B16DE76A_Out_2);
                float3 _CrossProduct_10AAB5C9_Out_2;
                Unity_CrossProduct_float(_Normalize_4E99CADE_Out_1, _Subtract_32DFFF4F_Out_2, _CrossProduct_10AAB5C9_Out_2);
                float _Sine_CD6051C7_Out_1;
                Unity_Sine_float(_Multiply_58839CDF_Out_2, _Sine_CD6051C7_Out_1);
                float3 _Multiply_E565B59B_Out_2;
                Unity_Multiply_float(_CrossProduct_10AAB5C9_Out_2, (_Sine_CD6051C7_Out_1.xxx), _Multiply_E565B59B_Out_2);
                float3 _Add_70586F80_Out_2;
                Unity_Add_float3(_Multiply_B16DE76A_Out_2, _Multiply_E565B59B_Out_2, _Add_70586F80_Out_2);
                float3 _Add_773B285F_Out_2;
                Unity_Add_float3(_Add_20CCB137_Out_2, _Add_70586F80_Out_2, _Add_773B285F_Out_2);
                float3 _Transform_3BC8B282_Out_1 = TransformWorldToObject(_Add_773B285F_Out_2.xyz);
                float3 _Property_37555482_Out_0 = Vector3_DE8CC74D;
                float _Length_2799ABFE_Out_1;
                Unity_Length_float3(_Property_37555482_Out_0, _Length_2799ABFE_Out_1);
                float _Comparison_4940F3B6_Out_2;
                Unity_Comparison_NotEqual_float(_Length_2799ABFE_Out_1, 0, _Comparison_4940F3B6_Out_2);
                float3 _Multiply_5354DD91_Out_2;
                Unity_Multiply_float(IN.WorldSpaceNormal, _Property_37555482_Out_0, _Multiply_5354DD91_Out_2);
                float3 _Branch_993A8BB_Out_3;
                Unity_Branch_float3(_Comparison_4940F3B6_Out_2, _Multiply_5354DD91_Out_2, IN.WorldSpaceNormal, _Branch_993A8BB_Out_3);
                vertex_1 = _Transform_3BC8B282_Out_1;
                normal_2 = _Branch_993A8BB_Out_3;
            }
            
            void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
            {
                Out = UV * Tiling + Offset;
            }
            
            void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
            {
                Out = A * B;
            }
            
            void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
            {
                Out = Predicate ? True : False;
            }
            
            void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
            {
                Out = lerp(A, B, T);
            }
        
            // Graph Vertex
            struct VertexDescriptionInputs
            {
                float3 ObjectSpaceNormal;
                float3 WorldSpaceNormal;
                float3 ObjectSpaceTangent;
                float3 WorldSpaceTangent;
                float3 ObjectSpaceBiTangent;
                float3 WorldSpaceBiTangent;
                float3 ObjectSpacePosition;
                float4 VertexColor;
                float3 TimeParameters;
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
                Bindings_NMFoliageVSProIndirect_5daaeae117458b94ca071c13e7a67c32 _NMFoliageVSProIndirect_6AFECCFE;
                float3 _NMFoliageVSProIndirect_6AFECCFE_ObjectSpacePosition_1;
                SG_NMFoliageVSProIndirect_5daaeae117458b94ca071c13e7a67c32(IN.ObjectSpacePosition, _NMFoliageVSProIndirect_6AFECCFE, _NMFoliageVSProIndirect_6AFECCFE_ObjectSpacePosition_1);
                float _Property_3E4B4411_Out_0 = _Drag;
                float _Property_7F252CE7_Out_0 = _HeightDrag;
                float _Property_7865D519_Out_0 = _Stiffness;
                float _Property_D5195AAC_Out_0 = _InitialBend;
                float4 _Property_FFB305BA_Out_0 = _NewNormal;
                float4 _Property_46C9B1EE_Out_0 = WIND_SETTINGS_WorldDirectionAndSpeed;
                float _Property_F9C82607_Out_0 = WIND_SETTINGS_FlexNoiseScale;
                float _Property_1DC2420_Out_0 = WIND_SETTINGS_Turbulence;
                float _Property_753163F4_Out_0 = WIND_SETTINGS_GustSpeed;
                float _Property_249371F4_Out_0 = WIND_SETTINGS_GustScale;
                float _Property_6A8E929E_Out_0 = WIND_SETTINGS_GustWorldScale;
                Bindings_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf _WindNMNoShiver_A2E31333;
                _WindNMNoShiver_A2E31333.ObjectSpaceNormal = IN.ObjectSpaceNormal;
                _WindNMNoShiver_A2E31333.WorldSpaceNormal = IN.WorldSpaceNormal;
                _WindNMNoShiver_A2E31333.ObjectSpaceTangent = IN.ObjectSpaceTangent;
                _WindNMNoShiver_A2E31333.WorldSpaceTangent = IN.WorldSpaceTangent;
                _WindNMNoShiver_A2E31333.ObjectSpaceBiTangent = IN.ObjectSpaceBiTangent;
                _WindNMNoShiver_A2E31333.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
                _WindNMNoShiver_A2E31333.VertexColor = IN.VertexColor;
                float3 _WindNMNoShiver_A2E31333_vertex_1;
                float3 _WindNMNoShiver_A2E31333_normal_2;
                SG_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf(IN.TimeParameters.x, _NMFoliageVSProIndirect_6AFECCFE_ObjectSpacePosition_1, _Property_3E4B4411_Out_0, _Property_7F252CE7_Out_0, 0, _Property_7865D519_Out_0, _Property_D5195AAC_Out_0, (_Property_FFB305BA_Out_0.xyz), TEXTURE2D_ARGS(WIND_SETTINGS_TexNoise, samplerWIND_SETTINGS_TexNoise), WIND_SETTINGS_TexNoise_TexelSize, TEXTURE2D_ARGS(WIND_SETTINGS_TexGust, samplerWIND_SETTINGS_TexGust), WIND_SETTINGS_TexGust_TexelSize, _Property_46C9B1EE_Out_0, _Property_F9C82607_Out_0, _Property_1DC2420_Out_0, _Property_753163F4_Out_0, _Property_249371F4_Out_0, _Property_6A8E929E_Out_0, _WindNMNoShiver_A2E31333, _WindNMNoShiver_A2E31333_vertex_1, _WindNMNoShiver_A2E31333_normal_2);
                description.VertexPosition = _WindNMNoShiver_A2E31333_vertex_1;
                description.VertexNormal = IN.ObjectSpaceNormal;
                description.VertexTangent = IN.ObjectSpaceTangent;
                return description;
            }
            
            // Graph Pixel
            struct SurfaceDescriptionInputs
            {
                float4 uv0;
                float4 uv3;
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
                float4 _Property_EC7746F0_Out_0 = _TrunkTilingOffset;
                float _Split_B742091E_R_1 = _Property_EC7746F0_Out_0[0];
                float _Split_B742091E_G_2 = _Property_EC7746F0_Out_0[1];
                float _Split_B742091E_B_3 = _Property_EC7746F0_Out_0[2];
                float _Split_B742091E_A_4 = _Property_EC7746F0_Out_0[3];
                float2 _Vector2_C5944BDD_Out_0 = float2(_Split_B742091E_R_1, _Split_B742091E_G_2);
                float2 _Vector2_A68E28C5_Out_0 = float2(_Split_B742091E_B_3, _Split_B742091E_A_4);
                float2 _TilingAndOffset_97CBEADA_Out_3;
                Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_C5944BDD_Out_0, _Vector2_A68E28C5_Out_0, _TilingAndOffset_97CBEADA_Out_3);
                float4 _SampleTexture2D_B919BA28_RGBA_0 = SAMPLE_TEXTURE2D(_TrunkBaseColorMap, sampler_TrunkBaseColorMap, _TilingAndOffset_97CBEADA_Out_3);
                float _SampleTexture2D_B919BA28_R_4 = _SampleTexture2D_B919BA28_RGBA_0.r;
                float _SampleTexture2D_B919BA28_G_5 = _SampleTexture2D_B919BA28_RGBA_0.g;
                float _SampleTexture2D_B919BA28_B_6 = _SampleTexture2D_B919BA28_RGBA_0.b;
                float _SampleTexture2D_B919BA28_A_7 = _SampleTexture2D_B919BA28_RGBA_0.a;
                float4 _Property_7FC0454F_Out_0 = _TrunkBaseColor;
                float4 _Multiply_6F337D09_Out_2;
                Unity_Multiply_float(_SampleTexture2D_B919BA28_RGBA_0, _Property_7FC0454F_Out_0, _Multiply_6F337D09_Out_2);
                float _Property_91B33228_Out_0 = _BarkUseUV3;
                float4 _UV_D3D66B0E_Out_0 = IN.uv3;
                float4 _UV_62FB944B_Out_0 = IN.uv0;
                float4 _Branch_7E7DD05F_Out_3;
                Unity_Branch_float4(_Property_91B33228_Out_0, _UV_D3D66B0E_Out_0, _UV_62FB944B_Out_0, _Branch_7E7DD05F_Out_3);
                float4 _Property_67884C_Out_0 = _BarkTilingOffset;
                float _Split_6B4B02A_R_1 = _Property_67884C_Out_0[0];
                float _Split_6B4B02A_G_2 = _Property_67884C_Out_0[1];
                float _Split_6B4B02A_B_3 = _Property_67884C_Out_0[2];
                float _Split_6B4B02A_A_4 = _Property_67884C_Out_0[3];
                float2 _Vector2_A7F21F38_Out_0 = float2(_Split_6B4B02A_R_1, _Split_6B4B02A_G_2);
                float2 _Vector2_1DA22E74_Out_0 = float2(_Split_6B4B02A_B_3, _Split_6B4B02A_A_4);
                float2 _TilingAndOffset_3B5515F1_Out_3;
                Unity_TilingAndOffset_float((_Branch_7E7DD05F_Out_3.xy), _Vector2_A7F21F38_Out_0, _Vector2_1DA22E74_Out_0, _TilingAndOffset_3B5515F1_Out_3);
                float4 _SampleTexture2D_7E4BB55F_RGBA_0 = SAMPLE_TEXTURE2D(_BarkBaseColorMap, sampler_BarkBaseColorMap, _TilingAndOffset_3B5515F1_Out_3);
                float _SampleTexture2D_7E4BB55F_R_4 = _SampleTexture2D_7E4BB55F_RGBA_0.r;
                float _SampleTexture2D_7E4BB55F_G_5 = _SampleTexture2D_7E4BB55F_RGBA_0.g;
                float _SampleTexture2D_7E4BB55F_B_6 = _SampleTexture2D_7E4BB55F_RGBA_0.b;
                float _SampleTexture2D_7E4BB55F_A_7 = _SampleTexture2D_7E4BB55F_RGBA_0.a;
                float4 _Property_400F851C_Out_0 = _BarkBaseColor;
                float4 _Multiply_22EAC4BF_Out_2;
                Unity_Multiply_float(_SampleTexture2D_7E4BB55F_RGBA_0, _Property_400F851C_Out_0, _Multiply_22EAC4BF_Out_2);
                float4 _Property_6F963EC1_Out_0 = _BarkBlendMaskTilingOffset;
                float _Split_7EFCE35C_R_1 = _Property_6F963EC1_Out_0[0];
                float _Split_7EFCE35C_G_2 = _Property_6F963EC1_Out_0[1];
                float _Split_7EFCE35C_B_3 = _Property_6F963EC1_Out_0[2];
                float _Split_7EFCE35C_A_4 = _Property_6F963EC1_Out_0[3];
                float2 _Vector2_3757C307_Out_0 = float2(_Split_7EFCE35C_R_1, _Split_7EFCE35C_G_2);
                float2 _Vector2_1FA6DD61_Out_0 = float2(_Split_7EFCE35C_B_3, _Split_7EFCE35C_A_4);
                float2 _TilingAndOffset_E00C37C5_Out_3;
                Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_3757C307_Out_0, _Vector2_1FA6DD61_Out_0, _TilingAndOffset_E00C37C5_Out_3);
                float4 _SampleTexture2D_BCB513F9_RGBA_0 = SAMPLE_TEXTURE2D(_LayerMask, sampler_LayerMask, _TilingAndOffset_E00C37C5_Out_3);
                float _SampleTexture2D_BCB513F9_R_4 = _SampleTexture2D_BCB513F9_RGBA_0.r;
                float _SampleTexture2D_BCB513F9_G_5 = _SampleTexture2D_BCB513F9_RGBA_0.g;
                float _SampleTexture2D_BCB513F9_B_6 = _SampleTexture2D_BCB513F9_RGBA_0.b;
                float _SampleTexture2D_BCB513F9_A_7 = _SampleTexture2D_BCB513F9_RGBA_0.a;
                float4 _Lerp_FB04343D_Out_3;
                Unity_Lerp_float4(_Multiply_6F337D09_Out_2, _Multiply_22EAC4BF_Out_2, (_SampleTexture2D_BCB513F9_A_7.xxxx), _Lerp_FB04343D_Out_3);
                surface.Albedo = (_Lerp_FB04343D_Out_3.xyz);
                surface.Alpha = 1;
                surface.AlphaClipThreshold = 0.5;
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
                float4 uv3 : TEXCOORD3;
                float4 color : COLOR;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif
            };
        
            // Generated Type: Varyings
            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float4 texCoord0;
                float4 texCoord3;
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
                float4 interp00 : TEXCOORD0;
                float4 interp01 : TEXCOORD1;
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
                output.interp00.xyzw = input.texCoord0;
                output.interp01.xyzw = input.texCoord3;
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
                output.texCoord0 = input.interp00.xyzw;
                output.texCoord3 = input.interp01.xyzw;
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
                output.WorldSpaceNormal =            TransformObjectToWorldNormal(input.normalOS);
                output.ObjectSpaceTangent =          input.tangentOS;
                output.WorldSpaceTangent =           TransformObjectToWorldDir(input.tangentOS.xyz);
                output.ObjectSpaceBiTangent =        normalize(cross(input.normalOS, input.tangentOS) * (input.tangentOS.w > 0.0f ? 1.0f : -1.0f) * GetOddNegativeScale());
                output.WorldSpaceBiTangent =         TransformObjectToWorldDir(output.ObjectSpaceBiTangent);
                output.ObjectSpacePosition =         input.positionOS;
                output.VertexColor =                 input.color;
                output.TimeParameters =              _TimeParameters.xyz;
            
                return output;
            }
            
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
            
            
            
            
            
                output.uv0 =                         input.texCoord0;
                output.uv3 =                         input.texCoord3;
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
