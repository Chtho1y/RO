#define UNITY_5_4_PLUS
#if UNITY_4_6 || UNITY_4_7 || UNITY_4_8 || UNITY_4_9 || UNITY_5_0 || UNITY_5_1 || UNITY_5_2 || UNITY_5_3
#undef UNITY_5_4_PLUS
#endif

#if UNITY_5_4_PLUS
using UnityEngine.SceneManagement;
#endif

using UnityEngine;
using UnityEngine.Events;

/// <summary>
/// Allow to detect Cheat Engine's speed hack usage
/// </summary>
public class SpeedHackDetector : ActDetectorBase
{
    internal const string COMPONENT_NAME = "Speed Hack Detector";
    internal const string FINAL_LOG_PREFIX = COMPONENT_NAME + ": ";

    const long TICKS_PER_SECOND = System.TimeSpan.TicksPerMillisecond * 1000;
    const int THRESHOLD = 10000000; // == 500 ms, allowed time difference between genuine and vulnerable ticks

    static int instancesInScene;

    /// <summary> 
    /// Time (in seconds) between detector checks.
    /// </summary>
    [Tooltip("Time (in seconds) between detector checks.")]
    public float interval = 1f;

    /// <summary>
    /// Maximum false positives count allowed before registering speed hack.
    /// </summary>
    [Tooltip("Maximum false positives count allowed before registering speed hack.")]
    public byte maxFalsePositives = 6;

    /// <summary>
    /// Amount of sequential successful checks before clearing internal false positives counter.<br/>
    /// Set 0 to disable Cool Down feature.
    /// </summary>
    [Tooltip("Amount of sequential successful checks before clearing internal false positives counter.\nSet 0 to disable Cool Down feature.")]
    public int coolDown = 30;

    #region private variables
    private byte currentFalsePositives;
    private int currentCooldownShots;
    private long ticksOnStart;
    private long vulnerableTicksOnStart;
    private long prevTicks;
    private long prevIntervalTicks;
    #endregion

    private SpeedHackDetector() { }

    public static SpeedHackDetector Instance { get; private set; }

    private static SpeedHackDetector GetOrCreateInstance
    {
        get
        {
            if (Instance != null)
                return Instance;

            if (detectorsContainer == null)
            {
                detectorsContainer = new GameObject(CONTAINER_NAME);
            }
            Instance = detectorsContainer.AddComponent<SpeedHackDetector>();
            return Instance;
        }
    }

    public static void StartDetection()
    {
        if (Instance != null)
        {
            Instance.StartDetectionInternal(null, Instance.interval, Instance.maxFalsePositives, Instance.coolDown);
        }
        else
        {
            Debug.LogError(FINAL_LOG_PREFIX + "can't be started since it doesn't exists in scene or not yet initialized!");
        }
    }

    public static void StartDetection(UnityAction callback)
    {
        StartDetection(callback, GetOrCreateInstance.interval);
    }

    public static void StartDetection(UnityAction callback, float interval)
    {
        StartDetection(callback, interval, GetOrCreateInstance.maxFalsePositives);
    }

    public static void StartDetection(UnityAction callback, float interval, byte maxFalsePositives)
    {
        StartDetection(callback, interval, maxFalsePositives, GetOrCreateInstance.coolDown);
    }

    public static void StartDetection(UnityAction callback, float interval, byte maxFalsePositives, int coolDown)
    {
        GetOrCreateInstance.StartDetectionInternal(callback, interval, maxFalsePositives, coolDown);
    }

    public static void StopDetection()
    {
        if (Instance != null) Instance.StopDetectionInternal();
    }

    public static void Dispose()
    {
        if (Instance != null) Instance.DisposeInternal();
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

    private void OnApplicationPause(bool pause)
    {
        if (!pause)
        {
            ResetStartTicks();
        }
    }

    private void Update()
    {
        if (!isRunning)
            return;

        long ticks = System.DateTime.UtcNow.Ticks;
        long ticksSpentSinceLastUpdate = ticks - prevTicks;

        if (ticksSpentSinceLastUpdate < 0 || ticksSpentSinceLastUpdate > TICKS_PER_SECOND)
        {
            ResetStartTicks();
            return;
        }

        prevTicks = ticks;

        long intervalTicks = (long)(interval * TICKS_PER_SECOND);

        if (ticks - prevIntervalTicks >= intervalTicks)
        {
            long vulnerableTicks = System.Environment.TickCount * System.TimeSpan.TicksPerMillisecond;

            if (Mathf.Abs((vulnerableTicks - vulnerableTicksOnStart) - (ticks - ticksOnStart)) > THRESHOLD)
            {
                currentFalsePositives++;
                if (currentFalsePositives > maxFalsePositives)
                {
                    DebugHelper.LogWarning("SpeedHackDetector: final detection!");
                    OnCheatingDetected();
                }
                else
                {
                    DebugHelper.LogWarning("SpeedHackDetector: detection! Allowed false positives left: " + (maxFalsePositives - currentFalsePositives));
                    currentCooldownShots = 0;
                    ResetStartTicks();
                }
            }
            else if (currentFalsePositives > 0 && coolDown > 0)
            {
                currentCooldownShots++;
                if (currentCooldownShots >= coolDown)
                {
                    DebugHelper.LogWarning("SpeedHackDetector: cool down!");
                    currentFalsePositives = 0;
                }
            }

            prevIntervalTicks = ticks;
        }
    }

    void StartDetectionInternal(UnityAction callback, float checkInterval, byte falsePositives, int shotsTillCooldown)
    {
        if (isRunning)
        {
            DebugHelper.LogWarning(FINAL_LOG_PREFIX + "already running!");
            return;
        }

        if (!enabled)
        {
            DebugHelper.LogWarning(FINAL_LOG_PREFIX + "disabled but StartDetection still called from somewhere (see stack trace for this message)!");
            return;
        }

        if (callback != null && detectionEventHasListener)
        {
            DebugHelper.LogWarning(FINAL_LOG_PREFIX + "has properly configured Detection Event in the inspector, but still get started with Action callback. Both Action and Detection Event will be called on detection. Are you sure you wish to do this?");
        }

        if (callback == null && !detectionEventHasListener)
        {
            DebugHelper.LogWarning(FINAL_LOG_PREFIX + "was started without any callbacks. Please configure Detection Event in the inspector, or pass the callback Action to the StartDetection method.");
            enabled = false;
            return;
        }

        detectionAction = callback;
        interval = checkInterval;
        maxFalsePositives = falsePositives;
        coolDown = shotsTillCooldown;

        ResetStartTicks();
        currentFalsePositives = 0;
        currentCooldownShots = 0;

        started = true;
        isRunning = true;
    }

    protected override void StartDetectionAutomatically()
    {
        StartDetectionInternal(null, interval, maxFalsePositives, coolDown);
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

    private void ResetStartTicks()
    {
        ticksOnStart = System.DateTime.UtcNow.Ticks;
        vulnerableTicksOnStart = System.Environment.TickCount * System.TimeSpan.TicksPerMillisecond;
        prevTicks = ticksOnStart;
        prevIntervalTicks = ticksOnStart;
    }
}