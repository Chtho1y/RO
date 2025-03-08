using UnityEngine;
using UnityEngine.UI;
using System.Collections;
using UnityEngine.EventSystems;

namespace UnityEngine.UI
{
    [AddComponentMenu("UI/Loop Vertical Scroll Rect", 51)]
    [DisallowMultipleComponent]
    public class LoopVerticalScrollRect : LoopScrollRect
    {
        bool bInited = false;
        SlideGridLayoutGroup slideLayout;

        protected override float GetSize(RectTransform item)
        {
            float size = contentSpacing;
            if (m_GridLayout != null)
            {
                size += m_GridLayout.cellSize.y;
            }
            else
            {
                size += LayoutUtility.GetPreferredHeight(item);
            }
            return size;
        }

        protected override float GetDimension(Vector2 vector)
        {
            return vector.y;
        }

        protected override Vector2 GetVector(float value)
        {
            return new Vector2(0, value);
        }

        protected override void Awake()
        {
            base.Awake();
            directionSign = -1;

            GridLayoutGroup layout = content.GetComponent<GridLayoutGroup>();
            if (layout != null && layout.constraint != GridLayoutGroup.Constraint.FixedColumnCount)
            {
                //Debug.LogError("[LoopHorizontalScrollRect] unsupported GridLayoutGroup constraint");
            }
            if (layout != null && (layout.startCorner == GridLayoutGroup.Corner.LowerLeft || layout.startCorner == GridLayoutGroup.Corner.LowerRight))
            {
                lowGrid = true;
            }

            if (layout == null)
            {
                slideLayout = content.GetComponent<SlideGridLayoutGroup>();
                if (slideLayout != null && slideLayout.constraint != SlideGridLayoutGroup.Constraint.FixedColumnCount)
                {
                    //Debug.LogError("[LoopHorizontalScrollRect] unsupported GridLayoutGroup constraint");
                }
                if (slideLayout != null && (slideLayout.startCorner == SlideGridLayoutGroup.Corner.LowerLeft || slideLayout.startCorner == SlideGridLayoutGroup.Corner.LowerRight))
                {
                    lowGrid = true;
                }
            }

            if (layout == null)
            {
                SlideVerticalLayoutGroup  slideLayout1 = content.GetComponent<SlideVerticalLayoutGroup>();

                if (slideLayout1 != null && slideLayout1.inverseChildPosEnable)
                {
                    lowGrid = true;
                }
            }
        }

        protected override bool UpdateItems(Bounds viewBounds, Bounds contentBounds)
        {
            
            if (!bInited)
            {
                bInited = true;
                CalcContentCount(viewBounds);
            }

            bool changed = false;
            if (viewBounds.min.y < contentBounds.min.y + 1)
            {
                float size = lowGrid? NewItemAtStart() : NewItemAtEnd();
                if (size > 0)
                {
                    if (threshold < size)
                    {
                        threshold = size * 1.1f;
                    }
                    changed = true;
                }
            }
            else if (viewBounds.min.y > contentBounds.min.y + threshold)
            {
                float size = lowGrid? DeleteItemAtStart() : DeleteItemAtEnd();
                if (size > 0)
                {
                    changed = true;
                }
            }
            if (viewBounds.max.y > contentBounds.max.y - 1)
            {
                float size = lowGrid ? NewItemAtEnd() : NewItemAtStart();
                if (size > 0)
                {
                    if (threshold < size)
                    {
                        threshold = size * 1.1f;
                    }
                    changed = true;
                }
            }
            else if (viewBounds.max.y < contentBounds.max.y - threshold)
            {
                float size = lowGrid ? DeleteItemAtEnd() : DeleteItemAtStart();
                if (size > 0)
                {
                    changed = true;
                }
            }
            return changed;
        }

        void CalcContentCount(Bounds viewBounds)
        {
            if (mContentCount == 0)
            {
                LayoutElement elm = Cell.GetComponent<LayoutElement>();
                if(elm.preferredHeight > 0)
                {
                    mContentCount = Mathf.CeilToInt(viewBounds.size.y / (elm.preferredHeight + contentSpacing));
                }else if(elm.minHeight > 0)
                {
                    mContentCount = Mathf.CeilToInt(viewBounds.size.y / (elm.minHeight + contentSpacing));
                }else if(elm.flexibleHeight > 0)
                {
                    mContentCount = Mathf.CeilToInt(viewBounds.size.y / (elm.flexibleHeight + contentSpacing));
                }
            }
        }

        public override void OnBeginDrag(PointerEventData eventData)
        {
            base.OnBeginDrag(eventData);

            LoopScrollRectDragEventInherit srInhert = GetComponent<LoopScrollRectDragEventInherit>();
            if (srInhert == null) return;

            ScrollRect sr = srInhert.GetInheritScrollRect();
            if (sr == null) return;

            if (sr.vertical)
            {
                sr.OnBeginDrag(eventData);
            }
        }

        public override void OnDrag(PointerEventData eventData)
        {
            base.OnDrag(eventData);

            LoopScrollRectDragEventInherit srInhert = GetComponent<LoopScrollRectDragEventInherit>();
            if (srInhert == null) return;

            ScrollRect sr = srInhert.GetInheritScrollRect();
            if (sr == null) return;

            if (sr.vertical)
            {
                sr.OnDrag(eventData);
            }
        }

        public override void OnEndDrag(PointerEventData eventData)
        {
            base.OnEndDrag(eventData);

            LoopScrollRectDragEventInherit srInhert = GetComponent<LoopScrollRectDragEventInherit>();
            if (srInhert == null) return;

            ScrollRect sr = srInhert.GetInheritScrollRect();
            if (sr == null) return;

            if (sr.vertical)
            {
                sr.OnEndDrag(eventData);
            }
        }
    }
}