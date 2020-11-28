// Copyright 2020 Visual Design Cafe. All rights reserved.
// Package: Nature Shaders
// Website: https://www.visualdesigncafe.com/nature-shaders
// Documentation: https://support.visualdesigncafe.com/hc/categories/900000043503

#ifndef NODE_WIND_DIRECTION_INCLUDED
#define NODE_WIND_DIRECTION_INCLUDED

#include "Wind Properties.cginc"

/// <summary>
/// Returns the global wind direction.
/// </summary>
float3 GetWindDirection()
{
    return normalize(float3(g_WindDirection.x, 0, g_WindDirection.z));
}

void GetWindDirection_float( out float3 windDirection )
{
    windDirection = GetWindDirection();
}

#endif