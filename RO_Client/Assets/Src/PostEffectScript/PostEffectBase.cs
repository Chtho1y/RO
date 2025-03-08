using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class PostEffectBase : MonoBehaviour
{
    public Shader shader = null;
    private Material _material = null;
    public Material Mat
    {
        get
        {
            if (_material == null)
                _material = GenerateMaterial(shader);

            return _material;
        }
    }

    protected Material GenerateMaterial(Shader shader)
    {
        if (shader == null) return null;

        if (shader.isSupported == false) return null;

        Material mat = new Material(shader);
        mat.hideFlags = HideFlags.DontSave;
        return mat;
    }

    // Use this for initialization
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {

    }
}
