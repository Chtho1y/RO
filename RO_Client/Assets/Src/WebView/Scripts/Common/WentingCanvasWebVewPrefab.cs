using System;
using UnityEngine;
using UnityEngine.UI;

namespace Vuplex.WebView
{
    public class WentingCanvasWebVewPrefab : BaseWebViewPrefab
    {
        private float m_InitialResolution = 1;
        private float m_ScrollingSensitivity = 15;
        private float m_RenderImageScale = 1;

        RectTransform m_CachedRectTransform;
        RectTransform cachedRectTransform
        {
            get
            {
                if (m_CachedRectTransform == null)
                {
                    m_CachedRectTransform = GetComponent<RectTransform>();
                }
                return m_CachedRectTransform;
            }
        }

        protected override Vector2 _convertRatioPointToUnityUnits(Vector2 point)
        {
            // Use Vector2.Scale() because Vector2 * Vector2 isn't supported in Unity 2017.
            return Vector2.Scale(point, cachedRectTransform.rect.size * m_RenderImageScale);
        }

        protected override float _getInitialResolution()
        {
            return m_InitialResolution;
        }

        protected override float _getScrollingSensitivity()
        {
            return m_ScrollingSensitivity;
        }

        protected override ViewportMaterialView _getVideoLayer()
        {
            return transform.Find("VideoLayer").GetComponent<ViewportMaterialView>();
        }

        protected override ViewportMaterialView _getView()
        {
            return transform.Find("CanvasWebViewPrefabView").GetComponent<ViewportMaterialView>();
        }

        protected override void _setVideoLayerPosition(Rect videoRect)
        {
            var videoRectTransform = _videoLayer.transform as RectTransform;
            // Use Vector2.Scale() because Vector2 * Vector2 isn't supported in Unity 2017.
            videoRectTransform.anchoredPosition = Vector2.Scale(Vector2.Scale(videoRect.position, cachedRectTransform.rect.size), new Vector2(1, -1));
            videoRectTransform.sizeDelta = Vector2.Scale(videoRect.size, cachedRectTransform.rect.size);
        }

        public float ScrollingSensitivity
        {
            get { return m_ScrollingSensitivity; }
            set { m_ScrollingSensitivity = value; }
        }

        public float RenderImageScale
        {
            get { return m_RenderImageScale; }
            set
            {
                value = Mathf.Max(value, 0.01f);
                if (Mathf.Approximately(m_RenderImageScale, value))
                    return;
                m_RenderImageScale = value;
                ResetSize();
            }
        }

        public void Init(float initialResolution, float scrollingSensitivity, float renderImageScale, WebViewOptions options = new WebViewOptions(), IWebView initializedWebView = null)
        {
            if (_webView != null)
            {
                Debug.LogError("RoCanvasWebVewPrefab.Init method can be called only once.");
                return;
            }
            m_InitialResolution = initialResolution;
            m_ScrollingSensitivity = scrollingSensitivity;
            m_RenderImageScale = Mathf.Max(renderImageScale, 0.01f);
            var rect = cachedRectTransform.rect;
            _init(rect.width * m_RenderImageScale, rect.height * m_RenderImageScale, options, initializedWebView);
        }
        
        public void ResetSize()
        {
            if (_webView == null) return;
            var rect = cachedRectTransform.rect;
            rect.width = rect.width * m_RenderImageScale;
            rect.height = rect.height * m_RenderImageScale;
            var size = _webView.Size;
            if (!(rect.width == size.x && rect.height == size.y))
            {
                _webView.Resize(rect.width, rect.height);
            }
        }
    }
}