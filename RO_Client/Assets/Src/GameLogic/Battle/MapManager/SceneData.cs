using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;

public class SceneData
{
    public const int SCENE_TYPE_COMMON = 1;//普通本

    private int mCurrentLevelTurn = 1;        //当前通关的场景
    private bool mbDisposed = false;

    private List<SceneItem> mSceneItems = new List<SceneItem>();
    private Dictionary<int, bool> mDictGotSceneFlags = new Dictionary<int, bool>();
   
    private SceneItem m_CurSceneItem;
    public SceneItem CurSceneItem
    {
        get 
        {
            return m_CurSceneItem; 
        }
        set
        {
            m_CurSceneItem = value;
        }
    }

    public SceneData()
    {
    }

	public void Dispose()
	{
		if (mbDisposed)
			return;

        if (m_CurSceneItem != null)
        {
            m_CurSceneItem.Dispose();
            m_CurSceneItem = null;
        }

        if (mSceneItems != null)
        {
            for (int idx = 0; idx < mSceneItems.Count; idx++)
            {
                if (mSceneItems[idx] != null)
                {
                    mSceneItems[idx].Dispose();
                    mSceneItems[idx] = null;
                }
                mSceneItems.Clear();
            }
        }

        if (mDictGotSceneFlags != null) {
			mDictGotSceneFlags.Clear ();
			mDictGotSceneFlags = null;
		}

		mbDisposed = true;
	}

    public void ClearDict()
    {
        mSceneItems.Clear();
    }

    public SceneItem GetSceneItem(int type, int id)
    {
        List<SceneItem> scenes = GetSceneItemsByType(type);
        if (scenes == null) return null;

        for (int i = 0; i < scenes.Count; ++i)
        {
            if (scenes[i].MapId == id) return scenes[i];
        }

        return null;
    }

    /// <summary>
    /// use for common dungeon
    /// </summary>
    /// <param name="id"></param>
    /// <returns></returns>
    public LevelItem GetLevelByID(int id) 
    {        
        for (int i = 0; i < mSceneItems.Count; i++)
        {
            for (int n = 0; n < mSceneItems[i].LevelItems.Length; n++)
            {
                if (mSceneItems[i].LevelItems[n].LevelId == id)
                    return mSceneItems[i].LevelItems[n];
            }
        }
        return null;
    }

    public string GetSceneTypeDes(int type) 
    {
        string result = "";
        return result;
    }

    public List<SceneItem> GetSceneItemsByType(int type)
    {
        return mSceneItems;
    }

    public void ResetDictGotSceneFlags(int type)
    {
        if(mDictGotSceneFlags.ContainsKey(type))
        {
            mDictGotSceneFlags[type]=false;
        }
    }

    public int GetSceneCount(int type)
    {
        return mSceneItems.Count;
    }

    public int GetPassLevelCount(int type)
    {
        int count = 0;
        for (int i = 0; i < mSceneItems.Count; i++)
        {
            LevelItem[] mCurrentSceneDungeons = mSceneItems[i].LevelItems;
            for (int j = 0; j < mCurrentSceneDungeons.Length; j++)
            {
                if (mCurrentSceneDungeons[j].HasPassed)
                {
                    count++;
                }
            }
        }
        return count;
    }

    public bool IsGotSceneList(int type)
    {
        bool bGot = false;
        if (mDictGotSceneFlags.TryGetValue(type, out bGot))
        {
            return bGot;
        }
        return false;
    }

    public SceneItem GetSceneFromConfig(int sceneID)
    {
        return new SceneItem(sceneID);
    }
}

public class SceneItem : IComparable<SceneItem>
{
    #region fields
    private int mMapId = 0;
    public int MapId
    {
        get { return mMapId; }
    }

    private string mName = "";
    public string Name
    {
        get { return mName; }
    }

    private string mDesciption = "";
    public string Description
    {
        get { return mDesciption; }
    }

    private string mMusicName = "";
    public string MusicName
    {
        get { return mMusicName; }
    }

    private string mAssetPath = "";
    public string AssetPath
    {
        get { return mAssetPath; }
    }

