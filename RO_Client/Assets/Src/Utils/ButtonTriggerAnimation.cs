using DG.Tweening;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[System.Serializable]
[RequireComponent(typeof(Button))]
public class ButtonTriggerAnimation : MonoBehaviour
{
    public Animator tagetAnimator;
    public string animationName;
    Button button;

    // Start is called before the first frame update
    void Start()
    {
        if (tagetAnimator == null) return;

        button = GetComponent<Button>();

        if (button == null) return;
        button.onClick.AddListener(OnClickPlayAnimation);
    }

    public void OnClickPlayAnimation()
    {
        // tagetAnimator.CrossFade(animationName, 0.2f);
    }

    private void OnDestroy()
    {
        if (button == null) return;

        button.onClick.RemoveListener(OnClickPlayAnimation);
    }
}
