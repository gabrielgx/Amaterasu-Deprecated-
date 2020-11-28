//#define MB_DEBUG

using UnityEngine;

namespace MenteBacata.ScivoloCharacterController.Internal
{
    public static class FloorAbovePointChecker
    {
        private const float probeRadiusFactor = 0.5f;

        private const float verticalOffsetFactor = 0.6f;

        /// <summary>
        /// Check if there is floor above a certain point by casting down a capsule from above the specified point.
        /// </summary>
        public static bool CheckFloorAbovePoint(in Vector3 point, float capsuleRadius, float capsuleHeight, float minFloorUp, 
            in Vector3 upDirection, LayerMask collisionMask, out Vector3 pointOnFloor)
        {
            float verticalOffset = verticalOffsetFactor * capsuleRadius;
            float probeRadius = probeRadiusFactor * capsuleRadius;
            float probeHeight = capsuleHeight - verticalOffset;

            if (probeHeight < 2f * probeRadius)
                probeHeight = 2f * probeRadius;

            float lowerCenterHeight = verticalOffset + probeRadius;
            Vector3 lowerCenter = point + lowerCenterHeight * upDirection;
            Vector3 upperCenter = lowerCenter + (probeHeight - 2f * probeRadius) * upDirection;

            if (OverlapChecker.CheckCapsuleOverlap(lowerCenter, upperCenter, probeRadius, collisionMask))
            {
                pointOnFloor = new Vector3();
                return false;
            }

            if (Physics.SphereCast(lowerCenter, probeRadius, -upDirection, out RaycastHit hit, lowerCenterHeight, collisionMask, QueryTriggerInteraction.Ignore))
            {
                pointOnFloor = hit.point;
                return Math.Dot(hit.normal, upDirection) > minFloorUp;
            }

            pointOnFloor = new Vector3();
            return false;
        }
    }
}
