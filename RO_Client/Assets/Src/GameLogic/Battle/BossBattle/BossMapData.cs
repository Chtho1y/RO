using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class BossMapData
{
    public int id;
    public string name;
    public string levelName;
    public string bgmMusic;
    public bool hasBossComingAnim;
    public float bossComingTime;

    public BossMapData(int mapId)
    {
        Dictionary<string, string> dic = ConfigMgr.Instance.getLine(mapId, Config.BossMapCfg);
        if(dic!=null)
        {
            this.id = mapId;
            this.name = dic["Name"];
            this.levelName = dic["LevelName"];
            this.bgmMusic = dic["BattleMusic"];

            if(dic.ContainsKey("BossAnimation"))
            {
                int temp;
                int.TryParse(dic["BossAnimation"], out temp);
                hasBossComingAnim = temp > 0;
            }
            
            if(dic.ContainsKey("BossAnimationTime"))
            {
                float.TryParse(dic["BossAnimationTime"], out bossComingTime);
            }
        }
        else
        {
            DebugHelper.LogError(string.Format("{0} boss地图配置不存在", mapId));
        }
    }
}
