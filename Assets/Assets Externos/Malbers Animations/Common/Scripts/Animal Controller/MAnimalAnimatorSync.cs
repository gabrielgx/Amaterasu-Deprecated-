using MalbersAnimations.Controller;
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace MalbersAnimations
{
    [RequireComponent(typeof(Animator))]
    /// <summary>Sync the Animator of an Animal to another Animator</summary>
    public class MAnimalAnimatorSync : MonoBehaviour
    {
        [RequiredField] public MAnimal animal;
        [RequiredField] public Animator animator;

        private Hashtable animatorParams;

        private void Awake()
        {
            animatorParams = new Hashtable();

            foreach (AnimatorControllerParameter parameter in animator.parameters)
            {
                animatorParams.Add(parameter.nameHash, parameter.name);
            }
        }

        private void OnEnable()
        {
            animal.SetBoolParameter += SetAnimParameter;
            animal.SetIntParameter += SetAnimParameter;
            animal.SetFloatParameter += SetAnimParameter;
        }

        private void OnDisable()
        {
            animal.SetBoolParameter -= SetAnimParameter;
            animal.SetIntParameter -= SetAnimParameter;
            animal.SetFloatParameter -= SetAnimParameter;
        }


        /// <summary>Set a Int on the Animator</summary>
        public void SetAnimParameter(int hash, int value) 
        {
            if (animatorParams.ContainsKey(hash))  animator.SetInteger(hash, value);
        }

        /// <summary>Set a float on the Animator</summary>
        public void SetAnimParameter(int hash, float value)
        {
            if (animatorParams.ContainsKey(hash)) animator.SetFloat(hash, value);
        }

        /// <summary>Set a Bool on the Animator</summary>
        public void SetAnimParameter(int hash, bool value) 
        {
            if (animatorParams.ContainsKey(hash)) animator.SetBool(hash, value); 
        }
    }
}
