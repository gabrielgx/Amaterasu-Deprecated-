//#define MB_DEBUG

using UnityEngine;
using MenteBacata.ScivoloCharacterController.Internal;
using static MenteBacata.ScivoloCharacterController.Internal.Math;
using static MenteBacata.ScivoloCharacterController.Internal.FloorAbovePointChecker;

namespace MenteBacata.ScivoloCharacterController
{
    [RequireComponent(typeof(CharacterCapsule), typeof(CharacterMover))]
    public class GroundDetector : MonoBehaviour
    {
        [SerializeField]
        [Tooltip("Small tolerance distance so that ground is detected even if the capsule is not directly touching it but just close enough.")]
        private float tolerance = 0.05f;

        [SerializeField]
        [Range(0f, 1f)]
        [Tooltip("Spacing between probe rays in relation to the capsule radius.")]
        private float raySpacing = 0.6f;

        [SerializeField]
        [Tooltip("Max distance for the rays used for probing ground.")]
        private float maxRayDistance = 1f;

        private LayerMask collisionMask;

        private CharacterMover mover;

        private CharacterCapsule capsule;


        private void Awake()
        {
            collisionMask = gameObject.CollisionMask();
            capsule = GetComponent<CharacterCapsule>();
            mover = GetComponent<CharacterMover>();
        }

        /// <summary>
        /// Detects ground below the capsule bottom and retrieves useful info.
        /// </summary>
        public bool DetectGround(out GroundInfo groundInfo)
        {
            float radius = capsule.Radius;
            Vector3 sphereCastOrigin = capsule.Center;
            Vector3 upDirection = capsule.UpDirection;
            float minFloorUp = Mathf.Cos(Mathf.Deg2Rad * mover.maxFloorAngle);

            float maxFloorDistance = 0.5f * capsule.Height - radius + tolerance;
            float maxDistance = maxFloorDistance + tolerance;

            if (!Physics.SphereCast(sphereCastOrigin, radius, -upDirection, out RaycastHit hit, maxDistance, collisionMask, QueryTriggerInteraction.Ignore))
            {
                groundInfo = new GroundInfo();
                return false;
            }

            // If it hits floor it has to be within max floor distance, this is because it uses extra tolerance only when it hits
            // ground that is not floor.
            if (Dot(hit.normal, upDirection) > minFloorUp)
            {
                if (hit.distance < maxFloorDistance)
                {
                    groundInfo = new GroundInfo(hit.point, hit.normal, hit.collider, true);
                    return true;
                }
                else
                {
                    groundInfo = new GroundInfo();
                    return false;
                }
            }

            // Set collider to trigger so it doesn't interfere with geometry queries. The previous sphere cast is not a problem 
            // since it starts inside the collider so it's ignored.
            bool isTrigger = capsule.Collider.isTrigger;
            capsule.Collider.isTrigger = true;

            groundInfo = new GroundInfo(hit.point, hit.normal, hit.collider,
                CheckFloorWithRaycasts(sphereCastOrigin - hit.distance * upDirection, hit.point, hit.normal, upDirection, minFloorUp));

            capsule.Collider.isTrigger = isTrigger;
            return true;
        }
        
        private static Vector3 NormalFromThreePoints(in Vector3 point1, in Vector3 point2, in Vector3 point3)
        {
            return Normalized(Cross(point1 - point2, point1 - point3));
        }

        private static void ComputeTriangleVertices(in Vector3 center, in Vector3 forwardDirection, in Vector3 rightDirection, float size,
            out Vector3 a, out Vector3 b, out Vector3 c)
        {
            const float cos60 = 0.5f;
            const float sen60 = 0.866f;

            a = size * (sen60 * rightDirection + -cos60 * forwardDirection) + center;
            b = size * (-sen60 * rightDirection + -cos60 * forwardDirection) + center;
            c = size * forwardDirection + center;
        }

