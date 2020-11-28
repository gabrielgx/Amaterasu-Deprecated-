// Copyright 2020 Visual Design Cafe. All rights reserved.
// Package: Nature Shaders
// Website: https://www.visualdesigncafe.com/nature-shaders
// Documentation: https://support.visualdesigncafe.com/hc/categories/900000043503

#ifndef NODE_COMBINE_WIND_INCLUDED
#define NODE_COMBINE_WIND_INCLUDED

#include "../Common.cginc"
#include "../Input/Wind Properties.cginc"

void CombineWind_float(
    float3 ambient,     // Large constant ambient wind motion.
    float3 gust,        // Local gust based on noise texture.
    float3 turbulence,  // Constant turbulence.
    float3 shiver,      // High frequency shivering during gust.
    float4 strength,    // The wind strength for each wind component.
    out float3 combinedWind )
{
    ambient *= strength.x;
    gust *= strength.y;
    turbulence *= strength.z;
    shiver *= strength.w;

    // Trees require more displacement for the wind to be visible because the objects are larger.
    // These are magic numbers that give a nice balance between the grass/plants and trees,
    // based on a common tree size.
    #if defined(_TYPE_TREE_LEAVES) || defined(_TYPE_TREE_BARK)
        ambient *= 3;
        gust *= 1;
        turbulence *= 3;
        shiver *= 3;
    #endif

    float gustLength = length( gust );
    float increaseTurbelenceWithGust = smoothstep(0, 1, gustLength) * 1 + 1;

    // Calculate the balance between different wind types. 
    // If we do it here then we can keep the input parameters in a 0-1 range.
    ambient *= 0.1;
    gust *= 1.5;
    turbulence *= 0.15;
    shiver *= 0.15;

    #if defined(_DEBUG_AMBIENT)
        combinedWind = ambient;
    #elif defined(_DEBUG_GUST)
        combinedWind = gust;
    #elif defined(_DEBUG_TURBULENCE)
        combinedWind = 
            lerp(
                turbulence * increaseTurbelenceWithGust,
                shiver * increaseTurbelenceWithGust,
                gustLength);
    #else
        combinedWind = 
            ambient
                + gust
                + lerp(
                    turbulence * increaseTurbelenceWithGust,
                    shiver * increaseTurbelenceWithGust,
                    gustLength);
    #endif
}

#endif