// Copyright 2020 Visual Design Cafe. All rights reserved.
// Package: Nature Shaders
// Website: https://www.visualdesigncafe.com/nature-shaders
// Documentation: https://support.visualdesigncafe.com/hc/categories/900000043503

#ifndef NODE_TRANSLUCENCY_INCLUDED
#define NODE_TRANSLUCENCY_INCLUDED

#include "../Input/Object Pivot.cginc"
#include "../Input/Object Height.cginc"

#ifdef STANDARD_RENDER_PIPELINE
	#include "UnityCG.cginc"
	#include "UnityShaderVariables.cginc"
	#include "AutoLight.cginc"
	#include "UnityPBSLighting.cginc"
	#include "UnityStandardUtils.cginc"

	struct Light
	{
		half3   direction;
		half3   color;
		half    distanceAttenuation;
		half    shadowAttenuation;
	};

	// Get the main light. Only works for directional lights.
	Light GetMainLight()
	{
		Light light;
		light.direction = _WorldSpaceLightPos0.xyz;
		light.distanceAttenuation = 1.0;
		light.shadowAttenuation = 1.0;
		light.color = _LightColor0 .rgb;

		return light;
	}

	// Get the main light. Works for all lights but requires a vertex world position.
	Light GetMainLight( float3 vertexWorldPosition )
	{
		Light light;
		#if defined(POINT) || defined(POINT_COOKIE) || defined(SPOT)
			light.direction = normalize(_WorldSpaceLightPos0.xyz - vertexWorldPosition);
			light.distanceAttenuation = 1.0;
		#else
			light.direction = _WorldSpaceLightPos0.xyz;
			light.distanceAttenuation = 1.0;
		#endif
		light.shadowAttenuation = 1.0;
		light.color = _LightColor0 .rgb;

		return light;
	}
#endif

struct TranslucencyInput
{
	float Scale;
	float NormalDistortion;
	float Scattering;
	float Thickness;
	half3 Color;
};

void GetTranslucencyInput( float thickness, out TranslucencyInput input )
{
	#ifdef PROPERTY_Translucency
		input.Scale = _Translucency;
	#else
		input.Scale = 1;
	#endif

	#ifdef PROPERTY_TranslucencyDistortion
		input.NormalDistortion = _TranslucencyDistortion;
	#else
		input.NormalDistortion = 0.5;
	#endif

	#ifdef PROPERTY_TranslucencyScattering
		input.Scattering = _TranslucencyScattering;
	#else
		input.Scattering = 2;
	#endif

	input.Thickness = thickness;

	#ifdef PROPERTY_TranslucencyColor
		input.Color = _TranslucencyColor.rgb;
	#else
		input.Color = half3(1, 1, 1);
	#endif
}

float3 Overlay(float3 a, float3 b)
{
	return a < 0.5
		? 2 * a * b 
		: 1 - 2 * (1-a) * (1-b);
}

half3 Translucency(
	TranslucencyInput input,
	float3 bakedGI,
	float3 surfaceAlbedo,
	float3 surfaceNormal, 
	float3 viewDirectionWS, 
	Light light ) 
{
	half3 lightDir = light.direction + surfaceNormal * input.NormalDistortion;
	half transVdotL = pow( saturate( dot( viewDirectionWS, -lightDir ) ), input.Scattering ) * input.Scale;
	half3 translucency = light.shadowAttenuation * light.distanceAttenuation * (transVdotL + bakedGI) * (1-input.Thickness);
	return half3( surfaceAlbedo * light.color * translucency * input.Color );
}

#ifdef STANDARD_RENDER_PIPELINE
	struct SurfaceOutputStandardCustom
	{
		half3 Albedo;
		half3 Normal;
		half3 Emission;
		half Metallic;
		half Smoothness;
		half Occlusion;
		half Alpha;
		half3 Thickness;
	};

	half4 LightingStandardCustom( SurfaceOutputStandardCustom s, half3 viewDir, UnityGI gi )
	{
		Light light = GetMainLight();

		SurfaceOutputStandard r;
		r.Albedo = s.Albedo;
		r.Normal = s.Normal;
		r.Emission = s.Emission;
		r.Metallic = s.Metallic;
		r.Smoothness = s.Smoothness;
		r.Occlusion = s.Occlusion;
		r.Alpha = s.Alpha;

		#if defined(POINT) || defined(POINT_COOKIE) || defined(SPOT) || defined(_TRANSLUCENCY_OFF)
			half3 translucency = half3(0,0,0);
		#else
			TranslucencyInput input;
			GetTranslucencyInput( s.Thickness, input );
			half3 translucency = 
				input.Scale > 0
					? Translucency( 
						input, 
						gi.indirect.diffuse,
						s.Albedo,
						s.Normal, 
						viewDir, 
						GetMainLight())
					: half3(0,0,0);
		#endif

		half4 color = LightingStandard (r, viewDir, gi);
		color.rgb += Overlay(translucency.rgb, color.rgb);
		return color;
	}

	inline void LightingStandardCustom_GI(
		SurfaceOutputStandardCustom s, UnityGIInput data, inout UnityGI gi )
	{
		#if defined(UNITY_PASS_DEFERRED) && UNITY_ENABLE_REFLECTION_BUFFERS
			gi = UnityGlobalIllumination(data, s.Occlusion, s.Normal);
		#else
			UNITY_GLOSSY_ENV_FROM_SURFACE( g, s, data );
			gi = UnityGlobalIllumination( data, s.Occlusion, s.Normal, g );
		#endif
	}
#else
	void Translucency_float( 
		float4 color, 
		Varyings varyings,
		InputData inputData, 
		SurfaceDescription surfaceDescription, 
		out float4 colorOut )
	{
		colorOut = color;

		#ifndef _TRANSLUCENCY_OFF
			#if defined(_TYPE_GRASS) || defined(_TYPE_TREE_LEAVES) || defined(_TYPE_PLANT) || defined(_TYPE_TREE_BILLBOARD)
				
				#ifdef PROPERTY_ThicknessMap
					float thickness = 
						SAMPLE_TEXTURE2D(_ThicknessMap, sampler_ThicknessMap, varyings.texCoord0.xy).r;
				#else
					float thickness = 0;
				#endif
				
				#ifdef PROPERTY_ThicknessRemap
					thickness = Remap( thickness, _ThicknessRemap );
				#endif

				TranslucencyInput input;
				GetTranslucencyInput( thickness, input );
				
				half3 translucency = 
					input.Scale > 0
						? Translucency( 
							input, 
							inputData.bakedGI,
							surfaceDescription.Albedo,
							surfaceDescription.Normal, 
							inputData.viewDirectionWS, 
							GetMainLight(inputData.shadowCoord))
						: half3(0,0,0);

				/* // Disabled to improve performance.
				#ifdef _ADDITIONAL_LIGHTS
					uint pixelLightCount = GetAdditionalLightsCount();
					for (uint lightIndex = 0u; lightIndex < pixelLightCount; ++lightIndex)
					{
						translucency += 
							Translucency( 
								input, 
								inputData.bakedGI,
								surfaceDescription.Albedo,
								surfaceDescription.Normal, 
								inputData.viewDirectionWS, 
								GetAdditionalLight(lightIndex, inputData.positionWS));
					}
				#endif
				*/

				#if defined(_TYPE_GRASS)
					float3 vertex = TransformWorldToObject(inputData.positionWS.xyz);
					translucency *= saturate(vertex.y / GetObjectHeight());
				#endif

				colorOut.rgb += Overlay(translucency.rgb, color.rgb);
			#endif
		#endif
	}
#endif
#endif