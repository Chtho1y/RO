using UnityEngine;
using UnityEngine.AI;
using System.Collections;
using LuaInterface;
using UnityEngine.UI;
using System.Collections.Generic;

public static class LuaBattleBridge
{
    public static void ClickChallegeBoss(ValType[] factors)
    {
        EventMgr.DispatchEvent<ValType[]>(new CoreEvent<ValType[]>(ECoreEventType.EID_Click_Challenge, factors));
    }

    public static void ClickReplayBattle(string recordStr)
    {
        BattleMgr.Instance.ReplayBattle(recordStr);
    }

    public static void SetReplayHeroActorName(string strName)
    {
        if (null != BattleMgr.Instance.Battle.Recorder)
            BattleMgr.Instance.Battle.Recorder.SetLeftHeroName(strName);
    }

    public static void SkipReplay()
    {
        BattleMgr.Instance.Skip();
    }

    public static void SetLuaBattleMgr(BattleMode battleMode, LuaTable luaBattleMgr)
    {
        if (battleMode == BattleMode.Normal)
            BattleMgr.Instance.LuaBattleMgr = luaBattleMgr;
        else if (battleMode == BattleMode.Versus)
            BattleMgr.Instance.LuaTowerMgr = luaBattleMgr;
        else if (battleMode == BattleMode.Boss)
            BattleMgr.Instance.LuaBossBattleMgr = luaBattleMgr;
    }

    public static void SetLuaGuildLobbyMgr(LuaTable luaGuildLobbyMgr)
    {
        GuildLobbyMgr.Instance.LuaGuildLobbyMgr = luaGuildLobbyMgr;
    }

    public static void SetGoColor(GameObject go, Color clr)
    {
        if (go == null) return;

        Renderer r = go.GetComponent<Renderer>();
        if (r == null) return;

        Material mat = r.material;
        if (mat == null) return;

        mat.color = clr;
    }

    public static Vector3 GetCanMovePoint(Vector3 source, Vector3 moveDir, float distance)
    {
        NavMeshHit hit;
        Vector3 dir = moveDir * distance;
        Vector3 target = dir + source;
        if (!NavMesh.Raycast(source, target, out hit, NavMesh.AllAreas))
        {
            return target;
        }
        Vector3 hitNormal = hit.normal;
        // 完全相反，则不能移动
        if (Mathf.Approximately(Vector3.Angle(moveDir, hitNormal), 180))
        {
            return source;
        }
        Vector3 newMoveDir = Vector3.Cross(Vector3.up, hitNormal).normalized;
        float dot = Vector3.Dot(moveDir, newMoveDir);
        if (dot < 0)
        {
            newMoveDir = -newMoveDir;
        }
        float newDistance = Vector3.Project(dir, newMoveDir).magnitude;
        Vector3 newPos = source + newMoveDir * newDistance;
        if (!NavMesh.Raycast(source, newPos, out hit, NavMesh.AllAreas))
        {
            return newPos;
        }
        return source;
    }

    public static bool GetCanMoveToPoint(Vector3 center, Quaternion quat, float minRange, float maxRange, out Vector3 result)
    {
        Matrix4x4 rotateMatrix = Matrix4x4.Rotate(quat);
        Vector3 defaultDir = rotateMatrix.MultiplyVector(Vector3.forward);
        defaultDir.Normalize();
        Vector3 target = center + defaultDir * maxRange;
        NavMeshPath navMeshPath = new NavMeshPath();
        NavMesh.CalculatePath(center, target, NavMesh.AllAreas, navMeshPath);
        if (navMeshPath.status == NavMeshPathStatus.PathComplete)
        {
            result = target;
            return true;
        }
        float minSqr = minRange * minRange;
        float maxSqr = maxRange * maxRange;
        Vector3[] corners = new Vector3[2];
        if (navMeshPath.status == NavMeshPathStatus.PathPartial)
        {
            navMeshPath.GetCornersNonAlloc(corners);
            if ((corners[1] - center).sqrMagnitude >= minSqr)
            {
                result = corners[1];
                return true;
            }
        }
        List<Vector3> canPoints = new List<Vector3>();
        float angle = (float)360 / 30;
        for (int i = 1; i < 29; i++)
        {
            Vector3 dir = Matrix4x4.Rotate(Quaternion.Euler(0, i * angle, 0)).MultiplyVector(defaultDir);
            Vector3 randomPoint = center + dir.normalized * maxRange;
            NavMesh.CalculatePath(center, randomPoint, NavMesh.AllAreas, navMeshPath);
            if (navMeshPath.status == NavMeshPathStatus.PathComplete)
            {
                canPoints.Add(randomPoint);
            }
            else if (navMeshPath.status == NavMeshPathStatus.PathPartial)
            {
                navMeshPath.GetCornersNonAlloc(corners);
                if ((corners[1] - center).sqrMagnitude >= minSqr)
                {
                    canPoints.Add(corners[1]);
                }
            }
        }
        if (canPoints.Count > 0)
        {
            result = canPoints[Random.Range(0, canPoints.Count)];
            return true;
        }
        else
        {
            result = Vector3.zero;
            return false;
        }
    }

