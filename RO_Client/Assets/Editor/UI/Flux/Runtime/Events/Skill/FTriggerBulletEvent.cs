using System.Collections;
using System.Collections.Generic;
using System.Security;
using UnityEngine;

namespace Flux
{
    [FEvent("Skill/伤害相关/发射子弹")]
    public class FTriggerBulletEvent : FEvent
    {
        [SerializeField]
        private AudioClip _soundClip = null;
        public AudioClip SoundClip { get { return _soundClip; } }

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
        private GameObject _bulletPrefab = null;        //子弹预制体
        public GameObject BulletPrefab
        {
            get { return _bulletPrefab; }
        }

        [HideInInspector]
        [SerializeField]
        private int _bulletId;
        public int BulletId
        {
            get { return _bulletId; }
        }

        [HideInInspector]
        [SerializeField]
        private string _bulletLink = null;      //子弹挂载点
        public string BulletLink
        {
            get { return _bulletLink; }
        }

        [HideInInspector]
        [SerializeField]
        private float _bulletFlyDuration = 0;
        public float BulletFlyDuration
        {
            get { return _bulletFlyDuration; }
        }

        [HideInInspector]
        [SerializeField]
        private Vector3 _bulletInitVelocity;
        public Vector3 BulletInitVelocity
        {
            get { return _bulletInitVelocity; }
        }

        [HideInInspector]
        [SerializeField]
        private Vector3 _bulletAcceleration;
        public Vector3 BulletAcceleration
        {
            get { return _bulletAcceleration; }
        }

        [HideInInspector]
        [SerializeField]
        private float _bulletAccelerationTime;
        public float BulletAccelerationTime
        {
            get { return _bulletAccelerationTime; }
        }

        [HideInInspector]
        [SerializeField]
        private string _bulletTargetLink;
        public string BulletTargetLink
        {
            get { return _bulletTargetLink; }
        }

        [HideInInspector]
        [SerializeField]
        private Vector3 _range;
        public Vector3 Range
        {
            get { return _range; }
        }

        [HideInInspector]
        [SerializeField]
        private int _moveType;
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
        private float _acceleration;
        public float Acceleration
        {
            get { return _acceleration; }
        }

        [HideInInspector]
        [SerializeField]
        private float _moveDistance;
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


        private GameObject _bulletGo;
        private ParticleSystem _bulletParticleSystem;
        private Animator _bulletAnimator;

        private GameObject _hitEffectGo;
        private ParticleSystem _hitParticleSystem;

        private Transform _bulletTrans;
        private Vector3 mStartOffset;               //开始偏移位置
        private Vector3 mTargetOffset;              //目标偏移位置

        private AudioSource _source;
        private MoveProcessor _beHitMoveProcessor;
        private BulletEventMoveProcessor _bulletMoveProcessor = null;

        private Vector3 _beHitDestPos;
        private float moveSpeed = 0;

        private float _lifeTime = 0;
        private float _previousTimeSinceTrigger = 0;
        private float _previousSpeed = 0;
        private Vector3 _targetPos;

        public FTriggerBulletEvent()
        {
            _eventType = SkillActionFrameEventType.FE_Bullet;
        }

        protected override void OnSetDefaultValues()
        {
            base.OnSetDefaultValues();
        }

