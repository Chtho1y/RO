using UnityEngine;
using System.Collections;
using System.Collections.Generic;

//子弹效果
public class Bullet : LogicTransform
{
	Fighter mFighter;
	FighterSkillStateData mSkillState;
	SkillActionAttackInfo mAttackInfo;
	BulletData mData;
	BulletGoCtrl mCtrl;

	//float mLifeTime;                    //时长
	int mLeftFrame = 0;					//总帧数
	Vector3 mStartOffset;               //开始偏移位置
	Vector3 mTargetOffset;              //目标偏移位置
	BulletMoveProcessor mMoveProcessor; //移动处理器
	List<Fighter> mAlreadyHitList;      //被击对象
    GameObject effectGo;
    BattleBuff mBattleBuff = null;
	int mHurtFrame = 0;
	bool hideEffect = false;

	public Fighter Caster { get { return mFighter; } }

	public Fighter Target { get; private set; }

	public bool IsDisposed { get; private set; }

	public BulletData BulletData { get { return mData; } }

	public SkillActionAttackInfo AttackInfo { get { return mAttackInfo; } }

	public Vector3 TargetPosition {	get { return Target != null ? (mData.targetOffset + Target.Ctrl.GetPosByLink(mData.targetLink)) : mTargetOffset; } }

	public BulletGoCtrl Ctrl { get { return mCtrl; } }

    public BulletMoveProcessor MoveProcessor { get { return mMoveProcessor; } }

    public Bullet (Fighter owner,Fighter target, SkillActionAttackInfo attackInfo,BattleBuff buff)
	{
		KeepHorizontalLook = false;
		IsDisposed = false;
		mFighter = owner;
		mAttackInfo = attackInfo;
		mSkillState = mFighter.StateData.SkillStateData;
        mBattleBuff = buff;
        Target = target;
		mData = BattlePrepareManager.Instance.PopBulletData (attackInfo.bulletID);
		Init ();
		//if (BattleMgr.Instance.Battle.IsPlayRecord || BattleMgr.Instance.Battle.IsKillingBoss)
		//{
		//	DebugHelper.LogError(string.Format("<color=#ff0000>bulletID = {0}-------stateFrame = {1} start mHurtFrame = {2}</color>", mData.id, mFighter.Battle.CurBattleField.CurrentStateFrame,mHurtFrame));
		//}
	}

	void Init ()
	{
        //mLifeTime = mData.lifeTime;
		mLeftFrame = (int)(mData.lifeTime * Constants.frame_to_time);
        Vector3 startForward = Target != null ? (Target.Position - Caster.Position).normalized : Vector3.forward;
		SetStartTransform (startForward);

        float moveSpeedPerFrame = (Vector3.Distance(Target.Position, Caster.Position) / mData.lifeTime) /Constants.frame_to_time;
		mMoveProcessor = new BulletMoveProcessor (this, moveSpeedPerFrame);

		if(mData.HurtDist != null)
		{
			float dist = Vector3.Distance(Caster.Position, Target.Position);
			for (int idx = mData.HurtDist.Length-1; idx >= 0; idx--)
			{
				if(dist > mData.HurtDist[idx])
				{
					mHurtFrame = mData.HurtFrames[idx];
					break;
				}
			}
		}

		InitGo ();
		hideEffect = false;
	}

	void InitGo ()
	{
		if (mFighter.Ctrl == null)
			return;

        effectGo = BattlePrepareManager.Instance.PopAssetGo (Constants.EffectPath,mData.effect);
		if (effectGo != null)
        {
            mCtrl = effectGo.GetComponent<BulletGoCtrl> ();
			if (mCtrl == null)
				mCtrl = effectGo.AddComponent<BulletGoCtrl> ();
			mCtrl.Bullet = this;
			ForceSync (mCtrl.transform);
		
			LayerName = BattleCamera.SceneEffectLayerName;
            effectGo.SetActive (true);
            effectGo.transform.SetParent(null);
			CommonUtil.SetGameObjectLayer(effectGo, LayerName);
		}
	}

