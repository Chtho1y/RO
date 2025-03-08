using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CGLogic : MonoBehaviour 
{
    public Transform m_cgRoot;
    public Transform m_cgAutoFinish;

    private string m_strLuaScriptName = "LuaCG";
	// Use this for initialization
	void Start () 
    {     
        LuaUtil.LuaDoFile(LuaClient.Instance.luaState, LuaUtil.GetUILuaPath(m_strLuaScriptName));
        LuaUtil.CallCS2Lua(LuaUtil.GetLuaScriptModuleName(m_strLuaScriptName) + "OnStart", m_cgRoot, m_cgAutoFinish);
	}
	
    void OnDestroy()
    {
        LuaUtil.CallCS2Lua(LuaUtil.GetLuaScriptModuleName(m_strLuaScriptName) + "OnDispose");
    }
}
