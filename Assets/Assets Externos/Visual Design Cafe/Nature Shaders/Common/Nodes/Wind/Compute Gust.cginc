// Copyright 2020 Visual Design Cafe. All rights reserved.
// Package: Nature Shaders
// Website: https://www.visualdesigncafe.com/nature-shaders
// Documentation: https://support.visualdesigncafe.com/hc/categories/900000043503

#ifndef NODE_COMPUTE_GUST_INCLUDED
#define NODE_COMPUTE_GUST_INCLUDED

#include "../Common.cginc"
#include "../Input/Wind Properties.cginc"

float3 SampleGust(
    float3 objectPivot, 
    float3 vertexWorldPosition,
    float4 vertexColor,
    float3 windDirection,
    float phaseOffset, 
    float edgeFlutter,
    float lod )
{
    #if defined(_TYPE_TREE_LEAVES) || defined(_TYPE_TREE_BARK)
        float time = GetSmoothGustOffset() - phaseOffset * 0.05;
        lod = 5;
    #else
        float time = GetSmoothGustOffset() - phaseOffset * 0.05;
    #endif

    // Constant offset moving the noise texture slowly to the left to prevent
    // the same gust repeating at the same location.
    #ifdef PER_OBJECT_VALUES_CALCULATED
        float3 constantOffset = g_ConstantWindOffset * _Time.x * 0.5;
    #else
        float3 constantOffset = cross( windDirection.xyz, float3(0,1,0) ) * _Time.x * 0.5;
    #endif

    float2 windOffsetOverTime = windDirection.xz * time + constantOffset.xz;
    #if defined(_TYPE_TREE_LEAVES)
        float3 vertexOffset = vertexWorldPosition - objectPivot;
        float2 offset = objectPivot.xz * 0.02 - windOffsetOverTime + vertexOffset.xz * 0.0075 * edgeFlutter;
    #else
        float2 offset = objectPivot.xz * 0.02 - windOffsetOverTime;
    #endif
    float strength  = tex2Dlod( g_GustNoise, float4(offset, 0, lod) ).r;
    return strength * windDirection;
}

void SampleGust_float( 
    float3 objectPivot, 
    float3 vertexWorldPosition,
    float4 vertexColor,
    float3 windDirection,
    float phaseOffset, 
    float edgeFlutter,
    float lod,
    out float3 gust )
{
    gust = SampleGust( objectPivot, vertexWorldPosition, vertexColor, windDirection, phaseOffset, edgeFlutter, lod );
}

#endif