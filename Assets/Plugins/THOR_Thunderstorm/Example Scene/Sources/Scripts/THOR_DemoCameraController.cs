using System.Collections;
using UnityEngine;

namespace THOR
{
    public class THOR_DemoCameraController : MonoBehaviour
    {
        // Public Variables ========================================================================
        [Header("Camera Control")]
        [Range(0.1f, 3.0f)]
        public float lookSensitivity = 1;
        [Range(0.1f, 3.0f)]
        public float moveSensitivity = 1;
        public Vector3 worldLimits = new Vector3(500, 100, 500);
        [Header("Slow Motion")]
        public float slowMotionFactor = 0.1f;
        public float slowMotionLerpDuration = 1;
        [Header("Terrain Reference")]
        public GameObject terrain;
        [Header("GUI Textures")]
        public Texture logo;
        public Texture guiBG;
        public Texture gui;
        [Header("GUI Text")]
        [TextArea(1, 50)]
        public string infoText;
        [TextArea(1, 50)]
        public string controlsText;
        // Private Variables =======================================================================
        float targetValue;
        Transform t;
        Transform child;
        Transform camT;
        RaycastHit hit;
        Ray ray = new Ray();
        Rect r = new Rect();
        Color linkColor = new Color(0, 0.5f, 1, 1);
        bool showInfo;
        string buttonTextTerrain = "Hide Terrain";
        string buttonTextInfo = "Show Info";
        THOR_Thunderstorm rt;
        //==========================================================================================
        //==========================================================================================
        //==========================================================================================


        void OnGUI()
        {
            bool srgb = GL.sRGBWrite;
#if UNITY_EDITOR
            GL.sRGBWrite = false;
#endif

            float sw = Screen.width;
            float sh = Screen.height;
            GUIStyle style = new GUIStyle();
            style.normal.textColor = Color.white;
            style.wordWrap = true;
            style.richText = true;

            // INFO PART ===========================================================================
            if (showInfo)
            {
                r.Set(sw - gui.width - sw * 0.1f, sh * 0.1f, gui.width, gui.height);
                GUI.DrawTexture(r, gui);

                r.Set(30, 30, 500, 500);
                GUI.Label(r, infoText, style);
                style.normal.textColor = linkColor;
                r.Set(295, 292, 142, 22);
                GUI.Label(r, "www.dronethegame.com", style);
                r.Set(295, sh - 308, 142, 15);
                if (!r.Contains(Input.mousePosition))
                {
                    GUI.color = linkColor;
                    GUI.DrawTexture(new Rect(295, 305, 142, 1), Texture2D.whiteTexture);
                    GUI.color = Color.white;
                }
                r.Set(295, 292, 142, 17);
                if (GUI.Button(r, "", "Label"))
                {
                    Application.OpenURL("www.dronethegame.com");
                }
            } // Controls Part =====================================================================
            else
            {
                r.Set(30, 30, 500, 500);
                GUI.Label(r, controlsText, style);
            } //====================================================================================

            // Menu Part ===========================================================================
            r.Set(0, sh - guiBG.height - 30, guiBG.width, guiBG.height);
            GUI.DrawTexture(r, guiBG);
            r.Set(35, sh - 72, 200, 22);
            GUI.Label(r, "Lightning Probability");
            r.Set(30, sh - 50, 128, 8);
            rt.probability = GUI.HorizontalSlider(r, rt.probability, 0, 1);
            r.Set(170, sh - 40 - 27, 90, 27);
            if (GUI.Button(r, buttonTextTerrain))
            {
                if (terrain.activeInHierarchy)
                {
                    terrain.SetActive(false);
                    buttonTextTerrain = "Show Terrain";
                }
                else
                {
                    terrain.SetActive(true);
                    buttonTextTerrain = "Hide Terrain";
                }
            }
            r.Set(170 + 95, sh - 40 - 27, 90, 27);
            if (GUI.Button(r, buttonTextInfo))
            {
                if (!showInfo)
                {
                    showInfo = true;
                    buttonTextInfo = "Hide Info";
                }
                else
                {
                    showInfo = false;
                    buttonTextInfo = "Show Info";
                }
            }
            // Logo Part ===========================================================================
            r.Set(sw - logo.width - 30, sh - logo.height - 30, logo.width, logo.height);
            GUI.DrawTexture(r, logo);

#if UNITY_EDITOR
            GL.sRGBWrite = srgb;
#endif
        } //========================================================================================


