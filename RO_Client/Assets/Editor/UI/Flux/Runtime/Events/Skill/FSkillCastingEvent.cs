using System.Collections;
using System.Collections.Generic;
using System.Security;
using UnityEngine;

namespace Flux
{
    [FEvent("Skill/动作相关/技能引导")]
    public class FSkillCastingEvent : FEvent
    {
        [HideInInspector]
        public string _animName;

        [HideInInspector]
        [Tooltip("What's the offset from where we play the animation?")]
        public int _startOffset;

        [SerializeField]
        private AudioClip _audioClip = null;
        public AudioClip AudioClip { get { return _audioClip; } }

        [HideInInspector]
        [SerializeField]
        private GameObject _effectPrefab = null;
        public GameObject EffectPrefab
        {
            get { return _effectPrefab; }
        }

        [HideInInspector]
        [SerializeField]
        private string _effectLink;
        public string EffectLink
        {
            get { return _effectLink; }
        }

        [HideInInspector]
        [SerializeField]
        private int _effectId;
        public int EffectId
        {
            get { return _effectId; }
        }

        private Animator _animator = null;
        public Animator animator
        {
            get { return _animator; }
        }

        private AudioSource _source;
        private ParticleSystem _particleSystem = null;
        private GameObject _effectGo = null;

        private float _previousTimeSinceTrigger = 0;
        private float _previousSpeed = 0;

        public FSkillCastingEvent()
        {
            _eventType = SkillActionFrameEventType.FE_Repeat_Caster;
        }

        protected override void OnSetDefaultValues()
        {
            base.OnSetDefaultValues();
            if (_casterTrans != null)
            {
                _animator = _casterTrans.gameObject.GetComponent<Animator>();
            }

        }

        protected override void OnInit()
        {
            if (_animator != null)
                _animator.enabled = false;
        }

        protected override void OnTrigger(float timeSinceTrigger)
        {
            if (Application.isPlaying)
            {
                _source = Owner.GetComponent<AudioSource>();
                if (_source == null)
                    _source = Owner.gameObject.AddComponent<AudioSource>();

                _source.volume = 1;
                _source.loop = false;
                _source.clip = _audioClip;

                if (Sequence.IsPlaying)
                    _source.Play();
            }
            else
            {
#if UNITY_EDITOR
                UnityEditor.AudioUtility.PlayClip(_audioClip);
#endif
            }
           

            if (_effectPrefab != null)
            {
                Vector3 pos = _casterTrans.position;
                Transform linkPoint = UnityEngineUtils.RecurisiveFindTransformChild(_casterTrans, _effectLink);
                if (linkPoint != null)
                {
                    pos = linkPoint.position;
                }
                _effectGo = (GameObject)Instantiate(_effectPrefab);

                _effectGo.transform.SetParent(linkPoint);
                _effectGo.transform.localPosition = Vector3.zero;
                _effectGo.transform.localScale = Vector3.one;
                _effectGo.transform.localRotation = Quaternion.identity;

                _particleSystem = _effectGo.GetComponentInChildren<ParticleSystem>();
                if (_particleSystem != null)
                {
                    ParticleSystem.MainModule mainModule = _particleSystem.main;
                    mainModule.simulationSpeed = Sequence.Speed;
                }
            }
           
            if (_particleSystem != null && Sequence.IsPlaying && Sequence.IsPlayingForward)
                _particleSystem.Play(true);


            if (_animator != null)
            {
                _animator.enabled = true;

                int id = GetId();

#if UNITY_EDITOR
                if (_animator.enabled && (!_track.HasCache || Application.isPlaying))
#else
			    if( _animator.enabled )
#endif
                {
                    _animator.SetLayerWeight(0, 1);
                    if (id == 0 || _track.Events[id - 1].End < Start)
                    {
                        _animator.Play(_animName, 0);
                    }

                    if (timeSinceTrigger > 0)
                    {
                        _animator.Update(timeSinceTrigger - 0.001f);
                    }
                    else
                        _animator.Update(0f);
                }
            }

            _previousTimeSinceTrigger = 0;
            _previousSpeed = Sequence.Speed;

        }

        protected override void OnPause()
        {
            if(Application.isPlaying)
            {
                if (_source)
                    _source.Pause();

            }
            else
            {
#if UNITY_EDITOR
                UnityEditor.AudioUtility.PauseClip(_audioClip);
#endif
            }

            if (_particleSystem != null)
                _particleSystem.Pause();


            if (_animator != null)
                _animator.enabled = false;
        }

        protected override void OnResume()
        {
            if(Application.isPlaying)
            {
                if (Sequence.IsPlaying)
                {
                    if (_source)
                        _source.Play();
                }
            }
            else
            {
#if UNITY_EDITOR
                UnityEditor.AudioUtility.PlayClip(_audioClip);
#endif
            }

            if (_particleSystem != null && Sequence.IsPlayingForward)
                _particleSystem.Play(true);

            if (_animator != null)
                _animator.enabled = true;
        }

