using UnityEngine;
using System.Collections;
using System.Security;

namespace Flux
{
    [FEvent("Skill/美术/播放特效")]
    public class FPlayEffectEvent : FEvent
    {
        [HideInInspector]
        [SerializeField]
        private GameObject _effectPrefab = null;
        public GameObject EffectPrefab
        {
            get { return _effectPrefab; }
        }

        [HideInInspector]
        [SerializeField]
        private int _effectId;
        public int EffectId
        {
            get { return _effectId; }
        }

        [HideInInspector]
        [SerializeField]
        private string _effectLink;
        public string EffectLink
        {
            get { return _effectLink; }
        }


        private GameObject effectGo;
        private ParticleSystem effectParticleSystem;
        private Animator[] effectAnimators;

        private float _previousTimeSinceTrigger = 0;
        private float _previousSpeed = 0;

        public FPlayEffectEvent()
        {
            _eventType = SkillActionFrameEventType.FE_PlayEffect;
        }

        protected override void OnSetDefaultValues()
        {
            base.OnSetDefaultValues();
        }

        protected override void OnTrigger(float timeSinceTrigger)
        {
            base.OnTrigger(timeSinceTrigger);

            if (_effectPrefab != null)
            {
                Vector3 pos = _casterTrans.position;
                Transform parent = null;
                Transform linkPoint = UnityEngineUtils.RecurisiveFindTransformChild(_casterTrans, _effectLink);
                if (linkPoint != null)
                {
                    parent = linkPoint;
                }

                effectGo = (GameObject)Instantiate(_effectPrefab);
                effectGo.transform.SetParent(parent);
                effectGo.transform.localPosition = Vector3.zero;
                effectGo.transform.localScale = Vector3.one;
                effectGo.transform.localRotation = Quaternion.identity;
                effectAnimators = effectGo.GetComponentsInChildren<Animator>();

                effectParticleSystem = effectGo.GetComponentInChildren<ParticleSystem>();
                if (effectParticleSystem != null)
                {
                    ParticleSystem.MainModule mainModule = effectParticleSystem.main;
                    mainModule.simulationSpeed = Sequence.Speed;
                }

                if(effectAnimators != null && effectAnimators.Length > 0)
                {
                    for(int aid = 0; aid < effectAnimators.Length; aid++)
                    {
                        var animator = effectAnimators[aid];
                        animator.enabled = true;
                        animator.SetLayerWeight(0, 1);
                        if (timeSinceTrigger > 0)
                        {
                            animator.Update(timeSinceTrigger - 0.001f);
                        }
                        else
                        {
                            animator.Update(0f);
                        }
                    }  
                }
            }

            if (effectParticleSystem != null && Sequence.IsPlaying && Sequence.IsPlayingForward)
                effectParticleSystem.Play(true);

            _previousTimeSinceTrigger = timeSinceTrigger;
            _previousSpeed = Sequence.Speed;
        }

        protected override void OnPause()
        {
            if (effectParticleSystem != null)
                effectParticleSystem.Pause();

            if (effectAnimators != null && effectAnimators.Length > 0)
            {
                for (int idx = 0; idx < effectAnimators.Length; idx++)
                    effectAnimators[idx].enabled = false;
            }
        }

        protected override void OnResume()
        {
            if (effectParticleSystem != null && Sequence.IsPlayingForward)
                effectParticleSystem.Play(true);

            if (effectAnimators != null && effectAnimators.Length > 0)
            {
                for (int idx = 0; idx < effectAnimators.Length; idx++)
                    effectAnimators[idx].enabled = true;
            }
        }

        protected override void OnFinish()
        {
            if (effectParticleSystem != null)
                effectParticleSystem.Stop(true);

            if (effectGo != null)
            {
                if ((IsLastEvent || _track.GetEvent(GetId() + 1).Start != End))
                {
                    if (effectAnimators != null && effectAnimators.Length > 0)
                    {
                        for (int idx = 0; idx < effectAnimators.Length; idx++)
                        {
                            effectAnimators[idx].SetLayerWeight(0, 0);
                            effectAnimators[idx].enabled = false;
                        }
                    }
                }

                GameObject.DestroyImmediate(effectGo);
                effectGo = null;
            }
        }

        protected override void OnStop()
        {
            if (effectParticleSystem != null)
            {
                effectParticleSystem.Stop(true);
                effectParticleSystem.Clear(true);
            }

            if (effectGo != null)
            {
                if ((IsLastEvent || _track.GetEvent(GetId() + 1).Start != End))
                {
                    if (effectAnimators != null)
                    {
                        for (int idx = 0; idx < effectAnimators.Length; idx++)
                        {
                            effectAnimators[idx].SetLayerWeight(0, 0);
                            effectAnimators[idx].enabled = false;
                        }
                    }
                }
                GameObject.DestroyImmediate(effectGo);
                effectGo = null;
            }
        }

        protected override void OnUpdateEvent(float timeSinceTrigger)
        {
            float delta = timeSinceTrigger - _previousTimeSinceTrigger;
            _previousTimeSinceTrigger = timeSinceTrigger;

            if (effectParticleSystem != null)
            {
                if (!Sequence.IsPlaying || !Sequence.IsPlayingForward)
                {
                    _previousSpeed = 1;
                    ParticleSystem.MainModule mainModule = effectParticleSystem.main;
                    mainModule.simulationSpeed = _previousSpeed;
                    if (Sequence.IsPlayingForward && delta > 0)
                    {
                        effectParticleSystem.Simulate(delta, true, false);
                    }
                }
                else if (_previousSpeed != Sequence.Speed)
                {
                    _previousSpeed = Sequence.Speed;
                    ParticleSystem.MainModule mainModule = effectParticleSystem.main;
                    mainModule.simulationSpeed = Mathf.Abs(_previousSpeed);
                }
            }

            if(effectAnimators!= null && effectAnimators.Length > 0)
            {
                for (int idx = 0; idx < effectAnimators.Length; idx++)
                {
                    var animator = effectAnimators[idx];
                    if (!animator.enabled)
                        animator.enabled = true;

                    if (delta > 0)
                    {
                        animator.Update(delta);   
                    }
                }
                _previousTimeSinceTrigger = timeSinceTrigger;
            }
        }

        public override int GetMaxLength()
        {
            return base.GetMaxLength();
        }

        public override string Text
        {
            get { return "播放特效"; }
            set { }
        }

        public override SecurityElement SaveToXml()
        {
            SecurityElement node =  base.SaveToXml();

            SecurityElement paramNode = WriteParamNode("effect",_effectId.ToString(),"int");
            node.AddChild(paramNode);

            if (_effectPrefab != null)
            {
#if UNITY_EDITOR
                paramNode = WriteParamNode("effectPrefab", UnityEditor.AssetDatabase.GetAssetPath(_effectPrefab), "string");
                node.AddChild(paramNode);
#endif
            }

            paramNode = WriteParamNode("effectLink", _effectLink, "string");
            if (paramNode != null)
                node.AddChild(paramNode);

            return node;
        }

        public override void LoadFromXml(SecurityElement eventNode)
        {
            base.LoadFromXml(eventNode);


            _effectId = GetNParam("effect");

            string effectPrefab = GetSParam("effectPrefab");
            if (!string.IsNullOrEmpty(effectPrefab))
            {
#if UNITY_EDITOR
                _effectPrefab = UnityEditor.AssetDatabase.LoadAssetAtPath<GameObject>(effectPrefab);
#endif
            }

            _effectLink = GetSParam("effectLink");
        }
    }
}
