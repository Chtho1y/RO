using System.Collections;
using System.Collections.Generic;
using System.Security;
using UnityEngine;

namespace Flux
{
    [FEvent("Skill/策划/召唤")]
    public class FSummonEvent : FEvent
    {
        [HideInInspector]
        [SerializeField]
        private int _npcId = 0;
        public int NpcId
        {
            get { return _npcId; }
        }

        [HideInInspector]
        [SerializeField]
        private int _npcPos = 0;
        public int NpcPos
        {
            get { return _npcPos; }
        }

        [SerializeField]
        [HideInInspector]
        private int _startOffset = 0;
        public int StartOffset { get { return _startOffset; } }

        public FSummonEvent()
        {
            _eventType = SkillActionFrameEventType.FE_Summon;
        }

        protected override void OnSetDefaultValues()
        {
            base.OnSetDefaultValues();
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
            get { return "召唤"; }
            set { }
        }

        public override SecurityElement SaveToXml()
        {
            SecurityElement node =  base.SaveToXml();

            SecurityElement paramNode = WriteParamNode("npcId",_npcId.ToString(),"int");
            node.AddChild(paramNode);

            paramNode = WriteParamNode("npcPos", _npcPos.ToString(), "int");
            node.AddChild(paramNode);

            return node;
        }

        public override void LoadFromXml(SecurityElement eventNode)
        {
            base.LoadFromXml(eventNode);

            _npcId = GetNParam("npcId");
            _npcPos = GetNParam("npcPos");
        }
    }

}