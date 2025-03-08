using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using Mono.Xml;
using System.Security;

public class MapCameraConfig
{
    public Vector3 pos;
    public Vector3 rot;
    public float fov;
    public float moveSpeed = 30f;
    public float rotSpeed = 150f;
    public float fovSpeed = 30f;

    public float speedRate = 0.5f;
    public bool syncStartSpeed = true;

    public void LoadCfgXml(SecurityElement camNode)
    {
        if (camNode == null) return;

        string posStr = camNode.Attribute("pos");
        pos = StringUtil.convertVector3(posStr);

        string angleStr = camNode.Attribute("angle");
        rot = StringUtil.convertVector3(angleStr);

        float.TryParse(camNode.Attribute("fov"), out fov);
        float.TryParse(camNode.Attribute("moveSpeed"), out moveSpeed);
        float.TryParse(camNode.Attribute("rotSpeed"), out rotSpeed);
        float.TryParse(camNode.Attribute("fovSpeed"), out fovSpeed);
    }

    public SecurityElement SaveCfgToXml()
    {
        SecurityElement camNode = new SecurityElement("CamCfg");
        camNode.AddAttribute("pos", StringUtil.ConvertVector2Str(pos));
        camNode.AddAttribute("angle", StringUtil.ConvertVector2Str(rot));
        camNode.AddAttribute("fov", fov.ToString());

        camNode.AddAttribute("moveSpeed", moveSpeed.ToString());
        camNode.AddAttribute("rotSpeed", rotSpeed.ToString());
        camNode.AddAttribute("fovSpeed", fovSpeed.ToString());

        return camNode;
    }
}

public class TowerBattleInfo
{
    #region for_editor_tool
    private TowerBattleInfoPoint mPoint = null;
    public TowerBattleInfoPoint Point
    {
        get
        {
            return mPoint;
        }
        set
        {
            mPoint = value;
        }
    }
    #endregion

    private List<MapCameraConfig> mCamCfgList = null;
    public Vector3 fieldPos;           //战场位置
    public Vector3 fieldRot;
    public Vector3 fieldForward;
    public float spawnDist;                 //距离战场中心的多远作为出生位置
    public float battleDist;                //开战距离

    public List<MapCameraConfig> CamCfgList
    {
        get { return mCamCfgList; }
    }

    public void LoadCfgXml(SecurityElement fieldNode)
    {
        if (fieldNode == null) return;

        float.TryParse(fieldNode.Attribute("spawnDist"), out spawnDist);
        float.TryParse(fieldNode.Attribute("battleDist"), out battleDist);
        fieldPos = StringUtil.convertVector3(fieldNode.Attribute("battlePos"));
        fieldRot = StringUtil.convertVector3(fieldNode.Attribute("battleRot"));
        fieldForward = StringUtil.convertVector3(fieldNode.Attribute("battleForward"));

        if (mCamCfgList == null)
            mCamCfgList = new List<MapCameraConfig>();
        else
            mCamCfgList.Clear();

        for (int idx = 0; idx < fieldNode.Children.Count; idx++)
        {
            var node = fieldNode.Children[idx] as SecurityElement;

            if (node.Tag.CompareTo("CamCfg") == 0)
            {
                MapCameraConfig camCfg = new MapCameraConfig();
                camCfg.LoadCfgXml(node);
                mCamCfgList.Add(camCfg);
            }
        }
    }

    public SecurityElement SaveCfgToXml()
    {
        if (mPoint != null)
        {
            SaveCfg(mPoint);
        }

        SecurityElement battleFieldNode = new SecurityElement("BattleField");
        battleFieldNode.AddAttribute("spawnDist", spawnDist.ToString());
        battleFieldNode.AddAttribute("battleDist", battleDist.ToString());
        battleFieldNode.AddAttribute("battlePos", StringUtil.ConvertVector2Str(fieldPos));
        battleFieldNode.AddAttribute("battleRot", StringUtil.ConvertVector2Str(fieldRot));
        battleFieldNode.AddAttribute("battleForward", StringUtil.ConvertVector2Str(fieldForward));

        if (mCamCfgList != null)
        {
            for (int idx = 0; idx < mCamCfgList.Count; idx++)
            {
                MapCameraConfig camCfg = mCamCfgList[idx];
                SecurityElement camCfgNode = camCfg.SaveCfgToXml();
                battleFieldNode.AddChild(camCfgNode);
            }
        }

        return battleFieldNode;
    }

