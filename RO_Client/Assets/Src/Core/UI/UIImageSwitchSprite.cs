using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[RequireComponent(typeof(Image))]
public class UIImageSwitchSprite : MonoBehaviour
{
    [SerializeField]
    private Sprite[] m_Sprites;

    private Image m_Image;

    private void Awake()
    {
        m_Image = GetComponent<Image>();
    }

    public void ChangeSprite(string spriteName)
    {
        if (m_Sprites == null || string.IsNullOrEmpty(spriteName)) return;

        for(int idx =0; idx < m_Sprites.Length;idx++)
        {
            if (m_Sprites[idx] != null && m_Sprites[idx].name == spriteName)
                m_Image.sprite = m_Sprites[idx];
        }
    }

    public void ChangeSprite(int spriteIdx)
    {
        if (m_Sprites == null) return;
        if (m_Sprites[spriteIdx] == null) return;
        m_Image.sprite = m_Sprites[spriteIdx];
    }
}
