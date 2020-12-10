// Copyright 2020 Visual Design Cafe. All rights reserved.
// Package: Nature Shaders
// Website: https://www.visualdesigncafe.com/nature-shaders
// Documentation: https://support.visualdesigncafe.com/hc/categories/900000043503

#ifndef NODE_WIND_SPEED_INCLUDED
#define NODE_WIND_SPEED_INCLUDED

#include "Wind Properties.cginc"

/// <summary>
/// Returns the global wind speed.
/// </summary>
float GetWindSpeed()
{
    return g_Wind.x;
}

void GetWindSpeed_float( out float windSpeed )
{
    windSpeed = GetWindSpeed();
}

#endif