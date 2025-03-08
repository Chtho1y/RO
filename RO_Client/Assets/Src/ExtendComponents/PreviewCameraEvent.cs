using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using LuaInterface;

[RequireComponent(typeof(Camera))]
public class PreviewCameraEvent : MonoBehaviour
{
    private LuaTable m_LuaSelf;
    private LuaFunction m_OnPreCullEvent;
    private LuaFunction m_OnPostRenderEvent;

    public void SetBindEvent(LuaTable luaSelf, LuaFunction preCullEvent, LuaFunction onPostRenderEvent)
    {
        m_LuaSelf = luaSelf;
        m_OnPreCullEvent = preCullEvent;
        m_OnPostRenderEvent = onPostRenderEvent;
    }

    private void OnPreCull() {
        if (m_OnPreCullEvent != null)
        {
            if (m_LuaSelf != null)
            {
                m_OnPreCullEvent.Call(m_LuaSelf);
            }
            else
            {
                m_OnPreCullEvent.Call();
            }
        }
    }

    private void OnPostRender() {
        if (m_OnPostRenderEvent != null)
        {
            if (m_LuaSelf != null)
            {
                m_OnPostRenderEvent.Call(m_LuaSelf);
            }
            else
            {
                m_OnPostRenderEvent.Call();
            }
        }
    }
}
