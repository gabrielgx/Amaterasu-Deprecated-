// Copyright 2020 Visual Design Cafe. All rights reserved.
// Package: Nature Shaders
// Website: https://www.visualdesigncafe.com/nature-shaders
// Documentation: https://support.visualdesigncafe.com/hc/categories/900000043503

#ifndef NODE_WIND_STRENGTH_INCLUDED
#define NODE_WIND_STRENGTH_INCLUDED

#include "Wind Properties.cginc"

/// <summary>
/// Returns the global wind strength.
/// </summary>
float GetWindStrength()
{
    #ifdef PROPERTY_WindStrength
        return g_Wind.y * _WindStrength;
    #else
        return g_Wind.y;
    #endif
}

void GetWindStrength_float( out float strength )
{
    strength = GetWindStrength();
}

#endif