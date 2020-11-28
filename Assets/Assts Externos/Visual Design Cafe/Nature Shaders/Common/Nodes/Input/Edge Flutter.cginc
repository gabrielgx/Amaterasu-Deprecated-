// Copyright 2020 Visual Design Cafe. All rights reserved.
// Package: Nature Shaders
// Website: https://www.visualdesigncafe.com/nature-shaders
// Documentation: https://support.visualdesigncafe.com/hc/categories/900000043503

#ifndef NODE_EDGE_FLUTTER_INCLUDED
#define NODE_EDGE_FLUTTER_INCLUDED

#include "Wind Properties.cginc"

/// <summary>
/// Returns the edge flutter for the vertex, 
/// based either the vertex colors or UV (depending on the Wind Control settings).
/// </summary>
float GetEdgeFlutter( 
    float4 vertexColor, // The vertex color.
    float2 uv0 )        // The first UV channel. (UV0)
{
    #if defined(_TYPE_TREE_BARK)
        return 0;
    #else
        #if defined(_WIND_CONTROL_BAKED) && defined(_TYPE_TREE_LEAVES)
            return vertexColor.g;
        #else
            return 1;
        #endif
    #endif
}

void GetEdgeFlutter_float( float4 vertexColor, float2 uv0, out float edgeFlutter )
{
    edgeFlutter = GetEdgeFlutter( vertexColor, uv0 );
}

#endif