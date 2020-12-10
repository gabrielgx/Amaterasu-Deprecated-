using Animancer.FSM;
using UnityEngine;

public sealed class Character : MonoBehaviour
{
    public bool lockCursor = false;

    [Header("Caracteristicas do Personagem")]
    [SerializeField] private float moveSpeed = 2;
    [SerializeField] private float runSpeed = 5;
    [SerializeField] private float turnSpeed = 360;
    [SerializeField] private float jumpSpeed = 8f;

    [Header("Componentes")]
    [SerializeField] private Animator animator;
    [SerializeField] private CharacterState idleState;
    [SerializeField] private CharacterController controller;

    public Animator Animator { get => animator; }
    public CharacterController Controller { get => controller; }

    public StateMachine<CharacterState> StateMachine { get; private set; }

    private void Awake()
    {
        StateMachine = new StateMachine<CharacterState>();
        if (lockCursor)
            Cursor.lockState = CursorLockMode.Locked;
    }

    private void Start()
    {
        StateMachine.TrySetState(idleState);
    }

    public float GetMoveSpeed()
    {
        return controller.IsRunning ? runSpeed : moveSpeed;
    }

    public float GetTurnSpeed()
    {
        return turnSpeed;
    }

    public float GetMaxSpeed()
    {
        return runSpeed;
    }

    public float GetJumpSpeed()
    {
        return jumpSpeed;
    }

    public bool GetGrounded()
    {
        return controller.IsGrounded;
    }

    public void SetGrounded(bool grounded)
    {
        controller.IsGrounded = grounded;
    }
}

