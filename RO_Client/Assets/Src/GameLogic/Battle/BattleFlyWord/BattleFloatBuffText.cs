using UnityEngine;
using System.Collections;
using UnityEngine.UI;

public class BattleFloatBuffText : MonoBehaviour
{
    public Transform item;

    Fighter target = null;

    bool bDisposed = false;
    bool bInited = false;

    Image functionImg;
    GameObject missGo;
    GameObject dodgeGo;

    GameObject shieldGo;
    Text shieldNumText;

    RectTransform rt = null;
    Animator mAnim = null;

    float beginShowTime = 0;
    float duration = 1.0f;
    long loadSeq = 0;

    public bool Finished
    {
        get
        {
            if (target == null) return true;

            float passedTime = Time.realtimeSinceStartup - beginShowTime;
            if (passedTime >= duration)
                return true;

            return false;
        }

    }

    void Start()
    {
    }

    
    void Update()
    {
        //if (bDisposed || !bInited) return;

        //UpdatePos();
    }

    private void OnDestroy()
    {
        Dispose();
    }

    public void ShowBuffText(Fighter fighter, string icon,bool upAnim)
    {
        OnShow(fighter, upAnim);
        missGo.SetActive(false);
        shieldGo.gameObject.SetActive(false);
        dodgeGo.SetActive(false);
        if (functionImg != null)
        {
            loadSeq = ResourceMgr.Instance.LoadAsset<Sprite>(OnLoadBuffTextCompleted, Constants.IconDir, icon);
        }
    }

    void OnLoadBuffTextCompleted(Sprite sp, string assetPath, params string[] assetNames)
    {
        loadSeq = 0;
        if(functionImg!=null)
        {
            functionImg.sprite = sp;
            functionImg.gameObject.SetActive(true);
        }
    }

    public void ShowShield(Fighter fighter, float hurt)
    {
        OnShow(fighter);
        missGo.SetActive(false);
        dodgeGo.SetActive(false);
        functionImg.gameObject.SetActive(false);
        shieldGo.gameObject.SetActive(true);
        shieldNumText.text = I18N.T("Shield") + hurt.ToString();
        if(fighter.IsTeamMember)
            shieldNumText.color = Color.red;
        else
            shieldNumText.color = Color.white;
    }

    public void ShowMissing(Fighter fighter)
    {
        OnShow(fighter);
        missGo.SetActive(fighter.TeamSide == eTeamType.Enemy);
        dodgeGo.SetActive(fighter.TeamSide == eTeamType.Friend);
        functionImg.gameObject.SetActive(false);
        shieldGo.gameObject.SetActive(false);
    }


    public void Dispose()
    {
        if(loadSeq > 0)
        {
            ResourceMgr.Instance.UnloadAssetBySeqId(loadSeq);
            loadSeq = 0;
        }
        target = null;
        bDisposed = true;
        if (missGo) { 
            missGo.SetActive(false);
        }

        if (dodgeGo) { 
            dodgeGo.SetActive(false);
        }

        if (functionImg) { 
            functionImg.gameObject.SetActive(false);
        }

        if (shieldGo) { 
            shieldGo.gameObject.SetActive(false);
        }
    }

    void OnShow(Fighter fighter, bool upAnim = true)
    {
        if (!bInited)
        {
            InitCom();
        }
        target = fighter;
        beginShowTime = Time.realtimeSinceStartup;
        UpdatePos();
        if(gameObject.activeInHierarchy)
        {
            if (upAnim)
            {
                mAnim.Play("EffectUp");
            }
            else
            {
                mAnim.Play("EffectDown");
            }
        }
    }

    void UpdatePos()
    {
        if (target == null) return;

        Vector3 relativePos = target.Ctrl.GetUIPointPos() + target.Actor.AvatarData.buffTextPos;
        Vector3 pos = BattleCamera.Instance.RealCamera.WorldToViewportPoint(relativePos);
        if (rt != null)
        {
            rt.anchoredPosition3D = new Vector3((pos.x - 0.5f) * UIMgr.SCREEN_WIDTH, (pos.y - 0.5f) * UIMgr.SCREEN_HEIGHT, 0);      
        }
           
    }

    void InitCom()
    {
        if (bInited) return;

        functionImg = item.Find("effect/function").GetComponent<Image>();
        missGo = item.Find("effect/MISS").gameObject;
        dodgeGo = item.Find("effect/DODGE").gameObject;
        shieldGo = item.Find("effect/Shield").gameObject;
        shieldNumText = item.Find("effect/Shield/hurt").GetComponent<Text>();
        rt = GetComponent<RectTransform>();
        mAnim = GetComponent<Animator>();

        bInited = true;
    }
}
