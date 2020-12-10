// Copyright 2020 Visual Design Cafe. All rights reserved.
// Package: Nature Shaders
// Website: https://www.visualdesigncafe.com/nature-shaders
// Documentation: https://support.visualdesigncafe.com/hc/categories/900000043503

#ifndef NODE_PERLIN_NOISE_INCLUDED
#define NODE_PERLIN_NOISE_INCLUDED

uniform sampler2D g_PerlinNoise;
uniform float g_PerlinNoiseScale;

void PerlinNoise( float2 uv, float scale, out float noise )
{
    noise = 
        tex2Dlod(
            g_PerlinNoise, 
            float4(uv.xy, 0, 0) * scale * g_PerlinNoiseScale).r;
}

void PerlinNoise_float( float2 uv, float scale, out float noise )
{
    #ifdef PER_OBJECT_VALUES_CALCULATED
        noise = g_WorldNoise;
    #else
        PerlinNoise( uv, scale, noise );
    #endif
}

#endif