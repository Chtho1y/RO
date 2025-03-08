using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class LogicBattleStateStart : LogicBattleState
{
	public static LogicBattleState Creator (LogicBattle battle)
	{
		return new LogicBattleStateStart (battle);
	}

	public LogicBattleStateStart (LogicBattle battle) 
        : base (battle, LogicBattleStateType.Start)
	{
	}

	public override void OnEnter ()
	{
        InitScene ();
        InitCamera ();
        InitFighterMgr ();
        InitCommonBuffs();
        InitCommonAssets();
    }

	public override void OnLeave ()
	{
	}

	public override void Update (float deltaTime)
	{
		ChangeState (LogicBattleStateType.Preloading);
	}

	void InitCamera()
	{
		BattleCamera.CurrentEffectLayerName = BattleCamera.SceneEffectLayerName;
	}

	void InitScene ()
	{
        mBattle.BattleScene = new LogicBattleScene(mBattle);
    }

	void InitFighterMgr ()
	{
		mBattle.FighterMgr = new FighterManager (mBattle);
		mBattle.FighterMgr.InitializeCurrentSceneFighters ();
        mBattle.FighterMgr.ParseLoad();
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

        if(commonEffectIds.Count > 0)
            BattlePrepareManager.Instance.PrecacheEffects(commonEffectIds.ToArray());

        if (BattleMgr.Instance.CommonEffectIds.Count > 0)
            BattlePrepareManager.Instance.PrecacheEffects(BattleMgr.Instance.CommonEffectIds.ToArray());
    }

    void InitCommonBuffs()
    {
        Dictionary<int, SInt>  pointBuffs =  BattleFormulaParamMgr.Instance.FunPointBuffs;
        foreach(var p in pointBuffs)
        {
            int buffId = p.Key;
            BattlePrepareManager.Instance.PrecacheBuff(buffId,(int)Role_Gender.Male,0,0,0);
        }
    }
}