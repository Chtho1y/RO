using UnityEngine;
using System.Collections;
using UnityEngine.UI;

public class MainCityButtonHelper : MonoBehaviour
{
    public Animator builder;
    // Use this for initialization
    public void OnButtonNormal()
    {
        if (builder == null) return;

        builder.SetTrigger("Normal");
    }

    public void OnButtonHighlighted()
    {
        if (builder == null) return;

        builder.SetTrigger("Highlighted");
    }

    public void OnButtonPressed()
    {
        if (builder == null) return;

        builder.SetTrigger("Pressed");
    }

    public void OnButtonDisabled()
    {
        if (builder == null) return;

        builder.SetTrigger("Disabled");
    }
}