        protected override void OnTrigger(float timeSinceTrigger)
        {
            if (_targetTrans != null)
            {
                FighterMoveType type = (FighterMoveType)_moveType;
                if (type != FighterMoveType.None)
                {
                    _beHitMoveProcessor = new MoveProcessor(_targetTrans);

                    if (type == FighterMoveType.Beat_Back)
                    {
                        Vector3 dir = (_targetTrans.position - _casterTrans.position).normalized;
                        dir.y = 0;
                        _beHitDestPos = dir * _moveDistance + _targetTrans.position;
                    }
                    else if (type == FighterMoveType.Beat_Fly)
                    {
                        Vector3 dir = Vector3.up;
                        _beHitDestPos = dir * _moveDistance + _targetTrans.position;
                    }
                }
            }

            if (_bulletPrefab != null)
            {
                _bulletGo = (GameObject)Instantiate(_bulletPrefab);
                _bulletTrans = _bulletGo.transform;

                Vector3 startForward = _targetTrans != null ? (_targetTrans.position - _casterTrans.position).normalized : Vector3.forward;
                SetStartTransform(startForward);

                if (_bulletFlyDuration > 0 && _targetTrans != null)
                    moveSpeed = Vector3.Distance(_targetTrans.position, _casterTrans.position) / _bulletFlyDuration;

                _bulletParticleSystem = _bulletGo.GetComponentInChildren<ParticleSystem>();
                if (_bulletParticleSystem != null)
                {
                    ParticleSystem.MainModule mainModule = _bulletParticleSystem.main;
                    mainModule.simulationSpeed = Sequence.Speed;
                }

                _bulletAnimator = _bulletGo.GetComponentInChildren<Animator>();
                if(_bulletAnimator!=null)
                {
                    _bulletAnimator.enabled = true;
                    _bulletAnimator.SetLayerWeight(0, 1);
                    if (timeSinceTrigger > 0)
                    {
                        _bulletAnimator.Update(timeSinceTrigger - 0.001f);
                    }
                    else
                    {
                        _bulletAnimator.Update(0f);
                    }
                }

                if (_targetTrans != null)
                {
                    _targetPos = _targetTrans.position;
                }

                if (_bulletMoveProcessor == null)
                {
                    _bulletMoveProcessor = new BulletEventMoveProcessor(_bulletTrans, BulletMoveType.Bullet_Move_Forward_Toward, moveSpeed, _bulletInitVelocity, _bulletAcceleration, mTargetOffset, _bulletAccelerationTime);
                }
                _bulletMoveProcessor.Start();
            }
            else
            {
                Debug.LogError("没有选择子弹的预制体");
            }

            if (_bulletParticleSystem != null && Sequence.IsPlaying && Sequence.IsPlayingForward)
                _bulletParticleSystem.Play(true);


            _previousTimeSinceTrigger = timeSinceTrigger;
            _previousSpeed = Sequence.Speed;
            _lifeTime = _bulletFlyDuration;
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
                UnityEditor.AudioUtility.PauseClip(_soundClip);
#endif
            }


            if (_hitParticleSystem != null)
                _hitParticleSystem.Pause();

            if (_bulletParticleSystem != null)
                _bulletParticleSystem.Pause();

            if (_bulletAnimator != null)
                _bulletAnimator.enabled = false;
        }

        protected override void OnResume()
        {
            if (Sequence.IsPlaying)
            {
                if(Application.isPlaying)
                {
                    if (_source)
                        _source.Play();
                }
                else
                {
#if UNITY_EDITOR
                    UnityEditor.AudioUtility.PlayClip(_soundClip);
#endif
                }
            }

            if (_hitParticleSystem != null && Sequence.IsPlayingForward)
                _hitParticleSystem.Play(true);

            if (_bulletParticleSystem != null && Sequence.IsPlayingForward)
                _bulletParticleSystem.Play(true);

            if (_bulletAnimator != null)
                _bulletAnimator.enabled = true;
        }

        protected override void OnFinish()
        {
            if(Application.isPlaying)
            {
                if (_source)
                {
                    if (_source.clip == _soundClip && _source.isPlaying)
                    {
                        _source.Stop();
                        _source.clip = null;
                    }
                }
            }
            else
            {
#if UNITY_EDITOR
                UnityEditor.AudioUtility.StopClip(_soundClip);
#endif
            }


            if (_bulletMoveProcessor != null)
            {
                _bulletMoveProcessor.Stop();
                _bulletMoveProcessor = null;
            }

            if (_hitParticleSystem != null)
                _hitParticleSystem.Stop(true);

            if (_bulletParticleSystem != null)
                _bulletParticleSystem.Stop(true);

            if (_bulletAnimator && (IsLastEvent || _track.GetEvent(GetId() + 1).Start != End))
            {
                _bulletAnimator.SetLayerWeight(0, 0);
                _bulletAnimator.enabled = false;
            }

            if (_hitEffectGo != null)
            {
                GameObject.DestroyImmediate(_hitEffectGo);
                _hitEffectGo = null;
            }

            if (_bulletGo != null)
            {
                GameObject.DestroyImmediate(_bulletGo);
                _bulletGo = null;
                _bulletTrans = null;
            }

            if (_targetTrans != null)
            {
                _targetTrans.position = _targetPos;
            }
        }

