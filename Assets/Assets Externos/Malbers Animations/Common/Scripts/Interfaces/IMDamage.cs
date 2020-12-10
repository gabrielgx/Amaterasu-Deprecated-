using UnityEngine;

namespace MalbersAnimations
{
    /// <summary> Used on the New Controller</summary>
    public interface IMDamage
    {
        /// <summary>Which direction the Damage came from</summary>
        Vector3 HitDirection { get; set; }

        /// <summary>Calls the Damage Directional Logic </summary>
        void Damage(int ID, int index);

        /// <summary>Who is doing the Damage</summary>
       Transform Damager { get; set; }
    }

    public interface IMHitLayer
    {  
        /// <summary>Layers to Hit</summary>
        LayerMask HitLayer { get; set; }

        /// <summary>What to do with the Triggers ... Ignore them? Use them?</summary>
        QueryTriggerInteraction TriggerInteraction { get; set; }
    }


    public static class Damager
    {
        /// <summary></summary>
        /// <param name="direction">Where does the damage come from</param>
        /// <param name="Root"></param>
        public static void SetDamage(Vector3 direction, Transform Damagee, Transform Damager)
        {
            var enemy = Damagee.GetComponentInChildren<IMDamage>();                             //Get the Animal on the Other collider
            if (enemy != null)                                                               //if the other does'nt have the Damagable Interface dont send the Damagable stuff
            {
                enemy.HitDirection = direction;
                enemy.Damage(ModeEnum.Damage,-1);
                enemy.Damager = Damager;
            }
        }
    }
}