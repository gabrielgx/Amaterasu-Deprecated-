using UnityEngine;

namespace MenteBacata.ScivoloCharacterController.Internal
{
    /*
     * Surface used to determine the resulting movement when moving onto it. It's type is determined by the angle that the 
     * surface normal forms with the upDirection.
     */
    public enum MovementSurface
    {
        // It's slope angle is less than a user specified value.
        Floor,

        // Steeper than floor but not as vertical as a wall.
        SteepSlope,

        // Nearly vertical surface.
        Wall,

        // It faces downward and is sloped.
        SlopedCeiling,

        // It faces downward and is nearly flat.
        FlatCeiling
    }

    public static class MovementSurfaceHelper
    {
        // Minimum upward component of the surface normal for it to be considered a steep slope.
        private const float minSteepSlopeUp = 0.173f;

        // Minimum upward component of the surface normal for it to be considered a vertical wall.
        private const float minWallUp = -minSteepSlopeUp;

        // Minimum upward component of the surface normal for it to be considered a sloped ceiling.
        private const float minSlopedCeilingUp = -0.99f;

        public static MovementSurface GetMovementSurface(in Vector3 normal, in Vector3 upDirection, float minFloorUp)
        {
            float upComponent = Math.Dot(normal, upDirection);

            if (upComponent > minFloorUp)
            {
                return MovementSurface.Floor;
            }
            else if (upComponent > minSteepSlopeUp)
            {
                return MovementSurface.SteepSlope;
            }
            else if (upComponent > minWallUp)
            {
                return MovementSurface.Wall;
            }
            else if (upComponent > minSlopedCeilingUp)
            {
                return MovementSurface.SlopedCeiling;
            }
            else
            {
                return MovementSurface.FlatCeiling;
            }
        }
    }
}
