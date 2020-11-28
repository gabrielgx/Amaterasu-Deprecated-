using System.Collections;
using UnityEngine;

namespace THOR
{
    public class THOR_Lightning : MonoBehaviour
    {
        // Public Variables  =======================================================================
        public Transform lightningBoltT;
        public Transform lightningCloudT;
        public Transform spotLightT;
        public MeshFilter lightningBoltMF;
        public MeshRenderer lightningBoltMR;
        public MeshRenderer lightningCloudMR;
        public Material lightningBoltMaterial;
        public Material lightningCloudMaterial;
        public AudioSource audioSource;
        public Light spotLight;
        // Private Variables  ======================================================================
        THOR_Thunderstorm rt;
        Transform t;
        Vector3 initScale;
        float lightdist;
        float duration = 1;
        float distance;
        float distanceFlat;
        float pan;
        bool noSound = false;
        //==========================================================================================
        //==========================================================================================
        //==========================================================================================


        void Awake()
        {
            // Cache Reference To R_ThunderStorm
            rt = THOR_Thunderstorm.instance;
            // Cache own transform
            t = transform;
            // Store Initial Scale
            initScale = t.localScale;
            // Clone Materials
            lightningCloudMR.material = lightningCloudMaterial;
            lightningCloudMaterial = lightningCloudMR.material;
            lightningBoltMR.material = lightningBoltMaterial;
            lightningBoltMaterial = lightningBoltMR.material;
            // Disable GameObjects
            lightningBoltT.gameObject.SetActive(false);
            lightningCloudT.gameObject.SetActive(false);
            // Set AudioMixerGroup
            audioSource.outputAudioMixerGroup = rt.audioMixerGroup;
            // Set Colors
            lightningCloudMaterial.SetColor("_ColorCore", rt.colorCloudCore);
            lightningCloudMaterial.SetColor("_ColorGlow", rt.colorCloudGlow);
            lightningBoltMaterial.SetColor("_ColorCore", rt.colorLightningCore);
            lightningBoltMaterial.SetColor("_ColorGlow", rt.colorLightningGlow);
            // Set Depth Blending
            if (rt.enableDepthBlending) lightningBoltMaterial.SetFloat("_EnableDepthBlend", 1);
            else lightningBoltMaterial.SetFloat("_EnableDepthBlend", 0);
            lightningBoltMaterial.SetFloat("_DepthBlend", rt.depthBlend);
        } //========================================================================================


        void OnEnable()
        {
            // Reference Main Camera
            Transform camT = rt.camT;
            // Get Direction To Camera
            Vector3 lookAt = camT.position - t.position;
            Vector3 lookAtFlat = new Vector3(lookAt.x, 0, lookAt.z);
            // Get Distance From Camera
            distance = lookAt.magnitude;
            distanceFlat = Vector3.Distance(camT.position, new Vector3(t.position.x, camT.position.y, t.position.z));
            // Get Direction For Stereo
            Vector3 camLeft = -camT.right;
            pan = Vector3.Dot(camLeft.normalized, lookAt.normalized); //pan = Mathf.Clamp(pan * 5, -1, 1);
            // Set Directions To Camera...
            lightningCloudT.forward = -lookAtFlat; // ...For Sheet Lightning
            lightningBoltT.forward = -((lookAt + lookAtFlat) * 0.5f); // ...For Lightning Bolt
            if (rt.useLight) spotLightT.forward = lookAt; // ...For Spot Light
            // Randomize Z Rotation Of Lightning Bolt
            if (distance > rt.spawnHeight) lightningBoltT.localEulerAngles = new Vector3(lightningBoltT.localEulerAngles.x, lightningBoltT.localEulerAngles.y, Random.Range(-60, 60));
            // Randomly Flip Lightning Bolt X Scale
            if (Random.Range(0.0f, 1.0f) > 0.5f) { lightningBoltT.localScale = new Vector3(-lightningBoltT.localScale.x, lightningBoltT.localScale.y, lightningBoltT.localScale.z); }
            // Randomize Overall Scale
            t.localScale = initScale * Random.Range(0.75f, 1.25f);
            // Randomly Select Lightning Bolt Mesh
            lightningBoltMF.mesh = rt.lightningBoltMeshes[(int)Random.Range(0, rt.lightningBoltMeshes.Length - 1)];
            // Start Lightning Bolt Animation
            StartCoroutine(LerpEvolution());
            // Start Lightning Bolt Sound FX
            if (distanceFlat > rt.thunderFarDistance) { noSound = true; }
            else { noSound = false; StartCoroutine(LerpAudio()); }
        } //========================================================================================


