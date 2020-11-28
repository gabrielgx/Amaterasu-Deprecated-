// Animancer // https://kybernetik.com.au/animancer // Copyright 2020 Kybernetik //

using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Animations;
using UnityEngine.Playables;

namespace Animancer
{
    /// <summary>Plays a single <see cref="AnimationClip"/> on startup.</summary>
    /// <remarks>
    /// Documentation: <see href="https://kybernetik.com.au/animancer/docs/manual/playing/component-types">Component Types</see>
    /// </remarks>
    /// <example>
    /// <see href="https://kybernetik.com.au/animancer/docs/examples/fine-control/solo-animation">Solo Animation</see>
    /// </example>
    /// https://kybernetik.com.au/animancer/api/Animancer/SoloAnimation
    /// 
    [AddComponentMenu(Strings.MenuPrefix + "Solo Animation")]
    [DefaultExecutionOrder(-5000)]// Initialise before anything else tries to use this component.
    [HelpURL(Strings.DocsURLs.APIDocumentation + "/" + nameof(SoloAnimation))]
    public sealed class SoloAnimation : SoloAnimationInternal { }
}
