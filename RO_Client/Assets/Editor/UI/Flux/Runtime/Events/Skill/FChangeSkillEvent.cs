using System.Collections;
using System.Collections.Generic;
using System.Security;
using UnityEngine;

namespace Flux
{
    [FEvent("Skill/策划/切换技能")]
    public class FChangeSkillEvent : FEvent
    {
        [HideInInspector]
        [SerializeField]
        private string _fromSkillId = "";
        public string FromSkillId
        {
            get { return _fromSkillId; }
        }

        [HideInInspector]
        [SerializeField]
        private string _toSkillId = "";
        public string ToSkillId
        {
            get { return _toSkillId; }
        }

        public FChangeSkillEvent()
        {
            _eventType = SkillActionFrameEventType.FE_SWITCH_SKILL;
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
            get { return "切换技能"; }
            set { }
        }

        public override SecurityElement SaveToXml()
        {
            SecurityElement node = base.SaveToXml();

            SecurityElement paramNode = WriteParamNode("fromskill", _fromSkillId.ToString(), "string");
            node.AddChild(paramNode);


            paramNode = WriteParamNode("toskill", _toSkillId.ToString(), "string");
            node.AddChild(paramNode);

            return node;
        }

        public override void LoadFromXml(SecurityElement eventNode)
        {
            base.LoadFromXml(eventNode);

            _fromSkillId = GetSParam("fromskill");
            _toSkillId = GetSParam("toskill");
        }
    }
}