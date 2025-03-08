using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

[RequireComponent(typeof(RectTransform))]
public class AdapterKeyboardLayout : UIBehaviour
{
    /// <summary>
	/// 必须设置值，判断是由哪个InputField发起的
	/// </summary>
	public InputField m_InputField;
	/// <summary>
	/// 在适配虚拟键盘时，对齐的点， 默认为InputField
	/// </summary>
	public RectTransform anchorTransform;
	/// <summary>
	/// 在适配虚拟键盘时，做偏移的对象， ， 默认为Self
	/// </summary>
	public RectTransform offsetTransform;

	private Canvas m_Canvas;
	private RectTransform m_OffsetParentTransform;
	private Vector3 m_AnchorPos;
	private Vector3 m_OffsetInitPos;
	private Vector2 m_OffsetScreePos = Vector2.zero;
	private bool m_LastVisible = false;

	public Canvas canvas
	{
		get
		{
			if (this.m_Canvas == null)
			{
				this.CacheCanvas();
			}
			return this.m_Canvas;
		}
	}

	protected override void OnEnable()
	{
		base.OnEnable();

		if (!m_InputField)
		{
			enabled = false;
			Debug.LogError("InputField is Null", gameObject);
			return;
		}

		if (!anchorTransform) anchorTransform = (RectTransform)m_InputField.transform;
		if (!offsetTransform) offsetTransform = (RectTransform)transform;
		Transform parent = offsetTransform.parent;
		if (!parent)
		{
			enabled = false;
			Debug.LogError("offsetTransform's parent is Null", gameObject);
			return;
		}
		m_OffsetParentTransform = (RectTransform)parent;
	}

	protected override void OnTransformParentChanged()
	{
		base.OnTransformParentChanged();
		m_Canvas = null;
	}

	protected override void OnCanvasHierarchyChanged()
	{
		m_Canvas = null;
	}

	private void CacheCanvas()
	{
		List<Canvas> list = new List<Canvas>();
		base.gameObject.GetComponentsInParent(false, list);
		if (list.Count > 0)
		{
			int num = 0;
			while (num < list.Count)
			{
				if (!list[num].isActiveAndEnabled)
				{
					num++;
					continue;
				}
				m_Canvas = list[num];
				break;
			}
		}
		else
		{
			m_Canvas = null;
		}
	}
	
	private void Update() 
	{
		Canvas curCanvas = canvas;
		if (curCanvas == null)
		{
			return;
		}

		if (!m_InputField.isFocused)
		{
			if (!Mathf.Approximately(m_OffsetScreePos.y, 0))
			{
				offsetTransform.localPosition = m_OffsetInitPos;
				m_OffsetScreePos.y = 0;
				DisposeMobileKeyboard();
			}
			return;
		}

		bool visible = GetMobileKeyboardVisible();

		if (visible)
		{
			if (m_LastVisible != visible)
			{
				// 左下角
				Rect rect = anchorTransform.rect;
				m_AnchorPos = anchorTransform.TransformPoint(rect.min);
				m_AnchorPos = m_OffsetParentTransform.InverseTransformPoint(m_AnchorPos);
				m_OffsetInitPos = offsetTransform.localPosition;
			}

			float height = GetMobileKeyboardHeight();
			if (!Mathf.Approximately(height, m_OffsetScreePos.y))
			{
				m_OffsetScreePos.y = height;
				Vector2 pos;
				Camera camera = (curCanvas.renderMode == RenderMode.ScreenSpaceOverlay ? null : curCanvas.worldCamera);
				if (RectTransformUtility.ScreenPointToLocalPointInRectangle(m_OffsetParentTransform, m_OffsetScreePos, camera, out pos))
				{
					if (m_AnchorPos.y < pos.y)
					{
						offsetTransform.localPosition = new Vector2(m_OffsetInitPos.x, m_OffsetInitPos.y + pos.y - m_AnchorPos.y);
					}
					else
					{
						offsetTransform.localPosition = m_OffsetInitPos;
					}
				}
			}
		}
		else
		{
			if (!Mathf.Approximately(m_OffsetScreePos.y, 0))
			{
				offsetTransform.localPosition = m_OffsetInitPos;
				m_OffsetScreePos.y = 0;
				DisposeMobileKeyboard();
			}
		}

		m_LastVisible = visible;
	}

	private bool GetMobileKeyboardVisible()
	{
#if UNITY_EDITOR
		return false;
#elif UNITY_ANDROID || UNITY_IOS
		return TouchScreenKeyboard.visible;
#else
		return true;
#endif
	}

	private float GetMobileKeyboardHeight()
	{
#if UNITY_EDITOR
        return 0;
#elif UNITY_ANDROID
        return GetMobileKeyboardHeight_Android();
#elif UNITY_IOS
        return TouchScreenKeyboard.area.height;
#else
        return 0;
#endif
    }

