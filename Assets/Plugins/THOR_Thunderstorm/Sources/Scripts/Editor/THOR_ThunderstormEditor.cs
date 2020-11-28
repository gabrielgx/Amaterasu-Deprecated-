using UnityEngine;
using UnityEditor;

namespace THOR
{
    [CustomEditor(typeof(THOR_Thunderstorm))]
    public class THOR_ThunderstormEditor : Editor
    {
        // Serialized Properties====================================================================
        SerializedProperty cam;
        SerializedProperty probability;
        SerializedProperty preferCameraView;
        SerializedProperty colorLightningCore;
        SerializedProperty colorLightningGlow;
        SerializedProperty colorCloudCore;
        SerializedProperty colorCloudGlow;
        SerializedProperty minDuration;
        SerializedProperty maxDuration;
        SerializedProperty enableDepthBlending;
        SerializedProperty depthBlend;
        SerializedProperty minDistance;
        SerializedProperty maxDistance;
        SerializedProperty spawnHeight;
        SerializedProperty scaleMulti;
        SerializedProperty distanceToMultiBolts;
        SerializedProperty distanceToMultiClouds;
        SerializedProperty flickerProbability;
        SerializedProperty flickerBolts;
        SerializedProperty flickerClouds;
        SerializedProperty useLight;
        SerializedProperty lightIntensityMulti;
        SerializedProperty lightColor;
        SerializedProperty maxLightDistance;
        SerializedProperty lightIntensityCurve;
        SerializedProperty lightDistanceCurve;
        SerializedProperty lightRange;
        SerializedProperty lightAngle;
        SerializedProperty lightCookie;
        SerializedProperty lightShadows;
        SerializedProperty shadowResolution;
        SerializedProperty shadowStrength;
        SerializedProperty shadowBias;
        SerializedProperty shadowNormalBias;
        SerializedProperty shadowNearPlane;
        SerializedProperty thunderLoop;
        SerializedProperty thunderLoopVolume;
        SerializedProperty thunderClipsVeryClose;
        SerializedProperty thunderVeryCloseDistance;
        SerializedProperty thunderClipsClose;
        SerializedProperty thunderCloseDistance;
        SerializedProperty thunderClipsMedium;
        SerializedProperty thunderMediumDistance;
        SerializedProperty thunderClipsFar;
        SerializedProperty thunderFarDistance;
        SerializedProperty distanceToVolume;
        SerializedProperty audioFade;
        SerializedProperty panMulti;
        SerializedProperty SpeedOfSound;
        SerializedProperty lerpSpeedUp;
        SerializedProperty lerpSpeedDown;
        SerializedProperty audioMixerGroup;
        SerializedProperty R_LightningPrefab;
        SerializedProperty poolSize;
        SerializedProperty R_SheetLightningPrefab;
        SerializedProperty poolSizeSheetLightning;
        SerializedProperty layer;
        SerializedProperty lightningBoltMeshes;
        // Local Variables =========================================================================
        string installPath;
        string inspectorGUIPath;
        float currentViewWidth;
        static float scrollBarWidth = 47;
        static bool showAdvancedSettings;
        static bool showColorSettings;
        static bool showDistanceSettings;
        static bool showFlickerSettings;
        static bool showLightSettings;
        static bool showPoolSettings;
        static bool showAudioSettings;
        static bool showAssetReferences;
        Color colorColorSettings = new Color(0.5f, 0.0f, 1.0f, 0.3f);
        Color colorDistanceSettings = new Color(0.0f, 0.5f, 1.0f, 0.3f);
        Color colorFlickerSettings = new Color(0.0f, 1.0f, 0.5f, 0.3f);
        Color colorLightSettings = new Color(0.5f, 1.0f, 0.0f, 0.3f);
        Color colorAudioSettings = new Color(1.0f, 0.8f, 0.0f, 0.3f);
        Color colorPoolSettings = new Color(1.0f, 0.5f, 0.0f, 0.3f);
        Color colorAssetReferences = new Color(1.0f, 0.0f, 0.0f, 0.3f);
        GUIContent guiC = new GUIContent();
        Texture2D logoTex;
        THOR_Thunderstorm thor;
        //==========================================================================================


