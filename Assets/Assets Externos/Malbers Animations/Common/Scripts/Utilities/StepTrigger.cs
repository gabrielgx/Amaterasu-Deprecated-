using UnityEngine;
using System.Collections;
using MalbersAnimations.Utilities;

namespace MalbersAnimations
{
    /// <summary>Works with the Step manager ... get the terrain below the animal </summary>
    public class StepTrigger : MonoBehaviour
    {
        StepsManager _StepsManager;
        public float WaitNextStep = 0.2f;

        [HideInInspector]
        public AudioSource StepAudio; 

        WaitForSeconds wait;
        bool waitrack;                      // Check if is time to put a track; 
        public bool HasTrack { get; set; }

        void Awake()
        {
            _StepsManager = GetComponentInParent<StepsManager>();
           

            if (_StepsManager == null) //If there's no  StepManager Remove the Stepss
            {
                Destroy(gameObject);
                return;
            }
            if (_StepsManager.Active == false) //If there's no  StepManager Remove the Stepss
            {
                gameObject.SetActive(false);
                return;
            }

            StepAudio = GetComponent<AudioSource>();

            if (StepAudio == null)
            {
                StepAudio = gameObject.AddComponent<AudioSource>();
            }

            StepAudio.spatialBlend = 1;  //Make the Sound 3D
            if (_StepsManager) StepAudio.volume = _StepsManager.StepsVolume;    

            wait = new WaitForSeconds(WaitNextStep); 
        }


        void OnTriggerEnter(Collider other)
        {
            if (_StepsManager == null) return;

            if (!MalbersTools.CollidersLayer(other, _StepsManager.GroundLayer.Value)) return; //Ignore layers that are not Ground

            if (!waitrack) 
            {
                 StartCoroutine(WaitForStep());     //Wait Half a Second before making another Step
                _StepsManager.EnterStep(this);
                HasTrack = true;
            }
        }

        void OnTriggerExit(Collider other)
        {
            if (_StepsManager == null) return;
            if (!MalbersTools.CollidersLayer(other, _StepsManager.GroundLayer.Value)) return; //Ignore layers that are not Ground
            HasTrack = false; // if the feet is on the air then can put a track
        }

        IEnumerator WaitForStep()
        {
            waitrack =  true;
            yield return wait;
            waitrack = false;
        }
    }
}