        protected override void OnStop()
        {
            if (Application.isPlaying)
            {
                if (_source)
                {
                    if (_source.clip == _soundClip && _source.isPlaying)
                    {
                        _source.Stop();
                        _source.clip = null;
                    }
                }
            }
            else
            {
#if UNITY_EDITOR
                UnityEditor.AudioUtility.StopClip(_soundClip);
#endif
            }

            if (_hitParticleSystem != null)
            {
                _hitParticleSystem.Stop(true);
                _hitParticleSystem.Clear(true);
            }

            if(_bulletParticleSystem!=null)
            {
                _bulletParticleSystem.Stop(true);
                _bulletParticleSystem.Clear(true);
            }

            if (_bulletMoveProcessor != null)
            {
                _bulletMoveProcessor.Stop();
                _bulletMoveProcessor = null;
            }

            if (_bulletAnimator && (IsLastEvent || _track.GetEvent(GetId() + 1).Start != End))
            {
                _bulletAnimator.SetLayerWeight(0, 0);
                _bulletAnimator.enabled = false;
            }

            if (_bulletGo!=null)
            {
                GameObject.DestroyImmediate(_bulletGo);
                _bulletGo = null;
                _bulletTrans = null;
            }

            if (_hitEffectGo != null)
            {
                GameObject.DestroyImmediate(_hitEffectGo);
                _hitEffectGo = null;
            }

            if (_targetTrans != null)
            {
                _targetTrans.position = _targetPos;
            }
        }

        public override int GetMaxLength()
        {
            return base.GetMaxLength();
        }

        public override string Text
        {
            get { return "发射子弹"; }
            set { }
        }

        protected override void OnUpdateEvent(float timeSinceTrigger)
        {
            float delta = timeSinceTrigger - _previousTimeSinceTrigger;
            _previousTimeSinceTrigger = timeSinceTrigger;
            _lifeTime -= delta;

            if (_lifeTime > 0)
            {
                if (_bulletParticleSystem != null)
                {
                    if (!Sequence.IsPlaying || !Sequence.IsPlayingForward)
                    {
                        _previousSpeed = 1;
                        ParticleSystem.MainModule mainModule = _bulletParticleSystem.main;
                        mainModule.simulationSpeed = _previousSpeed;
                        if (Sequence.IsPlayingForward && delta > 0)
                        {
                            _bulletParticleSystem.Simulate(delta, true, false);
                        }
                    }
                    else if (_previousSpeed != Sequence.Speed)
                    {
                        _previousSpeed = Sequence.Speed;
                        ParticleSystem.MainModule mainModule = _bulletParticleSystem.main;
                        mainModule.simulationSpeed = Mathf.Abs(_previousSpeed);
                    }
                }

                if (_bulletMoveProcessor != null)
                {
                    _bulletMoveProcessor.Update(delta);

                    CheckFlyBulletHit();
                }

                if (_bulletAnimator != null)
                {
                    if (!_bulletAnimator.enabled)
                        _bulletAnimator.enabled = true;

                    if (delta > 0)
                    {
                        _bulletAnimator.Update(delta);
                        _previousTimeSinceTrigger = timeSinceTrigger;
                    }
                }
            }

            if (_source != null && _source.clip != null)
            {
                _source.PlayScheduled(delta);
            }

            if (_hitParticleSystem != null)
            {
                if (!Sequence.IsPlaying || !Sequence.IsPlayingForward)
                {
                    _previousSpeed = 1;
                    ParticleSystem.MainModule mainModule = _hitParticleSystem.main;
                    mainModule.simulationSpeed = _previousSpeed;
                    if (Sequence.IsPlayingForward && delta > 0)
                    {
                        _hitParticleSystem.Simulate(delta, true, false);
                    }
                }
                else if (_previousSpeed != Sequence.Speed)
                {
                    _previousSpeed = Sequence.Speed;
                    ParticleSystem.MainModule mainModule = _hitParticleSystem.main;
                    mainModule.simulationSpeed = Mathf.Abs(_previousSpeed);
                }
            }

            if (_beHitMoveProcessor != null)
            {
                _beHitMoveProcessor.Update(delta);
            }
        }

