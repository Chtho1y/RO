using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Security;

namespace Flux
{
    [FEvent("Skill/移动效果/移动")]
    public class FMoveEvent : FEvent
    {
        [HideInInspector]
        [SerializeField]
        private int _moveType = 0;
        public int MoveType
        {
            get { return _moveType; }
        }

        [HideInInspector]
        [SerializeField]
        private float _initSpeed = 0;
        public float InitSpeed
        {
            get
            {
                return _initSpeed;
            }
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
        private int _moveOrientation = 0;
        public int MoveOrientation
        {
            get { return _moveOrientation; }
        }

        private Vector3 _lastPos;
        private MoveProcessor _moveProcessor;
        private float _previousTimeSinceTrigger = 0;
        private float _previousSpeed = 0;

        private Vector3 _destPos;

        public FMoveEvent()
        {
            _eventType = SkillActionFrameEventType.FE_Move;
        }

        protected override void OnSetDefaultValues()
        {
            base.OnSetDefaultValues();
        }

        protected override void OnTrigger(float timeSinceTrigger)
        {
            if (_casterTrans != null)
            {
                _lastPos = _casterTrans.position;
                _moveProcessor = new MoveProcessor(_casterTrans);

                if (_moveType == (int)FighterMoveType.Jump)
                {
                    _destPos = _casterTrans.position + Vector3.up * _moveDistance;
                }
                else if (_moveType == (int)FighterMoveType.Sprint_Target)
                {
                    if (_targetTrans != null)
                        _destPos = _targetTrans.position + _targetTrans.forward * _moveDistance;
                }
                else if (_moveType == (int)FighterMoveType.Sprint_Position)
                {
                    Vector3 eulerAngle = _casterTrans.rotation.eulerAngles;
                    eulerAngle.y += _moveOrientation;
                    _casterTrans.rotation = Quaternion.Euler(eulerAngle);

                    _destPos = _casterTrans.position + _casterTrans.forward * _moveDistance;
                }
            }

            if (_moveProcessor != null)
            {
                _moveProcessor.Start(_initSpeed,_acceleration, _destPos);
                _previousTimeSinceTrigger = timeSinceTrigger;
            }
        }

        protected override void OnPause()
        {
            base.OnPause();
        }

        protected override void OnResume()
        {
            base.OnResume();
        }

        protected override void OnFinish()
        {
            base.OnFinish();
        }

        protected override void OnStop()
        {
            base.OnStop();
            if(_casterTrans!=null)
            {
                _casterTrans.position = _lastPos;
            }
        }

        protected override void OnUpdateEvent(float timeSinceTrigger)
        {
            float delta = timeSinceTrigger - _previousTimeSinceTrigger;
            _previousTimeSinceTrigger = timeSinceTrigger;

            if(_moveProcessor!=null)
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
            get { return "移动"; }
            set { }
        }

        public override SecurityElement SaveToXml()
        {
            SecurityElement node =  base.SaveToXml();

            SecurityElement paramNode = WriteParamNode("moveType", _moveType.ToString(),"int");
            node.AddChild(paramNode);

            paramNode = WriteParamNode("initSpeed", ((int)(_initSpeed * 100)).ToString(), "int");
            node.AddChild(paramNode);

            paramNode = WriteParamNode("acceleration", ((int)(_acceleration * 100)).ToString(), "int");
            node.AddChild(paramNode);

            paramNode = WriteParamNode("moveDist", ((int)(_moveDistance * 100)).ToString(), "int");
            node.AddChild(paramNode);

            paramNode = WriteParamNode("moveOrientation", _moveOrientation.ToString(), "int");
            node.AddChild(paramNode);

            return node;
        }

        public override void LoadFromXml(SecurityElement eventNode)
        {
            base.LoadFromXml(eventNode);

            _moveType = GetNParam("moveType");
            _initSpeed = GetNParam("initSpeed") * 0.01f;
            _acceleration = GetNParam("acceleration") * 0.01f;
            _moveDistance = GetNParam("moveDist") * 0.01f;
            _moveOrientation = GetNParam("moveOrientation");
        }
    }
}

