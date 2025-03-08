using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using UnityEngine.Video;
using LuaInterface;

[RequireComponent(typeof(RawImage))]
[RequireComponent(typeof(VideoPlayer))]
public class UIPlayVideo : UIBehaviour
{
    private RawImage m_RawImage;
    private VideoPlayer m_VideoPlayer;
    private LuaTable m_Owner;
    private LuaFunction m_OwnerCB;

    protected override void Awake() {
        m_RawImage = GetComponent<RawImage>();
        m_VideoPlayer = GetComponent<VideoPlayer>();
    }

    protected override void OnEnable() {
        m_VideoPlayer.started += OnStarted;
        m_VideoPlayer.errorReceived += OnErrorReceived;
        m_VideoPlayer.loopPointReached += OnLoopPointReached;
        m_RawImage.texture = null;
    }

    protected override void OnDisable() {
        m_VideoPlayer.started -= OnStarted;
        m_VideoPlayer.errorReceived -= OnErrorReceived;
        m_VideoPlayer.loopPointReached -= OnLoopPointReached;
        m_RawImage.texture = null;
    }

    protected override void OnRectTransformDimensionsChange()
    {
        base.OnRectTransformDimensionsChange();
        if (!IsActive()) return;
        if (m_RawImage && m_RawImage.texture)
        {
            ResetSize();
        }
    }

    private void ResetSize()
    {
        RectTransform parent = (RectTransform)(transform.parent);
        if (parent)
        {
            Vector2 size = parent.rect.size;
            int textureW = m_RawImage.texture.width;
            int textureH = m_RawImage.texture.height;
            float scaleW = size.x / textureW;
            float scaleH = size.y / textureH;
            if (scaleW < scaleH)
            {
                size.y = scaleW * textureH;
            }
            else if (scaleW > scaleH)
            {
                size.x = scaleH * textureW;
            }
            RectTransform rectTransform = (RectTransform)transform;
            rectTransform.sizeDelta = size;
        }
    }

    private void OnStarted(VideoPlayer source)
    {
        if (m_VideoPlayer.texture != null)
        {
            m_RawImage.texture = m_VideoPlayer.texture;
            ResetSize();
        }
    }

    private void OnErrorReceived(VideoPlayer source, string message)
    {
        Debug.LogError(message);
        Complete(1);
    }

    private void OnLoopPointReached(VideoPlayer source)
    {
        Complete(0);
    }

    private void Complete(int errorCode)
    {
        if (m_OwnerCB != null)
        {
            if (m_Owner != null)
            {
                m_OwnerCB.Call(m_Owner, errorCode);
            }
            else
            {
                m_OwnerCB.Call(errorCode);
            }
        }
    }

    public void BindLuaCallBack(LuaTable owner, LuaFunction ownerCB)
    {
        m_Owner = owner;
        m_OwnerCB = ownerCB;
    }

    public void Play(string path)
    {
        m_VideoPlayer.url = path;
        m_VideoPlayer.Stop();
        m_VideoPlayer.Play();
    }
}
