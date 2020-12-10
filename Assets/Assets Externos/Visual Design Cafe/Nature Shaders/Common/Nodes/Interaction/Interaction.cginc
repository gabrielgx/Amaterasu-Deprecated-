// Copyright 2020 Visual Design Cafe. All rights reserved.
// Package: Nature Shaders
// Website: https://www.visualdesigncafe.com/nature-shaders
// Documentation: https://support.visualdesigncafe.com/hc/categories/900000043503

#ifndef NODE_INTERACTION_INCLUDED
#define NODE_INTERACTION_INCLUDED

#include "../Common.cginc"
#include "../../Nature Shaders.shadersettings"

float4 _InteractionZonePosition;
float4 _InteractionZoneSize;
sampler2D _InteractionData;
float _InteractionDataTexelSize;
float _InteractionConstantFade;

/*
float _InteractionDuration;
float _InteractionStrength;
float _InteractionPushDown;
*/

// TODO: Move this calculations so that we don't need to calculate the UV for each sample.
float2 InteractionDataUV( float3 vertexWorldPosition )
{
    float2 relativePosition = vertexWorldPosition.xz - _InteractionZonePosition.xz + _InteractionZoneSize.xz * 0.5;
    float2 normalizedPosition = relativePosition / _InteractionZoneSize.xz;
    return normalizedPosition;
}

float4 SampleInteractionData( float3 vertexWorldPosition, float2 offset )
{
    float2 uv = InteractionDataUV( vertexWorldPosition ) + offset;
    return tex2Dlod(_InteractionData, float4(uv.x, uv.y, 0, 0));
}

float4 SampleInteractionData( float3 vertexWorldPosition )
{
    return SampleInteractionData( vertexWorldPosition, float2(0,0));
}

float GetHeight( float color )
{
    float ground = _InteractionZonePosition.y - _InteractionZoneSize.y * 0.5;
    return ground + (1-color) * _InteractionZoneSize.y;
}

void SampleAverageInteractionData( float3 vertexWorldPosition, out float4 data, out float3 normal )
{
    #define SAMPLE_INTERACTION( uv ) \
    SampleInteractionData( vertexWorldPosition + _InteractionDataTexelSize * float3(uv.x, 0, uv.y) )

    float4 top    = SAMPLE_INTERACTION(float2( 0,-1));
    float4 left   = SAMPLE_INTERACTION(float2(-1, 0));
    float4 middle = SAMPLE_INTERACTION(float2( 0, 0));
    float4 right  = SAMPLE_INTERACTION(float2( 1, 0));
    float4 bottom = SAMPLE_INTERACTION(float2( 0, 1));

    #undef SAMPLE_INTERACTION

    data = (top + bottom + left + right + middle) * 0.2;

    float4 h;
    h[0] = GetHeight( top.g );
    h[1] = GetHeight( left.g );
    h[2] = GetHeight( right.g );
    h[3] = GetHeight( bottom.g );
    float3 n;
    n.z = h[3] - h[0];
    n.x = h[2] - h[1];
    n.y = 2;

    normal = normalize(n);
}

void Interact( 
    inout float4 vertex, 
    inout float3 vertexWorldPosition, 
    float3 objectPivot, 
    float mask,
    float phaseOffset,
    float interactionDuration,
    float interactionStrength,
    float interactionPushDown )
{
    float distanceFromEdge = 
        distance( vertexWorldPosition.xz, _InteractionZonePosition.xz );

    float range = _InteractionZoneSize.x * 0.1;
    float start = _InteractionZoneSize.x * 0.5 - range;
    distanceFromEdge = 1.0 - saturate( (distanceFromEdge - start) / range);

    float4 data;
    float3 normal;
    
    // Sample at either objectPivot or vertexWorldPosition.
    #ifdef _INTERACTION_ON_VERTEX
        SampleAverageInteractionData( vertexWorldPosition.xyz, data, normal );
    #else
        SampleAverageInteractionData( objectPivot.xyz, data, normal );
    #endif

    float fade = data.r - data.g;
    float life = 1 - saturate(fade / _InteractionConstantFade / (interactionDuration + (1-phaseOffset) * 2));

    float2 motion =  SafeNormalize( float3(normal.xz, 0) ).xy;
    float motionAmplitude = cos((1-life) * 20.0 ) * life * life;

    float heightDifference = max(vertexWorldPosition.y - GetHeight( data.g ), 0);
    float overlap = max(vertexWorldPosition.y - GetHeight( data.r ), 0);

    vertexWorldPosition = 
        FixStretching(
            vertexWorldPosition
                + float3(motion.x, 0, motion.y) 
                    * motionAmplitude 
                    * mask 
                    * interactionStrength 
                    * overlap
                    * distanceFromEdge
                - float3(0, heightDifference, 0)
                    * distanceFromEdge 
                    * interactionPushDown
                    * interactionStrength,
            vertexWorldPosition,
            objectPivot);

    // Limit the amount that the grass can be pushed down 
    // to prevent grass from going through the ground.
    // We don't want the grass to completely disappear.
    /* vertexWorldPosition.y = 
        max(
            vertexWorldPosition.y, 
            objectPivot.y + 0.05 * mask); */

    vertex.xyz = TransformWorldToObject( vertexWorldPosition );
}

void Interact_float(
    float4 vertex, 
    float3 vertexWorldPosition, 
    float3 objectPivot, 
    float mask, 
    float phaseOffset, 
    float interactionDuration,
    float interactionStrength,
    float interactionPushDown,
    out float4 vertexOut, 
    out float3 vertexWorldPositionOut )
{
    #ifdef INTERACTION_SUPPORTED
        #if defined(_TYPE_GRASS) || defined(_TYPE_PLANT)
            #if defined(_INTERACTION_ON) || defined(_INTERACTION_ON_VERTEX)
                Interact(
                    vertex,
                    vertexWorldPosition,
                    objectPivot,
                    mask,
                    phaseOffset,
                    interactionDuration,
                    interactionStrength,
                    interactionPushDown);
            #endif
        #endif
    #endif
    vertexOut = vertex;
    vertexWorldPositionOut = vertexWorldPosition;
}

#endif