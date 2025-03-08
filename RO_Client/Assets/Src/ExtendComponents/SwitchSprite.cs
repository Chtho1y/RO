using UnityEngine;
using System;
using UnityEngine.UI;

public class SwitchSprite : MonoBehaviour
{

    public Sprite[] sprites;

    private void OnDestroy()
    {
        sprites = null;
    }


    public Sprite GetSprite(string spriteName)
    {
        if (sprites == null || string.IsNullOrEmpty(spriteName)) return null;

        for(int idx =0; idx < sprites.Length;idx++)
        {
            if (sprites[idx] != null && sprites[idx].name == spriteName)
                return sprites[idx];
        }
        return null;
    }
}