    private string mPath = "";
    public string Path
    {
        get { return mPath; }
    }

    //关卡数目
    private int mLevelNum = 0;
    public int LevelNum
    {
        get { return mLevelNum; }
    }

    bool mbDisposed = false;

    private LevelItem[] mLevelItems = null;
    
    private LevelItem mCurrentLevelItem = null;

    public LevelItem[] LevelItems
    {
        get
        {
			return mLevelItems == null ? new LevelItem[0]: mLevelItems;
        }
    }

    public LevelItem CurrentLevelItem
    {
        get { return mCurrentLevelItem; }
        set { mCurrentLevelItem = value; }
    }
    #endregion

    public SceneItem(int id)
    {
        this.mMapId = id;
        ReadLevelFromConfig();
    }

    ///// <summary>
    ///// 获得下一关
    ///// </summary>
    ///// <param name="index"></param>
    ///// <returns></returns>
    //public LevelItem TryGetNextFightLevel(int levelId,out int index)
    //{       
    //    for (int i = 0; i < mLevelItems.Count; i++)
    //    {
    //        if (mLevelItems[i].LevelId == levelId)
    //        {
    //            index = i;
    //            return mLevelItems[i];               
    //        }
    //    }
    //    index = 0;
    //    return null;
    //}

    public int CompareTo(SceneItem other) 
    {
        if (this.MapId < other.MapId)
            return -1;
        else if (this.MapId == other.MapId)
            return 0;
        else
            return 1;
    }

	public void Dispose()
	{
		if (mbDisposed)
			return;

		if (mLevelItems != null) {
			for (int i = 0; i < mLevelItems.Length; ++i) {
				if (mLevelItems [i] != null) {
					mLevelItems [i].Dispose ();
					mLevelItems [i] = null;
				}
			}
			mLevelItems = null;
		}

		mCurrentLevelItem = null;	
		mbDisposed = true;
	}

    ////整个地图是否通过
    //public bool HasPassed 
    //{
    //    get 
    //    {
    //        return LevelItems[LevelItems.Length - 1].HasPassed;
    //    }
    //}

    public int GetLevelIndex(int id) 
    {
        for (int i = 0; i < LevelItems.Length; i++)
        {
            if (LevelItems[i].LevelId == id) 
            {
                return i;
            }
        }
        return 0;
    }

    //public LevelItem GetLevelByTurn(int leveId)
    //{
    //    for (int i = 0; i < LevelItems.Length; i++)
    //    {
    //        if (LevelItems[i].LevelId == leveId)
    //        {
    //            return LevelItems[i];
    //        }

    //    }
    //    return null;
    //}

    //public int GetCurLevelIndex()
    //{
    //    int id = CurrentLevelItem.LevelId;
    //    for (int i = 0; i < LevelItems.Length; i++)
    //    {
    //        if (LevelItems[i].LevelId == id)
    //        {
    //            return i;
    //        }

    //    }
    //    return 0;
    //}

    public LevelItem GetLevelItem(int id)
    {
        LevelItem item = null;
        for (int i = 0, len = mLevelItems.Length; i < len; ++i)
        {
            if (mLevelItems[i] != null && mLevelItems[i].LevelId == id)
            {
                item = mLevelItems[i];
                break;
            }
        }
        return item;
    }

    ////判断是否为最后一关
    //public bool IsLastLevel(int levelId)
    //{
    //    return mLevelItems[mLevelItems.Count - 1].LevelId == levelId;
    //}

    void ReadLevelFromConfig()
    {
        List<LevelItem> levelList = new List<LevelItem>();
        Dictionary<string, string> dic = ConfigMgr.Instance.getLine(MapId,Config.MapCfgName);
        if (dic != null)
        {
            int levelId = 1;
            while (ConfigUtil.HasLevel(this.MapId, levelId))
            {
                LevelItem li = new LevelItem(this.MapId, levelId);
                levelList.Add(li);
                levelId++;
            }
            mLevelNum = levelList.Count;
        }
        mLevelItems = levelList.ToArray();
    }
}