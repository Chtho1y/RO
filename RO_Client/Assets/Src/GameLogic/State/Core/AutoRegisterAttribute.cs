// custom attribute

using System;
using UnityEngine;

public class AutoRegisterAttribute :
    Attribute
{

}

public class FriendlyName : PropertyAttribute
{
    public string friendlyName { get; protected set; }

    public FriendlyName(string InDisplayName)
    {
        friendlyName = InDisplayName;
    }
}