    public static void AddNavMeshCapsule(GameObject go, Vector3 center, float radius, float height)
    {
        NavMeshObstacle navMeshObstacle = go.GetComponent<NavMeshObstacle>();
        if (navMeshObstacle == null)
        {
            navMeshObstacle = go.AddComponent<NavMeshObstacle>();
        }
        navMeshObstacle.carving = true;
        navMeshObstacle.center = center;
        navMeshObstacle.height = height;
        navMeshObstacle.radius = radius;
        navMeshObstacle.shape = NavMeshObstacleShape.Capsule;
    }

    public static Camera InitMainCamera()
    {
        GameObject cameraGo = GameObject.FindWithTag("MainCamera");
        cameraGo.AddComponent<Cinemachine.CinemachineBrain>();
        return cameraGo.GetComponent<Camera>();
    }

    public static void SetIconGray(Image img, bool gray)
    {
        if (img == null) return;

        Material mat = img.material;
        if (mat == null) return;

        if (mat.HasProperty("_NeedGray"))
            mat.SetFloat("_NeedGray", gray ? 1 : 0);
    }

    public static int GetCurLevelExp()
    {
        return BattleMgr.Instance.CurExp;
    }

    public static int GetCurLevelParnterExp()
    {
        return BattleMgr.Instance.CurParnterExp;
    }

    public static int GetCurLevelGold()
    {
        return BattleMgr.Instance.CurGold;
    }

    public static int GetCurLevelCruise()
    {
        return BattleMgr.Instance.CurCruise;
    }

    public static int GetCurLevelZeny()
    {
        return BattleMgr.Instance.CurZeny;
    }

    public static int GetCurLevelEvil()
    {
        return BattleMgr.Instance.CurEvil;
    }

    public static string GetCurLevelName()
    {
        if (null == BattleMgr.Instance.Battle)
            return string.Empty;
        if (null == BattleMgr.Instance.Battle.CurLevelItem)
            return string.Empty;
        return BattleMgr.Instance.Battle.CurLevelItem.Name;
    }


    public static int GetCurLevelChallengeLv()
    {
        return BattleMgr.Instance.ChallengeLevel;
    }

    public static void SetRewardDropPos(Vector3 pos)
    {
        BattleMgr.s_reward_pos = pos;
        BattleMgr.s_reward_pos.z = 0;
    }

    public static List<Vector3> GetFightersPos()
    {
        return BattleMgr.Instance.GetFightersPos();
    }

    public static void GenerateDropItems(Vector3 startPos, bool createGold, Vector3 toGoldPos, bool createExp, Vector3 toExpPos, bool createPartnerExp, Vector3 toPartnerExpPos, bool createJobExp, Vector3 toJobExpPos, float goldRange, float expRange, params string[] itemIcons)
    {
        BattleDropMgr.Instance.GenerateDropItems(startPos, createGold, toGoldPos, createExp, toExpPos, createPartnerExp, toPartnerExpPos, createJobExp, toJobExpPos, itemIcons, goldRange, expRange);
    }

