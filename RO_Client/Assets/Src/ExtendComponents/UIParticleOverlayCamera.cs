using UnityEngine;

namespace UIExtensions
{
    [ExecuteInEditMode]
    public class UIParticleOverlayCamera : MonoBehaviour
    {
        private Camera m_Camera;

        private static UIParticleOverlayCamera s_Instance;

        public static UIParticleOverlayCamera instance
        {
            get
            {
                if ((object)s_Instance == null)
                {
                    s_Instance = (Object.FindObjectOfType<UIParticleOverlayCamera>() ?? new GameObject(typeof(UIParticleOverlayCamera).Name, typeof(UIParticleOverlayCamera)).GetComponent<UIParticleOverlayCamera>());
                    s_Instance.gameObject.SetActive(value: true);
                    s_Instance.enabled = true;
                }
                return s_Instance;
            }
        }

        private Camera cameraForOvrelay
        {
            get
            {
                if (!m_Camera)
                {
                    if (!(m_Camera = GetComponent<Camera>()))
                    {
                        return m_Camera = base.gameObject.AddComponent<Camera>();
                    }
                    return m_Camera;
                }
                return m_Camera;
            }
        }

        public static Camera GetCameraForOvrelay(Canvas canvas)
        {
            UIParticleOverlayCamera instance = UIParticleOverlayCamera.instance;
            RectTransform rectTransform = canvas.rootCanvas.transform as RectTransform;
            Camera cameraForOvrelay = instance.cameraForOvrelay;
            Transform transform = instance.transform;
            cameraForOvrelay.enabled = false;
            Vector3 localPosition = rectTransform.localPosition;
            cameraForOvrelay.orthographic = true;
            cameraForOvrelay.orthographicSize = Mathf.Max(localPosition.x, localPosition.y);
            cameraForOvrelay.nearClipPlane = 0.3f;
            cameraForOvrelay.farClipPlane = 1000f;
            localPosition.z -= 100f;
            transform.localPosition = localPosition;
            return cameraForOvrelay;
        }

        private void Awake()
        {
            if (s_Instance == null)
            {
                s_Instance = GetComponent<UIParticleOverlayCamera>();
            }
            else if (s_Instance != this)
            {
                Debug.LogWarning("Multiple " + typeof(UIParticleOverlayCamera).Name + " in scene.", base.gameObject);
                base.enabled = false;
                Object.Destroy(base.gameObject);
                return;
            }
            cameraForOvrelay.enabled = false;
            if (Application.isPlaying)
            {
                Object.DontDestroyOnLoad(base.gameObject);
            }
        }

        private void OnDestroy()
        {
            if (s_Instance == this)
            {
                s_Instance = null;
            }
        }
    }
}
