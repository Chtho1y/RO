using UnityEngine;
using System;
using System.Collections.Generic;
using System.Text;
using System.Security;
using Mono.Xml;
using System.IO;

namespace Flux
{
	/**
	 * @brief A timeline is an object that holds tracks that pertain to 
	 * a specific object, aka Owner. When evaluated this timeline will 
	 * run events which most of the times will directly affect the Owner.
	 * @sa FSquence, FTrack, FEvent
	 */
	public class FTimeline : FObject//, ISerializationCallbackReceiver
	{

		// To which Sequence this timeline belongs to
//		[SerializeField]
//		private FSequence _sequence;
		[SerializeField]
		private FContainer _container = null;
		public FContainer Container { get { return _container; } }

		// Which object is the owner of this timeline
		[SerializeField]
		private Transform _owner = null;

		// What's the path to the _owner, used for serialization purposes in prefabs
		[SerializeField]
		private string _ownerPath = null;
		public string OwnerPath { get { return _ownerPath; } }

        [HideInInspector]
        [SerializeField]
        private int _buffId = 0;
        public int BuffId
        {
            get { return _buffId; }
        }

        [HideInInspector]
        [SerializeField]
        private string _buffName = "";
        public string BuffName
        {
            get { return _buffName; }
        }

        [HideInInspector]
        [SerializeField]
        private int _gender = 3;
        public int Gender
        {
            get { return _gender; }
        }

        [HideInInspector]
        [SerializeField]
        private int _jobType;
        public int JobType
        {
            get { return _jobType; }
        }

        [HideInInspector]
        [SerializeField]
        private int _jobStage;
        public int JobStage
        {
            get { return _jobStage; }
        }

        [HideInInspector]
        [SerializeField]
        private int _jobBranch;
        public int JobBranch
        {
            get { return _jobBranch; }
        }

		public override FSequence Sequence { get { return _container.Sequence; } }

		public override Transform Owner { get { return _owner; } }

		public void Awake()
		{
			if( _owner == null && !string.IsNullOrEmpty(_ownerPath) )
				_owner = transform.Find( _ownerPath );
		}

		/// @brief Sets the owner of this timeline
		public void SetOwner( Transform owner ) { 
			_owner = owner; 
			if( _owner != null ) 
				name = _owner.name;
			OnValidate();
			if( Container != null && Sequence.IsInit )
				Init();
		}

		internal void SetContainer( FContainer container )
		{
			_container = container;
			if( _container )
				transform.parent = container.transform;
			else
				transform.parent = null;
			OnValidate();
		}

		// tracks
		[SerializeField]
		private List<FTrack> _tracks = new List<FTrack>();
		/// @brief Get the tracks inside this timeline
		public List<FTrack> Tracks { get { return _tracks; } }

		public static FTimeline Create( Transform owner )
		{
			GameObject go = new GameObject(owner.name);
			FTimeline timeline = go.AddComponent<FTimeline>();
			timeline.SetOwner( owner );

			return timeline;
		}

		public override void Init()
		{
			if( _owner == null )
				Awake();

			enabled = Owner != null;

			if( !enabled )
				return;

			for( int i = 0; i != _tracks.Count; ++i )
				_tracks[i].Init();
		}

		public void Pause()
		{
			for( int i = 0; i != _tracks.Count; ++i )
				_tracks[i].Pause();
		}

		public void Resume()
		{
			for( int i = 0; i != _tracks.Count; ++i )
				_tracks[i].Resume();
		}

		public override void Stop()
		{
			for( int i = 0; i != _tracks.Count; ++i )
				_tracks[i].Stop();
		}

		public bool IsEmpty()
		{
			foreach( FTrack track in _tracks )
			{
				if( !track.IsEmpty() )
					return false;
			}

			return true;
		}

		public FTrack Add<T>( FrameRange range ) where T : FEvent
		{
			FTrack track = FTrack.Create<T>();

			Add( track );

			FEvent evt = FEvent.Create<T>( range );

			track.Add( evt );

            evt.SetDefaultValues();

            return track;
		}

		public void Add( FTrack track )
		{
			int id = _tracks.Count;

			_tracks.Add( track );

			track.SetTimeline( this );
			track.SetId( id );

			if( !Sequence.IsStopped )
				track.Init();
		}
	
		public void Remove( FTrack track )
		{
			if( _tracks.Remove( track ) )
			{
				track.SetTimeline( null );

				UpdateTrackIds();
			}
		}

