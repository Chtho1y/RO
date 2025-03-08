using UnityEngine;
using System.Collections;

public class UIData
{
    private int mPageId;
    public int PageID
    {
        get { return mPageId; }
    }

    private string mUIName;
    public string UIName
    {
        get { return mUIName; }
    }

    private string mLuaScriptName;
    public string LuaScriptName
    {
        get { return mLuaScriptName; }
    }

    private string[] mUIAssetsName;
    public string[] UIAssetsName
    {
        get
        {
            return mUIAssetsName;
        }
    }
}
