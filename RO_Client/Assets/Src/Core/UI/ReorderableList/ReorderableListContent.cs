using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

namespace RO
{
    public class ReorderableListContent : MonoBehaviour
    {
        private List<Transform> m_CachedChildren;
        private List<ReorderableListElement> m_CachedListElement;
        private ReorderableListElement m_Ele;
        private ReorderableList m_ExtList;
        private RectTransform m_Rect;

        public void OnTransformChildrenChanged()
        {
            StartCoroutine(RefreshChildren());
        }

        public void Init(ReorderableList extList)
        {
            m_ExtList = extList;
            m_Rect = GetComponent<RectTransform>();
            m_CachedChildren = new List<Transform>();
            m_CachedListElement = new List<ReorderableListElement>();

            StartCoroutine(RefreshChildren());
        }

        private IEnumerator RefreshChildren()
        {
            //Handle new chilren
            for (int i = 0; i < m_Rect.childCount; i++)
            {
                if (m_CachedChildren.Contains(m_Rect.GetChild(i)))
                    continue;

                //Get or Create ReorderableListElement
                m_Ele = m_Rect.GetChild(i).gameObject.GetComponent<ReorderableListElement>() ??
                       m_Rect.GetChild(i).gameObject.AddComponent<ReorderableListElement>();
                m_Ele.Init(m_ExtList);

                m_CachedChildren.Add(m_Rect.GetChild(i));
                m_CachedListElement.Add(m_Ele);
            }

            //HACK a little hack, if I don't wait one frame I don't have the right deleted children
            yield return 0;

            //Remove deleted child
            for (int i = m_CachedChildren.Count - 1; i >= 0; i--)
            {
                if (m_CachedChildren[i] == null)
                {
                    m_CachedChildren.RemoveAt(i);
                    m_CachedListElement.RemoveAt(i);
                }
            }
        }
    }
}