		public void UpdateTracks( int frame, float time )
		{
			for( int i = 0; i != _tracks.Count; ++i )
			{
				if( !_tracks[i].enabled ) continue;
				_tracks[i].UpdateEvents( frame, time );
			}
		}

		public void UpdateTracksEditor( int frame, float time )
		{
			for( int i = 0; i != _tracks.Count; ++i )
			{
				if( !_tracks[i].enabled ) continue;

                _tracks[i].UpdateEventsEditor( frame, time );
			}
		}

#if UNITY_EDITOR
        public void SaveToXml()
        {
            string frameEventFileName = string.Format("{0}/Content/Xml/Skill/buff_{1}_{2}_{3}_{4}_{5}.xml", Application.dataPath, _buffId,_gender,_jobType,_jobStage,_jobBranch);
            SecurityElement root = new SecurityElement("FrameEvent");

            SecurityElement buffNode = new SecurityElement("buff");
            buffNode.AddAttribute("id", this._buffId.ToString());
            buffNode.AddAttribute("name", this._buffName);
            buffNode.AddAttribute("endFrame", Sequence.Length.ToString());
            buffNode.AddAttribute("gender", this._gender.ToString());
            buffNode.AddAttribute("jobType", this._jobType.ToString());
            buffNode.AddAttribute("jobStage", this._jobStage.ToString());
            buffNode.AddAttribute("jobBranch", this._jobBranch.ToString());
            if(Sequence.CasterActor!=null)
                buffNode.AddAttribute("caster", Sequence.CasterActor.name);

            if (Sequence.TargetActor != null)
                buffNode.AddAttribute("target", Sequence.TargetActor.name);

            if(_tracks!=null)
            {
                for(int idx =0; idx < _tracks.Count; idx++ )
                {
                    FTrack track = _tracks[idx];
                    if(track.Events!=null)
                    {
                        for(int jdx = 0; jdx < track.Events.Count;jdx++)
                        {
                            SecurityElement eventNode = track.Events[jdx].SaveToXml();
                            if(eventNode!=null)
                            {
                                buffNode.AddChild(eventNode);
                            }
                        }
                    }
                }
            }

            root.AddChild(buffNode);

            SecurityTools.DumpSecurityElementToXml(root, frameEventFileName);

        }