        private bool CheckFloorWithRaycasts(in Vector3 origin, in Vector3 contactPosition, in Vector3 contactNormal, in Vector3 upDirection, float minFloorUp)
        {
            float maxDistance = maxRayDistance + capsule.Radius;

            // It should be smaller than maxDistance, this because even if a point is not on floor could still be used for
            // further evaluations.
            float maxFloorDistance = GetMaxFloorDistance(contactPosition, origin, upDirection, minFloorUp);

            Vector3 forwardDirection = Normalized(ProjectOnPlane(contactNormal, upDirection));
            Vector3 rightDirection = Cross(upDirection, forwardDirection);

            bool oResult = Physics.Raycast(origin, -upDirection, out RaycastHit oHit, maxDistance, collisionMask, QueryTriggerInteraction.Ignore);

            if (oHit.distance < maxFloorDistance && Dot(oHit.normal, upDirection) > minFloorUp)
            {
                return true;
            }
            
            ComputeTriangleVertices(origin, forwardDirection, rightDirection, raySpacing * capsule.Radius,
                out Vector3 a, out Vector3 b, out Vector3 c);

            bool aResult = Physics.Raycast(a, -upDirection, out RaycastHit aHit, maxDistance, collisionMask, QueryTriggerInteraction.Ignore);

            if (aHit.distance < maxFloorDistance && Dot(aHit.normal, upDirection) > minFloorUp)
            {
                return true;
            }
            
            bool bResult = Physics.Raycast(b, -upDirection, out RaycastHit bHit, maxDistance, collisionMask, QueryTriggerInteraction.Ignore);

            if (bHit.distance < maxFloorDistance && Dot(bHit.normal, upDirection) > minFloorUp)
            {
                return true;
            }

            bool cResult = Physics.Raycast(c, -upDirection, out RaycastHit cHit, maxDistance, collisionMask, QueryTriggerInteraction.Ignore);

            if (cHit.distance < maxFloorDistance && Dot(cHit.normal, upDirection) > minFloorUp)
            {
                return true;
            }
            
            // If it didn't detect floor from single hit points, it groups them into triangles and check their normals.

            // ABC
            if (aResult && bResult && cResult)
            {
                if (aHit.distance < maxFloorDistance || bHit.distance < maxFloorDistance || cHit.distance < maxFloorDistance)
                {
                    if (Dot(NormalFromThreePoints(aHit.point, bHit.point, cHit.point), upDirection) > minFloorUp)
                    {
                        return true;
                    }
                }
            }

            // OAB
            if (oResult && aResult && bResult)
            {
                if (oHit.distance < maxFloorDistance || aHit.distance < maxFloorDistance || bHit.distance < maxFloorDistance)
                {
                    if (Dot(NormalFromThreePoints(oHit.point, aHit.point, bHit.point), upDirection) > minFloorUp)
                    {
                        return true;
                    }
                }
            }

            // OBC
            if (oResult && bResult && cResult)
            {
                if (oHit.distance < maxFloorDistance || bHit.distance < maxFloorDistance || cHit.distance < maxFloorDistance)
                {
                    if (Dot(NormalFromThreePoints(oHit.point, bHit.point, cHit.point), upDirection) > minFloorUp)
                    {
                        return true;
                    }
                }
            }

            // OCA
            if (oResult && cResult && aResult)
            {
                if (oHit.distance < maxFloorDistance || cHit.distance < maxFloorDistance || aHit.distance < maxFloorDistance)
                {
                    if (Dot(NormalFromThreePoints(oHit.point, cHit.point, aHit.point), upDirection) > minFloorUp)
                    {
                        return true;
                    }
                }
            }
            return false;
        }

        /// <summary>
        /// Maximum distance from the raycast origin within which a point can be considered on a floor.
        /// </summary>
        private float GetMaxFloorDistance(in Vector3 contactPosition, in Vector3 origin, in Vector3 upDirection, float minFloorUp)
        {
            float maxFloorDistance = capsule.Radius;

            if (CheckFloorAbovePoint(contactPosition, capsule.Radius, capsule.Height, minFloorUp, upDirection, collisionMask, out _))
            {
                // It uses contactPosition because it's lower than point on floor so it will result in a greater distance and 
                // more chances to detect something below it.
                float stepDistance = Dot(origin - contactPosition, upDirection) + mover.maxStepHeight;

                maxFloorDistance = stepDistance > maxFloorDistance ? stepDistance : maxFloorDistance;
            }

            return maxFloorDistance + tolerance;
        }

        private void OnValidate()
        {
            tolerance = Mathf.Max(0f, tolerance);
            maxRayDistance = Mathf.Max(tolerance, maxRayDistance);
        }
    }
}