    public static string GetLevelName(int levelId)
    {
        Dictionary<string, string> cfg = ConfigMgr.Instance.getLine(levelId, Config.LevelCfgName);
        if (cfg != null)
            return cfg["Name"];
        return "";
    }

    public static void BeginVersus()
    {
        BattleMgr.Instance.BeginVersus();
    }

    public static void SetVersusActors(ActorData[] teamActors, ActorData[] enemyActors, float maxBattlingTime)
    {
        BattleMgr.Instance.SetVersusActors(teamActors, enemyActors, maxBattlingTime);
    }

    public static void AddActorToBattle(ActorData actor)
    {
        BattleMgr.Instance.AddActorToBossBattle(actor);
    }

    public static void SetActorDead(long actorId)
    {
        BattleMgr.Instance.SetActorDead(actorId);
    }

    public static void RemoveActorFromBattle(long actorId)
    {
        BattleMgr.Instance.RemoveActorFromBossBattle(actorId);
    }

    public static void SyncWorldBossLife(int life)
    {
        BattleMgr.Instance.SyncBossLife(life);
    }

    public static void ShowPreviewTeam()
    {
        BattleMgr.Instance.ShutDownCurrentBattle();
        PreviewTeamMgr.Instance.Show();
    }

    public static void HidePreviewTeam()
    {
        PreviewTeamMgr.Instance.Hide();
    }

    public static void ClearPreviewTeam()
    {
        if (PreviewTeamMgr.Instance.InPreview)
        {
            PreviewTeamMgr.Instance.Clean();
        }
    }

    public static void PlayEffect(int uid)
    {
        if (PreviewTeamMgr.Instance.InPreview)
        {
            PreviewTeamMgr.Instance.PlayEffect(uid);
        }
    }
    
    public static void StopEffect(int uid)
    {
        if (PreviewTeamMgr.Instance.InPreview)
        {
            PreviewTeamMgr.Instance.StopEffect(uid);
        }
    }
    
    public static void PlayAnimInDojo(int uid,string animName)
    {
        if (PreviewTeamMgr.Instance.InPreview)
        {
            PreviewTeamMgr.Instance.PlayAnim(uid,animName);
        }
    }

    public static void SetBattleFlag(int uid, bool inBattle)
    {
        if (PreviewTeamMgr.Instance.InPreview)
        {
            PreviewTeamMgr.Instance.SetBattleFlag(uid, inBattle);
        }
    }

    public static bool InSeason(string seasonStartTime,string seasonEndTime)
    {
        return DateTimeUtil.ContainTime(seasonStartTime, seasonEndTime, (long)(TimerManager.Instance.serverTime * 0.001f));
    }


    public static int CalcLeftTime(string endTimeStr)
    {
        return DateTimeUtil.CaclLeftTime((long)(TimerManager.Instance.serverTime * 0.001f), endTimeStr);
    }

    public static int CaclLeftTimeWitTimeStamp(string endTimeStr)
    {
        return DateTimeUtil.CaclLeftTimeWitTimeStamp(TimerManager.Instance.serverTime, endTimeStr);
    }

    public static void TweemFillAmount(GameObject go,float to, float time)
    {
        TweenFillAmount.Begin(go, time ,to);
    }

    public static void SetTweenFillAmount(GameObject go,bool enabled)
    {
        TweenFillAmount tween = go.GetComponent<TweenFillAmount>();
        if(tween != null)
        {
            tween.enabled = false;
        }
    }

    public static void BeginTweenPosition(GameObject go, Vector3 to)
    {
        TweenPosition.Begin(go, 0, to);
    }

    public static void BeginTweenPosition(GameObject go,float duration,Vector3 to,bool worldSpace)
    {
        TweenPosition.Begin(go, duration,to,worldSpace);
    }

    public static void BeginTweenRecTransformPos(GameObject go, float duration, Vector3 to)
    {
        TweenRectTransformPosition.Begin(go, duration, to);
    }

    public static void AddCollider(GameObject go,Vector3 size,Vector3 center)
    {
        if (go == null) return;

        BoxCollider collider = go.AddComponent<BoxCollider>();
        collider.size = size;
        collider.center = center;
    }

