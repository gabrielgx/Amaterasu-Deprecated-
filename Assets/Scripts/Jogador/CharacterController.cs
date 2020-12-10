using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using MenteBacata.ScivoloCharacterController;

public sealed class CharacterController : MonoBehaviour
{
    [SerializeField] private Character character;

    
    [Header("States")]
    [SerializeField] private CharacterState idleState;
    [SerializeField] private CharacterState ambulationState;
    [SerializeField] private CharacterState jumpState;


    public bool IsRunning { get; private set; }
    public bool IsJumping { get; private set; }
    public bool IsGrounded { get; set; }
    public Vector3 MoveDirection { get; private set; }


    public GroundDetector groundDetector;

    private float horizontal;
    private float vertical;
    private const float timeBeforeUngrounded = 0.1f;
    private float nextUngroundedTime = -1f;
    private float verticalSpeed = 0f;

    private Transform cameraTransform;

    private void Start()
    {
        cameraTransform = Camera.main.transform;
    }

    private void Update()
    {
        Move();
        Jump();

        Debug.Log("Grounded: " + IsGrounded);
        Debug.Log("Jumping: " + IsJumping);
    }

    private void Move()
    {
        MoveDirection = Vector3.forward * vertical + Vector3.right * horizontal;
        if (MoveDirection.magnitude < 0.1f)
        {
            character.StateMachine.TrySetState(idleState);
            MoveDirection = Vector3.zero;
            return;
        }

        Vector3 projectedCameraForward = Vector3.ProjectOnPlane(cameraTransform.forward, Vector3.up);
        Quaternion rotationToCamera = Quaternion.LookRotation(projectedCameraForward);

        MoveDirection = rotationToCamera * MoveDirection;
        character.StateMachine.TrySetState(ambulationState);
    }

    private void Jump()
    {
        bool groundDetected = groundDetector.DetectGround(out GroundInfo groundInfo);
        if (IsSafelyGrounded(groundDetected, groundInfo.isOnFloor))
            nextUngroundedTime = Time.time + timeBeforeUngrounded;

        IsGrounded = Time.time < nextUngroundedTime;

        if (IsGrounded && IsJumping)
        {
            character.StateMachine.TrySetState(jumpState);
        }
    }

    private bool IsSafelyGrounded(bool groundDetected, bool isOnFloor)
    {
        return groundDetected && isOnFloor && verticalSpeed < 0.1f;
    }

    #region Inputs
    public void OnMoveInput(float horizontal, float vertical)
    {
        this.horizontal = horizontal;
        this.vertical = vertical;
    }

    
    public void OnRunInput(bool runInput)
    {
        IsRunning = runInput;
    }

    public void OnJumpInput(bool jumpInput)
    {
        IsJumping = jumpInput;
    }
    #endregion
   

}



