using LuaInterface;
using System;
using System.Collections.Generic;
using System.Text;
using UnityEngine.UI;

namespace UnityEngine
{
	public static class UnityEngineUtils
	{
		#region Instantiate
		public static T Instantiate<T>(this T original) where T : Object
		{
			return Object.Instantiate(original) as T;
		}

		public static GameObject Root(this GameObject gameObject)
		{
			return gameObject.transform.root.gameObject;
		}
        		
		public static void SetSafeActive(this GameObject gameObject, bool bValue)
		{
			if (gameObject == null)
			{
				return;
			}
			gameObject.SetActive(bValue);
		}

        public static void SetSafeActive(this Transform transform, bool bValue)
		{
			if (transform == null)
			{
				return;
			}
			transform.gameObject.SetActive(bValue);
		}
		
		public static void SetVisible(this MonoBehaviour component, bool bValue)
		{
			if (component == null)
			{
				return;
			}
			component.gameObject.SetActive(bValue);
		}
		public static bool IsVisible(this MonoBehaviour component)
		{
			return !(component == null) && component.gameObject.activeSelf;
		}
		public static void SetSafeEnable(this MonoBehaviour component, bool bValue)
		{
			if (component == null)
			{
				return;
			}
			component.enabled = bValue;
		}			

        public static void Destroy(this GameObject go)
        {
            if (go == null) return;

            ((Object)go).Destroy();
        }

        public static void DestroyComponent(this GameObject go, Type comName)
        {
            if (go == null) return;

            var com = go.GetComponent(comName.ToString());
            if (com == null) return;

            GameObject.DestroyImmediate(com);
        }
        #endregion

        #region
        public static GameObject getGameObject(this Transform tr, string name)
        {
            if (tr == null)
            {
				DebugHelper.LogError("No such Transform ");
                return null;
            }

            Transform trs = tr.Find(name);
            if (trs)
            {
                return trs.gameObject;
            }
            else
            {
				DebugHelper.LogError("No such item  {0}" , name);
                return null;
            }
        }

        public static void RemoveAllChild(this Transform transform)
        {
            if (transform == null)
            {
                return;
            }
            int i = 0;
            int childCount = transform.childCount;
            while (i < childCount)
            {
                Transform child = transform.GetChild(i);
                child.gameObject.SetActive(false);
                GameObject.Destroy(child.gameObject);
                i++;
            }
        }
        [NoToLua]
        public static T GetComponentUpwards<T>(this GameObject _go) where T : Component
        {
            Transform parent = _go.transform.parent;
            while (parent != null)
            {
                T t = parent.GetComponent(typeof(T)) as T;
                if (t != null)
                {
                    return t;
                }
                parent = parent.parent;
            }
            return (T)((object)null);
        }

        [NoToLua]
        public static T GetComponentInChildrenFast<T>(this GameObject go) where T : Component
        {
            Component component = go.GetComponent(typeof(T));
            if (component != null)
            {
                return component as T;
            }
            Transform transform = go.transform;
            if (transform != null)
            {
                int childCount = transform.childCount;
                for (int i = 0; i < childCount; i++)
                {
                    Transform child = transform.GetChild(i);
                    T componentInChildrenFast = child.gameObject.GetComponentInChildrenFast<T>();
                    if (componentInChildrenFast != null)
                    {
                        return componentInChildrenFast;
                    }
                }
            }
            return (T)((object)null);
        }
        [NoToLua]
        public static T GetComponentInChildrenFast<T>(this Component component) where T : Component
        {
            return component.gameObject.GetComponentInChildrenFast<T>();
        }

        [NoToLua]
        public static T GetComponent<T>(this GameObject go, bool create) where T : Component
        {
            T t = go.GetComponent(typeof(T)) as T;
            if (create && t == null)
            {
                t = (go.AddComponent(typeof(T)) as T);
            }
            return t;
        }

        public static Component GetOrAddComponent(this GameObject go, Type type)
        {
            Component comp = null;
            if (type != null)
            {
                comp = go.GetComponent(type);
                if (!comp)
                    comp = go.AddComponent(type);
            }

            return comp;
        }

        /// <summary>
        /// Gets or add a component. Usage example:
        /// BoxCollider boxCollider = transform.GetOrAddComponent<BoxCollider>();
        /// </summary>
        [NoToLua]
        public static T GetOrAddComponent<T>(this Component child) where T : Component
        {
            T result = child.GetComponent<T>();
            if (result == null)
            {
                result = child.gameObject.AddComponent<T>();
            }
            return result;
        }

