Shader "NatureManufacture Shaders/Water River Vertex Color Flow"
{
	Properties
	{
		_UVVDirection1UDirection0("UV - V Direction (1) U Direction (0)", Int) = 0
		_WaterMainSpeed("Water Main Speed", Vector) = (1,1,0,0)
		_WaterMixSpeed("Water Mix Speed", Vector) = (0.01,0.05,0,0)
		_SmallCascadeMainSpeed("Small Cascade Main Speed", Vector) = (1,1,0,0)
		_SmallCascadeMixSpeed("Small Cascade Mix Speed", Vector) = (0.04,0.08,0,0)
		_BigCascadeMainSpeed("Big Cascade Main Speed", Vector) = (1,1,0,0)
		_BigCascadeMixSpeed("Big Cascade Mix Speed", Vector) = (0.02,0.28,0,0)
		_WaterDepth("Water Depth", Range( 0 , 1)) = 0
		_ShalowFalloff("Shalow Falloff", Float) = 0
		_ShalowDepth("Shalow Depth", Float) = 0
		_ShalowColor("Shalow Color", Color) = (1,1,1,0)
		_DeepColor("Deep Color", Color) = (0,0,0,0)
		_WaterDeepTranslucencyPower("Water Deep Translucency Power", Range( 0 , 10)) = 1
		_WaterShalowTranslucencyPower("Water Shalow Translucency Power", Range( 0 , 10)) = 1
		_WaterSpecular("Water Specular", Range( 0 , 1)) = 0
		_WaterSmoothness("Water Smoothness", Float) = 0
		_Distortion("Distortion", Float) = 0.5
		_WaterFalloffBorder("Water Falloff Border", Range( 0 , 10)) = 0
		_WaterNormal("Water Normal", 2D) = "bump" {}
		_NormalScale("Normal Scale", Float) = 0
		_SmallCascadeAngle("Small Cascade Angle", Range( 0.001 , 90)) = 90
		_SmallCascadeAngleFalloff("Small Cascade Angle Falloff", Range( 0 , 80)) = 5
		_SmallCascadeNormal("Small Cascade Normal", 2D) = "bump" {}
		_SmallCascadeNormalScale("Small Cascade Normal Scale", Float) = 0
		_SmallCascade("Small Cascade", 2D) = "white" {}
		_SmallCascadeColor("Small Cascade Color", Vector) = (1,1,1,0)
		_SmallCascadeFoamFalloff("Small Cascade Foam Falloff", Range( 0 , 10)) = 0
		_SmallCascadeSmoothness("Small Cascade Smoothness", Float) = 0
		_SmallCascadeSpecular("Small Cascade Specular", Range( 0 , 1)) = 0
		_BigCascadeAngle("Big Cascade Angle", Range( 0.001 , 90)) = 90
		_BigCascadeAngleFalloff("Big Cascade Angle Falloff", Range( 0 , 80)) = 15
		_BigCascadeNormal("Big Cascade Normal", 2D) = "bump" {}
		_BigCascadeNormalScale("Big Cascade Normal Scale", Float) = 0
		_BigCascade("Big Cascade", 2D) = "white" {}
		_BigCascadeColor("Big Cascade Color", Vector) = (1,1,1,0)
		_BigCascadeFoamFalloff("Big Cascade Foam Falloff", Range( 0 , 10)) = 0
		_BigCascadeTransparency("Big Cascade Transparency", Range( 0 , 1)) = 0
		_BigCascadeSmoothness("Big Cascade Smoothness", Float) = 0
		_BigCascadeSpecular("Big Cascade Specular", Range( 0 , 1)) = 0
		_Noise("Noise", 2D) = "white" {}
		_SmallCascadeNoisePower("Small Cascade Noise Power", Range( 0 , 10)) = 2.71
		_BigCascadeNoisePower("Big Cascade Noise Power", Range( 0 , 10)) = 2.71
		_NoiseSpeed("Noise Speed", Vector) = (-0.2,-0.5,0,0)
		_Foam("Foam", 2D) = "white" {}
		_FoamSpeed("Foam Speed", Vector) = (-0.001,0.018,0,0)
		_FoamColor("Foam Color", Vector) = (1,1,1,0)
		_FoamDepth("Foam Depth", Range( -100 , 100)) = 0
		_FoamFalloff("Foam Falloff", Range( -100 , 1)) = 1
		_FoamSpecular("Foam Specular", Range( 0 , 1)) = 0
		_FoamSmoothness("Foam Smoothness", Float) = 0
		_AOPower("AO Power", Range( 0 , 1)) = 1
		[HideInInspector] _texcoord4( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
		[Header(Forward Rendering Options)]
		[ToggleOff] _SpecularHighlights("Specular Highlights", Float) = 1.0
		[ToggleOff] _GlossyReflections("Reflections", Float) = 1.0
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+999" "IsEmissive" = "true"  }
		Cull Off
		ZTest LEqual
		Blend SrcAlpha OneMinusSrcAlpha , SrcAlpha OneMinusSrcAlpha
		BlendOp Add , Add
		GrabPass{ "_WaterGrab" }
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma shader_feature _SPECULARHIGHLIGHTS_OFF
		#pragma shader_feature _GLOSSYREFLECTIONS_OFF
		#pragma surface surf StandardSpecular keepalpha 
		struct Input
		{
			half2 uv_texcoord;
			half2 uv4_texcoord4;
			float3 worldNormal;
			INTERNAL_DATA
			float4 vertexColor : COLOR;
			float4 screenPos;
		};

		uniform half _NormalScale;
		uniform sampler2D _WaterNormal;
		uniform int _UVVDirection1UDirection0;
		uniform half2 _WaterMixSpeed;
		uniform float4 _WaterNormal_ST;
		uniform half2 _WaterMainSpeed;
		uniform half _SmallCascadeNormalScale;
		uniform sampler2D _SmallCascadeNormal;
		uniform half2 _SmallCascadeMixSpeed;
		uniform float4 _SmallCascadeNormal_ST;
		uniform half2 _SmallCascadeMainSpeed;
		uniform fixed _SmallCascadeAngle;
		uniform half _SmallCascadeAngleFalloff;
		uniform fixed _BigCascadeAngle;
		uniform half _BigCascadeAngleFalloff;
		uniform half _BigCascadeNormalScale;
		uniform sampler2D _BigCascadeNormal;
		uniform half2 _BigCascadeMixSpeed;
		uniform float4 _BigCascadeNormal_ST;
		uniform half2 _BigCascadeMainSpeed;
		uniform sampler2D _WaterGrab;
		uniform half _Distortion;
		uniform half4 _DeepColor;
		uniform half4 _ShalowColor;
		uniform sampler2D _CameraDepthTexture;
		uniform half _ShalowDepth;
		uniform half _ShalowFalloff;
		uniform half _BigCascadeTransparency;
		uniform half3 _FoamColor;
		uniform half _FoamDepth;
		uniform half _FoamFalloff;
		uniform sampler2D _Foam;
		uniform float4 _Foam_ST;
		uniform half2 _FoamSpeed;
		uniform sampler2D _SmallCascade;
		uniform sampler2D _Noise;
		uniform half2 _NoiseSpeed;
		uniform float4 _Noise_ST;
		uniform half _SmallCascadeNoisePower;
		uniform half3 _SmallCascadeColor;
		uniform half _SmallCascadeFoamFalloff;
		uniform sampler2D _BigCascade;
		uniform half _BigCascadeNoisePower;
		uniform half3 _BigCascadeColor;
		uniform half _BigCascadeFoamFalloff;
		uniform half _WaterDeepTranslucencyPower;
		uniform half _WaterShalowTranslucencyPower;
		uniform half _WaterSpecular;
		uniform half _FoamSpecular;
		uniform half _SmallCascadeSpecular;
		uniform half _BigCascadeSpecular;
		uniform half _WaterSmoothness;
		uniform half _FoamSmoothness;
		uniform half _SmallCascadeSmoothness;
		uniform half _BigCascadeSmoothness;
		uniform half _AOPower;
		uniform half _WaterDepth;
		uniform half _WaterFalloffBorder;


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float mulTime445 = _Time.y * 1;
			int Direction723 = _UVVDirection1UDirection0;
			float2 appendResult706 = (half2(_WaterMixSpeed.y , _WaterMixSpeed.x));
			float2 uv_WaterNormal = i.uv_texcoord * _WaterNormal_ST.xy + _WaterNormal_ST.zw;
			float2 panner612 = ( uv_WaterNormal + mulTime445 * (( (float)Direction723 == 1 ) ? _WaterMixSpeed :  appendResult706 ));
			float2 WaterSpeedValueMix516 = panner612;
			float2 appendResult705 = (half2(_WaterMainSpeed.y , _WaterMainSpeed.x));
			float2 uv4_TexCoord829 = i.uv4_texcoord4 * float2( 1,1 ) + float2( 0,0 );
			float2 appendResult823 = (half2(( (( (float)Direction723 == 1 ) ? _WaterMainSpeed :  appendResult705 ).x * uv4_TexCoord829.x ) , ( (( (float)Direction723 == 1 ) ? _WaterMainSpeed :  appendResult705 ).y * uv4_TexCoord829.y )));
			float mulTime815 = _Time.y * 1;
			float temp_output_816_0 = ( mulTime815 * 0.15 );
			float temp_output_818_0 = frac( ( temp_output_816_0 + 1 ) );
			float2 WaterSpeedValueMainFlowUV1830 = ( uv_WaterNormal + ( appendResult823 * temp_output_818_0 ) );
			float temp_output_820_0 = frac( ( temp_output_816_0 + 0.5 ) );
			float2 WaterSpeedValueMainFlowUV2831 = ( uv_WaterNormal + ( appendResult823 * temp_output_820_0 ) );
			float clampResult845 = clamp( abs( ( ( temp_output_818_0 + -0.5 ) * 2 ) ) , 0 , 1 );
			float SlowFlowHeightBase835 = clampResult845;
			float3 lerpResult838 = lerp( UnpackScaleNormal( tex2D( _WaterNormal, WaterSpeedValueMainFlowUV1830 ) ,_NormalScale ) , UnpackScaleNormal( tex2D( _WaterNormal, WaterSpeedValueMainFlowUV2831 ) ,_NormalScale ) , SlowFlowHeightBase835);
			float3 temp_output_24_0 = BlendNormals( UnpackScaleNormal( tex2D( _WaterNormal, WaterSpeedValueMix516 ) ,( _NormalScale * 1.2 ) ) , lerpResult838 );
			float mulTime427 = _Time.y * 1;
			float2 appendResult709 = (half2(_SmallCascadeMixSpeed.y , _SmallCascadeMixSpeed.x));
			float2 uv_SmallCascadeNormal = i.uv_texcoord * _SmallCascadeNormal_ST.xy + _SmallCascadeNormal_ST.zw;
			float2 panner597 = ( uv_SmallCascadeNormal + mulTime427 * (( (float)Direction723 == 1 ) ? _SmallCascadeMixSpeed :  appendResult709 ));
			float2 SmallCascadeSpeedValueMix433 = panner597;
			float2 appendResult710 = (half2(_SmallCascadeMainSpeed.y , _SmallCascadeMainSpeed.x));
			float2 appendResult849 = (half2(( (( (float)Direction723 == 1 ) ? _SmallCascadeMainSpeed :  appendResult710 ).x * uv4_TexCoord829.x ) , ( (( (float)Direction723 == 1 ) ? _SmallCascadeMainSpeed :  appendResult710 ).y * uv4_TexCoord829.y )));
			float mulTime941 = _Time.y * 1;
			float temp_output_942_0 = ( mulTime941 * 0.25 );
			float temp_output_946_0 = frac( ( temp_output_942_0 + 1 ) );
			float2 SmallCascadeWaterSpeedValueMainFlowUV1860 = ( uv_SmallCascadeNormal + ( appendResult849 * temp_output_946_0 ) );
			float2 SmallCascadeWaterSpeedValueMainFlowUV2854 = ( uv_SmallCascadeNormal + ( appendResult849 * frac( ( temp_output_942_0 + 0.5 ) ) ) );
			float clampResult858 = clamp( abs( ( ( temp_output_946_0 + -0.5 ) * 2 ) ) , 0 , 1 );
			float SmallCascadeSlowFlowHeightBase859 = clampResult858;
			float3 lerpResult864 = lerp( UnpackNormal( tex2D( _SmallCascadeNormal, SmallCascadeWaterSpeedValueMainFlowUV1860 ) ) , UnpackScaleNormal( tex2D( _SmallCascadeNormal, SmallCascadeWaterSpeedValueMainFlowUV2854 ) ,_SmallCascadeNormalScale ) , SmallCascadeSlowFlowHeightBase859);
			float3 temp_output_526_0 = BlendNormals( UnpackScaleNormal( tex2D( _SmallCascadeNormal, SmallCascadeSpeedValueMix433 ) ,_SmallCascadeNormalScale ) , lerpResult864 );
			half3 ase_worldNormal = WorldNormalVector( i, half3( 0, 0, 1 ) );
			float clampResult259 = clamp( ase_worldNormal.y , 0 , 1 );
			float temp_output_258_0 = ( _SmallCascadeAngle / 45 );
			float clampResult263 = clamp( ( clampResult259 - ( 1.0 - temp_output_258_0 ) ) , 0 , 2 );
			float clampResult584 = clamp( ( clampResult263 * ( 1 / temp_output_258_0 ) ) , 0 , 1 );
			float temp_output_267_0 = pow( ( 1.0 - clampResult584 ) , _SmallCascadeAngleFalloff );
			float clampResult507 = clamp( ase_worldNormal.y , 0 , 1 );
			float temp_output_504_0 = ( _BigCascadeAngle / 45 );
			float clampResult509 = clamp( ( clampResult507 - ( 1.0 - temp_output_504_0 ) ) , 0 , 2 );
			float clampResult583 = clamp( ( clampResult509 * ( 1 / temp_output_504_0 ) ) , 0 , 1 );
			float clampResult514 = clamp( pow( ( 1.0 - clampResult583 ) , _BigCascadeAngleFalloff ) , 0 , 1 );
			float clampResult285 = clamp( ( temp_output_267_0 - clampResult514 ) , 0 , 1 );
			float3 lerpResult330 = lerp( temp_output_24_0 , temp_output_526_0 , clampResult285);
			float mulTime519 = _Time.y * 1;
			float2 appendResult712 = (half2(_BigCascadeMixSpeed.y , _BigCascadeMixSpeed.x));
			float2 uv_BigCascadeNormal = i.uv_texcoord * _BigCascadeNormal_ST.xy + _BigCascadeNormal_ST.zw;
			float2 panner606 = ( uv_BigCascadeNormal + mulTime519 * (( (float)Direction723 == 1 ) ? _BigCascadeMixSpeed :  appendResult712 ));
			float2 BigCascadeSpeedValueMix608 = panner606;
			float2 appendResult714 = (half2(_BigCascadeMainSpeed.y , _BigCascadeMainSpeed.x));
			float2 appendResult884 = (half2(( (( (float)Direction723 == 1 ) ? _BigCascadeMainSpeed :  appendResult714 ).x * uv4_TexCoord829.x ) , ( (( (float)Direction723 == 1 ) ? _BigCascadeMainSpeed :  appendResult714 ).y * uv4_TexCoord829.y )));
			float mulTime952 = _Time.y * 1;
			float temp_output_951_0 = ( mulTime952 * 0.6 );
			float temp_output_948_0 = frac( ( temp_output_951_0 + 1 ) );
			float2 BigCascadeWaterSpeedValueMainFlowUV1893 = ( uv_BigCascadeNormal + ( appendResult884 * temp_output_948_0 ) );
			float2 BigCascadeWaterSpeedValueMainFlowUV2894 = ( uv_BigCascadeNormal + ( appendResult884 * frac( ( temp_output_951_0 + 0.5 ) ) ) );
			float clampResult892 = clamp( abs( ( ( temp_output_948_0 + -0.5 ) * 2 ) ) , 0 , 1 );
			float BigCascadeSlowFlowHeightBase895 = clampResult892;
			float3 lerpResult899 = lerp( UnpackScaleNormal( tex2D( _BigCascadeNormal, BigCascadeWaterSpeedValueMainFlowUV1893 ) ,_BigCascadeNormalScale ) , UnpackScaleNormal( tex2D( _BigCascadeNormal, BigCascadeWaterSpeedValueMainFlowUV2894 ) ,_BigCascadeNormalScale ) , BigCascadeSlowFlowHeightBase895);
			float3 temp_output_333_0 = BlendNormals( UnpackScaleNormal( tex2D( _BigCascadeNormal, BigCascadeSpeedValueMix608 ) ,_BigCascadeNormalScale ) , lerpResult899 );
			float3 lerpResult529 = lerp( lerpResult330 , temp_output_333_0 , clampResult514);
			float3 lerpResult748 = lerp( lerpResult529 , temp_output_24_0 , ( i.vertexColor / float4( 1,1,1,1 ) ).r);
			float3 lerpResult749 = lerp( lerpResult748 , temp_output_526_0 , ( i.vertexColor / float4( 1,1,1,1 ) ).g);
			float3 lerpResult750 = lerp( lerpResult749 , temp_output_333_0 , ( i.vertexColor / float4( 1,1,1,1 ) ).b);
			o.Normal = lerpResult750;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float2 appendResult163 = (half2(ase_grabScreenPosNorm.r , ase_grabScreenPosNorm.g));
			float4 screenColor65 = tex2D( _WaterGrab, ( half3( ( appendResult163 / ase_grabScreenPosNorm.a ) ,  0.0 ) + ( lerpResult529 * _Distortion ) ).xy );
			float eyeDepth1 = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD(ase_screenPos))));
			float temp_output_89_0 = abs( ( eyeDepth1 - ase_screenPos.w ) );
			float lerpResult810 = lerp( pow( ( temp_output_89_0 + _ShalowDepth ) , _ShalowFalloff ) , 100 , ( _BigCascadeTransparency * clampResult514 ));
			float temp_output_94_0 = saturate( lerpResult810 );
			float4 lerpResult13 = lerp( _DeepColor , _ShalowColor , temp_output_94_0);
			float temp_output_113_0 = saturate( pow( ( temp_output_89_0 + _FoamDepth ) , _FoamFalloff ) );
			float2 uv_Foam = i.uv_texcoord * _Foam_ST.xy + _Foam_ST.zw;
			float2 appendResult918 = (half2(_FoamSpeed.y , _FoamSpeed.x));
			float2 appendResult924 = (half2(( (( (float)Direction723 == 1 ) ? _FoamSpeed :  appendResult918 ).x * uv4_TexCoord829.x ) , ( (( (float)Direction723 == 1 ) ? _FoamSpeed :  appendResult918 ).y * uv4_TexCoord829.y )));
			float2 FoamCascadeWaterSpeedValueMainFlowUV1933 = ( uv_Foam + ( appendResult924 * temp_output_818_0 ) );
			float2 FoamCascadeWaterSpeedValueMainFlowUV2934 = ( uv_Foam + ( appendResult924 * temp_output_820_0 ) );
			float clampResult932 = clamp( abs( ( ( temp_output_818_0 + -0.5 ) * 2 ) ) , 0 , 1 );
			float FoamCascadeSlowFlowHeightBase935 = clampResult932;
			float lerpResult936 = lerp( tex2D( _Foam, FoamCascadeWaterSpeedValueMainFlowUV1933 ).r , tex2D( _Foam, FoamCascadeWaterSpeedValueMainFlowUV2934 ).r , FoamCascadeSlowFlowHeightBase935);
			float temp_output_114_0 = ( temp_output_113_0 * lerpResult936 );
			float4 lerpResult117 = lerp( lerpResult13 , half4( _FoamColor , 0.0 ) , temp_output_114_0);
			float4 lerpResult93 = lerp( screenColor65 , lerpResult117 , temp_output_113_0);
			float temp_output_458_0 = ( 1.0 - temp_output_94_0 );
			float4 lerpResult390 = lerp( lerpResult93 , lerpResult13 , temp_output_458_0);
			float lerpResult879 = lerp( tex2D( _SmallCascade, SmallCascadeWaterSpeedValueMainFlowUV1860 ).g , tex2D( _SmallCascade, SmallCascadeWaterSpeedValueMainFlowUV2854 ).g , SmallCascadeSlowFlowHeightBase859);
			float2 appendResult718 = (half2(_NoiseSpeed.y , _NoiseSpeed.x));
			float2 temp_output_743_0 = (( (float)Direction723 == 1 ) ? _NoiseSpeed :  appendResult718 );
			float2 uv_Noise = i.uv_texcoord * _Noise_ST.xy + _Noise_ST.zw;
			float2 panner646 = ( uv_Noise + _SinTime.x * temp_output_743_0);
			half4 tex2DNode647 = tex2D( _Noise, ( panner646 * float2( -1,-1 ) ) );
			float2 panner321 = ( uv_Noise + _SinTime.x * temp_output_743_0);
			half4 tex2DNode477 = tex2D( _Noise, panner321 );
			float clampResult488 = clamp( ( pow( min( tex2DNode647.r , tex2DNode477.r ) , _SmallCascadeNoisePower ) * 20 ) , 0 , 1 );
			float lerpResult480 = lerp( 0 , lerpResult879 , clampResult488);
			float3 temp_output_320_0 = ( lerpResult480 * _SmallCascadeColor );
			float clampResult322 = clamp( pow( lerpResult879 , _SmallCascadeFoamFalloff ) , 0 , 1 );
			float lerpResult580 = lerp( 0 , clampResult322 , clampResult285);
			float4 lerpResult324 = lerp( lerpResult390 , half4( temp_output_320_0 , 0.0 ) , lerpResult580);
			float lerpResult902 = lerp( tex2D( _BigCascade, BigCascadeWaterSpeedValueMainFlowUV1893 ).r , tex2D( _BigCascade, BigCascadeWaterSpeedValueMainFlowUV2894 ).r , BigCascadeSlowFlowHeightBase895);
			float clampResult807 = clamp( ( pow( min( tex2DNode647.r , tex2D( _Noise, ( panner321 + float2( -0.47,0.37 ) ) ).r ) , _BigCascadeNoisePower ) * 20 ) , 0 , 1 );
			float lerpResult626 = lerp( ( lerpResult902 * 0.5 ) , lerpResult902 , clampResult807);
			float3 temp_output_241_0 = ( lerpResult626 * _BigCascadeColor );
			float clampResult299 = clamp( pow( lerpResult902 , _BigCascadeFoamFalloff ) , 0 , 1 );
			float lerpResult579 = lerp( 0 , clampResult299 , clampResult514);
			float4 lerpResult239 = lerp( lerpResult324 , half4( temp_output_241_0 , 0.0 ) , lerpResult579);
			float4 lerpResult773 = lerp( screenColor65 , lerpResult13 , temp_output_458_0);
			float4 lerpResult757 = lerp( lerpResult239 , lerpResult773 , ( i.vertexColor / float4( 1,1,1,1 ) ).r);
			float4 lerpResult762 = lerp( lerpResult773 , half4( temp_output_320_0 , 0.0 ) , clampResult322);
			float4 lerpResult758 = lerp( lerpResult757 , lerpResult762 , ( i.vertexColor / float4( 1,1,1,1 ) ).g);
			float4 lerpResult763 = lerp( lerpResult773 , half4( temp_output_241_0 , 0.0 ) , clampResult299);
			float4 lerpResult756 = lerp( lerpResult758 , lerpResult763 , ( i.vertexColor / float4( 1,1,1,1 ) ).b);
			o.Albedo = lerpResult756.rgb;
			float clampResult552 = clamp( max( lerpResult529.x , lerpResult529.y ) , 0 , 1 );
			float4 lerpResult451 = lerp( float4( 0,0,0,0 ) , _ShalowColor , clampResult552);
			float lerpResult549 = lerp( _WaterDeepTranslucencyPower , _WaterShalowTranslucencyPower , temp_output_94_0);
			float4 lerpResult459 = lerp( float4( 0,0,0,0 ) , ( lerpResult451 * lerpResult549 ) , temp_output_458_0);
			o.Emission = lerpResult459.rgb;
			float lerpResult130 = lerp( _WaterSpecular , _FoamSpecular , temp_output_114_0);
			float lerpResult585 = lerp( lerpResult130 , _SmallCascadeSpecular , ( lerpResult580 * clampResult285 ));
			float lerpResult587 = lerp( lerpResult585 , _BigCascadeSpecular , ( lerpResult579 * clampResult514 ));
			float lerpResult785 = lerp( lerpResult587 , lerpResult130 , ( i.vertexColor / float4( 1,1,1,1 ) ).r);
			float lerpResult796 = lerp( lerpResult130 , _SmallCascadeSpecular , lerpResult580);
			float lerpResult786 = lerp( lerpResult785 , lerpResult796 , ( i.vertexColor / float4( 1,1,1,1 ) ).g);
			float lerpResult797 = lerp( lerpResult130 , _BigCascadeSpecular , lerpResult579);
			float lerpResult787 = lerp( lerpResult786 , lerpResult797 , ( i.vertexColor / float4( 1,1,1,1 ) ).b);
			half3 temp_cast_22 = (lerpResult787).xxx;
			o.Specular = temp_cast_22;
			float lerpResult591 = lerp( _WaterSmoothness , _FoamSmoothness , temp_output_114_0);
			float lerpResult593 = lerp( lerpResult591 , _SmallCascadeSmoothness , ( lerpResult580 * clampResult285 ));
			float lerpResult592 = lerp( lerpResult593 , _BigCascadeSmoothness , ( lerpResult579 * clampResult514 ));
			float lerpResult788 = lerp( lerpResult592 , lerpResult591 , ( i.vertexColor / float4( 1,1,1,1 ) ).r);
			float lerpResult798 = lerp( lerpResult591 , _SmallCascadeSmoothness , lerpResult580);
			float lerpResult789 = lerp( lerpResult788 , lerpResult798 , ( i.vertexColor / float4( 1,1,1,1 ) ).g);
			float lerpResult799 = lerp( lerpResult591 , _BigCascadeSmoothness , lerpResult579);
			float lerpResult790 = lerp( lerpResult789 , lerpResult799 , ( i.vertexColor / float4( 1,1,1,1 ) ).b);
			o.Smoothness = lerpResult790;
			o.Occlusion = _AOPower;
			float lerpResult208 = lerp( 0 , 1 , pow( saturate( pow( temp_output_89_0 , _WaterDepth ) ) , _WaterFalloffBorder ));
			o.Alpha = ( lerpResult208 * i.vertexColor.a );
		}

		ENDCG
	}
	Fallback "Diffuse"
}