    public static CapsuleCollider AddCapsuleCollider(GameObject go, float size, Vector3 center)
    {
        if (go == null) return null;

        CapsuleCollider collider = go.AddComponent<CapsuleCollider>();
        collider.height = 2.5f;
        collider.center = center;
        return collider;
    }

    public static void SetCreateRoleLuaTable(LuaTable luaTbl)
    {
        CreateRoleMgr.Instance.SetLuaTable(luaTbl);
    }

    public static void ClearCreateRole()
    {
        CreateRoleMgr.Instance.Clear();
    }

    public static void PlayCamAnim(string animName,bool forward)
    {
        CreateRoleMgr.Instance.PlayAnim(animName, forward);
    }

    public static bool IsPlayCamAnimEnd(string animName)
    {
        return CreateRoleMgr.Instance.IsPlayAnimEnd(animName);
    }

    public static void ShowCreateRoleCam()
    {
        CreateRoleMgr.Instance.EnableCam();
    }

    public static void OpenDof()
    {
        CreateRoleMgr.Instance.OpenDof();
    }

    public static void CloseDof()
    {
        CreateRoleMgr.Instance.CloseDof();
    }

    public static void PlayCreateRoleTransferEffect()
    {
        CreateRoleMgr.Instance.PlayTransferEffect();
    }

    public static void CurStoryOver(int storyId)
    {
        EventMgr.DispatchEvent<int>(new CoreEvent<int>(ECoreEventType.EID_Dialogue_Finished, storyId));
    }

    public static void SetGameObjectLayerFrom(GameObject go,string fromLayer,string toLayer)
    {
        CommonUtil.SetGameObjectLayerFrom(go, fromLayer, toLayer);
    }

    public static void EnableBattleCam()
    {
        BattleCamera.Instance.EnableBattleCam();
    }

    public static void RefreshMinimap(Vector3 center, int mapSizeX,int mapSizeZ,int miniMapSizeX,int miniMapSizeZ, GameObject hero,params RectTransform[] goes)
    {
        if(goes!=null)
        {
            BattleMgr.Instance.RefreshMinimap(center, mapSizeX, mapSizeZ, miniMapSizeX, miniMapSizeZ, hero, goes);
        }
    }

    public static float GetOriFighterRotate(int cfgId, int teamId)
    {
        float oriAngle = 0;
        if (BattleMgr.Instance.Battle == null) return oriAngle;

        Fighter f = BattleMgr.Instance.Battle.FighterMgr.GetFighterByBaseId(cfgId, (eTeamType)teamId);
        if (f != null)
        {
            oriAngle = f.EulerAngle.y;
        }

        return oriAngle;
    }

    public static void DoFighterRotate(int cfgId,int teamId,float angle)
    {
        if (BattleMgr.Instance.Battle == null) return;
       
        Fighter f = BattleMgr.Instance.Battle.FighterMgr.GetFighterByBaseId(cfgId, (eTeamType)teamId);
        if(f!=null)
        {
            f.SetRotation(Quaternion.Euler(0, angle, 0));
        }
    }

    public static void DoFighterPlayAnimation(int cfgId,int teamId,string animName)
    {
        if (BattleMgr.Instance.Battle == null || string.IsNullOrEmpty(animName)) return;

        Fighter f = BattleMgr.Instance.Battle.FighterMgr.GetFighterByBaseId(cfgId, (eTeamType)teamId);
        if(f!=null)
        {
            f.Ctrl.Animator.Play(animName);
        }
    }

    public static void DoFighterPlayEffect(int cfgId,int teamId,int effectId)
    {
        if (BattleMgr.Instance.Battle == null || effectId == 0) return;

        Fighter f = BattleMgr.Instance.Battle.FighterMgr.GetFighterByBaseId(cfgId, (eTeamType)teamId);
        if (f != null)
        {
            EffectManager.Instance.PlayEffect(effectId, f, f);
        }
    }

