using UnityEngine;
using System.Collections;

public enum Level_Type
{
    Small_Level = 1,        //小关卡
    Big_Level = 2,          //大关卡
    SwitchMap_Level = 3,    //切换地图的关卡
}

public enum Position_Type
{
    Position_None = 0,  //未指定
    Position_Front = 1, //前排
    Position_Middle = 2,  //中排
    Position_Back = 3,  //后排
}

//技能目标阵营
public enum FilterTeamType
{
    Team_Type_Self_Team = 1,    //我方
    Team_Type_Enemy = 2,    //敌方
}

//技能选择类型
public enum FilterActorType
{
    Actor_Type_All = -1,
    Actor_Type_Hero = 1,
    Actor_Type_Fellow = 2,
    Actor_Type_Monster = 3,
    Actor_Type_Pet = 4,
    Actor_Type_Hero_Fellow = 5,
    Actor_Type_Exclude_Pet = 6,     //去掉宠物全体
}

public enum FilterParamType
{
    Param_Type_None = 0,
    Param_Type_Profession = 1,
    Param_Type_Nature = 2,
    Param_Type_PetId = 3,
}


//技能选择目标规则
public enum Target_Select_Rule
{
    Target_Select_All = -1,                     //全体
    Target_Select_OnlyOne = 1,                  //单体
    Target_Select_Self = 2,                    //自己
    Target_Select_LeastBlood = 3,               //生命最低
    Target_Select_Exclude_Self = 4,             //除自己以外的队友
    Target_Select_Exclude_Target = 5,           //除目标以外的其他对象
    Target_Select_RandomOne = 6,                //随机1个目标
    Target_Select_RandomOne_Prior_Front = 7,    //随机1个目标，优先前排
    Target_Select_RandomOne_Prior_Back = 8,    //随机1个目标，优先后排
    Target_Select_Pos_Prior_Front = 9,          //整排目标，优先前排
    Target_Select_Pos_Prior_Back = 10,          //整排目标，优先后排
    Target_Select_Most_NegativeBuff = 11,       //减益buff最多的单位
    Target_Select_Most_LeastLifePercent = 12,   //生命百分比最低的单位
    Target_Select_MostLife = 13,                //血量最高的单位
    Target_Select_Owner = 14,                   //宠物关联的主人
    Target_Select_Owner_And_Pet = 15,           //宠物和主人
}

//伤害类型
public enum Damage_Type
{
    Attack_Type_Physic = 1,  //物理伤害
    Attack_Type_Magic = 2,  //魔法伤害 
    Attack_Type_Realtime = 3,   //真实伤害
}

public enum EUIPageType
{
    Null = 0,
    Full = 1,
    Popup = 2,
    Tips = 3,
    Max
}


/// <summary>
/// 英雄职业类型
/// </summary>
public enum ProfessionType
{
    Pro_Type_0 = 0,         //初心者
    Pro_Type_Sword = 1,     //剑士
    Pro_Type_Thief = 2,     //盗贼
    Pro_Type_Hunter = 3,    //弓手
    Pro_Type_Magic = 4,     //法师
    Pro_Type_Priest = 5,    //服侍
}

public enum FightingResult
{
    None = 0,
    Win = 1,
    Failed = 2,
    Peace = 3,
}

public enum SkillTriggerType
{
    None = 0,                                       //表示普通攻击,不受任何的限制
    Immediately_Casting = 1,                        //顺发技能
    Continuous_Casting_NoSing = 2,                  //免吟唱持续施法
    Casting_Sing = 3,                               //吟唱直接施法
    Continuous_Casting_Sing = 4,                    //吟唱持续施法
    Passive_Trigger = 5,                            //被动技能
}

public enum Nature_Type
{
    None = 1,
    Nature_Water = 2,       //水
    Nature_Ground = 3,      //地
    Nature_Fire = 4,        //火
    Nature_Wind = 5,        //风
    Nature_Saint = 6,       //圣
    Nature_Dark = 7,        //暗
    Nature_Read = 8,        //念

    Max = 9,
}

public enum BossIntroType
{
    None = 0,
    Warning = 1,
    BossIntro = 2,
}

public enum BuffTriggerCasterType
{
    self = 1,           //自己
    target = 2,         //目标
    friends = 3,        //己方
    enemies = 4,        //敌方
    host = 5,           //主人
}

