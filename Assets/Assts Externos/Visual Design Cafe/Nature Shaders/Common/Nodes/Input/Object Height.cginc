// Copyright 2020 Visual Design Cafe. All rights reserved.
// Package: Nature Shaders
// Website: https://www.visualdesigncafe.com/nature-shaders
// Documentation: https://support.visualdesigncafe.com/hc/categories/900000043503

#ifndef NODE_OBJECT_HEIGHT_INCLUDED
#define NODE_OBJECT_HEIGHT_INCLUDED

#include "Wind Properties.cginc"

/// <summary>
/// Returns the height of the object.
/// Is used when no baked data is available.
/// </summary>
float GetObjectHeight()
{
    #ifdef PROPERTY_ObjectHeight
        return _ObjectHeight;
    #else
        #if defined(_TYPE_TREE_LEAVES) || defined(_TYPE_TREE_BARK)
            return TRUNK_DEFAULT_HEIGHT;
        #elif defined(_TYPE_GRASS)
            return GRASS_DEFAULT_HEIGHT;
        #else
            return PLANT_DEFAULT_HEIGHT;
        #endif
    #endif
}

void GetObjectHeight_float( out float height )
{
    height = GetObjectHeight();
}

#endif