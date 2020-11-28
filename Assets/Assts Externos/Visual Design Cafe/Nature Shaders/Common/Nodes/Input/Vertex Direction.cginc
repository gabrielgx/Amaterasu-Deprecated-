// Copyright 2020 Visual Design Cafe. All rights reserved.
// Package: Nature Shaders
// Website: https://www.visualdesigncafe.com/nature-shaders
// Documentation: https://support.visualdesigncafe.com/hc/categories/900000043503

#ifndef NODE_VERTEX_DIRECTION_INCLUDED
#define NODE_VERTEX_DIRECTION_INCLUDED

#include "Wind Properties.cginc"

/// <summary>
/// Returns the vertex normal in world space when vertex normals are anbled.
/// Otherwise, returns the object's forward (Z+) direction.
/// </summary>
float3 GetWorldNormal( 
    float3 vertexNormal, // The vertex normal in object space.
    float3 objectPivot ) // The object pivot in world space.
{
    #if defined(PER_OBJECT_VALUES_CALCULATED) && !defined(_TYPE_TREE_LEAVES)
        return g_WorldNormal;
    #else
        #ifdef _TYPE_TREE_LEAVES
            // Scramble the vertex normals in case they are projected onto spheres
            // or other geometry for smooth lighting. Otherwise the wind turbulence will end
            // up as weird expanding and shrinking spheres.
            // Define DO_NOT_SCRAMBLE_VERTEX_NORMALS in the shader if the tree models have
            // accurate normals.
            #ifndef DO_NOT_SCRAMBLE_VERTEX_NORMALS
                return TransformObjectToWorldDir( vertexNormal.xzy );
            #else
                return TransformObjectToWorldDir( vertexNormal.xyz );
            #endif
        #else
            return TransformObjectToWorldDir( float3(0, 0, 1) );
        #endif
    #endif
}

void GetWorldNormal_float( 
    float3 vertexNormal, // The vertex normal in object space.
    float3 objectPivot,  // The object pivot in world space.
    out float3 worldNormal )
{
    worldNormal = GetWorldNormal( vertexNormal, objectPivot );
}

#endif