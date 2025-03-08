using System;
using UnityEngine;

namespace Pack
{
    public static class PackLog
    {
        public static void Log(string message)
        {
            if (Application.isBatchMode)
                Debug.Log(PackConstant.TAG_START + message + PackConstant.TAG_END);
            else
                Debug.Log(message);
        }

        public static void LogError(string message)
        {
            if (Application.isBatchMode)
                Debug.LogError(PackConstant.TAG_ERROR_START + message + PackConstant.TAG_ERROR_END);
            else
                Debug.LogError(message);
        }

        public static void LogWarning(string message)
        {
            if (Application.isBatchMode)
                Debug.LogWarning(PackConstant.TAG_WARING_START + message + PackConstant.TAG_WARING_END);
            else
                Debug.LogWarning(message);
        }

        public static void LogException(Exception exception)
        {
            if (Application.isBatchMode)
            {
                Debug.LogError(PackConstant.TAG_EXCEPTION_START);
                Debug.LogException(exception);
                Debug.LogError(PackConstant.TAG_EXCEPTION_END);
            }
            else
                Debug.LogException(exception);
        }
    }
}