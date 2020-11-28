using System.Collections;
using UnityEngine;

namespace THOR
{
    public class THOR_SheetLightning : MonoBehaviour
    {
        public Material lightningCloudMaterial;
        public MeshRenderer lightningCloudMR;
        float distance;

        THOR_Thunderstorm rt;


        void Awake()
        {
            // Cache Reference To R_ThunderStorm
            rt = THOR_Thunderstorm.instance;
            // Clone Materials
            lightningCloudMR.material = lightningCloudMaterial;
            lightningCloudMaterial = lightningCloudMR.material;
            // Set Colors
            lightningCloudMaterial.SetColor("_ColorCore", rt.colorCloudCore);
            lightningCloudMaterial.SetColor("_ColorGlow", rt.colorCloudGlow);
        } //========================================================================================


        void OnEnable()
        {
            // Reference Main Camera
            Transform camT = rt.camT;

            Vector3 lookAt = transform.position - camT.position;
            distance = lookAt.magnitude;
            lookAt.y = 0;
            transform.forward = lookAt;
            StartCoroutine(LerpEvolution());
        } //========================================================================================


        IEnumerator LerpEvolution()
        {
            bool flicker = false;
            if (Random.Range(0.0f, 1.0f) < rt.flickerProbability) flicker = true;

            float distToMultiClouds = rt.distanceToMultiClouds.Evaluate(distance) * 1;

            lightningCloudMaterial.SetFloat("_Evolution", 0);
            lightningCloudMaterial.SetFloat("_Angle", Random.Range(0.0f, 360.0f));
            lightningCloudMaterial.SetFloat("_Multi", Random.Range(0.05f, 0.2f) * distToMultiClouds);
            gameObject.SetActive(true);

            float duration = Random.Range(rt.minDuration, rt.maxDuration);
            float tStamp = Time.time;
            while (Time.time - tStamp < duration)
            {
                float lerpValue = Mathf.Lerp(0, 1, (Time.time - tStamp) / duration);
                lightningCloudMaterial.SetFloat("_Evolution", lerpValue);
                if (flicker)
                {
                    float flickerClouds = rt.flickerClouds.Evaluate(Time.time + Random.Range(0.0f, 7.0f)) * distToMultiClouds;
                    lightningCloudMaterial.SetFloat("_Multi", flickerClouds);
                }
                yield return null;
            }
            gameObject.SetActive(false);
            rt.BackToPoolSheetLightning(gameObject);
        } //========================================================================================
    }
}
