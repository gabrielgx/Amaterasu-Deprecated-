// Copyright 2020 Visual Design Cafe. All rights reserved.
// Package: Nature Shaders
// Website: https://www.visualdesigncafe.com/nature-shaders
// Documentation: https://support.visualdesigncafe.com/hc/categories/900000043503

#ifndef NODE_COMPUTE_TURBULENCE_INCLUDED
#define NODE_COMPUTE_TURBULENCE_INCLUDED

#include "../Common.cginc"
#include "../Input/Wind Properties.cginc"

/// <summary>
/// Calculates the turbulence.
/// </summary>
float3 Turbulence( 
    float3 objectPivot,         // The object pivot in world space.
    float3 vertexWorldPosition, // The vertex position in world space.
    float4 vertexColor,         // The vertex color
    float3 windDirection,       // The wind direction in world space (normalized).
    float3 worldNormal,         // The direction of the turbulence in world space (usually vertex normal).
    float phaseOffset,          // The wind phase offset.
    float edgeFlutter,          // The amount of edge flutter for tree leaves. (Range: 0-1)
    float speed )               // The wind speed.
{
    #if defined(_TYPE_TREE_BARK)
        return float3(0, 0, 0);
    #else
        float time = GetSmoothTurbulenceOffset() - phaseOffset;
        float frequency = (objectPivot.x + objectPivot.y + objectPivot.z) * 2.5 - time;

        // TODO: Add a secondary frequency.
        float4 sine = 
            FastSin( 
                float4(
                    (1.65 * frequency) * speed, 
                    (2 * 1.65 * frequency) * speed, 
                    0,
                    0) );

        float x = 1 * sine.x + 1;
        float z = 1 * sine.y + 1;
        float y = (x + z) * 0.5;

        #if defined(_TYPE_TREE_LEAVES)
            return worldNormal * float3(x, y, z) * float3(1, 0.35, 1) * edgeFlutter;
        #else
            return worldNormal * float3(x, y, z) * float3(1, 0.35, 1);
        #endif
    #endif
}

/// <summary>
/// Calculates the turbulence.
/// </summary>
void Turbulence_float( 
    float3 objectPivot,         // The object pivot in world space.
    float3 vertexWorldPosition, // The vertex position in world space.
    float4 vertexColor,         // The vertex color
    float3 windDirection,       // The wind direction in world space (normalized).
    float3 worldNormal,         // The direction of the turbulence in world space (usually vertex normal).
    float phaseOffset,          // The wind phase offset.
    float edgeFlutter,          // The amount of edge flutter for tree leaves. (Range: 0-1)
    float speed,                // The wind speed.
    out float3 turbulence )
{
    turbulence = 
        Turbulence( 
            objectPivot, 
            vertexWorldPosition, 
            vertexColor, 
            windDirection, 
            worldNormal, 
            phaseOffset, 
            edgeFlutter, 
            speed );
}

#endif