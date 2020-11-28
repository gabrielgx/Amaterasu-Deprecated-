// Copyright 2020 Visual Design Cafe. All rights reserved.
// Package: Nature Shaders
// Website: https://www.visualdesigncafe.com/nature-shaders
// Documentation: https://support.visualdesigncafe.com/hc/categories/900000043503

#ifndef COMMON_FUNCTIONS_INCLUDED
#define COMMON_FUNCTIONS_INCLUDED

#ifdef STANDARD_RENDER_PIPELINE
    #define FLT_MIN  1.175494351e-38 // Minimum normalized positive floating-point number
    
    // Normalize that account for vectors with zero length
    float3 SafeNormalize(float3 inVec)
    {
        float dp3 = max(FLT_MIN, dot(inVec, inVec));
        return inVec * rsqrt(dp3);
    }

    float3 TransformObjectToWorld(float3 positionOS)
    {
        return mul(unity_ObjectToWorld, float4(positionOS, 1.0)).xyz;
    }

    float3 TransformWorldToObject(float3 positionWS)
    {
        return mul(unity_WorldToObject, float4(positionWS, 1.0)).xyz;
    }

    float3 GetAbsolutePositionWS(float3 positionRWS)
    {
        return positionRWS;
    }

    float3 GetCameraRelativePositionWS(float3 positionWS)
    {
        return positionWS;
    }

    float3 TransformObjectToWorldDir(float3 dirOS)
    {
        // Normalize to support uniform scaling
        return SafeNormalize( mul(unity_ObjectToWorld, float4(dirOS, 0.0)).xyz );
    }

    float3 TransformWorldToObjectDir(float3 dirWS)
    {
        // Normalize to support uniform scaling
        return normalize( mul(unity_WorldToObject, float4(dirWS, 0.0)).xyz );
    }
#endif

float Remap( float value, float2 remap )
{
    return remap.x + value * (remap.y - remap.x);
}

float4 SmoothCurve( float4 x ) 
{   
    return x * x *( 3.0 - 2.0 * x ); 
} 
float4 TriangleWave( float4 x ) 
{
    return abs( frac( x + 0.5 ) * 2.0 - 1.0 ); 
}
float4 SmoothTriangleWave( float4 x ) 
{   
    return SmoothCurve( TriangleWave( x ) ); 
}

float4 FastSin( float4 x )
{
    #ifdef _WIND_QUALITY_HIGH
        return sin(x);
    #else
        #ifndef PI
            #define PI 3.14159265
        #endif
        #define DIVIDE_BY_PI 1.0 / (2.0 * PI)
        return (SmoothTriangleWave( x * DIVIDE_BY_PI ) - 0.5) * 2;
    #endif
}

float3 FixStretching( float3 vertex, float3 original, float3 center )
{
    return center + SafeNormalize(vertex - center) * length(original - center);
}

float3 RotateAroundAxis( float3 center, float3 original, float3 u, float angle )
{
    original -= center;
    float C = cos( angle );
    float S = sin( angle );
    float t = 1 - C;
    float m00 = t * u.x * u.x + C;
    float m01 = t * u.x * u.y - S * u.z;
    float m02 = t * u.x * u.z + S * u.y;
    float m10 = t * u.x * u.y + S * u.z;
    float m11 = t * u.y * u.y + C;
    float m12 = t * u.y * u.z - S * u.x;
    float m20 = t * u.x * u.z - S * u.y;
    float m21 = t * u.y * u.z + S * u.x;
    float m22 = t * u.z * u.z + C;
    float3x3 finalMatrix = float3x3( m00, m01, m02, m10, m11, m12, m20, m21, m22 );
    return mul( finalMatrix, original ) + center;
}

float3 RotateAroundAxisFast( float3 center, float3 original, float3 direction )
{
    return original + direction;
}
#endif