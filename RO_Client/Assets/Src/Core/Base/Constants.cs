using UnityEngine;
using System.Collections;
public static class Constants
{
    public static bool isOffline = false;


    #region 战斗相关
    public static string s_skillaction_frame_key_bulletid = "bulletid";
    public static string s_skillaction_frame_key_singAnimName = "singAnimName";
    public static string s_skillaction_frame_key_singFrame = "singFrame";
    public static string s_skillaction_frame_key_buffid = "buffid";
    public static string s_skillaction_frame_key_damagePercent = "damagePercent";
    public static string s_skillaction_frame_key_rangeType = "rangeType";
    public static string s_skillaction_frame_key_rangeX = "rangeX";
    public static string s_skillaction_frame_key_rangeY = "rangeY";
    public static string s_skillaction_frame_key_rangeZ = "rangeZ";
    public static string s_skillaction_frame_key_rangeOffsetX = "rangeOffsetX";
    public static string s_skillaction_frame_key_rangeOffsetY = "rangeOffsetY";
    public static string s_skillaction_frame_key_flyLen = "flyLen";
    public static string s_skillaction_frame_key_backLen = "backLen";
    public static string s_skillaction_frame_key_moveTime = "movetime";
    public static string s_skillaction_frame_key_stifftime = "stifftime";
    public static string s_skillaction_frame_key_hiteffect = "hiteffect";
    public static string s_skillaction_frame_key_hitframe = "hitframe";
    public static string s_skillaction_frame_key_hitsound = "hitsound";
    public static string s_skillaction_frame_key_effect = "effect";
    public static string s_skillaction_frame_key_sound = "sound";
    public static string s_skillaction_frame_key_breakLevel = "breaklevel";
    public static string s_skillaction_frame_key_hitrate = "hitrate";
    public static string s_skillaction_frame_key_repeatinterval = "repeatinterval";
    public static string s_skillaction_frame_key_multihit = "multihit";
    public static string s_skillaction_frame_key_multihitinterval = "multihitinterval";
    public static string s_skillaction_frame_key_targetinterval = "targetinterval";
    public static string s_skillaction_frame_key_reselectTarget = "reselecttarget";
    public static string s_skillaction_frame_key_normalizerange = "normalizerange";
    public static string s_skillaction_frame_key_npcId = "npcId";
    public static string s_skillaction_frame_key_npcPos = "npcPos";

    public static string s_skillaction_frame_key_position = "position";
    public static string s_skillaction_frame_key_rotation = "rotation";

    public static string s_skillaction_frame_key_switchscene = "switchscene";
    public static string s_skillaction_frame_key_delay_hurt_interval = "delay_hurt_interval";
    public static string s_skillaction_frame_key_delay_hurt_count = "delay_hurt_count";
    public static string s_skillaction_frame_key_delay_hurt_delay_frame = "hurt_delay_frame";
    public static string s_skillaction_frame_key_replace_skill_from = "fromskill";
    public static string s_skillaction_frame_key_replace_skill_to = "toskill";

    public static string s_skillaction_frame_key_shake_magnitude = "magnitude";
    public static string s_skillaction_frame_key_shake_roughness = "roughness";
    public static string s_skillaction_frame_key_shake_fadeInTime = "fadeInTime";
    public static string s_skillaction_frame_key_shake_fadeOutTime = "fadeOutTime";
    public static string s_skillaction_frame_key_shake_pos = "shakePos";
    public static string s_skillaction_frame_key_shake_rot = "shakeRot";

    public static string s_skillaction_frame_key_cam_pos = "camPos";
    public static string s_skillaction_frame_key_cam_rot = "camRot";
    public static string s_skillaction_frame_key_cam_fov = "camFov";

    public static string s_skillaction_frame_key_move_type = "moveType";
    public static string s_skillaction_frame_key_move_speed = "initSpeed";
    public static string s_skillaction_frame_key_move_acceleration = "acceleration";
    public static string s_skillaction_frame_key_move_dist = "moveDist";
    public static string s_skillaction_frame_key_move_orientation = "moveOrientation";
    public static string s_skillaction_frame_key_material_name = "mat";
    public static string s_skillaction_frame_key_prefabname = "prefabname";
    public static string s_skillaction_frame_key_battleui_visible = "visible";

    public static string s_skillaction_frame_key_rate = "rate";

    public static float frame_to_time = 30.0f;
    public static float s_internaltime = 0.033f;

    public static float gravity = 20f;
    public static float s_starkStopTime = 0.1f;
    public static string s_common_frameEventName = "FrameEvent";

    public static int s_protectframe = 3;

