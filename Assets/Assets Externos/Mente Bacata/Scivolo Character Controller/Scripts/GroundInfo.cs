using UnityEngine;

namespace MenteBacata.ScivoloCharacterController
{
    public struct GroundInfo
    {
        public readonly Vector3 point;
        public readonly Vector3 normal;
        public readonly Collider collider;
        public readonly bool isOnFloor;

        public GroundInfo(Vector3 point, Vector3 normal, Collider collider, bool isOnFloor)
        {
            this.point = point;
            this.normal = normal;
            this.collider = collider;
            this.isOnFloor = isOnFloor;
        }
    }
}
