using System.Collections;
using System.Collections.Generic;
using System.Security;
using UnityEngine;

namespace Flux
{
    [FEvent("Skill/伤害相关/打击点")]
    public class FSkillHitEvent : FEvent
    {
        [HideInInspector]
        [Tooltip("What's the offset from where we play the animation?")]
        public int _startOffset;

        [SerializeField]
        private AudioClip _audioClip = null;
        public AudioClip AudioClip
        {
            get { return _audioClip; }
        }

        [HideInInspector]
        [SerializeField]
        private int _hitEffectId;
        public int HitEffectId
        {
            get { return _hitEffectId; }
        }

        [HideInInspector]
        [SerializeField]
        private GameObject _hitEffectPrefab = null;
        public GameObject HitEffectPrefab
        {
            get { return _hitEffectPrefab; }
        }

        [HideInInspector]
        [SerializeField]
        private string _hitEffectLink;
        public string HitEffectLink
        {
            get { return _hitEffectLink; }
        }

        [HideInInspector]
        [SerializeField]
        private int _moveType = 0;
        public int MoveType
        {
            get { return _moveType; }
        }

        [HideInInspector]
        [SerializeField]
        private float _initSpeed;
        public float InitSpeed
        {
            get { return _initSpeed; }
        }

        [HideInInspector]
        [SerializeField]
        private float _acceleration = 0;
        public float Acceleration
        {
            get { return _acceleration; }
        }

        [HideInInspector]
        [SerializeField]
        private float _moveDistance = 0;
        public float MoveDistance
        {
            get { return _moveDistance; }
        }

        [HideInInspector]
        [SerializeField]
        private int _triggerBuffId;
        public int TriggerBuffId
        {
            get { return _triggerBuffId; }
        }

        [HideInInspector]
        [SerializeField]
        private int _triggerBuffRate;
        public int TriggerBuffRate
        {
            get { return _triggerBuffRate; }
        }

        private AudioSource _source;
        private ParticleSystem _particleSystem = null;
        private GameObject _effectGo = null;
        private Animator[] effectAnimators;

        private float _previousTimeSinceTrigger = 0;
        private float _previousSpeed = 0;
        private MoveProcessor _moveProcessor;
        private Vector3 _destPos;
        private Vector3 _targetPos;


        public FSkillHitEvent()
        {
            _eventType = SkillActionFrameEventType.FE_Hit;
        }

        protected override void OnSetDefaultValues()
        {
            base.OnSetDefaultValues();
        }

