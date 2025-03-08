using UnityEngine;
using UnityEngine.EventSystems;

public class UIEventTriggerListener : EventTrigger
{
    public static GameObject current;
    public static PointerEventData currentEventData;

    public UnityEngine.Events.UnityAction onClick;
    public UnityEngine.Events.UnityAction onBeginDrag;
    public UnityEngine.Events.UnityAction onDrag;
    public UnityEngine.Events.UnityAction onEndDrag;
    public UnityEngine.Events.UnityAction onPointerDown;
    public UnityEngine.Events.UnityAction onPointerUp;
    public UnityEngine.Events.UnityAction onDeselect;
    public UnityEngine.Events.UnityAction onPointerEnter;
    public UnityEngine.Events.UnityAction onPointerExit;
    public UnityEngine.Events.UnityAction onDrop;

    bool isDragging = false;

    public static UIEventTriggerListener Get(GameObject go)
    {
        UIEventTriggerListener trigger = go.GetComponent<UIEventTriggerListener>();
        if (trigger == null) trigger = go.AddComponent<UIEventTriggerListener>();
        return trigger;
    }

    public static Vector2 ScreenPointToLocalPointInRectangle(RectTransform rt, PointerEventData eventData)
    {
        Vector2 result;
        RectTransformUtility.ScreenPointToLocalPointInRectangle(rt, eventData.position, eventData.pressEventCamera, out result);
        return result;
    }

    public override void OnPointerClick(PointerEventData eventData)
    {
        if (isDragging) return;
        base.OnPointerClick(eventData);

        current = gameObject;
        currentEventData = eventData;

        if (onClick != null) onClick();

        current = null;
    }
    public override void OnPointerDown(PointerEventData eventData)
    {
        base.OnPointerDown(eventData);

        current = gameObject;
        currentEventData = eventData;

        if (onPointerDown != null) onPointerDown();

        current = null;
    }
    public override void OnPointerUp(PointerEventData eventData)
    {
        base.OnPointerUp(eventData);

        current = gameObject;
        currentEventData = eventData;

        if (onPointerUp != null) onPointerUp();

        current = null;
    }


    public override void OnBeginDrag(PointerEventData eventData)
    {
        isDragging = true;

        base.OnBeginDrag(eventData);

        current = gameObject;
        currentEventData = eventData;

        if (onBeginDrag != null) onBeginDrag();

        current = null;
    }

    public override void OnDrag(PointerEventData eventData)
    {
        base.OnDrag(eventData);

        current = gameObject;
        currentEventData = eventData;

        if (onDrag != null) onDrag();

        current = null;
    }

    public override void OnEndDrag(PointerEventData eventData)
    {
        base.OnEndDrag(eventData);

        current = gameObject;
        currentEventData = eventData;

        if (onEndDrag != null) onEndDrag();

        current = null;
        isDragging = false;
    }

    public override void OnDeselect(BaseEventData eventData)
    {
        base.OnDeselect(eventData);

        if (onDeselect != null) onDeselect();
    }

    public override void OnPointerEnter(PointerEventData eventData)
    {
        base.OnPointerEnter(eventData);

        if (onPointerEnter != null) onPointerEnter();
    }

    public override void OnPointerExit(PointerEventData eventData)
    {
        base.OnPointerExit(eventData);

        if (onPointerExit != null) onPointerExit();
    }

    public override void OnDrop(PointerEventData eventData)
    {
        base.OnDrop(eventData);

        current = gameObject;
        currentEventData = eventData;

        if (onDrop != null) onDrop();

        current = null;
    }
}
