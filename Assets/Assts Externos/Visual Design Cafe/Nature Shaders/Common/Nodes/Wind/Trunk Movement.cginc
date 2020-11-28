// Copyright 2020 Visual Design Cafe. All rights reserved.
// Package: Nature Shaders
// Website: https://www.visualdesigncafe.com/nature-shaders
// Documentation: https://support.visualdesigncafe.com/hc/categories/900000043503

#ifndef NODE_TRUNK_MOVEMENT_INCLUDED
#define NODE_TRUNK_MOVEMENT_INCLUDED

#include "../Common.cginc"
#include "../Input/Wind Properties.cginc"
#include "../Input/Wind Strength.cginc"
#include "../Input/Object Height.cginc"
#include "Compute Ambient Wind.cginc"
#include "Compute Gust.cginc"

float GetTrunkMask( 
    float3 vertex, float2 uv1, float treeHeight, float bendFactor, float baseBendFactor )
{
    #ifdef _WIND_CONTROL_BAKED
        float trunkMask = saturate( uv1.x * bendFactor );
    #else
        float trunkMask = pow(saturate( vertex.y / treeHeight ), 2) * bendFactor;
    #endif

    return saturate( trunkMask + saturate( vertex.y ) * baseBendFactor );
}

/// <summary>
/// Rotates the entire object based on the trunk wind movement. (Trees only)
/// </summary>
void TrunkMovement_float( 
    float3 vertex,              // The vertex position in object space.
    float3 vertexWorldPosition, // The vertex position in world space.
    float3 vertexWithWind,      // The vertex position with wind displacement in world space.
    float2 uv1,                 // The second UV channel of the vertex. (UV1)
    float3 objectPivot,         // The object pivot in world space.
    float3 windDirection,       // The wind direction in world space. (normalized)
    out float3 vertexOut )
{
    // Additional properties. Either global or baked.
    float2 bendFactor = GetTrunkBendFactor();
    float trunkMask = GetTrunkMask( vertex, uv1, GetObjectHeight(), bendFactor.x,  bendFactor.y );
    float ambientStrength =  GetWindStrength();
    
    // Calculate Ambient Wind
    float4 trunkAmbient = 
        AmbientFrequency( objectPivot, vertexWorldPosition, windDirection, 0, 0.75 ) + ambientStrength;
    trunkAmbient *= trunkMask;

    // Calculate Gust
    float3 trunkGust = SampleGust( objectPivot, vertexWorldPosition, float4(1,0,1,1), windDirection, 0, 0, 7);
    trunkGust *= trunkMask;

    // Apply
    float gustFrequency = trunkAmbient.w * length(trunkGust);
    float baseFrequency1 = trunkAmbient.x;
    float baseFrequency2 = trunkAmbient.x + trunkAmbient.y;
    float baseFrequency = 
        lerp( baseFrequency1, baseFrequency2, (_SinTime.x + 1) * 0.5 * ambientStrength);
    
    vertexOut =
        RotateAroundAxis( 
            objectPivot, 
            vertexWithWind, 
            normalize( cross( float3(0,1,0) , windDirection ) ), 
            (baseFrequency * 0.75 + gustFrequency) * ambientStrength * 0.0375);
}
#endif