	private void DisposeMobileKeyboard()
	{
#if UNITY_ANDROID
		if (m_InputDialogAJO != null)
		{
			m_InputDialogAJO.Dispose();
			m_InputDialogAJO = null;
		}
		if (m_ViewAJO != null)
		{
			m_ViewAJO.Dispose();
			m_ViewAJO = null;
		}
		if (m_RectAJO != null)
		{
			m_RectAJO.Dispose();
			m_RectAJO = null;
		}
		if (m_PointAJO != null)
		{
			m_PointAJO.Dispose();
			m_PointAJO = null;
		}
		if (m_DefaultDisplayAJO != null)
		{
			m_DefaultDisplayAJO.Dispose();
			m_DefaultDisplayAJO = null;
		}
#endif
	}


#if UNITY_ANDROID
    private static float m_KeyboardHeight = 0;
    private static int m_CalcFrameCount = 0;
	private static AndroidJavaObject m_InputDialogAJO = null;
	private static AndroidJavaObject m_ViewAJO = null;
	private static AndroidJavaObject m_RectAJO = null;
	private static AndroidJavaObject m_PointAJO = null;
	private static AndroidJavaObject m_DefaultDisplayAJO = null;
	private static float GetMobileKeyboardHeight_Android()
	{
        // 同一帧内不重复计算
        if (Time.frameCount == m_CalcFrameCount) { return m_KeyboardHeight; }
        m_CalcFrameCount = Time.frameCount;
		if (m_InputDialogAJO == null || m_ViewAJO == null || m_DefaultDisplayAJO == null)
		{
			using (AndroidJavaClass unityPlayerAJC = new AndroidJavaClass("com.unity3d.player.UnityPlayer"))
			{
				using (AndroidJavaObject currentActivityAJO = unityPlayerAJC.GetStatic<AndroidJavaObject>("currentActivity"))
				{
					if (m_InputDialogAJO == null || m_ViewAJO == null)
					{
						using (AndroidJavaObject unityPlayerAJO = currentActivityAJO.Get<AndroidJavaObject>("mUnityPlayer"))
						{
							if (m_InputDialogAJO == null)
							{
								AndroidJavaClass dialogAJC = new AndroidJavaClass("android.app.Dialog");
								AndroidJavaObject[] fieldsAJO = unityPlayerAJO.Call<AndroidJavaObject>("getClass").Call<AndroidJavaObject[]>("getDeclaredFields");
								for (int i = 0, iMax = fieldsAJO.Length; i < iMax; i++)
								{
									AndroidJavaObject dialogAJO = fieldsAJO[i].Call<AndroidJavaObject>("get", unityPlayerAJO);
									if (dialogAJO == null)
									{
										continue;
									}
									if (AndroidJNI.IsInstanceOf(dialogAJO.GetRawObject(), dialogAJC.GetRawClass()))
									{
										m_InputDialogAJO = dialogAJO.Call<AndroidJavaObject>("getWindow")
															.Call<AndroidJavaObject>("getDecorView");
										break;
									}
								}
							}

							if (m_ViewAJO == null)
							{
								m_ViewAJO = unityPlayerAJO.Call<AndroidJavaObject>("getView");
							}
						}
					}
					if (m_DefaultDisplayAJO == null)
					{
						m_DefaultDisplayAJO = currentActivityAJO.Call<AndroidJavaObject>("getWindowManager").Call<AndroidJavaObject>("getDefaultDisplay");
					}
				}
			}
		}

		if (m_RectAJO == null)
		{
			m_RectAJO = new AndroidJavaObject("android.graphics.Rect");
		}

		if (m_PointAJO == null)
		{
			m_PointAJO = new AndroidJavaObject("android.graphics.Point");
		}

		float screenH = Screen.height;
		float realScreenH = 0;
		if (m_DefaultDisplayAJO != null)
		{
			m_DefaultDisplayAJO.Call("getRealSize", m_PointAJO);
			realScreenH = m_PointAJO.Get<int>("y");
		}
		else
		{
			realScreenH = screenH;
		}

		float height = 0f;
		if (m_InputDialogAJO != null)
		{
			bool result = m_InputDialogAJO.Call<bool>("getGlobalVisibleRect", m_RectAJO);
			if (result)
			{
				float inputDialogHeight = m_RectAJO.Call<int>("height");
				height += inputDialogHeight;
			}
		}

		if (m_ViewAJO != null)
		{
			m_ViewAJO.Call("getWindowVisibleDisplayFrame", m_RectAJO);
			float viewBottom = m_RectAJO.Get<int>("bottom");
			height += realScreenH - viewBottom;
		}
        m_KeyboardHeight = height * screenH / realScreenH;
		return m_KeyboardHeight;
	}
#endif
}
