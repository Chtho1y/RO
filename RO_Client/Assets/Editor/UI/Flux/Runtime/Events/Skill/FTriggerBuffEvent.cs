using System.Collections;
using System.Collections.Generic;
using System.Security;
using UnityEngine;

namespace Flux
{
    [FEvent("Skill/策划/触发buff")]
    public class FTriggerBuffEvent : FEvent
    {
        [HideInInspector]
        [SerializeField]
        private int _buffId = 0;
        public int BuffId
        {
            get { return _buffId; }
        }

        [HideInInspector]
        [SerializeField]
        private int _rate = 0;
        public int Rate
        {
            get { return _rate; }
        }

        public FTriggerBuffEvent()
        {
            _eventType = SkillActionFrameEventType.FE_Buff;
        }

        protected override void OnTrigger(float timeSinceTrigger)
        {
            base.OnTrigger(timeSinceTrigger);
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
        }

        public override int GetMaxLength()
        {
            return base.GetMaxLength();
        }

        public override string Text
        {
            get { return "触发buff"; }
            set { }
        }

        public override SecurityElement SaveToXml()
        {
            SecurityElement node =  base.SaveToXml();

            SecurityElement paramNode = WriteParamNode("buffid", _buffId.ToString(), "int");
            node.AddChild(paramNode);

            paramNode = WriteParamNode("rate", _rate.ToString(), "int");
            node.AddChild(paramNode);

            return node;
        }

        public override void LoadFromXml(SecurityElement eventNode)
        {
            base.LoadFromXml(eventNode);

            _buffId = GetNParam("buffid");
            _rate = GetNParam("rate");
        }
    }
}
