// Copyright 2020 Visual Design Cafe. All rights reserved.
// Package: Nature Shaders
// Website: https://www.visualdesigncafe.com/nature-shaders
// Documentation: https://support.visualdesigncafe.com/hc/categories/900000043503

#ifndef NODE_TURBULENCE_STRENGTH_INCLUDED
#define NODE_TURBULENCE_STRENGTH_INCLUDED

#include "Wind Properties.cginc"

/// <summary>
/// Returns the global turbulence strength.
/// </summary>
float GetTurbulenceStrength()
{
    #ifdef PROPERTY_TurbulenceStrength
        return g_Turbulence.y * _TurbulenceStrength;
    #else
        return g_Turbulence.y;
    #endif
}

void GetTurbulenceStrength_float( out float strength )
{
    strength = GetTurbulenceStrength();
}

#endif