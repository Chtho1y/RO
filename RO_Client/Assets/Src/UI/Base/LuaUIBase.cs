using LuaInterface;
using System;
using UnityEngine;

public class LuaUIBase : UIBase
{
    [HideInInspector]
    public LuaTable MLuaTable
    {
        set { m_luaTable = value; }
        get { return m_luaTable; }
    }

    [SerializeField]
    private LuaTable m_luaTable = null;

    protected override void OnAwake()
    {

        m_luaTable.CallCS2Lua<object>("OnAwake", m_Data);
        //LuaUtil.CallCS2Lua<object>(LuaUtil.GetLuaScriptModuleName(m_strLuaScriptName) + "OnAwake", m_Data);

    }

    protected override void AddEventListener()
    {
        m_luaTable.CallCS2Lua("AddEventListener");
        //LuaUtil.CallCS2Lua(LuaUtil.GetLuaScriptModuleName(m_strLuaScriptName) + "AddEventListener");
    }

    protected override void FillContent()
    {
        try
        {
            m_luaTable.CallCS2Lua<object, LuaUIBase>("FillContent", m_Data, this);

            if (mIsShowed)
                OnBaseShow();
        }
        catch(System.Exception e)
        {
            DebugHelper.LogError("PageId:"+PageId+" error:"+e.Message);
        }
    }

    protected override void RemoveEventListener()
    {
        if (!Inited)
            return;

        m_luaTable.CallCS2Lua("RemoveEventListener");
        //LuaUtil.CallCS2Lua(LuaUtil.GetLuaScriptModuleName(m_strLuaScriptName) + "RemoveEventListener");
    }

    protected override void AddUIEventListener()
    {
        if (!Inited)
            return;

        m_luaTable.CallCS2Lua("AddUIEventListener");
       // LuaUtil.CallCS2Lua(LuaUtil.GetLuaScriptModuleName(m_strLuaScriptName) + "AddUIEventListener");
    }

    protected override void OnHide()
    {
        if (!Inited)
            return;

        OnBaseHide();
        m_luaTable.CallCS2Lua("OnHide");
        //LuaUtil.CallCS2Lua(LuaUtil.GetLuaScriptModuleName(m_strLuaScriptName) + "OnHide");
    }

    protected override void OnShow()
    {
        if (!Inited)
            return;

        m_luaTable.CallCS2Lua("OnShow", m_Data);
        if (mIsShowed)
            OnBaseShow();
        //LuaUtil.CallCS2Lua(LuaUtil.GetLuaScriptModuleName(m_strLuaScriptName) + "OnShow");
        //LuaUtil.CallCS2Lua(LuaUtil.GetLuaScriptModuleName("UILauncher") + "OnUIShow", mUIData.PageID);
    }


    protected override void OnClose()
    {
        if (!Inited)
            return;

        OnBaseHide();
        OnBaseClose();
        m_luaTable.CallCS2Lua("OnClose");
        //LuaUtil.CallCS2Lua(LuaUtil.GetLuaScriptModuleName(m_strLuaScriptName) + "OnClose");
    }

    protected override void OnDispose()
    {
        if (Inited)
        {
            OnBaseDispose();
            m_luaTable.CallCS2Lua("OnDispose");
        }
      
        m_luaTable.CallCS2Lua("DisposeView");
        //LuaUtil.CallCS2Lua(LuaUtil.GetLuaScriptModuleName(m_strLuaScriptName) + "OnDispose");
        MLuaTable = null;
        // 引导功能
        //LuaUtil.CallCS2Lua(LuaUtil.GetLuaScriptModuleName("UILauncher") + "OnUIDispose", mUIData.PageID);
    }
    protected override void OnBackIn()
    {
        //m_luaTable.CallCS2Lua("OnBackIn");
        //Show();
    }

    protected override void OnBaseHide()
    {
        if (!Inited)
            return;
        m_luaTable.CallCS2Lua("OnBaseHide");
    }

    protected override void OnBaseShow()
    {
        if (!Inited)
            return;
        m_luaTable.CallCS2Lua("OnBaseShow");
    }
    protected override void OnBaseClose()
    {
        if (!Inited)
            return;
        m_luaTable.CallCS2Lua("OnBaseClose");
    }

    protected override void OnBaseDispose()
    {
        if (!Inited)
            return;
        m_luaTable.CallCS2Lua("OnBaseDispose");
    }

    protected override void OnPageOutEnd()
    {
        if (!Inited)
            return;

        m_luaTable.CallCS2Lua("OnPageOutEnd");
    }

    protected override void OnPageInEnd()
    {
        if (!Inited)
            return;

        m_luaTable.CallCS2Lua("OnPageInEnd");
    }

    public override void OnSubCloseAnimEnd(string path)
    {
        if (!Inited)
            return;
        m_luaTable.CallCS2Lua<string>("OnSubClose", path);
    }
}

