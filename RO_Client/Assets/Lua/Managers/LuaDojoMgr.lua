local LuaDojoMgr = class("LuaDojoMgr")

function LuaDojoMgr:ctor()
    self.battleSubMode = BattleSubMode.None
    self:RegisterNetEvents();
end

function LuaDojoMgr:Destroy()
    if tolua.getpeer(self) ~= nil then
        tolua.setpeer(self, nil)
    end
end

function LuaDojoMgr:RegisterNetEvents()
    ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.EID_SHUT_PVPCIMBINGBATTLE, self, self.PvpClimbingShutBattle)
end

function LuaDojoMgr:UnRegisterNetEvents()
    ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.EID_SHUT_PVPCIMBINGBATTLE, self, self.PvpClimbingShutBattle)
end

function LuaDojoMgr:Enter(mode)
    if mode == nil then
        LogError("请设置VersusBattle的战斗类型")
        return
    end
    self.battleSubMode = mode
    ManagerContainer.LuaGameMgr:SetGameSpeed(ManagerContainer.LuaGameMgr.GameSpeed)
    if self.battleSubMode == BattleSubMode.Voyage then
        ManagerContainer.LuaEventMgr:RegisterEvent(UIEventNames.DOJO_CHALLENGE_RESULT_CHANGED, self, self.OnChallengeResultChanged)
    end
end

function LuaDojoMgr:Exit()
    if self.battleSubMode == BattleSubMode.Voyage then
        ManagerContainer.LuaEventMgr:UnregisterEvent(UIEventNames.DOJO_CHALLENGE_RESULT_CHANGED, self, self.OnChallengeResultChanged)
    end
end

function LuaDojoMgr:OnChallengeResultChanged()
    if self.battleSubMode == BattleSubMode.Voyage then
        local win = ManagerContainer.DataMgr.VoyageDataMgr:GetLastBattleWin()
        local scores = ManagerContainer.DataMgr.VoyageDataMgr:GetLastBattleScores()
        local rewards = ManagerContainer.DataMgr.VoyageDataMgr:GetLastBattleRewards()
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIBattleResult, {win, scores, rewards, 'VoyageResultTips', self.ShowDojoExit, self})
    end
end

function LuaDojoMgr:OnStartingFight()
    local data = {}
    data[1] = BattleMode.Versus
    data[2] = self.battleSubMode
    if self.battleSubMode == BattleSubMode.Arena then
        data[3] = ManagerContainer.DataMgr.ArenaData:GetMatchFighterName()
        data[4] = ManagerContainer.DataMgr.ArenaData:GetOurMembers()
        data[5] = ManagerContainer.DataMgr.ArenaData:GetEnemyMembers()
    elseif self.battleSubMode == BattleSubMode.PvPClimbinglower then
        data[3] = ManagerContainer.DataMgr.PeakTowerDataMgr:GetMatchFighterName()
        data[4] = ManagerContainer.DataMgr.PeakTowerDataMgr:GetOurMembers()
        data[5] = ManagerContainer.DataMgr.PeakTowerDataMgr:GetEnemyMembers()
        data[6] = true
        data[7] = ManagerContainer.DataMgr.PeakTowerDataMgr:GetLimitedTime()
    elseif self.battleSubMode == BattleSubMode.HundredDojo then
        data[3] = ManagerContainer.DataMgr.HundredDojoDataMgr:GetMatchFighterName()
        data[4] = ManagerContainer.DataMgr.HundredDojoDataMgr:GetOurMembers()
        data[5] = ManagerContainer.DataMgr.HundredDojoDataMgr:GetEnemyMembers()
        data[6] = true
        data[7] = ManagerContainer.DataMgr.HundredDojoDataMgr:GetLimitedTime()
    elseif self.battleSubMode == BattleSubMode.Voyage then
        data[3] = ManagerContainer.DataMgr.VoyageDataMgr:GetMatchFighterName()
        data[4] = ManagerContainer.DataMgr.VoyageDataMgr:GetOurMembers()
        data[5] = ManagerContainer.DataMgr.VoyageDataMgr:GetEnemyMembers()
        data[6] = true
        data[7] = ManagerContainer.DataMgr.VoyageDataMgr:GetLimitedTime()
    elseif self.battleSubMode == BattleSubMode.GvG then
        local guildWarDataMgr = ManagerContainer.DataMgr.GuildWarDataMgr
        if guildWarDataMgr then
            data[3] = guildWarDataMgr:GetMatchFighterName()
            data[4] = guildWarDataMgr:GetOurMembers()
            data[5] = guildWarDataMgr:GetEnemyMembers()
            data[6] = true
            data[7] = guildWarDataMgr:GetLimitedTime()
        else
            data[6] = true
            data[7] = 0
        end
        ManagerContainer.DataMgr.GuildWarDataMgr:StartStayBatting()
    end
    ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIDojoBattle, data)
