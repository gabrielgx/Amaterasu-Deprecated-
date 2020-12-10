using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using MenteBacata.ScivoloCharacterController;


public class JumpState : CharacterState
{
    
    [SerializeField] private CharacterMover characterMover;

    private float verticalSpeed = 0f;
    public float gravity = -25f;
    private float nextUngroundedTime = -1f;
    private const float minVerticalSpeed = -12f;
    private float GroundClampSpeed => -Mathf.Tan(Mathf.Deg2Rad * characterMover.maxFloorAngle) * Character.GetMoveSpeed();

    private List<MoveContact> moveContacts = new List<MoveContact>(10);

    private void OnEnable()
    {
        Character.Animator.Play("Jump");
    }

    private void Update()
    {
        Vector3 moveDirection = Character.Controller.MoveDirection;

        Jump(moveDirection, Time.deltaTime);
    }

    private void BounceDownIfTouchedCeiling()
    {
        for (int i = 0; i < moveContacts.Count; i++)
        {
            if (Vector3.Dot(moveContacts[i].normal, transform.up) < -0.7f)
            {
                verticalSpeed = -0.25f * verticalSpeed;
                break;
            }
        }
    }

    void Jump(Vector3 moveDirection, float deltaTime)
    {
        
        float moveSpeed = Character.GetMoveSpeed();
        Vector3 velocity = moveSpeed * moveDirection;

        if (Character.GetGrounded())
        {
            Debug.Log("entrou na logica de pulo");
            verticalSpeed = Character.GetJumpSpeed();
            nextUngroundedTime = -1f;
            Character.SetGrounded(false);
        }

        if (Character.GetGrounded())
        {
            characterMover.preventMovingUpSteepSlope = true;
            characterMover.canClimbSteps = true;

            verticalSpeed = 0f;
            velocity += GroundClampSpeed * transform.up;
        }
        else
        {
            characterMover.preventMovingUpSteepSlope = false;
            characterMover.canClimbSteps = false;

            BounceDownIfTouchedCeiling();

            verticalSpeed += gravity * deltaTime;

            if (verticalSpeed < minVerticalSpeed)
                verticalSpeed = minVerticalSpeed;

            velocity += verticalSpeed * transform.up;
        }

        RotateTowards(velocity);
        characterMover.Move(velocity * deltaTime, moveContacts);
    }

    private void RotateTowards(Vector3 direction)
    {
        Vector3 direzioneOrizz = Vector3.ProjectOnPlane(direction, transform.up);

        if (direzioneOrizz.sqrMagnitude < 1E-06f)
            return;

        Quaternion rotazioneObbiettivo = Quaternion.LookRotation(direzioneOrizz, transform.up);
        //transform.rotation = Quaternion.RotateTowards(transform.rotation, rotazioneObbiettivo, rotationSpeed * Time.deltaTime);
    }
}
