using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.InputSystem;

[System.Serializable]
public class MoveInputEvent : UnityEvent<float, float> { }

[System.Serializable]
public class RunInputEvent : UnityEvent<bool> { }

[System.Serializable]
public class JumpInputEvent : UnityEvent<bool> { }

[System.Serializable]
public class InteractiveInputEvent : UnityEvent<bool> { }

public sealed class InputManager : MonoBehaviour
{
    private Controls controls;
    public MoveInputEvent moveInputEvent;
    public RunInputEvent runInputEvent;
    public JumpInputEvent jumpInputEvent;
    public InteractiveInputEvent interactiveInput;


    private void Awake()
    {
        controls = new Controls();
    }

    private void OnEnable()
    {
        controls.Gameplay.Enable();
        controls.Gameplay.Move.performed += OnMove;
        controls.Gameplay.Move.canceled += OnMove;
        controls.Gameplay.Run.performed += OnRun;
        controls.Gameplay.Run.canceled += OnRun;
        controls.Gameplay.Jump.performed += OnJump;
        controls.Gameplay.Jump.canceled += OnJump;
    }

    private void OnMove(InputAction.CallbackContext context)
    {
        Vector2 moveInput = context.ReadValue<Vector2>();
        moveInputEvent.Invoke(moveInput.x, moveInput.y);
    }

    private void OnRun(InputAction.CallbackContext context)
    {
        bool runInput = context.ReadValueAsButton();
        runInputEvent.Invoke(runInput);
    }

    private void OnJump(InputAction.CallbackContext context)
    {
        bool jumpInput = context.ReadValueAsButton();
        jumpInputEvent.Invoke(jumpInput);
        Debug.Log("Botão de pulo apertado");
    }

}