end

function LuaDojoMgr:OnBattleWin()
    ManagerContainer.LuaGameMgr:SetGameSpeed(1)
    if self.battleSubMode == BattleSubMode.Arena then
        ManagerContainer.DataMgr.ArenaData:BattleEnd(1)
    elseif self.battleSubMode == BattleSubMode.HundredDojo then
        ManagerContainer.DataMgr.HundredDojoDataMgr:BattleEnd(1)
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIBattleSimpleResult, {1, self.ShowDojoExit, self})
    elseif self.battleSubMode == BattleSubMode.Voyage then
        ManagerContainer.DataMgr.VoyageDataMgr:BattleEnd(1)
    elseif self.battleSubMode == BattleSubMode.GvG then
        ManagerContainer.DataMgr.GuildWarDataMgr:BattleEnd(1)
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIBattleSimpleResult, {1, self.ShowDojoExit, self})
    elseif self.battleSubMode == BattleSubMode.PvPClimbinglower then
        ManagerContainer.DataMgr.PeakTowerDataMgr:BattleEnd(1)
    end
end

function LuaDojoMgr:OnBattleFailed()
    ManagerContainer.LuaGameMgr:SetGameSpeed(1)
    if self.battleSubMode == BattleSubMode.Arena then
        ManagerContainer.DataMgr.ArenaData:BattleEnd(0)
    elseif self.battleSubMode == BattleSubMode.HundredDojo then
        ManagerContainer.DataMgr.HundredDojoDataMgr:BattleEnd(0)
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIBattleSimpleResult, {0, self.ShowDojoExit, self})
    elseif self.battleSubMode == BattleSubMode.Voyage then
        ManagerContainer.DataMgr.VoyageDataMgr:BattleEnd(0)
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIBattleResult, {0, nil, nil, 'VoyageResultTips', self.ShowDojoExit, self})
    elseif self.battleSubMode == BattleSubMode.GvG then
        ManagerContainer.DataMgr.GuildWarDataMgr:BattleEnd(0)
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIBattleSimpleResult, {0, self.ShowDojoExit, self})
    elseif self.battleSubMode == BattleSubMode.PvPClimbinglower then
        --ManagerContainer.DataMgr.PeakTowerDataMgr:BattleEnd(0)
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIClimbingTowerBattleFailed,Enum.UIPageName.UIClimbingTower)
    end
end

function LuaDojoMgr:OnBattleEnd()
    ManagerContainer.LuaGameMgr:SetGameSpeed(1)
end

--关闭结算界面
function LuaDojoMgr:CloseBattlePage()
    ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UIDojoBattle)
    ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UIBattleStatistics)
    if self.battleSubMode == BattleSubMode.Arena then
        ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UIDojoBattleFail)
        ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UIDojoBattleWin)
    elseif self.battleSubMode == BattleSubMode.HundredDojo then
        ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UIBattleSimpleResult)
    elseif self.battleSubMode == BattleSubMode.Voyage then
        ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UIBattleResult)
    elseif self.battleSubMode == BattleSubMode.GvG then
        ManagerContainer.LuaUIMgr:ClosePage(Enum.UIPageName.UIBattleSimpleResult)
    end
end

function LuaDojoMgr:ShowDojoExit()
    ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIDojoExit)
end

