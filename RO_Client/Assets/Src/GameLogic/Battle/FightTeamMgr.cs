using UnityEngine;
using System.Collections;

public class FightTeamInfo {

    public const int FlyPointThreshold = 100;

    public const int FlyPointPerHit = 5;

    public const float CritFlyPointRate = 4f;

    public const float AutoFlyHeight = 0.5f;

    #region fields
    int mSide;  // 0 none ; 1 left ;  2 right  
    int mFlyPoint;  //击飞点数
    #endregion

    #region properties
    public int Side
    {
        get { return mSide; }
    }

    public int FlyPoint
    {
        get {return mFlyPoint;}
        set { mFlyPoint = value; }
    }
    #endregion

    public FightTeamInfo(int side) { mSide = side; }
}


public class FightTeamMgr
{
    static FightTeamMgr mInstance;
    public static FightTeamMgr Instance
    {
        get
        {
            if (mInstance == null)
                mInstance = new FightTeamMgr();
            return mInstance;
        }
    }

    FightTeamInfo leftTeam;
    FightTeamInfo rightTeam;

    FightTeamMgr()
    {
        leftTeam = new FightTeamInfo(1);
        rightTeam = new FightTeamInfo(2);
    }

    public FightTeamInfo Left
    {
        get { return leftTeam; }
    }

    public FightTeamInfo Right
    {
        get { return rightTeam; }
    }
}