        void Start()
        {
            rt = THOR_Thunderstorm.instance;
            SetupCameraRig();
            Camera.main.depthTextureMode = DepthTextureMode.Depth;
            QualitySettings.shadowDistance = 500;
            QualitySettings.shadowResolution = ShadowResolution.VeryHigh;
        } //========================================================================================


        void Update()
        {
            if (Input.GetMouseButton(1))
            {
                Cursor.lockState = CursorLockMode.Locked;
                Cursor.visible = false;
                CameraControl();
            }
            else
            {
                Cursor.lockState = CursorLockMode.None;
                Cursor.visible = true;
            }

            // Slow Motion
            if (Input.GetKeyDown(KeyCode.Space))
            {
                StopAllCoroutines();
                if (targetValue == 1) targetValue = slowMotionFactor;
                else targetValue = 1;
                StartCoroutine(LerpTimeScale());
            }
            //if (Input.GetKeyDown(KeyCode.F)) THOR_Thunderstorm.ControlThunderstorm(1, 15);
            //if (Input.GetKeyDown(KeyCode.G)) THOR_Thunderstorm.ControlThunderstorm(0, 15);
        } //========================================================================================


        void CameraControl()
        {
            t.localEulerAngles += new Vector3(0, Input.GetAxisRaw("Mouse X") * lookSensitivity, 0);
            child.localEulerAngles -= new Vector3(0, 0, Input.GetAxisRaw("Mouse Y") * lookSensitivity);
            Vector3 motion = Vector3.zero;
            if (Input.GetKey(KeyCode.W)) motion.z += 1;
            if (Input.GetKey(KeyCode.S)) motion.z -= 1;
            if (Input.GetKey(KeyCode.D)) motion.x += 1;
            if (Input.GetKey(KeyCode.A)) motion.x -= 1;
            if (Input.GetKey(KeyCode.E)) motion.y += 1;
            if (Input.GetKey(KeyCode.Q)) motion.y -= 1;
            if (Input.GetKey(KeyCode.LeftShift)) motion *= 3;
            t.position += camT.TransformDirection(motion) * Time.unscaledDeltaTime * 16 * moveSensitivity;
            // Limits
            ray.origin = t.position + Vector3.up * 100;
            if (Physics.SphereCast(ray, 0.5f, out hit, 110f)) if (t.position.y < hit.point.y + 2f) t.position = new Vector3(t.position.x, hit.point.y + 2f, t.position.z);
            if (t.position.y > worldLimits.y) t.position = new Vector3(t.position.x, worldLimits.y, t.position.z);
            if (t.position.y < 0) t.position = new Vector3(t.position.x, 0, t.position.z);
            if (t.position.x > worldLimits.x) t.position = new Vector3(worldLimits.x, t.position.y, t.position.z);
            if (t.position.x < -worldLimits.x) t.position = new Vector3(-worldLimits.x, t.position.y, t.position.z);
            if (t.position.z > worldLimits.z) t.position = new Vector3(t.position.x, t.position.y, worldLimits.z);
            if (t.position.z < -worldLimits.z) t.position = new Vector3(t.position.x, t.position.y, -worldLimits.z);
        } //========================================================================================


        void SetupCameraRig()
        {
            t = transform;
            Transform[] children = t.GetComponentsInChildren<Transform>();
            child = new GameObject("Tilt").transform;
            child.parent = t;
            child.localPosition = Vector3.zero;
            child.transform.localEulerAngles = new Vector3(0, 90, 0);
            for (int i = 0; i < children.Length; i++) { if (children[i] != t) children[i].parent = child; }
            camT = Camera.main.transform;
            camT.parent = child;
            camT.forward = t.forward;
            camT.localPosition = Vector3.zero;
            ray.direction = Vector3.down;
        } //========================================================================================


        IEnumerator LerpTimeScale()
        {
            float startValue = Time.timeScale;
            float totalDelta = Mathf.Abs(1 - slowMotionFactor);
            float currentDelta = Mathf.Abs(targetValue - startValue);
            float delta = (slowMotionLerpDuration / totalDelta) * currentDelta;
            float tStamp = Time.realtimeSinceStartup;
            while (Time.realtimeSinceStartup - tStamp < slowMotionLerpDuration * delta)
            {
                float lerpValue = (Time.realtimeSinceStartup - tStamp) / (slowMotionLerpDuration * delta);
                Time.timeScale = Mathf.Lerp(startValue, targetValue, lerpValue);
                yield return null;
            }
        } //========================================================================================
    }
}
