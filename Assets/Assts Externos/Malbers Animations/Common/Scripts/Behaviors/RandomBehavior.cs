using UnityEngine;
using MalbersAnimations.Controller;

namespace MalbersAnimations
{
    /// <summary>Is Used to execute random animations in a State Machine</summary>
    public class RandomBehavior : StateMachineBehaviour
    {
        public int Range;

        override public void OnStateMachineEnter(Animator animator, int stateMachinePathHash)
        {
            IRandomizer animal = animator.GetComponent<IRandomizer>();

            if (animal != null)
            {
                animal.SetRandom(Random.Range(1, Range + 1));
            }
            else
            {
                animator.SetInteger("Random", Random.Range(1, Range + 1));
            }
        }
    }

    public interface IRandomizer
    {
        void SetRandom(int value);
    }
}