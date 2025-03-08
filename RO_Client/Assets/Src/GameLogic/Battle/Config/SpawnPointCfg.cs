using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;
using System.Security;

public enum SpawnPointType
{
    Monster = 1,        //小怪出生点
    Boss = 2,           //boss出生点
}

[Serializable]
public struct MonsterSpawnLoc
{
    public Vector3 pos;
    public Vector3 rot;
    public int npcId;
    public long npcInstanceId;
}

public class SpawnPointCfg
{
    private SpawnPointType mType = SpawnPointType.Monster;

    public SpawnPointType PointType
    {
        get { return mType; }
    }

    private Vector3 mPos;
    public Vector3 Pos
    {
        get { return mPos; }
    }

    private Vector3 mRot;
    public Vector3 Rot
    {
        get { return mRot; }
    }

    private Vector3 mTransferPos;
    public Vector3 TransferPos
    {
        get { return mTransferPos; }
    }


    private Vector3 mTransferRot;
    public Vector3 TransferRot
    {
        get { return mTransferRot; }
    }

    private Vector3 mBossCamPos;
    public Vector3 BossCamPos
    {
        get { return mBossCamPos; }
    }

    private Vector3 mBossCamRot;
    public Vector3 BossCamRot
    {
        get { return mBossCamRot; }
    }

    private float mCamFar;
    public float CamFar
    {
        get { return mCamFar; }
    }

    private List<MonsterSpawnLoc> mPointList;
    public List<MonsterSpawnLoc> PointList
    {
        get { return mPointList; }
    }

    private SpawnPoint mCurrentSpawnPoint = null;
    public SpawnPoint CurrentSpawnPoint
    {
        get
        {
            return mCurrentSpawnPoint;
        }
        set
        {
            mCurrentSpawnPoint = value;
        }
    }


    private float mActorDist = 3;
    public float ActorReadyDist
    {
        get { return mActorDist; }
    }


    private float mHorSpace = 2;
    public float HorSpace
    {
        get { return mHorSpace; }
    }

    private float mVerSpace = 2;
    public float VerSpace
    {
        get { return mVerSpace; }
    }

    public SpawnPointCfg()
    {
        mPointList = new List<MonsterSpawnLoc>();
    }

    public void LoadCfgXml(SecurityElement spNode)
    {
        mPointList.Clear();
        if (spNode == null) return;

        if (spNode.Children == null) return;

        int type = 0;
        int.TryParse(spNode.Attribute("type"), out type);
        mType = (SpawnPointType)type;

        float.TryParse(spNode.Attribute("px"), out mPos.x);
        float.TryParse(spNode.Attribute("py"), out mPos.y);
        float.TryParse(spNode.Attribute("pz"), out mPos.z);

        float.TryParse(spNode.Attribute("rx"), out mRot.x);
        float.TryParse(spNode.Attribute("ry"), out mRot.y);
        float.TryParse(spNode.Attribute("rz"), out mRot.z);

        float.TryParse(spNode.Attribute("actorReadyDist"), out mActorDist);
        float.TryParse(spNode.Attribute("hSpace"), out mHorSpace);
        float.TryParse(spNode.Attribute("vSpace"), out mVerSpace);

        for (int idx =0; idx < spNode.Children.Count;idx++)
        {
            var pointNode = spNode.Children[idx] as SecurityElement;

            if(pointNode.Tag.CompareTo("Transfer") == 0)
            {
                float.TryParse(pointNode.Attribute("px"), out mTransferPos.x);
                float.TryParse(pointNode.Attribute("py"), out mTransferPos.y);
                float.TryParse(pointNode.Attribute("pz"), out mTransferPos.z);

                float.TryParse(pointNode.Attribute("rx"), out mTransferRot.x);
                float.TryParse(pointNode.Attribute("ry"), out mTransferRot.y);
                float.TryParse(pointNode.Attribute("rz"), out mTransferRot.z);
            } else if(pointNode.Tag.CompareTo("Camera") == 0)
            {
                float.TryParse(pointNode.Attribute("px"), out mBossCamPos.x);
                float.TryParse(pointNode.Attribute("py"), out mBossCamPos.y);
                float.TryParse(pointNode.Attribute("pz"), out mBossCamPos.z);

                float.TryParse(pointNode.Attribute("rx"), out mBossCamRot.x);
                float.TryParse(pointNode.Attribute("ry"), out mBossCamRot.y);
                float.TryParse(pointNode.Attribute("rz"), out mBossCamRot.z);

                float.TryParse(pointNode.Attribute("far"), out mCamFar);
            }
            else
            {

                MonsterSpawnLoc loc = new MonsterSpawnLoc();
                float.TryParse(pointNode.Attribute("px"), out loc.pos.x);
                float.TryParse(pointNode.Attribute("py"), out loc.pos.y);
                float.TryParse(pointNode.Attribute("pz"), out loc.pos.z);

                float.TryParse(pointNode.Attribute("rx"), out loc.rot.x);
                float.TryParse(pointNode.Attribute("ry"), out loc.rot.y);
                float.TryParse(pointNode.Attribute("rz"), out loc.rot.z);

                int.TryParse(pointNode.Attribute("npcId"), out loc.npcId);
                mPointList.Add(loc);
            }
        }
    }