    public const int EndBattle_By_UndeadCount = 1;      //队伍阵亡
    public const int EndBattle_By_BattleTime = 2;       //超时
    public const int EndBattle_By_TeamTotalDamage = 3;      //我方达到伤害量  
    public const int EndBattle_By_MainRoleDead = 4;         //主角死亡战斗结束
    public const int EndBattle_By_BossDead = 5;             //挑战的boss死亡战斗结束
    public const int EndBattle_By_PetDead = 6;          //挑战宠物boos 战斗结束

    public const int ResultType_Normal = 1;
    public const int ResultType_Special = 2;
    #endregion

    #region Directory
    public const string LuaDir = "Assets/ToLua/Lua";
    public const string LuaLogicDir = "Assets/Lua";
    public const string LuaPbDir = "Assets/Lua/Pb";
    public const string PubSec = "Assets/ToLua/pubsec";

    public const string ABLuaLogicDir = "Assets/Content/Lua";
    public const string ABLuaDir = "Assets/Content/ToLua/Lua";
    public const string ABLuaPbDir = "Assets/Content/Lua/Pb";
    public const string ABPubsec = "Assets/Content/ToLua/pubsec";

    public const string UIAtlas = "Assets/Content/UI/UIAtlas";
    public const string UIPath = "Assets/Content/Prefabs/UI";
    public const string UI3DPath = "Assets/Content/Prefabs/3DUI";
    public const string UITexturePath = "Assets/Content/UI/UITexture";
    public const string UIOtherPath = "Assets/Content/Prefabs/UI/UIOthers";
    public const string VideoClipPath = "Assets/Content/Video";
    public const string AudioClipPath = "Assets/Content/Audio";
    public const string OtherPath = "Assets/Content/Prefabs/Others";
    public const string CameraRootAvtarPath = "Assets/Content/Prefabs/CameraRootAvtar";

    public const string AvatarPrefabPath = "Assets/Content/Art/Avatar";
    public const string AvatarEquipPath = "Assets/Content/Art/AvatarEquip/Prefabs";
    public const string TimelinePath = "Assets/Content/OperaMod";

    public const string MonsterPath = "Assets/Content/Prefabs/Models/Monster";
    public const string HeroPath = "Assets/Content/Prefabs/Models/Hero";

    public const string ShaderDir = "Assets/Shaders";
    public const string FontDir = "Assets/Content/Fonts";
    public const string CsvConfig = "Assets/Content/Config";
    public const string XmlConfig = "Assets/Content/Xml";
    public const string SpineDynamicPath = "Assets/Content/Prefabs/SpineDynamic";
    public const string ModelPath = "Assets/Content/Prefabs/Models";
    public const string EffectPath = "Assets/Content/Prefabs/Effects";
    public const string UIEffectPath = "Assets/Content/Prefabs/Effects/UI";
    public const string TriggerPath = "Assets/Content/Prefabs/Trigger";
    public const string AnimPath = "Assets/Content/Prefabs/Anim";
    public const string ScenePath = "Assets/Scenes";
    public const string FightAudioPath = "Assets/Content/Audio/Fight";
    public const string UIAudioPath = "Assets/Content/Audio/UI";
    public const string BGMAudioPath = "Assets/Content/Audio/BGM";
    public const string IconDir = "Assets/Content/Icons";
    public const string CommonMaterialDir = "Assets/Content/Materials";
    public const string UIItemDir = "Assets/Content/Prefabs/UI/GridViewItem";
    public const string AnimatorPath = "Assets/Content/Prefabs/Animator";
    public const string UICommonPath = "Assets/Content/Prefabs/UI/Common";

    #endregion Directory

    public const string go_name_camera_target = "camera_target";
    public const string camera_real_camera_node_name = "Camera";
    public const string actor_born_point = "ActorBornPoint";
    public const string enemy_actor_born_point = "EnemyActorBornPoint";
    public const string design_go = "Design";
    public const string coming_camera_target = "Camera_on-off";

    public const int c_delay_skillcasting_time = 2;


    public static bool AssetbundleMode = false;

    public static string ArenaOnBattleAniName = "f_Arena_attack";   //英灵殿上阵的英雄的动作
    public static string ArenaOffBattleAniName = "f_Arena_idle";    //英灵殿下阵的英雄的动作

    public static Color green = new Color(0.4078431f, 0.7686275f, 0.254902f);
    public static Color red = new Color(1.0f, 0.3098039f, 0.1960784f);
    public static Color yellow = new Color(1.0f, 0.9176471f, 0);
    public static Color spClr = new Color(0.243f, 0.705f, 1.0f);

    public static bool printBattleLog = false;
}

public static class LangKeys
{
    public const string ChinaHongKong = "_hk";
    public const string ChinaTaiwan = "_tw";
    public const string ChinaSimplifiedFull = "_cn";
    public const string USA = "_us";
    public const string Japan = "_jp";
    public const string Korea = "_ko";
    public const string Russia = "_ru";
    public const string Turkey = "_tr";
}