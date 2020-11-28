using UnityEngine;

namespace MenteBacata.ScivoloCharacterController
{
    public struct MoveContact
    {
        public readonly Vector3 position;
        public readonly Vector3 normal;
        public readonly Collider collider;

        public MoveContact(Vector3 position, Vector3 normal, Collider collider)
        {
            this.position = position;
            this.normal = normal;
            this.collider = collider;
        }
    }
}
