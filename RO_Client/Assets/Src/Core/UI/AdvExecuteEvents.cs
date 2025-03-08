using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.EventSystems;

/// <summary>
/// 配合AdvStandaloneInputModule使用
/// </summary>
public static class AdvExecuteEvents
{
    public class EventFunction : UnityEvent<PointerEventData> {}

    private static EventFunction s_OnClick = new EventFunction();

    public static EventFunction onClick
    {
        get { return s_OnClick; }
        set { s_OnClick = value; }
    }

    public static void Execute(PointerEventData eventData, EventFunction functor)
    {
        if (functor == null) return;
        functor.Invoke(eventData);
    }
    
}
