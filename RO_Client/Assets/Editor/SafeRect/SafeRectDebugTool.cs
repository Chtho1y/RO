using System;
using System.Collections;
using System.Reflection;
using UnityEditor;
using UnityEngine;

public class SafeRectDebugTool : EditorWindow
{
    private class DeviceInfo
    {
        public string name;
        public Vector2Int size;
        public Rect safeArea;
        public string maskTexturePath;
    }

    protected FieldInfo m_EditorSafeRectFieldInfo = null;
    protected FieldInfo m_EditorScreenOrientationFieldInfo = null;
    protected FieldInfo m_EditorMaskTextureFieldInfo = null;

    protected PropertyInfo m_GameView_SelectedSizeIndex_PropertyInfo = null;
    protected MethodInfo m_GetSizeOfMainGameViewMethodInfo = null;
    protected MethodInfo m_GameView_GetMainGameView_MethodInfo = null;
    protected MethodInfo m_GameView_UpdateZoomAreaAndParent_MethodInfo = null;

    protected Type m_GameViewSizeTypeType = null;
    protected Type m_GameViewSizeType = null;
    protected PropertyInfo m_GameViewSize_SizeType_PropertyInfo = null;
    protected PropertyInfo m_GameViewSize_Width_PropertyInfo = null;
    protected PropertyInfo m_GameViewSize_Height_PropertyInfo = null;
    protected ConstructorInfo m_GameViewSizeConstructorInfo = null;

    protected Type m_GameViewSizesType = null;

    protected Type m_GameViewSizeGroupType = null;
    protected MethodInfo m_GetTotalCountMethodInfo = null;
    protected MethodInfo m_GetGameViewSizeMethodInfo = null;
    protected MethodInfo m_AddCustomSizesMethodInfo = null;

    private SafeRectCheck m_SafeRectCheck;

    private object m_GameViewSizeType_FixedResolution_Object = null;
    private object m_CurrentGroupObject = null;

    private DeviceInfo[] m_DeviceInfos;
    private string[] m_DevicesNames;

    private string[] m_ScreenOrientationNames = {
        "Portrait",
        "PortraitUpsideDown",
        "LandscapeLeft",
        "LandscapeRight"
    };
    private ScreenOrientation[] m_ScreenOrientationValues = {
        ScreenOrientation.Portrait,
        ScreenOrientation.PortraitUpsideDown,
        ScreenOrientation.LandscapeLeft,
        ScreenOrientation.LandscapeRight,
    };

    private int m_DefaultScreenOrientationIndex = 0;
    private int m_CurScreenOrientationIndex = 0;
    private int m_CurDeviceIndex = 0;
    private bool m_Init = false;

