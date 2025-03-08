using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Text;

public  class CombineSkinnedMeshes : MonoBehaviour
{
    public Transform[] DontCombineRender;

    /// <summary>
    /// 是否启用合并网格
    /// </summary>
    public bool EnableCombined = false;

    /// <summary>
    /// 是否启用离屏更新
    /// </summary>
    public bool EnableUpdateWhenOffscreen = false;

    Material mMat = null;

    Vector3 mOrgPos = Vector3.zero;

    Quaternion mOrgRot = Quaternion.identity;

    SkinnedMeshRenderer mSMR = null;

	Mesh mNormalMesh = null;

	Mesh mHidedWeaponMesh = null;

    public SkinQuality skinQuality = SkinQuality.Auto;

    void Awake()
    {
        mOrgPos = transform.localPosition;
        mOrgRot = transform.localRotation;
        mSMR = GetComponent<SkinnedMeshRenderer>();
#if UNITY_INSTANTGAME
        return;
#else
        if (EnableCombined)
            CombineToMesh();
#endif
    }

	void Start()
	{
        if (mSMR != null)
            SetMat();
    }

	void OnDestroy()
	{
		if (mNormalMesh) {
			mNormalMesh.Destroy ();
			mNormalMesh = null;
		}

		if (mHidedWeaponMesh) {
			mHidedWeaponMesh.Destroy ();
			mHidedWeaponMesh = null;
		}

        DontCombineRender = null;
    }

    public SkinnedMeshRenderer GetRenderer()
    { 
        return mSMR;
    }

    /// <summary>
    /// 模型处理函数
    /// </summary>
    void CombineToMesh()
    {
		List<CombineInstance> combineInstances = new List<CombineInstance>();
		List<Transform> bones = new List<Transform>();
		SkinnedMeshRenderer[] smrList = GetComponentsInChildren<SkinnedMeshRenderer>();
        if (DontCombineRender != null && DontCombineRender.Length > 0)
        {
            List<SkinnedMeshRenderer> tempList = new List<SkinnedMeshRenderer>(smrList.Length);
            tempList.AddRange(smrList);
            for (int idx = 0; idx < DontCombineRender.Length; idx++)
            {
                for (int jdx = 0; jdx < tempList.Count; jdx++)
                {
                    if (tempList[jdx] == null || tempList[jdx].transform == DontCombineRender[idx])
                    {
                        tempList.RemoveAt(jdx);
                        break;
                    }
                }  
            }
            smrList = tempList.ToArray();

        }

        for (int idx = 0; idx < smrList.Length; idx++)
        {
            SkinnedMeshRenderer smr = smrList[idx];
            if (mMat == null)
                mMat = smr.material;

            Mesh mesh = smr.sharedMesh;
			if (mesh == null)
				continue;

            CombineInstance ci = new CombineInstance();
            ci.mesh = mesh;
            ci.subMeshIndex = 0;
            combineInstances.Add(ci);
           
            bones.AddRange(smr.bones);
            Object.Destroy(smr.gameObject);  
        }

        if(mSMR == null)
            mSMR = gameObject.AddComponent<SkinnedMeshRenderer>();
		mNormalMesh = new Mesh ();
		mNormalMesh.CombineMeshes(combineInstances.ToArray(), true, false);

        mSMR.quality = skinQuality;
        mSMR.sharedMesh = mNormalMesh;
        mSMR.bones = bones.ToArray();
        if (EnableUpdateWhenOffscreen)
            mSMR.updateWhenOffscreen = EnableUpdateWhenOffscreen;

        Bounds bounds = mSMR.localBounds;
        bounds.center = new Vector3(0, 0.5f, 0);
        bounds.extents = Vector3.one;
        mSMR.localBounds = bounds;

        for (int idx = 0; idx < smrList.Length; idx++)
        {
            SkinnedMeshRenderer mr = smrList[idx];
            Resources.UnloadAsset(mr.sharedMesh);
            mr.sharedMesh = null;
        }
    }

    void SetMat()
    {
        mSMR.material = mMat;
    }
}
