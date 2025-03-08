using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public static class ConfigUtil
{
    public static bool HasLevel(int mapId,int levelId)
    {
        int tempId = mapId * 10000 + levelId;
        Dictionary<string, string> dic = ConfigMgr.Instance.getLine(tempId, Config.LevelCfgName);
        return dic != null;
    }
}
