// Copyright 2020 Visual Design Cafe. All rights reserved.
// Package: Nature Shaders
// Website: https://www.visualdesigncafe.com/nature-shaders
// Documentation: https://support.visualdesigncafe.com/hc/categories/900000043503

#ifndef NODE_HEIGHT_MASK_INCLUDED
#define NODE_HEIGHT_MASK_INCLUDED

#include "Wind Properties.cginc"
#include "Object Height.cginc"
#include "Object Radius.cginc"

float MaskFromHeightAndRadius( float3 vertex, float height, float radius )
{
    return pow( saturate( max(vertex.y / height, length(vertex.xz) / radius) ), 2);
}

/// <summary>
/// Returns a mask based on the relative height of the vertex.
/// </summary>
float GetHeightMask( 
    float3 vertex,      // The vertex position in object space.
    float4 vertexColor, // The vertex color.
    float2 uv0,         // The first UV channel.
    float2 uv1 )        // The second UV channel.
{
    #if defined(_WIND_CONTROL_BAKED)
        #if defined(_TYPE_TREE_LEAVES) || defined(_TYPE_TREE_BARK)
            return uv1.y;
        #else
            return vertexColor.a;
        #endif
    #else
        #if defined(_TYPE_GRASS)
            return saturate( vertex.y / GetObjectHeight() );
        #else
            return MaskFromHeightAndRadius( vertex, GetObjectHeight(), GetObjectRadius() );
        #endif
    #endif
}

void GetHeightMask_float( 
    float3 vertex,      // The vertex position in object space.
    float4 vertexColor, // The vertex color.
    float2 uv0,         // The first UV channel.
    float2 uv1,         // The second UV channel.
    out float mask )
{
    mask = GetHeightMask( vertex, vertexColor, uv0, uv1 );
}

#endif