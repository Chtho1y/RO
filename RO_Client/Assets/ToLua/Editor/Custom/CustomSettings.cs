using System;
using System.Collections.Generic;
using LuaInterface;
using UnityEditor;
using UnityEngine;
using UnityEngine.UI;

using BindType = ToLuaMenu.BindType;
using System.Reflection;

public static class CustomSettings
{
    public static string saveDir = Application.dataPath + "/ToLua/Source/Generate/";
    public static string toluaBaseType = Application.dataPath + "/ToLua/BaseType/";
    public static string baseLuaDir = Application.dataPath + "/Tolua/Lua/";
    public static string injectionFilesPath = Application.dataPath + "/ToLua/Injection/";

    //导出时强制做为静态类的类型(注意customTypeList 还要添加这个类型才能导出)
    //unity 有些类作为sealed class, 其实完全等价于静态类
    public static List<Type> staticClassTypes = new List<Type> {
        typeof (UnityEngine.Application),
        typeof (UnityEngine.Time),
        typeof (UnityEngine.Screen),
        typeof (UnityEngine.SleepTimeout),
        typeof (UnityEngine.Input),
        typeof (UnityEngine.Resources),
        typeof (UnityEngine.Physics),
        typeof (UnityEngine.RenderSettings),
        typeof (UnityEngine.QualitySettings),
        typeof (UnityEngine.GL),
        typeof (UnityEngine.Graphics),
    };

    //附加导出委托类型(在导出委托时, customTypeList 中牵扯的委托类型都会导出， 无需写在这里)
    public static DelegateType[] customDelegateList = {
        _DT (typeof (Action)),
        _DT (typeof (UnityEngine.Events.UnityAction)),
        _DT (typeof (System.Predicate<int>)),
        _DT (typeof (System.Action<int>)),
        _DT (typeof (System.Comparison<int>)),
        _DT (typeof (System.Func<int, int>)),
    };

