using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

namespace RO
{
    [RequireComponent(typeof(RectTransform))]
    public class ReorderableListElement : MonoBehaviour, IDragHandler, IBeginDragHandler, IEndDragHandler
    {
        private readonly List<RaycastResult> m_RaycastResults = new List<RaycastResult>();
        private ReorderableList m_CurrentReorderableListRaycasted;
        private RectTransform m_DraggingObject;
        private LayoutElement m_DraggingObjectLE;
        private Vector2 m_DraggingObjectOriginalSize;
        private Vector3 m_DraggingObjectOffset;
        private RectTransform m_FakeElement;
        private LayoutElement m_FakeElementLE;
        private int m_FromIndex;
        private bool m_IsDragging;
        private RectTransform m_Rect;
        private ReorderableList m_ReorderableList;

        private int m_VaildPointerHashCode = 0;

        #region IBeginDragHandler Members

        public void OnBeginDrag(PointerEventData eventData)
        {
            if (m_ReorderableList == null)
                return;

            //Can't drag, return...
            if (!m_ReorderableList.IsDraggable)
            {
                m_DraggingObject = null;
                return;
            }

            if (m_ReorderableList.isDragging) return;
            m_ReorderableList.isDragging = true;
            m_VaildPointerHashCode = eventData.GetHashCode();

            int indexSibling = m_Rect.GetSiblingIndex();
            Vector3 position = m_Rect.position;

            //If CloneDraggedObject  just set draggingObject to this gameobject
            if (m_ReorderableList.CloneDraggedObject == false)
            {
                m_DraggingObject = m_Rect;
                m_FromIndex = m_Rect.GetSiblingIndex();
                //Send OnElementRemoved Event
                if (m_ReorderableList.OnElementRemoved != null)
                {
                    m_ReorderableList.OnElementRemoved.Invoke(new ReorderableList.ReorderableListEventStruct
                    {
                        DroppedObject = m_DraggingObject.gameObject,
                        IsAClone = m_ReorderableList.CloneDraggedObject,
                        SourceObject = m_ReorderableList.CloneDraggedObject ? gameObject : m_DraggingObject.gameObject,
                        FromList = m_ReorderableList,
                        FromIndex = m_FromIndex,
                    });
                }
            }
            //Else Duplicate
            else
            {
                GameObject clone = (GameObject)Instantiate(gameObject);
                m_DraggingObject = clone.GetComponent<RectTransform>();
            }

            if (m_ReorderableList.ContentLayout is SlideHorizontalOrVerticalLayoutGroup)
            {
                (m_ReorderableList.ContentLayout as SlideHorizontalOrVerticalLayoutGroup).snapEnable = true;
            }

            //Put _dragging object into the draggin area
            m_DraggingObjectOriginalSize = gameObject.GetComponent<RectTransform>().rect.size;
            m_DraggingObjectLE = m_DraggingObject.GetComponent<LayoutElement>();
            m_DraggingObject.SetParent(m_ReorderableList.DraggableArea);
            m_DraggingObject.SetAsLastSibling();

            //Create a fake element for previewing placement
            m_FakeElement = new GameObject("Fake").AddComponent<RectTransform>();
            m_FakeElementLE = m_FakeElement.gameObject.AddComponent<LayoutElement>();

            RefreshSizes();

            if (m_ReorderableList.CloneDraggedObject == false)
            {
                m_FakeElement.SetParent(m_ReorderableList.Content, false);
                m_FakeElement.position = position;
                m_FakeElement.SetSiblingIndex(indexSibling);
            }

            //Send OnElementGrabbed Event
            if (m_ReorderableList.OnElementGrabbed != null)
            {
                m_ReorderableList.OnElementGrabbed.Invoke(new ReorderableList.ReorderableListEventStruct
                {
                    DroppedObject = m_DraggingObject.gameObject,
                    IsAClone = m_ReorderableList.CloneDraggedObject,
                    SourceObject = m_ReorderableList.CloneDraggedObject ? gameObject : m_DraggingObject.gameObject,
                    FromList = m_ReorderableList,
                    FromIndex = m_FromIndex,
                });
            }

            m_IsDragging = true;

            Vector3 pointWorldPos;
            Canvas canvas = m_ReorderableList.GetCanvas();
            Camera camera = null;
            if (canvas)
            {
                camera = canvas.worldCamera;
            }
            RectTransformUtility.ScreenPointToWorldPointInRectangle(m_ReorderableList.DraggableArea, eventData.position, camera, out pointWorldPos);
            m_DraggingObjectOffset = m_DraggingObject.position - pointWorldPos;
        }

