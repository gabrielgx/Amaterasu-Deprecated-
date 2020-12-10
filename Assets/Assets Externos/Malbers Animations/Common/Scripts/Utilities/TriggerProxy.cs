using UnityEngine;
using MalbersAnimations.Events;
using MalbersAnimations.Scriptables;

namespace MalbersAnimations.Utilities
{
    /// <summary>
    /// This is used when the collider is in a different gameObject and you need to check the Collider Events
    /// Create this component at runtime and subscribe to the UnityEvents
    /// </summary>
    public class TriggerProxy : MonoBehaviour
    {
        [Tooltip("Hit Layer for the Trigger Proxy")]
        [SerializeField] private LayerReference hitLayer = new LayerReference(-1);
        [SerializeField] private BoolReference active = new BoolReference(true);
        [SerializeField] private BoolReference ignoreTriggers = new BoolReference(true);

        public ColliderEvent OnTrigger_Enter = new ColliderEvent();
        public ColliderEvent OnTrigger_Stay = new ColliderEvent();
        public ColliderEvent OnTrigger_Exit = new ColliderEvent();
        public CollisionEvent OnCollision_Enter = new CollisionEvent();

        public bool Active { get => active.Value; set => active.Value = value; }
        public LayerMask HitLayer { get => hitLayer.Value; set => hitLayer.Value = value; }
        public bool IgnoreTriggers { get => ignoreTriggers.Value; set => ignoreTriggers.Value = value; }

        public bool TrueConditions(Collider other)
        {
            if (!Active) return false;
            if (ignoreTriggers && other.isTrigger) return false;
            if (!MalbersTools.Layer_in_LayerMask(other.gameObject.layer, HitLayer)) return false;

            return true;
        }

        void OnTriggerStay(Collider other)
        {
            if (TrueConditions(other)) OnTrigger_Stay.Invoke(other);
        }

        void OnTriggerEnter(Collider other)
        {
            if (TrueConditions(other)) OnTrigger_Enter.Invoke(other);
        }

        void OnTriggerExit(Collider other)
        {
            if (TrueConditions(other)) OnTrigger_Exit.Invoke(other);
        }

        private void Reset()
        {
            var collider = GetComponent<Collider>();
            Active = true;

            if (collider)
                collider.isTrigger = true;
            else
                Debug.LogWarning("This Script requires a Collider, please add any type of collider");
        }
    }
}