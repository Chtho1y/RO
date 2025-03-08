using System.Collections;
using System.Collections.Generic;
using System.Security;
using UnityEngine;

namespace Flux
{
    [FEvent("Skill/策划/克隆")]
    public class FCloneEvent : FEvent
    {
        [HideInInspector]
        [SerializeField]
        private int _npcId;
        public int NpcId
        {
            get { return _npcId; }
        }

        [HideInInspector]
        [SerializeField]
        private int _npcPos;
        public int NpcPos
        {
            get { return _npcPos; }
        }

        [HideInInspector]
        [SerializeField]
        private int _bornEffectId;
        public int BornEffectId
        {
            get { return _bornEffectId; }
        }

        [HideInInspector]
        [SerializeField]
        private GameObject _bornEffectPrefab = null;
        public GameObject BornEffectPrefab
        {
            get { return _bornEffectPrefab; }
        }

        

        [HideInInspector]
        [SerializeField]
        private Vector3 _bornPos = Vector3.zero;
        public Vector3 BornPos
        {
            get { return _bornPos; }
        }

        [HideInInspector]
        [SerializeField]
        private Vector3 _bornRot = Vector3.zero;
        public Vector3 BornRot
        {
            get { return _bornRot; }
        }


        public FCloneEvent()
        {
            _eventType = SkillActionFrameEventType.FE_Clone;
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
            get { return "克隆"; }
            set { }
        }


        public override SecurityElement SaveToXml()
        {
            SecurityElement node = base.SaveToXml();

            SecurityElement paramNode = WriteParamNode("npcId", _npcId.ToString(), "int");
            node.AddChild(paramNode);

            paramNode = WriteParamNode("npcPos", _npcPos.ToString(), "int");
            node.AddChild(paramNode);

            paramNode = WriteParamNode("effect", _bornEffectId.ToString(), "int");
            node.AddChild(paramNode);

            if(_bornEffectPrefab!=null)
            {
#if UNITY_EDITOR
                paramNode = WriteParamNode("effectPrefab", UnityEditor.AssetDatabase.GetAssetPath(_bornEffectPrefab), "string");
                node.AddChild(paramNode);
#endif
            }

            paramNode = WriteParamNode("position", StringUtil.ConvertVector2Str(_bornPos), "string");
            node.AddChild(paramNode);

            paramNode = WriteParamNode("rotation", StringUtil.ConvertVector2Str(_bornRot), "string");
            node.AddChild(paramNode);

            return node;
        }

        public override void LoadFromXml(SecurityElement eventNode)
        {
            base.LoadFromXml(eventNode);


            _npcId = GetNParam("npcId");
            _npcPos = GetNParam("npcPos");
            _bornEffectId = GetNParam("effect");

            string bornEffectPath = GetSParam("effectPrefab");
            if (!string.IsNullOrEmpty(bornEffectPath))
            {
#if UNITY_EDITOR
                _bornEffectPrefab = UnityEditor.AssetDatabase.LoadAssetAtPath<GameObject>(bornEffectPath);
#endif
            }

            _bornPos = GetVParam("position");
            _bornRot = GetVParam("rotation");

        }
    }
}