        #endregion

        #region IDragHandler Members

        public void OnDrag(PointerEventData eventData)
        {
            if (!m_IsDragging)
                return;
            if (m_VaildPointerHashCode != eventData.GetHashCode())
                return;

            //Set dragging object on cursor
            Vector3 pointWorldPos;
            Canvas canvas = m_ReorderableList.GetCanvas();
            Camera camera = null;
            if (canvas)
            {
                camera = canvas.worldCamera;
            }
            RectTransformUtility.ScreenPointToWorldPointInRectangle(m_ReorderableList.DraggableArea, eventData.position, camera, out pointWorldPos);
            m_DraggingObject.position = pointWorldPos + m_DraggingObjectOffset;

            //Check everything under the cursor to find a ReorderableList
            EventSystem.current.RaycastAll(eventData, m_RaycastResults);
            for (int i = 0; i < m_RaycastResults.Count; i++)
            {
                m_CurrentReorderableListRaycasted = m_RaycastResults[i].gameObject.GetComponent<ReorderableList>();
                if (m_CurrentReorderableListRaycasted != null)
                {
                    break;
                }
                m_CurrentReorderableListRaycasted = m_RaycastResults[i].gameObject.GetComponentInParent<ReorderableList>();
                if (m_CurrentReorderableListRaycasted != null)
                {
                    break;
                }
            }
            if (m_CurrentReorderableListRaycasted == null)
            {
                Vector3 pointLocalPos = m_ReorderableList.DraggableArea.InverseTransformPoint(pointWorldPos);
                if (m_ReorderableList.DraggableArea.rect.Contains(pointLocalPos))
                {
                    m_CurrentReorderableListRaycasted = m_ReorderableList;
                }
            }

            //If nothing found or the list is not dropable, put the fake element outsite
            if (m_CurrentReorderableListRaycasted == null || m_CurrentReorderableListRaycasted.IsDropable == false)
            {
                RefreshSizes();
                m_FakeElement.transform.SetParent(m_ReorderableList.DraggableArea, false);
            }
            //Else find the best position on the list and put fake element on the right index  
            else
            {
                if (m_FakeElement.parent != m_CurrentReorderableListRaycasted)
                    m_FakeElement.SetParent(m_CurrentReorderableListRaycasted.Content, false);

                float minDistance = float.PositiveInfinity;
                int targetIndex = 0;
                float dist = 0;
                bool isVertical = (m_CurrentReorderableListRaycasted.ContentLayout is VerticalLayoutGroup
                                || m_CurrentReorderableListRaycasted.ContentLayout is GridLayoutGroup
                                || m_CurrentReorderableListRaycasted.ContentLayout is SlideVerticalLayoutGroup);
                bool isHorizontal = (m_CurrentReorderableListRaycasted.ContentLayout is HorizontalLayoutGroup
                                || m_CurrentReorderableListRaycasted.ContentLayout is GridLayoutGroup
                                || m_CurrentReorderableListRaycasted.ContentLayout is SlideHorizontalLayoutGroup);
                bool isSlide = (m_CurrentReorderableListRaycasted.ContentLayout is SlideHorizontalOrVerticalLayoutGroup);
                Dictionary<Transform, Vector3> slideTargetPosDic = null;
                Vector2 offset = Vector2.zero;
                Vector2 localPoint = m_CurrentReorderableListRaycasted.Content.InverseTransformPoint(pointWorldPos);
                if (isSlide)
                {
                    slideTargetPosDic = (m_CurrentReorderableListRaycasted.ContentLayout as SlideHorizontalOrVerticalLayoutGroup).slideTargePosDic;
                    offset = m_CurrentReorderableListRaycasted.Content.rect.position;
                }

                for (int j = 0; j < m_CurrentReorderableListRaycasted.Content.childCount; j++)
                {
                    var c = m_CurrentReorderableListRaycasted.Content.GetChild(j).GetComponent<RectTransform>();
                    if (!c.gameObject.activeSelf) continue;
                    Vector3 position;
                    if (isSlide)
                    {
                        if (slideTargetPosDic.ContainsKey(c))
                        {
                            position = slideTargetPosDic[c];
                            if (isHorizontal) position.x += offset.x;
                            if (isVertical) position.y += offset.y;
                        }
                        else
                        {
                            position = c.localPosition;
                        }
                    }
                    else
                    {
                        position = c.localPosition;
                    }
                    dist = 0;
                    if (isVertical)
                    {
                        dist += Mathf.Abs(position.y - localPoint.y);
                    }
                    if (isHorizontal)
                    {
                        dist += Mathf.Abs(position.x - localPoint.x);
                    }

                    if (dist < minDistance)
                    {
                        minDistance = dist;
                        targetIndex = j;
                    }
                }

                RefreshSizes();
                int siblingIndex = m_FakeElement.GetSiblingIndex();
                if (siblingIndex != targetIndex)
                {
                    m_FakeElement.SetSiblingIndex(targetIndex);
                    if (m_ReorderableList.OnElementSiblingChanged != null)
                    {
                        m_ReorderableList.OnElementSiblingChanged.Invoke(new ReorderableList.ReorderableListEventStruct
                        {
                            DroppedObject = m_DraggingObject.gameObject,
                            IsAClone = m_ReorderableList.CloneDraggedObject,
                            SourceObject = m_ReorderableList.CloneDraggedObject ? gameObject : m_DraggingObject.gameObject,
                            FromList = m_ReorderableList,
                            FromIndex = m_FromIndex,
                            ToList = m_CurrentReorderableListRaycasted,
                            ToIndex = targetIndex
                        });
                    }
                }
                m_FakeElement.gameObject.SetActive(true);
            }
        }

