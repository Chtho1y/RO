using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;
using System.Linq;


public class EffectManager : Singleton<EffectManager>
{
	const int MAX_OWN_SAME_EFFECT_COUNT = 15;
	const int MAX_TARGET_SAME_EFFECT_COUNT = 15;

	Dictionary<int, Effect> mEffectMap = new Dictionary<int, Effect> ();
	Dictionary<Transform, Dictionary<int, List<int>>> mOwnerEffectMap = new Dictionary<Transform, Dictionary<int, List<int>>> ();
	Dictionary<Transform, Dictionary<int, List<int>>> mTargetEffectMap = new Dictionary<Transform, Dictionary<int, List<int>>> ();

	List<int> mRemoveList = new List<int> (50);

    public override void Init()
    {
        base.Init();
    }

    public override void UnInit()
    {
        base.UnInit();
    }

    public void Update (float deltaTime)
	{
		var e = mEffectMap.GetEnumerator ();
		while (e.MoveNext ())
        {
			if (e.Current.Value.IsDisposed)
				mRemoveList.Add (e.Current.Key);
			else
				e.Current.Value.Update (deltaTime);
		}

		for (int i = 0; i < mRemoveList.Count; i++)
        {
			Effect eft = mEffectMap [mRemoveList [i]];
			if (eft.OwnerTransform != null)
				mOwnerEffectMap [eft.OwnerTransform] [eft.EffectID].Remove (eft.InstanceID);
			if (eft.TargetTransform != null)
				mTargetEffectMap [eft.TargetTransform] [eft.EffectID].Remove (eft.InstanceID);
			mEffectMap.Remove (mRemoveList [i]);
		}
		mRemoveList.Clear ();
	}

	public void Clear ()
	{
		for (int i = 0; i < mEffectMap.Count; i++)
        {
			var element = mEffectMap.ElementAt (i);
			element.Value.Destroy();
		}
		mEffectMap.Clear ();
		mOwnerEffectMap.Clear ();
		mTargetEffectMap.Clear ();
	}

	#region PublicMethods

	public void PauseEffectOfOwnerFighter (Fighter fighter)
	{
		if (fighter.Ctrl == null)
			return;
		if (mOwnerEffectMap.ContainsKey (fighter.Ctrl.transform)) {
			Dictionary<int, List<int>> ownEffects = mOwnerEffectMap [fighter.Ctrl.transform];
			for (int i = 0; i < ownEffects.Count; i++) {
				var e = ownEffects.ElementAt (i);
				for (int j = 0; j < e.Value.Count; j++)
					mEffectMap [e.Value [j]].Pause ();
			}
		}
	}

	public void ResumeEffectOfOwnerFighter (Fighter fighter)
	{
		if (fighter.Ctrl == null)
			return;
		if (mOwnerEffectMap.ContainsKey (fighter.Ctrl.transform)) {
			Dictionary<int, List<int>> ownEffects = mOwnerEffectMap [fighter.Ctrl.transform];
			for (int i = 0; i < ownEffects.Count; i++) {
				var e = ownEffects.ElementAt (i);
				for (int j = 0; j < e.Value.Count; j++)
					mEffectMap [e.Value [j]].ResumeFromPause ();
			}
		}
	}

	public void RemoveEffectByOwnerFighter(Fighter fighter)
	{
		if (fighter.Ctrl == null)
			return;
		if (mOwnerEffectMap.ContainsKey(fighter.Ctrl.transform))
		{
			Dictionary<int, List<int>> ownEffects = mOwnerEffectMap[fighter.Ctrl.transform];
			for(int i = ownEffects.Count -1; i>=0; i--)
			{
				var e = ownEffects.ElementAt(i);
				for (int j = 0; j < e.Value.Count; j++)
				{
					if(mEffectMap.ContainsKey(e.Value[j]))
					{
						mEffectMap[e.Value[j]].Destroy();
					}
				}
				e.Value.Clear();
			}
		}
	}

	public void PauseAllEffects()
	{
		foreach(var p in mEffectMap)
		{
			p.Value.Pause();
		}
	}

	public void ResumeAllEffects()
	{
		foreach (var p in mEffectMap)
		{
			p.Value.ResumeFromPause();
		}
	}

	public void RemoveEffectByOwnerID (Transform t, int id)
	{
		if (mOwnerEffectMap.ContainsKey (t)) {
			Dictionary<int, List<int>> ownEffects = mOwnerEffectMap [t];
			if (ownEffects.ContainsKey (id)) {
				List<int> effects = ownEffects [id];
				for (int i = 0; i < effects.Count; i++)
					mEffectMap [effects [i]].Destroy ();
                effects.Clear();
			}
		}
	}

	public void RemoveOneEffectByOwnerID (Transform t, int id)
	{
		if (mOwnerEffectMap.ContainsKey (t)) {
			Dictionary<int, List<int>> ownEffects = mOwnerEffectMap [t];
			if (ownEffects.ContainsKey (id) && ownEffects [id].Count > 0)
            {
                if (mEffectMap.ContainsKey(ownEffects[id][0]))
                {
                    mEffectMap[ownEffects[id][0]].Destroy();
                    ownEffects[id].RemoveAt(0);
                }
                else
                {
                    ownEffects[id].RemoveAt(0);
                }
            }
				
		}
	}

	public void RemoveOneEffectByTargetID (Transform t, int id)
	{
		if (mTargetEffectMap.ContainsKey (t)) {
			Dictionary<int, List<int>> targetEffects = mTargetEffectMap [t];
			if (targetEffects.ContainsKey (id) && targetEffects [id].Count > 0) {
                if (mEffectMap.ContainsKey(targetEffects[id][0])) { 
                    mEffectMap [targetEffects[id][0]].Destroy();
                    targetEffects[id].RemoveAt(0);
                }
                else
                {
                    targetEffects[id].RemoveAt(0);
                }
            }
        }
	}

