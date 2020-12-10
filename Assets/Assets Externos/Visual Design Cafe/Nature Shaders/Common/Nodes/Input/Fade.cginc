// Copyright 2020 Visual Design Cafe. All rights reserved.
// Package: Nature Shaders
// Website: https://www.visualdesigncafe.com/nature-shaders
// Documentation: https://support.visualdesigncafe.com/hc/categories/900000043503

#ifndef NODE_FADE_INCLUDED
#define NODE_FADE_INCLUDED

#include "Wind Properties.cginc"

void GetFade(
    float3 objectPivot, // The object pivot in world space.
    out float windFade, 
    out float scaleFade )
{
    #if defined(_TYPE_TREE_LEAVES) || defined(_TYPE_TREE_BARK)
        windFade = 1.0;
        scaleFade = 1.0;
    #else
        float distanceToCamera = length( objectPivot - _WorldSpaceCameraPos );
        #ifdef PROPERTY_WindFade
            windFade = 1.0 - saturate( (distanceToCamera - _WindFade.x) / _WindFade.y );
        #else
            windFade = 1.0;
        #endif
        #ifdef PROPERTY_ScaleFade
            scaleFade = 1.0 - saturate( (distanceToCamera - _ScaleFade.x) / _ScaleFade.y  );
        #else
            scaleFade = 1.0;
        #endif
    #endif
}

/// <summary>
/// Calculates a normalized fade value for wind distance fade and scale distance fade.
/// </summary>
void GetFade_float( 
    float3 objectPivot, // The object pivot in world space.
    out float windFade, 
    out float scaleFade )
{
    #ifdef PER_OBJECT_VALUES_CALCULATED
        windFade = g_WindFade;
        scaleFade = g_ScaleFade;
    #else
        GetFade(objectPivot, windFade, scaleFade);
    #endif
}

void ApplyScaleFade_OS_float( float3 vertex, float fade, out float3 vertexOut )
{
    #if !defined(_TYPE_TREE_LEAVES) && !defined(_TYPE_TREE_BARK)
        vertexOut = vertex;
        vertexOut.y *= saturate(fade + 0.2) / (fade > 0 ? 1.0 : 0.0);
    #else
        vertexOut = vertex;
    #endif
}

void ApplyScaleFade_float( float3 vertexWorldPosition, float3 objectPivot, float fade, out float3 vertexOut )
{
    #if !defined(_TYPE_TREE_LEAVES) && !defined(_TYPE_TREE_BARK)
        vertexOut = vertexWorldPosition;
        vertexOut.y = 
            objectPivot.y + (vertexWorldPosition.y - objectPivot.y) * saturate(fade + 0.2) / (fade > 0 ? 1.0 : 0.0);
    #else
        vertexOut = vertexWorldPosition;
    #endif
}

#endif