function LuaDojoMgr:BackDojoMain()
    self:CloseBattlePage();
    if self.battleSubMode == BattleSubMode.Arena then
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIDojo2D, nil, Enum.UIPageName.UIMainCity1)
    elseif self.battleSubMode == BattleSubMode.HundredDojo then
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIHundredDojo, nil, Enum.UIPageName.UIMainCity1)
    elseif self.battleSubMode == BattleSubMode.Voyage then
        ManagerContainer.LuaUIMgr:Open(Enum.UIPageName.UIVoyage, nil, Enum.UIPageName.UIMainCity1)
    elseif self.battleSubMode == BattleSubMode.GvG then
        local data = require('ExecuteSequenceData'):new()
        data:AppendUIListener(Enum.UIPageName.UIMain, UIEventNames.UI_FILLCONTENT_COMPELETED, 5)
        data:AppendFuncAfterListener(false, ManagerContainer.LuaUIMgr, ManagerContainer.LuaUIMgr.Open, Enum.UIPageName.UIMain)
        data:AppendUIListener(Enum.UIPageName.UIMainCity1, UIEventNames.UI_FILLCONTENT_COMPELETED, 5)
        data:AppendUIViewFuncAfterListener(false, Enum.UIPageName.UIMain, 'ChangePageMsg', Enum.MainViewPageType.Town)
        data:AppendFunc(false, nil, function (sequenceData)
            if ManagerContainer.DataMgr.GuildWarDataMgr:GetOpenState() then
                sequenceData:AppendUIListener(Enum.UIPageName.UIGuildWarMatchMap, UIEventNames.UI_PAGE_IN_END_NTF, 5)
                sequenceData:AppendFuncAfterListener(false, ManagerContainer.LuaUIMgr, ManagerContainer.LuaUIMgr.Open, Enum.UIPageName.UIGuildWarMatchMap)
                sequenceData:AppendFunc(false, nil, function (sequenceData1)
                    if ManagerContainer.DataMgr.GuildWarDataMgr:GetOpenState() then
                        local attackBattleIdx = ManagerContainer.DataMgr.GuildWarDataMgr:GetLastAttackBattleIdx()
                        if attackBattleIdx then
                            sequenceData1:AppendUIListener(Enum.UIPageName.UIGuildWar, UIEventNames.UI_PAGE_IN_END_NTF, 5)
                            sequenceData1:AppendFuncAfterListener(false, ManagerContainer.LuaUIMgr, ManagerContainer.LuaUIMgr.Open, Enum.UIPageName.UIGuildWar,attackBattleIdx)
                        end
                    end
                end, sequenceData)
            end
        end, data)
        ManagerContainer.ExecuteSequenceMgr:Execute(data)
    end
    self:ShutBattle()
end

function LuaDojoMgr:ShutBattle()
    ManagerContainer.LuaGameMgr:ShutDownBattle()
    ManagerContainer.FSMMgr:ChangeState(Enum.StateEnum.IdleState.stateId)
end

function LuaDojoMgr:PvpClimbingShutBattle(openPageId,param)
    self:CloseBattlePage()
    if self.battleSubMode == BattleSubMode.PvPClimbinglower then
        self:ShutBattle()
        if openPageId ~= nil and openPageId > 0 then
            ManagerContainer.LuaUIMgr:Open(openPageId,param, Enum.UIPageName.UIMainCity1)
        end
        LuaBattleBridge.CloseBgm()
    end    
end

-- 显示战场结束转场
function LuaDojoMgr:ShowBattleEndInterlude()
end

--pvp压制特效
function LuaDojoMgr:OnShowPvpPressPoint()    
    if self.chatHideTimer then
		ManagerContainer.LuaTimerMgr:RemoveTimer(chatHideTimer)
		self.chatHideTimer = nil
	end
    ManagerContainer.LuaTimerMgr:AddTimer(2000, 1,self,self.OnHidePvpPressPointTimer,nil);
end

function LuaDojoMgr:OnHidePvpPressPointTimer()
    self.chatHideTimer = ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_SHOW_PVP_PRESSPOINT,true);
end

function LuaDojoMgr:OnShowBossBuff(teamSide,actorId,isBoss,buffIcon,num)
    if isBoss then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_Boss_Buff,buffIcon,num)
    else
        if teamSide == 0 then   --我方
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_Player_Buff,actorId, buffIcon,num)
        end
    end
end

function LuaDojoMgr:OnRemoveBossBuff(teamSide,actorId,isBoss,buffIcon)
    if isBoss then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_Boss_Remove_Buff,buffIcon)
    else
        if teamSide == 0 then   --我方
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Remove_Player_Buff, actorId, buffIcon)
        end
    end
end

function LuaDojoMgr:OnLoadBegin()
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Loading_Begin);
end

function LuaDojoMgr:OnLoadProgress(progress)
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Loading_Progress,progress);
end

function LuaDojoMgr:OnLoadComplete()
    LogWarning("LuaDojoMgr:OnLoadComplete ")
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Loading_Complete);
end

function LuaDojoMgr:OnFighterLifeChanged(isBoss,actorId,life,maxLife,teamSide)
    if isBoss then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_Boss_Life,life,maxLife)
    else
        if teamSide == 0 then
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_Fighter_Life,actorId,life,maxLife)
        else
            ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_Enemy_Fighter_Life,actorId,life,maxLife)
        end
    end
end

function LuaDojoMgr:OnFighterEnergyChanged(actorId,sp,maxSp,teamSide)
    if teamSide == 0 then
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_Fighter_Sp,actorId,sp,maxSp)
    else
        ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_Enemy_Fighter_Sp,actorId,sp,maxSp)
    end
end

function LuaDojoMgr:OnFighterCastSkill(skillParam)
end


function LuaDojoMgr:RefreshStatistics()
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_Refresh_BattleStatistics)
end

function LuaDojoMgr:OnFightingStart()
    ManagerContainer.LuaEventMgr:Dispatch(UIEventNames.EID_FIGHTING_START)
end

return LuaDojoMgr;