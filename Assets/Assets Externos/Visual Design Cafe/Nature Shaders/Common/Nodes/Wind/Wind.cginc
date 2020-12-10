// Copyright 2020 Visual Design Cafe. All rights reserved.
// Package: Nature Shaders
// Website: https://www.visualdesigncafe.com/nature-shaders
// Documentation: https://support.visualdesigncafe.com/hc/categories/900000043503

#ifndef NODE_WIND_INCLUDED
#define NODE_WIND_INCLUDED

#include "../Common.cginc"
#include "../Input/Wind Properties.cginc"
#include "../Input/Wind Direction.cginc"
#include "../Input/Object Pivot.cginc"
#include "../Input/Phase Offset.cginc"
#include "../Input/Wind Speed.cginc"
#include "../Input/Vertex Direction.cginc"
#include "../Input/Height Mask.cginc"
#include "../Input/Wind Variation.cginc"
#include "../Input/Vertex Mask.cginc"
#include "../Input/Edge Flutter.cginc"
#include "../Input/Fade.cginc"
#include "Compute Ambient Wind.cginc"
#include "Compute Gust.cginc"
#include "Compute Turbulence.cginc"
#include "Combine Wind.cginc"
#include "Compute Wind.cginc"
#include "Apply Wind.cginc"
#include "Trunk Movement.cginc"

/// <summary>
/// Calculates the wind for the vertex with the default values and applies it.
/// </summary>
void Wind_float(
    float4 vertex,              // The vertex position in model space.
    float3 vertexWorldPosition, // The vertex position in world space.
    float3 normal,              // The vertex normal in model space.
    float4 texcoord0,           // The first UV coordinate.
    float4 texcoord1,           // The second UV coordinate.
    float4 color,               // Per-vertex color
    out float3 vertexOut,
    out float3 normalOut )
{
    #ifdef _WIND_OFF
        vertexOut = vertexWorldPosition;
        #if defined(_TYPE_GRASS)
            normalOut = 
                normalize(
                    normal + TransformWorldToObjectDir( float3(0,.9,0) ) );
        #else
            normalOut = normal;
        #endif
    #else
        // Properties.
        float3 windDirection = GetWindDirection();
        float3 pivot = GetObjectPivot();

        #if !defined(_TYPE_TREE_BILLBOARD)

            // Distance fade.
            float windFade;
            float scaleFade;
            #ifdef PER_OBJECT_VALUES_CALCULATED
                windFade = g_WindFade;
                scaleFade = g_ScaleFade;
            #else
                GetFade_float( pivot, windFade, scaleFade );
            #endif

            float speed = GetWindSpeed();

            // Exit if the wind is not set, or fully faded out.
            if( windFade == 0 || speed == 0 )
            {
                vertexOut = vertexWorldPosition;
                normalOut = normal;
                return;
            }

            float phaseOffset = GetPhaseOffset( color, texcoord0.xy, vertexWorldPosition, pivot );
            float3 worldNormal = GetWorldNormal( normal, pivot );

            // Mask.
            float heightMask = GetHeightMask( vertex.xyz, color, texcoord0.xy, texcoord1.xy );
            float windVariation = GetWindVariation( pivot );
            float vertexMask = GetVertexMask( color );
            float mask = heightMask * vertexMask * windVariation;
            float edgeFlutter = GetEdgeFlutter( color, texcoord0.xy );

            // Compute wind.
            float3 wind;
            float3 samplePivot = pivot;
            #ifdef _TYPE_GRASS
                samplePivot = float3(vertexWorldPosition.x, pivot.y, vertexWorldPosition.z);
            #endif
            ComputeWind_float( windDirection, samplePivot, vertexWorldPosition.xyz, color, phaseOffset, edgeFlutter, speed, worldNormal, wind );

            // Apply wind to vertex.
            ApplyWind_float( vertexWorldPosition.xyz, pivot, wind, mask, windFade, vertexOut );
        #else
            vertexOut = vertexWorldPosition;
        #endif

        #if defined(_TYPE_GRASS)
            float3 delta = vertexOut - vertexWorldPosition;
            normalOut = 
                lerp(
                    normal, 
                    normal + SafeNormalize( TransformWorldToObjectDir(delta + float3(0, 0.1, 0)) ),
                    #ifdef PROPERTY_RecalculateWindNormals
                        length(delta) * _RecalculateWindNormals );
                    #else
                        length(delta) );
                    #endif
        #else
            normalOut = normal;
        #endif

        // Trunk Rotation
        #if defined(_TYPE_TREE_LEAVES) || defined( _TYPE_TREE_BARK ) || defined(_TYPE_TREE_BILLBOARD)
            TrunkMovement_float( 
                vertex.xyz, 
                vertexWorldPosition.xyz, 
                vertexOut, 
                texcoord1.xy, 
                pivot, 
                windDirection, 
                vertexOut );
        #endif
    #endif
}

#endif