    //在这里添加你要导出注册到lua的类型列表
    public static BindType[] customTypeList = {
        //------------------------为例子导出--------------------------------
        //_GT(typeof(TestEventListener)),
        //_GT(typeof(TestProtol)),
        //_GT(typeof(TestAccount)),
        //_GT(typeof(Dictionary<int, TestAccount>)).SetLibName("AccountMap"),
        //_GT(typeof(KeyValuePair<int, TestAccount>)),
        //_GT(typeof(Dictionary<int, TestAccount>.KeyCollection)),
        //_GT(typeof(Dictionary<int, TestAccount>.ValueCollection)),
        //_GT(typeof(TestExport)),
        //_GT(typeof(TestExport.Space)),
        //-------------------------------------------------------------------        

        _GT (typeof(Dictionary<object, object>)),

        _GT (typeof (LuaInjectionStation)),
        _GT (typeof (InjectType)),
        _GT (typeof (Debugger)).SetNameSpace (null),

        //#if USING_DOTWEENING
        _GT (typeof (DG.Tweening.DOTween)),
        _GT (typeof (DG.Tweening.Ease)),
        _GT (typeof (DG.Tweening.Tween)).SetBaseType (typeof (System.Object)).AddExtendType (typeof (DG.Tweening.TweenExtensions)),
        _GT (typeof (DG.Tweening.Sequence)).AddExtendType (typeof (DG.Tweening.TweenSettingsExtensions)),
        _GT (typeof (DG.Tweening.Tweener)).AddExtendType (typeof (DG.Tweening.TweenSettingsExtensions)),
        _GT (typeof (DG.Tweening.LoopType)),
        _GT (typeof (DG.Tweening.PathMode)),
        _GT (typeof (DG.Tweening.PathType)),
        _GT (typeof (DG.Tweening.RotateMode)),
        _GT (typeof (Component)).AddExtendType (typeof (DG.Tweening.ShortcutExtensions)),
        _GT (typeof (Transform)).AddExtendType (typeof (DG.Tweening.ShortcutExtensions)).AddExtendType(typeof(UnityEngineUtils)),
        _GT (typeof (Light)).AddExtendType (typeof (DG.Tweening.ShortcutExtensions)),
        _GT (typeof (Material)).AddExtendType (typeof (DG.Tweening.ShortcutExtensions)),
        _GT (typeof (Rigidbody)).AddExtendType (typeof (DG.Tweening.ShortcutExtensions)),
        _GT (typeof (Camera)).AddExtendType (typeof (DG.Tweening.ShortcutExtensions)),
        _GT (typeof (AudioSource)).AddExtendType (typeof (DG.Tweening.ShortcutExtensions)),
        _GT (typeof (Graphic)).AddExtendType (typeof (DG.Tweening.DOTweenModuleUI)),
        //_GT(typeof(LineRenderer)).AddExtendType(typeof(DG.Tweening.ShortcutExtensions)),
        //_GT(typeof(TrailRenderer)).AddExtendType(typeof(DG.Tweening.ShortcutExtensions)),    
        //#else

        //_GT(typeof(Component)).AddExtendType(typeof(UnityEngineUtils)),
        //_GT(typeof(Transform)).AddExtendType(typeof(UnityEngineUtils)),
        //_GT(typeof(Material)),
        //_GT(typeof(Light)),
        //_GT(typeof(Rigidbody)),
        //_GT(typeof(Camera)),
        //_GT(typeof(AudioSource)),
        //_GT(typeof(LineRenderer))
        //_GT(typeof(TrailRenderer))
        //#endif

        _GT (typeof (Behaviour)),
        _GT (typeof (MonoBehaviour)),
        _GT (typeof (GameObject)).AddExtendType (typeof (UnityEngineUtils)),
        _GT (typeof (TrackedReference)),
        _GT (typeof (Application)),
        _GT (typeof (Physics)),
        _GT (typeof (Collider)),
        _GT (typeof (Time)),
        _GT (typeof (Texture)),
        _GT (typeof (Texture2D)),
        _GT (typeof (Shader)),
        _GT (typeof (Renderer)),
        _GT (typeof (WWW)),
        _GT (typeof (Screen)),
        _GT (typeof (CameraClearFlags)),
        _GT (typeof (AudioClip)),
        _GT (typeof (AssetBundle)),
        _GT (typeof (ParticleSystem)),
        _GT (typeof (AsyncOperation)).SetBaseType (typeof (System.Object)),
        _GT (typeof (LightType)),
        _GT (typeof (SleepTimeout)),
#if UNITY_5_3_OR_NEWER && !UNITY_5_6_OR_NEWER
        _GT (typeof (UnityEngine.Experimental.Director.DirectorPlayer)),
#endif
        _GT (typeof (Animator)),
        _GT (typeof (AnimatorStateInfo)),
        _GT (typeof (RuntimeAnimatorController)),
        _GT (typeof (AnimatorOverrideController)),
        _GT (typeof (Input)),
        _GT (typeof (KeyCode)),
        _GT (typeof (SkinnedMeshRenderer)),
        _GT (typeof (Space)),

        _GT (typeof (MeshRenderer)),
#if !UNITY_5_4_OR_NEWER
        _GT (typeof (ParticleEmitter)),
        _GT (typeof (ParticleRenderer)),
        _GT (typeof (ParticleAnimator)),
#endif

        _GT (typeof (BoxCollider)),
        _GT (typeof (MeshCollider)),
        _GT (typeof (SphereCollider)),
        _GT (typeof (CharacterController)),
        _GT (typeof (CapsuleCollider)),

        _GT (typeof (Animation)),
        _GT (typeof (AnimationClip)).SetBaseType (typeof (UnityEngine.Object)),
        _GT (typeof (AnimationState)),
        _GT (typeof (AnimationBlendMode)),
        _GT (typeof (QueueMode)),
        _GT (typeof (PlayMode)),
        _GT (typeof (WrapMode)),

        _GT (typeof (QualitySettings)),
        _GT (typeof (RenderSettings)),
        _GT (typeof (SkinWeights)),
        _GT (typeof (RenderTexture)),
        _GT (typeof (RenderTextureDescriptor)),
        _GT (typeof (RenderTextureFormat)),
        _GT (typeof (Resources)),
        _GT (typeof (LuaProfiler)),

        //关联类
        _GT (typeof (Image)).AddExtendType (typeof (DG.Tweening.DOTweenModuleUI)),
        _GT (typeof (RectTransform)).AddExtendType (typeof (DG.Tweening.DOTweenModuleUI)),
        _GT (typeof (RectTransform.Axis)),
        _GT (typeof (Button)),
        _GT (typeof (Button.ButtonClickedEvent)),
        _GT (typeof (Text)).AddExtendType (typeof (DG.Tweening.DOTweenModuleUI)),
        _GT (typeof (RawImage)),
        _GT (typeof (Toggle)),
        _GT (typeof (Toggle.ToggleEvent)),
        _GT (typeof (Slider)).AddExtendType (typeof (DG.Tweening.DOTweenModuleUI)),
        _GT (typeof (Slider.SliderEvent)),
        _GT (typeof (InputField)).AddExtendType (typeof (UnityEngineUtils)),
        _GT (typeof (InputField.OnChangeEvent)),
        _GT (typeof (InputField.SubmitEvent)),
        _GT (typeof (ScrollRect)).AddExtendType (typeof (DG.Tweening.DOTweenModuleUI)),
        _GT (typeof (ScrollRect.ScrollRectEvent)),
        _GT (typeof (Canvas)),
        _GT (typeof (CanvasGroup)).AddExtendType (typeof (DG.Tweening.DOTweenModuleUI)),
        //_GT(typeof(DG.Tweening.DOTween)),
        _GT (typeof (LayerMask)),
        _GT (typeof (Dropdown)),
        _GT (typeof (Dropdown.OptionData)),
        _GT (typeof (LayoutElement)),
        _GT (typeof (GridLayoutGroup)),
        _GT (typeof (VerticalLayoutGroup)),
        _GT (typeof (HorizontalLayoutGroup)),
        _GT (typeof (MeshFilter)),
        _GT (typeof (Int32)),
        _GT (typeof (PlayerPrefs)),
        _GT (typeof (ToggleGroup)),
        _GT (typeof (Quaternion)),
        _GT (typeof (Scrollbar)),
        //
        _GT (typeof (GameMgr)),
        _GT (typeof (Constants)),
        _GT (typeof (LuaConst)),
        _GT (typeof (LuaUIBase)),
        _GT (typeof (LuaMgr)),
        _GT (typeof (ResourceMgr)),
        _GT (typeof (ELoadType)),
        _GT (typeof (NetworkMgr)),
        _GT (typeof (ECoreEventType)),
        _GT (typeof (SceneMgr)),
        _GT (typeof (MusicMgr)),
        _GT (typeof (UIMgr)),
        _GT (typeof (DebugHelper)),
        _GT (typeof (TimerManager)),
        _GT (typeof (LoopVerticalScrollRect)),
        _GT (typeof (LoopHorizontalScrollRect)),
        _GT (typeof (FileUtils)),
        _GT (typeof (RepeatButton)),
        _GT (typeof (CheckInputLength)),
        _GT (typeof (GlobalConfig)),
        _GT (typeof (ModelMgr)),
        _GT (typeof (StoryCMType)),
        _GT (typeof (ActorDataMgr)),
        _GT (typeof (ActorData)),
        _GT (typeof (HeroActorData)),
        _GT (typeof (FellowActorData)),
        _GT (typeof (PetActorData)),
        _GT (typeof (LuaBattleBridge)),
        _GT (typeof (CUIPolygon)),
        _GT (typeof (TMPro.TextMeshProUGUI)),
        _GT (typeof (TMPro.TextMeshPro)),
        _GT (typeof (TMPro.TMP_InputField)),
        _GT (typeof (TMPro.TMP_TextUtilities)),
        _GT (typeof (TMPro.TMP_TextInfo)),
        _GT (typeof (TMPro.TMP_LinkInfo)),
        _GT (typeof (StringUtil)),
        _GT (typeof (UILocalizeScript)),
        _GT (typeof (ButtonTriggerAnimation)),
        _GT (typeof (UIEventHandler)),
        _GT (typeof (UIJoystick)),
        _GT (typeof (UIJoystick.OnDragEvent)),
        _GT (typeof (Cinemachine.CinemachineVirtualCamera)),
        _GT (typeof (UIEventTriggerListener)),
        _GT (typeof (UnityEngine.EventSystems.PointerEventData)),
        _GT (typeof (UnityEngine.EventSystems.PhysicsRaycaster)),
        _GT (typeof (LuaUInt64)),
        _GT (typeof (LuaUInt32)),
        _GT (typeof (ProfessionType)),
        _GT (typeof (I18N)),
        _GT (typeof (UIDragItem)),
        _GT (typeof (MirrorCamera)),
        _GT (typeof (CameraMgr)),
        _GT (typeof (SuperScrollView.LoopGridView)),
        _GT (typeof (SuperScrollView.LoopGridViewItem)),
        _GT (typeof (SuperScrollView.LoopGridViewSettingParam)),
        _GT (typeof (SuperScrollView.LoopGridViewInitParam)),
        _GT (typeof (SuperScrollView.RowColumnPair)),
        _GT (typeof (SuperScrollView.LoopListView)),
        _GT (typeof (SuperScrollView.LoopListViewItem)),
        _GT (typeof (SuperScrollView.LoopListViewInitParam)),
        _GT (typeof (SuperScrollView.GridFixedType)),
        _GT (typeof (UIExtensions.UIParticle)),
        _GT (typeof (DateTimeUtil)),
        _GT (typeof (PreviewCameraEvent)),
        _GT (typeof (AroundSphereMove)),
        _GT (typeof (RollingNumberText)),
        _GT (typeof (Rect)),
        _GT (typeof (RectOffset)),
        _GT (typeof (RenderingPath)),
        _GT (typeof (BattleSubMode)),
        _GT (typeof (BattleMode)),
        _GT (typeof (SceneType)),
        _GT (typeof (SkillParam)),
        _GT (typeof (BuffParam)),
        _GT (typeof (ActorParam)),
        _GT (typeof (FashionParam)),
        _GT (typeof (HairColorParam)),
        _GT (typeof (BodyPartParam)),
        _GT (typeof (ServerFighterParam)),
        _GT (typeof (GvGMark)),
        _GT (typeof (RO.ReorderableList)),
        _GT (typeof (RO.ReorderableList.ReorderableListEventStruct)),
        _GT (typeof (RO.ReorderableList.ReorderableListHandler)),
        _GT (typeof (SlideHorizontalLayoutGroup)),
        _GT (typeof (CastSkillData)),
        _GT (typeof (SwitchSprite)),
        _GT (typeof (LoopScrollRectDragEventInherit)),
        _GT (typeof (SlideVerticalLayoutGroup)),
        _GT (typeof (SlideGridLayoutGroup)),
        _GT (typeof (ContentSizeFitter)),
        _GT (typeof (WXB.SymbolText)),
        _GT (typeof (eNetType)),
        _GT (typeof (UIBigMapLine)),
        _GT (typeof (UIRaycastNoDraw)),
        _GT (typeof (UIGridViewMark)),
        _GT (typeof (UIPlayVideo)),
        _GT (typeof (AnimControlSkin)),
        _GT (typeof (GuideMask)),
        _GT (typeof (DropDownHelper)),
        _GT (typeof (WXB.SymbolTextEvent)),
        _GT (typeof (UIEffectCfg)),
        _GT (typeof (SInt)),
        _GT (typeof (SBool)),
        _GT (typeof (SFloat)),
        _GT (typeof (SDouble)),
        _GT (typeof (SLong)),
        _GT (typeof (SDataUtil)),
        _GT (typeof (OutputType)),
        _GT (typeof (OutputInfo)),
        _GT (typeof(BattleStatistics)),
        _GT (typeof(FighterStatistics)),
        _GT (typeof(SkillStatistics)),
        _GT (typeof(AvatarRTMgr)),
        _GT (typeof(BattleEndCondition)),
        _GT (typeof(ValType)),
        _GT (typeof(Spine.Unity.SkeletonGraphic)),
        _GT (typeof(Spine.AnimationState)),
        _GT (typeof(Spine.Skeleton)),
        _GT (typeof(TextAnchor)),
        _GT (typeof(SDKMgr)),
        _GT (typeof(ChannelType)),
        _GT (typeof(SDKModulType)),
        _GT (typeof(DeviceSystemData)),
        _GT (typeof(GameRoleInfo)),
        _GT (typeof(Wenting.Lebian.LeBianSDK)),
        _GT (typeof(Wenting.Lebian.QueryUpdateErrorCode)),
        _GT (typeof(UIImageSwitchSprite)),
        _GT (typeof (RolRectTransform)),
        _GT (typeof (UiLoopAutoMove)),
        _GT (typeof(GUIUtility)),
        _GT (typeof(UnityEngineUtils)),
        _GT (typeof(Vuplex.WebView.Web)),
        _GT (typeof(Vuplex.WebView.WebViewOptions)),
        _GT (typeof(Vuplex.WebView.WebPluginType)),
        _GT (typeof(Vuplex.WebView.WentingCanvasWebVewPrefab)),
        _GT (typeof(Vuplex.WebView.CanvasWebViewPrefab)),
        _GT (typeof(Vuplex.WebView.WebViewPrefab)),
        _GT (typeof(Vuplex.WebView.BaseWebViewPrefab)),
        _GT (typeof(Vuplex.WebView.DragMode)),
        _GT (typeof(Vuplex.WebView.BaseWebView)),
        _GT (typeof(Vuplex.WebView.ConsoleMessageEventArgs)),
        _GT (typeof(Vuplex.WebView.FocusedInputFieldChangedEventArgs)),
        _GT (typeof(Vuplex.WebView.ProgressChangedEventArgs)),
        _GT (typeof(Vuplex.WebView.UrlChangedEventArgs)),
        _GT (typeof(Vuplex.WebView.ScrolledEventArgs)),
        _GT (typeof(Vuplex.WebView.CanvasKeyboard)),
        _GT (typeof(Vuplex.WebView.Keyboard)),
        _GT (typeof(Vuplex.WebView.BaseKeyboard)),
        _GT (typeof(Vuplex.WebView.KeyModifier)),
    };

