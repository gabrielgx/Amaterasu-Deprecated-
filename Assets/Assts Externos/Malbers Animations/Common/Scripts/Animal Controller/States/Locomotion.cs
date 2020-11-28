using MalbersAnimations.Utilities;
using UnityEngine;

namespace MalbersAnimations.Controller
{
    /// <summary>This will be in charge of the Movement While is on the Ground </summary>
    public class Locomotion : State
    {
        [Header("Locomotion Parameters"),Tooltip("Set this parameter to true if there's no Idle State")]
        public bool IsIdle = false;

        [Space(10), Tooltip("Makes the Animal avoid ledges, Useful when the Animal without a Fall State, like the Elephant")]
        public bool AntiFall = false;

        [ConditionalHide("AntiFall", true, false)] public float frontDistance = 0.5f;
        [ConditionalHide("AntiFall", true, false)] public float frontSpace = 0.2f;
        [Space]
        [ConditionalHide("AntiFall", true, false)] public float BackDistance = 0.5f;
        [ConditionalHide("AntiFall", true, false)] public float BackSpace = 0.2f;
        [Space]
        [ConditionalHide("AntiFall", true, false)] public float FallMultiplier = 1f;
        [ConditionalHide("AntiFall", true, false)] public Color DebugColor = Color.yellow;

        /// <summary>This try to enable the Locomotion Logic</summary>
        public override bool TryActivate()
        {
            if (animal.Grounded)
            {
                if (animal.TerrainSlope > animal.maxAngleSlope) 
                    return false;

                if (IsIdle) 
                    return true; //Return true if is grounded

                if (animal.MovementAxisSmoothed != Vector3.zero || animal.MovementDetected) //If is moving? 
                    return true;
            }
            return false;
        }

        public override void OnStateMove(float deltatime)
        {
            if (animal.TerrainSlope > animal.maxAngleSlope && animal.MovementAxis.z > 0) animal.MovementAxis.z = 0;  //Don't allow movement when the slope is Deep

            Anti_Fall();
        }


        //───────────────────────────────────────── ANTI FALL CODE ──────────────────────────────────────────────────────────────────

        private void Anti_Fall()
        {
            if (AntiFall)
            {
                bool BlockForward = false;

                var ForwardMov = animal.MovementAxisRaw.z; // Get the Raw movement that enters on the animal witouth any modifications
                var Dir = animal.TerrainSlope > 0 ? animal.GravityDirection : -animal.Up;

                float SprintMultiplier = (animal.CurrentSpeedModifier.Vertical).Value;
                  SprintMultiplier += animal.Sprint ? 1f  : 0f; //Check if the animal is sprinting

                float scale = animal.ScaleFactor;
                var RayMultiplier = animal.Pivot_Multiplier * FallMultiplier; //Get the Multiplier

                var MainPivotPoint = animal.Pivot_Chest.World(animal.transform);

                RaycastHit[] hits = new RaycastHit[1];

                Vector3 Center;
                Vector3 Left;
                Vector3 Right;


                if (ForwardMov > 0)              //Means we are going forward
                {
                    Center = MainPivotPoint + (animal.Forward * frontDistance * SprintMultiplier * scale); //Calculate ahead the falling ray
                    Left = Center + (animal.Right * frontSpace * scale);
                    Right = Center + (-animal.Right * frontSpace * scale);
                }
                else if (ForwardMov < 0)  //Means we are going backwards
                {
                    Center = MainPivotPoint - (animal.Forward * BackDistance * SprintMultiplier * scale); //Calculate ahead the falling ray
                    Left = Center + (animal.Right * BackSpace * scale);
                    Right = Center + (-animal.Right * BackSpace * scale);
                }
                else
                { return; }

                Debug.DrawRay(Center, Dir * RayMultiplier, DebugColor);
                Debug.DrawRay(Left, Dir * RayMultiplier, DebugColor);
                Debug.DrawRay(Right, Dir * RayMultiplier, DebugColor);

                var fallHits = Physics.RaycastNonAlloc(Center, Dir, hits, RayMultiplier, animal.GroundLayer, QueryTriggerInteraction.Ignore);

                if (fallHits == 0)
                {
                    BlockForward = true; //Means there's 2 rays that are falling
                }
                else
                    fallHits = Physics.RaycastNonAlloc(Left, Dir, hits, RayMultiplier, animal.GroundLayer, QueryTriggerInteraction.Ignore);
                if (fallHits == 0)
                {
                    BlockForward = true; //Means there's 2 rays that are falling
                }
                else
                {
                    fallHits = Physics.RaycastNonAlloc(Right, Dir, hits, RayMultiplier, animal.GroundLayer, QueryTriggerInteraction.Ignore);
                    if (fallHits == 0)
                    {
                        BlockForward = true; //Means there's 2 rays that are falling
                    }
                }
                animal.LockForwardMovement = BlockForward;
            }
        }

        public override void DebugState()
        {
            if (!IsActiveState && AntiFall)
                PaintRays();
        }

        void PaintRays()
        {
            float scale = animal.ScaleFactor;
            var Dir = animal.TerrainSlope > 0 ? animal.GravityDirection : -animal.Up;
            var RayMultiplier = animal.Pivot_Multiplier * FallMultiplier; //Get the Multiplier
            var MainPivotPoint = animal.Pivot_Chest.World(animal.transform);

            var FrontCenter = MainPivotPoint + (animal.Forward * frontDistance * scale); //Calculate ahead the falling ray
            var FrontLeft = FrontCenter + (animal.Right * frontSpace * scale);
            var FrontRight = FrontCenter + (-animal.Right * frontSpace * scale);
            var BackCenter = MainPivotPoint - (animal.Forward * BackDistance * scale); //Calculate ahead the falling ray
            var BackLeft = BackCenter + (animal.Right * BackSpace * scale);
            var BackRight = BackCenter + (-animal.Right * BackSpace * scale);

            Debug.DrawRay(FrontCenter, Dir * RayMultiplier, DebugColor);
            Debug.DrawRay(FrontLeft, Dir * RayMultiplier, DebugColor);
            Debug.DrawRay(FrontRight, Dir * RayMultiplier, DebugColor);
            Debug.DrawRay(BackCenter, Dir * RayMultiplier, DebugColor);
            Debug.DrawRay(BackLeft, Dir * RayMultiplier, DebugColor);
            Debug.DrawRay(BackRight, Dir * RayMultiplier, DebugColor);
        }


#if UNITY_EDITOR
        void Reset()
        {
            ID = MalbersTools.GetInstance<StateID>("Locomotion");

            General = new AnimalModifier()
            {
                RootMotion = true,
                Grounded = true,
                Sprint = true,
                OrientToGround = true,
                CustomRotation = false,
                IgnoreLowerStates = false,
                //Colliders = true,
                AdditivePosition = true,
                //AdditiveRotation = true,
                Gravity = false,
                modify = (modifier)(-1),
            };
        }
#endif
    }
}