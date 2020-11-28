using UnityEngine;

namespace MenteBacata.ScivoloCharacterController.Internal
{
    /// <summary>
    /// Check if given capsule is overlapping other colliders taking into account a small overlap margin.
    /// Returns true if any collider overlaps the capsule.
    /// </summary>
    public static class OverlapChecker
    {
        private const float overlapMargin = 0.001f;

        public static bool CheckCapsuleOverlap(in Vector3 lowerCenter, in Vector3 upperCenter, float radius, LayerMask collisionMask)
        {
            return Physics.CheckCapsule(lowerCenter, upperCenter, radius + overlapMargin, collisionMask, QueryTriggerInteraction.Ignore);
        }
    }
}