    public void SaveCfg(TowerBattleInfoPoint point)
    {
        mPoint = point;
        fieldPos = point.transform.position;
        fieldRot = point.transform.rotation.eulerAngles;
        fieldForward = point.transform.forward;
        spawnDist = point.spawnDist;
        battleDist = point.battleDist;

        if (point.CamCfgList != null)
        {
            if (mCamCfgList == null)
                mCamCfgList = new List<MapCameraConfig>();
            else
                mCamCfgList.Clear();

            mCamCfgList.AddRange(point.CamCfgList);
        }
    }
}

public class TowerBattleInfoPoint : MonoBehaviour
{
    public float spawnDist = 10;
    public float battleDist = 6;
    public List<MapCameraConfig> CamCfgList;

#if UNITY_EDITOR
    void OnDrawGizmos()
    {
        Gizmos.color = Color.red;
        Gizmos.DrawSphere(this.transform.position, 0.1f);

        UnityEditor.Handles.color = Color.blue;
        UnityEditor.Handles.ArrowHandleCap(0, this.transform.position, this.transform.rotation, 10f, EventType.Repaint);
        UnityEditor.Handles.Disc(this.transform.rotation, this.transform.position, Vector3.up, 5, false, 1);
    }
#endif
}

public class TowerTeamBornInfo
{
    public Vector3[] bornPosList = new Vector3[TowerBattleCfgMgr.team_num];
    public Vector3 forward;
    public Vector3 camPos;          //出生时相机位置
    public Vector3 camRot;          //出生时相机旋转
    public float fov;               //出生时相机fov

    public void LoadCfgXml(SecurityElement bornNode)
    {
        if (bornNode == null) return;

        for (int pdx = 0; pdx < TowerBattleCfgMgr.team_num; pdx++)
        {
            Vector3 pos = StringUtil.convertVector3(bornNode.Attribute("p" + pdx));
            bornPosList[pdx] = pos;
        }

        camPos = StringUtil.convertVector3(bornNode.Attribute("camPos"));
        camRot = StringUtil.convertVector3(bornNode.Attribute("camRot"));
        forward = StringUtil.convertVector3(bornNode.Attribute("forward"));
        float.TryParse(bornNode.Attribute("camFov"), out fov);
    }

    public SecurityElement SaveCfgToXml()
    {
        SecurityElement node = new SecurityElement("TeamBorn");

        node.AddAttribute("camPos", StringUtil.ConvertVector2Str(camPos));
        node.AddAttribute("camRot", StringUtil.ConvertVector2Str(camRot));
        node.AddAttribute("camFov", fov.ToString());
        node.AddAttribute("forward", StringUtil.ConvertVector2Str(forward));

        for (int idx = 0; idx < TowerBattleCfgMgr.team_num; idx++)
        {
            Vector3 pos = bornPosList[idx];
            node.AddAttribute("p" + idx, StringUtil.ConvertVector2Str(pos));
        }

        return node;
    }
}

public class TowerTeamBornInfoPoint : MonoBehaviour
{
    public GameObject[] bornPoints = new GameObject[TowerBattleCfgMgr.team_num];
    public Vector3[] bornPosList = new Vector3[TowerBattleCfgMgr.team_num];
    public Vector3 forward;
    public Vector3 camPos;          //出生时相机位置
    public Vector3 camRot;          //出生时相机旋转
    public float fov;               //出生时相机fov

    public void LoadCfgXml(SecurityElement bornNode)
    {
        if (bornNode == null) return;

        for (int pdx = 0; pdx < TowerBattleCfgMgr.team_num; pdx++)
        {
            Vector3 pos = StringUtil.convertVector3(bornNode.Attribute("p" + pdx));
            bornPosList[pdx] = pos;
            Transform child = this.transform.Find("p" + pdx);
            if (child == null)
            {
                GameObject childGo = new GameObject("p" + pdx);
                child = childGo.transform;
                child.SetParent(this.transform);
            }
            child.position = pos;
        }

        camPos = StringUtil.convertVector3(bornNode.Attribute("camPos"));
        camRot = StringUtil.convertVector3(bornNode.Attribute("camRot"));
        forward = StringUtil.convertVector3(bornNode.Attribute("forward"));
        float.TryParse(bornNode.Attribute("camFov"), out fov);
    }

