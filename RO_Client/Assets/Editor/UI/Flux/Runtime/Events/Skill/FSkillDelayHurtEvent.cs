using System.Collections;
using System.Collections.Generic;
using System.Security;
using UnityEngine;

namespace Flux
{
    [FEvent("Skill/伤害相关/延迟伤害")]
    public class FSkillDelayHurtEvent :FEvent
    {
        [SerializeField]
        private AudioClip _hitSoundClip = null;
        public AudioClip HitSoundClip
        {
            get { return _hitSoundClip; }
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
        private string _hitEffectLink = null;
        public string HitEffectLink
        {
            get { return _hitEffectLink; }
        }

        [HideInInspector]
        [SerializeField]
        private int _hurtDelayFrame = 0;
        public int HurtDelayFrame
        {
            get { return _hurtDelayFrame; }
        }

        [HideInInspector]
        [SerializeField]
        private int _delayHurtInterval = 0;
        public int DelayHurtInterval
        {
            get { return _delayHurtInterval; }
        }

        [HideInInspector]
        [SerializeField]
        private int _delayHurtCount = 0;
        public int DelayHurtCount
        {
            get { return _delayHurtCount; }
        }


        private int _leftFrame = 0;
        private int _hitCnt = 0;
  
        private AudioSource _source;
        private GameObject hitEffectGo = null;
        private ParticleSystem _hitPs = null;

        private float _previousTimeSinceTrigger = 0;
        private float _previousSpeed = 0;


        public FSkillDelayHurtEvent()
        {
            _eventType = SkillActionFrameEventType.FE_Delay_Hurt;
        }

        protected override void OnTrigger(float timeSinceTrigger)
        {
            _leftFrame = _hurtDelayFrame;
            _hitCnt = 0;
            _previousTimeSinceTrigger = timeSinceTrigger;
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
                UnityEditor.AudioUtility.PauseClip(_hitSoundClip);
#endif
            }
    

           if(_hitPs!=null)
            {
                _hitPs.Pause(true);
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
                UnityEditor.AudioUtility.PlayClip(_hitSoundClip);
#endif
            }


            if (_hitPs != null)
            {
                _hitPs.Play(true);
            }
        }

        protected override void OnFinish()
        {
            if (Application.isPlaying)
            {
                if (_source)
                {
                    if (_source.clip == _hitSoundClip && _source.isPlaying)
                    {
                        _source.Stop();
                        _source.clip = null;
                    }
                }
            }
            else
            {
#if UNITY_EDITOR
                UnityEditor.AudioUtility.StopClip(_hitSoundClip);
#endif
            }


            if (hitEffectGo != null)
            {
                GameObject.DestroyImmediate(hitEffectGo);
                hitEffectGo = null;
            }
        }

        protected override void OnStop()
        {
            if(Application.isPlaying)
            {
                if (_source)
                {
                    if (_source.clip == _hitSoundClip && _source.isPlaying)
                    {
                        _source.Stop();
                        _source.clip = null;
                    }
                }
            }
            else
            {
#if UNITY_EDITOR
                UnityEditor.AudioUtility.StopClip(_hitSoundClip);
#endif
            }


            if (hitEffectGo != null)
            {
                GameObject.DestroyImmediate(hitEffectGo);
                hitEffectGo = null;
            }
        }

        public override int GetMaxLength()
        {
            return base.GetMaxLength();
        }

        public override string Text
        {
            get { return "延迟伤害"; }
            set { }
        }

        protected override void OnUpdateEvent(float timeSinceTrigger)
        {
            float delta = timeSinceTrigger - _previousTimeSinceTrigger;
            _previousTimeSinceTrigger = timeSinceTrigger;

            bool restart = false;

            if (_hitCnt < _delayHurtCount)
            {
                if (_leftFrame == 0)
                {
                    restart = true;
                    ExecuteHit();
                }
                else
                {
                    _leftFrame--;
                }
            }

            if (_hitPs && !Sequence.IsPlaying || !Sequence.IsPlayingForward)
            {
                _previousSpeed = 1;
                ParticleSystem.MainModule mainModule = _hitPs.main;
                mainModule.simulationSpeed = _previousSpeed;
                if (Sequence.IsPlayingForward && delta > 0)
                {
                    _hitPs.Simulate(delta, true, restart);
                }
            }
            else if (_previousSpeed != Sequence.Speed)
            {
                _previousSpeed = Sequence.Speed;
                ParticleSystem.MainModule mainModule = _hitPs.main;
                mainModule.simulationSpeed = Mathf.Abs(_previousSpeed);
            }
        }