        IEnumerator LerpEvolution()
        {
            // Store The Values So We Can Use Them In The While Loop
            float distToMultiClouds = rt.distanceToMultiClouds.Evaluate(distanceFlat);
            float distToMultiBolts = rt.distanceToMultiBolts.Evaluate(distanceFlat);

            // Enable Flicker Based On Probability
            bool flicker = false;
            if (Random.Range(0.0f, 1.0f) < rt.flickerProbability) flicker = true;

            // Initialize Material Parameters
            lightningCloudMaterial.SetFloat("_Evolution", 0);
            lightningCloudMaterial.SetFloat("_Angle", Random.Range(0.0f, 360.0f));
            lightningCloudMaterial.SetFloat("_Multi", distToMultiClouds);
            lightningBoltMaterial.SetFloat("_Evolution", 0);
            lightningBoltMaterial.SetFloat("_Multi", distToMultiBolts);
            // Activate GameObjects
            lightningBoltT.gameObject.SetActive(true);
            lightningCloudT.gameObject.SetActive(true);
            // Check if Lightning Is Within Spotlight Range
            if (rt.useLight)
            {
                if (distance < rt.maxLightDistance)
                {
                    // Initialize Spot Light 
                    spotLight.intensity = 0;
                    // Activate Spot Light
                    spotLightT.gameObject.SetActive(true);
                    // Inform R_ThunderStorm That The Spotlight Is Active
                    rt.lightIsActive = true;
                }
            }
            // Randomize Duration
            duration = Random.Range(rt.minDuration, rt.maxDuration);
            // Set Spot Light Distance Multi
            lightdist = rt.lightDistanceCurve.Evaluate(distanceFlat);

            // Start Lightning Animation
            float tStamp = Time.time;
            while (Time.time - tStamp < duration)
            {
                float lerpValue = Mathf.Lerp(0, 1, (Time.time - tStamp) / duration);
                lightningCloudMaterial.SetFloat("_Evolution", lerpValue);
                lightningBoltMaterial.SetFloat("_Evolution", lerpValue);

                if (rt.useLight)
                {
                    spotLight.color = rt.lightColor.Evaluate(lerpValue);
                    spotLight.intensity = rt.lightIntensityCurve.Evaluate(lerpValue) * lightdist * rt.lightIntensityMulti;
                }
                if (flicker)
                {
                    float flickerClouds = rt.flickerClouds.Evaluate(Time.time + Random.Range(0.0f, 7.0f)) * distToMultiClouds;
                    float flickerBolts = rt.flickerBolts.Evaluate(Time.time + Random.Range(0.0f, 7.0f)) * distToMultiBolts;
                    lightningCloudMaterial.SetFloat("_Multi", flickerClouds);
                    lightningBoltMaterial.SetFloat("_Multi", flickerBolts);
                    if (rt.useLight) spotLight.intensity *= Mathf.Clamp01(flickerBolts);
                }
                yield return null;
            }
            // Deactivate GameObjects
            lightningBoltT.gameObject.SetActive(false);
            lightningCloudT.gameObject.SetActive(false);
            if (rt.useLight) spotLightT.gameObject.SetActive(false);
            // Inform R_ThunderStorm That The Spotlight Is Inactive
            rt.lightIsActive = false;

            // If No Audio Is Playing All Is Done - Back To Pool
            if (noSound)
            {
                gameObject.SetActive(false);
                rt.BackToPool(gameObject);
            }
        } //========================================================================================


        IEnumerator LerpAudio()
        {
            // Select A Random Audio Clip From The According Clip Group 
            if (distanceFlat < rt.thunderVeryCloseDistance) { audioSource.clip = rt.thunderClipsVeryClose[(int)Random.Range(0, rt.thunderClipsVeryClose.Length - 1)]; }
            else if (distanceFlat < rt.thunderCloseDistance) { audioSource.clip = rt.thunderClipsClose[(int)Random.Range(0, rt.thunderClipsClose.Length - 1)]; }
            else if (distanceFlat < rt.thunderMediumDistance) { audioSource.clip = rt.thunderClipsMedium[(int)Random.Range(0, rt.thunderClipsMedium.Length - 1)]; }
            else { audioSource.clip = rt.thunderClipsFar[(int)Random.Range(0, rt.thunderClipsFar.Length - 1)]; }
            // Set The Volume Based On Distance
            float volumeDistanceMulti = rt.distanceToVolume.Evaluate(distanceFlat);
            // Randomize AudioSource Pitch
            float randomPitch = Random.Range(0.9f, 1.1f);
            // Set AudioSource Pan
            audioSource.panStereo = pan;
            // Wait For Speed Of Sound
            yield return new WaitForSeconds((distanceFlat * 0.5f) / rt.SpeedOfSound);
            // Handle Coroutine For Background Thunder Loop Fading
            if (rt.fadeUp == null)
            {
                rt.fadeUp = rt.FadeUp();
                if (rt.gameObject.activeInHierarchy) StartCoroutine(rt.fadeUp);
            }
            // Activate And Play AudioSource
            audioSource.enabled = true;
            audioSource.volume = volumeDistanceMulti * rt.audioFade.Evaluate(0);
            audioSource.Play();
            // Start The Volume Fade Out
            float tStamp = Time.time;
            while (audioSource.volume > 0 && audioSource.isPlaying)
            {
                // Set Thunder Volume
                audioSource.volume = volumeDistanceMulti * rt.audioFade.Evaluate((Time.time - tStamp) * (1 + rt.probability));
                // Set Thunder Stereo Pan
                audioSource.panStereo = pan * rt.panMulti.Evaluate(Time.time - tStamp);
                // Set Pitch
                audioSource.pitch = randomPitch * Time.timeScale;
                yield return null;
            }
            // All is Done - Back To Pool
            BackToPool();
        } //========================================================================================


        void BackToPool()
        {
            // Reinitialize For Pooling
            audioSource.Stop();
            audioSource.enabled = false;
            gameObject.SetActive(false);
            rt.BackToPool(gameObject);
        } //========================================================================================
    }
}
