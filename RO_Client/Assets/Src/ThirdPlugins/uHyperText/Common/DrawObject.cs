using UnityEngine;
using UnityEngine.UI;
using System;
using UnityEngine.Events;
using System.Collections.Generic;

namespace WXB
{
    [RequireComponent(typeof(RectTransform))]
    [RequireComponent(typeof(CanvasRenderer))]
    [ExecuteInEditMode]
    public class DrawObject : MonoBehaviour, Draw, IClippable, ICanvasElement
    {
        private RectMask2D m_ParentMask;
        [Serializable]
        public class CullStateChangedEvent : UnityEvent<bool> { }

        // Event delegates triggered on click. 
        [SerializeField]
        private CullStateChangedEvent m_OnCullStateChanged = new CullStateChangedEvent();

        /// <summary>
        /// Callback issued when culling changes.
        /// </summary>
        /// <remarks>
        /// Called whene the culling state of this MaskableGraphic either becomes culled or visible. You can use this to control other elements of your UI as culling happens.
        /// </remarks>
        public CullStateChangedEvent onCullStateChanged
        {
            get { return m_OnCullStateChanged; }
            set { m_OnCullStateChanged = value; }
        }

        private Canvas m_Canvas;

        /// <summary>
        /// A reference to the Canvas this Graphic is rendering to.
        /// </summary>
        /// <remarks>
        /// In the situation where the Graphic is used in a hierarchy with multiple Canvases, the Canvas closest to the root will be used.
        /// </remarks>
        public Canvas canvas
        {
            get
            {
                if (m_Canvas == null)
                    CacheCanvas();
                return m_Canvas;
            }
        }

        private void CacheCanvas()
        {
            var list = ListPool<Canvas>.Get();
            gameObject.GetComponentsInParent(false, list);
            if (list.Count > 0)
            {
                // Find the first active and enabled canvas.
                for (int i = 0; i < list.Count; ++i)
                {
                    if (list[i].isActiveAndEnabled)
                    {
                        m_Canvas = list[i];
                        break;
                    }
                }
            }
            else
            {
                m_Canvas = null;
            }

            ListPool<Canvas>.Release(list);
        }

        readonly Vector3[] m_Corners = new Vector3[4];
        private Rect rootCanvasRect
        {
            get
            {
                if (rectTransform == null)
                {
                    return new Rect(Vector2.zero, Vector2.zero);
                }
                rectTransform.GetWorldCorners(m_Corners);

                if (canvas)
                {
                    Matrix4x4 mat = canvas.rootCanvas.transform.worldToLocalMatrix;
                    for (int i = 0; i < 4; ++i)
                        m_Corners[i] = mat.MultiplyPoint(m_Corners[i]);
                }

                // bounding box is now based on the min and max of all corners (case 1013182)

                Vector2 min = m_Corners[0];
                Vector2 max = m_Corners[0];
                for (int i = 1; i < 4; i++)
                {
                    min.x = Mathf.Min(m_Corners[i].x, min.x);
                    min.y = Mathf.Min(m_Corners[i].y, min.y);
                    max.x = Mathf.Max(m_Corners[i].x, max.x);
                    max.y = Mathf.Max(m_Corners[i].y, max.y);
                }

                return new Rect(min, max - min);
            }
        }

        protected virtual void OnTransformParentChanged()
        {
            if (!isActiveAndEnabled)
                return;

            UpdateRect(Vector2.zero);
            UpdateClipParent();
        }

        protected virtual void OnDisable()
        {
            if (canvasRenderer == null)
                return;

            canvasRenderer.Clear();
            UpdateClipParent();
        }

        protected void OnEnable()
        {
            UpdateRect(Vector2.zero);
            UpdateClipParent();
        }

        public void OnInit()
        {
            enabled = true;
            UpdateRect(Vector2.zero);
        }

        protected void Start()
        {
            UpdateRect(Vector2.zero);
        }

