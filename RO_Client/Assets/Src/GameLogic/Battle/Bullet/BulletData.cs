using UnityEngine;
using System.Collections;
using System;
using System.Collections.Generic;

//子弹移动类型
public enum BulletMoveType
{
    Bullet_Move_Target_Toward = 0, //向目标移动， 总是面朝移动方向
    Bullet_Move_Trace_Target_Toward = 1,  //跟踪目标, 总是面朝移动方向
    Bullet_Move_Throw_Toward = 2, //抛掷，总是面朝移动方向
    Bullet_Move_Target = 3,    //向目标移动
    Bullet_Move_Forward = 4,   //向前移动
    Bullet_Move_Trace_Target = 5,    //跟踪目标
    Bullet_Move_Throw = 6,    //抛掷
    Bullet_Move_Forward_Toward = 7,    //向前移动，总是面朝移动方向
    Bullet_Move_None = 8,  //不移动
}

//子弹(炮弹)碰撞销毁类型
public enum BulletHitDestroyType
{
    Bullet_HitDestroy_Fighter = 0,    //碰撞玩家销毁
    Bullet_HitDestroy_Penetrate = 1,  //穿透玩家销毁
    Bullet_HitDestroy_Floor = 2,  //碰撞地面销毁
    Bullet_HitDestroy_None = 3,  //不碰撞，到时间销毁
    Bullet_HitDestroy_Target = 4,  //类似0,但只有碰撞到目标才会发生事件
    Bullet_HitDestory_Fighter_Floor = 5,	//碰撞到地面或者玩家都会销毁
}

public class BulletData
{
    public int id;
    public EffectFollowType followType;
    public EffectTargetType targetType;
    public Vector3 offset;
    public string effect;
    public EffectType actorType;
    public float lifeTime;
    public string sound;
    public Vector3 targetOffset;
    public BulletHitDestroyType hitDestroyType;
    
    public Vector3 initSpeedVec;
    public Vector3 accelationSpeedVec;
    public float accelationDuration;

    public string targetLink;   //目标随机范围
    public string startLink;    //出发点随机范围
    public BulletMoveType moveType;         //移动类型

    private float[] mHurtDist = null;
    private int[] mHurtFrames = null;

    public float[] HurtDist
    {
        get { return mHurtDist; }
    }

    public int[] HurtFrames
    {
        get { return mHurtFrames; }
    }

    public BulletData(int id)
    {
        Dictionary<string, string> cfg = ConfigMgr.Instance.getLine(id, Config.BulletCfgName);
        if(cfg!=null)
        {
            this.id = id;
            if (cfg.ContainsKey("Prefab"))
                this.effect = cfg["Prefab"];

            if (cfg.ContainsKey("Link"))
                this.startLink = cfg["Link"];

            if (cfg.ContainsKey("TargetLink"))
                this.targetLink = cfg["TargetLink"];

            if (cfg.ContainsKey("FlyDuration"))
                float.TryParse(cfg["FlyDuration"], out lifeTime);

            if(cfg.ContainsKey("VelocityVector"))
            {
                initSpeedVec = StringUtil.convertVector3(cfg["VelocityVector"]);
            }

            if(cfg.ContainsKey("VariableSpeed"))
            {
                accelationSpeedVec = StringUtil.convertVector3(cfg["VariableSpeed"]);
            }

            if(cfg.ContainsKey("VariableTime"))
            {
                float.TryParse(cfg["VariableTime"], out accelationDuration);
            }

            if(cfg.ContainsKey("HurtFrames"))
            {
                string[] strTemps =  StringUtil.split(cfg["HurtFrames"], ';');
                if(strTemps != null)
                {
                    mHurtDist = new float[strTemps.Length];
                    mHurtFrames = new int[strTemps.Length];

                    for (int idx =0; idx < strTemps.Length;idx++)
                    {
                        string[] strTemps2 = StringUtil.split(strTemps[idx], ':');
                        if(strTemps2 != null && strTemps2.Length == 2)
                        {
                            float dist = 0;
                            int frame = 0;
                            float.TryParse(strTemps2[0], out dist);
                            int.TryParse(strTemps2[1], out frame);
                            mHurtDist[idx] = dist;
                            mHurtFrames[idx] = frame;
                        }
                    }
                }
            }

            actorType = EffectType.EffectType_Fly;
            hitDestroyType = BulletHitDestroyType.Bullet_HitDestroy_Target;
            moveType = BulletMoveType.Bullet_Move_Forward_Toward;
            targetType = EffectTargetType.Effect_Target_Self;
        }
        else
        {
            DebugHelper.LogError("读取子弹特效数据 {0} 出错", id);
        }
    }
}
