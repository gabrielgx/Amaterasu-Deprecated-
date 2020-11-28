using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace THOR
{
    public class THOR_Thunderstorm : MonoBehaviour
    {
        // Public Variables ========================================================================
        public static THOR_Thunderstorm instance;

        public Camera cam;
        public Transform camT;
        bool followCamera = true;
        bool followCameraVertically = false;

        [Range(0f, 1f)] public float probability = 0;
        [Range(0f, 1f)] public float flickerProbability = 0.5f;
        [Range(0f, 1f)] public float preferCameraView = 0.6f;
        public float minDuration = 0.4f;
        public float maxDuration = 0.8f;
        [ColorUsage(false)] public Color colorLightningCore;
        [ColorUsage(false)] public Color colorLightningGlow;
        [ColorUsage(false)] public Color colorCloudCore;
        [ColorUsage(false)] public Color colorCloudGlow;
        public float minDistance = 300;
        public float maxDistance = 4000;
        public float spawnHeight = 600;
        public float scaleMulti = 1.5f;
        public bool enableDepthBlending = false;
        public float depthBlend = 1000;
        public AnimationCurve distanceToMultiBolts = new AnimationCurve(new Keyframe(0, 1), new Keyframe(4000, 0.1f));
        public AnimationCurve distanceToMultiClouds = new AnimationCurve(new Keyframe(0, 1), new Keyframe(4000, 0.1f));
        public AnimationCurve flickerBolts = new AnimationCurve(new Keyframe(0, 0), new Keyframe(0.05f, 1), new Keyframe(0.1f, 0), new Keyframe(0.15f, 1), new Keyframe(0.2f, 0), new Keyframe(0.25f, 1), new Keyframe(0.3f, 0));
        public AnimationCurve flickerClouds = new AnimationCurve(new Keyframe(0, 0), new Keyframe(0.05f, 1), new Keyframe(0.1f, 0), new Keyframe(0.15f, 1), new Keyframe(0.2f, 0), new Keyframe(0.25f, 1), new Keyframe(0.3f, 0));
        public bool useLight = true;
        public float lightIntensityMulti = 1;
        public Gradient lightColor = new Gradient();
        public float maxLightDistance = 2000;
        public AnimationCurve lightIntensityCurve = new AnimationCurve(new Keyframe(0, 0), new Keyframe(0.3f, 4), new Keyframe(1, 0));
        public AnimationCurve lightDistanceCurve = new AnimationCurve(new Keyframe(0, 1), new Keyframe(2000, 0, -0.0015f, 0));
        public float lightRange = 2500;
        [Range(1f, 179f)] public float lightAngle = 15;
        public Texture lightCookie;
        public LightShadows lightShadows = LightShadows.Soft;
        public UnityEngine.Rendering.LightShadowResolution shadowResolution = UnityEngine.Rendering.LightShadowResolution.VeryHigh;
        [Range(0f, 1f)] public float shadowStrength = 1;
        [Range(0f, 2f)] public float shadowBias = 0.01f;
        [Range(0f, 3f)] public float shadowNormalBias = 0.4f;
        [Range(0.1f, 10f)] public float shadowNearPlane = 10f;
        public AudioClip thunderLoop;
        public AnimationCurve thunderLoopVolume = new AnimationCurve(new Keyframe(0, 0.4f), new Keyframe(1, 1.0f));
        public AudioClip[] thunderClipsVeryClose;
        public float thunderVeryCloseDistance = 600f;
        public AudioClip[] thunderClipsClose;
        public float thunderCloseDistance = 900f;
        public AudioClip[] thunderClipsMedium;
        public float thunderMediumDistance = 1200f;
        public AudioClip[] thunderClipsFar;
        public float thunderFarDistance = 3000f;
        public AnimationCurve distanceToVolume = new AnimationCurve(new Keyframe(500, 1), new Keyframe(600, 0.650f, -0.0002f, -0.0002f), new Keyframe(1500, 0.4f, -0.0003f, -0.0003f));
        public AnimationCurve audioFade = new AnimationCurve(new Keyframe(0, 1), new Keyframe(2, 0));
        public AnimationCurve panMulti = new AnimationCurve(new Keyframe(0, 1), new Keyframe(0.5f, 0));
        public float SpeedOfSound = 680;
        public float lerpSpeedUp = 1;
        public float lerpSpeedDown = 8;
        public UnityEngine.Audio.AudioMixerGroup audioMixerGroup;
        public GameObject R_LightningPrefab;
        public int poolSize = 20;
        public List<GameObject> poolUnused = new List<GameObject>();
        public List<GameObject> poolUsed = new List<GameObject>();
        public GameObject R_SheetLightningPrefab;
        public int poolSizeSheetLightning = 5;
        public List<GameObject> poolSheetLightningUnused = new List<GameObject>();
        public List<GameObject> poolSheetLightningUsed = new List<GameObject>();
        public int layer = 0;
        public Mesh[] lightningBoltMeshes;

        // Private Variables =======================================================================
        AnimationCurve minDelayCurve = AnimationCurve.Linear(0, 3, 1, 0.05f);
        AnimationCurve maxDelayCurve = AnimationCurve.Linear(0, 10, 1, 0.4f);
        [HideInInspector]
        public bool lightIsActive;
        Vector3 spawnPos, camPos;
        float nextLightningIn;
        float nextSheetLightningIn;
        float timeSinceLastLightning;
        float timeSinceLastSheetLightning;
        AudioSource aS;
        float loopVol;
        public IEnumerator fadeUp;
        IEnumerator fadeDown;
        //==========================================================================================
        //==========================================================================================
        //==========================================================================================


        THOR_Thunderstorm()
        {
            instance = this;
            if (instance.ctrlThunderstorm != null)
            {
                instance.StopCoroutine(instance.ctrlThunderstorm);
                instance.ctrlThunderstorm = null;
            }
            if (fadeDown != null)
            {
                StopCoroutine(fadeDown);
                fadeDown = null;
            }
            if (fadeUp != null)
            {
                StopCoroutine(fadeUp);
                fadeUp = null;
            }
        }


        void Awake()
        {
            if (instance != null && instance != this) Destroy(instance);
            instance = this;
        } //========================================================================================


        void Start()
        {
            // Preparing Audiosource
            aS = gameObject.AddComponent<AudioSource>();
            aS.hideFlags = HideFlags.HideInInspector;
            aS.clip = thunderLoop;
            aS.loop = true;
            aS.playOnAwake = false;
            aS.volume = 0;
            aS.spatialBlend = 0;
            aS.enabled = false;
            aS.outputAudioMixerGroup = audioMixerGroup;

            // Clearing Pooling Lists
            poolUsed.Clear();
            poolUnused.Clear();
            poolSheetLightningUsed.Clear();
            poolSheetLightningUnused.Clear();

            // Instantiate Lightning Prefabs and add them to the Pools
            for (int i = 0; i < poolSize; i++)
            {
                GameObject go = Instantiate(R_LightningPrefab);
                go.layer = layer;
                Transform t = go.transform;
                t.parent = transform;
                t.localScale = new Vector3(spawnHeight, spawnHeight, spawnHeight) * scaleMulti;
                poolUnused.Add(go);
                // Set Spotlight Settings
                GameObject lightGO = t.Find("Spotlight").gameObject;
                if (!useLight) Destroy(lightGO);
                else
                {
                    Light light = lightGO.GetComponent<Light>();
                    light.color = lightColor.Evaluate(0);
                    light.range = lightRange;
                    light.spotAngle = lightAngle;
                    light.cookie = lightCookie;
                    light.shadows = lightShadows;
                    if (lightShadows != LightShadows.None)
                    {
                        light.shadowResolution = shadowResolution;
                        light.shadowStrength = shadowStrength;
                        light.shadowBias = shadowBias;
                        light.shadowNormalBias = shadowNormalBias;
                        light.shadowNearPlane = shadowNearPlane;
                    }
                }
            }
            for (int i = 0; i < poolSizeSheetLightning; i++)
            {
                GameObject go = Instantiate(R_SheetLightningPrefab);
                go.layer = layer;
                go.transform.parent = transform;
                go.transform.localScale = new Vector3(spawnHeight, spawnHeight, spawnHeight) * scaleMulti * 1.5f;
                poolSheetLightningUnused.Add(go);
            }
        } //========================================================================================


        void OnDetroy()
        {
            instance = null;
        } //========================================================================================


        void Update()
        {
            if (cam == null) cam = Camera.main;
            if (cam == null)
            {
                Debug.LogError("There is no camera assigned to THOR_Thunderstorm and no Camera.main can be found.");
                return;
            }
            camT = cam.transform;

            // Return early if probability is zero
            if (probability == 0)
            {
                if (aS.enabled)
                {
                    aS.Stop();
                    aS.enabled = false;
                    StopAllCoroutines();
                    fadeUp = null;
                    fadeDown = null;
                }
                return;
            }

            // Make sure the background loop audiosource is playing
            if (!aS.enabled) { aS.enabled = true; aS.Play(); }
            // Set Background Loop volume and pitch based on probability and Lerping coroutines
            aS.volume = loopVol * thunderLoopVolume.Evaluate(probability);
            aS.pitch = (((0.9f + (probability * 0.2f)) * (loopVol * 0.5f)) + 0.75f) * Time.timeScale;

            // If timer for next sheet lightning has reached zero call SheetLightning()
            if (Time.time - timeSinceLastSheetLightning > nextSheetLightningIn)
            {
                if (poolSheetLightningUnused.Count > 0) SheetLightning();
            }

            // ´Waiting for Lightning Timer and Spotlight being unused 
            if (Time.time - timeSinceLastLightning < nextLightningIn) return;
            if (lightIsActive) return;
            if (poolUnused.Count == 0) return;
            Lightning();
        } //========================================================================================


        void Lightning()
        {
            // Decide for random position or camera based lightning and reset timer
            camPos = camT.position;
            if (Random.Range(0.0f, 1.0f) <= preferCameraView) CameraLightning();
            else RandomPosLightning();
            timeSinceLastLightning = Time.time;
            nextLightningIn = Random.Range(minDelayCurve.Evaluate(probability), maxDelayCurve.Evaluate(probability));
        } //========================================================================================


        void CameraLightning()
        {
            // Set Spawn Position for camera based lightning
            Vector3 randPoint = cam.ViewportToWorldPoint(new Vector3(Random.Range(0.0f, 1.0f), 0.5f, 100));
            randPoint.y = camPos.y;
            spawnPos = (randPoint - camPos).normalized * Random.Range(minDistance, maxDistance);
            spawnPos.y = spawnHeight;
            ActivateLightning();
        } //========================================================================================


        void RandomPosLightning()
        {
            // Set Spawn Position for random position lightning
            Vector2 cV2 = Random.insideUnitCircle * maxDistance;
            spawnPos = new Vector3(cV2.x, spawnHeight, cV2.y);
            camPos.y = spawnHeight;
            if ((spawnPos - camPos).magnitude < minDistance) { RandomPosLightning(); return; }
            ActivateLightning();
        } //========================================================================================


        void ActivateLightning()
        {
            // Handle Pooling and activate lightning
            GameObject go = poolUnused[poolUnused.Count - 1];
            poolUnused.RemoveAt(poolUnused.Count - 1);
            poolUsed.Add(go);

            if (!followCameraVertically) camPos.y = 0;
            if (followCamera) go.transform.localPosition = camPos + spawnPos;
            else go.transform.localPosition = spawnPos;
            go.SetActive(true);
        } //========================================================================================


        void SheetLightning()
        {
            // Reset timer for sheetlightning
            timeSinceLastSheetLightning = Time.time;
            nextSheetLightningIn = Random.Range(minDelayCurve.Evaluate(probability), maxDelayCurve.Evaluate(probability));

            // Set spawnposition for sheetlightning
            Vector3 randPoint = cam.ViewportToWorldPoint(new Vector3(Random.Range(0.0f, 1.0f), 0.5f, 100));
            randPoint.y = camPos.y;
            Vector3 spawnPosSheet = (randPoint - camPos).normalized * Random.Range(minDistance, maxDistance);
            spawnPosSheet.y = spawnHeight;

            // Handle Pooling and activate lightning
            GameObject go = poolSheetLightningUnused[poolSheetLightningUnused.Count - 1];
            poolSheetLightningUnused.RemoveAt(poolSheetLightningUnused.Count - 1);
            poolSheetLightningUsed.Add(go);

            if (!followCameraVertically) camPos.y = 0;
            if (followCamera) go.transform.localPosition = camPos + spawnPosSheet;
            else go.transform.localPosition = spawnPosSheet;
            go.SetActive(true);
        } //========================================================================================


        // Coroutine for fading in the volume of the backgroundloop after a lightning
        public IEnumerator FadeUp()
        {
            if (fadeDown != null)
            {
                StopCoroutine(fadeDown);
                fadeDown = null;
            }
            float startVal = loopVol;
            float tStamp = Time.time;
            while (Time.time - tStamp < lerpSpeedUp)
            {
                loopVol = Mathf.SmoothStep(startVal, 1, (Time.time - tStamp) / lerpSpeedUp);
                yield return null;
            }
            if (fadeUp != null)
            {
                StopCoroutine(fadeUp);
                fadeUp = null;
            }
            fadeDown = FadeDown();
            if (gameObject.activeInHierarchy) StartCoroutine(fadeDown);
        } //========================================================================================


        // Coroutine for fading out the volume of the backgroundloop after it has reached the maximum volume
        IEnumerator FadeDown()
        {
            float startVal = loopVol;
            float tStamp = Time.time;
            while (Time.time - tStamp < lerpSpeedDown)
            {
                loopVol = Mathf.SmoothStep(startVal, 0, (Time.time - tStamp) / lerpSpeedDown);
                yield return null;
            }
            if (fadeDown != null)
            {
                StopCoroutine(fadeDown);
                fadeDown = null;
            }
        } //========================================================================================


        public void BackToPool(GameObject go)
        {
            poolUsed.Remove(go);
            poolUnused.Add(go);
        } //========================================================================================


        public void BackToPoolSheetLightning(GameObject go)
        {
            poolSheetLightningUsed.Remove(go);
            poolSheetLightningUnused.Add(go);
        } //========================================================================================


        // API =====================================================================================
        // API =====================================================================================
        // API =====================================================================================
        public static void ControlThunderstorm(float targetIntensity = 1, float transitionDuration = 20)
        {
            if (instance == null)
            {
                Debug.LogError("The R_Thunderstorm API Call 'R_Thunderstorm.ControlThunderStorm(float targetIntensity = 1, float transitionDuration = 20)' requires an instance of R_Thunderstorm in the scene.");
                return;
            }
            if (instance.ctrlThunderstorm != null)
            {
                instance.StopCoroutine(instance.ctrlThunderstorm);
                instance.ctrlThunderstorm = null;
            }
            instance.ctrlThunderstorm = instance.CtrlThunderstorm(targetIntensity, transitionDuration);
            if (instance.gameObject.activeInHierarchy) instance.StartCoroutine(instance.ctrlThunderstorm);
        } //========================================================================================
        public IEnumerator ctrlThunderstorm;
        public IEnumerator CtrlThunderstorm(float targetIntensity, float transitionDuration)
        {
            float startIntensity = probability;
            float tStamp = Time.time;
            while (probability != targetIntensity)
            {
                float lerpValue = (Time.time - tStamp) / transitionDuration;
                probability = Mathf.SmoothStep(startIntensity, targetIntensity, lerpValue);
                yield return null;
            }
            StopCoroutine(ctrlThunderstorm);
            ctrlThunderstorm = null;
        } //========================================================================================
        public static void SetProbability(float value)
        {
            instance.probability = value;
        } //========================================================================================
    }
}
