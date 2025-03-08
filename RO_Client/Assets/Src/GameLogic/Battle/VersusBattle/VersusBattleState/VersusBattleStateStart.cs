using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class VersusBattleStateStart : VersusBattleState
{
    public static VersusBattleState Creator(VersusBattle battle)
    {
        return new VersusBattleStateStart(battle);
    }

    public VersusBattleStateStart(VersusBattle battle)
        : base(battle, VersusBattleStateType.Start)
    {
    }

    public override void OnEnter()
    {
        Init();
    }

    public override void OnLeave()
    {
    }

    public override void Update(float deltaTime)
    {
        ChangeState(VersusBattleStateType.Preloading);
    }

    void Init()
    {
        //创建场景
        mBattle.BattleScene = new VersusBattleScene(mBattle);

        //解析战斗人员
        mBattle.FighterMgr = new FighterManager(mBattle);
        mBattle.FighterMgr.InitFighters();
        mBattle.FighterMgr.ParseLoad();
        InitCommonBuffs();
        InitCommonAssets();
    }

    void InitCommonAssets()
    {
        List<int> commonEffectIds = new List<int>();
        commonEffectIds.Add(GlobalConfig.Instance.GetConfigIntValue(GlobalConfig.c_runsmoke_effectid));
        commonEffectIds.Add(GlobalConfig.Instance.GetConfigIntValue(GlobalConfig.c_shadow_effectid));
        commonEffectIds.Add(GlobalConfig.Instance.GetConfigIntValue(GlobalConfig.c_self_effectid));
        commonEffectIds.Add(GlobalConfig.Instance.GetConfigIntValue(GlobalConfig.c_relive_effectid));
        commonEffectIds.Add(GlobalConfig.Instance.GetConfigIntValue(GlobalConfig.c_enter_transfer_effectId));
        commonEffectIds.Add(GlobalConfig.Instance.GetConfigIntValue(GlobalConfig.c_exit_transfer_effectId));

        commonEffectIds.Add(GlobalConfig.Instance.GetConfigIntValue(BattleMgr.m_angle_effect_id_cfgid));

        if (commonEffectIds.Count > 0)
            BattlePrepareManager.Instance.PrecacheEffects(commonEffectIds.ToArray());

        if (BattleMgr.Instance.CommonEffectIds.Count > 0)
            BattlePrepareManager.Instance.PrecacheEffects(BattleMgr.Instance.CommonEffectIds.ToArray());
    }

    void InitCommonBuffs()
    {
        Dictionary<int, SInt> pointBuffs = BattleFormulaParamMgr.Instance.FunPointBuffs;
        foreach (var p in pointBuffs)
        {
            int buffId = p.Key;
            BattlePrepareManager.Instance.PrecacheBuff(buffId, (int)Role_Gender.Male,0,0,0);
        }
    }
}
