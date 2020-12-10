//#define MB_DEBUG

using System.Collections.Generic;
using UnityEngine;
using MenteBacata.ScivoloCharacterController.Internal;
using static MenteBacata.ScivoloCharacterController.Internal.Math;
using static MenteBacata.ScivoloCharacterController.Internal.OverlapResolver;
using static MenteBacata.ScivoloCharacterController.Internal.FloorAbovePointChecker;
using static MenteBacata.ScivoloCharacterController.Internal.CapsuleSweepTestWithBuffer;
using static MenteBacata.ScivoloCharacterController.Internal.MovementSurfaceHelper;

namespace MenteBacata.ScivoloCharacterController
{
    [RequireComponent(typeof(CharacterCapsule))]
    public class CharacterMover : MonoBehaviour
    {
        [Range(25f, 75f)]
        [Tooltip("Maximum angle a slope can have in order to be considered floor.")]
        public float maxFloorAngle = 45f;

        [Tooltip("Prevents the character from moving up slopes which exceed the maximum floor angle.")]
        public bool preventMovingUpSteepSlope = false;

        [Tooltip("Allows the character to climb steps.")]
        public bool canClimbSteps = false;

        [Tooltip("Maximum height of climbable step.")]
        public float maxStepHeight = 0.3f;

        [SerializeField]
        [Tooltip("Small distance padding from the collider surface within which contacts are detected.")]
        private float contactOffset = 0.01f;

        // Maximum number of iterations for the main move loop, however it can be exceeded to satisfy the minimum number of 
        // iterations after climbing a step.
        // Maximum iterations upper bound is: maxMainMovementIterations + minIterationAfterStepClimb.
        private const int maxMainMoveIterations = 5;

        // Minimum number of iterations for the main move loop after climbing a step.
        private const int minIterationsAfterStepClimb = 2;

        // Maximum number of iterations for the horizontal move loop when climbing a step.
        private const int maxHorizontalClimbStepIterations = 3;

        // Maximum number of iterations for the upward move loop when climbing a step.
        private const int maxUpwardClimbStepIterations = 2;

        // Minimum move distance.
        private const float minMoveDistance = 0.0001f;

        // Maximum allowed move distance when starting with overlaps in relation to the length of the capsule radius.
        private const float maxMoveDistanceOverlapPerRadius = 0.5f;

        // Maximum distance between two contacts for them to be considered near in relation to the length of the capsule radius.
        private const float maxNearContactDistancePerRadius = 0.05f;

        // Minimum distance from the last step climb to allow the next one in relation to the length of the capsule radius.
        private const float minDistanceFromLastStepClimbPerRadius = 0.02f;

        private readonly MovementProjector movementProjector = new MovementProjector();

        private LayerMask collisionMask;

        private CharacterCapsule capsule;

        private List<MoveContact> moveContacts;

        // Minimum up component of the ground normal for it to be considered floor.
        private float minFloorUp;

        private float capsuleHeight;

        private float capsuleRadius;

        private Vector3 upDirection;

        private Vector3 toCapsuleLowerCenter;

        private Vector3 toCapsuleUpperCenter;
        
        
        private void Awake()
        {
            capsule = GetComponent<CharacterCapsule>();
            collisionMask = gameObject.CollisionMask();
        }

        /// <summary>
        /// Moves the character according to the movement settings trying to fulfill the desired movement as close as it can, if 
        /// a MoveContact list is provided it populates the list with all the contact informations it have found during the 
        /// movement.
        /// </summary>
        public void Move(Vector3 desiredMovement, List<MoveContact> moveContacts = null)
        {
            Initialize(moveContacts);

            // Set collider to trigger so it doesn't interfere with geometry queries.
            bool isTrigger = capsule.Collider.isTrigger;
            capsule.Collider.isTrigger = true;

            Vector3 currentPosition = transform.position;

            if (!TryResolveCapsuleOverlap(capsule, currentPosition, contactOffset, collisionMask, out currentPosition))
            {
                desiredMovement = Vector3.ClampMagnitude(desiredMovement, maxMoveDistanceOverlapPerRadius * capsuleRadius);
            }

            Vector3 beforeMovePosition = currentPosition;
            DoMainMoveLoop(ref currentPosition, desiredMovement);

            // If it ends up in a position where it can't resolve overlap, it reverts back to the position prior the move loop.
            // The only movement is given by the first overlap resolve.
            if (!TryResolveCapsuleOverlap(capsule, currentPosition, contactOffset, collisionMask, out currentPosition))
            {
                currentPosition = beforeMovePosition;
                moveContacts?.Clear();
            }

            transform.position = currentPosition;
            capsule.Collider.isTrigger = isTrigger;

            return;
        }
        
        private void Initialize(List<MoveContact> moveContacts)
        {
            maxFloorAngle = Mathf.Clamp(maxFloorAngle, 25f, 75f);
            minFloorUp = Mathf.Cos(Mathf.Deg2Rad * maxFloorAngle);
            capsuleHeight = capsule.Height;
            capsuleRadius = capsule.Radius;
            upDirection = capsule.UpDirection;
            toCapsuleLowerCenter = capsule.ToLowerHemisphereCenter;
            toCapsuleUpperCenter = capsule.ToUpperHemisphereCenter;
            movementProjector.Initialize(upDirection, minFloorUp, preventMovingUpSteepSlope);
            this.moveContacts = moveContacts;
            this.moveContacts?.Clear();
        }
        
