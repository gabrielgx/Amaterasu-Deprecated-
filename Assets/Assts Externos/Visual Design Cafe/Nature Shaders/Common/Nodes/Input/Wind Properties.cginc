// Copyright 2020 Visual Design Cafe. All rights reserved.
// Package: Nature Shaders
// Website: https://www.visualdesigncafe.com/nature-shaders
// Documentation: https://support.visualdesigncafe.com/hc/categories/900000043503

#ifndef WIND_PROPERTIES_INCLUDED
#define WIND_PROPERTIES_INCLUDED

#include "../Common.cginc"

#define GRASS_DEFAULT_HEIGHT 0.5
#define PLANT_DEFAULT_HEIGHT 1.0
#define TRUNK_DEFAULT_HEIGHT 20.0
#define TRUNK_BASE_BEND_FACTOR 0.3
#define TRUNK_BEND_MULTIPLIER 2.0

uniform float4 g_SmoothTime;
uniform float3 g_WindDirection;
uniform float2 g_Wind;
uniform float2 g_Turbulence;
uniform sampler2D g_GustNoise;

/// <summary>
/// Returns the bend factor for the tree trunk.
/// X contains the bend factor for the entire tree, Y for the base.
/// </summary>
float2 GetTrunkBendFactor()
{
    #ifdef PROPERTY_TrunkBendFactor
        return _TrunkBendFactor;
    #else
        return float2(TRUNK_BEND_MULTIPLIER, TRUNK_BASE_BEND_FACTOR);
    #endif
}

/// <summary>
/// Returns the time for ambient wind.
/// Smoothly adjusted for changes in wind speed.
/// </summary>
float GetSmoothAmbientOffset()
{
    return g_SmoothTime.x;
}

/// <summary>
/// Returns the time for gusts.
/// Smoothly adjusted for changes in wind speed.
/// </summary>
float GetSmoothGustOffset()
{
    return g_SmoothTime.y;
}

/// <summary>
/// Returns the time for turbulence.
/// Smoothly adjusted for changes in wind speed.
/// </summary>
float GetSmoothTurbulenceOffset()
{
    return g_SmoothTime.z;
}

#endif