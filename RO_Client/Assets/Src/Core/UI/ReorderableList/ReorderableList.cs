using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.UI;

namespace RO
{
    [RequireComponent(typeof(RectTransform)), DisallowMultipleComponent]
    public class ReorderableList : MonoBehaviour
    {
        [Tooltip("Child container with re-orderable items in a layout group")]
        public LayoutGroup ContentLayout;
        [Tooltip("Parent area to draw the dragged element on top of containers. Defaults to the root Canvas")]
        public RectTransform DraggableArea;

        [Tooltip("Can items be dragged from the container?")]
        public bool IsDraggable = true;
        [Tooltip("Should the draggable components be removed or cloned?")]
        public bool CloneDraggedObject = false;

        [Tooltip("Can new draggable items be dropped in to the container?")]
        public bool IsDropable = true;


        [Header("UI Re-orderable Events")]
        public ReorderableListHandler OnElementDropped = new ReorderableListHandler();
        public ReorderableListHandler OnElementGrabbed = new ReorderableListHandler();
        public ReorderableListHandler OnElementRemoved = new ReorderableListHandler();
        public ReorderableListHandler OnElementSiblingChanged = new ReorderableListHandler();
        public UnityEvent OnElementEndDrag = new UnityEvent();

        private RectTransform m_Content;
        private ReorderableListContent m_ListContent;
        private Canvas m_Canvas;
        private bool m_IsDragging = false;

        public RectTransform Content
        {
            get
            {
                if (m_Content == null)
                {
                    m_Content = ContentLayout.GetComponent<RectTransform>();
                }
                return m_Content;
            }
        }

        public Canvas GetCanvas()
        {
            return m_Canvas;
        }

        /// <summary>
        /// 该参数是用来内部判断多点击的
        /// </summary>
        /// <value></value>
        public bool isDragging
        {
            get { return m_IsDragging; }
            set { m_IsDragging = value; }
        }

        private void Awake()
        {

            if (ContentLayout == null)
            {
                Debug.LogError("You need to have a child LayoutGroup content set for the list: " + name, gameObject);
                return;
            }
            if (DraggableArea == null)
            {
                DraggableArea = transform.root.GetComponentInChildren<Canvas>().GetComponent<RectTransform>();
            }
            // if (IsDropable && !GetComponent<Graphic>())
            // {
            //     Debug.LogError("You need to have a Graphic control (such as an Image) for the list [" + name + "] to be droppable", gameObject);
            //     return;
            // }

            m_ListContent = ContentLayout.gameObject.AddComponent<ReorderableListContent>();
            m_ListContent.Init(this);
        }

        private void OnEnable()
        {
            if (m_Canvas == null)
            {
                CacheCanvas();
            }
        }

        private void OnTransformParentChanged()
        {
            m_Canvas = null;
            if (isActiveAndEnabled)
            {
                CacheCanvas();
            }
        }

        private void OnCanvasHierarchyChanged()
        {
            m_Canvas = null;
            if (isActiveAndEnabled)
            {
                CacheCanvas();
            }
        }

        private void CacheCanvas()
        {
            List<Canvas> list = new List<Canvas>();
            base.gameObject.GetComponentsInParent(false, list);
            if (list.Count > 0)
            {
                int num = 0;
                while (num < list.Count)
                {
                    if (!list[num].isActiveAndEnabled)
                    {
                        num++;
                        continue;
                    }
                    m_Canvas = list[num];
                    break;
                }
            }
            else
            {
                m_Canvas = null;
            }
        }

        #region Nested type: ReorderableListEventStruct

        [Serializable]
        public struct ReorderableListEventStruct
        {
            public GameObject DroppedObject;
            public int FromIndex;
            public ReorderableList FromList;
            public bool IsAClone;
            public GameObject SourceObject;
            public int ToIndex;
            public ReorderableList ToList;
        }

        #endregion

        #region Nested type: ReorderableListHandler

        [Serializable]
        public class ReorderableListHandler : UnityEvent<ReorderableListEventStruct>
        {
        }

        public void TestReOrderableListTarget(ReorderableListEventStruct item)
        {
            Debug.Log("Event Received");
            Debug.Log("Hello World, is my item a clone? [" + item.IsAClone + "]");
        }

        #endregion
    }
}