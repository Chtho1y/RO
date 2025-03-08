using UnityEngine;
using System.Collections.Generic;

public class TimeBattleStateStart : TimeBattleState
{
    public static TimeBattleStateStart Creator(TimeBattle battle)
    {
        return new TimeBattleStateStart(battle);
    }

    public TimeBattleStateStart(TimeBattle battle):
        base(battle,TimeBattleStateType.Start)
    {

    }

    public override void OnEnter()
    {
        Init();
    }

    public override void Update(float deltaTime)
    {
        ChangeState(TimeBattleStateType.Preloading);
    }

    public override void OnLeave()
    {
            
    }

    void Init()
    {
        mBattle.BattleScene = new TimeBattleScene(mBattle, mBattle.SceneName);
        mBattle.FighterMgr = new FighterManager(mBattle);
        mBattle.FighterMgr.InitFighters();
        mBattle.FighterMgr.ParseLoad();


        InitCommonBuffs();
        InitCommonAssets();
    }

    void InitCommonAssets()
    {
        List<int> commonEffectIds = new List<int>();
        commonEffectIds.Add(GlobalConfig.Instance.GetConfigIntValue(GlobalConfig.c_shadow_effectid));
        commonEffectIds.Add(GlobalConfig.Instance.GetConfigIntValue(GlobalConfig.c_self_effectid));

        if (commonEffectIds.Count > 0)
            BattlePrepareManager.Instance.PrecacheEffects(commonEffectIds.ToArray());
    }

    void InitCommonBuffs()
    {
        Dictionary<int, SInt> pointBuffs = BattleFormulaParamMgr.Instance.FunPointBuffs;
        foreach (var p in pointBuffs)
        {
            int buffId = p.Key;
            BattlePrepareManager.Instance.PrecacheBuff(buffId, (int)Role_Gender.Male, 0, 0, 0);
        }
    }
}
