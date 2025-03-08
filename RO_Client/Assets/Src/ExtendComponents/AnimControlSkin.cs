using System.Collections;
using System.Collections.Generic;
using LuaInterface;
using UnityEngine;

// [RequireComponent(typeof(Animator))]
public class AnimControlSkin : MonoBehaviour {
    private LuaTable m_LuaTable;
    private LuaFunction m_LuaFunction;

    private void OnDestroy () {
        m_LuaTable = null;
        m_LuaFunction = null;
    }

    public void SetBindLuaCallback (LuaTable luaTable, LuaFunction luaFunction) {
        m_LuaTable = luaTable;
        m_LuaFunction = luaFunction;
    }

    public void ChangeSkins (int[] skinSlotTypes, int[] roleAvatarIds) {
        if (m_LuaFunction != null) {
            if (m_LuaTable != null) {
                m_LuaFunction.Call (m_LuaTable, skinSlotTypes, roleAvatarIds);
            } else {
                m_LuaFunction.Call (skinSlotTypes, roleAvatarIds);
            }
        }
    }
}