// Copyright 2020 Visual Design Cafe. All rights reserved.
// Package: Nature Shaders
// Website: https://www.visualdesigncafe.com/nature-shaders
// Documentation: https://support.visualdesigncafe.com/hc/categories/900000043503

#ifndef NODE_COMPUTE_AMBIENT_WIND_INCLUDED
#define NODE_COMPUTE_AMBIENT_WIND_INCLUDED

#include "../Common.cginc"
#include "../Input/Wind Properties.cginc"

/// <summary>
/// Calculates the wind frequency for the ambient wind.
/// Returns a vector4 containing 4 different sine waves.
/// </summary>
float4 AmbientFrequency(
    float3 objectPivot,         // The object pivot in world space.
    float3 vertexWorldPosition, // The vertex position in world space.
    float3 windDirection,       // The wind direction in world space.
    float phaseOffset,          // The wind phase offset. (Range: 0-1)
    float speed )               // The wind speed.
{
    // Constant offset moving the noise texture slowly to the left to prevent
    // the same gust repeating at the same location.
    #ifdef PER_OBJECT_VALUES_CALCULATED
        float3 constantOffset = g_ConstantWindOffset * _Time.x * 0.5;
    #else
        float3 constantOffset = cross( windDirection.xyz, float3(0,1,0) ) * _Time.x * 0.5;
    #endif

    float footprint = 3;
    float time = GetSmoothAmbientOffset() - phaseOffset * footprint;

    #ifdef PER_OBJECT_VALUES_CALCULATED
        float pivotOffset = g_PivotOffset;
    #else
        float pivotOffset = length( float3(objectPivot.x, 0, objectPivot.z) );
    #endif

    float scale = 0.5;
    float frequency = pivotOffset * scale - time;
    return FastSin(
        float4(
            frequency + constantOffset.x, 
            frequency*0.5 + constantOffset.z, 
            frequency*0.25, 
            frequency*0.125) * speed );
}

/// <summary>
/// Calculates the ambient wind.
/// </summary>
float3 AmbientWind( 
    float3 objectPivot,         // The object pivot in world space.
    float3 vertexWorldPosition, // The vertex position in world space.
    float3 windDirection,       // The wind direction in world space.
    float phaseOffset )         // The wind phase offset. (Range: 0-1)
{
    float4 sine = AmbientFrequency( objectPivot, vertexWorldPosition, windDirection, phaseOffset, 1 );
    sine.w = abs(sine.w) + 0.5;
    float xz = 1.5 * sine.x * sine.z + sine.w + 1;
    float y  = 1 * sine.y * sine.z + sine.w;
    return windDirection * float3(xz, 0, xz) + float3(0, y, 0);
}

/// <summary>
/// Calculates the ambient wind.
/// </summary>
void AmbientWind_float( 
    float3 objectPivot,         // The object pivot in world space.
    float3 vertexWorldPosition, // The vertex position in object space.
    float3 windDirection,       // The wind direction in world space.
    float phaseOffset,          // The wind phase offset. (Range: 0-1)
    out float3 ambientWind )
{
    ambientWind = AmbientWind( objectPivot, vertexWorldPosition, windDirection, phaseOffset );
}

#endif