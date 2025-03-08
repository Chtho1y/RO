using UnityEngine;
using System.Collections;
using System.Security;

namespace Flux
{
    [FEvent("Skill/美术/播放声音")]
    public class FPlaySoundEvent : FEvent
    {
        [SerializeField]
        private AudioClip _soundClip = null;
        public AudioClip SoundClip { get { return _soundClip; } }

        [Range(0f, 1f)]
        [SerializeField]
        private float _volume = 1f;

        [SerializeField]
        private bool _loop = false;
        public bool Loop { get { return _loop; } }

        [SerializeField]
        private bool _speedDeterminesPitch = true;
        public bool SpeedDeterminesPitch { get { return _speedDeterminesPitch; } set { _speedDeterminesPitch = value; } }


        private AudioSource _source;

        private float _previousTimeSinceTrigger = 0;
        private float _previousSpeed = 0;

        public FPlaySoundEvent()
        {
            _eventType = SkillActionFrameEventType.FE_PlaySound;
        }

        protected override void OnTrigger(float timeSinceTrigger)
        {
            if(Application.isPlaying)
            {
                _source = Owner.GetComponent<AudioSource>();
                if (_source == null)
                    _source = Owner.gameObject.AddComponent<AudioSource>();
                _source.volume = _volume;
                _source.loop = _loop;
                _source.clip = _soundClip;

                if (Sequence.IsPlaying)
                    _source.Play();
                _source.time = timeSinceTrigger;
                if (SpeedDeterminesPitch)
                    _source.pitch = Sequence.Speed * Time.timeScale;
            }
            else
            {
#if UNITY_EDITOR
                UnityEditor.AudioUtility.PlayClip(_soundClip);
#endif
            }

        }

        protected override void OnPause()
        {
            if(Application.isPlaying)
            {
                _source.Pause();
            }
            else
            {
#if UNITY_EDITOR
                UnityEditor.AudioUtility.PauseClip(_soundClip);
#endif
            }
        }

        protected override void OnResume()
        {
            if (Application.isPlaying)
            {
                if (Sequence.IsPlaying)
                    _source.Play();
            }
            else
            {
#if UNITY_EDITOR
                UnityEditor.AudioUtility.PlayClip(_soundClip);
#endif
            }
        }

        protected override void OnFinish()
        {
            if (Application.isPlaying)
            {
                if (_source.clip == _soundClip && _source.isPlaying)
                {
                    _source.Stop();
                    _source.clip = null;
                }
            }
            else
            {
#if UNITY_EDITOR
                UnityEditor.AudioUtility.StopClip(_soundClip);
#endif
            }
        }

        protected override void OnStop()
        {
            if (Application.isPlaying)
            {
                if (_source.clip == _soundClip && _source.isPlaying)
                {
                    _source.Stop();
                    _source.clip = null;
                }
            }
            else
            {
#if UNITY_EDITOR
                UnityEditor.AudioUtility.StopClip(_soundClip);
#endif
            }
        }

        public override int GetMaxLength()
        {
            if (_loop || _soundClip == null)
                return base.GetMaxLength();

            return Mathf.RoundToInt(_soundClip.length * Sequence.FrameRate);
        }

        public int GetMaxStartOffset()
        {
            if (_soundClip == null)
                return 0;

            int maxFrames = Mathf.RoundToInt(_soundClip.length * Sequence.FrameRate);

            if (_loop)
                return maxFrames;

            return maxFrames - Length;
        }

        public override string Text
        {
            get { return "播放声音"; }
            set { }
        }

        public override SecurityElement SaveToXml()
        {
            SecurityElement node =  base.SaveToXml();

            if (_soundClip != null)
            {
#if UNITY_EDITOR
                string audioPath = UnityEditor.AssetDatabase.GetAssetPath(_soundClip);
                string relativeName = FileUtils.RemoveParent(Constants.FightAudioPath, audioPath);

                SecurityElement paramNode = WriteParamNode("sound", relativeName, "string");
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

            string soundPath = GetSParam("soundPath");
            if(!string.IsNullOrEmpty(soundPath))
            {
#if UNITY_EDITOR
                _soundClip = UnityEditor.AssetDatabase.LoadAssetAtPath<AudioClip>(soundPath);
#endif
            }
        }
    }
}