        #endregion

        #region IEndDragHandler Members

        public void OnEndDrag(PointerEventData eventData)
        {
            if (m_VaildPointerHashCode != eventData.GetHashCode())
                return;
            m_IsDragging = false;

            if (m_DraggingObject != null)
            {
                //If we have a, ReorderableList that is dropable
                //Put the dragged object into the content and at the right index
                if (m_CurrentReorderableListRaycasted != null && m_CurrentReorderableListRaycasted.IsDropable)
                {
                    RefreshSizes();
                    m_DraggingObject.SetParent(m_CurrentReorderableListRaycasted.Content, false);

                    int siblingIndex = m_FakeElement.GetSiblingIndex();
                    m_DraggingObject.SetSiblingIndex(siblingIndex);

                    //Send OnelementDropped Event
                    if (m_ReorderableList.OnElementDropped != null)
                    {
                        m_ReorderableList.OnElementDropped.Invoke(new ReorderableList.ReorderableListEventStruct
                        {
                            DroppedObject = m_DraggingObject.gameObject,
                            IsAClone = m_ReorderableList.CloneDraggedObject,
                            SourceObject = m_ReorderableList.CloneDraggedObject ? gameObject : m_DraggingObject.gameObject,
                            FromList = m_ReorderableList,
                            FromIndex = m_FromIndex,
                            ToList = m_CurrentReorderableListRaycasted,
                            ToIndex = siblingIndex
                        });
                    }
                }
                //We don't have an ReorderableList
                else
                {
                    //If it's a clone, delete it
                    if (m_ReorderableList.CloneDraggedObject)
                    {
                        Destroy(m_DraggingObject.gameObject);
                    }
                    //Else replace the draggedObject to his first place
                    else
                    {
                        RefreshSizes();
                        m_DraggingObject.SetParent(m_ReorderableList.Content, false);
                        m_DraggingObject.SetSiblingIndex(m_FromIndex);
                    }
                }
            }

            //Delete fake element
            if (m_FakeElement != null)
                Destroy(m_FakeElement.gameObject);
            if (m_ReorderableList.ContentLayout is SlideHorizontalOrVerticalLayoutGroup)
            {
                (m_ReorderableList.ContentLayout as SlideHorizontalOrVerticalLayoutGroup).snapEnable = false;
            }
            if (m_ReorderableList.OnElementEndDrag != null)
            {
                m_ReorderableList.OnElementEndDrag.Invoke();
            }

            m_ReorderableList.isDragging = false;
        }

        #endregion

        private void RefreshSizes()
        {
            Vector2 size = m_DraggingObjectOriginalSize;

            if (m_CurrentReorderableListRaycasted != null && m_CurrentReorderableListRaycasted.IsDropable && m_CurrentReorderableListRaycasted.Content.childCount > 0)
            {
                var firstChild = m_CurrentReorderableListRaycasted.Content.GetChild(0);
                if (firstChild != null)
                {
                    size = firstChild.GetComponent<RectTransform>().rect.size;
                }
            }

            m_DraggingObject.sizeDelta = size;
            m_FakeElement.sizeDelta = size;
            m_FakeElementLE.preferredHeight = m_DraggingObjectLE.preferredHeight = size.y;
            m_FakeElementLE.preferredWidth = m_DraggingObjectLE.preferredWidth = size.x;
        }

        public void Init(ReorderableList reorderableList)
        {
            m_ReorderableList = reorderableList;
            m_Rect = GetComponent<RectTransform>();
        }
    }
}