        private void ExecuteHit()
        {
            _hitCnt++;
            _leftFrame = _delayHurtInterval;

            _source = Owner.GetComponent<AudioSource>();
            if (_source == null)
                _source = Owner.gameObject.AddComponent<AudioSource>();

            _source.volume = 1;
            _source.loop = false;
            _source.clip = _hitSoundClip;

            if (Sequence.IsPlaying)
                _source.Play();

            if (_hitEffectPrefab != null)
            {
                Vector3 pos = _targetTrans.position;
                Transform hitPoint = UnityEngineUtils.RecurisiveFindTransformChild(_targetTrans, _hitEffectLink);
                if (hitPoint != null)
                {
                    pos = hitPoint.position;
                }

                if(hitEffectGo!=null)
                {
                    GameObject.DestroyImmediate(hitEffectGo);
                    hitEffectGo = null;
                }

                hitEffectGo = (GameObject)Instantiate(_hitEffectPrefab);
                hitEffectGo.transform.SetParent(hitPoint);
                hitEffectGo.transform.localPosition = Vector3.zero;
                hitEffectGo.transform.localScale = Vector3.one;
                hitEffectGo.transform.localRotation = Quaternion.identity;

                _hitPs = hitEffectGo.GetComponentInChildren<ParticleSystem>();
                if (_hitPs != null)
                {
                    ParticleSystem.MainModule mainModule = _hitPs.main;
                    mainModule.simulationSpeed = Sequence.Speed;

                    if (Sequence.IsPlaying && Sequence.IsPlayingForward)
                    {
                        _hitPs.Play(true);
                    }    
                }
            }  
        }

        public override SecurityElement SaveToXml()
        {
            SecurityElement node =  base.SaveToXml();

            SecurityElement paramNode = WriteParamNode("delay_hurt_count", _delayHurtCount.ToString(), "int");
            node.AddChild(paramNode);

            paramNode = WriteParamNode("delay_hurt_interval", _delayHurtInterval.ToString(), "int");
            node.AddChild(paramNode);

            paramNode = WriteParamNode("hurt_delay_frame", _hurtDelayFrame.ToString(), "int");
            node.AddChild(paramNode);

            paramNode = WriteParamNode("effect", _hitEffectId.ToString(), "int");
            node.AddChild(paramNode);

            if (_hitEffectPrefab != null)
            {
#if UNITY_EDITOR
                paramNode = WriteParamNode("effectPrefab", UnityEditor.AssetDatabase.GetAssetPath(_hitEffectPrefab), "string");
                node.AddChild(paramNode);
#endif
            }

            paramNode = WriteParamNode("effectLink", _hitEffectLink, "string");
            if (paramNode != null)
                node.AddChild(paramNode);

            if (_hitSoundClip != null)
            {
#if UNITY_EDITOR
                string audioPath = UnityEditor.AssetDatabase.GetAssetPath(_hitSoundClip);
                string relativeName = FileUtils.RemoveParent(Constants.FightAudioPath, audioPath);

                paramNode = WriteParamNode("hitsound", relativeName, "string");
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


            _delayHurtCount = GetNParam("delay_hurt_count");
            _delayHurtInterval = GetNParam("delay_hurt_interval");
            _hurtDelayFrame = GetNParam("hurt_delay_frame");
            _hitEffectId = GetNParam("effect");

            string effectPrefab = GetSParam("effectPrefab");
            if (!string.IsNullOrEmpty(effectPrefab))
            {
#if UNITY_EDITOR
                _hitEffectPrefab = UnityEditor.AssetDatabase.LoadAssetAtPath<GameObject>(effectPrefab);
#endif
            }

            _hitEffectLink = GetSParam("effectLink");

            string soundPath = GetSParam("soundPath");

            if (!string.IsNullOrEmpty(soundPath))
            {
#if UNITY_EDITOR
                _hitSoundClip = UnityEditor.AssetDatabase.LoadAssetAtPath<AudioClip>(soundPath);
#endif
            }
        }
    }
}