        protected virtual void Init()
        {

        }

        protected void Awake()
        {
            canvasRenderer = GetComponent<CanvasRenderer>();
            rectTransform = GetComponent<RectTransform>();
            Init();
        }

        public RectTransform rectTransform { get; private set; }

        public virtual DrawType type { get { return DrawType.Default; } }
        public virtual long key { get; set; }

        public CanvasRenderer canvasRenderer
        {
            get;
            private set;
        }

        protected void UpdateRect(Vector2 offset)
        {
            Tools.UpdateRect(rectTransform, offset);
        }

        public virtual void UpdateSelf(float deltaTime)
        {

        }

        Material m_Material;
        Texture m_Texture;

        public Material srcMat { get { return m_Material; } set { m_Material = value; } }

        public Texture texture
        {
            get { return m_Texture; }
            set { m_Texture = value; }
        }

        public void FillMesh(Mesh workerMesh)
        {
            canvasRenderer.SetMesh(workerMesh);
        }

        public virtual void UpdateMaterial(Material mat)
        {
            canvasRenderer.materialCount = 1;
            canvasRenderer.SetMaterial(mat, 0);
            canvasRenderer.SetTexture(m_Texture);
        }

        public virtual void Release()
        {
            m_Material = null;
            m_Texture = null;
            key = 0;
            if (canvasRenderer != null)
            {
                canvasRenderer.Clear();
            }
        }

        public void DestroySelf()
        {
            Tools.Destroy(gameObject);
        }

        private void UpdateClipParent()
        {
            var newParent = MaskUtilities.GetRectMaskForClippable(this);

            // if the new parent is different OR is now inactive
            if (m_ParentMask != null && (newParent != m_ParentMask || !newParent.IsActive()))
            {
                m_ParentMask.RemoveClippable(this);
                UpdateCull(false);
            }

            // don't re-add it if the newparent is inactive
            if (newParent != null && newParent.IsActive())
                newParent.AddClippable(this);

            m_ParentMask = newParent;
        }

        /// <summary>
        /// See IClippable.RecalculateClipping
        /// </summary>
        public virtual void RecalculateClipping()
        {
            UpdateClipParent();
        }

        /// <summary>
        /// See IClippable.Cull
        /// </summary>
        public virtual void Cull(Rect clipRect, bool validRect)
        {
            var cull = !validRect || !clipRect.Overlaps(rootCanvasRect, true);
            UpdateCull(cull);
        }

        private void UpdateCull(bool cull)
        {
            if (canvasRenderer == null) return;

            if (canvasRenderer.cull != cull)
            {
                canvasRenderer.cull = cull;
                UISystemProfilerApi.AddMarker("MaskableGraphic.cullingChanged", this);
                m_OnCullStateChanged.Invoke(cull);
                //OnCullingChanged();
                if (!canvasRenderer.cull && !CanvasUpdateRegistry.IsRebuildingGraphics() && !CanvasUpdateRegistry.IsRebuildingLayout())
                {
                    /// When we were culled, we potentially skipped calls to <c>Rebuild</c>.
                    CanvasUpdateRegistry.RegisterCanvasElementForGraphicRebuild(this);
                }
            }
        }

        /// <summary>
        /// See IClippable.SetClipRect
        /// </summary>
        public virtual void SetClipRect(Rect clipRect, bool validRect)
        {
            if (canvasRenderer == null) return;

            if (validRect)
                canvasRenderer.EnableRectClipping(clipRect);
            else
                canvasRenderer.DisableRectClipping();
        }

        public virtual void SetClipSoftness(Vector2 clipSoftness)
        {

        }


        public virtual void Rebuild(CanvasUpdate executing)
        {
            
        }

        public virtual void LayoutComplete()
        {
            
        }

        public virtual void GraphicUpdateComplete()
        {
           
        }

        public virtual bool IsDestroyed()
        {
            return this == null;
        }
    }
}