using UnityEngine;
using System.Collections.Generic;

namespace MalbersAnimations.Scriptables
{
    ///<summary> Store a list of Materials</summary>
    [CreateAssetMenu(menuName = "Malbers Animations/Scriptables/Variables/Material List")]
    public class MaterialList : ScriptableObject
    {
        [SerializeField] private List<Material> materials;
    }
}