        void SetupSerializedProperties()
        {
            cam = serializedObject.FindProperty("cam");
            probability = serializedObject.FindProperty("probability");
            preferCameraView = serializedObject.FindProperty("preferCameraView");
            colorLightningCore = serializedObject.FindProperty("colorLightningCore");
            colorLightningGlow = serializedObject.FindProperty("colorLightningGlow");
            colorCloudCore = serializedObject.FindProperty("colorCloudCore");
            colorCloudGlow = serializedObject.FindProperty("colorCloudGlow");
            minDuration = serializedObject.FindProperty("minDuration");
            maxDuration = serializedObject.FindProperty("maxDuration");
            enableDepthBlending = serializedObject.FindProperty("enableDepthBlending");
            depthBlend = serializedObject.FindProperty("depthBlend");
            minDistance = serializedObject.FindProperty("minDistance");
            maxDistance = serializedObject.FindProperty("maxDistance");
            spawnHeight = serializedObject.FindProperty("spawnHeight");
            scaleMulti = serializedObject.FindProperty("scaleMulti");
            distanceToMultiBolts = serializedObject.FindProperty("distanceToMultiBolts");
            distanceToMultiClouds = serializedObject.FindProperty("distanceToMultiClouds");
            flickerProbability = serializedObject.FindProperty("flickerProbability");
            flickerBolts = serializedObject.FindProperty("flickerBolts");
            flickerClouds = serializedObject.FindProperty("flickerClouds");
            useLight = serializedObject.FindProperty("useLight");
            lightIntensityMulti = serializedObject.FindProperty("lightIntensityMulti");
            lightColor = serializedObject.FindProperty("lightColor");
            maxLightDistance = serializedObject.FindProperty("maxLightDistance");
            lightIntensityCurve = serializedObject.FindProperty("lightIntensityCurve");
            lightDistanceCurve = serializedObject.FindProperty("lightDistanceCurve");
            lightRange = serializedObject.FindProperty("lightRange");
            lightAngle = serializedObject.FindProperty("lightAngle");
            lightCookie = serializedObject.FindProperty("lightCookie");
            lightShadows = serializedObject.FindProperty("lightShadows");
            shadowResolution = serializedObject.FindProperty("shadowResolution");
            shadowStrength = serializedObject.FindProperty("shadowStrength");
            shadowBias = serializedObject.FindProperty("shadowBias");
            shadowNormalBias = serializedObject.FindProperty("shadowNormalBias");
            shadowNearPlane = serializedObject.FindProperty("shadowNearPlane");
            thunderLoop = serializedObject.FindProperty("thunderLoop");
            thunderLoopVolume = serializedObject.FindProperty("thunderLoopVolume");
            thunderClipsVeryClose = serializedObject.FindProperty("thunderClipsVeryClose");
            thunderVeryCloseDistance = serializedObject.FindProperty("thunderVeryCloseDistance");
            thunderClipsClose = serializedObject.FindProperty("thunderClipsClose");
            thunderCloseDistance = serializedObject.FindProperty("thunderCloseDistance");
            thunderClipsMedium = serializedObject.FindProperty("thunderClipsMedium");
            thunderMediumDistance = serializedObject.FindProperty("thunderMediumDistance");
            thunderClipsFar = serializedObject.FindProperty("thunderClipsFar");
            thunderFarDistance = serializedObject.FindProperty("thunderFarDistance");
            distanceToVolume = serializedObject.FindProperty("distanceToVolume");
            audioFade = serializedObject.FindProperty("audioFade");
            panMulti = serializedObject.FindProperty("panMulti");
            SpeedOfSound = serializedObject.FindProperty("SpeedOfSound");
            lerpSpeedUp = serializedObject.FindProperty("lerpSpeedUp");
            lerpSpeedDown = serializedObject.FindProperty("lerpSpeedDown");
            audioMixerGroup = serializedObject.FindProperty("audioMixerGroup");
            R_LightningPrefab = serializedObject.FindProperty("R_LightningPrefab");
            poolSize = serializedObject.FindProperty("poolSize");
            R_SheetLightningPrefab = serializedObject.FindProperty("R_SheetLightningPrefab");
            poolSizeSheetLightning = serializedObject.FindProperty("poolSizeSheetLightning");
            layer = serializedObject.FindProperty("layer");
            lightningBoltMeshes = serializedObject.FindProperty("lightningBoltMeshes");
        } //========================================================================================


