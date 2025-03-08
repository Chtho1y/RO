using UnityEngine;
using System.Collections;

public abstract class FunctionEvent
{
    protected BuffFunctionData mData;
    protected Buff_Function_Type mType;
    protected int mBuffId;
    protected Fighter mCaster;
    protected string mSkillName;

    public int BuffId
    {
        get { return mBuffId; }
        set { mBuffId = value; }
    }

    public Fighter Caster
    {
        get { return mCaster; }
        set { mCaster = value; }
    }

    public Buff_Function_Type Type
    {
        get { return mType; }
    }

    public BattleBuffType BuffType
    {
        get { return mData.buffType; }
    }

    public int Group
    {
        get { return mData.Group; }
    }

    public string SkillName
    {
        get { return mSkillName; }
        set { mSkillName = value; }
    }

    public BuffFunctionData Data
    {
        get { return mData; }
    }

    public FunctionEvent(BuffFunctionData data)
    {
        mData = data;
    }

    public virtual float GetValue()
    {
        return Data.value;
    }

    public virtual void Enter(Fighter fighter) { }

    public virtual void Exit(Fighter fighter) { }
}