        [NoToLua]
        public static T GetComponent<T>(this Component component, bool create) where T : Component
        {
            T t = component.GetComponent(typeof(T)) as T;
            if (create && t == null)
            {
                t = (component.gameObject.AddComponent(typeof(T)) as T);
            }
            return t;
        }
        #endregion

        public static void SetLayer(GameObject go, string layerName)
        {
            if (go == null) return;
            LayerMask mask = LayerMask.NameToLayer(layerName);
            SetLayer(go.transform, mask);
        }

        private static void SetLayer(Transform tr, LayerMask mask)
        {
            if (tr == null)
                return;
            for (int i = 0; i < tr.childCount; ++i)
            {
                SetLayer(tr.GetChild(i), mask);
            }
            tr.gameObject.layer = mask;
        }

        public static Material GetMaterial(this Renderer render)
        {
#if UNITY_EDITOR
            return render.material;
#else
            return render.sharedMaterial;  
#endif
        }

        public static void SetMaterialBlack(this GameObject go, bool black = false)
        {
            if (go == null) return;

            Renderer[] renders = go.GetComponentsInChildren<Renderer>();
            if (renders != null)
            {
                string shaderName = "";
                for (int i = 0; i < renders.Length; ++i)
                {
                    Material mMaterial;
#if UNITY_EDITOR
                    mMaterial = renders[i].material;
#else
                    mMaterial = renders[i].sharedMaterial;  
#endif
                    if (mMaterial != null)
                    {
                        shaderName = mMaterial.shader.name;
                        if (black)
                        {
                            if(shaderName.Contains("Particles"))
                            {
                                continue;
                            }
                            mMaterial.shader = Shader.Find("Diffuse");
                            mMaterial.SetVector("_Color", new Vector4(0,0,0,1));
                            //mMaterial.EnableKeyword("BLACKMODE");
                        }
                        else
                        {
                            if (shaderName.Contains("Diffuse"))
                            {
                                mMaterial.shader = Shader.Find("Mx_JS/HeroShow_RimTail");
                            }
                        }
                    }
                    shaderName = null;
                }
            }
        }

        public static void SetMaterialGray(this GameObject go, bool gray = false)
        {
            Renderer[] renders = go.GetComponentsInChildren<SkinnedMeshRenderer>();
            if (renders != null)
            {
                for (int i = 0; i < renders.Length; ++i)
                {
                    Material mMaterial = renders[i].material;
                    if (mMaterial != null && mMaterial.HasProperty("_Strength"))
                    {
                        if (gray)
                        {
                            mMaterial.SetFloat("_Strength", 0.314f);
                        }
                        else
                        {
                            mMaterial.SetFloat("_Strength", 1);
                        }
                    }
                }
            }
        }

        public static Color SetAlpha(this Color clr,float alpha)
        {
            clr.a = alpha;
            return clr;
        }

        public static void PauseEffectParticle(GameObject effectGameObject)
        {
            if (effectGameObject == null)
            {
                return;
            }

            ParticleSystem[] particals = effectGameObject.GetComponentsInChildren<ParticleSystem>(true);
            foreach (ParticleSystem p in particals)
            {
                p.Pause(false);
            }
        }

        public static void ResumeEffectParticle(GameObject effectGameObject)
        {
            if (effectGameObject == null)
            {
                return;
            }

            ParticleSystem[] particals = effectGameObject.GetComponentsInChildren<ParticleSystem>(true);
            foreach (ParticleSystem p in particals)
            {
                p.Play(false);
            }
        }

        public static void SetUnscalTimePartical(GameObject effectGameObject)
        {
            if (effectGameObject != null && effectGameObject.GetComponent<UnscaleTimeEffect>() == null)
            {
                effectGameObject.AddComponent<UnscaleTimeEffect>();
            }
        }

        public static void DestroyImmediate(this Object obj)
        {
            GameObject.DestroyImmediate(obj);
        }

        public static Transform GetTargetInChildens<T>(string targets, Transform transform) where T : Component
        {
            if (string.IsNullOrEmpty(targets))
            {
                return transform;
            }
            Transform[] componentsInChildren = transform.GetComponentsInChildren<Transform>(true);
            for (int i = 0; i < componentsInChildren.Length; i++)
            {
                if (componentsInChildren[i].name.Equals(targets))
                {
                    return componentsInChildren[i];
                }
            }
            return transform;
        }