        void OnEnable()
        {
            string scriptLocation = AssetDatabase.GetAssetPath(MonoScript.FromScriptableObject(this));
            installPath = scriptLocation.Replace("/Sources/Scripts/Editor/THOR_ThunderstormEditor.cs", "");
            inspectorGUIPath = installPath + "/Sources/Scripts/Editor/EditorGUI";

            logoTex = AssetDatabase.LoadAssetAtPath(inspectorGUIPath + "/THOR_Logo.png", typeof(Texture2D)) as Texture2D;

            thor = (THOR_Thunderstorm)target;
            SetupSerializedProperties();
        } //========================================================================================


        public override void OnInspectorGUI()
        {
            currentViewWidth = EditorGUIUtility.currentViewWidth;
            Rect bgRect = EditorGUILayout.GetControlRect(GUILayout.Width(0), GUILayout.Height(70));
            bgRect = new Rect(bgRect.x + 34, bgRect.y - 4, currentViewWidth - 87, bgRect.height + 1);
            GUI.DrawTexture(new Rect((currentViewWidth / 2) - 194, bgRect.y + 0, 388, 142), logoTex);

            // Set Label Width
            EditorGUIUtility.labelWidth = currentViewWidth - 150 - scrollBarWidth;
            //======================================================================================
            serializedObject.Update();

            guiC.text = "Probability";
            guiC.tooltip = "The probability for a lightning bolt or sheet lightning(cloud lightning) to spawn.";
            EditorGUILayout.PropertyField(probability, guiC);
            guiC.text = "Prefer Camera View";
            guiC.tooltip = "Higher values increase the chance that a lightning is spawned in the camera view. Zero means that lightning is spawned randomly around the camera. One means that all lightning is spawned within the camera view.";
            EditorGUILayout.PropertyField(preferCameraView, guiC);
            guiC.text = "Spawn Height";
            guiC.tooltip = "The height in scene units in which a lightning is spawned (the point where a lightning bolt leaves the clouds).";
            EditorGUILayout.PropertyField(spawnHeight, guiC);
            guiC.text = "Scale Multi";
            guiC.tooltip = "A multiplier for the size of the lighting. A value of one means that lightning bolts are exaclty as long as the 'Spawn Height'.\n\nNote: This value can not be changed in playmode.";
            EditorGUILayout.PropertyField(scaleMulti, guiC);
            guiC.text = "Camera";
            guiC.tooltip = "The camera which the lightning will be spawned around/in front of. This can be left empty in most cases, as it is only needed if you switch between multiple cameras in runtime. In such a case you would need to set the 'cam' variable via script.\nAPI Call: THOR.THOR_Thunderstorm.instance.cam = yourCamera";
            EditorGUILayout.PropertyField(cam, guiC);

            showAdvancedSettings = EditorGUILayout.Toggle("Show Advanced Settings", showAdvancedSettings);
            if (showAdvancedSettings)
            {
                // Color Settings ==================================================================
                if (showColorSettings = StartSection("Color Settings", showColorSettings, colorColorSettings))
                {
                    guiC.text = "Lightning Core";
                    guiC.tooltip = "Sets the core color of the lightning bolts.\n\nNote: This value can not be changed in playmode.";
                    EditorGUILayout.PropertyField(colorLightningCore, guiC);
                    guiC.text = "Lightning Glow";
                    guiC.tooltip = "Sets the glow color of the lightning bolts.\n\nNote: This value can not be changed in playmode.";
                    EditorGUILayout.PropertyField(colorLightningGlow, guiC);
                    guiC.text = "Cloud Core";
                    guiC.tooltip = "Sets the core color of the sheet lightning(cloud lightning).\n\nNote: This value can not be changed in playmode.";
                    EditorGUILayout.PropertyField(colorCloudCore, guiC);
                    guiC.text = "Cloud Glow";
                    guiC.tooltip = "Sets the glow color of the sheet lightning(cloud lightning).\n\nNote: This value can not be changed in playmode.";
                    EditorGUILayout.PropertyField(colorCloudGlow, guiC);
                }
                EndSection(showColorSettings); //===================================================


                // Distance & Duration Settings ====================================================
                if (showDistanceSettings = StartSection("Distance & Duration Settings", showDistanceSettings, colorDistanceSettings))
                {
                    guiC.text = "Minimum Distance";
                    guiC.tooltip = "Sets how close to the camera a lighting can spawn.";
                    EditorGUILayout.PropertyField(minDistance, guiC);
                    guiC.text = "Maximum Distance";
                    guiC.tooltip = "Sets how far from the camera a lighting can spawn.";
                    EditorGUILayout.PropertyField(maxDistance, guiC);
                    guiC.text = "Brightness over Distance Lightning";
                    guiC.tooltip = "This curve is a multiplier for brightness over distance. Essentially this makes near lightning brighter and far away lightning darker.";
                    EditorGUILayout.PropertyField(distanceToMultiBolts, guiC);
                    guiC.text = "Brightness over Distance Clouds";
                    guiC.tooltip = "This curve is a multiplier for brightness over distance. Essentially this makes near sheet lightning(lightning within the clouds) brighter and far away sheet lightning darker.";
                    EditorGUILayout.PropertyField(distanceToMultiClouds, guiC);
                    guiC.text = "Minimum Duration";
                    guiC.tooltip = "Sets the minimum duration of a lightning. No lighting can exist shorter than the time you specify here.";
                    EditorGUILayout.PropertyField(minDuration, guiC);
                    guiC.text = "Maximum Duration";
                    guiC.tooltip = "Sets the maximum duration of a lightning. No lightning can exist longer than the time you specify here.";
                    EditorGUILayout.PropertyField(maxDuration, guiC);

                    guiC.text = "Enable Depth Blending";
                    guiC.tooltip = "Enables Depth Blending. Just like soft particles this makes a soft intersection between the lighting bolts and scene geometry.\n\nNote:This feature requires using deferred lighting or making your camera render the depth texture.\nNote: This value can not be changed in playmode.";
                    EditorGUILayout.PropertyField(enableDepthBlending, guiC);
                    if (enableDepthBlending.boolValue)
                    {
                        guiC.text = "Depth Blend Distance";
                        guiC.tooltip = "Controls how soft the blending between lightning bolts and intersecting scene geometry should should be.\n\nNote: This value can not be changed in playmode.";
                        EditorGUILayout.PropertyField(depthBlend, guiC);
                    }
                }
                EndSection(showDistanceSettings); //================================================


                // Flicker Settings ================================================================
                if (showFlickerSettings = StartSection("Flicker Settings", showFlickerSettings, colorFlickerSettings))
                {
                    guiC.text = "Flicker Probability";
                    guiC.tooltip = "The chance for lightning to flicker. A value of zero means no flickering will occur, a value of one means all lightning will flicker.";
                    EditorGUILayout.PropertyField(flickerProbability, guiC);
                    guiC.text = "Flicker Lightning";
                    guiC.tooltip = "This curve is a repeating brightness multiplier pattern, flickering lightning will evaluate a random section of this curve. This curve is a multiplier for the brightness of the lightning bolts.";
                    EditorGUILayout.PropertyField(flickerBolts, guiC);
                    guiC.text = "Flicker Clouds";
                    guiC.tooltip = "This curve is a repeating brightness multiplier pattern, flickering sheet lightning will evaluate a random section of this curve. This curve is a multiplier for the brightness of the sheet lightning (cloud lightning). It is recommended to make the flickering less strong than in the above curve. Also, keeping this curve in sync with the above curve is plausible.";
                    EditorGUILayout.PropertyField(flickerClouds, guiC);
                }
                EndSection(showFlickerSettings); //=================================================


                // Light Settings ==================================================================
                if (showLightSettings = StartSection("Light Settings", showLightSettings, colorLightSettings))
                {
                    guiC.text = "Enable Light";
                    guiC.tooltip = "Enables/disables the spotlight for lighting. Note that even though all lightning prefabs have a spotlight there will always be one active at a time.\n\nNote: This value can not be changed in playmode.";
                    EditorGUILayout.PropertyField(useLight, guiC);
                    if (useLight.boolValue)
                    {
                        guiC.text = "Intensity Multi";
                        guiC.tooltip = "Multiplies the intenstiy of the light by the given value. If you use SRP/HDRP you may want to set this to a value of around 10000 to compensate for the different light falloff in the new renderpipelines.";
                        EditorGUILayout.PropertyField(lightIntensityMulti, guiC);
                        guiC.text = "Color over Duration";
                        guiC.tooltip = "This controls the spotlight color over the duration of a lightning.";
                        EditorGUILayout.PropertyField(lightColor, guiC);
                        guiC.text = "Maximum Distance";
                        guiC.tooltip = "The maximum distance in which the lightning spotlight will be active. Any lightning further away than specified in this value will have no dynamic spotlight.";
                        EditorGUILayout.PropertyField(maxLightDistance, guiC);
                        guiC.text = "Intensity over Duration";
                        guiC.tooltip = "This controls the spotlight intensity over the duration of a lightning.";
                        EditorGUILayout.PropertyField(lightIntensityCurve, guiC);
                        guiC.text = "Intensity over Distance";
                        guiC.tooltip = "This controls the spotlight intensity over distance. Essentially it makes near lightning have stronger light and far away lightning have weaker light. This curve gives additional control for the brightness over distance similar to the 'Range Value' below.";
                        EditorGUILayout.PropertyField(lightDistanceCurve, guiC);
                        guiC.text = "Light Range";
                        guiC.tooltip = "This controls the range of the spotlight. This is the value 'Range' on Unity Lights.\n\nNote: This value can not be changed in playmode.";
                        EditorGUILayout.PropertyField(lightRange, guiC);
                        guiC.text = "Light Angle";
                        guiC.tooltip = "This controls the angle of the spotlight. This is the value 'Spot Angle' on Unity Spotlights.\n\nNote: This value can not be changed in playmode.";
                        EditorGUILayout.PropertyField(lightAngle, guiC);
                        guiC.text = "Light Cookie";
                        guiC.tooltip = "This sets the cookie of the spotlight.\n\nNote: This value can not be changed in playmode.";
                        EditorGUILayout.PropertyField(lightCookie, guiC);

                        guiC.text = "Shadow Type";
                        guiC.tooltip = "This controls the spotlight shadow type.\n\nNote: This value can not be changed in playmode.";
                        EditorGUILayout.PropertyField(lightShadows, guiC);
                        if (lightShadows.enumNames[lightShadows.enumValueIndex] != LightShadows.None.ToString())
                        {
                            guiC.text = "Shadow Resolution";
                            guiC.tooltip = "This controls the spotlight shadow resolution.\n\nNote: This value can not be changed in playmode.";
                            EditorGUILayout.PropertyField(shadowResolution, guiC);
                            guiC.text = "Shadow Strength";
                            guiC.tooltip = "This controls the spotlight shadow strength.\n\nNote: This value can not be changed in playmode.";
                            EditorGUILayout.PropertyField(shadowStrength, guiC);
                            guiC.text = "Bias";
                            guiC.tooltip = "Controls the distance at which the shadows will be pushed away from the light. Useful for avoiding false self-shadowing artifacts.\n\nNote: This value can not be changed in playmode.";
                            EditorGUILayout.PropertyField(shadowBias, guiC);
                            guiC.text = "Normal Bias";
                            guiC.tooltip = "Controls the distance at which the shadow casting surfaces will be shrunk along the surface normal. Useful for avoiding false self-shadowing artifacts.\n\nNote: This value can not be changed in playmode.";
                            EditorGUILayout.PropertyField(shadowNormalBias, guiC);
                            guiC.text = "Near Plane";
                            guiC.tooltip = "Controls the value for the near clip plane when rendering shadows. Currently clamped to 0.1 units or 1% of the lights range property, whichever is lower.\n\nNote: This value can not be changed in playmode.";
                            EditorGUILayout.PropertyField(shadowNearPlane, guiC);
                        }
                    }
                }
                EndSection(showLightSettings); //===================================================


                // Audio Settings ==================================================================
                if (showAudioSettings = StartSection("Audio Settings", showAudioSettings, colorAudioSettings))
                {
                    guiC.text = "Audio Mixer Group";
                    guiC.tooltip = "Optionally specify an audio mixer group for your audio routing.\n\nNote: This value can not be changed in playmode.";
                    EditorGUILayout.PropertyField(audioMixerGroup, guiC);
                    guiC.text = "Speed of Sound";
                    guiC.tooltip = "Sets how many meters per second sound can travel. A realistic value is 340 m/s at sea level. Basically this controls the delay between visible lighting and its thunder. Testing has shown that a realistic value feels too long, for this reason the default value is 680 m/s. Note: Slower speed of sound means that a lighting in the pool stays active for longer time (at no extra performance cost as the audio source will only be activated when the sound is actually audible). For this reason it might be necessary to increase the pool size.";
                    EditorGUILayout.PropertyField(SpeedOfSound, guiC);
                    guiC.text = "Sound Duration Fade";
                    guiC.tooltip = "This is an optimization. It controls the fade out of a sound. The included sound samples are all 8 seconds long but having them playing this long in a very strong thunderstorm would mean many active audio sources (limited only by the pool size). Since there is also a background loop faded in and out after a lightning strike, shortening the thunder sounds with this curve can still sound great. Note that longer fade times can make it necessary to increase the poolsize for very strong thunderstorms.";
                    EditorGUILayout.PropertyField(audioFade, guiC);
                    guiC.text = "Stereo Panning Multi";
                    guiC.tooltip = "This controls how soon after a thunder becomes audible the panning will be centered. Centering the panning is realistic as the low rumble of a thunder echoes around and this makes it very hard to notice directionality. Only in the beginning of a thunder a direction can be noticed.";
                    EditorGUILayout.PropertyField(panMulti, guiC);
                    guiC.text = "Very Near Distance";
                    guiC.tooltip = "Defines the range up to which the 'Very Near Distance' thunder samples are played. Any lighting further away than this value will play the samples from the 'Near Distance' group.";
                    EditorGUILayout.PropertyField(thunderVeryCloseDistance, guiC);
                    guiC.text = "Near Distance";
                    guiC.tooltip = "Defines the range up to which the 'Near Distance' thunder samples are played. Any lighting further away than this value will play the samples from the 'Medium Distance' group.";
                    EditorGUILayout.PropertyField(thunderCloseDistance, guiC);
                    guiC.text = "Medium Distance";
                    guiC.tooltip = "Defines the range up to which the 'Medium Distance' thunder samples are played. Any lighting further away than this value will play the samples from the 'Far Distance' group.";
                    EditorGUILayout.PropertyField(thunderMediumDistance, guiC);
                    guiC.text = "Far Distance";
                    guiC.tooltip = "Defines the range up to which the 'Far Distance' thunder samples are played. Any lighting further away than this value will have no sound.";
                    EditorGUILayout.PropertyField(thunderFarDistance, guiC);
                    guiC.text = "Volume Over Distance";
                    guiC.tooltip = "This controls the volume of the thunder sounds over distance. Essentially this makes near distance thunder louder and far distance thunder more silent.";
                    EditorGUILayout.PropertyField(distanceToVolume, guiC);

                    EditorGUILayout.LabelField("Background Loop Settings", EditorStyles.boldLabel);

                    guiC.text = "Probability to Volume";
                    guiC.tooltip = "This curve is a volume multiplier for the background loop(the background loop consists of the typical low thunder rumble). A higher probability value in the main settings will make the background loop louder.";
                    EditorGUILayout.PropertyField(thunderLoopVolume, guiC);
                    guiC.text = "Fade In Time";
                    guiC.tooltip = "This defines how quickly after an individual thunder sound the background loop will be faded in.";
                    EditorGUILayout.PropertyField(lerpSpeedUp, guiC);
                    guiC.text = "Fade Out Time";
                    guiC.tooltip = "This defines how quickly after the background loop reached full volume it will fade out again.";
                    EditorGUILayout.PropertyField(lerpSpeedDown, guiC);
                }
                EndSection(showAudioSettings); //===================================================


                // Pool Settings ===================================================================
                if (showPoolSettings = StartSection("Pool Settings", showPoolSettings, colorPoolSettings))
                {
                    guiC.text = "Pool Size Lightning";
                    guiC.tooltip = "This value defines the size of the pool for the main lighting, a higher number might be needed if there are long thunder fade out times and/or a slow speed of sound is set. Pool sizes between 10 and 20 are usually good. You can see if the full pool is used if all 'R_Lighting' children are active at the same time.\n\nNote: This value can not be changed in playmode.";
                    EditorGUILayout.PropertyField(poolSize, guiC);
                    guiC.text = "Pool Size Clouds";
                    guiC.tooltip = "This value defines the size of the pool for the sheet lighting. Pool sizes between 3 and 6 are usually good. You can see if the full pool is used if all 'R_SheetLighting' children are active at the same time.\n\nNote: This value can not be changed in playmode.";
                    EditorGUILayout.PropertyField(poolSizeSheetLightning, guiC);
                    guiC.text = "Layer Mask";
                    guiC.tooltip = "The Layer the THOR Thunderstorm objects will have.";
                    EditorGUI.BeginChangeCheck();
                    int l = EditorGUILayout.LayerField(guiC, layer.intValue);
                    if (EditorGUI.EndChangeCheck())
                    {
                        layer.intValue = l;
                        thor.gameObject.layer = l;
                    }
                }
                EndSection(showPoolSettings); //====================================================


                // Asset References ================================================================
                if (showAssetReferences = StartSection("Asset References", showAssetReferences, colorAssetReferences))
                {
                    guiC.text = "Lightning Prefab";
                    guiC.tooltip = "The prefab for the main lightning.";
                    EditorGUILayout.PropertyField(R_LightningPrefab, guiC);
                    guiC.text = "Cloud Prefab";
                    guiC.tooltip = "The prefab for the sheet lightning.";
                    EditorGUILayout.PropertyField(R_SheetLightningPrefab, guiC);

                    EditorGUI.indentLevel++;
                    guiC.text = "Lightning Meshes";
                    guiC.tooltip = "The meshes for the main lightning.";
                    EditorGUILayout.PropertyField(lightningBoltMeshes, guiC, true);
                    EditorGUI.indentLevel--;

                    EditorGUILayout.LabelField("Audio Clips", EditorStyles.boldLabel);
                    GUI.color = Color.black;
                    GUI.DrawTexture(EditorGUILayout.GetControlRect(GUILayout.MaxHeight(1)), Texture2D.whiteTexture);
                    GUI.color = Color.white;

                    guiC.text = "Background Loop";
                    guiC.tooltip = "The background loop audio clip.";
                    EditorGUILayout.PropertyField(thunderLoop, guiC);

                    EditorGUI.indentLevel++;
                    guiC.text = "Very Near";
                    guiC.tooltip = "The audio clips for the 'Very Near Distance' thunder sounds.";
                    EditorGUILayout.PropertyField(thunderClipsVeryClose, guiC, true);
                    guiC.text = "Near";
                    guiC.tooltip = "The audio clips for the 'Near Distance' thunder sounds.";
                    EditorGUILayout.PropertyField(thunderClipsClose, guiC, true);
                    guiC.text = "Medium";
                    guiC.tooltip = "The audio clips for the 'Medium Distance' thunder sounds.";
                    EditorGUILayout.PropertyField(thunderClipsMedium, guiC, true);
                    guiC.text = "Far";
                    guiC.tooltip = "The audio clips for the 'Far Distance' thunder sounds.";
                    EditorGUILayout.PropertyField(thunderClipsFar, guiC, true);
                    EditorGUI.indentLevel--;
                }
                EndSection(showAssetReferences); //=================================================
            }
            else
            {
                EmptySection(colorColorSettings);
                EmptySection(colorDistanceSettings);
                EmptySection(colorFlickerSettings);
                EmptySection(colorLightSettings);
                EmptySection(colorAudioSettings);
                EmptySection(colorPoolSettings);
                EmptySection(colorAssetReferences);
            }

            GUILayout.Space(5);
            serializedObject.ApplyModifiedProperties();
        } //========================================================================================