        public void LoadFromXml(SecurityElement buffNode)
        {
            if (buffNode == null) return;

            int.TryParse(buffNode.Attribute("id"), out _buffId);
            _buffName = buffNode.Attribute("name");
            int.TryParse(buffNode.Attribute("gender"), out _gender);
            int.TryParse(buffNode.Attribute("jobType"), out _jobType);
            int.TryParse(buffNode.Attribute("jobStage"), out _jobStage);
            int.TryParse(buffNode.Attribute("jobBranch"), out _jobBranch);
            if(_gender == 0)
            {
                _gender = 3;
            }

            if(buffNode.Children!=null)
            {
                for (int idx = 0; idx < buffNode.Children.Count; idx++)
                {
                    var eventNode = buffNode.Children[idx] as SecurityElement;
                    if (eventNode.Tag.CompareTo("event") != 0) continue;

                    int eventType = 0;
                    int startFrame = 0, endFrame = 0;
                    int.TryParse(eventNode.Attribute("type"), out eventType);
                    int.TryParse(eventNode.Attribute("startFrame"), out startFrame);
                    int.TryParse(eventNode.Attribute("endFrame"), out endFrame);
                    if(endFrame == 0)
                    {
                        endFrame = startFrame+10;
                    }

                  
                    SkillActionFrameEventType type = (SkillActionFrameEventType)eventType;
                    FEvent evt = null;
                    FTrack track = null;
                    var range =  new FrameRange(startFrame, endFrame);
                    if (type == SkillActionFrameEventType.FE_ShakeCamera)
                    {
                        evt = FEvent.Create<FCameraShakeEvent>(range);
                        track = FTrack.Create <FCameraShakeEvent>();
                    }
                    else if(type  == SkillActionFrameEventType.FE_SWITCH_SKILL)
                    {
                        evt = FEvent.Create<FChangeSkillEvent>(range);
                        track = FTrack.Create<FChangeSkillEvent>();
                    }
                    else if(type == SkillActionFrameEventType.FE_Clone)
                    {
                        evt = FEvent.Create<FCloneEvent>(range);
                        track = FTrack.Create<FCloneEvent>();
                    }
                    else if(type == SkillActionFrameEventType.FE_Move)
                    {
                        evt = FEvent.Create<FMoveEvent>(range);
                        track = FTrack.Create<FMoveEvent>();
                    }
                    else if(type == SkillActionFrameEventType.FE_PlaySkillAnim)
                    {
                        evt = FEvent.Create<FPlayAnimEvent>(range);
                        track = FTrack.Create<FPlayAnimEvent>();
                    }
                    else if(type == SkillActionFrameEventType.FE_PlayEffect)
                    {
                        evt = FEvent.Create<FPlayEffectEvent>(range);
                        track = FTrack.Create<FPlayEffectEvent>();
                    }
                    else if(type == SkillActionFrameEventType.FE_PlaySound)
                    {
                        evt = FEvent.Create<FPlaySoundEvent>(range);
                        track = FTrack.Create<FPlaySoundEvent>();
                    }
                    else if(type == SkillActionFrameEventType.FE_SELECT_TARGET)
                    {
                        evt = FEvent.Create<FSelectTargetEvent>(range);
                        track = FTrack.Create<FSelectTargetEvent>();
                    }
                    else if(type == SkillActionFrameEventType.FE_Repeat_Caster)
                    {
                        evt = FEvent.Create<FSkillCastingEvent>(range);
                        track = FTrack.Create<FSkillCastingEvent>();
                    }
                    else if(type == SkillActionFrameEventType.FE_Delay_Hurt)
                    {
                        evt = FEvent.Create<FSkillDelayHurtEvent>(range);
                        track = FTrack.Create<FSkillDelayHurtEvent>();
                    }
                    else if(type == SkillActionFrameEventType.FE_Hit)
                    {
                        evt = FEvent.Create<FSkillHitEvent>(range);
                        track = FTrack.Create<FSkillHitEvent>();
                    }
                    else if(type == SkillActionFrameEventType.FE_Skill_Sing)
                    {
                        evt = FEvent.Create<FSkillSingEvent>(range);
                        track = FTrack.Create<FSkillSingEvent>();
                    }
                    else if(type == SkillActionFrameEventType.FE_Summon)
                    {
                        evt = FEvent.Create<FSummonEvent>(range);
                        track = FTrack.Create<FSummonEvent>();
                    }
                    else if(type == SkillActionFrameEventType.FE_Buff)
                    {
                        evt = FEvent.Create<FTriggerBuffEvent>(range);
                        track = FTrack.Create<FTriggerBuffEvent>();
                    }
                    else if(type == SkillActionFrameEventType.FE_Bullet)
                    {
                        evt = FEvent.Create<FTriggerBulletEvent>(range);
                        track = FTrack.Create<FTriggerBulletEvent>();
                    }
                    
                    if(evt!=null && track!=null)
                    {
                        track.SetTimeline(this);
                        track.SetId(idx + 1);
                        evt.LoadFromXml(eventNode);

                        track.Add(evt);
                        evt.SetDefaultValues();

                        _tracks.Add(track);
                    }  
                }
            }

            if (Owner != null)
            {
                Owner.name = "buff_" + _buffId + "_" + _gender + "_" + _jobType + "_" + _jobStage + "_" + _jobBranch;
            }
        }
#endif

        public void Rebuild()
		{
			Transform t = transform;
			_tracks.Clear();

			for( int i = 0; i != t.childCount; ++i )
			{
				FTrack track = t.GetChild(i).GetComponent<FTrack>();
				if( track )
				{
					_tracks.Add( track );
					track.SetTimeline( this );
					track.Rebuild();
				}
			}

			UpdateTrackIds();
		}

		// updates the track ids
		private void UpdateTrackIds()
		{
			for( int i = 0; i != _tracks.Count; ++i )
				_tracks[i].SetId( i );
		}

		protected virtual void OnValidate()
		{
			if( _owner != null )
				_ownerPath = GetTransformPath( _owner );
		}

		// helper function to get the transform path of a specific transform t
		private string GetTransformPath( Transform t )
		{
			StringBuilder sb = new StringBuilder(t.name);

			if( Container == null || Sequence == null )
				return string.Empty;
			Transform sequenceTransform = Sequence.transform;

			t = t.parent;

			while( t != null )
			{
				if( t == sequenceTransform )
					return sb.ToString();

				sb.Insert( 0, string.Format("{0}/", t.name) );

				t = t.parent;
			}

			sb.Insert( 0, '/' );

			return sb.ToString();
		}
	}
}
