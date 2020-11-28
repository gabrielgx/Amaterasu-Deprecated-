using UnityEngine;
using System.Collections;
using MalbersAnimations.Utilities;
using System.Collections.Generic;
using UnityEngine.Events;

namespace MalbersAnimations.Controller
{
    /// <summary>Simple Script to make damage anything with a stat</summary>
    public class MAttackTrigger : MonoBehaviour, IMHitLayer
    {
        /// <summary>ID of the Trigger. This is called on the Animator to wakes up the Trigger</summary>
        [Tooltip("ID of the Trigger. This is called on the Animator to wakes up the Trigger")]
        public int index = 1;
        [Tooltip("ID to Activate Mode")]
        public int ModeID = 3;
        [Tooltip("Ability Index")]
        public int Ability = -1;

        [Tooltip("If the Target has a rigidbody then it will push it with that force")]
        public float PushForce = 10;

        [RequiredField, Tooltip("Collider used for the Interaction")]
        public Collider Trigger;
        
        /// <summary>When the Attack Trigger is Enabled, Affect your stat</summary>
        [/*Header("Stats "), */Tooltip("When the Attack Trigger is Enabled, Affect your stat")]
        public StatModifier SelfStatEnter;

        /// <summary>When the Attack Trigger is Disabled, Affect your stat</summary>
        [Tooltip("When the Attack Trigger is Disabled, Affect your stat")]
        public StatModifier SelfStatExit;


        /// <summary>When the Attack Trigger Enters an enemy, Affect his stats</summary>
        [Tooltip("When the Attack Trigger Enters an enemy, Affect his stats")]
        public StatModifier EnemyStatEnter;

        /// <summary>When the Attack Trigger Exits an enemy, Affect his stats</summary>
        [Tooltip("When the Attack Trigger Exits an enemy, Affect his stats")]
        public StatModifier EnemyStatExit;

        public UnityEvent OnAttackBegin = new UnityEvent();
        public UnityEvent OnAttackEnd = new UnityEvent();

        public bool debug = true;
        public Color DebugColor = new Color(1, 0.25f, 0, 0.15f);
        
        /// <summary>Enemy that can be Damaged</summary>
        private IMDamage enemy;
        private Stats enemyStats;
        protected Stats SelfStats;
        private Transform owner;
        protected List<Collider> AlreadyHitted = new List<Collider>();

        private IMHitLayer HitMaskOwner;

        [SerializeField] private LayerMask hitLayer = ~0;
        [SerializeField] private QueryTriggerInteraction triggerInteraction = QueryTriggerInteraction.Collide;
        public LayerMask HitLayer { get => hitLayer; set => hitLayer = value; }

        public QueryTriggerInteraction TriggerInteraction { get => triggerInteraction; set => triggerInteraction = value; }

 
        public Transform Owner
        {
            get { return owner; }
            set
            {
                owner = value;

                HitMaskOwner = Owner.GetComponentInChildren<IMHitLayer>();

                if (HitMaskOwner != null)
                {
                    HitLayer = HitMaskOwner.HitLayer;
                    TriggerInteraction = HitMaskOwner.TriggerInteraction;
                }

                SelfStats = Owner.GetComponentInParent<Stats>();
            }
        }
 
        void OnEnable()
        {  
            Owner = transform.root; //Set which is the owner of this AttackTrigger
            SelfStatEnter.ModifyStat(SelfStats);
            Trigger.enabled = true;
            Trigger.isTrigger = true;
            AlreadyHitted = new List<Collider>();
            OnAttackBegin.Invoke();
            enemy = null;
            enemyStats = null;

        }
 

        void OnDisable()
        {
            SelfStatExit.ModifyStat(SelfStats);
            Trigger.enabled = false;
            EnemyStatExit.ModifyStat(enemyStats);
            AlreadyHitted = new List<Collider>();
            OnAttackEnd.Invoke();

            enemy = null;
            enemyStats = null;
        }