    private void InitValue()
    {
        m_Init = true;
        m_SafeRectCheck = SafeRectCheck.Instance;

        m_EditorSafeRectFieldInfo = typeof(SafeRectCheck).GetField("m_EditorSafeRect", BindingFlags.Instance | BindingFlags.NonPublic);
        m_EditorScreenOrientationFieldInfo = typeof(SafeRectCheck).GetField("m_EditorScreenOrientation", BindingFlags.Instance | BindingFlags.NonPublic);
        ScreenOrientation screenOrientation = (ScreenOrientation)m_EditorScreenOrientationFieldInfo.GetValue(m_SafeRectCheck);
        m_EditorMaskTextureFieldInfo = typeof(SafeRectCheck).GetField("m_EditorMaskTexture", BindingFlags.Instance | BindingFlags.NonPublic);

        Type gameViewType = typeof(Editor).Assembly.GetType("UnityEditor.GameView");
        m_GetSizeOfMainGameViewMethodInfo = gameViewType.GetMethod("GetSizeOfMainGameView", BindingFlags.Instance | BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Static);
        Vector2 screenSize = (Vector2)m_GetSizeOfMainGameViewMethodInfo.Invoke(null, null);
        m_GameView_SelectedSizeIndex_PropertyInfo = gameViewType.GetProperty("selectedSizeIndex", BindingFlags.Instance | BindingFlags.Public | BindingFlags.NonPublic);
        m_GameView_GetMainGameView_MethodInfo = gameViewType.GetMethod("GetMainGameView", BindingFlags.Instance | BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Static);
        m_GameView_UpdateZoomAreaAndParent_MethodInfo = gameViewType.GetMethod("UpdateZoomAreaAndParent", BindingFlags.Instance | BindingFlags.Public | BindingFlags.NonPublic);

        m_GameViewSizeTypeType = typeof(Editor).Assembly.GetType("UnityEditor.GameViewSizeType");
        m_GameViewSizeType_FixedResolution_Object = Enum.Parse(m_GameViewSizeTypeType, "FixedResolution");

        m_GameViewSizeType = typeof(Editor).Assembly.GetType("UnityEditor.GameViewSize");
        m_GameViewSize_SizeType_PropertyInfo = m_GameViewSizeType.GetProperty("sizeType");
        m_GameViewSize_Width_PropertyInfo = m_GameViewSizeType.GetProperty("width");
        m_GameViewSize_Height_PropertyInfo = m_GameViewSizeType.GetProperty("height");
        m_GameViewSizeConstructorInfo = m_GameViewSizeType.GetConstructor(new Type[] { m_GameViewSizeTypeType, typeof(int), typeof(int), typeof(string) });

        m_GameViewSizesType = typeof(Editor).Assembly.GetType("UnityEditor.GameViewSizes");
        var singleType = typeof(ScriptableSingleton<>).MakeGenericType(m_GameViewSizesType);
        var instanceProp = singleType.GetProperty("instance");
        var crrentGroupProp = m_GameViewSizesType.GetProperty("currentGroup");
        m_CurrentGroupObject = crrentGroupProp.GetValue(instanceProp.GetValue(null, null), null);

        m_GameViewSizeGroupType = typeof(Editor).Assembly.GetType("UnityEditor.GameViewSizeGroup");
        m_GetTotalCountMethodInfo = m_GameViewSizeGroupType.GetMethod("GetTotalCount");
        m_GetGameViewSizeMethodInfo = m_GameViewSizeGroupType.GetMethod("GetGameViewSize");
        m_AddCustomSizesMethodInfo = m_GameViewSizeGroupType.GetMethod("AddCustomSize");

        if (screenSize.x > screenSize.y)
        {
            m_DefaultScreenOrientationIndex = 2;
            screenSize = new Vector2(screenSize.y, screenSize.x);
        }
        else
        {
            m_DefaultScreenOrientationIndex = 0;
        }

        m_DeviceInfos = new DeviceInfo[] {
            new DeviceInfo {
            name = "None",
            size = new Vector2Int (Mathf.CeilToInt (screenSize.x), Mathf.CeilToInt (screenSize.y)),
            safeArea = new Rect (0, 0, screenSize.x, screenSize.y),
            maskTexturePath = string.Empty
            },
            new DeviceInfo {
            name = "Apple/iPad7",
            size = new Vector2Int (1620, 2160),
            safeArea = new Rect (0, 0, 1620, 2160),
            maskTexturePath = string.Empty
            },
            new DeviceInfo {
            name = "Apple/iPhoneX",
            size = new Vector2Int (1125, 2436),
            safeArea = new Rect (0, 120, 1125, 2215),
            maskTexturePath = "Assets/Editor/SafeRect/Texture/AppleiPhoneX_Overlay.png"
            },
            new DeviceInfo {
            name = "Huawei/MatePadPro",
            size = new Vector2Int (1600, 2560),
            safeArea = new Rect (0, 112, 1600, 2448),
            maskTexturePath = "Assets/Editor/SafeRect/Texture/HuaweiMatePadPro_Overlay.png"
            },
            new DeviceInfo {
            name = "Huawei/Mate20Pro",
            size = new Vector2Int (1440, 3120),
            safeArea = new Rect (0, 100, 1440, 3020),
            maskTexturePath = "Assets/Editor/SafeRect/Texture/HuaweiMate20Pro_Overlay.png"
            },
            new DeviceInfo {
            name = "OnePlus6T",
            size = new Vector2Int (1080, 2340),
            safeArea = new Rect (0, 79, 1080, 2261),
            maskTexturePath = "Assets/Editor/SafeRect/Texture/OnePlus6T_Overlay.png"
            },
            new DeviceInfo {
            name = "Samsung/GalaxyS10Plus",
            size = new Vector2Int (1440, 3040),
            safeArea = new Rect (0, 142, 1440, 2898),
            maskTexturePath = "Assets/Editor/SafeRect/Texture/SamsungGalaxyS10Plus_Overlay.png"
            },
            new DeviceInfo {
            name = "Samsung/GalaxyS10",
            size = new Vector2Int (1080, 2280),
            safeArea = new Rect (0, 112, 1080, 2168),
            maskTexturePath = "Assets/Editor/SafeRect/Texture/SamsungGalaxyS10_Overlay.png"
            },
            new DeviceInfo {
            name = "Samsung/GalaxyNote10Plus",
            size = new Vector2Int (1080, 2280),
            safeArea = new Rect (0, 85, 1080, 2195),
            maskTexturePath = "Assets/Editor/SafeRect/Texture/SamsungGalaxyNote10Plus_Overlay.png"
            },
        };

        m_DevicesNames = new string[m_DeviceInfos.Length];
        for (int i = 0; i < m_DeviceInfos.Length; i++)
        {
            m_DevicesNames[i] = m_DeviceInfos[i].name;
        }

        if (m_ScreenOrientationValues[m_DefaultScreenOrientationIndex] != screenOrientation)
        {
            m_CurScreenOrientationIndex = m_DefaultScreenOrientationIndex;
            ResetDevice();
        }
    }

