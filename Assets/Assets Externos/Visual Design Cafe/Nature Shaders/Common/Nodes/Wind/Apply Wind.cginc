// Copyright 2020 Visual Design Cafe. All rights reserved.
// Package: Nature Shaders
// Website: https://www.visualdesigncafe.com/nature-shaders
// Documentation: https://support.visualdesigncafe.com/hc/categories/900000043503

#ifndef NODE_APPLY_WIND_INCLUDED
#define NODE_APPLY_WIND_INCLUDED

#include "../Common.cginc"

/// <summary>
/// Applies the wind to the vertex (object space).
/// </summary>
void ApplyWind_float(
    float3 vertexWorldPosition, // Vertex position in world space.
    float3 objectPivot,         // Object Pivot in world space.
    float3 combinedWind,        // Combined Wind vector in world space.
    float mask,                 // Wind mask. (Range: 0-1)
    float distanceFade,         // Wind distance fade. (Range: 0-1)
    out float3 vertexOut )
{
    // Convert vertex to world space.
    //float3 vertexWorldPosition = GetAbsolutePositionWS( TransformObjectToWorld( vertex ) );

    #if defined(_TYPE_GRASS)
        vertexOut = 
            FixStretching( 
                vertexWorldPosition + combinedWind * mask * distanceFade, 
                vertexWorldPosition, 
                float3( vertexWorldPosition.x, objectPivot.y, vertexWorldPosition.z ) );
    #elif defined(_TYPE_TREE_LEAVES) || defined(_TYPE_TREE_BARK)
        vertexOut =
            FixStretching( 
                vertexWorldPosition + combinedWind * mask * distanceFade * 4, 
                vertexWorldPosition, 
                objectPivot);
    #else
    //#elif defined(_TYPE_PLANT)
        vertexOut = 
            FixStretching( 
                vertexWorldPosition + combinedWind * mask * mask * distanceFade, 
                vertexWorldPosition, 
                objectPivot);
    //#else
    //    #error Invalid Vegetation Type. See 'Shader Errors' section in Help/Nature Shaders/Documentation.
    #endif

    // Convert vertex back to object space.
    //vertexOut = TransformWorldToObject( GetCameraRelativePositionWS( vertexOut ) );
}
#endif