using System;
using UnityEditor;
using UnityEngine;

namespace Pack
{
    public class PackException : Exception
    {
        public PackException(string message) : base((Application.isBatchMode ? (PackConstant.TAG_EXCEPTION_START + message + PackConstant.TAG_EXCEPTION_END) : message)) { }
        public PackException(string message, Exception innerException) : base((Application.isBatchMode ? (PackConstant.TAG_EXCEPTION_START + message + PackConstant.TAG_EXCEPTION_END) : message), innerException) { }
    }
}