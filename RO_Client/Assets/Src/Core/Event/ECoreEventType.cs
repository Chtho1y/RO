using UnityEngine;
using System.Collections;

public sealed class ECoreEventType
{
    public const int EID_ConfigMgrInit = 3;
    public const int EID_AudioMgrInit = 4;
    public const int EID_LevelLoaded = 5;
    public const int EID_LevelLoading = 6;
    public const int EID_UIMgrInit = 10;
    public const int EID_UI_LoadFail = 11;
    public const int EID_UI_LoadSuccess = 12;
    public const int EID_ChangeLoadingState = 13;
    public const int EID_MainMenuRefresh = 14;
    public const int EID_Waiting = 15;
    public const int EID_Logout = 16;

    public const int EID_CameraMgrInited = 17;

    public const int EID_OperaDebugger = 18;
    public const int EID_OperaDebuggerLoad = 19;
    public const int EID_UIMessageBox = 26;
    public const int EID_DragCamera = 27;
    public const int EID_PropelCamera = 28;

    public const int EID_LOADKEY_OK = 29;
    public const int EID_Scene_Loaded = 30;
    public const int EID_Scene_Unloaded = 31;
    public const int EID_SubScene_Loaded = 32;
    public const int EID_UI_CLOSE = 33;
    public const int EID_UI_SHOW = 34;
    public const int EID_GameServer_ConnectSuccess = 35;
    public const int EID_LOAD_LUA_OK = 36;


    public const int EID_FIGHTER_ENTERCOMBAT = 99;
    public const int EID_FIGHTER_HURT = 100;    
    public const int EID_FIGHTER_HEAL = 101;                //玩家受到治疗
    public const int EID_FIGHTER_DODGE = 102;
    public const int EID_FIGHTER_IMMUNITY = 103;
    public const int EID_FIGHTER_SPAWN = 104;
    public const int EID_FIGHTER_LIFE_CHANGED = 105;
    public const int EID_FIGHTER_DISPOSE = 106;
    public const int EID_FIGHTER_RELIVE = 107;
    public const int EID_FIGHTER_DIE = 108;
    public const int EID_FIGHTER_ENERGY_CHAGNED = 109;
    public const int EID_FIGHTER_DO_SKILL = 110;               //非普通攻击技能
    public const int EID_FIGHTER_ASYNC_LOADED = 111;
    public const int EID_NEGATIVE_FUNCTION = 112;              //玩家身中负面效果
    public const int EID_Fighter_Attack = 113;                 //玩家发动攻击
    public const int EID_Fighter_BeHit = 114;                  //玩家受到攻击
    public const int EID_Fighter_Treatment = 115;              //玩家发动治疗
    public const int EID_Fighter_Vertigo = 116;                //玩家被眩晕
    public const int EID_Fighter_Damage_FromCrit = 117;        //玩家的伤害来自暴击
    public const int EID_Fighter_Damage_WithCrit = 118;        //玩家打出暴击
    public const int EID_Fighter_Damage_Avoid = 119;           //玩家伤害被闪避
    public const int EID_Fighter_HP_Lower = 120;               //玩家血量低于xx时
    public const int EID_Fighter_Break_Skill = 121;        //玩家打断带有施法条的技能
    public const int EID_Fighter_Skill_Broken = 122;       //玩家带有施法条的技能被打断
    public const int EID_Fighter_AddSp = 123;                  //玩家回蓝
    public const int EID_Fighter_Kill = 124;                    //玩家击杀
    public const int EID_Fighter_Disperse_Buff = 125;
    public const int EID_Fighter_Purify_Debuff = 126;
    public const int EID_Fighter_Sleep = 127;               //玩家被睡眠

    public const int EID_Fighter_Silence = 127;                 //玩家被沉默
    public const int EID_Fighter_Curse = 127;                   //玩家被睡眠
    public const int EID_Fighter_DamageMaxHpPrecent = 127;      //玩家承受最大x%生命
    public const int EID_Fighter_DamageTotalMaxHpPrecent = 127; //玩家总承受最大x%生命



