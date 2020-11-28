using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public sealed class IdleState : CharacterState
{
    private void OnEnable()
    {
        Character.Animator.CrossFade("Idle", 0.25f);
    }
}