        // Iteratively moves according to the movement settings, it handles sliding on surfaces and climbing steps.
        private void DoMainMoveLoop(ref Vector3 position, in Vector3 desiredMovement)
        {
            Vector3 initialPosition = position;
            Vector3 movementToMake = desiredMovement;

            ContactInfo currentContact = new ContactInfo();
            bool hasCurrentContact = false;

            StepClimbInfo lastStepClimb = new StepClimbInfo();
            bool hasLastStepClimb = false;

            int extraIterations = 0;

            for (int i = 0; i < maxMainMoveIterations + extraIterations; i++)
            {
                float distanceToMake = Magnitude(movementToMake);

                if (distanceToMake < minMoveDistance)
                {
                    break;
                }

                SweepCapsuleAndUpdateCurrentContact(ref position, movementToMake, distanceToMake, ref hasCurrentContact, ref currentContact);

                if (hasCurrentContact)
                {
                    Vector3 movementLeft = (initialPosition - position) + desiredMovement;

                    if (canClimbSteps && IsClimbableStep(position, currentContact.position, currentContact.normal))
                    {
                        // Is not allowed to climb steps when using extra iterations.
                        if (i >= maxMainMoveIterations)
                        {
                            break;
                        }

                        if (!CheckIfShouldAndClimbStep(ref position, movementLeft, currentContact, ref hasLastStepClimb, ref lastStepClimb))
                        {
                            break;
                        }

                        hasCurrentContact = false;

                        movementToMake = (initialPosition - position) + desiredMovement;

                        extraIterations = Mathf.Max(i + minIterationsAfterStepClimb + 1 - maxMainMoveIterations, 0);
                    }
                    else
                    {
                        movementToMake = SlideMovement(movementLeft, currentContact.normal, currentContact.hasNearNormal, currentContact.nearNormal);
                    }
                }
                else
                {
                    movementToMake = (initialPosition - position) + desiredMovement;
                }
            }
        }
        
        // Iteratively moves according to the movement settings and projection mode for specialized movement, it only handles 
        // sliding.
        private void DoSimpleMoveLoop(ref Vector3 position, in Vector3 desiredMovement, ProjectionMode mode, int maxIterations)
        {
            Vector3 initialPosition = position;
            Vector3 movementToMake = desiredMovement;

            for (int i = 0; i < maxIterations; i++)
            {
                float distanceToMake = Magnitude(movementToMake);

                if (distanceToMake < minMoveDistance)
                {
                    break;
                }

                Vector3 directionToMake = Normalized(movementToMake);

                if (SweepCapsule(position, directionToMake, distanceToMake, out RaycastHit hit))
                {
                    moveContacts?.Add(new MoveContact(hit.point, hit.normal, hit.collider));

                    position += hit.distance * directionToMake;
                    Vector3 movementLeft = (initialPosition - position) + desiredMovement;

                    movementToMake = SlideMovement(movementLeft, hit.normal, mode);
                }
                else
                {
                    position += movementToMake;

                    // Unlike the main loop, it ends if it doesn't detect any contact.
                    break;
                }
            }
        }
        
        // Sweeps the capsule along the movement direction until it either finds a contact or completes the movement.
        private void SweepCapsuleAndUpdateCurrentContact(ref Vector3 position, in Vector3 movement, float distance, 
            ref bool hasCurrentContact, ref ContactInfo currentContact)
        {
            Vector3 direction = Normalized(movement);

            if (SweepCapsule(position, direction, distance, out RaycastHit hit))
            {
                moveContacts?.Add(new MoveContact(hit.point, hit.normal, hit.collider));

                position += hit.distance * direction;

                currentContact = new ContactInfo
                {
                    position = hit.point,
                    normal = hit.normal,
                    nearNormal = currentContact.normal,
                    hasNearNormal = hasCurrentContact && hit.distance < maxNearContactDistancePerRadius * capsuleRadius,
                    fromDirection = direction
                };

                hasCurrentContact = true;
            }
            else
            {
                position += movement;

                hasCurrentContact = false;
            }
        }

        private bool SweepCapsule(in Vector3 position, in Vector3 direction, float maxDistance, out RaycastHit hit)
        {
            return SweepCapsuleWithBuffer(position + toCapsuleLowerCenter, position + toCapsuleUpperCenter, capsuleRadius, 
                direction, maxDistance, contactOffset, collisionMask, out hit);
        }
        
