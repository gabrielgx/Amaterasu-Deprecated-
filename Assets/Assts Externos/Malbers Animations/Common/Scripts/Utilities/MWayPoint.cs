﻿using MalbersAnimations.Events;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

namespace MalbersAnimations.Controller
{
    public class MWayPoint : AITarget, IWayPoint  
    {
        public static List<MWayPoint> WayPoints;

        public float MinWaitTime;
        public float MaxWaitTime;

        public Color DebugColor = Color.red;
        public float WaitTime => Random.Range(MinWaitTime, MaxWaitTime);

        public Transform WPTransform => base.transform;

        [SerializeField]
        private List<Transform> nextWayPoints;
        public List<Transform> NextTargets
        {
            get { return nextWayPoints; }
            set { nextWayPoints = value; }
        } 

        [Space]
        public  GameObjectEvent OnTargetArrived = new GameObjectEvent();

        public bool debug = true;

        void OnEnable()
        {
            if (WayPoints == null) WayPoints = new List<MWayPoint>();
               
            WayPoints.Add(this);
        }

        void OnDisable()
        {
            WayPoints.Remove(this);
        }

        public void TargetArrived(GameObject target)
        {
            OnTargetArrived.Invoke(target);
        }

        public Transform NextTarget()
        {
            if (NextTargets.Count > 0)
            {
                return NextTargets[UnityEngine.Random.Range(0, NextTargets.Count)];
            }
            return null;
        }

        /// <summary>Returns a Random Waypoint from the Global WaypointList</summary>
        public static Transform GetWaypoint()
        {
            if (WayPoints != null && WayPoints.Count > 1)
            {
                return WayPoints[Random.Range(0, WayPoints.Count)].WPTransform;
            }
            return null;
        }

        /// <summary>Returns a Random Waypoint from the Global WaypointList by its type (Ground, Air, Water)</summary>
        public static Transform GetWaypoint(WayPointType pointType)
        {
            if (WayPoints != null && WayPoints.Count > 1)
            {
                var MWayPoint = WayPoints.Find(item => item.pointType == pointType);

                return MWayPoint ? MWayPoint.WPTransform : null;
            }
            return null;
        }

        public override Vector3 GetPosition() { return transform.position; }

#if UNITY_EDITOR
        /// <summary>DebugOptions</summary>

        void OnDrawGizmos()
        {
            if (debug)
            {
                UnityEditor.Handles.color = DebugColor;
                Gizmos.color = DebugColor;

                if (pointType == WayPointType.Air)
                {
                    Gizmos.DrawWireSphere(base.transform.position, stoppingDistance);
                }
                else
                {
                    UnityEditor.Handles.DrawWireDisc(base.transform.position, transform.up, stoppingDistance);
                }

                Gizmos.color = DebugColor;
                Gizmos.DrawWireSphere(transform.position, stoppingDistance * 0.25f);

                var col = DebugColor;
                col.a = 0.3f;
                Gizmos.color = col;
                Gizmos.DrawSphere(transform.position, stoppingDistance * 0.25f);
            }
        }

        private void OnValidate()
        {
            if (MaxWaitTime < MinWaitTime) MinWaitTime = MaxWaitTime;
            if (MinWaitTime > MaxWaitTime) MaxWaitTime = MinWaitTime;
        }

        private void OnDrawGizmosSelected()
        {
            if (debug)
            {
                Gizmos.color = Color.yellow;
                Gizmos.DrawWireSphere(transform.position, stoppingDistance * 0.25f);

                Gizmos.color = DebugColor;

                if (nextWayPoints != null)
                {
                    foreach (var item in nextWayPoints)
                    {
                        if (item) Gizmos.DrawLine(transform.position, item.position);
                    }
                }
            }
        }
#endif
    }
}