        protected override void OnTrigger(float timeSinceTrigger)
        {
            if(Application.isPlaying)
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

            if (_targetTrans != null)
            {
                FighterMoveType type = (FighterMoveType)_moveType;
                if (type != FighterMoveType.None)
                {
                    _moveProcessor = new MoveProcessor(_targetTrans);

                    if (type == FighterMoveType.Beat_Back)
                    {
                        Vector3 dir = (_targetTrans.position - _casterTrans.position).normalized;
                        dir.y = 0;
                        _destPos = dir * _moveDistance + _targetTrans.position;
                    }
                    else if (type == FighterMoveType.Beat_Fly)
                    {
                        Vector3 dir = Vector3.up;
                        _destPos = dir * _moveDistance + _targetTrans.position;
                    }
                }
            }

            effectAnimators = null;
            if (_hitEffectPrefab != null)
            {
                Vector3 pos = _targetTrans.position;
                Transform hitPoint = UnityEngineUtils.RecurisiveFindTransformChild(_targetTrans, _hitEffectLink);
                if (hitPoint != null)
                {
                    pos = hitPoint.position;
                }

                _effectGo = (GameObject)Instantiate(_hitEffectPrefab);
                _effectGo.transform.SetParent(hitPoint);
                _effectGo.transform.localPosition = Vector3.zero;
                _effectGo.transform.localScale = Vector3.one;
                _effectGo.transform.localRotation = Quaternion.identity;

                _particleSystem = _effectGo.GetComponentInChildren<ParticleSystem>();
                if (_particleSystem != null)
                {
                    ParticleSystem.MainModule mainModule = _particleSystem.main;
                    mainModule.simulationSpeed = Sequence.Speed;

                    effectAnimators = _effectGo.GetComponentsInChildren<Animator>();
                }
            }

            if (effectAnimators != null && effectAnimators.Length > 0)
            {
                for (int aid = 0; aid < effectAnimators.Length; aid++)
                {
                    var animator = effectAnimators[aid];
                    animator.enabled = true;
                    animator.SetLayerWeight(0, 1);
                    animator.Update(0f);
                }
            }

            if (_particleSystem != null && Sequence.IsPlaying && Sequence.IsPlayingForward)
                _particleSystem.Play(true);

            if(_targetTrans!=null)
            {
                _targetPos = _targetTrans.position;
            }

            if (_moveProcessor != null)
            {
                _moveProcessor.Start(_initSpeed, _acceleration, _destPos);
                _previousTimeSinceTrigger = timeSinceTrigger;
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

            if (effectAnimators != null && effectAnimators.Length > 0)
            {
                for (int idx = 0; idx < effectAnimators.Length; idx++)
                    effectAnimators[idx].enabled = false;
            }
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
            {
                _particleSystem.Play(true);
                if (effectAnimators != null && effectAnimators.Length > 0)
                {
                    for (int idx = 0; idx < effectAnimators.Length; idx++)
                        effectAnimators[idx].enabled = true;
                }
            }       
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

            if (effectAnimators != null && effectAnimators.Length > 0)
            {
                for (int idx = 0; idx < effectAnimators.Length; idx++)
                {
                    effectAnimators[idx].SetLayerWeight(0, 0);
                    effectAnimators[idx].enabled = false;
                }
            }

            if (_particleSystem != null)
                _particleSystem.Stop(true);

            if (_effectGo != null)
            {
                GameObject.DestroyImmediate(_effectGo);
                _effectGo = null;
            }

            if(_targetTrans!=null)
            {
                _targetTrans.position = _targetPos;
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

            if (_particleSystem != null)
            {
                _particleSystem.Stop(true);
                _particleSystem.Clear(true);
            }

            if (_effectGo != null)
            {
                if (effectAnimators != null)
                {
                    for (int idx = 0; idx < effectAnimators.Length; idx++)
                    {
                        effectAnimators[idx].SetLayerWeight(0, 0);
                        effectAnimators[idx].enabled = false;
                    }
                }

                GameObject.DestroyImmediate(_effectGo);
                _effectGo = null;
            }

            if (_targetTrans != null)
            {
                _targetTrans.position = _targetPos;
            }
        }

        protected override void OnUpdateEvent(float timeSinceTrigger)
        {
            float delta = timeSinceTrigger - _previousTimeSinceTrigger;
            _previousTimeSinceTrigger = timeSinceTrigger;

            if (_source != null && _source.clip != null)
            {
                _source.PlayScheduled(delta);
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

                if (effectAnimators != null && effectAnimators.Length > 0)
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
                }
            }

            if (_moveProcessor != null)
            {
                _moveProcessor.Update(delta);
            }
        }

        public override int GetMaxLength()
        {
            return base.GetMaxLength();
        }

        public override string Text
        {
            get { return "打击点"; }
            set { }
        }

        public override SecurityElement SaveToXml()
        {
            SecurityElement node =  base.SaveToXml();

            SecurityElement paramNode = WriteParamNode("hiteffect", _hitEffectId.ToString(), "int");
            node.AddChild(paramNode);

            if (_hitEffectPrefab != null)
            {
#if UNITY_EDITOR
                paramNode = WriteParamNode("hitEffectPrefab", UnityEditor.AssetDatabase.GetAssetPath(_hitEffectPrefab), "string");
                node.AddChild(paramNode);
#endif
            }

            paramNode = WriteParamNode("hitEffectLink", _hitEffectLink, "string");
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

            paramNode = WriteParamNode("buffid", _triggerBuffId.ToString(), "int");
            node.AddChild(paramNode);

            paramNode = WriteParamNode("rate", _triggerBuffRate.ToString(), "int");
            node.AddChild(paramNode);

            paramNode = WriteParamNode("moveType", _moveType.ToString(),"int");
            node.AddChild(paramNode);

            paramNode = WriteParamNode("initSpeed", ((int)(_initSpeed * 100)).ToString(), "int");
            node.AddChild(paramNode);

            paramNode = WriteParamNode("acceleration", ((int)(_acceleration * 100)).ToString(), "int");
            node.AddChild(paramNode);

            paramNode = WriteParamNode("moveDist", ((int)(_moveDistance*100)).ToString(), "int");
            node.AddChild(paramNode);

            return node;
        }

        public override void LoadFromXml(SecurityElement eventNode)
        {
            base.LoadFromXml(eventNode);


            int.TryParse(eventNode.Attribute(""), out _hitEffectId);


            _hitEffectId = GetNParam("hiteffect");
            _triggerBuffId = GetNParam("buffid");
            _triggerBuffRate = GetNParam("rate");
            _moveType = GetNParam("moveType");
            _initSpeed = GetNParam("initSpeed") * 0.01f;
            _acceleration = GetNParam("acceleration") * 0.01f;
            _moveDistance = GetNParam("moveDist") * 0.01f;

            string hitEffectPrefab = GetSParam("hitEffectPrefab");
            if (!string.IsNullOrEmpty(hitEffectPrefab))
            {
#if UNITY_EDITOR
                _hitEffectPrefab = UnityEditor.AssetDatabase.LoadAssetAtPath<GameObject>(hitEffectPrefab);
#endif
            }

            _hitEffectLink = GetSParam("hitEffectLink");


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