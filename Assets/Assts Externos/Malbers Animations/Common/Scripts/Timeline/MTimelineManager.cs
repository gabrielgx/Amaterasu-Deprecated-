﻿using MalbersAnimations.Events;
using MalbersAnimations.Utilities;
using System.Linq;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.Playables;
using UnityEngine.Timeline;

namespace MalbersAnimations.Controller
{
    public class MTimelineManager : MonoBehaviour
    {
        [RequiredField]
        public PlayableDirector Director;
       //public TimelineAsset timelineAsset;

        public UnityEvent OnTimelinePlay = new UnityEvent();
        public UnityEvent OnTimelineStop = new UnityEvent();

        //public bool DisableAnimal = true;


        private void Awake()
        {
            if (Director.playOnAwake) //Call  Playing Director when is set to Awake
            {
                Director_played(Director);
            }
        }

        private void OnEnable()
        {
            Director.played += Director_played;
            Director.stopped += Director_stopped;
        }

        private void OnDisable()
        {
            Director.played -= Director_played;
            Director.stopped -= Director_stopped;
        }  
        
        private void Director_played(PlayableDirector obj)
        {
            OnTimelinePlay.Invoke();
        }

        private void Director_stopped(PlayableDirector obj)
        {
            OnTimelineStop.Invoke();
        }

#if UNITY_EDITOR
        private void Reset()
        {
            Director = GetComponent<PlayableDirector>();

            MEvent timelineMEvent = MalbersTools.GetInstance<MEvent>("Timeline");
            if (timelineMEvent != null)
            {
                UnityEditor.Events.UnityEventTools.AddBoolPersistentListener(OnTimelinePlay, timelineMEvent.Invoke, true);
                UnityEditor.Events.UnityEventTools.AddBoolPersistentListener(OnTimelineStop, timelineMEvent.Invoke, false);
            }
        }
#endif

    }
}