	public GameObject CreateEffectGo (string effectName)
	{
		return BattlePrepareManager.Instance.PopAssetGo (Constants.EffectPath,effectName);
	}

	int GetOwnerEffectCount (Transform t, int id)
	{
		if (mOwnerEffectMap.ContainsKey (t) && mOwnerEffectMap [t].ContainsKey (id))
			return mOwnerEffectMap [t] [id].Count;
		return 0;
	}

	int GetTargetEffectCount (Transform t, int id)
	{
		if (mTargetEffectMap.ContainsKey (t) && mTargetEffectMap [t].ContainsKey (id))
			return mTargetEffectMap [t] [id].Count;
		return 0;
	}

	#endregion

	public int PlayEffect (int effectId, Fighter owner, Fighter target, Bullet bullet = null
		, bool ignoreTimescale = false, bool fixFloor = false, int lookType = 0, bool mirrorable = true, string forceLayer = "")
	{
		return PlayEffect (effectId, owner != null && owner.Ctrl != null ? owner.Ctrl.transform : null, 
			target != null && target.Ctrl != null ? target.Ctrl.transform : null, 
			bullet != null && bullet.Ctrl != null ? bullet.Ctrl.transform : null, 
			ignoreTimescale, fixFloor, lookType, mirrorable, forceLayer);
	}

	public int PlayEffect (int effectId, Transform ownerTransform, Transform targetTransform, Transform bulletTransform = null
		, bool ignoreTimescale = false, bool fixFloor = false, int lookType = 0, bool mirrorable = true, string forceLayer = "")
	{
        if (ownerTransform != null && GetOwnerEffectCount(ownerTransform, effectId) >= MAX_OWN_SAME_EFFECT_COUNT)
            RemoveOneEffectByOwnerID(ownerTransform, effectId);

        if (targetTransform != null && GetTargetEffectCount(targetTransform, effectId) >= MAX_TARGET_SAME_EFFECT_COUNT)
            RemoveOneEffectByTargetID(targetTransform, effectId);

        Effect effect = PopEffect (effectId);
		if (effect == null || !effect.Valid) {  
            return -1;
        }

        effect.Play (ownerTransform, targetTransform, bulletTransform, ignoreTimescale, fixFloor, lookType, mirrorable, forceLayer);

		mEffectMap.Add (effect.InstanceID, effect);
		if (ownerTransform != null)
        {
			if (!mOwnerEffectMap.ContainsKey (ownerTransform))
				mOwnerEffectMap.Add (ownerTransform, new Dictionary<int, List<int>> ());
			if (!mOwnerEffectMap [ownerTransform].ContainsKey (effect.EffectID))
				mOwnerEffectMap [ownerTransform].Add (effect.EffectID, new List<int> ());
			mOwnerEffectMap [ownerTransform] [effect.EffectID].Add (effect.InstanceID);
		}
		if (targetTransform != null)
        {
			if (!mTargetEffectMap.ContainsKey (targetTransform))
				mTargetEffectMap.Add (targetTransform, new Dictionary<int, List<int>> ());
			if (!mTargetEffectMap [targetTransform].ContainsKey (effect.EffectID))
				mTargetEffectMap [targetTransform].Add (effect.EffectID, new List<int> ());
			mTargetEffectMap [targetTransform] [effect.EffectID].Add (effect.InstanceID);
		}

		return effect.InstanceID;
	}

    public int PlayEffect(int effectId)
    {
        Effect effect = PopEffect(effectId);
        if (effect == null || !effect.Valid)
            return -1;

        effect.Play(null, null, null, false, false, 0, true, "");

        mEffectMap.Add(effect.InstanceID, effect);
      
        return effect.InstanceID;
    }

	public void RemoveEffectByID (int effectID)
	{
		for (int i = 0; i < mEffectMap.Count; i++)
			if (mEffectMap.ElementAt (i).Value.EffectID == effectID) { 
				mEffectMap.ElementAt (i).Value.Destroy();
            }
    }

	public void RemoveAllEffect ()
	{
		Clear ();
	}

	Effect PopEffect (int effectId)
	{
		EffectData data = BattlePrepareManager.Instance.PopEffectData (effectId);
		return data != null ? new Effect (data) : null;
	}

	public void RemoveEffectByInstanceID (int instanceID, bool selfOnly = false)
	{
		if (mEffectMap.ContainsKey (instanceID)) {
			Effect eft = mEffectMap [instanceID];
			//if (selfOnly && IsEffectSelf (eft))
			//	return;
			eft.Destroy();
		}
	}

	void Dispose ()
	{
		Clear ();        
	}

	public void HideEffectByInstanceId (int instanceid)
	{
		if (mEffectMap.ContainsKey (instanceid))
			mEffectMap [instanceid].Hide ();
	}

	public void UnHideEffectByInstanceId (int instanceid)
	{
		if (mEffectMap.ContainsKey (instanceid))
			mEffectMap [instanceid].UnHide ();
	}

    public void SetEffectScaleByInstanceId(int instanceId,float scale)
    {
        if (mEffectMap.ContainsKey(instanceId))
            mEffectMap[instanceId].SetScale(scale);
    }

	public void OnFullScreenEffectStart ()
	{
		//foreach (var efx in mEffectMap.Values)
		//	if (efx.RunningOption != null && efx.RunningOption.hideOnUltraSkill)
		//		efx.Hide ();
	}

	public void OnFullScreenEffectEnd ()
	{
		//foreach (var efx in mEffectMap.Values)
		//	if (efx.RunningOption != null && efx.RunningOption.hideOnUltraSkill)
		//		efx.UnHide ();
	}
}