        bool StartSection(string title, bool show, Color color)
        {
            GUI.backgroundColor = color;
            EditorGUILayout.BeginVertical("Box");
            EditorGUILayout.BeginVertical("Box");
            GUI.backgroundColor = Color.white;

            string showLabel = "| Show";
            if (show) showLabel = "| Hide";

            Rect r = EditorGUILayout.GetControlRect();
            EditorGUI.LabelField(r, title, EditorStyles.boldLabel);
            r.x = r.width - 40; r.width = 50;
            EditorGUI.LabelField(r, showLabel);
            r.x += 56; r.width = 15;
            show = EditorGUI.Foldout(r, show, "");

            EditorGUI.DrawRect(EditorGUILayout.GetControlRect(GUILayout.MaxHeight(1)), Color.black);
            EditorGUI.DrawRect(EditorGUILayout.GetControlRect(GUILayout.MaxHeight(1)), Color.black);

            if (show) GUILayout.Space(5);
            return show;
        } //========================================================================================


        void EndSection(bool show)
        {
            if (show) GUILayout.Space(5);
            EditorGUILayout.EndVertical();
            EditorGUILayout.EndVertical();
        } //========================================================================================


        void EmptySection(Color color)
        {
            color.a = 0.4f;
            GUI.backgroundColor = color;
            EditorGUILayout.BeginVertical("Box");
            EditorGUILayout.GetControlRect(GUILayout.MaxHeight(0));
            EditorGUILayout.EndVertical();
        } //========================================================================================
    }
}
