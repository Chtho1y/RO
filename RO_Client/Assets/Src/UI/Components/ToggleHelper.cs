using UnityEngine;
using UnityEngine.UI;

[RequireComponent(typeof(Toggle))]
public class ToggleHelper:MonoBehaviour
{
    Transform on;
    Transform off;
    Toggle toggle;

    private void Awake()
    {
        toggle = GetComponent<Toggle>();
        on = transform.Find("On");
        off = transform.Find("Off");
    }

    public void OnEnable()
    {
        Set(toggle.isOn);
        toggle.onValueChanged.AddListener(OnValueChanged);
    }

    private void OnDisable() {
        toggle.onValueChanged.RemoveListener(OnValueChanged);
    }

    private void OnValueChanged(bool status)
    {
        Set(toggle.isOn);
    }

    private void Set(bool status)
    {
        if (on)
            on.gameObject.SetActive(status);
        if (off)
            off.gameObject.SetActive(!status);
    }
}