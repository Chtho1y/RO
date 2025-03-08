using UnityEngine;
using System.Collections;

/// <summary>
/// 释放技能的参数
/// </summary>
public class CastSkillData
{
    public long actorId;
    public int teamSide;
    public bool isBoss;

    public int skillId;
    public string skillIcon;            //当前技能ICON
    public float cdTime;                //距离下个技能可释放时长
    public bool IsForbidden;            //是否处于禁止释放
    public bool IsEnhance;              //是否处于增加状态
    public bool IsCasting;              //正在是否技能
}

public class SkillCDParam
{
    public int actorId;
    public bool isBoss;
    public float leftCD;
    public float totalCD;
}
