using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;
using UnityEngine.UI;

public enum ParticleTLType
{
    NpcBody,
    Place,
}

[System.Serializable]
public class ScriptPlayableAssetParticle : PlayableAsset
{
    public ParticleSystem particles;

    public ParticleTLType location = ParticleTLType.NpcBody;
    public int masterId;
    public string point;

    public string placeName;

    public bool StartEnabled;
    public bool EndEnabled;
    public Color ParticleColour = Color.white;

    public StoryMgr mgr;

    // Factory method that generates a playable based on this asset
    public override Playable CreatePlayable(PlayableGraph graph, GameObject go)
    {
        ScriptPlayableTrackParticle particlePlayable = new ScriptPlayableTrackParticle();
        particlePlayable.Init(particles, location, masterId, point, placeName, StartEnabled, EndEnabled, ParticleColour, mgr);

        return ScriptPlayable<ScriptPlayableTrackParticle>.Create(graph, particlePlayable);
    }
}
