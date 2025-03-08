local LuaTimeBattleMgr = class("LuaTimeBattleMgr")

function LuaTimeBattleMgr:ctor()
    self.timeBattleMode = BattleSubMode.None
    self.isLoading = false
    self.isBattleEnd = false
    self.curBattlePageId = 0
    self.curBattleLoadedTime = 0
    self:RegisterNetEvents();
end

function LuaTimeBattleMgr:Destroy()
    self:UnRegisterNetEvents();
    if tolua.getpeer(self) ~= nil then
		    tolua.setpeer(self, nil)
    end
end

function LuaTimeBattleMgr:RegisterNetEvents()
    ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.EID_SHUT_TIMEBATTLE, self, self.ShutBattle)
end

function LuaTimeBattleMgr:UnRegisterNetEvents()
    ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.EID_SHUT_TIMEBATTLE, self, self.ShutBattle)
end

function LuaTimeBattleMgr:Enter(mode)
    if mode == nil then
        LogError("请设置TimeBattle的战斗类型")
        return
    end

    self.isBattleEnd = false

    self.timeBattleMode = mode
    local GuildExParam = nil
    if self.timeBattleMode == BattleSubMode.Resource then
        self.curBattlePageId = Enum.UIPageName.UISkillExpBattleBattle
    elseif self.timeBattleMode == BattleSubMode.Guild then
        self.curBattlePageId = Enum.UIPageName.UIGuildHuntBattle
    elseif self.timeBattleMode == BattleSubMode.GuildEx then
        self.curBattlePageId = Enum.UIPageName.UIGuildHuntBattle
        GuildExParam = true
    elseif self.timeBattleMode == BattleSubMode.ClimbingTower then
        self.curBattlePageId = Enum.UIPageName.UIClimbingTowerBattle
    elseif self.timeBattleMode == BattleSubMode.Expedition then
        self.curBattlePageId = Enum.UIPageName.UIExpeditionBattle
    end
    ManagerContainer.LuaUIMgr:Open(self.curBattlePageId,GuildExParam)

    ManagerContainer.LuaGameMgr:SetGameSpeed(ManagerContainer.LuaGameMgr.GameSpeed)
end

function LuaTimeBattleMgr:Exit()
    self.timeBattleMode = BattleSubMode.None
    self.isBattleEnd = true
    self.curBattlePageId = 0
    self.curBattleLoadedTime = 0
end

function LuaTimeBattleMgr:OnFightingStart()
    self.curBattleLoadedTime = Time.realtimeSinceStartup - ManagerContainer.DataMgr.TowerDataMgr.curEnterBattleTime
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_FIGHTING_START)
end

function LuaTimeBattleMgr:OnBattleFailed(battleTime,fighterParams,bossLife,bossSp)
    ManagerContainer.LuaGameMgr:SetGameSpeed(1)
    ManagerContainer.LuaUIMgr:ClosePage(self.curBattlePageId)

    if self.timeBattleMode == BattleSubMode.Resource then
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIClimbingTowerBattleFailed,Enum.UIPageName.UISkillExpBattle)
    elseif self.timeBattleMode == BattleSubMode.Guild then
    elseif self.timeBattleMode == BattleSubMode.GuildEx then
    elseif self.timeBattleMode == BattleSubMode.ClimbingTower then
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIClimbingTowerBattleFailed,Enum.UIPageName.UIClimbingTower)
    elseif self.timeBattleMode == BattleSubMode.Expedition then
        ManagerContainer.DataMgr.ExpeditionDataMgr:BattleEnd(battleTime,fighterParams,bossLife,bossSp)
    end
end

function LuaTimeBattleMgr:OnForceBattleFailed()
    ManagerContainer.LuaGameMgr:SetGameSpeed(1)
    ManagerContainer.LuaUIMgr:ClosePage(self.curBattlePageId)

    if self.timeBattleMode == BattleSubMode.ClimbingTower then
        self:ShutBattle(Enum.UIPageName.UIClimbingTower)
    end
end

function LuaTimeBattleMgr:OnBattleWin(battleTime,isPlayRecord,timeStamp,fighterParams)
    ManagerContainer.LuaUIMgr:ClosePage(self.curBattlePageId)
    ManagerContainer.LuaGameMgr:SetGameSpeed(1)
    
    if self.timeBattleMode == BattleSubMode.Resource then
    elseif self.timeBattleMode == BattleSubMode.Guild then
    elseif self.timeBattleMode == BattleSubMode.GuildEx then
    elseif self.timeBattleMode == BattleSubMode.ClimbingTower then
        ManagerContainer.DataMgr.TowerDataMgr:BattleEnd(battleTime,isPlayRecord,timeStamp)
    elseif self.timeBattleMode  == BattleSubMode.Expedition then
        ManagerContainer.DataMgr.ExpeditionDataMgr:BattleEnd(battleTime,fighterParams,0,0)
    end
    
