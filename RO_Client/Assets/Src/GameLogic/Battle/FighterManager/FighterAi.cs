using UnityEngine;
using System.Collections;

//using StateMachine;
using System.IO;

public class FighterAi
{
	readonly Fighter mFighter;
	float mNextActionTime;
	int mNextSelectAttack;
    int mNormalAttackCnt = 0;
    int maxCnt = 0;


    public int NextSelectAttack
    {
        get { return mNextSelectAttack; }
    }

	public FighterAi (Fighter fighter)
	{
		mFighter = fighter;
		Enabled = false;
		mNextSelectAttack = SkillType.Attack1;
        maxCnt = GlobalConfig.Instance.GetConfigIntValue(124);
    }

    public void Reset()
    {
        mNextSelectAttack = SkillType.Attack1;
        mNormalAttackCnt = 0;
    }

	public bool Enabled { get; set; }

	public void Update (float deltaTime)
	{
		if (!Enabled)
			return;

        bool playRecord = mFighter.Battle.IsPlayRecord;
        if (playRecord)
        {
            mFighter.Battle.Recorder.ProcessFrameRecord(BattleRecorder.RecordType.FighterMove, mFighter);
            mFighter.Battle.Recorder.ProcessFrameRecord(BattleRecorder.RecordType.FighterSkill, mFighter);
            return;
        }

        BaseSkill skill = null;
        if (mNormalAttackCnt >= maxCnt && 
            !mFighter.FuncMgr.HaveForbidSkillFunc() && 
            mFighter.CheckDoSkill(mNextSelectAttack,out skill))
        {
            mFighter.Sp -= skill.SpCost;

            mFighter.CheckSkillEnhance(skill);

            mNextSelectAttack++;
            if (mNextSelectAttack > mFighter.SkillCnt)
                mNextSelectAttack = SkillType.Attack1;

            mFighter.RefreshSp();
            mFighter.Actor.SkillMgr.ResetRandomSkill();
            return;
        }

        if (!mFighter.FuncMgr.HaveForbidNormalAttackFunc() && mFighter.CheckDoSkill(SkillType.NormalAttack,out skill))
        {
            mNormalAttackCnt++;
            mFighter.ResetNormalSkillCd();
            mFighter.Actor.SkillMgr.AddNormalAttackIndex();
        }
    }
}
