using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;

public enum EffectFollowType
{
    Effect_Follow_None = 0, //不更随
    Effect_Follow_Self = 1, //更随自身
    Effect_Follow_Target = 2,   //更随目标
    Effect_Follow_Camera_Back = 3,   //跟随相机，底层渲染，一般全屏特效使用
    Effect_Follow_Bullet = 4,   //更随子弹
    Effect_Follow_Camera_Normal = 5,   //跟随相机
    Effect_Follow_Self_Bloodbar = 6,    //跟随自身血条
    Effect_Follow_Target_Bloodbar = 7,  //跟随目标血条
    Effect_Follow_Self_Floor = 8,  //跟随自身贴地
    Effect_Follow_Target_Floor = 9,  //跟随目标贴地
}

public enum EffectTargetType
{
    Effect_Target_None = 0,
    Effect_Target_Self = 1,
    Effect_Target_Target = 2,
    Effect_Target_Bullet = 3,
    Effect_Target_Self_Floor = 4,
    Effect_Target_Target_Floor = 5,
    Effect_Target_To_Self = 6,
    Effect_Self_To_Target = 7,
}

public enum EffectType
{
    EffectType_None = 0,
    EffectType_Fly = 1,
    EffectType_Summon = 2,
    EffectType_Ball = 3,
    EffectType_Common = 4,
}

public enum EffectFlyType
{
    EffectFlyType_None = 0,
}

public enum EffectHitType
{
    EffectHitType_Destroy = 0,
    EffectHitType_Boom = 1,
    EffectHitType_Bebound = 2,
    EffectHitType_Through = 3,
}

public class EffectData
{
    public int id;
    public float lifeTime;
    public float delay;

    public EffectFollowType followTargetType;
    public EffectTargetType targetType;
    public string targetObjName;
    public string effect;
    public Vector3 rot = Vector3.zero;

    public bool valid = false;

    public EffectData(int id)
    {
        valid = false;

        if (id == 0) return;

        Dictionary<string, string> dic = ConfigMgr.Instance.getLine(id, Config.EffectCfgName);
        if (dic != null)
        {
            this.id = id;

            this.effect = dic["Effect"];
            this.targetObjName = dic["Link"];

            if (dic.ContainsKey("LifeTime"))
            {
                float.TryParse(dic["LifeTime"], out this.lifeTime);
            }

            if (dic.ContainsKey("FollowType"))
            {
                followTargetType = (EffectFollowType)int.Parse(dic["FollowType"]);
            }
            else
            {
                followTargetType = EffectFollowType.Effect_Follow_Self;
            }


            if (dic.ContainsKey("TargetType"))
            {
                targetType = (EffectTargetType)int.Parse(dic["TargetType"]);
            }
            else
            {
                targetType = EffectTargetType.Effect_Target_Self;
            }

            if(dic.ContainsKey("Rot"))
            {
                rot = StringUtil.convertVector3(dic["Rot"]);
            }
            
            valid = true;
        }
        else
        {
            DebugHelper.LogWarning("特效ID {0} 不存在", id);
        }
    }
}