    public static List<Type> dynamicList = new List<Type>() {
        typeof (MeshRenderer),
#if !UNITY_5_4_OR_NEWER
        typeof (ParticleEmitter),
        typeof (ParticleRenderer),
        typeof (ParticleAnimator),
#endif

        typeof (BoxCollider),
        typeof (MeshCollider),
        typeof (SphereCollider),
        typeof (CharacterController),
        typeof (CapsuleCollider),

        typeof (Animation),
        typeof (AnimationClip),
        typeof (AnimationState),

        typeof (SkinWeights),
        typeof (RenderTexture),
        typeof (Rigidbody),
    };

    //重载函数，相同参数个数，相同位置out参数匹配出问题时, 需要强制匹配解决
    //使用方法参见例子14
    public static List<Type> outList = new List<Type>()
    {

    };

    //ngui优化，下面的类没有派生类，可以作为sealed class
    public static List<Type> sealedList = new List<Type>() { };

    public static BindType _GT(Type t)
    {
        return new BindType(t);
    }

    public static DelegateType _DT(Type t)
    {
        return new DelegateType(t);
    }

    //[MenuItem("Lua/Attach Profiler", false, 151)]
    static void AttachProfiler()
    {
        if (!Application.isPlaying)
        {
            EditorUtility.DisplayDialog("警告", "请在运行时执行此功能", "确定");
            return;
        }

        LuaClient.Instance.AttachProfiler();
    }

    //[MenuItem("Lua/Detach Profiler", false, 152)]
    static void DetachProfiler()
    {
        if (!Application.isPlaying)
        {
            return;
        }

        LuaClient.Instance.DetachProfiler();
    }
}