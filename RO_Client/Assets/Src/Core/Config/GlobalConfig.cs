using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class GlobalConfig : Singleton<GlobalConfig>
{
    public const int c_total_fighttime_configid = 1;                 //战斗全局总时长
    public const int c_enter_bossbattle_time_config = 2;            //进入boss战斗的倒计时
    public const int c_enter_bossrage_time_configid = 3;            //boss的狂暴倒计时
    public const int c_skill_commoncd_configid = 4;                 //技能公共CD时长
    public const int c_refresh_monsterdistance_configid = 5;        //刷怪距离镜头的距离
    public const int c_boss_exitbattle_configid = 6;                //boss退场时长
    public const int c_battlesettlementtime_configid = 7;           //结算界面持续时长
    public const int c_failurecnt_configid = 8;                     //累计挂机战斗失败次数配置
    public const int c_boss_battlepower_ratio_configid = 9;         //boss狂暴提升的攻击力倍数
    public const int c_strategy_changedistance_configid = 10;       //巡游阵型变更持续距离
    public const int c_strategy_keepdistance_configid = 11;         //阵型保持的距离
    public const int c_walkspeed_configid = 12;                     //巡游状态的移动速度
    public const int c_rushspeed_configid = 13;                     //冲刺速度
    public const int c_boss_rage_attackspeed_ratio = 14;            //修改攻击速度比例
    public const int c_boss_shock_stop_time = 15;                   //增加boss预警停留时长
    public const int c_runsmoke_effectid = 16;                      //扬尘特效id
    public const int c_shadow_effectid = 17;                        //阴影特效id
    public const int c_self_effectid = 18;                          //主角光环
    public const int c_relive_effectid = 19;                        //复活特效
    public const int c_default_dropmoney_cnt = 20;                  //默认金币掉落个数
    public const int c_default_female_model = 21;                   //初始默认女角色模型
    public const int c_default_male_model = 22;                     //初始默认男角色模型
    public const int c_default_profession = 23;                     //初始默认职业
    public const int c_default_country = 24;                        //初始默认国家
    public const int c_default_head_icon = 25;                      //初始默认头像
    public const int c_role_id = 26;                                //主角id配置
    public const int c_base_attr_id = 27;                           //基础属性id
    public const int c_maxRotate_InTeam = 28;                       //目标为队友时的最大转动角度
    public const int c_switchboss_ui_waittime = 33;                 //切换boss ui隐藏时长
    public const int c_npc_sell_limit_radius = 34;                  // 限制NPC附近不能摆摊的半径
    public const int c_npc_collider_radius = 35;                    // 玩家和npc之间的碰撞检测半径
    public const int c_npc_trigger_radius = 36;                     // 玩家进入npc触发事件的半径
    public const int c_refresh_bossdistance_configid = 40;        //BOSS刷新距镜头固定距离
    public const int c_card_recreate_cost = 41;                     //卡片重置一次消耗
    public const int c_man_face_model_path = 42;                    // 男性角色脸部模型路径
    public const int c_woman_face_model_path = 43;                  // 女性角色脸部模型路径
    public const int c_man_base_model_path = 44;                    // 男性角色基本模型路径
    public const int c_woman_base_model_path = 45;                  // 女性角色基本模型路径
    public const int c_miniRewardTime_cfg_id = 47;                  // 领取奖励最少时间
    public const int c_enter_transfer_effectId = 49;                //进入传送点特效id
    public const int c_exit_transfer_effectId = 50;                 //离开传送特效id
    public const int c_transfer_effectid = 77;
    public const int c_gravity_cfg_id = 83;
    public const int c_keep_starktime_cfg_id = 84;
    public const int c_pauseEffect_cfg_id = 127;                    //开场boss暂停特写特效
    public const int c_arena_choosen_effectid = 165;                          //英灵殿选中特效
    public const int c_quit_battle_condition = 263;                          //巡遊boss 爬塔 退出按鈕出現條件
    public const int c_pet_scale_level = 314;                           //宠物等级对应体型
    public const int c_PressPointEffect = 40;                           //压制特效

    Dictionary<int, int> mIntValConfigDic = new Dictionary<int, int>();
    Dictionary<int, string> mStrValConfigDic = new Dictionary<int, string>();
    Dictionary<int, float> mFloatValConfigDic = new Dictionary<int, float>();
    
    public override void Init()
    {
        ReadConfig();

        Constants.gravity = GetConfigFloatValue(c_gravity_cfg_id);
        Constants.s_starkStopTime = GetConfigFloatValue(c_keep_starktime_cfg_id);
    }

    public override void UnInit()
    {

    }

    public int GetConfigIntValue(int id)
    {
        int iVal;
        mIntValConfigDic.TryGetValue(id, out iVal);
        return iVal;
    }

    public float GetConfigFloatValue(int id)
    {
        float fVal;
        mFloatValConfigDic.TryGetValue(id, out fVal);
        return fVal;
    }

    public string GetConfigStrValue(int id)
    {
        string sVal;
        mStrValConfigDic.TryGetValue(id, out sVal);
        return sVal;
    }

    void ReadConfig()
    {
        Dictionary<string, Dictionary<string, string>> cfg = ConfigMgr.Instance.getTable(Config.GlobalCfgName);
        if (cfg != null)
        {
            foreach(var p in cfg)
            {
                var key = p.Key;
                var dic = p.Value;
                

                int kVal = 0;
                if(int.TryParse(key,out kVal))
                {
                    int iVal = 0;
                    float fVal = 0;
                    string sVal = dic["SVal"];
                    int.TryParse(dic["IVal"], out iVal);
                    float.TryParse(dic["FVal"], out fVal);

                    if (iVal > 0)
                    {
                        mIntValConfigDic.Add(kVal, iVal);
                    }
                    if (fVal > 0)
                    {
                        mFloatValConfigDic.Add(kVal, fVal);
                    }
                    if (!string.IsNullOrEmpty(sVal))
                    {
                        mStrValConfigDic.Add(kVal, sVal);
                    }
                } 
            }
        }
    }
}