        void OnTriggerEnter(Collider other)
        {
            if (other.isTrigger && TriggerInteraction == QueryTriggerInteraction.Ignore) return;    //just collapse when is a collider what we are hitting
            if (!MalbersTools.Layer_in_LayerMask(other.gameObject.layer, HitLayer)) return;         //Just hit what is on the HitMask Layer

            if (IsParent(other.transform, owner)) return;           //Don't hit yourself

           var Newenemy = other.GetComponentInParent<IMDamage>();                           //Get the Animal on the Other collider

            if (!AlreadyHitted.Find(col => col == other))                                 //if the entering collider is not already on the list add it
                AlreadyHitted.Add(other);

              

            if (enemy == Newenemy) return;                                                //if the animal is the same, do nothing we already done the logic below
            else
            {
                if (enemy != null)
                    AlreadyHitted = new List<Collider>();                                 //Clean the colliders if you had a previus animal

                var interactable = other.GetComponentInParent<IInteractable>();           //Get the interactable on the Other collider
                interactable?.Interact();
                
                enemy = Newenemy;                                                         //Get the Damager on the Other collider
                enemyStats = other.GetComponentInParent<Stats>();

                Vector3 direction = (Owner.position - other.bounds.center).normalized;    //Calculate the direction of the attack

                if (enemy != null)                                                        //if the other does'nt have the Damagable Interface dont send the Damagable stuff
                {
                    enemy.HitDirection = direction;
                    enemy.Damage(ModeID, Ability);
                    EnemyStatEnter.ModifyStat(enemyStats);                                //Affect Stats
                }
                else if (other.attachedRigidbody && PushForce != 0)                        //If the other has a riggid body and it can be pushed
                {
                    other.attachedRigidbody.AddForce(-direction * PushForce, ForceMode.VelocityChange);
                }
            }
        }

        void OnTriggerExit(Collider other)
        {
            if (other.isTrigger && TriggerInteraction == QueryTriggerInteraction.Ignore) return;        //just collapse when is a collider what we are hitting

            var Newenemy = other.GetComponentInParent<IMDamage>();                                      //Get the Animal on the Other collider

            if (enemy != Newenemy) return;                                                              //If is another animal exiting the trigger SKIP


            if (AlreadyHitted.Find(col => col == other))                                                //Remove the collider from the list that is exiting the zone.
                AlreadyHitted.Remove(other);


            if (AlreadyHitted.Count == 0)                                        //When all the collides are removed from the list..
            {
                if (enemy != null)                                                  //if the other does'nt have the animal script skip
                {
                    EnemyStatExit.ModifyStat(enemyStats);
                    enemy = null;
                    enemyStats = null;
                }
            }
        }

        public virtual void SetOwner(Transform owner) { Owner = owner; }



        public bool IsParent(Transform childObject,Transform parent)
        {
            Transform t = childObject.transform;

            while (t.parent != null)
            {
                if (t.parent == parent)
                {
                    return true;
                }
                t = t.parent.transform;
            }
            return false; // Could not its parent
        }


#if UNITY_EDITOR
        void Reset()
        {
            SetOwner(transform.root);

            EnemyStatEnter = new StatModifier()
            {
                ID = MalbersTools.GetInstance<StatID>("Health"),
                modify = StatOption.SubstractValue,
                Value = new Scriptables.FloatReference() { UseConstant = true, ConstantValue = 10 },
            };

            Trigger = GetComponent<Collider>();
            if (!Trigger) Trigger.GetComponentInChildren<Collider>();
            if (!Trigger) Trigger.GetComponentInParent<Collider>();


            if (!Trigger) Trigger = gameObject.AddComponent<BoxCollider>();
            Trigger.isTrigger = true;
            enabled = false;



            IMHitLayer mHit = GetComponentInParent<IMHitLayer>();
            if (mHit != null)
            {
                HitLayer = mHit.HitLayer;
                TriggerInteraction = mHit.TriggerInteraction;
            }
        }


        void OnDrawGizmos()
        {
            MalbersTools.DrawTriggers(transform, Trigger, DebugColor);
        }
#endif
    }
}

