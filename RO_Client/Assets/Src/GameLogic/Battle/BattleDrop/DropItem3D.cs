using UnityEngine;
using System.Collections;

public class DropItem3D
{
    private DropItemType itemType;
    private Vector3 bornPos;
    private float lifeTime;
    private GameObject itemGo;

    public DropItem3D(Vector3 pos,DropItemType type,int animIdx)
    {
        itemGo = ResourceMgr.Instance.GetGoFromPool(Constants.ModelPath, BattleDropMgr.drop_gold_prefab_name);
        itemType = type;
        bornPos = pos;
        lifeTime = 1.5f;
        if (itemGo != null)
        {
            itemGo.transform.SetParent(BattleDropMgr.Instance.Root.transform);
            itemGo.transform.localPosition = pos;
            itemGo.transform.localScale = new Vector3(2, 2, 2);
        }
        //PlayAnim(animIdx);
    }

    public bool IsValid(float deltatime)
    {
        if (itemGo == null) return false;

        lifeTime -= deltatime;
        return lifeTime>0;
    }

    public void Dispose()
    {
        if (itemGo != null)
        {
            ResourceMgr.Instance.RecycleGO(Constants.ModelPath, BattleDropMgr.drop_gold_prefab_name, itemGo);
            itemGo = null;
        }
    }

    void PlayAnim(int animIdx)
    {
        if (itemGo == null) return;

        Animator animator = itemGo.GetComponent<Animator>();
        if (animator == null) return;

        string animName = "Drop" + animIdx;
        animator.Play(animName);
    }
}
