using UnityEngine;
using System.Collections;

public class ReviveRegion : FuncRegion
{
    public GameObject[] SubRevivePlaces = new GameObject[0];

    [FriendlyName("仅作为出生点")]
    public bool OnlyBirth = false;


    public ReviveRegion()
    {

    }
}