        // Check if a contact can be considered a step and if the character can climb it.
        private bool IsClimbableStep(in Vector3 position, in Vector3 contactPosition, in Vector3 contactNormal)
        {
            var surface = GetMovementSurface(contactNormal, upDirection, minFloorUp);

            if (surface != MovementSurface.SteepSlope && surface != MovementSurface.Wall)
                return false;

            float contactHeightFromCapsuleBottom = Dot((contactPosition - position) - toCapsuleLowerCenter, upDirection) + capsuleRadius;

            if (contactHeightFromCapsuleBottom >= maxStepHeight)
                return false;

            if (CheckFloorAbovePoint(contactPosition, capsuleRadius, capsuleHeight, minFloorUp, upDirection, collisionMask, out Vector3 puntoSuSuolo))
            {
                float floorHeightFromCapsuleBottom = Dot((puntoSuSuolo - position) - toCapsuleLowerCenter, upDirection) + capsuleRadius;

                return floorHeightFromCapsuleBottom < maxStepHeight;
            }

            return false;
        }
        
        // Check if the conditions to start climbing a step are met and eventually climb it.
        private bool CheckIfShouldAndClimbStep(ref Vector3 position, in Vector3 movement, in ContactInfo currentContact, 
            ref bool hasLastStepClimb, ref StepClimbInfo lastStepClimb)
        {
            Vector3 horizontalMovement = ProjectOnPlane(movement, upDirection);

            if (horizontalMovement.IsShorterThan(minMoveDistance) && 
                IsCircaZero(ProjectOnPlane(currentContact.fromDirection, upDirection)))
            {
                return false;
            }
            
            // Only uses extra up distance if it moves towards the step and it needs to climb it up, not when to climb it down.
            bool useExtraUpDistance = Dot(horizontalMovement, currentContact.normal) < 0f;

            if (hasLastStepClimb)
            {
                if (useExtraUpDistance == lastStepClimb.usedExtraUpDistance &&
                    (position - lastStepClimb.initialPosition).IsShorterThan(minDistanceFromLastStepClimbPerRadius * capsuleRadius))
                {
                    return false;
                }
            }
            
            StepUpThenMoveHorizontally(ref position, movement, useExtraUpDistance ? maxStepHeight + contactOffset : 0f);

            lastStepClimb = new StepClimbInfo
            {
                initialPosition = position,
                usedExtraUpDistance = useExtraUpDistance
            };

            hasLastStepClimb = true;

            return true;
        }
        
        // It moves at first along the upward component of the desired movement and then along the horizontal component of 
        // the remaining movement.
        private void StepUpThenMoveHorizontally(ref Vector3 position, in Vector3 desiredMovement, float extraUpDistance)
        {
            Vector3 initialPosition = position;
            float upDistance = Dot(desiredMovement, upDirection);

            if (upDistance < 0f)
                upDistance = extraUpDistance;
            else
                upDistance += extraUpDistance;

            DoSimpleMoveLoop(ref position, upDistance * upDirection, ProjectionMode.Vertical, maxUpwardClimbStepIterations);

            Vector3 horizontalMovement = ProjectOnPlane((initialPosition - position) + desiredMovement, upDirection);
            DoSimpleMoveLoop(ref position, horizontalMovement, ProjectionMode.Horizontal, maxHorizontalClimbStepIterations);
        }
        
        // Gets the result of a movement against a surface on which it can slide. It handles sliding on two surfaces, if the 
        // normal of a near surface is provided.
        private Vector3 SlideMovement(in Vector3 movement, in Vector3 surfaceNormal, bool hasNearSurface, in Vector3 nearNormal)
        {
            Vector3 resultantMovement = movement;

            // Only projects if it moves toward the surface.
            if (Dot(movement, surfaceNormal) < 0f)
            {
                resultantMovement = movementProjector.ProjectOnSurface(movement, surfaceNormal);
            }

            if (!hasNearSurface)
                return resultantMovement;

            // If it slides toward the near surface...
            if (Dot(resultantMovement, nearNormal) < 0f)
            {
                // ...it projects the movement on the intersection of the two surface.
                if (movementProjector.TryProjectOnSurfacesIntersection(movement, surfaceNormal, nearNormal, out Vector3 movementOnIntersection))
                {
                    return movementOnIntersection;
                }
            }

            return resultantMovement;
        }
        
        // Gets the result of a movement against a surface on which it can slide according to the projection mode.
        private Vector3 SlideMovement(in Vector3 movement, in Vector3 surfaceNormal, ProjectionMode mode)
        {
            if (Dot(movement, surfaceNormal) < 0f)
            {
                switch (mode)
                {
                    case ProjectionMode.Horizontal:
                        return movementProjector.ProjectOnSurface_Horizontal(movement, surfaceNormal);
                    case ProjectionMode.Vertical:
                        return movementProjector.ProjectOnSurface_Vertical(movement, surfaceNormal);
                    case ProjectionMode.Generic:
                    default:
                        return movementProjector.ProjectOnSurface(movement, surfaceNormal);
                }
            }

            return movement;
        }
        
        private enum ProjectionMode
        {
            Generic,
            Horizontal,
            Vertical
        }

        private struct ContactInfo
        {
            public Vector3 position;
            public Vector3 normal;
            public Vector3 nearNormal;
            public bool hasNearNormal;
            public Vector3 fromDirection;
        }

        private struct StepClimbInfo
        {
            public Vector3 initialPosition;
            public bool usedExtraUpDistance;
        }
    }
}