public enum BuffTriggerType
{
    None = 0,
    Trigger_Attack = 1,                 //发动攻击
    Trigger_Hit = 2,                    //受到攻击
    Trigger_Heal = 3,                   //释放治疗
    Trigger_Healed = 4,                 //受到治疗
    Trigger_Vertigo = 5,                //遭受眩晕    
    Trigger_Damage_From_Crit = 6,       //遭受暴击
    Trigger_Damage_With_Crit = 7,       //打出暴击时
    Trigger_Miss = 8,                   //闪避
    Trigger_Damage_Missed = 9,          //攻击被闪避
    Trigger_HP_Lower = 10,              //血量低于
    Trigger_Negative_Fun = 11,          //身上有负面状态时
    Trigger_CastingSkill = 12,          //发动技能时
    Trigger_Break_SingSkill = 13,       //打断施法技能
    Trigger_SingSkill_Broken = 14,      //施法技能被打断
    Trigger_FixedTime = 15,             //固定时间触发
    Trigger_AddSp = 16,                 //回蓝时
    Trigger_FixedSkill_CritDamage = 17,      //固定技能暴击
    Trigger_FixedSkill_Broken = 18,           //固定技能被打断
    Trigger_FixedSkill_Break_Skill = 19,      //固定技能打断目标
    Trigger_FixedSkill_Avoid = 20,           //固定技能未命中
    Trigger_FixedSkill_KillTarget = 21,      //固定技能杀死目标
    Trigger_FixedSkill_DisperseBuff = 22,     //固定技能驱散目标buff
    Trigger_FixedSkill_PurifyDeBuff = 23,       //固定技能净化buff
    Trigger_Add_Shield = 24,                    //叠加护盾时
    Trigger_Clear_Shield = 25,                  //破盾时
    Trigger_Accumulative_TakeDamage = 26,       //承受伤害达到xxx触发【只触发一次】
    Trigger_Multi_Accumulative_TakeDamage = 27, //每次累计承受xxxx伤害触发
    Trigger_Begin_Fighting = 28,                //战斗开始就触发

    Trigger_Silence = 29,                       //沉默触发
    Trigger_Curse = 30,                         //诅咒触发
    Trigger_Multi_Accumulative_TakeDamage_Precent = 31,  //每次累计承受xxxx伤害血量百分触发
    Trigger_Accumulative_TakeDamage_Precent = 32,               //承受伤害达到xxx触发【只触发一次】
}

public enum FighterMoveType
{
    None = 0,
    Beat_Back = 1,      //击退
    Sprint_Position = 2,         //冲刺到位置
    Sprint_Target = 3,           //冲刺到目标
    Jump = 4,                    //跳起
    Beat_Fly = 5,                //击飞
    Beat_Down = 6,               //掉落
}

public enum Role_Gender
{
    None = 0,       //无
    Female = 1,     //女
    Male = 2,       //男
}

public enum eTeamType
{
    Friend = 0,     //我方
    Enemy = 1,      //地方
}

public enum SceneType
{
    LoginScene = 0,             //登录场景
    CreateRoleScene = 1,        //创建角色场景
    NormalBattleScene = 2,      //普通战斗场景
    GuildLobbyScene = 3,          //公会大厅场景
    TowerBattleScene = 4,       //爬塔战斗场景
    BossBattleScene = 5,        //boss战斗场景
    TimeBattleScene = 6,        //时间战斗类型的场景
}

public enum BodyPart : int
{
    HeadTop = 1,        //头上
    HeadMiddle = 2,     //头中
    HeadBottom = 3,     //头下
    Cloth = 4,
    LeftWeapon = 5,
    RightWeapon = 6,
    Back = 7,
    HairStyle = 8,        // 时装头发
    Pupil = 9,            // 时装眼睛
    Hair = 100,          // 创角头发 (目前已弃用，策划需求不变后再删除)
    HairColor = 101,     // 创角头发颜色 (目前已弃用，策划需求不变后再删除)
    Eye = 102,           // 创角眼睛 (目前已弃用，策划需求不变后再删除)

    Face = 1000,            //基础Face


    Skeleton = 10000,        //模型骨架
}

public enum BattleSubMode
{
    None = 0,           //无
    WorldBoss = 1,      //世界boss
    NewbieBoss = 2,     //开场boss
    Resource = 3,   //资源副本
    Guild = 4,     //公会副本
    ClimbingTower = 5,      //爬塔副本
    Expedition = 6,         //远征之门
    Arena = 7,              //竞技场
    HundredDojo = 8,        //百人道场
    GvG = 9,                //工会战
    Voyage = 10,            //远航
    PvPClimbinglower = 11,  //pvp 爬塔
    GuildEx = 12,           //公会战斗扩展
    HundredDojoEx = 13,     //百人道场预留
}
