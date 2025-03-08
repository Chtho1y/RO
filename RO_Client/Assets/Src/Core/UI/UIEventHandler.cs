using UnityEngine;
using UnityEngine.Events;
using UnityEngine.EventSystems;

/// <summary>
/// 在任意地方都可以监听到UI的输入事件
/// </summary>
public class UIEventHandler : MonoBehaviour
{
    public class TriggerEvent : UnityEvent<GameObject> {}


    private TriggerEvent m_OnClick = new TriggerEvent();
    public TriggerEvent onClick
    {
        get { return m_OnClick; }
        set { m_OnClick = value; }
    }

    private void OnEnable() 
    {
        AdvExecuteEvents.onClick.AddListener(OnPointerClick);
    }

    private void OnDisable() 
    {
        AdvExecuteEvents.onClick.RemoveListener(OnPointerClick);
    }

    public virtual void OnPointerClick(PointerEventData eventData)
    {
        onClick.Invoke(eventData.pointerCurrentRaycast.gameObject);
    }

    public void RemoveListener()
    {
        onClick.RemoveAllListeners();
    }
}
