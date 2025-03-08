using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Security;
using Mono.Xml;


namespace Flux
{
    [FEvent("Skill/镜头/震屏")]
    public class FCameraShakeEvent : FEvent
    {
        [HideInInspector]
        [SerializeField]
        private float _leftRightValue;
        public float LeftRightValue
        {
            get { return _leftRightValue; }
        }

        [HideInInspector]
        [SerializeField]
        private float _upDownValue;
        public float UpDownValue
        {
            get { return _upDownValue; }
        }

        [HideInInspector]
        [SerializeField]
        private float _forwardbackward;
        public float Forwardbackward
        {
            get { return _forwardbackward; }
        }

        [HideInInspector]
        [SerializeField]
        private float _shakeTime;
        public float ShakeTime
        {
            get { return _shakeTime; }
        }

        [HideInInspector]
        [SerializeField]
        private int _cycle = 1;
        public int Cycle
        {
            get { return _cycle; }
        }


        private float _previousTimeSinceTrigger = 0;
        private float _previousSpeed = 0;

        private Vector3 _lastCamPos = Vector3.zero;
        private Vector3 _lastCamRot = Vector3.zero;
        private Shake mShake;


        public FCameraShakeEvent()
        {
            _eventType = SkillActionFrameEventType.FE_ShakeCamera;
        }

        protected override void OnTrigger(float timeSinceTrigger)
        {
            if(_cameraTrans!=null)
            {
                mShake = _cameraTrans.GetComponent<Shake>();
                if(mShake == null)
                {
                    mShake = _cameraTrans.gameObject.AddComponent<Shake>();
                    mShake.Init(_cameraTrans);
                }

                mShake.onShakeStopCb = OnShakeStop;
            }
            _lastCamPos = _cameraTrans.localPosition;
            _lastCamRot = _cameraTrans.localEulerAngles;

            BeginShake(_leftRightValue,_upDownValue,_forwardbackward,_shakeTime,_cycle);

            _previousTimeSinceTrigger = timeSinceTrigger;
            _previousSpeed = Sequence.Speed;
        }

        private void BeginShake(float leftRight,float upDown, float forwardBackward, float time, int cycle)
        {
            mShake.positionShake = new Vector3(leftRight, upDown, forwardBackward);
            mShake.angleShake = Vector3.zero;
            if (Mathf.Abs(time) < Mathf.Epsilon)
                time = 0.1f;
            mShake.cycleTime = time;
            mShake.fCycleCount = cycle;
            mShake.unscaleTime = false;
            mShake.bothDir = true;
            mShake.autoDisable = true;
            mShake.Restart();

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
            if (_cameraTrans != null)
            {
                _cameraTrans.localPosition = _lastCamPos;
                _cameraTrans.localEulerAngles = _lastCamRot;
            }

            GameObject.DestroyImmediate(mShake);
            mShake = null;
        }

        protected override void OnStop()
        {
            base.OnStop();
            if(_cameraTrans!=null)
            {
                _cameraTrans.localPosition = _lastCamPos;
                _cameraTrans.localEulerAngles = _lastCamRot;
            }

            GameObject.DestroyImmediate(mShake);
            mShake = null;
        }

        public override int GetMaxLength()
        {
            return base.GetMaxLength();
        }

        public override string Text
        {
            get { return "震屏";}
            set { }
        }

        protected override void OnUpdateEvent(float timeSinceTrigger)
        {
            float delta = timeSinceTrigger - _previousTimeSinceTrigger;
            _previousTimeSinceTrigger = timeSinceTrigger;

            if(mShake!=null)
            {
                mShake.UpdateFrame(delta);
            }
        }

        private void OnShakeStop(Shake shakeCom)
        {

        }

        public override SecurityElement SaveToXml()
        {
            SecurityElement node = base.SaveToXml();

            SecurityElement paramNode = WriteParamNode("leftright", ((int)(_leftRightValue*100)).ToString(), "int");
            node.AddChild(paramNode);


            paramNode = WriteParamNode("updown", ((int)(_upDownValue*100)).ToString(), "int");
            node.AddChild(paramNode);


            paramNode = WriteParamNode("forwardbackward", ((int)(_forwardbackward*100)).ToString(), "int");
            node.AddChild(paramNode);

            paramNode = WriteParamNode("time", ((int)(_shakeTime*100)).ToString(), "int");
            node.AddChild(paramNode);

            paramNode = WriteParamNode("cycle",_cycle.ToString(), "int");
            node.AddChild(paramNode);

            return node;
        }

        public override void LoadFromXml(SecurityElement eventNode)
        {
            base.LoadFromXml(eventNode);

            _leftRightValue = GetNParam("leftright") * 0.01f;
            _upDownValue = GetNParam("updown") * 0.01f;
            _forwardbackward = GetNParam("forwardbackward") * 0.01f;
            _shakeTime = GetNParam("time") * 0.01f;
            _cycle = GetNParam("cycle");
        }
    }
}
