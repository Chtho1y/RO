using UnityEngine;
using System.Collections;
using UnityEngine.EventSystems;

public class UIEventListener : MonoBehaviour, IPointerClickHandler
{
    /// 定义事件代理
    public delegate void UIEventProxy();
    // 鼠标点击事件
    public event UIEventProxy OnClick;


    public void OnPointerClick(PointerEventData eventData)
    {
        if (OnClick != null)
            OnClick();
    }
}
