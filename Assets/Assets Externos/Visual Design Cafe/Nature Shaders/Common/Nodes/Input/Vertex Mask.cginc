// Copyright 2020 Visual Design Cafe. All rights reserved.
// Package: Nature Shaders
// Website: https://www.visualdesigncafe.com/nature-shaders
// Documentation: https://support.visualdesigncafe.com/hc/categories/900000043503

#ifndef NODE_VERTEX_MASK_INCLUDED
#define NODE_VERTEX_MASK_INCLUDED

#include "Wind Properties.cginc"

/// <summary>
/// Returns the mask for the vertex.
/// Uses the red channel of the vertex color.
/// </summary>
float GetVertexMask( 
    float4 vertexColor ) // The vertex color.
{
    #if defined(_TYPE_TREE_LEAVES) || defined(_TYPE_TREE_BARK)
        return 1.0;
    #else
        #ifdef _WIND_CONTROL_BAKED
            return vertexColor.r;
        #else
            return 1.0;
        #endif
    #endif
}

void GetVertexMask_float( 
    float4 vertexColor, // The vertex color.
    out float mask )
{
    mask = GetVertexMask( vertexColor );
}

#endif