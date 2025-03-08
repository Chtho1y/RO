using UnityEngine;
using System.Collections;
using System;

public struct stLocCfg
{
    public Vector3 heroPos;
    public Vector3 petPos;

    public stLocCfg(Vector3 hPos, Vector3 pPos)
    {
        heroPos = hPos;
        petPos = pPos;
    }

    public void ResetHeight(float py)
    {
        heroPos.y = py;
        petPos.y = py;
    }
}

public class ReadyPoint : MonoBehaviour
{
    [Serializable]
    public struct ReadyPointCfg
    {
        public int order;
        public Transform point;
        public Transform petPoint;
    }

    public ReadyPointCfg[] NoviceReadyPoints;

    public ReadyPointCfg[] SwordReadyPoints;

    public ReadyPointCfg[] ThiefReadyPoints;

    public ReadyPointCfg[] HunterReadyPoints;

    public ReadyPointCfg[] MagicReadyPoints;

    public ReadyPointCfg[] PriestReadyPoints;

    stLocCfg[] novicePosList = null;
    stLocCfg[] swordPosList = null;
    stLocCfg[] thiefPosList = null;
    stLocCfg[] hunterPosList = null;
    stLocCfg[] magicPosList = null;
    stLocCfg[] priestPosList = null;


    stLocCfg[] initedNovicePosList = null;
    stLocCfg[] initedSwordPosList = null;
    stLocCfg[] initedThiefPosList = null;
    stLocCfg[] initedHunterPosList = null;
    stLocCfg[] initedMagicPosList = null;
    stLocCfg[] initedPriestPosList = null;


    Vector3 mOffset = Vector3.zero;
    Vector3 mCenter = Vector3.zero;
    public Vector3 Center
    {
        get { return mCenter; }
    }

    private void Start()
    {
        InitPos();

        CalcRelativePos();
    }

    void InitPos()
    {
        if (NoviceReadyPoints != null)
        {
            novicePosList = new stLocCfg[NoviceReadyPoints.Length];
            for (int idx = 0; idx < novicePosList.Length; idx++)
            {
                ReadyPointCfg pointCfg = NoviceReadyPoints[idx];
                Vector3 hPos = pointCfg.point != null ? pointCfg.point.position : Vector3.zero;
                Vector3 pPos = pointCfg.petPoint != null ? pointCfg.petPoint.position : Vector3.zero;
                novicePosList[pointCfg.order - 1] = new stLocCfg(hPos, pPos);
            }
        }

        if (SwordReadyPoints != null)
        {
            swordPosList = new stLocCfg[SwordReadyPoints.Length];
            for (int idx = 0; idx < SwordReadyPoints.Length; idx++)
            {
                ReadyPointCfg pointCfg = SwordReadyPoints[idx];
                Vector3 hPos = pointCfg.point != null ? pointCfg.point.position : Vector3.zero;
                Vector3 pPos = pointCfg.petPoint != null ? pointCfg.petPoint.position : Vector3.zero;
                swordPosList[pointCfg.order - 1] = new stLocCfg(hPos, pPos);
            }
        }

        if (ThiefReadyPoints != null)
        {
            thiefPosList = new stLocCfg[ThiefReadyPoints.Length];
            for (int idx = 0; idx < ThiefReadyPoints.Length; idx++)
            {
                ReadyPointCfg pointCfg = ThiefReadyPoints[idx];
                Vector3 hPos = pointCfg.point != null ? pointCfg.point.position : Vector3.zero;
                Vector3 pPos = pointCfg.petPoint != null ? pointCfg.petPoint.position : Vector3.zero;
                thiefPosList[pointCfg.order - 1] = new stLocCfg(hPos, pPos);
            }
        }

        if (HunterReadyPoints != null)
        {
            hunterPosList = new stLocCfg[HunterReadyPoints.Length];
            for (int idx = 0; idx < HunterReadyPoints.Length; idx++)
            {
                ReadyPointCfg pointCfg = HunterReadyPoints[idx];
                Vector3 hPos = pointCfg.point != null ? pointCfg.point.position : Vector3.zero;
                Vector3 pPos = pointCfg.petPoint != null ? pointCfg.petPoint.position : Vector3.zero;
                hunterPosList[pointCfg.order - 1] = new stLocCfg(hPos, pPos);
            }
        }

        if (MagicReadyPoints != null)
        {
            magicPosList = new stLocCfg[MagicReadyPoints.Length];
            for (int idx = 0; idx < MagicReadyPoints.Length; idx++)
            {
                ReadyPointCfg pointCfg = MagicReadyPoints[idx];
                Vector3 hPos = pointCfg.point != null ? pointCfg.point.position : Vector3.zero;
                Vector3 pPos = pointCfg.petPoint != null ? pointCfg.petPoint.position : Vector3.zero;
                magicPosList[pointCfg.order - 1] = new stLocCfg(hPos, pPos);
            }
        }

        if (PriestReadyPoints != null)
        {
            priestPosList = new stLocCfg[PriestReadyPoints.Length];
            for (int idx = 0; idx < PriestReadyPoints.Length; idx++)
            {
                ReadyPointCfg pointCfg = PriestReadyPoints[idx];
                Vector3 hPos = pointCfg.point != null ? pointCfg.point.position : Vector3.zero;
                Vector3 pPos = pointCfg.petPoint != null ? pointCfg.petPoint.position : Vector3.zero;
                priestPosList[pointCfg.order - 1] = new stLocCfg(hPos, pPos);
            }
        }
    }

