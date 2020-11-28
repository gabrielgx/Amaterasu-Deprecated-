//#define MB_DEBUG

using UnityEngine;
using static MenteBacata.ScivoloCharacterController.Internal.OverlapChecker;
using static MenteBacata.ScivoloCharacterController.Internal.DisplacementOfBestFitCalculator;

namespace MenteBacata.ScivoloCharacterController.Internal
{
    public static class OverlapResolver
    {
        private const int maxIterations = 3;

        internal const int maxOverlaps = 5;

        private static readonly Collider[] overlaps = new Collider[maxOverlaps];

        // Buffer for displacement directions from single colliders.
        private static readonly Vector3[] directions = new Vector3[maxOverlaps];

        // Buffer for displacement distances from single colliders.
        private static readonly float[] distances = new float[maxOverlaps];

        /// <summary>
        /// Tries to resolve capsule's overlaps, if it succeeds it return true, false otherwise.
        /// </summary>
        public static bool TryResolveCapsuleOverlap(CharacterCapsule capsule, in Vector3 initialPosition, float resolveOffset, LayerMask collisionMask, out Vector3 suggestedPosition)
        {
            Vector3 toLowerCenter = capsule.ToLowerHemisphereCenter;
            Vector3 toUpperCenter = capsule.ToUpperHemisphereCenter;
            CapsuleCollider capsuleCollider = capsule.Collider;
            Quaternion rotation = capsule.Rotation;

            // It uses inflated capsule to collect and resolve overlaps but the original it's still used to check overlaps.
            float originalRadius = capsuleCollider.radius;
            float originalHeight = capsuleCollider.height;
            capsuleCollider.radius = capsuleCollider.radius + resolveOffset;
            capsuleCollider.height = capsuleCollider.height + 2f * resolveOffset;

            Vector3 currentPosition = initialPosition;
            bool success = false;

            for (int i = 0; i < maxIterations; i++)
            {
                Vector3 lowerCenter = currentPosition + toLowerCenter;
                Vector3 upperCenter = currentPosition + toUpperCenter;

                if (!CheckCapsuleOverlap(lowerCenter, upperCenter, originalRadius, collisionMask))
                {
                    success = true;
                    break;
                }

                int overlapsCount = Physics.OverlapCapsuleNonAlloc(lowerCenter, upperCenter, capsuleCollider.radius, overlaps, collisionMask, QueryTriggerInteraction.Ignore);

                int displacementsCount = PopulateDisplacements(currentPosition, rotation, capsuleCollider, overlapsCount);

                if (displacementsCount > 0)
                {
                    Vector3 displacement;

                    if (displacementsCount > 1)
                        displacement = GetDisplacementOfBestFit(directions, distances, displacementsCount);
                    else
                        displacement = distances[0] * directions[0];

                    currentPosition += displacement;

                    if (Math.IsCircaZero(displacement))
                        break;
                }
                else
                {
                    success = true;
                    break;
                }
            }

            capsuleCollider.radius = originalRadius;
            capsuleCollider.height = originalHeight;

            suggestedPosition = currentPosition;

            return success || !CheckCapsuleOverlap(currentPosition + toLowerCenter, currentPosition + toUpperCenter, originalRadius, collisionMask);
        }

        private static int PopulateDisplacements(in Vector3 position, in Quaternion rotation, CapsuleCollider capsuleCollider, int overlapsNumber)
        {
            int k = 0;

            for (int i = 0; i < overlapsNumber; i++)
            {
                Collider otherCollider = overlaps[i];

                if (capsuleCollider == otherCollider)
                    continue;

                if (Physics.ComputePenetration(capsuleCollider, position, rotation, otherCollider, otherCollider.transform.position, otherCollider.transform.rotation,
                    out Vector3 direction, out float distance))
                {
                    directions[k] = direction;
                    distances[k++] = distance;
                }
            }

            return k;
        }
    }
}