        private void SetStartTransform(Vector3 startForward)
        {
            Transform linkTrans = UnityEngineUtils.RecurisiveFindTransformChild(_casterTrans,_bulletLink);
            if(linkTrans!=null)
            {
                mStartOffset = linkTrans.position;
            }

            if (_targetTrans != null)
            {
                linkTrans = UnityEngineUtils.RecurisiveFindTransformChild(_targetTrans, _bulletTargetLink);
                if (linkTrans != null)
                {
                    mTargetOffset = linkTrans.position;
                }
            }

            _bulletTrans.position = mStartOffset;
            _bulletTrans.forward = startForward;
        }

        private void CheckFlyBulletHit()
        {
            if (CheckHitTarget())
            {
                ProcessHitFighter();
                DestroyBullet();
            }
        }

        private void ProcessHitFighter()
        {
            if(Application.isPlaying)
            {
                _source = Owner.GetComponent<AudioSource>();
                if (_source == null)
                    _source = Owner.gameObject.AddComponent<AudioSource>();

                _source.volume = 1;
                _source.loop = false;
                _source.clip = _soundClip;

                if (Sequence.IsPlaying)
                    _source.Play();

            }
            else
            {
#if UNITY_EDITOR
                UnityEditor.AudioUtility.PlayClip(_soundClip);
#endif
            }

            if (_hitEffectPrefab != null)
            {
                Vector3 pos = _targetTrans.position;
                Transform hitPoint = UnityEngineUtils.RecurisiveFindTransformChild(_targetTrans, _hitEffectLink);
                if(hitPoint!=null)
                {
                    pos = hitPoint.position;
                }

                _hitEffectGo = (GameObject)Instantiate(_hitEffectPrefab);
                _hitEffectGo.transform.SetParent(hitPoint);
                _hitEffectGo.transform.localPosition = Vector3.zero;
                _hitEffectGo.transform.localScale = Vector3.one;
                _hitEffectGo.transform.localRotation = Quaternion.identity;



                _hitParticleSystem = _hitEffectGo.GetComponentInChildren<ParticleSystem>();
                if (_hitParticleSystem != null)
                {
                    ParticleSystem.MainModule mainModule = _hitParticleSystem.main;
                    mainModule.simulationSpeed = Sequence.Speed;
                }
            }

            if (_hitParticleSystem != null && Sequence.IsPlaying && Sequence.IsPlayingForward)
                _hitParticleSystem.Play(true);


            if (_beHitMoveProcessor != null)
            {
                _beHitMoveProcessor.Start(_initSpeed, _acceleration, _beHitDestPos);
            }
        }

        private bool CheckHitTarget()
        {
            if (_targetTrans != null)
            {
                Vector3 offset = mTargetOffset - _bulletTrans.position;
                return Mathf.Abs(offset.x) <= _range.x && Mathf.Abs(offset.y) <= _range.y && Mathf.Abs(offset.z) <= _range.z;
            }
            return false;
        }

        private void DestroyBullet()
        {
            if (_bulletParticleSystem != null)
            {
                _bulletParticleSystem.Stop(true);
                _bulletParticleSystem.Clear(true);
            }


            _bulletMoveProcessor.Stop();
            _bulletMoveProcessor = null;

            if (_bulletGo != null)
            {
                GameObject.DestroyImmediate(_bulletGo);
                _bulletGo = null;
                _bulletTrans = null;
            }
        }


