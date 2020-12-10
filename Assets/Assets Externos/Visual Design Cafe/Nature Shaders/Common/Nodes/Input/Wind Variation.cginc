// Copyright 2020 Visual Design Cafe. All rights reserved.
// Package: Nature Shaders
// Website: https://www.visualdesigncafe.com/nature-shaders
// Documentation: https://support.visualdesigncafe.com/hc/categories/900000043503

#ifndef NODE_WIND_VARIATION_INCLUDED
#define NODE_WIND_VARIATION_INCLUDED

#include "Wind Properties.cginc"


/// <summary>
/// Returns a random windVariation value based on the object pivot.
/// </summary>
float GetWindVariation( 
    float3 objectPivot ) // The object pivot in world space.
{
    #ifdef PROPERTY_WindVariation
        float variation = _WindVariation;
    #else
        float variation = 0.3;
    #endif
    return 1.0 - frac( objectPivot.x * objectPivot.z * 10.0 ) * variation;
}

void GetWindVariation_float( float3 objectPivot, out float windVariation )
{
    windVariation = GetWindVariation( objectPivot );
}

#endif