    public SecurityElement SaveCfgToXml()
    {
        SecurityElement node = new SecurityElement("TeamBorn");

        node.AddAttribute("camPos", StringUtil.ConvertVector2Str(camPos));
        node.AddAttribute("camRot", StringUtil.ConvertVector2Str(camRot));
        node.AddAttribute("camFov", fov.ToString());
        node.AddAttribute("forward", StringUtil.ConvertVector2Str(forward));

        for (int idx = 0; idx < TowerBattleCfgMgr.team_num; idx++)
        {
            Transform child = this.transform.Find("p" + idx);
            if (child != null)
                bornPosList[idx] = child.position;

            Vector3 pos = bornPosList[idx];
            node.AddAttribute("p" + idx, StringUtil.ConvertVector2Str(pos));
        }

        return node;
    }

#if UNITY_EDITOR
    private void OnDrawGizmos()
    {
        for (int jdx = 0; jdx < bornPosList.Length; jdx++)
        {
            Transform child = this.transform.Find("p" + jdx);
            if (child == null) continue;

            DrawPoint(child.position,this.transform.rotation);
        }

    }

    void DrawPoint(Vector3 pos, Quaternion rot)
    {
        Gizmos.color = Color.yellow;
        Gizmos.DrawSphere(pos, 0.1f);

        UnityEditor.Handles.color = Color.blue;
        UnityEditor.Handles.ArrowHandleCap(0, pos, rot, 1f, EventType.Repaint);
        UnityEditor.Handles.Disc(rot, pos, Vector3.up, transform.localScale.z * 0.5f, false, 1);
    }
#endif
}

public class TowerBattleCfgMgr : Singleton<TowerBattleCfgMgr>
{
    public const int team_num = 6;

    TowerTeamBornInfo teamBornInfo = null;

    List<TowerBattleInfo> mTowerBattlenfoDic = new List<TowerBattleInfo>();

    public TowerTeamBornInfo TeamBornData
    {
        get { return teamBornInfo; }
    }

    public override void Init()
    {
        base.Init();
        ReadCfg();
    }

    public override void UnInit()
    {
        base.UnInit();
    }

    public void ReadCfg()
    {
        mTowerBattlenfoDic.Clear();

        string ta = ConfigMgr.Instance.GetXmlCfg("TowerBattleCfg");
        if (ta == null)
        {
            DebugHelper.LogError("TowerBattleCfg 文件不存在");
            return;
        }

        SecurityParser doc = new SecurityParser();
        try
        {
            doc.LoadXml(ta);
        }
        catch (System.Exception e)
        {
            DebugHelper.Assert(false, "exception = {0}", e.Message);
            return;
        }

        System.Security.SecurityElement root = doc.SelectSingleNode("BattleFields");
        if (root == null || root.Children == null) return;

        for (int idx = 0; idx < root.Children.Count; idx++)
        {
            var node = root.Children[idx] as System.Security.SecurityElement;
            if (node.Tag.CompareTo("BattleField") == 0)
            {
                TowerBattleInfo battleFieldCfg = new TowerBattleInfo();
                battleFieldCfg.LoadCfgXml(node);
                mTowerBattlenfoDic.Add(battleFieldCfg);
            }
            else if (node.Tag.CompareTo("TeamBorn") == 0)
            {
                if (teamBornInfo == null)
                {
                    teamBornInfo = new TowerTeamBornInfo();
                }
                teamBornInfo.LoadCfgXml(node);
            }
        }
    }

    public TowerBattleInfo GetTowerBattleInfo()
    {
        if (mTowerBattlenfoDic.Count == 0) return null;

        int idx = Random.Range(0, mTowerBattlenfoDic.Count);
        return mTowerBattlenfoDic[idx];
    }
}