        /// <summary>
        /// 获取top物体path路径下物体的T组件
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="top"></param>
        /// <param name="path"></param>
        /// <param name="create"></param>
        /// <returns></returns>
        [NoToLua]
        public static T GetComponentByPath<T>(this GameObject top, string path, bool create = false) where T : Component
        {
            Transform t = top != null ? (string.IsNullOrEmpty(path) ? top.transform : top.transform.Find(path)) : null;
            if (t != null)
            {
                T c = t.GetComponent<T>();
                if (c == null && create)
                    c = t.gameObject.AddComponent<T>();
                return c;
            }
            return null;
        }

        public static void Destroy(this Object obj)
        {
            GameObject.Destroy(obj);
        }

        public static string GetParentPath(this Transform tr, Transform root)
        {
            string transPath = string.Empty;
            if (tr != null && root != null && root != tr)
            {
                List<string> path = new List<string>();
                path.Add(tr.name);
                GetParentPathEX(tr.parent, ref path, root);
                if (path.Count > 0)
                {
                    StringBuilder sb = new StringBuilder(1024);
                    for (int i = path.Count - 1; i >= 0; --i)
                    {
                        sb.Append(path[i]);
                        if (i != 0)
                            sb.Append('/');
                    }
                    transPath = sb.ToString();
                }
            }
            else if (tr != null)
            {
                transPath = tr.name;
            }
            return transPath;
        }

        public static List<string> GetParentPathEX(Transform tr, ref List<string> path, Transform root)
        {
            if (tr != null && root != tr)
            {
                path.Add(tr.name);
                return GetParentPathEX(tr.parent, ref path, root);
            }
            return path;
        }

        public static void SetParentNormalize(this GameObject go, GameObject parent)
        {
            if (go == null || parent == null)
            {
                return;
            }
            go.transform.SetParentNormalize(parent.transform);
        }

        public static void SetParentNormalize(this GameObject go, Transform parent)
        {
            if (go == null)
            {
                return;
            }
            go.transform.SetParentNormalize(parent);
        }

        public static void SetParentNormalize(this Transform tr, Transform parent)
        {
            if (tr == null)
            {
                return;
            }
            tr.SetParent(parent);
            tr.ResetTransform();

        }

        public static void ResetTransform(this GameObject go)
        {
            if (go != null)
                go.transform.ResetTransform();
        }

        public static void ResetTransform(this Transform tr)
        {
            if (tr != null)
            {
                tr.localPosition = Vector3.zero;
                tr.localEulerAngles = Vector3.zero;
                tr.localScale = Vector3.one;
            }
        }

        public static Transform RecurisiveFindTransformChild(Transform t, string name)
        {
            if (t == null)
                return null;

            if (string.IsNullOrEmpty(name) || name.CompareTo(t.name) == 0)
                return t;
            for (int i = 0; i < t.childCount; i++)
            {
                Transform childT = RecurisiveFindTransformChild(t.GetChild(i), name);
                if (childT != null)
                    return childT;
            }
            return null;
        }

        public static void DisplayMobileKeyboard(this InputField input, bool display)
        {
            input.keyboardType = display ? TouchScreenKeyboardType.Default :(TouchScreenKeyboardType)(-1);
            input.ActivateInputField();
        }


        public static bool CheckBoundIsInCamera(this Bounds bound, Camera camera)
        {
            System.Func<Vector4, int> ComputeOutCode = (projectionPos) =>
            {
                int _code = 0;
                if (projectionPos.x < -projectionPos.w) _code |= 1;
                if (projectionPos.x > projectionPos.w) _code |= 2;
                if (projectionPos.y < -projectionPos.w) _code |= 4;
                if (projectionPos.y > projectionPos.w) _code |= 8;
                if (projectionPos.z < -projectionPos.w) _code |= 16;
                if (projectionPos.z > projectionPos.w) _code |= 32;
                return _code;
            };

            Vector4 worldPos = Vector4.one;
            int code = 63;
            for (int i = -1; i <= 1; i += 2)
            {
                for (int j = -1; j <= 1; j += 2)
                {
                    for (int k = -1; k <= 1; k += 2)
                    {
                        worldPos.x = bound.center.x + i * bound.extents.x;
                        worldPos.y = bound.center.y + j * bound.extents.y;
                        worldPos.z = bound.center.z + k * bound.extents.z;

                        code &= ComputeOutCode(camera.projectionMatrix * camera.worldToCameraMatrix * worldPos);
                    }
                }
            }
            return code == 0 ? true : false;
        }
    }
}