using UnityEngine;
using UnityEngine.UI;
using System.Collections;

public class FPS : MonoBehaviour {	
    GUIStyle myStyle;
    void Start()
    {
	    // 正式环境打包，开启该宏，屏蔽fps显示
#if FPS_DISABLE
	    enabled = false;
#endif
        myStyle = new GUIStyle();
        myStyle.fontSize = 30;
    }

    void OnGUI()
    {
        if (GameMgr.HasInstance())
        {
            GUILayout.Label(string.Format("FPS: {0} timescale:{1}", GameMgr.Instance.maxFrameTime,Time.timeScale), myStyle);
        }
    }
}
