using UnityEngine;
using System.Collections;
using System.Security;

namespace Flux
{
    [FEvent("Skill/动作相关/播放技能动作")]
    public class FPlayAnimEvent : FEvent
    {
        [HideInInspector]
        [SerializeField]
        private string _animName;

        [HideInInspector]
        [SerializeField]
        private int _animSpeed = 100;

        public string AnimName
        {
            get { return _animName; }
            set { _animName = value; }
        }

        public int AnimSpeed
        {
            get { return _animSpeed; }
            set { _animSpeed = value; }
        }

        private Animator _animator = null;
        public Animator animator
        {
            get { return _animator; }
        }

        private float _previousTimeSinceTrigger = 0;
        private float _previousSpeed = 0;

        public FPlayAnimEvent()
        {
            _eventType = SkillActionFrameEventType.FE_PlaySkillAnim;
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
            if(_animator!=null)
                _animator.enabled = false;
        }

        protected override void OnTrigger(float timeSinceTrigger)
        {
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
                        // - 0.001f because if you pass the length of the animation
                        // it seems that it will go over it and miss the condition
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
            if (_animator != null)
                _animator.enabled = false;
        }

        protected override void OnResume()
        {
            if (_animator != null)
                _animator.enabled = true;
        }

        protected override void OnFinish()
        {
            if (_animator && (IsLastEvent || _track.GetEvent(GetId() + 1).Start != End))
            {
                _animator.SetLayerWeight(0, 0);
                _animator.enabled = false;
            }
        }

        protected override void OnStop()
        {
            int id = GetId();

            if (_animator && (id == 0 || _track.GetEvent(id - 1).End != Start))
            {
                _animator.Play("f_idle", 0);
                _animator.Update(0);
            }
        }

        protected override void OnUpdateEvent(float timeSinceTrigger)
        {
            float delta = timeSinceTrigger - _previousTimeSinceTrigger;

            if (_animator != null)
            {
                if (!_animator.enabled)
                    _animator.enabled = true;

                if(delta > 0)
                {
                    float moveSpeed = _animSpeed * 0.01f;
                    _animator.SetFloat("moveSpeed", moveSpeed);
                    _animator.Update(delta);
                    _previousTimeSinceTrigger = timeSinceTrigger;
                }
                else if(delta < 0)
                {
                    _animator.SetFloat("moveSpeed", -1);
                    _animator.Update(-delta);
                    _previousTimeSinceTrigger = timeSinceTrigger;
                }
            }
        }

        public override int GetMaxLength()
        {
            return base.GetMaxLength();
        }

        public override string Text
        {
            get { return "播放动作"; }
            set { }
        }

        public override SecurityElement SaveToXml()
        {
            SecurityElement node = base.SaveToXml();

            SecurityElement paramNode = WriteParamNode("animName", _animName, "string");
            if (paramNode != null)
                node.AddChild(paramNode);

            SecurityElement speedNode = WriteParamNode("animSpeed", _animSpeed.ToString(), "int");
            if (speedNode != null)
                node.AddChild(speedNode);

            return node;
        }

        public override void LoadFromXml(SecurityElement eventNode)
        {
            base.LoadFromXml(eventNode);

            _animName = GetSParam("animName");
            _animSpeed = GetNParam("animSpeed");
            if(_animSpeed == 0)
            {
                _animSpeed = 100;
            }
        }
    }
}
