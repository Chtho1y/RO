using UnityEngine;
using System.Collections;
using UnityEngine.UI;

[RequireComponent(typeof(Image))]
public class TweenFillAmount : Tweener
{
    public float from = 1.0f;
    public float to = 1.0f;


    private Image mImage;

    public Image cachedImage { get { return mImage; } }

    public float value { get { return mImage.fillAmount; } set { mImage.fillAmount = value; } }


    private void Awake()
    {
        mImage = GetComponent<Image>();
    }

    protected override void OnUpdate(float factor, bool isFinished)
    {
        value = from * (1f - factor) + to * factor;
    }

    public static TweenFillAmount Begin(GameObject go, float duration, float to)
    {
        TweenFillAmount comp = Tweener.Begin<TweenFillAmount>(go, duration);
        comp.from = comp.value;
        comp.to = to;

        if (duration <= 0f)
        {
            comp.Sample(1f, true);
            comp.enabled = false;
        }
        return comp;
    }

    [ContextMenu("Set 'From' to current value")]
    public override void SetStartToCurrentValue() { from = value; }

    [ContextMenu("Set 'To' to current value")]
    public override void SetEndToCurrentValue() { to = value; }

    [ContextMenu("Assume value of 'From'")]
    void SetCurrentValueToStart() { value = from; }

    [ContextMenu("Assume value of 'To'")]
    void SetCurrentValueToEnd() { value = to; }
}