        protected override void OnFinish()
        {
            if(Application.isPlaying)
            {
                if (_source)
                {
                    if (_source.clip == _audioClip && _source.isPlaying)
                    {
                        _source.Stop();
                        _source.clip = null;
                    }
                }
            }
            else
            {
#if UNITY_EDITOR
                UnityEditor.AudioUtility.StopClip(_audioClip);
#endif
            }


            if (_animator && (IsLastEvent || _track.GetEvent(GetId() + 1).Start != End))
            {
                _animator.SetLayerWeight(0, 0);
                _animator.enabled = false;
            }

            if (_particleSystem != null)
                _particleSystem.Stop(true);

            if (_effectGo != null)
            {
                GameObject.DestroyImmediate(_effectGo);
                _effectGo = null;
            }
        }

        protected override void OnStop()
        {
            if(Application.isPlaying)
            {
                if (_source)
                {
                    if (_source.clip == _audioClip && _source.isPlaying)
                    {
                        _source.Stop();
                        _source.clip = null;
                    }
                }
            }
            else
            {
#if UNITY_EDITOR
                UnityEditor.AudioUtility.StopClip(_audioClip);
#endif
            }


            int id = GetId();

            if (_animator && (id == 0 || _track.GetEvent(id - 1).End != Start))
            {
                _animator.Play("f_idle", 0);
                _animator.Update(0);
            }

            if (_particleSystem != null)
            {
                _particleSystem.Stop(true);
                _particleSystem.Clear(true);
            }

            if (_effectGo != null)
            {
                GameObject.DestroyImmediate(_effectGo);
                _effectGo = null;
            }
        }

        protected override void OnUpdateEvent(float timeSinceTrigger)
        {
            float delta = timeSinceTrigger - _previousTimeSinceTrigger;
            _previousTimeSinceTrigger = timeSinceTrigger;

            if (_animator != null)
            {
                if (!_animator.enabled)
                    _animator.enabled = true;

                if(delta > 0)
                {
                    _animator.SetFloat("moveSpeed", 1);
                    _animator.Update(delta);
                }
                else if(delta < 0)
                {
                    _animator.SetFloat("moveSpeed", -1);
                    _animator.Update(-delta);
                }
            }


            if (_particleSystem != null)
            {
                if (!Sequence.IsPlaying || !Sequence.IsPlayingForward)
                {
                    _previousSpeed = 1;
                    ParticleSystem.MainModule mainModule = _particleSystem.main;
                    mainModule.simulationSpeed = _previousSpeed;
                    if (Sequence.IsPlayingForward && delta > 0)
                    {
                        _particleSystem.Simulate(delta, true, false);
                    }
                }
                else if (_previousSpeed != Sequence.Speed)
                {
                    _previousSpeed = Sequence.Speed;
                    ParticleSystem.MainModule mainModule = _particleSystem.main;
                    mainModule.simulationSpeed = Mathf.Abs(_previousSpeed);
                }
            }
        }

        public override int GetMaxLength()
        {
            return base.GetMaxLength();
        }

        public override string Text
        {
            get { return "引导动作"; }
            set { }
        }


        public override SecurityElement SaveToXml()
        {
            SecurityElement node =  base.SaveToXml();

            SecurityElement paramNode = WriteParamNode("animName", _animName, "string");
            if (paramNode != null)
                node.AddChild(paramNode);

            paramNode = WriteParamNode("hiteffect", _effectId.ToString(), "int");
            node.AddChild(paramNode);

            if(_effectPrefab!=null)
            {
#if UNITY_EDITOR
                paramNode = WriteParamNode("effectPrefab", UnityEditor.AssetDatabase.GetAssetPath(_effectPrefab), "string");
                node.AddChild(paramNode);
#endif
            }

            paramNode = WriteParamNode("effectLink", _effectLink, "string");
            if (paramNode != null)
                node.AddChild(paramNode);

            if (_audioClip != null)
            {
#if UNITY_EDITOR
                string audioPath = UnityEditor.AssetDatabase.GetAssetPath(_audioClip);
                string relativeName = FileUtils.RemoveParent(Constants.FightAudioPath, audioPath);

                paramNode = WriteParamNode("sound", relativeName, "string");
                node.AddChild(paramNode);

                paramNode = WriteParamNode("soundPath", audioPath, "string");
                node.AddChild(paramNode);
#endif
            }

            return node;
        }

        public override void LoadFromXml(SecurityElement eventNode)
        {
            base.LoadFromXml(eventNode);

            _animName = GetSParam("animName");
            _effectId = GetNParam("hiteffect");
            string effectPrefab = GetSParam("effectPrefab");
            if (!string.IsNullOrEmpty(effectPrefab))
            {
#if UNITY_EDITOR
                _effectPrefab = UnityEditor.AssetDatabase.LoadAssetAtPath<GameObject>(effectPrefab);
#endif
            }
            _effectLink = GetSParam("effectLink");

            string soundPath = GetSParam("soundPath");
            if (!string.IsNullOrEmpty(soundPath))
            {
#if UNITY_EDITOR
                _audioClip = UnityEditor.AssetDatabase.LoadAssetAtPath<AudioClip>(soundPath);
#endif
            }
        }
    }
}