    private void OnDestroy()
    {
        if (Application.isPlaying)
        {
            ResetDevice();
        }
    }

    public void ResetDevice()
    {
        if (m_Init)
        {
            m_Init = false;
            m_CurDeviceIndex = 0;
            m_CurScreenOrientationIndex = m_DefaultScreenOrientationIndex;
            RefreshValue();
        }
    }

    private void OnGUI()
    {
        if (!Application.isPlaying)
        {
            GUILayout.FlexibleSpace();
            EditorGUILayout.HelpBox("目前只能在播放模式下使用", MessageType.Warning);
            GUILayout.FlexibleSpace();
            return;
        }
        if (!SafeRectCheck.Instance) return;
        if (!m_SafeRectCheck) InitValue();
        EditorGUILayout.Space();

        int index = EditorGUILayout.Popup("模拟设备类型", m_CurDeviceIndex, m_DevicesNames);
        if (m_CurDeviceIndex != index)
        {
            m_CurDeviceIndex = index;
            RefreshValue();
        }

        EditorGUILayout.Space();
        index = EditorGUILayout.Popup("模拟设备方向", m_CurScreenOrientationIndex, m_ScreenOrientationNames);
        if (m_CurScreenOrientationIndex != index)
        {
            m_CurScreenOrientationIndex = index;
            RefreshValue();
        }

        EditorGUILayout.Space();
    }