	public void Update (float deltaTime)
	{
		if (IsDisposed)
			return;
		
		if (Parent != null)
			UpdateFromParent ();

		mHurtFrame--;
		if (mHurtFrame <= 0)
		{
			//if (BattleMgr.Instance.Battle.IsPlayRecord || BattleMgr.Instance.Battle.IsKillingBoss)
			//{
			//	DebugHelper.LogError(string.Format("<color=#ff0000>bulletID = {0}-------stateFrame = {1} hit</color>", mData.id, mFighter.Battle.CurBattleField.CurrentStateFrame));
			//}
			ProcessHitFighter();
			Dispose();
		}

		if (!IsDisposed)
		{
			mLeftFrame--;
			if (mLeftFrame <= 0)
				Dispose();
		}
	}

    public void FrameUpdate(float deltaTime)
    {
        if(mMoveProcessor!=null)
        {
            mMoveProcessor.Update(deltaTime);
        }

        CheckFlyBulletHit();
    }

	public void Dispose ()
	{
		if (IsDisposed)
			return;

        if(mCtrl!=null)
        {
            mCtrl.Bullet = null;
        }

        mBattleBuff = null;
        mAlreadyHitList = null;
        ResourceMgr.Instance.RecycleGO(Constants.EffectPath, mData.effect, effectGo);

        GameObject.Destroy(mCtrl);
        mCtrl = null;
		IsDisposed = true;
	}

    public override void SetPosition(Vector3 position)
    {
        Position = position;
    }

    void SetStartTransform (Vector3 startForward)
	{
		mStartOffset = mData.offset + Caster.Ctrl.GetPosByLink(mData.startLink);

		mTargetOffset = mData.targetOffset + Target.Ctrl.GetPosByLink(mData.targetLink);

		if (mData.followType == EffectFollowType.Effect_Follow_Self || 
            mData.followType == EffectFollowType.Effect_Follow_Self_Bloodbar)
        {
			SetParent (Caster);
			LocalPosition = mStartOffset;
		}
        else if (mData.followType == EffectFollowType.Effect_Follow_Target || 
            mData.followType == EffectFollowType.Effect_Follow_Target_Bloodbar)
        {
			if (Target != null)
            {
                SetParent (Target);
				LocalPosition = mStartOffset;
			}
		}
        else if (mData.targetType == EffectTargetType.Effect_Target_Self)
        {
			SetPosition (mStartOffset);
		}
        else if (mData.targetType == EffectTargetType.Effect_Target_Target)
        {
			if (Target != null)
            {
				SetPosition (Target.TransformPoint (mStartOffset));
			}
		}
        else
        {
			SetPosition (Caster.TransformPoint (mStartOffset));
		}
		LookForward (startForward);
	}

	void CheckFlyBulletHit ()
	{
		if (mData.actorType != EffectType.EffectType_Fly)
			return;

		if (!hideEffect &&  CheckHitTarget())
		{
			if (effectGo != null)
				CommonUtil.SetGameObjectLayer(effectGo, "Hide");
			hideEffect = true;
		}
	}

	void ProcessHitFighter()
    {
        if (mBattleBuff == null) return;

        mBattleBuff.PerformBullteAttackInfo(mAttackInfo,Target);
    }

    List<Fighter> GetBeHitFighters ()
	{
		mSkillState.HitRange.Set (Caster, Target, AttackInfo, this);
		return mSkillState.HitRange.GetSkillHitFighters (Caster, mAttackInfo.skill, Caster.FighterMgr.AllFighters, true, mAlreadyHitList);
	}

	bool CheckHitTarget ()
	{
		if (Target != null)
		{
			AttackInfo.rangeType = SkillRangeType.RangeType_Bullet;
			mSkillState.HitRange.Set(Caster, Target, AttackInfo, this);
			return mSkillState.HitRange.CheckHitFighter(Target, Position, mData.targetLink);
		}
		return false;
	}
}

