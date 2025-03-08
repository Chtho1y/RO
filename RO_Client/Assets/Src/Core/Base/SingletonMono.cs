using UnityEngine;
using System.Collections;

public class MonoBase : MonoBehaviour
{

}

public class SingletonMono<T> : MonoBase where T : MonoBase
{
    private static T instance;
    public static T Instance
    {
        get
        {
            if (instance != null)
            {
#if UNITY_EDITOR
                if (applicationIsQuitting)
                {
                    DebugHelper.Log("[Singleton] Instance [ {0} ] already destroyed on application quit. Won't create again - returning null.", typeof(T));
                    return null;
                }
#endif
                return instance;
            }
#if UNITY_EDITOR
            if (!Application.isPlaying)
            {
                GameObject singleton = GameObject.Find("Editor");
                if (singleton == null)
                    singleton = new GameObject("Editor");
                instance = singleton.transform.GetOrAddComponent<T>();
                return instance;
            }
            else
            {
                if (applicationIsQuitting)
                {
                    DebugHelper.Log("[Singleton] Instance [ {0} ] already destroyed on application quit. Won't create again - returning null.", typeof(T));
                    return null;
                }
                GameObject go = new GameObject(typeof(T).Name);
                instance = go.AddComponent<T>();
                DontDestroyOnLoad(go);
                return instance;
            }
#else
                if (GameMgr.Instance != null)

                {
                    if (typeof(T).Equals(typeof(UIMgr)))
                    {
                        GameObject singleton = new GameObject(typeof(T).ToString());
                        singleton.transform.parent = GameMgr.Instance.transform;
                        instance = singleton.AddComponent<T>();
                    }
                    else
                        instance = GameMgr.Instance.GetOrAddComponent<T>();
                }
                else  if (GameMgr.Instance == null)
                {
                    GameObject singleton = new GameObject(typeof(T).ToString());
                    instance = singleton.AddComponent<T>();
                }
                return instance;
#endif
        }
    }
    private static bool applicationIsQuitting = false;

    protected void OnDestroy()
    {
        Dispose();
    }

    public virtual void InitMgr()
    {

    }

    protected virtual void Dispose()
    {
        instance = null;
    }

    protected virtual void OnApplicationQuit()
    {
        applicationIsQuitting = true;
        instance = null;
    }

    public static bool HasInstance()
    {
        return (instance != null);
    }
}
