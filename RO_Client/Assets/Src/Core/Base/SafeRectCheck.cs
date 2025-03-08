using UnityEngine;
using UnityEngine.Events;

public class SafeRectCheck : SingletonMono<SafeRectCheck>
{
    private int m_LastScreenWidth = 0;
    private int m_LastScreenHeight = 0;
    private Rect m_LastSafeRect = Rect.zero;
    private ScreenOrientation m_LastScreenOrientation = ScreenOrientation.Portrait;
    private UnityEvent m_SafeRectChangedCanvasEvent = new UnityEvent();
    private UnityEvent m_SafeRectChangedEvent = new UnityEvent();

    private void OnEnable()
    {
        Debug.Log("手机型号：" + SystemInfo.deviceModel);
        CheckChange();
    }

    private void Update()
    {
        // HUAWEI ELS-AN00 => P40 PRO
        // HUAWEI ANA-AN00 => P40
        // HUAWEI ELS-AN10 => P40 PRO +
        // HUAWEI WLZ-AL10 => NOVA 6
        if (
            SystemInfo.deviceModel != "HUAWEI ANA-AN00"
            && SystemInfo.deviceModel != "HUAWEI ELS-AN00"
            && SystemInfo.deviceModel != "HUAWEI ELS-AN10"
            && SystemInfo.deviceModel != "HUAWEI WLZ-AL10"
        )
        CheckChange();
    }

#if UNITY_EDITOR
    private Rect m_EditorSafeRect = Rect.zero;
    private ScreenOrientation m_EditorScreenOrientation = ScreenOrientation.Portrait;
    private Texture2D m_EditorMaskTexture = null;
    private void CheckChange()
    {
        bool isChanged = false;
        int width = Screen.width;
        if (m_LastScreenWidth != width)
        {
            m_LastScreenWidth = width;
            isChanged = true;
        }
        int height = Screen.height;
        if (m_LastScreenHeight != height)
        {
            m_LastScreenHeight = height;
            isChanged = true;
        }
        Rect safeArea;
        if (m_EditorSafeRect == Rect.zero) safeArea = Screen.safeArea;
        else safeArea = m_EditorSafeRect;
        if (safeArea != m_LastSafeRect)
        {
            m_LastSafeRect = safeArea;
            isChanged = true;
        }
        if (m_EditorScreenOrientation != m_LastScreenOrientation)
        {
            m_LastScreenOrientation = m_EditorScreenOrientation;
            isChanged = true;
        }
        if (isChanged)
        {
            m_SafeRectChangedCanvasEvent.Invoke();
            m_SafeRectChangedEvent.Invoke();
        }
    }

    private void OnGUI() {
        if (m_EditorSafeRect == Rect.zero) return;
        if (!m_EditorMaskTexture) return;
        Color defaultColor = GUI.color;
        GUI.color = new Color32(40, 40, 40, 255);
        float angle = 0;
        Rect rect;
        if (m_EditorScreenOrientation == ScreenOrientation.PortraitUpsideDown)
        {
            angle = 180;
            rect = new Rect(0, 0, Screen.width, Screen.height);
        }
        else if (m_EditorScreenOrientation == ScreenOrientation.LandscapeLeft)
        {
            angle = 270;
            rect = new Rect((Screen.width - Screen.height) * 0.5f, (Screen.height - Screen.width) * 0.5f, Screen.height, Screen.width);
        }
        else if (m_EditorScreenOrientation == ScreenOrientation.LandscapeRight)
        {
            angle = 90;
            rect = new Rect((Screen.width - Screen.height) * 0.5f, (Screen.height - Screen.width) * 0.5f, Screen.height, Screen.width);
        }
        else
        {
            rect = new Rect(0, 0, Screen.width, Screen.height);
        }
        GUIUtility.RotateAroundPivot(angle, new Vector2(Screen.width * 0.5f, Screen.height * 0.5f));
        GUI.DrawTexture(rect, m_EditorMaskTexture);
        GUIUtility.RotateAroundPivot(-angle, new Vector2(Screen.width * 0.5f, Screen.height * 0.5f));
        GUI.color = defaultColor;
    }
#else
    private void CheckChange()
    {
        bool isChanged = false;
        int width = Screen.width;
        if (m_LastScreenWidth != width)
        {
            m_LastScreenWidth = width;
            isChanged = true;
        }
        int height = Screen.height;
        if (m_LastScreenHeight != height)
        {
            m_LastScreenHeight = height;
            isChanged = true;
        }
        Rect safeArea = Screen.safeArea;
        if (safeArea != m_LastSafeRect)
        {
            m_LastSafeRect = safeArea;
            isChanged = true;
        }
        ScreenOrientation screenOrientation = Screen.orientation;
        if (screenOrientation != m_LastScreenOrientation)
        {
            m_LastScreenOrientation = screenOrientation;
            isChanged = true;
        }
        if (isChanged)
        {
            m_SafeRectChangedCanvasEvent.Invoke();
            m_SafeRectChangedEvent.Invoke();
        }
    }
#endif

    public int screenWidth
    {
        get
        {
            return m_LastScreenWidth;
        }
    }

    public int screenHeight
    {
        get
        {
            return m_LastScreenHeight;
        }
    }

    public Rect safeArea
    {
        get
        {
            return m_LastSafeRect;
        }
    }
    public ScreenOrientation orientation
    {
        get
        {
            return m_LastScreenOrientation;
        }
    }

    /// <summary>
    /// 安全区域变化后，用于作用Canvas变化
    /// 对Canvas的变化需要在其它UI元素之前，否则UI元素会错乱
    /// </summary>
    public UnityEvent onChangedCanvas
    {
        get
        {
            return m_SafeRectChangedCanvasEvent;
        }
    }

    /// <summary>
    /// 安全区域变化后，用于作用Canvas变化
    /// 对Canvas的变化需要在其它UI元素之前，否则UI元素会错乱
    /// </summary>
    public UnityEvent onChanged
    {
        get
        {
            return m_SafeRectChangedEvent;
        }
    }
}
