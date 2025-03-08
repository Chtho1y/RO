using UnityEngine;
using System.Collections;
using System.Security;

[AddComponentMenu("Trigger/Trigger_Spawn")]
public class AreaEventTriggerSpawn : AreaEventTrigger
{
    public SpawnCfgGroup[] SpawnGroups = new SpawnCfgGroup[0];

    protected override void BuildTriggerWrapper()
    {
        PresetActWrapper = new TriggerActionWrapper(EGlobalTriggerAct.TriggerSpawn);
        GameObject[] SpawnGroupObjList = new GameObject[SpawnGroups.Length];
        for (int i = 0; i < SpawnGroups.Length; ++i)
        {
            SpawnGroupObjList[i] = null;
            if (SpawnGroups[i])
            {
                SpawnGroupObjList[i] = SpawnGroups[i].gameObject;
            }
        }
        PresetActWrapper.RefObjList = SpawnGroupObjList;
        PresetActWrapper.Init(ID);
    }

    public SecurityElement SaveToXml()
    {
        SecurityElement node = new SecurityElement("TriggerSpawnGroup");
        for(int idx =0; idx < SpawnGroups.Length;idx++)
        {
            SpawnCfgGroup cfgGroup = SpawnGroups[idx];

            if(cfgGroup.ConfigId > 0)
            {
                SecurityElement childNode = new SecurityElement("Spawn");
                childNode.AddAttribute("id", cfgGroup.ConfigId.ToString());
                childNode.AddAttribute("actorType", ((int)cfgGroup.actorType).ToString());
                node.AddChild(childNode);
            }

            SpawnCfg nextPoint = cfgGroup.nextPoint;

            while (nextPoint)
            {
                SecurityElement childNode = new SecurityElement("Spawn");
                childNode.AddAttribute("id", nextPoint.ConfigId.ToString());
                childNode.AddAttribute("actorType", ((int)nextPoint.actorType).ToString());
                node.AddChild(childNode);

                nextPoint = nextPoint.nextPoint;
            }

        }
        return node;
    }
}