    private void RefreshValue()
    {
        DeviceInfo deviceInfo = m_DeviceInfos[m_CurDeviceIndex];
        ScreenOrientation screenOrientation = m_ScreenOrientationValues[m_CurScreenOrientationIndex];
        int width = deviceInfo.size.x;
        int height = deviceInfo.size.y;
        Rect safeArea = new Rect(deviceInfo.safeArea);
#if UNITY_2018_4_OR_NEWER
        safeArea.y = height - safeArea.y - safeArea.height;
#endif
        int realWidth, realHeight;
        if (screenOrientation == ScreenOrientation.PortraitUpsideDown)
        {
            realWidth = width;
            realHeight = height;
            safeArea.x = width - safeArea.x - safeArea.width;
            safeArea.y = height - safeArea.y - safeArea.height;
        }
        else if (screenOrientation == ScreenOrientation.LandscapeLeft)
        {
            realWidth = height;
            realHeight = width;
            safeArea.x = height - safeArea.y - safeArea.height;
            safeArea.y = safeArea.x;
            safeArea.width = realWidth;
            safeArea.height = realHeight;
        }
        else if (screenOrientation == ScreenOrientation.LandscapeRight)
        {
            realWidth = height;
            realHeight = width;
            safeArea.x = safeArea.y;
            safeArea.y = width - safeArea.x - safeArea.width;
            safeArea.width = realWidth;
            safeArea.height = realHeight;
        }
        else
        {
            realWidth = width;
            realHeight = height;
        }
        if (!UIMgr.HasInstance())
        {
            UIMgr.Instance.InitMgr();
        }

        SetSize(realWidth, realHeight);
        m_EditorSafeRectFieldInfo.SetValue(m_SafeRectCheck, safeArea);
        m_EditorMaskTextureFieldInfo.SetValue(m_SafeRectCheck, AssetDatabase.LoadAssetAtPath<Texture2D>(deviceInfo.maskTexturePath));
        m_EditorScreenOrientationFieldInfo.SetValue(m_SafeRectCheck, screenOrientation);
    }

    private void SetSize(int width, int height)
    {
        int index = FindSize(width, height);
        if (index == -1)
        {
            AddCustomSize(width, height);
        }
        index = FindSize(width, height);
        if (index == -1) return;
        object gameViewObj = m_GameView_GetMainGameView_MethodInfo.Invoke(null, null);
        m_GameView_SelectedSizeIndex_PropertyInfo.SetValue(gameViewObj, index);
        m_GameView_UpdateZoomAreaAndParent_MethodInfo.Invoke(gameViewObj, null);
    }

    private void AddCustomSize(int width, int height)
    {
        object gameViewSizeObj = m_GameViewSizeConstructorInfo.Invoke(new object[] { m_GameViewSizeType_FixedResolution_Object, width, height, string.Empty });
        m_AddCustomSizesMethodInfo.Invoke(m_CurrentGroupObject, new object[] { gameViewSizeObj });
    }

    private bool ExistSize(int width, int height)
    {
        return FindSize(width, height) != -1;
    }

    private int FindSize(int width, int height)
    {
        int count = (int)m_GetTotalCountMethodInfo.Invoke(m_CurrentGroupObject, null);
        for (int i = 0; i < count; i++)
        {
            object gameViewSizeObj = m_GetGameViewSizeMethodInfo.Invoke(m_CurrentGroupObject, new object[] { i });
            object objSizeType = m_GameViewSize_SizeType_PropertyInfo.GetValue(gameViewSizeObj, null);
            int objWidth = (int)m_GameViewSize_Width_PropertyInfo.GetValue(gameViewSizeObj, null);
            int objHeight = (int)m_GameViewSize_Height_PropertyInfo.GetValue(gameViewSizeObj, null);
            if (width == objWidth && height == objHeight && ((int)m_GameViewSizeType_FixedResolution_Object == (int)objSizeType))
            {
                return i;
            }
        }
        return -1;
    }

    [InitializeOnLoadMethod]
    private static void OnRegister()
    {
        EditorApplication.playModeStateChanged += OnPlayModeStateChanged;
    }

    private static void OnPlayModeStateChanged(PlayModeStateChange playModeStateChange)
    {
        if (playModeStateChange == PlayModeStateChange.ExitingPlayMode)
        {
            UnityEngine.Object[] wins = Resources.FindObjectsOfTypeAll(typeof(SafeRectDebugTool));
            SafeRectDebugTool win = wins.Length > 0 ? (SafeRectDebugTool)(wins[0]) : null;
            if (win)
            {
                win.ResetDevice();
            }
        }
    }

    [MenuItem("RO_Tool/移动设备模拟器")]
    private static SafeRectDebugTool OpenWindow()
    {
        var window = EditorWindow.GetWindow<SafeRectDebugTool>("移动设备模拟器");
        return window;
    }
}