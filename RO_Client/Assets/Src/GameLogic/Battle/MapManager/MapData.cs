using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public enum GameMode
{
	GameMode_Normal = 0,
}

public enum LevelWinCondition
{
	LevelWinCondition_LastField_Or_HaveNoEnemy = 0,
	LevelWinCondition_LastField = 1,
	LevelWinCondition_HaveNoEnemy = 2,
}

//自动转场类型
public enum AutoInterludeType
{
    AutoInterlude_None = 0,                             //什么都不做
    AutoInterlude_SetToNextField = 1,                   //相机瞬切到下一个战场，玩家和敌人从战场左右两边进入
    AutoInterlude_RunToNextField = 2,                   //相机跟踪玩家，玩家自动跑到下一个战场等待战斗开始
    AutoInterlude_MoveCameraToNextField_Normal = 3,     //相机移动（平移）到下一个战场，玩家和敌人从战场左右两边进入
    AutoInterlude_MoveCameraToNextField_Jump = 4,       //相机移动（跳跃）到下一个战场，玩家和敌人从战场左右两边进入
    AutoInterlude_CameraAnimationToNextField = 5,       //自动过渡到动画起始点，播放指定相机动画，并自动过渡到战场相机，玩家和敌人从战场左右两边进入
}

/// <summary>
/// 战斗胜利条件
/// </summary>
public enum BattleWinCondition
{
	BattleWinCondition_All_Die = 0,         //所有敌人死亡
	BattleWinCondition_Life_Less = 1,       //敌人血量低于
	BattleWinCondition_Timeout = 2,         //时间到
}

/// <summary>
/// 战斗失败的条件
/// </summary>
public enum BattleLoseCondition
{
	BattleLoseCondition_All_Die = 0,            //所有英雄死亡
	BattleLoseCondition_Life_Less = 1,          //敌人血量低于
	BattleLoseCondition_Timeout = 2,            //时间到
}

public class AutoInterludeInfo
{
	public AutoInterludeType type;
	JSONObject parameters;

	public int GetN (int idx = 0)
	{
		if (parameters == null)
			return 0;
        
		if (parameters.IsArray && parameters.Count > idx + 1 && parameters [idx].IsNumber)
			return (int)parameters [idx].n;

		if (parameters.isContainer && parameters.list.Count > idx + 1 && parameters.list [idx].IsNumber)
			return (int)parameters.list [idx].n;

		return 0;
	}

	public int GetN (string paramName)
	{
		if (parameters == null || !parameters.isContainer || !parameters.HasField (paramName) || !parameters [paramName].IsNumber)
			return 0;

		return (int)parameters [paramName].n;
	}

	public string GetStr (int idx = 0)
	{
		if (parameters == null)
			return string.Empty;

		if (parameters.IsArray && parameters.Count > idx + 1 && parameters [idx].IsString)
			return parameters [idx].str;

		if (parameters.isContainer && parameters.list.Count > idx + 1 && parameters.list [idx].IsString)
			return parameters.list [idx].str;

		return string.Empty;
	}

	public string GetStr (string paramName)
	{
		if (parameters == null || !parameters.isContainer || !parameters.HasField (paramName) || !parameters [paramName].IsString)
			return string.Empty;

		return parameters [paramName].str;
	}

	public float GetFloat (string paramName)
	{
		if (parameters == null || !parameters.isContainer || !parameters.HasField (paramName) || !parameters [paramName].IsString)
			return 0;

		return parameters [paramName].ParseF ();
	}

	public Vector3 GetVector3 (int idx = 0)
	{
		if (parameters == null)
			return Vector3.zero;

		if (parameters.IsArray && parameters.Count > idx + 1 && parameters [idx].IsArray)
			return JSONObject.ParseVector3FromJson (parameters [idx]);

		if (parameters.isContainer && parameters.list.Count > idx + 1 && parameters.list [idx].IsArray)
			return JSONObject.ParseVector3FromJson (parameters.list [idx]);

		return Vector3.zero;
	}

	public Vector3 GetVector3 (string paramName)
	{
		if (parameters == null || !parameters.isContainer || !parameters.HasField (paramName) || !parameters [paramName].IsArray)
			return Vector3.zero;

		return JSONObject.ParseVector3FromJson (parameters [paramName]);
	}

	public Vector2 GetVector2 (int idx = 0)
	{
		if (parameters == null)
			return Vector2.zero;

		if (parameters.IsArray && parameters.Count > idx + 1 && parameters [idx].IsArray)
			return JSONObject.ParseVector2FromJson (parameters [idx]);

		if (parameters.isContainer && parameters.list.Count > idx + 1 && parameters.list [idx].IsArray)
			return JSONObject.ParseVector2FromJson (parameters.list [idx]);

		return Vector2.zero;
	}

	public AutoInterludeInfo (AutoInterludeType interludeType)
	{
		type = interludeType;
	}
}

public class MapItemData
{
	public int id;
	public string name;
	public string levelname;
	public string description;
	public string bgmusic;

	public LevelItem[] battles;        //战斗信息

	public int cameraGroup = -1;
	public GameMode gameMode;

    public MapItemData(int mapId,LevelItem[] levelItems)
    {
        Dictionary<string, string> dic = ConfigMgr.Instance.getLine(mapId, Config.MapCfgName);
        if (dic != null)
        {
            this.id = mapId;
            this.name = dic["Name"];
            this.levelname = dic["LevelName"];
            if (dic.ContainsKey("BgmMusic"))
                bgmusic = dic["BgmMusic"];
            else
                bgmusic = "";

            if (dic.ContainsKey("Description"))
                description = dic["Description"];
            else
                description = string.Empty;

            battles = levelItems;
            gameMode = GameMode.GameMode_Normal;
        }
        else
        {
            DebugHelper.LogError(string.Format("{0} map配置不存在", mapId));
        }
        
    }
}