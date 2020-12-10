// Copyright 2020 Visual Design Cafe. All rights reserved.
// Package: Nature Shaders
// Website: https://www.visualdesigncafe.com/nature-shaders
// Documentation: https://support.visualdesigncafe.com/hc/categories/900000043503

#ifndef NODE_OBJECT_RADIUS_INCLUDED
#define NODE_OBJECT_RADIUS_INCLUDED

#define GRASS_DEFAULT_RADIUS 1.0
#define PLANT_DEFAULT_RADIUS 1.0
#define TREE_DEFAULT_RADIUS 6.0

/// <summary>
/// Returns the radius of the object.
/// Is used when no baked data is available.
/// </summary>
float GetObjectRadius()
{
    #ifdef PROPERTY_ObjectRadius
        return _ObjectRadius;
    #else
        #if defined(_TYPE_TREE_LEAVES) || defined(_TYPE_TREE_BARK)
            return TREE_DEFAULT_RADIUS;
        #elif defined(_TYPE_GRASS)
            return GRASS_DEFAULT_RADIUS;
        #else
            return PLANT_DEFAULT_RADIUS;
        #endif
    #endif
}

void GetObjectRadius_float( out float radius )
{
    radius = GetObjectRadius();
}

#endif