    public SecurityElement SaveCfgToXml()
    {
        if (mPointList == null || mPointList.Count == 0) return null;

        if (mCurrentSpawnPoint != null)
        {
            mCurrentSpawnPoint.SavePoint();
            SaveCfg(mCurrentSpawnPoint);
        }

        SecurityElement spNode = new SecurityElement("SpawnPoint");
        spNode.AddAttribute("type", ((int)mType).ToString());
        spNode.AddAttribute("px", mPos.x.ToString());
        spNode.AddAttribute("py", mPos.y.ToString());
        spNode.AddAttribute("pz", mPos.z.ToString());
        spNode.AddAttribute("rx", mRot.x.ToString());
        spNode.AddAttribute("ry", mRot.y.ToString());
        spNode.AddAttribute("rz", mRot.z.ToString());

        spNode.AddAttribute("actorReadyDist", mActorDist.ToString());
        spNode.AddAttribute("hSpace", mHorSpace.ToString());
        spNode.AddAttribute("vSpace", mVerSpace.ToString());

        for (int idx =0; idx < mPointList.Count;idx++)
        {
            MonsterSpawnLoc loc = mPointList[idx];

            SecurityElement pointNode = new SecurityElement("Point");
            pointNode.AddAttribute("px", loc.pos.x.ToString());
            pointNode.AddAttribute("py", loc.pos.y.ToString());
            pointNode.AddAttribute("pz", loc.pos.z.ToString());

            pointNode.AddAttribute("rx", loc.rot.x.ToString());
            pointNode.AddAttribute("ry", loc.rot.y.ToString());
            pointNode.AddAttribute("rz", loc.rot.z.ToString());

            pointNode.AddAttribute("npcId", loc.npcId.ToString());

            spNode.AddChild(pointNode);
        }

        if(mType == SpawnPointType.Boss)
        {
            SecurityElement transferNode = new SecurityElement("Transfer");
            transferNode.AddAttribute("px", mTransferPos.x.ToString());
            transferNode.AddAttribute("py", mTransferPos.y.ToString());
            transferNode.AddAttribute("pz", mTransferPos.z.ToString());
            transferNode.AddAttribute("rx", mTransferRot.x.ToString());
            transferNode.AddAttribute("ry", mTransferRot.y.ToString());
            transferNode.AddAttribute("rz", mTransferRot.z.ToString());
            spNode.AddChild(transferNode);

            SecurityElement camNode = new SecurityElement("Camera");
            camNode.AddAttribute("px", mBossCamPos.x.ToString());
            camNode.AddAttribute("py", mBossCamPos.y.ToString());
            camNode.AddAttribute("pz", mBossCamPos.z.ToString());

            camNode.AddAttribute("rx", mBossCamRot.x.ToString());
            camNode.AddAttribute("ry", mBossCamRot.y.ToString());
            camNode.AddAttribute("rz", mBossCamRot.z.ToString());

            camNode.AddAttribute("far", mCamFar.ToString());
            spNode.AddChild(camNode);
        } 

        return spNode;
    }

    public void SaveCfg(SpawnPoint sp)
    {
        mCurrentSpawnPoint = sp;
        mPos = sp.transform.position;
        mRot = sp.transform.eulerAngles;

        mType = sp.type;
        mTransferPos = sp.transferPos;
        mTransferRot = sp.transferRot;
        mActorDist = sp.fActorReadyDist;
        mHorSpace = sp.fHorSpace;
        mVerSpace = sp.fVerSpace;
        mBossCamPos = sp.camPos;
        mBossCamRot = sp.camRot;
        mCamFar = sp.camFar;

        mPointList.Clear();
        mPointList.AddRange(sp.spawnLocs);
    }

    public void AddPoint(Vector3 pos,Vector3 rot)
    {
        MonsterSpawnLoc loc = new MonsterSpawnLoc();
        loc.pos = pos;
        loc.rot = rot;
        mPointList.Add(loc);
    }

    public void DeletePoint(MonsterSpawnLoc loc)
    {
        mPointList.Remove(loc);
    }
}