end

function LuaTimeBattleMgr:OnBattleEnd(isPlayRecord)
    ManagerContainer.LuaGameMgr:SetGameSpeed(1)
    if self.isBattleEnd then return end
    self.isBattleEnd = true
    if self.timeBattleMode == BattleSubMode.Guild then
        ManagerContainer.DataMgr.GuildDataMgr:StopGuildHuntBattle(isPlayRecord, LuaBattleBridge.GetFightingTime())
    elseif self.timeBattleMode == BattleSubMode.GuildEx then
        ManagerContainer.DataMgr.GuildDemonData:StopGuildDemonBattle(isPlayRecord, LuaBattleBridge.GetFightingTime())
    end
end

function LuaTimeBattleMgr:OnReplayEnd()
    ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIDojoExit,true)
end

function LuaTimeBattleMgr:ShutBattle(openPageId,param)
    ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UIBattleStatistics)
    ManagerContainer.LuaGameMgr:ShutDownBattle()
    ManagerContainer.FSMMgr:ChangeState(Enum.StateEnum.IdleState.stateId)
    if openPageId ~= nil and openPageId > 0 then
        ManagerContainer.LuaUIMgr:Open(openPageId,param, Enum.UIPageName.UIMainCity1)
    end
    LuaBattleBridge.CloseBgm()
end

function LuaTimeBattleMgr:OnFighterHurt(hurtValue)
    if self.timeBattleMode == BattleSubMode.Guild then
        ManagerContainer.DataMgr.GuildDataMgr:RecordHurtValueChanged(hurtValue)
    elseif self.timeBattleMode == BattleSubMode.GuildEx then
        ManagerContainer.DataMgr.GuildDemonData:RecordDemonValueChanged(hurtValue)
    end
end

function LuaTimeBattleMgr:OnFighterLifeChanged(isBoss,actorId,life,maxLife,sp,maxSp)
    if isBoss then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_Boss_Life,life,maxLife)
        if self.timeBattleMode == BattleSubMode.Expedition then
            ManagerContainer.DataMgr.ExpeditionDataMgr:SyncBossLife(life)
        end
    else
        if self.timeBattleMode  == BattleSubMode.Expedition then
            ManagerContainer.DataMgr.ExpeditionDataMgr:SyncHeroLifeAndSp(actorId,life,maxLife,sp,maxSp)
        end
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_Fighter_Life,actorId,life,maxLife)
    end
end

function LuaTimeBattleMgr:OnFighterEnergyChanged(isBoss,actorId,life,maxLife,sp,maxSp)
    if isBoss then
        if self.timeBattleMode == BattleSubMode.Expedition then
            ManagerContainer.DataMgr.ExpeditionDataMgr:SyncBossSP(sp)
        end
    else
        if self.timeBattleMode  == BattleSubMode.Expedition then
            ManagerContainer.DataMgr.ExpeditionDataMgr:SyncHeroLifeAndSp(actorId,life,maxLife,sp,maxSp)
        end
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_Fighter_Sp,actorId,sp,maxSp)
    end
end

function LuaTimeBattleMgr:OnFighterCastSkill(skillParam)
    if skillParam.isBoss then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_Boss_Skill,skillParam)
    else
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_Cast_Skill,skillParam)
    end
end

function LuaTimeBattleMgr:GetLeftFightingTime()
    return LuaBattleBridge.GetLeftFightingTime()
end

function LuaTimeBattleMgr:RefreshStatistics()
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_BattleStatistics)
end

function LuaTimeBattleMgr:OnShowBossBuff(teamSide,actorId,isBoss,buffIcon,num)
    if isBoss then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_Boss_Buff,buffIcon,num)
    else
        if teamSide == 0 then   --我方
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_Player_Buff,actorId, buffIcon,num)
        end
    end
end

function LuaTimeBattleMgr:OnRemoveBossBuff(teamSide,actorId,isBoss,buffIcon)
    if isBoss then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_Boss_Remove_Buff,buffIcon)
    else
        if teamSide == 0 then   --我方
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Remove_Player_Buff, actorId, buffIcon)
        end
    end
end

--开始进行加载
function LuaTimeBattleMgr:OnLoadBegin()
    LogWarning("LuaTimeBattleMgr:OnLoadBegin ")
    self.isLoading = true
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Loading_Begin);
end

--加载进度的刷新
function LuaTimeBattleMgr:OnLoadProgress(progress)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Loading_Progress,progress);
end

--加载完成
function LuaTimeBattleMgr:OnLoadComplete()
    LogWarning("LuaTimeBattleMgr:OnLoadComplete ")

    self.isLoading = false
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Loading_Complete);
end

return LuaTimeBattleMgr