using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Flux
{
    [FEvent("Skill/策划/选择目标")]
    public class FSelectTargetEvent : FEvent
    {

        public FSelectTargetEvent()
        {
            _eventType = SkillActionFrameEventType.FE_SELECT_TARGET;
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
            get { return "重新选择目标"; }
            set { }
        }
    }
}