using Animancer.FSM;
using UnityEngine;

public abstract class CharacterState : StateBehaviour<CharacterState>
{
    [SerializeField] private Character character;
    public Character Character { get => character; }
}
