using UnityEngine;
using System.Collections;
using UnityEngine.UI;

public class ModelTopUI
{

    public GameObject TopUI;
    public GameObject target;

    private string mAssetName;
    private Transform TopPos = null;
    private Vector3 vL = new Vector3((-1.0f * (float)Screen.width / (float)Screen.height) + 0.13f, 0.0f, 0.0f);
    private Vector3 vR = new Vector3(((float)Screen.width / (float)Screen.height) - 0.13f, 0.0f, 0.0f);
    private Vector3 linkPos = new Vector3(0,0,0);
    private RectTransform mItemIt = null;

    public ModelTopUI(GameObject _target, Camera cam,string assetName)
    {
        mAssetName = assetName;
        target = _target;
        TopPos = UnityEngineUtils.RecurisiveFindTransformChild(target.transform, "ui_point");
        TopUI = ResourceMgr.Instance.GetGoFromPool(Constants.UIPath, mAssetName);
        TopUI.SetSafeActive(true);
        SetTopUI(cam);
        SetBattleFlag(false);
    }

    public void SetLocation(Vector3 offsetPos_)
    {
        linkPos = offsetPos_;
    }

    public void SetNameAndLevel(string name,int level)
    {
        if (TopUI == null) return;

        Transform nameTrans = TopUI.transform.Find("Item/name");
        if(nameTrans!=null)
        {
            Text nameLbl = nameTrans.GetComponent<Text>();
            if (nameLbl != null)
                nameLbl.text = I18N.T(name);
        }

        Transform lvTrans = TopUI.transform.Find("Item/Lv/val");
        if(lvTrans!=null)
        {
            Text lvLbl = lvTrans.GetComponent<Text>();
            if (lvLbl != null)
                lvLbl.text = level.ToString();
        }

        TopUI.name = name;
    }

    public void SetBattleFlag(bool inBattle)
    {
        if (TopUI == null) return;

        Transform battleNode = TopUI.transform.Find("Item/Battle");
        if (battleNode != null)
        {
            battleNode.gameObject.SetActive(inBattle);
        }
    }

    //头顶事件图标
    public void SetTopUI(Camera cam)
    {
        //处理UI跟随
        if (TopUI)
        {
            Transform trans = TopUI.transform;
            trans.SetParent(BattleFlyWordMgr.Instance.HudRootTrans, true);
            trans.localScale = Vector3.one;
            trans.localRotation = Quaternion.identity;

            RectTransform rt = trans.GetComponent<RectTransform>();
            rt.anchorMin = Vector2.zero;
            rt.anchorMax = Vector2.one;
            rt.anchoredPosition3D = Vector3.zero;
            rt.offsetMin = rt.offsetMax = Vector2.zero;

            Transform item = trans.Find("Item");
            if(item!=null)
            {
                mItemIt = item.GetComponent<RectTransform>();
            }
        }
    }

    public void Update(Camera cam)
    {
        //处理UI跟随
        if (TopPos == null || mItemIt == null) return;


        Vector3 m_vec3Head = TopPos.position;
        m_vec3Head.x = TopPos.position.x + linkPos.x;
        m_vec3Head.y = TopPos.position.y + linkPos.y;
        m_vec3Head.z = TopPos.position.z + linkPos.z;

        Vector3 pos = cam.WorldToViewportPoint(m_vec3Head);
        mItemIt.anchoredPosition3D = new Vector3((pos.x - 0.5f) * UIMgr.SCREEN_WIDTH, (pos.y - 0.5f) * UIMgr.SCREEN_HEIGHT, 0);
    }

    public void SetVisible(bool vis)
    {
        if (TopUI != null)
            TopUI.SetSafeActive(vis);
    }

    public void Dispose()
    {
        target = null;
        if (TopUI)
        {
            GameObject.Destroy(TopUI);
        }
        TopUI = null;
    }

}
