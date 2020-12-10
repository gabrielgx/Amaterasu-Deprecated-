// Copyright 2020 Visual Design Cafe. All rights reserved.
// Package: Nature Shaders
// Website: https://www.visualdesigncafe.com/nature-shaders
// Documentation: https://support.visualdesigncafe.com/hc/categories/900000043503

#ifndef NODE_PHASE_OFFSET_INCLUDED
#define NODE_PHASE_OFFSET_INCLUDED

#include "Wind Properties.cginc"

/// <summary>
/// Calculates the phase offset for the branch, based on the baked data.
/// If no baked data is available, it will calculate an approximation of the branch.
/// Should only be called for trees.
/// </summary>
float GetBranchPhaseOffset( 
    float4 vertexColor,         // The vertex color.
    float2 texcoord0,           // The first UV channel.
    float3 vertexWorldPosition, // The vertex position in world space.
    float3 objectPivot )        // The object pivot in world space.
{
    float3 offset = vertexWorldPosition - objectPivot;
    float randomOffset = ( offset.x + offset.y + offset.z ) * 0.005;

    #if defined(_WIND_CONTROL_BAKED)
        float edgeFlutter = saturate( (vertexColor.g - 0.5) * 2);
        return vertexColor.r;
    #else
        #if defined(_TYPE_TREE_BARK)
            return 0;
        #else
            return randomOffset;
        #endif
    #endif
}

/// <summary>
/// Returns the phase offset for the vertex.
/// </summary>
float GetPhaseOffset( 
    float4 vertexColor,         // The vertex color.
    float2 uv0,                 // The first UV channel.
    float3 vertexWorldPosition, // The vertex position in world space.
    float3 objectPivot )        // The object pivot in world space.
{
    #if defined(_TYPE_TREE_LEAVES) || defined(_TYPE_TREE_BARK)
        return GetBranchPhaseOffset( vertexColor, uv0, vertexWorldPosition, objectPivot );
    #else
        #ifdef _WIND_CONTROL_BAKED
            return ( 1.0 - vertexColor.g );
        #else
            return 0;
        #endif
    #endif
}

void GetPhaseOffset_float( 
    float4 vertexColor,         // The vertex color.
    float2 uv0,                 // The first UV channel.
    float3 vertexWorldPosition, // The vertex position in world space.
    float3 pivot,               // The object pivot in world space.
    out float phaseOffset )
{
    phaseOffset = GetPhaseOffset( vertexColor, uv0, vertexWorldPosition, pivot );
}

#endif