    public static void PlayTweenAlpha(GameObject target, float delay = 0, float duration = 1)
    {
        if (null == target)
            return;
        TweenAlpha alpha = target.GetComponent<TweenAlpha>();
        if (null != alpha)
        {
            alpha.enabled = true;
            alpha.delay = delay;
            alpha.duration = duration;
            alpha.ResetToBeginning();
        }
        else
            Debug.LogWarningFormat("{0}上没有挂载TweenAlpha脚本", target.name);
    }

    public static void SkipNewbieBattle()
    {
        BattleMgr.Instance.OnBattleEnd(2);
    }

    public static void CloseBgm()
    {
        MusicMgr.Instance.CleanBGMusic();
    }

    public static float GetLeftFightingTime()
    {
        return BattleMgr.Instance.GetLeftFightingTime();
    }

    public static  List<string> GetBattleLog()
    {
        if (BattleMgr.Instance.Battle == null) return null;

        return BattleMgr.Instance.Battle.BattleOut.OutputList;
    }

    public static string GetBattleRecord(long timeStamp)
    {
        return BattleMgr.Instance.PopBattleRecord(timeStamp);
    }

    public static BattleStatistics GetBattleStatistics(BattleMode mode, BattleSubMode subMode)
    {
        return BattleMgr.Instance.GetBattleStatistics(mode,subMode);
    }

    public static bool HasStatistics(BattleMode mode, BattleSubMode subMode)
    {
        return BattleMgr.Instance.HasBattleStatistics(mode,subMode);
    }

    public static BattleMode CurrentBattleMode()
    {
        return BattleMgr.Instance.Battle!=null? BattleMgr.Instance.Battle.Mode:BattleMode.None;
    }

    public static BattleSubMode CurrentBattleSubMode()
    {
        return BattleMgr.Instance.Battle != null ? BattleMgr.Instance.Battle.SubBattleMode : BattleSubMode.None;
    }

    public static bool CurrentBattleIsPlayRecord()
    {
        return BattleMgr.Instance.Battle != null ? BattleMgr.Instance.Battle.IsPlayRecord : false;
    }    

    public static void LoadPreviewActors(ActorData[] actors,LuaTable lbl)
    {
        AvatarRTMgr.Instance.LoadPreviewActors(actors,lbl);
    }

    public static string GetTestBattleRecorder()
    {
#if UNITY_EDITOR
        TextAsset ta = UnityEditor.AssetDatabase.LoadAssetAtPath<TextAsset>("Assets/Content/Test/records.txt");
        if (ta == null) return "";

        return ta.text;
#else
        return "";
#endif
    }

    public static List<ActorData> GetBattleTeamActors()
    {
        if (BattleMgr.Instance.Battle == null) return null;

        return BattleMgr.Instance.Battle.TeamActors;
    }

    public static List<ActorData> GetBattleEnemyActors()
    {
        if (BattleMgr.Instance.Battle == null) return null;

        return BattleMgr.Instance.Battle.EnemyActors;
    }

    public static List<ActorData> GetBattleTeamPlayerActors()
    {
        if (BattleMgr.Instance.Battle == null) return null;

        return BattleMgr.Instance.Battle.TeamPlayerActors;
    }

    public static List<ActorData> GetBattleEnemyPlayerActors()
    {
        if (BattleMgr.Instance.Battle == null) return null;

        return BattleMgr.Instance.Battle.EnemyPlayerActors;
    }

    public static ActorData GetFighterActorDataByUid(long uid, int teamSide)
    {
        if (BattleMgr.Instance.Battle == null) return null;

        var f = BattleMgr.Instance.Battle.FighterMgr.GetFighterByID(uid, (eTeamType)teamSide);
        if(f != null)
        {
            return f.Actor;
        }

        return null;
    }

    public static float GetFightingTime()
    {
        return BattleMgr.Instance.FightingTime;
    }

    public static bool ActorInFighting(long uid)
    {
        if (BattleMgr.Instance.Battle == null) return false;


        var f = BattleMgr.Instance.Battle.FighterMgr.GetFighterByID(uid, eTeamType.Friend);
        if (f != null)
        {
            return true;
        }

        return false;
    }
}
