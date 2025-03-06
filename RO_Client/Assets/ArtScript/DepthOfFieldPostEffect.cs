using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class DepthOfFieldPostEffect : MonoBehaviour
{
    public Material mat;

    [Range(0.0f, 100.0f)]
    public float focalDistance = 10.0f;
    [Range(0.0f, 100.0f)]
    public float nearBlurScale = 0.0f;
    [Range(0.0f, 1000.0f)]
    public float farBlurScale = 50.0f;
    //分辨率  
    public int downSample = 1;
    //采样率  
    public int samplerScale = 1;

    private Camera mCam;
    public Camera Cam
    {
        get
        {
            if (mCam == null)
            {
                mCam = GetComponent<Camera>();
            }
            return mCam;
        }
    }

    private void OnEnable()
    {
        if(Cam != null)
        {
            Cam.depthTextureMode |= DepthTextureMode.Depth;
        }
    }

    private void OnDisable()
    {
        if(Cam != null)
        {
            Cam.depthTextureMode &= ~DepthTextureMode.Depth;
        }
    }

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if(mat!=null)
        {
            //首先将我们设置的焦点限制在远近裁剪面之间  
            Mathf.Clamp(focalDistance, Cam.nearClipPlane, Cam.farClipPlane);

            //申请两块RT，并且分辨率按照downSameple降低  
            RenderTexture temp1 = RenderTexture.GetTemporary(src.width >> downSample, src.height >> downSample, 0, src.format);
            RenderTexture temp2 = RenderTexture.GetTemporary(src.width >> downSample, src.height >> downSample, 0, src.format);

            //直接将场景图拷贝到低分辨率的RT上达到降分辨率的效果  
            Graphics.Blit(src, temp1);

            //高斯模糊，两次模糊，横向纵向，使用pass0进行高斯模糊  
            mat.SetVector("_offsets", new Vector4(0, samplerScale, 0, 0));
            Graphics.Blit(temp1, temp2, mat, 0);
            mat.SetVector("_offsets", new Vector4(samplerScale, 0, 0, 0));
            Graphics.Blit(temp2, temp1, mat, 0);

            //景深操作，景深需要两的模糊效果图我们通过_BlurTex变量传入shader  
            mat.SetTexture("_BlurTex", temp1);
            //设置shader的参数，主要是焦点和远近模糊的权重，权重可以控制插值时使用模糊图片的权重  
            mat.SetFloat("_focalDistance", FocalDistance01(focalDistance));
            mat.SetFloat("_nearBlurScale", nearBlurScale);
            mat.SetFloat("_farBlurScale", farBlurScale);

            //使用pass1进行景深效果计算，清晰场景图直接从source输入到shader的_MainTex中  
            Graphics.Blit(src, dest, mat, 1);

            //释放申请的RT  
            RenderTexture.ReleaseTemporary(temp1);
            RenderTexture.ReleaseTemporary(temp2);
        }
    }

    //计算设置的焦点被转换到01空间中的距离，以便shader中通过这个01空间的焦点距离与depth比较  
    private float FocalDistance01(float distance)
    {
        float dist = Cam.WorldToViewportPoint((distance - Cam.nearClipPlane) * Cam.transform.forward + Cam.transform.position).z / (Cam.farClipPlane - Cam.nearClipPlane);
        return dist;
    }
}
