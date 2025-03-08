using UnityEngine;
using System.Collections;
using UnityEditor;
using System.Security;
using Mono.Xml;

[CustomEditor(typeof(GlobalTrigger))]
public class GlobalTriggerEditor : Editor
{
    GlobalTrigger gTrigger = null;

    private void OnEnable()
    {
        gTrigger = target as GlobalTrigger;
    }

    public override void OnInspectorGUI()
    {
        base.OnInspectorGUI();
        if(GUILayout.Button("导出到配置"))
        {
            SaveCfg();
        }
    }

    void SaveCfg()
    {
        string cfgFileName = "Newbie_Design.xml";
        string filePath = Application.dataPath + "/Content/Xml/" + cfgFileName;

        SecurityElement root = new SecurityElement("GlobalTrigger");

        gTrigger.SaveCfgToXml(root);

        SecurityTools.DumpSecurityElementToXml(root, filePath);
        AssetDatabase.Refresh();
    }
}
