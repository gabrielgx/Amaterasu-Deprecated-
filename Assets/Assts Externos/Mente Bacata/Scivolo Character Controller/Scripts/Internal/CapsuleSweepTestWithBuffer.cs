//#define MB_DEBUG

using UnityEngine;

namespace MenteBacata.ScivoloCharacterController.Internal
{
    public static class CapsuleSweepTestWithBuffer
    {
        private const float extraDistancePerBuffer = 8f;

        /// <summary>
        /// It sweeps the capsule along the given direction. The returned hit distance accounts for the buffer distance as if the
        /// capsule stopped at a buffer distance from the hit point surface. Buffer distance is not guaranteed be kept if the
        /// capsule starts inside the buffer distance or the angle between the direction and the hit normal is too small.
        /// </summary>
        public static bool SweepCapsuleWithBuffer(in Vector3 lowerCenter, in Vector3 upperCenter, float radius, in Vector3 direction, 
            float maxDistance, float buffer, LayerMask collisionMask, out RaycastHit hit)
        {
            float extraDistance = extraDistancePerBuffer * buffer;

            if (Physics.CapsuleCast(lowerCenter, upperCenter, radius, direction, out hit, maxDistance + extraDistance, collisionMask, QueryTriggerInteraction.Ignore))
            {
                float dot = Math.Dot(direction, hit.normal);

                if (Math.IsCircaZero(dot))
                {
                    hit.distance -= extraDistance;
                }
                else
                {
                    hit.distance -= Mathf.Min(-buffer / dot, extraDistance);
                }

                if (hit.distance >= maxDistance)
                {
                    return false;
                }

                if (hit.distance < 0f)
                    hit.distance = 0f;

                return true;
            }
            else
            {
                return false;
            }
        }
    }
}
