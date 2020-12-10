// Copyright 2020 Visual Design Cafe. All rights reserved.
// Package: Nature Shaders
// Website: https://www.visualdesigncafe.com/nature-shaders
// Documentation: https://support.visualdesigncafe.com/hc/categories/900000043503

#ifndef NODE_COMPUTE_WIND_INCLUDED
#define NODE_COMPUTE_WIND_INCLUDED

#include "../Common.cginc"
#include "../Input/Wind Properties.cginc"
#include "../Input/Wind Strength.cginc"
#include "../Input/Turbulence Strength.cginc"
#include "Compute Ambient Wind.cginc"
#include "Compute Gust.cginc"
#include "Compute Turbulence.cginc"
#include "Combine Wind.cginc"

/// <summary>
/// Computes the wind based on the input parameters.
/// </summary>
void ComputeWind_float(
    float3 windDirection,       // The direction of the wind in world space.
    float3 objectPivot,         // The pivot of the object in world space.
    float3 vertexWorldPosition, // The vertex position in object space.
    float4 vertexColor,         // The vertex color.
    float phaseOffset,          // The time offset for the wind calculation. (Range: 0-1)
    float edgeFlutter,          // The amount of edge flutter for tree leaves. (Range: 0-1)
    float speed,                // The wind speed.
    float3 worldNormal,         // The direction of the turbulence in world space (usually vertex normal).
    out float3 combinedWind )    
{
    #define parameters objectPivot, vertexWorldPosition, vertexColor, windDirection
    #define parameters_ambient objectPivot, vertexWorldPosition, windDirection, phaseOffset
    #define parameters_gust parameters, phaseOffset, edgeFlutter, 0
    #define parameters_turbulence parameters, worldNormal, phaseOffset, edgeFlutter
    
    float ambientStrength =  GetWindStrength();
    float turbulenceStrength = GetTurbulenceStrength();
    phaseOffset *= dot( windDirection, (vertexWorldPosition - objectPivot) );

    CombineWind_float( 
        AmbientWind( parameters_ambient ), 
        SampleGust( parameters_gust ), 
        Turbulence( parameters_turbulence, 1 ), 
        Turbulence( parameters_turbulence, 2 ), 
        float4(ambientStrength.xx, turbulenceStrength.xx),
        combinedWind );

    #undef parameters
    #undef parameters_ambient
    #undef parameters_gust
    #undef parameters_turbulence
}

#endif