    public const int EID_BATTLE_NEW_START_FIGHTING = 300;
    public const int EID_LOAD_BEGIN = 301;
    public const int EID_LOAD_COMPLETE = 302;
    public const int EID_LOAD_PROGRESS = 303;
    public const int EID_BATTLE_NEW_FIGHTING_START = 304;
    public const int EID_BATTLE_NEW_NEXT_WAVE = 305;
    public const int EID_BATTLE_SWITCH_MAP = 306;
    public const int EID_SHOW_BATTLE_SCENE = 307;
    public const int EID_SKILL_BEGIN_SING = 308;
    public const int EID_SKILL_END_SING = 309;
    public const int EID_BOSS_SPAWNED = 310;
    public const int EID_BATTLE_FAILED = 311;
    public const int EID_BATTLE_SUCCESS = 312;
    public const int EID_BATTLE_CONTINUE_WAVE = 313;
    public const int EID_BOSS_IN_RAGE = 314;
    public const int EID_DROP_ITEMS = 315;
    public const int EID_BATTLE_NEXT_MAP = 316;
    public const int EID_SKILL_FRESH_SING = 317;
    public const int EID_SHOW_SKILL_REPEATCASTING = 318;
    public const int EID_BATTLE_END = 319;
    public const int EID_SHOW_BUFF_ICON = 320;
    public const int EID_REMOVE_BUFF_ICON = 321;
    public const int EID_ADD_FUNCTION = 323;
    public const int EID_SHIELD_ABSORT_HURT = 324;      //护盾吸收伤害
    public const int EID_FIGHTERS_LOAD_OK = 325;
    public const int EID_PREPARE_LOAD_OK = 326;
    public const int EID_UI_VISIBLE = 327;
    public const int EID_SHOW_DEBUFF_ICON = 328;
    public const int EID_REFRESH_SKILL_CD = 329;
    public const int EID_SHOW_FIGHTER = 330;
    public const int EID_CLONE_NEW_BOSS = 331;
    public const int EID_REPLAY_BATTLE_LOADOK = 332;
    public const int EID_FIGHTER_ADD_SHIELD = 333;
    public const int EID_FIGHTER_CLEAR_SHIELD = 334;



    //战斗UI
    public const int EID_BATTLE_NEW_SHOW_BATTLE_UI = 1000;
    public const int EID_BATTLE_NEW_DISPOSED = 1001;
    public const int EID_BATTLE_NEW_RESTART = 1002;
    public const int EID_Data_AllConfigLoaded = 1003;
    public const int EID_UI_REFRESH = 1004;
    public const int EID_TOTAL_RECHARGE_CHANGE = 1005;
    public const int EID_MAP_CHECK = 1006;
    public const int EID_VIP_LEVEL_UP = 1007;
    public const int EID_ANIMATION_COMPLETED = 1008;
    public const int EID_Click_Challenge = 1009;
    public const int EID_SHOW_BOSS_RAGE_LEFTTIME = 1010;
    public const int EID_SHOW_SCENE_GO = 1011;
    public const int EID_RESTORE_SCENE = 1012;
    public const int EID_MOUSE_DELTA = 1013;
    public const int EID_START_MOVE_MOUSE = 1014;
    public const int EID_END_MOVE_MOUSE = 1015;
    public const int EID_Refresh_Skill = 1016;
    public const int EID_Dialogue_Finished = 1017;       //对话结束
    public const int EID_CHAGNE_SKYBOX_MATERIAL = 1018;
    public const int EID_Fighter_Move_End = 1019;
    public const int EID_PLAY_SKILL_PREFAB = 1020;
    public const int EID_BattleUI_Visible = 1021;
    public const int EID_CLOSE_SKILL_PREFAB = 1022;
    public const int EID_RESTORE_SKYBOX_MATERIAL = 1023;
    public const int EID_CLICK_REPLAY_BATTLE = 1024;     //播放战斗视屏
    public const int EID_BEGIN_BOSS_RAGE_TIME = 1025;    //开始boss狂暴倒计时

    public const int EID_SDK_INIT_RESULT = 2000;
    public const int EID_SDK_LOGIN_RESULT = 2001;
    public const int EID_SDK_SWITCH_ACCOUNT = 2002;
    public const int EID_SDK_LOGOUT = 2003;
    public const int EID_SDK_EXIT = 2004;
    public const int EID_SDK_PAY_SUCCESS = 2005;
    public const int EID_SDK_PAY_CANCEL = 2006;
    public const int EID_SDK_PAY_FAILED = 2007;
    public const int EID_SDK_LOGIN_RESULT_NEW = 2008;
    public const int EID_SDK_SWITCH_ACCOUNT_NEW = 2009;
	public const int EID_SDK_QUESTION_REWARD_RESULT = 2010;
}
