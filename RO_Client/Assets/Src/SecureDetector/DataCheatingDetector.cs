#define UNITY_5_4_PLUS
#if UNITY_4_6 || UNITY_4_7 || UNITY_4_8 || UNITY_4_9 || UNITY_5_0 || UNITY_5_1 || UNITY_5_2 || UNITY_5_3
#undef UNITY_5_4_PLUS
#endif

#if UNITY_5_4_PLUS
using UnityEngine.SceneManagement;
#endif

using System.IO;
using UnityEngine;
using UnityEngine.Events;
using System.Collections;
using System.Collections.Generic;
public class DataCheatingDetector:ActDetectorBase
{
    internal const string COMPONENT_NAME = "Injection Detector";
    internal const string FINAL_LOG_PREFIX = COMPONENT_NAME + ": ";

    private static int instancesInScene;

    /// <summary>
    /// 在加密和fake值之间最大的允许误差值
    /// </summary>
    public float floatEpsilon = 0.0001f;

    public static DataCheatingDetector Instance { get; private set; }

    private static DataCheatingDetector GetOrCreateInstance
    {
        get
        {
            if (Instance != null) return Instance;

            if (detectorsContainer == null)
            {
                detectorsContainer = new GameObject(CONTAINER_NAME);
            }
            Instance = detectorsContainer.AddComponent<DataCheatingDetector>();
            return Instance;
        }
    }

    public static void StartDetection()
    {
        if (Instance != null)
        {
            Instance.StartDetectionInternal(null);
        }
        else
        {
            //Log.e(FINAL_LOG_PREFIX + "can't be started since it doesn't exists in scene or not yet initialized!");
        }
    }

    public static void StartDetection(UnityAction callback)
    {
        GetOrCreateInstance.StartDetectionInternal(callback);
    }

    public static void StopDetection()
    {
        if (Instance != null) Instance.StopDetectionInternal();
    }

    public static void Dispose()
    {
        if (Instance != null) Instance.DisposeInternal();
    }

    internal static bool IsRunning
    {
        get
        {
            return ((object)Instance != null) && Instance.isRunning;
        }
    }

    private DataCheatingDetector() { } // prevents direct instantiation

    private void StartDetectionInternal(UnityAction callback)
    {
        if (isRunning)
        {
            Debug.LogWarning(FINAL_LOG_PREFIX + "already running!", this);
            return;
        }

        if (!enabled)
        {
            Debug.LogWarning(FINAL_LOG_PREFIX + "disabled but StartDetection still called from somewhere (see stack trace for this message)!", this);
            return;
        }

        if (callback != null && detectionEventHasListener)
        {
            Debug.LogWarning(FINAL_LOG_PREFIX + "has properly configured Detection Event in the inspector, but still get started with Action callback. Both Action and Detection Event will be called on detection. Are you sure you wish to do this?", this);
        }

        if (callback == null && !detectionEventHasListener)
        {
            Debug.LogWarning(FINAL_LOG_PREFIX + "was started without any callbacks. Please configure Detection Event in the inspector, or pass the callback Action to the StartDetection method.", this);
            enabled = false;
            return;
        }

        detectionAction = callback;
        started = true;
        isRunning = true;
    }

    private void Awake()
    {
        instancesInScene++;
        if (Init(Instance, COMPONENT_NAME))
        {
            Instance = this;
        }

#if UNITY_5_4_PLUS
        SceneManager.sceneLoaded += OnLevelWasLoadedNew;
#endif
    }

    protected override void OnDestroy()
    {
        base.OnDestroy();
        instancesInScene--;
    }

#if UNITY_5_4_PLUS
    private void OnLevelWasLoadedNew(Scene scene, LoadSceneMode mode)
    {
        OnLevelLoadedCallback();
    }
#else
		private void OnLevelWasLoaded()
		{
			OnLevelLoadedCallback();
		}
#endif

    private void OnLevelLoadedCallback()
    {
        if (instancesInScene < 2)
        {
            if (!keepAlive)
            {
                DisposeInternal();
            }
        }
        else
        {
            if (!keepAlive && Instance != this)
            {
                DisposeInternal();
            }
        }
    }

    protected override void StartDetectionAutomatically()
    {
        StartDetectionInternal(null);
    }

    protected override void PauseDetector()
    {
        isRunning = false;
    }

    protected override void ResumeDetector()
    {
        if (detectionAction == null && !detectionEventHasListener) return;
        isRunning = true;
    }

    protected override void StopDetectionInternal()
    {
        if (!started)
            return;

        detectionAction = null;
        started = false;
        isRunning = false;
    }

    protected override void DisposeInternal()
    {
        base.DisposeInternal();
        if (Instance == this) Instance = null;
    }
}