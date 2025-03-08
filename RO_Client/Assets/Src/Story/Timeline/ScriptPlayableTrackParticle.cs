using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.UI;

// A behaviour that is attached to a playable
public class ScriptPlayableTrackParticle : PlayableBehaviour
{
    public ParticleSystem particles;
    private ParticleSystem.EmissionModule particlesEmission;

    public ParticleTLType location = ParticleTLType.NpcBody;
    public int masterId;
    public string point;

    public string placeName;

    public bool startEnabled;
    public bool endEnabled;
    public Color particleColour = Color.white;

    public StoryMgr mgr;

    public void Init(ParticleSystem particles, ParticleTLType location, int masterId, string point, string placeName, bool startEnabled, bool endEnabled, Color particleColour, StoryMgr mgr)
    {
        this.mgr = mgr;
        this.particles = particles;
        if (particles != null)
            particlesEmission = particles.emission;

        this.location = location;
        this.masterId = masterId;
        this.point = point;
        this.placeName = placeName;
        this.startEnabled = startEnabled;
        this.endEnabled = endEnabled;
        this.particleColour = particleColour;
        this.mgr = mgr;
    }
    // Called when the owning graph starts playing
    public override void OnGraphStart(Playable playable)
    {
        //Debug.Log("OnGraphStart");
    }

    // Called when the owning graph stops playing
    public override void OnGraphStop(Playable playable)
    {
        //Debug.Log("OnGraphStop");
    }

    // Called when the state of the playable is set to Play
    public override void OnBehaviourPlay(Playable playable, FrameData info)
    {
        if (particles == null)
            return;

        particlesEmission.enabled = startEnabled;

        ParticleSystem.MainModule mainModule = particles.main;
        ParticleSystem.MinMaxGradient colourGradient = new ParticleSystem.MinMaxGradient(particleColour);
        mainModule.startColor = colourGradient;

        if (mgr)
            mgr.BindParticle2Place(particles, masterId, placeName, location);
        else
            StoryMgr.Instance.BindParticle2Place(particles, masterId, placeName, location);
    }

    public override void OnBehaviourPause(Playable playable, FrameData info)
    {
        //Debug.Log("pause");
        if (particles == null)
            return;

        particlesEmission.enabled = endEnabled;
    }
}