    void CalcRelativePos()
    {
        Vector3 hPos = Vector3.zero; ;
        int cnt = novicePosList.Length;
        initedNovicePosList = new stLocCfg[novicePosList.Length];

        for (int idx = 0; idx < novicePosList.Length; idx++)
        {
            hPos += novicePosList[idx].heroPos;
            initedNovicePosList[idx] = novicePosList[idx];
        }

        cnt += swordPosList.Length;
        initedSwordPosList = new stLocCfg[swordPosList.Length];

        for (int idx = 0; idx < swordPosList.Length; idx++)
        {
            hPos += swordPosList[idx].heroPos;
            initedSwordPosList[idx] = swordPosList[idx];
        }

        cnt += thiefPosList.Length;
        initedThiefPosList = new stLocCfg[thiefPosList.Length];
        for (int idx = 0; idx < thiefPosList.Length; idx++)
        {
            hPos += thiefPosList[idx].heroPos;
            initedThiefPosList[idx] = thiefPosList[idx];
        }

        cnt += hunterPosList.Length;
        initedHunterPosList = new stLocCfg[hunterPosList.Length];

        for (int idx = 0; idx < hunterPosList.Length; idx++)
        {
            hPos += hunterPosList[idx].heroPos;
            initedHunterPosList[idx] = hunterPosList[idx];
        }

        cnt += magicPosList.Length;
        initedMagicPosList = new stLocCfg[magicPosList.Length];

        for (int idx = 0; idx < magicPosList.Length; idx++)
        {
            hPos += magicPosList[idx].heroPos;
            initedMagicPosList[idx] = magicPosList[idx];
        }

        cnt += priestPosList.Length;
        initedPriestPosList = new stLocCfg[priestPosList.Length];

        for (int idx = 0; idx < priestPosList.Length; idx++)
        {
            hPos += priestPosList[idx].heroPos;
            initedPriestPosList[idx] = priestPosList[idx];
        }

        mCenter = hPos / cnt;
        mOffset = this.transform.position - mCenter;
        mOffset.y = 0;
    }

    public stLocCfg GetBornPointPos(ProfessionType profession, int order)
    {
        stLocCfg[] posList = null;
        if (profession == ProfessionType.Pro_Type_0)
            posList = initedNovicePosList;
        else if (profession == ProfessionType.Pro_Type_Sword)
            posList = initedSwordPosList;
        else if (profession == ProfessionType.Pro_Type_Thief)
            posList = initedThiefPosList;
        else if (profession == ProfessionType.Pro_Type_Hunter)
            posList = initedHunterPosList;
        else if (profession == ProfessionType.Pro_Type_Magic)
            posList = initedMagicPosList;
        else if (profession == ProfessionType.Pro_Type_Priest)
            posList = initedPriestPosList;

        if (posList != null && order >= 1 && order <= posList.Length)
        {
            return posList[order - 1];
        }
        return default(stLocCfg);
    }

    public stLocCfg GetReadyPointPos(ProfessionType profession, int order)
    {
        stLocCfg[] posList = null;
        if (profession == ProfessionType.Pro_Type_0)
            posList = novicePosList;
        else if (profession == ProfessionType.Pro_Type_Sword)
            posList = swordPosList;
        else if (profession == ProfessionType.Pro_Type_Thief)
            posList = thiefPosList;
        else if (profession == ProfessionType.Pro_Type_Hunter)
            posList = hunterPosList;
        else if (profession == ProfessionType.Pro_Type_Magic)
            posList = magicPosList;
        else if (profession == ProfessionType.Pro_Type_Priest)
            posList = priestPosList;

        if (posList != null && order >= 1 && order <= posList.Length)
        {
            return posList[order - 1];
        }
        return default(stLocCfg);
    }

    public void CalcNextBattleFieldPoints(Vector3 center, Vector3 rot)
    {
        //DebugHelper.LogError("CalcNextBattleFieldPoints:" + center);
        mCenter = center;
        this.transform.position = mCenter;
        this.transform.rotation = Quaternion.Euler(rot);

        InitPos();

        ResetHeight();
    }

    void ResetHeight()
    {
        for (int idx = 0; idx < novicePosList.Length; idx++)
            novicePosList[idx].ResetHeight(mCenter.y);

        for (int idx = 0; idx < swordPosList.Length; idx++)
            swordPosList[idx].ResetHeight(mCenter.y);

        for (int idx = 0; idx < thiefPosList.Length; idx++)
            thiefPosList[idx].ResetHeight(mCenter.y);

        for (int idx = 0; idx < hunterPosList.Length; idx++)
            hunterPosList[idx].ResetHeight(mCenter.y);

        for (int idx = 0; idx < magicPosList.Length; idx++)
            magicPosList[idx].ResetHeight(mCenter.y);

        for (int idx = 0; idx < priestPosList.Length; idx++)
            priestPosList[idx].ResetHeight(mCenter.y);
    }

    public void Dispose()
    {
        swordPosList = null;
        thiefPosList = null;
        hunterPosList = null;
        magicPosList = null;
        priestPosList = null;
    }

#if UNITY_EDITOR
    private void OnDrawGizmos()
    {
        for (int jdx = 0; jdx < this.transform.childCount; jdx++)
        {
            Transform child = this.transform.GetChild(jdx);
            if (child.gameObject.activeInHierarchy)
                DrawPoint(child.position, child.rotation);
        }

    }

    void DrawPoint(Vector3 pos, Quaternion rot)
    {
        Gizmos.color = Color.red;
        Gizmos.DrawSphere(pos, 0.1f);

        UnityEditor.Handles.color = Color.green;
        UnityEditor.Handles.ArrowHandleCap(0, pos, rot, transform.localScale.z, EventType.Repaint);
        UnityEditor.Handles.Disc(rot, pos, Vector3.up, transform.localScale.z * 0.5f, false, 1);
    }
#endif
}
