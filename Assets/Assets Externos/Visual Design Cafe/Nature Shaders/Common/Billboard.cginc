// Copyright 2020 Visual Design Cafe. All rights reserved.
// Package: Nature Shaders
// Website: https://www.visualdesigncafe.com/nature-shaders
// Documentation: https://support.visualdesigncafe.com/hc/categories/900000043503

#ifndef NODE_BILLBOARD_INCLUDED
#define NODE_BILLBOARD_INCLUDED

#include "Nodes/Input/Object Pivot.cginc"

CBUFFER_START(UnityBillboardPerCamera)
    float3 unity_BillboardNormal;
    float3 unity_BillboardTangent;
    float4 unity_BillboardCameraParams;
    #define unity_BillboardCameraPosition (unity_BillboardCameraParams.xyz)
    #define unity_BillboardCameraXZAngle (unity_BillboardCameraParams.w)
CBUFFER_END

CBUFFER_START(UnityBillboardPerBatch)
    float4 unity_BillboardInfo; // x: num of billboard slices; y: 1.0f / (delta angle between slices)
    float4 unity_BillboardSize; // x: width; y: height; z: bottom
    float4 unity_BillboardImageTexCoords[16];
CBUFFER_END

void BillboardVert(
    inout float4 vertex, 
    out float3 normal, 
    out float4 tangent, 
    inout float4 uv0, 
    inout float4 uv1)
{
    // assume no scaling & rotation
    float3 worldPos = vertex.xyz + GetObjectPivot();

    float3 billboardTangent = unity_BillboardTangent;
    float3 billboardNormal = unity_BillboardNormal;
    float angle = unity_BillboardCameraXZAngle;

    float widthScale = uv1.x;
    float heightScale = uv1.y;
    float rotation = uv1.z;

    float2 percent = uv0.xy;
    float3 billboardPos = (percent.x - 0.5f) * unity_BillboardSize.x * widthScale * billboardTangent;
    billboardPos.y += (percent.y * unity_BillboardSize.y + unity_BillboardSize.z) * heightScale;

    vertex.xyz += billboardPos;
    vertex.w = 1.0f;
    normal = billboardNormal.xyz;

    tangent = float4(billboardTangent.xyz,-1);

    float slices = unity_BillboardInfo.x;
    float invDelta = unity_BillboardInfo.y;
    angle += rotation;

    float imageIndex = fmod(floor(angle * invDelta + 0.5f), slices);
    float4 imageTexCoords = unity_BillboardImageTexCoords[imageIndex];
    if (imageTexCoords.w < 0)
    {
        uv0.xy = imageTexCoords.xy - imageTexCoords.zw * percent.yx;
    }
    else
    {
        uv0.xy = imageTexCoords.xy + imageTexCoords.zw * percent;
    }
}

void Billboard_float( 
    float4 vertex, 
    float4 uv0, 
    float4 uv1, 
    out float4 vertexOut, 
    out float3 normalOut, 
    out float4 tangentOut, 
    out float4 uv0Out, 
    out float4 uv1Out )
{
    BillboardVert(vertex, normalOut, tangentOut, uv0, uv1);
    vertexOut = vertex;
    uv0Out = uv0;
    uv1Out = uv1;
}
#endif