        public override SecurityElement SaveToXml()
        {
            SecurityElement node =  base.SaveToXml();

            SecurityElement paramNode = WriteParamNode("bulletid", _bulletId.ToString(), "int");
            node.AddChild(paramNode);

            if (_bulletPrefab != null)
            {
#if UNITY_EDITOR
                paramNode = WriteParamNode("bulletPrefab", UnityEditor.AssetDatabase.GetAssetPath(_bulletPrefab), "string");
                node.AddChild(paramNode);
#endif
            }

            paramNode = WriteParamNode("bulletLink",_bulletLink, "string");
            if (paramNode != null)
                node.AddChild(paramNode);

            paramNode = WriteParamNode("bulletTargetLink", _bulletTargetLink, "string");
            if (paramNode != null)
                node.AddChild(paramNode);

            paramNode = WriteParamNode("bulletFlyDuration", _bulletFlyDuration.ToString(), "string");
            node.AddChild(paramNode);

            paramNode = WriteParamNode("bulletInitVelocity", StringUtil.ConvertVector2Str(_bulletInitVelocity), "string");
            node.AddChild(paramNode);

            paramNode = WriteParamNode("bulletAcceleration", StringUtil.ConvertVector2Str(_bulletAcceleration), "string");
            node.AddChild(paramNode);

            paramNode = WriteParamNode("bulletAccelerationTime", _bulletAccelerationTime.ToString(), "string");
            node.AddChild(paramNode);

            paramNode = WriteParamNode("bulletTargetLink", _bulletTargetLink, "string");
            if(paramNode!=null)
                node.AddChild(paramNode);

            paramNode = WriteParamNode("range", StringUtil.ConvertVector2Str(_range), "string");
            node.AddChild(paramNode);


            paramNode = WriteParamNode("hiteffect", _hitEffectId.ToString(), "int");
            node.AddChild(paramNode);

            if(_hitEffectPrefab!=null)
            {
#if UNITY_EDITOR
                paramNode = WriteParamNode("hitEffectPrefab", UnityEditor.AssetDatabase.GetAssetPath(_hitEffectPrefab), "string");
                node.AddChild(paramNode);
#endif
            }

            paramNode = WriteParamNode("hitEffectLink", _hitEffectLink, "string");
            if (paramNode != null)
                node.AddChild(paramNode);


            if (_soundClip != null)
            {
#if UNITY_EDITOR
                string audioPath = UnityEditor.AssetDatabase.GetAssetPath(_soundClip);
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

            paramNode = WriteParamNode("moveType", _moveType.ToString(), "int");
            node.AddChild(paramNode);

            paramNode = WriteParamNode("initSpeed", ((int)(_initSpeed * 100)).ToString(), "int");
            node.AddChild(paramNode);

            paramNode = WriteParamNode("acceleration", ((int)(_acceleration * 100)).ToString(), "int");
            node.AddChild(paramNode);

            paramNode = WriteParamNode("moveDist", ((int)(_moveDistance * 100)).ToString(), "int");
            node.AddChild(paramNode);

            return node;
        }

        public override void LoadFromXml(SecurityElement eventNode)
        {
            base.LoadFromXml(eventNode);

            _bulletId = GetNParam("bulletid");

            string bulletPrefab = GetSParam("bulletPrefab");
            if(!string.IsNullOrEmpty(bulletPrefab))
            {
#if UNITY_EDITOR
                _bulletPrefab = UnityEditor.AssetDatabase.LoadAssetAtPath<GameObject>(bulletPrefab);
#endif
            }

            _bulletLink = GetSParam("bulletLink");
            _bulletTargetLink = GetSParam("bulletTargetLink");

            _bulletFlyDuration = GetFParam("bulletFlyDuration");

            _bulletInitVelocity = GetVParam("bulletInitVelocity");
            _bulletAcceleration = GetVParam("bulletAcceleration");

            _bulletAccelerationTime = GetFParam("bulletAccelerationTime");
            _range = GetVParam("range");

            _hitEffectId = GetNParam("hiteffect");

            string hitEffectPrefab = GetSParam("hitEffectPrefab");
            if(!string.IsNullOrEmpty(hitEffectPrefab))
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
                _soundClip = UnityEditor.AssetDatabase.LoadAssetAtPath<AudioClip>(soundPath);
#endif
            }

            _triggerBuffId = GetNParam("buffid");
            _triggerBuffRate = GetNParam("rate");
            _moveType = GetNParam("moveType");
            _initSpeed = GetNParam("initSpeed") * 0.01f;
            _acceleration = GetNParam("acceleration") * 0.01f;
            _moveDistance = GetNParam("moveDist") * 0.01f;
        }
    }
}