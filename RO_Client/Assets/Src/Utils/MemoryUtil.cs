using UnityEngine;
using System;

public class MemoryUtil
{
//    /// <summary>
//    /// 调用回收Mono内存
//    /// </summary>
//    public static void CollectMonoMem()
//    {
//#if !UNITY_EDITOR
//        System.GC.Collect();
//#endif
//    }

    /// <summary>
    /// 调用回收Unity的资源内存
    /// </summary>
    public static void CollectNativeMem()
    {
        Resources.UnloadUnusedAssets();
    }

    /// <summary>
    /// 调用回收Lua代码造成的内存
    /// </summary>
    public static void CollectLuaMem()
    {
        if (LuaMgr.HasInstance())
            LuaMgr.Instance.LuaGC();
    }

    ///// <summary>
    ///// 同时调用回收不用资源以及Mono内存
    ///// </summary>
    //public static void CollectMonoAndNativeMem()
    //{
    //    Resources.UnloadUnusedAssets();
    //    CollectMonoMem();
    //}

    ///// <summary>
    ///// 同时调用回收Mono和Lua内存
    ///// </summary>
    //public static void CollectMonoAndLuaMem()
    //{
    //    Resources.UnloadUnusedAssets();
    //    CollectMonoMem();
    //}

    public static void ReleaseMemory()
    {
        GameMgr.Instance.CleanUnusedAssets();
        CollectLuaMem();
    }
}
